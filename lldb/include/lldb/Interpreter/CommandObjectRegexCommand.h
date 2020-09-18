//===-- CommandObjectRegexCommand.h -----------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_INTERPRETER_COMMANDOBJECTREGEXCOMMAND_H
#define LLDB_INTERPRETER_COMMANDOBJECTREGEXCOMMAND_H

#include <list>

#include "lldb/Interpreter/CommandObject.h"
#include "lldb/Utility/CompletionRequest.h"
#include "lldb/Utility/RegularExpression.h"

namespace lldb_private {

// CommandObjectRegexCommand

class CommandObjectRegexCommand : public CommandObjectRaw {
public:
  CommandObjectRegexCommand(CommandInterpreter &interpreter, llvm::StringRef name,
    llvm::StringRef help, llvm::StringRef syntax,
                            uint32_t max_matches, uint32_t completion_type_mask,
                            bool is_removable);

  ~CommandObjectRegexCommand() override;

  bool IsRemovable() const override { return m_is_removable; }

  bool AddRegexCommand(const char *re_cstr, const char *command_cstr);

  bool HasRegexEntries() const { return !m_entries.empty(); }

  void HandleCompletion(CompletionRequest &request) override;

protected:
  bool DoExecute(llvm::StringRef command, CommandReturnObject &result) override;

  struct Entry {
    RegularExpression regex;
    std::string command;
  };

  typedef std::list<Entry> EntryCollection;
  const uint32_t m_max_matches;
  const uint32_t m_completion_type_mask;
  EntryCollection m_entries;
  bool m_is_removable;

private:
  CommandObjectRegexCommand(const CommandObjectRegexCommand &) = delete;
  const CommandObjectRegexCommand &
  operator=(const CommandObjectRegexCommand &) = delete;
};

} // namespace lldb_private

#endif // LLDB_INTERPRETER_COMMANDOBJECTREGEXCOMMAND_H
