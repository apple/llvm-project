//===-- lldb-gdbserver.cpp --------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef _WIN32
#include <signal.h>
#include <unistd.h>
#endif

#include "Acceptor.h"
#include "LLDBServerUtilities.h"
#include "Plugins/Process/gdb-remote/GDBRemoteCommunicationServerLLGS.h"
#include "Plugins/Process/gdb-remote/ProcessGDBRemoteLog.h"
#include "lldb/Host/Config.h"
#include "lldb/Host/ConnectionFileDescriptor.h"
#include "lldb/Host/FileSystem.h"
#include "lldb/Host/Pipe.h"
#include "lldb/Host/Socket.h"
#include "lldb/Host/StringConvert.h"
#include "lldb/Host/common/NativeProcessProtocol.h"
#include "lldb/Target/Process.h"
#include "lldb/Utility/Status.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Option/ArgList.h"
#include "llvm/Option/OptTable.h"
#include "llvm/Option/Option.h"
#include "llvm/Support/Errno.h"
#include "llvm/Support/WithColor.h"

#if defined(__linux__)
#include "Plugins/Process/Linux/NativeProcessLinux.h"
#elif defined(__FreeBSD__)
#include "Plugins/Process/FreeBSDRemote/NativeProcessFreeBSD.h"
#elif defined(__NetBSD__)
#include "Plugins/Process/NetBSD/NativeProcessNetBSD.h"
#elif defined(_WIN32)
#include "Plugins/Process/Windows/Common/NativeProcessWindows.h"
#endif

#ifndef LLGS_PROGRAM_NAME
#define LLGS_PROGRAM_NAME "lldb-server"
#endif

#ifndef LLGS_VERSION_STR
#define LLGS_VERSION_STR "local_build"
#endif

using namespace llvm;
using namespace lldb;
using namespace lldb_private;
using namespace lldb_private::lldb_server;
using namespace lldb_private::process_gdb_remote;

namespace {
#if defined(__linux__)
typedef process_linux::NativeProcessLinux::Factory NativeProcessFactory;
#elif defined(__FreeBSD__)
typedef process_freebsd::NativeProcessFreeBSD::Factory NativeProcessFactory;
#elif defined(__NetBSD__)
typedef process_netbsd::NativeProcessNetBSD::Factory NativeProcessFactory;
#elif defined(_WIN32)
typedef NativeProcessWindows::Factory NativeProcessFactory;
#else
// Dummy implementation to make sure the code compiles
class NativeProcessFactory : public NativeProcessProtocol::Factory {
public:
  llvm::Expected<std::unique_ptr<NativeProcessProtocol>>
  Launch(ProcessLaunchInfo &launch_info,
         NativeProcessProtocol::NativeDelegate &delegate,
         MainLoop &mainloop) const override {
    llvm_unreachable("Not implemented");
  }
  llvm::Expected<std::unique_ptr<NativeProcessProtocol>>
  Attach(lldb::pid_t pid, NativeProcessProtocol::NativeDelegate &delegate,
         MainLoop &mainloop) const override {
    llvm_unreachable("Not implemented");
  }
};
#endif
}

#ifndef _WIN32
// Watch for signals
static int g_sighup_received_count = 0;

static void sighup_handler(MainLoopBase &mainloop) {
  ++g_sighup_received_count;

  Log *log(GetLogIfAnyCategoriesSet(LIBLLDB_LOG_PROCESS));
  LLDB_LOGF(log, "lldb-server:%s swallowing SIGHUP (receive count=%d)",
            __FUNCTION__, g_sighup_received_count);

  if (g_sighup_received_count >= 2)
    mainloop.RequestTermination();
}
#endif // #ifndef _WIN32

void handle_attach_to_pid(GDBRemoteCommunicationServerLLGS &gdb_server,
                          lldb::pid_t pid) {
  Status error = gdb_server.AttachToProcess(pid);
  if (error.Fail()) {
    fprintf(stderr, "error: failed to attach to pid %" PRIu64 ": %s\n", pid,
            error.AsCString());
    exit(1);
  }
}

