import lldb
from lldbsuite.test.decorators import *
import lldbsuite.test.lldbtest as lldbtest
import lldbsuite.test.lldbutil as lldbutil

# This test creates 5 async frames:
# * ASYNC___1___, which is called by
# * ASYNC___2___, which is called by
# * ...
# * ASYNC___5___, which is called by
#
# The number of frames is important to exercise all possible unwind plans:
# * The top frame (ASYNC___1___) is created by just inspecting the registers as
# they are.
# * The plan for ASYNC___1___ -> ASYNC___2___ is created through
# `GetRuntimeUnwindPlan`, which is responsible for the transition from a real
# frame to a virtual frame.
# * The plan for ASYNC___2___ -> ASYNC___3___ is created through
# GetFollowAsyncContextUnwindPlan, which is responsible to create a virtual
# frame from another virtual frame.
# * The plan for ASYNC___3___ -> ASYNC___4___ is created through
# GetFollowAsyncContextUnwindPlan, but this time it follow the code path where
# `is_indirect = True` (see its implementation).
# * The plan for ASYNC___4___ -> ASYNC___5___ is created through the same code
# path as the previous one. It is not technically needed, but we keep it here
# because it is the first time where we should be creating an identical plan as
# the one from the previous frame.

class TestCase(lldbtest.TestBase):

    mydir = lldbtest.TestBase.compute_mydir(__file__)

    def set_breakpoints_all_funclets(self, target):
        funclet_names = [
            "$s1a12ASYNC___1___4condS2i_tYaF",
            "$s1a12ASYNC___1___4condS2i_tYaFTY0_",
            "$s1a12ASYNC___1___4condS2i_tYaFTQ1_",
            "$s1a12ASYNC___1___4condS2i_tYaFTY2_",
            "$s1a12ASYNC___1___4condS2i_tYaFTQ3_",
            "$s1a12ASYNC___1___4condS2i_tYaFTY4_",
            "$s1a12ASYNC___1___4condS2i_tYaFTQ5_",
            "$s1a12ASYNC___1___4condS2i_tYaFTY6_",
        ]

        breakpoints = set()
        for funclet_name in funclet_names:
            sym_ctx_list = target.FindFunctions(funclet_name)
            self.assertEqual(
                sym_ctx_list.GetSize(),
                1,
                f"failed to get symbol context for {funclet_name}",
            )
            function = sym_ctx_list[0].function

            instructions = list(function.GetInstructions(target))
            self.assertGreater(len(instructions), 0)
            for instruction in instructions:
                bp = target.BreakpointCreateBySBAddress(instruction.GetAddress())
                self.assertTrue(
                    bp.IsValid(), f"failed to set bp inside funclet {funclet_name}"
                )
                breakpoints.add(bp.GetID())
        return breakpoints

    # FIXME: there are challenges when unwinding Q funclets ("await resume"),
    # see rdar://137048317. For now, we only know how to unwind during and
    # shortly after the prologue. This function returns "should skip" if we're
    # at a PC that is too far from the prologue (~16 bytes). This is a
    # rough approximation that seems to work for both x86 and arm.
    def should_skip_Q_funclet(self, thread):
        current_frame = thread.frames[0]
        function = current_frame.GetFunction()
        if "await resume" not in function.GetName():
            return False

        max_prologue_offset = 16
        prologue_end = function.GetStartAddress()
        prologue_end.OffsetAddress(function.GetPrologueByteSize() + max_prologue_offset)
        current_pc = current_frame.GetPCAddress()
        return current_pc.GetFileAddress() >= prologue_end.GetFileAddress()

    def check_unwind_ok(self, thread, bpid):
        if self.should_skip_Q_funclet(thread):
            return
        # Check that we see the virtual backtrace:
        expected_funcnames = [
            "ASYNC___1___",
            "ASYNC___2___",
            "ASYNC___3___",
            "ASYNC___4___",
            "ASYNC___5___",
        ]
        frames = thread.frames
        self.assertGreater(
            len(frames), len(expected_funcnames), f"Invalid backtrace for {frames}"
        )
        actual_funcnames = [
            frame.GetFunctionName() for frame in frames[: len(expected_funcnames)]
        ]
        for expected_name, actual_name in zip(expected_funcnames, actual_funcnames):
            self.assertIn(expected_name, actual_name, f"Unexpected backtrace: {frames}")

    @swiftTest
    @skipIf(oslist=["windows", "linux"])
    def test(self):
        """Test that the debugger can unwind at all instructions of all funclets"""
        self.build()

        source_file = lldb.SBFileSpec("main.swift")
        target, process, _, _ = lldbutil.run_to_source_breakpoint(
            self, "BREAK HERE", source_file
        )

        breakpoints = self.set_breakpoints_all_funclets(target)
        num_breakpoints = len(breakpoints)

        # Reach most breakpoints and ensure we can unwind in that position.
        while True:
            process.Continue()
            thread = lldbutil.get_stopped_thread(process, lldb.eStopReasonBreakpoint)
            if thread is None:
                break
            bpid = thread.GetStopReasonDataAtIndex(0)
            breakpoints.remove(bpid)
            target.FindBreakpointByID(bpid).SetEnabled(False)

            self.check_unwind_ok(thread, bpid)

        # We will never hit all breakpoints we set, because of things like
        # overflow handling or other unreachable traps. However, it's good to
        # have some sanity check that we have hit at least a decent chunk of
        # them.
        breakpoints_not_hit = len(breakpoints)
        self.assertGreater(0.10, breakpoints_not_hit / num_breakpoints)
