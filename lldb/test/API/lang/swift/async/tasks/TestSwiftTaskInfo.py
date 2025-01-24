import lldb
from lldbsuite.test.decorators import *
from lldbsuite.test.lldbtest import TestBase
import lldbsuite.test.lldbutil as lldbutil

import re


def _tail(output):
    """Delete the first line of output text."""
    return re.subn(r"^.*\n", "", output, count=1)


class TestCase(TestBase):
    def test(self):
        self.build()
        lldbutil.run_to_source_breakpoint(
            self, "break here", lldb.SBFileSpec("main.swift")
        )
        self.runCmd("language swift task info")
        task_info_output = self.res.GetOutput()
        self.runCmd("frame variable task")
        frame_variable_output = self.res.GetOutput()
        self.assertEqual(_tail(task_info_output), _tail(frame_variable_output))