void handle_attach_to_process_name(GDBRemoteCommunicationServerLLGS &gdb_server,
                                   const std::string &process_name) {
  // FIXME implement.
}

void handle_attach(GDBRemoteCommunicationServerLLGS &gdb_server,
                   const std::string &attach_target) {
  assert(!attach_target.empty() && "attach_target cannot be empty");

  // First check if the attach_target is convertible to a long. If so, we'll use
  // it as a pid.
  char *end_p = nullptr;
  const long int pid = strtol(attach_target.c_str(), &end_p, 10);

  // We'll call it a match if the entire argument is consumed.
  if (end_p &&
      static_cast<size_t>(end_p - attach_target.c_str()) ==
          attach_target.size())
    handle_attach_to_pid(gdb_server, static_cast<lldb::pid_t>(pid));
  else
    handle_attach_to_process_name(gdb_server, attach_target);
}

void handle_launch(GDBRemoteCommunicationServerLLGS &gdb_server,
                   llvm::ArrayRef<llvm::StringRef> Arguments) {
  ProcessLaunchInfo info;
  info.GetFlags().Set(eLaunchFlagStopAtEntry | eLaunchFlagDebug |
                      eLaunchFlagDisableASLR);
  info.SetArguments(Args(Arguments), true);

  llvm::SmallString<64> cwd;
  if (std::error_code ec = llvm::sys::fs::current_path(cwd)) {
    llvm::errs() << "Error getting current directory: " << ec.message() << "\n";
    exit(1);
  }
  FileSpec cwd_spec(cwd);
  FileSystem::Instance().Resolve(cwd_spec);
  info.SetWorkingDirectory(cwd_spec);
  info.GetEnvironment() = Host::GetEnvironment();

  gdb_server.SetLaunchInfo(info);

  Status error = gdb_server.LaunchProcess();
  if (error.Fail()) {
    llvm::errs() << llvm::formatv("error: failed to launch '{0}': {1}\n",
                                  Arguments[0], error);
    exit(1);
  }
}

Status writeSocketIdToPipe(Pipe &port_pipe, const std::string &socket_id) {
  size_t bytes_written = 0;
  // Write the port number as a C string with the NULL terminator.
  return port_pipe.Write(socket_id.c_str(), socket_id.size() + 1,
                         bytes_written);
}

Status writeSocketIdToPipe(const char *const named_pipe_path,
                           const std::string &socket_id) {
  Pipe port_name_pipe;
  // Wait for 10 seconds for pipe to be opened.
  auto error = port_name_pipe.OpenAsWriterWithTimeout(named_pipe_path, false,
                                                      std::chrono::seconds{10});
  if (error.Fail())
    return error;
  return writeSocketIdToPipe(port_name_pipe, socket_id);
}

Status writeSocketIdToPipe(lldb::pipe_t unnamed_pipe,
                           const std::string &socket_id) {
  Pipe port_pipe{LLDB_INVALID_PIPE, unnamed_pipe};
  return writeSocketIdToPipe(port_pipe, socket_id);
}

