; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm64-eabi | FileCheck %s

define float @t1(i1 %a, float %b, float %c) nounwind {
; CHECK-LABEL: t1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    fcsel s0, s0, s1, ne
; CHECK-NEXT:    ret
  %sel = select i1 %a, float %b, float %c
  ret float %sel
}

; This may infinite loop if isNegatibleForFree and getNegatedExpression are conflicted.

define double @negation_propagation(double* %arg, double %arg1, double %arg2) {
; CHECK-LABEL: negation_propagation:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov d2, #1.00000000
; CHECK-NEXT:    fdiv d0, d2, d0
; CHECK-NEXT:    fmul d2, d0, d0
; CHECK-NEXT:    fmul d1, d0, d1
; CHECK-NEXT:    fmul d0, d0, d2
; CHECK-NEXT:    fsub d0, d1, d0
; CHECK-NEXT:    ret
  %t = fdiv double 1.0, %arg1
  %t7 = fmul double %t, %arg2
  %t10 = fneg double %t7
  %t11 = fmul double %t, %t
  %t13 = fsub double %t11, %t
  %t14 = fneg double %t
  %t15 = fmul double %t, %t14
  %t16 = fmul double %t, %t15
  %t18 = fadd double %t16, %t7
  ret double %t18
}

define { double, double } @testfn(double %x, double %y) #0 {
; CHECK-LABEL: testfn:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fsub d0, d0, d1
; CHECK-NEXT:    fneg d1, d0
; CHECK-NEXT:    ret
  %sub = fsub fast double %x, %y
  %neg = fneg fast double %sub
  %r0 = insertvalue { double, double } undef, double %sub, 0
  %r1 = insertvalue { double, double } %r0, double %neg, 1
  ret { double, double } %r1
}

attributes #0 = { "no-signed-zeros-fp-math"="true" }
