"""
Test process list.
"""


import os
import lldb
import shutil
from lldbsuite.test.decorators import *
from lldbsuite.test.lldbtest import *
from lldbsuite.test import lldbutil


class ProcessListTestCase(TestBase):

    mydir = TestBase.compute_mydir(__file__)

    NO_DEBUG_INFO_TESTCASE = True

    @skipIfWindows  # https://bugs.llvm.org/show_bug.cgi?id=43702
    @skipIfRemote   # rdar://problem/66542336
    @expectedFailureAll(oslist=['freebsd'])
    def test_process_list_with_args(self):
        """Test process list show process args"""
        self.build()
        exe = self.getBuildArtifact("TestProcess")

        # Spawn a new process
        popen = self.spawnSubprocess(exe, args=["arg1", "--arg2", "arg3"])

        substrs = [str(popen.pid), "TestProcess arg1 --arg2 arg3"]

        # Because LLDB isn't the one spawning the subprocess, the PID will be
        # different during replay.
        if configuration.is_reproducer_replay():
            substrs.pop(0)

        self.expect("platform process list -v", substrs=substrs)