void ConnectToRemote(MainLoop &mainloop,
                     GDBRemoteCommunicationServerLLGS &gdb_server,
                     bool reverse_connect, llvm::StringRef host_and_port,
                     const char *const progname, const char *const subcommand,
                     const char *const named_pipe_path, pipe_t unnamed_pipe,
                     int connection_fd) {
  Status error;

  std::unique_ptr<Connection> connection_up;
  if (connection_fd != -1) {
    // Build the connection string.
    char connection_url[512];
    snprintf(connection_url, sizeof(connection_url), "fd://%d", connection_fd);

    // Create the connection.
#if LLDB_ENABLE_POSIX && !defined _WIN32
    ::fcntl(connection_fd, F_SETFD, FD_CLOEXEC);
#endif
    connection_up.reset(new ConnectionFileDescriptor);
    auto connection_result = connection_up->Connect(connection_url, &error);
    if (connection_result != eConnectionStatusSuccess) {
      fprintf(stderr, "error: failed to connect to client at '%s' "
                      "(connection status: %d)\n",
              connection_url, static_cast<int>(connection_result));
      exit(-1);
    }
    if (error.Fail()) {
      fprintf(stderr, "error: failed to connect to client at '%s': %s\n",
              connection_url, error.AsCString());
      exit(-1);
    }
  } else if (!host_and_port.empty()) {
    // Parse out host and port.
    std::string final_host_and_port;
    std::string connection_host;
    std::string connection_port;
    uint32_t connection_portno = 0;

    // If host_and_port starts with ':', default the host to be "localhost" and
    // expect the remainder to be the port.
    if (host_and_port[0] == ':')
      final_host_and_port.append("localhost");
    final_host_and_port.append(host_and_port.str());

    // Note: use rfind, because the host/port may look like "[::1]:12345".
    const std::string::size_type colon_pos = final_host_and_port.rfind(':');
    if (colon_pos != std::string::npos) {
      connection_host = final_host_and_port.substr(0, colon_pos);
      connection_port = final_host_and_port.substr(colon_pos + 1);
      connection_portno = StringConvert::ToUInt32(connection_port.c_str(), 0);
    }


    if (reverse_connect) {
      // llgs will connect to the gdb-remote client.

      // Ensure we have a port number for the connection.
      if (connection_portno == 0) {
        fprintf(stderr, "error: port number must be specified on when using "
                        "reverse connect\n");
        exit(1);
      }

      // Build the connection string.
      char connection_url[512];
      snprintf(connection_url, sizeof(connection_url), "connect://%s",
               final_host_and_port.c_str());

      // Create the connection.
      connection_up.reset(new ConnectionFileDescriptor);
      auto connection_result = connection_up->Connect(connection_url, &error);
      if (connection_result != eConnectionStatusSuccess) {
        fprintf(stderr, "error: failed to connect to client at '%s' "
                        "(connection status: %d)\n",
                connection_url, static_cast<int>(connection_result));
        exit(-1);
      }
      if (error.Fail()) {
        fprintf(stderr, "error: failed to connect to client at '%s': %s\n",
                connection_url, error.AsCString());
        exit(-1);
      }
    } else {
      std::unique_ptr<Acceptor> acceptor_up(
          Acceptor::Create(final_host_and_port, false, error));
      if (error.Fail()) {
        fprintf(stderr, "failed to create acceptor: %s\n", error.AsCString());
        exit(1);
      }
      error = acceptor_up->Listen(1);
      if (error.Fail()) {
        fprintf(stderr, "failed to listen: %s\n", error.AsCString());
        exit(1);
      }
      const std::string socket_id = acceptor_up->GetLocalSocketId();
      if (!socket_id.empty()) {
        // If we have a named pipe to write the socket id back to, do that now.
        if (named_pipe_path && named_pipe_path[0]) {
          error = writeSocketIdToPipe(named_pipe_path, socket_id);
          if (error.Fail())
            fprintf(stderr, "failed to write to the named pipe \'%s\': %s\n",
                    named_pipe_path, error.AsCString());
        }
        // If we have an unnamed pipe to write the socket id back to, do that
        // now.
        else if (unnamed_pipe != LLDB_INVALID_PIPE) {
          error = writeSocketIdToPipe(unnamed_pipe, socket_id);
          if (error.Fail())
            fprintf(stderr, "failed to write to the unnamed pipe: %s\n",
                    error.AsCString());
        }
      } else {
        fprintf(stderr,
                "unable to get the socket id for the listening connection\n");
      }

      Connection *conn = nullptr;
      error = acceptor_up->Accept(false, conn);
      if (error.Fail()) {
        printf("failed to accept new connection: %s\n", error.AsCString());
        exit(1);
      }
      connection_up.reset(conn);
    }
  }
  error = gdb_server.InitializeConnection(std::move(connection_up));
  if (error.Fail()) {
    fprintf(stderr, "Failed to initialize connection: %s\n",
            error.AsCString());
    exit(-1);
  }
  printf("Connection established.\n");
}

