; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -constprop -S < %s | FileCheck %s

; Fixes PR20832
; Make sure that we correctly fold a fused multiply-add where operands
; are all finite constants and addend is zero.

declare double @llvm.fma.f64(double, double, double)


define double @PR20832()  {
; CHECK-LABEL: @PR20832(
; CHECK-NEXT:    ret double 5.600000e+01
;
  %1 = call double @llvm.fma.f64(double 7.0, double 8.0, double 0.0)
  ret double %1
}

; Test builtin fma with all finite non-zero constants.
define double @test_all_finite()  {
; CHECK-LABEL: @test_all_finite(
; CHECK-NEXT:    ret double 6.100000e+01
;
  %1 = call double @llvm.fma.f64(double 7.0, double 8.0, double 5.0)
  ret double %1
}

; Test builtin fma with a +/-NaN addend.
define double @test_NaN_addend()  {
; CHECK-LABEL: @test_NaN_addend(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 7.0, double 8.0, double 0x7FF8000000000000)
  ret double %1
}

define double @test_NaN_addend_2()  {
; CHECK-LABEL: @test_NaN_addend_2(
; CHECK-NEXT:    ret double 0xFFF8000000000000
;
  %1 = call double @llvm.fma.f64(double 7.0, double 8.0, double 0xFFF8000000000000)
  ret double %1
}

; Test builtin fma with a +/-Inf addend.
define double @test_Inf_addend()  {
; CHECK-LABEL: @test_Inf_addend(
; CHECK-NEXT:    ret double 0x7FF0000000000000
;
  %1 = call double @llvm.fma.f64(double 7.0, double 8.0, double 0x7FF0000000000000)
  ret double %1
}

define double @test_Inf_addend_2()  {
; CHECK-LABEL: @test_Inf_addend_2(
; CHECK-NEXT:    ret double 0xFFF0000000000000
;
  %1 = call double @llvm.fma.f64(double 7.0, double 8.0, double 0xFFF0000000000000)
  ret double %1
}

; Test builtin fma with one of the operands to the multiply being +/-NaN.
define double @test_NaN_1()  {
; CHECK-LABEL: @test_NaN_1(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 0x7FF8000000000000, double 8.0, double 0.0)
  ret double %1
}

define double @test_NaN_2()  {
; CHECK-LABEL: @test_NaN_2(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 7.0, double 0x7FF8000000000000, double 0.0)
  ret double %1
}

define double @test_NaN_3()  {
; CHECK-LABEL: @test_NaN_3(
; CHECK-NEXT:    ret double 0xFFF8000000000000
;
  %1 = call double @llvm.fma.f64(double 0xFFF8000000000000, double 8.0, double 0.0)
  ret double %1
}

define double @test_NaN_4()  {
; CHECK-LABEL: @test_NaN_4(
; CHECK-NEXT:    ret double 0xFFF8000000000000
;
  %1 = call double @llvm.fma.f64(double 7.0, double 0xFFF8000000000000, double 0.0)
  ret double %1
}

; Test builtin fma with one of the operands to the multiply being +/-Inf.
define double @test_Inf_1()  {
; CHECK-LABEL: @test_Inf_1(
; CHECK-NEXT:    ret double 0x7FF0000000000000
;
  %1 = call double @llvm.fma.f64(double 0x7FF0000000000000, double 8.0, double 0.0)
  ret double %1
}

define double @test_Inf_2()  {
; CHECK-LABEL: @test_Inf_2(
; CHECK-NEXT:    ret double 0x7FF0000000000000
;
  %1 = call double @llvm.fma.f64(double 7.0, double 0x7FF0000000000000, double 0.0)
  ret double %1
}

define double @test_Inf_3()  {
; CHECK-LABEL: @test_Inf_3(
; CHECK-NEXT:    ret double 0xFFF0000000000000
;
  %1 = call double @llvm.fma.f64(double 0xFFF0000000000000, double 8.0, double 0.0)
  ret double %1
}

define double @test_Inf_4()  {
; CHECK-LABEL: @test_Inf_4(
; CHECK-NEXT:    ret double 0xFFF0000000000000
;
  %1 = call double @llvm.fma.f64(double 7.0, double 0xFFF0000000000000, double 0.0)
  ret double %1
}

; -inf + inf --> NaN

define double @inf_product_opposite_inf_addend_1()  {
; CHECK-LABEL: @inf_product_opposite_inf_addend_1(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 7.0, double 0xFFF0000000000000, double 0x7FF0000000000000)
  ret double %1
}

; inf + -inf --> NaN

define double @inf_product_opposite_inf_addend_2()  {
; CHECK-LABEL: @inf_product_opposite_inf_addend_2(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 7.0, double 0x7FF0000000000000, double 0xFFF0000000000000)
  ret double %1
}

; -inf + inf --> NaN

define double @inf_product_opposite_inf_addend_3()  {
; CHECK-LABEL: @inf_product_opposite_inf_addend_3(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 0xFFF0000000000000, double 42.0, double 0x7FF0000000000000)
  ret double %1
}

; inf + -inf --> NaN

define double @inf_product_opposite_inf_addend_4()  {
; CHECK-LABEL: @inf_product_opposite_inf_addend_4(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 0x7FF0000000000000, double 42.0, double 0xFFF0000000000000)
  ret double %1
}

; 0 * -inf --> NaN

define double @inf_times_zero_1()  {
; CHECK-LABEL: @inf_times_zero_1(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 0.0, double 0xFFF0000000000000, double 42.0)
  ret double %1
}

; 0 * inf --> NaN

define double @inf_times_zero_2()  {
; CHECK-LABEL: @inf_times_zero_2(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 0.0, double 0x7FF0000000000000, double 42.0)
  ret double %1
}

; -inf * 0 --> NaN

define double @inf_times_zero_3()  {
; CHECK-LABEL: @inf_times_zero_3(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 0xFFF0000000000000, double 0.0, double 42.0)
  ret double %1
}

; inf * 0 --> NaN

define double @inf_times_zero_4()  {
; CHECK-LABEL: @inf_times_zero_4(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 0x7FF0000000000000, double 0.0, double 42.0)
  ret double %1
}

; -0 * -inf --> NaN

define double @inf_times_zero_5()  {
; CHECK-LABEL: @inf_times_zero_5(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double -0.0, double 0xFFF0000000000000, double 42.0)
  ret double %1
}

; -0 * inf --> NaN

define double @inf_times_zero_6()  {
; CHECK-LABEL: @inf_times_zero_6(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double -0.0, double 0x7FF0000000000000, double 42.0)
  ret double %1
}

; -inf * -0 --> NaN

define double @inf_times_zero_7()  {
; CHECK-LABEL: @inf_times_zero_7(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 0xFFF0000000000000, double -0.0, double 42.0)
  ret double %1
}

; inf * -0 --> NaN

define double @inf_times_zero_8()  {
; CHECK-LABEL: @inf_times_zero_8(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %1 = call double @llvm.fma.f64(double 0x7FF0000000000000, double -0.0, double 42.0)
  ret double %1
}
