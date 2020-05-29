//===- DependencyScanningTool.cpp - clang-scan-deps service ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "clang/Tooling/DependencyScanning/DependencyScanningTool.h"
#include "clang/Basic/LLVM.h"
#include "clang/Frontend/Utils.h"

namespace clang{
namespace tooling{
namespace dependencies{

std::vector<std::string> FullDependencies::getAdditionalCommandLine(
    std::function<StringRef(ClangModuleDep)> LookupPCMPath,
    std::function<const ModuleDeps &(ClangModuleDep)> LookupModuleDeps) const {
  std::vector<std::string> Ret = AdditionalNonPathCommandLine;

  dependencies::detail::appendCommonModuleArguments(
      ClangModuleDeps, LookupPCMPath, LookupModuleDeps, Ret);

  return Ret;
}

DependencyScanningTool::DependencyScanningTool(
    DependencyScanningService &Service)
    : Worker(Service) {}

llvm::Expected<std::string> DependencyScanningTool::getDependencyFile(
    const tooling::CompilationDatabase &Compilations, StringRef CWD) {
  /// Prints out all of the gathered dependencies into a string.
  class MakeDependencyPrinterConsumer : public DependencyConsumer {
  public:
    void handleFileDependency(const DependencyOutputOptions &Opts,
                              StringRef File) override {
      if (!this->Opts)
        this->Opts = std::make_unique<DependencyOutputOptions>(Opts);
      Dependencies.push_back(std::string(File));
    }

    void handleModuleDependency(ModuleDeps MD) override {
      // These are ignored for the make format as it can't support the full
      // set of deps, and handleFileDependency handles enough for implicitly
      // built modules to work.
    }

    void handleContextHash(std::string Hash) override {}

    void printDependencies(std::string &S) {
      if (!Opts)
        return;

      class DependencyPrinter : public DependencyFileGenerator {
      public:
        DependencyPrinter(DependencyOutputOptions &Opts,
                          ArrayRef<std::string> Dependencies)
            : DependencyFileGenerator(Opts) {
          for (const auto &Dep : Dependencies)
            addDependency(Dep);
        }

        void printDependencies(std::string &S) {
          llvm::raw_string_ostream OS(S);
          outputDependencyFile(OS);
        }
      };

      DependencyPrinter Generator(*Opts, Dependencies);
      Generator.printDependencies(S);
    }

  private:
    std::unique_ptr<DependencyOutputOptions> Opts;
    std::vector<std::string> Dependencies;
  };

  // We expect a single command here because if a source file occurs multiple
  // times in the original CDB, then `computeDependencies` would run the
  // `DependencyScanningAction` once for every time the input occured in the
  // CDB. Instead we split up the CDB into single command chunks to avoid this
  // behavior.
  assert(Compilations.getAllCompileCommands().size() == 1 &&
         "Expected a compilation database with a single command!");
  std::string Input = Compilations.getAllCompileCommands().front().Filename;

  MakeDependencyPrinterConsumer Consumer;
  auto Result =
      Worker.computeDependencies(Input, CWD, Compilations, Consumer, nullptr);
  if (Result)
    return std::move(Result);
  std::string Output;
  Consumer.printDependencies(Output);
  return Output;
}

llvm::Expected<FullDependenciesResult>
DependencyScanningTool::getFullDependencies(
    const tooling::CompilationDatabase &Compilations, StringRef CWD,
    const llvm::StringSet<> &AlreadySeen) {
  class FullDependencyPrinterConsumer : public DependencyConsumer {
  public:
    FullDependencyPrinterConsumer(const llvm::StringSet<> &AlreadySeen)
        : AlreadySeen(AlreadySeen) {}

    void handleFileDependency(const DependencyOutputOptions &Opts,
                              StringRef File) override {
      Dependencies.push_back(std::string(File));
    }

    void handleModuleDependency(ModuleDeps MD) override {
      ClangModuleDeps[MD.ContextHash + MD.ModuleName] = std::move(MD);
    }

    void handleContextHash(std::string Hash) override {
      ContextHash = std::move(Hash);
    }

    FullDependenciesResult
    getFullDependencies(std::vector<std::string> &&OriginalInvocation) const {
      FullDependencies FD;

      FD.ContextHash = std::move(ContextHash);

      FD.FileDeps.assign(Dependencies.begin(), Dependencies.end());

      for (auto &&M : ClangModuleDeps) {
        auto &MD = M.second;
        if (MD.ImportedByMainFile)
          FD.ClangModuleDeps.push_back({MD.ModuleName, ContextHash});
      }

      FD.AdditionalNonPathCommandLine = OriginalInvocation;
      FD.AdditionalNonPathCommandLine.push_back("-fno-implicit-modules");
      FD.AdditionalNonPathCommandLine.push_back("-fno-implicit-module-maps");

      FullDependenciesResult FDR;

      for (auto &&M : ClangModuleDeps) {
        // TODO: Avoid handleModuleDependency even being called for modules
        //   we've already seen.
        if (AlreadySeen.count(M.first))
          continue;
        FDR.DiscoveredModules.push_back(std::move(M.second));
      }

      FDR.FullDeps = std::move(FD);
      return FDR;
    }

  private:
    std::vector<std::string> Dependencies;
    std::unordered_map<std::string, ModuleDeps> ClangModuleDeps;
    std::string ContextHash;
    std::vector<std::string> OutputPaths;
    const llvm::StringSet<> &AlreadySeen;
  };

  // We expect a single command here because if a source file occurs multiple
  // times in the original CDB, then `computeDependencies` would run the
  // `DependencyScanningAction` once for every time the input occured in the
  // CDB. Instead we split up the CDB into single command chunks to avoid this
  // behavior.
  assert(Compilations.getAllCompileCommands().size() == 1 &&
         "Expected a compilation database with a single command!");
  std::string Input = Compilations.getAllCompileCommands().front().Filename;

  FullDependencyPrinterConsumer Consumer(AlreadySeen);

  std::vector<std::string> OriginalInvocation;
  llvm::Error Result = Worker.computeDependencies(
      Input, CWD, Compilations, Consumer, &OriginalInvocation);
  if (Result)
    return std::move(Result);
  return Consumer.getFullDependencies(std::move(OriginalInvocation));
}

} // end namespace dependencies
} // end namespace tooling
} // end namespace clang