namespace {
enum ID {
  OPT_INVALID = 0, // This is not an option ID.
#define OPTION(PREFIX, NAME, ID, KIND, GROUP, ALIAS, ALIASARGS, FLAGS, PARAM,  \
               HELPTEXT, METAVAR, VALUES)                                      \
  OPT_##ID,
#include "LLGSOptions.inc"
#undef OPTION
};

#define PREFIX(NAME, VALUE) const char *const NAME[] = VALUE;
#include "LLGSOptions.inc"
#undef PREFIX

const opt::OptTable::Info InfoTable[] = {
#define OPTION(PREFIX, NAME, ID, KIND, GROUP, ALIAS, ALIASARGS, FLAGS, PARAM,  \
               HELPTEXT, METAVAR, VALUES)                                      \
  {                                                                            \
      PREFIX,      NAME,      HELPTEXT,                                        \
      METAVAR,     OPT_##ID,  opt::Option::KIND##Class,                        \
      PARAM,       FLAGS,     OPT_##GROUP,                                     \
      OPT_##ALIAS, ALIASARGS, VALUES},
#include "LLGSOptions.inc"
#undef OPTION
};

class LLGSOptTable : public opt::OptTable {
public:
  LLGSOptTable() : OptTable(InfoTable) {}

  void PrintHelp(llvm::StringRef Name) {
    std::string Usage =
        (Name + " [options] [[host]:port] [[--] program args...]").str();
    OptTable::PrintHelp(llvm::outs(), Usage.c_str(), "lldb-server");
    llvm::outs() << R"(
DESCRIPTION
  lldb-server connects to the LLDB client, which drives the debugging session.
  If no connection options are given, the [host]:port argument must be present
  and will denote the address that lldb-server will listen on. [host] defaults
  to "localhost" if empty. Port can be zero, in which case the port number will
  be chosen dynamically and written to destinations given by --named-pipe and
  --pipe arguments.

  If no target is selected at startup, lldb-server can be directed by the LLDB
  client to launch or attach to a process.

)";
  }
};
} // namespace

