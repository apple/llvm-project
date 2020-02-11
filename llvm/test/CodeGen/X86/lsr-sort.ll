; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

@X = common global i16 0		; <i16*> [#uses=1]

define i32 @foo(i32 %N) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    jle .LBB0_2
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %bb
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movw %ax, {{.*}}(%rip)
; CHECK-NEXT:    incl %eax
; CHECK-NEXT:    cmpl %eax, %edi
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  .LBB0_2: # %return
; CHECK-NEXT:    retq
entry:
	%0 = icmp sgt i32 %N, 0		; <i1> [#uses=1]
	br i1 %0, label %bb, label %return

bb:		; preds = %bb, %entry
	%i.03 = phi i32 [ 0, %entry ], [ %indvar.next, %bb ]		; <i32> [#uses=2]
	%1 = trunc i32 %i.03 to i16		; <i16> [#uses=1]
	store volatile i16 %1, i16* @X, align 2
	%indvar.next = add i32 %i.03, 1		; <i32> [#uses=2]
	%exitcond = icmp eq i32 %indvar.next, %N		; <i1> [#uses=1]
	br i1 %exitcond, label %return, label %bb

return:		; preds = %bb, %entry
        %h = phi i32 [ 0, %entry ], [ %indvar.next, %bb ]
	ret i32 %h
}
