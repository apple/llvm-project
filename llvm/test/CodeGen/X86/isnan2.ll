; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- -mcpu=yonah | FileCheck %s

; This should not need to materialize 0.0 to evaluate the condition.

define i32 @test(double %X) nounwind  {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    ucomisd %xmm0, %xmm0
; CHECK-NEXT:    setp %al
; CHECK-NEXT:    retl
entry:
	%tmp6 = fcmp uno double %X, 0.000000e+00		; <i1> [#uses=1]
	%tmp67 = zext i1 %tmp6 to i32		; <i32> [#uses=1]
	ret i32 %tmp67
}