int main_gdbserver(int argc, char *argv[]) {
  Status error;
  MainLoop mainloop;
#ifndef _WIN32
  // Setup signal handlers first thing.
  signal(SIGPIPE, SIG_IGN);
  MainLoop::SignalHandleUP sighup_handle =
      mainloop.RegisterSignal(SIGHUP, sighup_handler, error);
#endif

  const char *progname = argv[0];
  const char *subcommand = argv[1];
  std::string attach_target;
  std::string named_pipe_path;
  std::string log_file;
  StringRef
      log_channels; // e.g. "lldb process threads:gdb-remote default:linux all"
  lldb::pipe_t unnamed_pipe = LLDB_INVALID_PIPE;
  bool reverse_connect = false;
  int connection_fd = -1;

  // ProcessLaunchInfo launch_info;
  ProcessAttachInfo attach_info;

  LLGSOptTable Opts;
  llvm::BumpPtrAllocator Alloc;
  llvm::StringSaver Saver(Alloc);
  bool HasError = false;
  opt::InputArgList Args = Opts.parseArgs(argc - 1, argv + 1, OPT_UNKNOWN,
                                          Saver, [&](llvm::StringRef Msg) {
                                            WithColor::error() << Msg << "\n";
                                            HasError = true;
                                          });
  std::string Name =
      (llvm::sys::path::filename(argv[0]) + " g[dbserver]").str();
  std::string HelpText =
      "Use '" + Name + " --help' for a complete list of options.\n";
  if (HasError) {
    llvm::errs() << HelpText;
    return 1;
  }

  if (Args.hasArg(OPT_help)) {
    Opts.PrintHelp(Name);
    return 0;
  }

#ifndef _WIN32
  if (Args.hasArg(OPT_setsid)) {
    // Put llgs into a new session. Terminals group processes
    // into sessions and when a special terminal key sequences
    // (like control+c) are typed they can cause signals to go out to
    // all processes in a session. Using this --setsid (-S) option
    // will cause debugserver to run in its own sessions and be free
    // from such issues.
    //
    // This is useful when llgs is spawned from a command
    // line application that uses llgs to do the debugging,
    // yet that application doesn't want llgs receiving the
    // signals sent to the session (i.e. dying when anyone hits ^C).
    {
      const ::pid_t new_sid = setsid();
      if (new_sid == -1) {
        WithColor::warning()
            << llvm::formatv("failed to set new session id for {0} ({1})\n",
                             LLGS_PROGRAM_NAME, llvm::sys::StrError());
      }
    }
  }
#endif

  log_file = Args.getLastArgValue(OPT_log_file).str();
  log_channels = Args.getLastArgValue(OPT_log_channels);
  named_pipe_path = Args.getLastArgValue(OPT_named_pipe).str();
  reverse_connect = Args.hasArg(OPT_reverse_connect);
  attach_target = Args.getLastArgValue(OPT_attach).str();
  if (Args.hasArg(OPT_pipe)) {
    if (!llvm::to_integer(Args.getLastArgValue(OPT_pipe), unnamed_pipe)) {
      WithColor::error() << "invalid '--pipe' argument\n" << HelpText;
      return 1;
    }
  }
  if (Args.hasArg(OPT_fd)) {
    if (!llvm::to_integer(Args.getLastArgValue(OPT_fd), connection_fd)) {
      WithColor::error() << "invalid '--fd' argument\n" << HelpText;
      return 1;
    }
  }

  if (!LLDBServerUtilities::SetupLogging(
          log_file, log_channels,
          LLDB_LOG_OPTION_PREPEND_TIMESTAMP |
              LLDB_LOG_OPTION_PREPEND_FILE_FUNCTION))
    return -1;

  std::vector<llvm::StringRef> Inputs;
  for (opt::Arg *Arg : Args.filtered(OPT_INPUT))
    Inputs.push_back(Arg->getValue());
  if (opt::Arg *Arg = Args.getLastArg(OPT_REM)) {
    for (const char *Val : Arg->getValues())
      Inputs.push_back(Val);
  }
  if (Inputs.empty() && connection_fd == -1) {
    WithColor::error() << "no connection arguments\n" << HelpText;
    return 1;
  }

  NativeProcessFactory factory;
  GDBRemoteCommunicationServerLLGS gdb_server(mainloop, factory);

  llvm::StringRef host_and_port;
  if (!Inputs.empty()) {
    host_and_port = Inputs.front();
    Inputs.erase(Inputs.begin());
  }

  // Any arguments left over are for the program that we need to launch. If
  // there
  // are no arguments, then the GDB server will start up and wait for an 'A'
  // packet
  // to launch a program, or a vAttach packet to attach to an existing process,
  // unless
  // explicitly asked to attach with the --attach={pid|program_name} form.
  if (!attach_target.empty())
    handle_attach(gdb_server, attach_target);
  else if (!Inputs.empty())
    handle_launch(gdb_server, Inputs);

  // Print version info.
  printf("%s-%s\n", LLGS_PROGRAM_NAME, LLGS_VERSION_STR);

  ConnectToRemote(mainloop, gdb_server, reverse_connect, host_and_port,
                  progname, subcommand, named_pipe_path.c_str(),
                  unnamed_pipe, connection_fd);

  if (!gdb_server.IsConnected()) {
    fprintf(stderr, "no connection information provided, unable to run\n");
    return 1;
  }

  Status ret = mainloop.Run();
  if (ret.Fail()) {
    fprintf(stderr, "lldb-server terminating due to error: %s\n",
            ret.AsCString());
    return 1;
  }
  fprintf(stderr, "lldb-server exiting...\n");

  return 0;
}
