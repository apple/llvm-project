; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

define <4 x double> @autogen_SD30452(i1 %L230) {
; CHECK-LABEL: autogen_SD30452:
; CHECK:       # %bb.0: # %BB
; CHECK-NEXT:    movdqa {{.*#+}} xmm1 = [151829,151829]
; CHECK-NEXT:    movq %xmm0, %rax
; CHECK-NEXT:    cvtsi2sd %rax, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[2,3,0,1]
; CHECK-NEXT:    movq %xmm2, %rax
; CHECK-NEXT:    xorps %xmm2, %xmm2
; CHECK-NEXT:    cvtsi2sd %rax, %xmm2
; CHECK-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; CHECK-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; CHECK-NEXT:    cvtdq2pd %xmm1, %xmm1
; CHECK-NEXT:    retq
BB:
  %I = insertelement <4 x i64> zeroinitializer, i64 151829, i32 3
  %Shuff7 = shufflevector <4 x i64> %I, <4 x i64> zeroinitializer, <4 x i32> <i32 undef, i32 undef, i32 3, i32 undef>
  br label %CF242

CF242:                                            ; preds = %CF242, %BB
  %FC125 = sitofp <4 x i64> %Shuff7 to <4 x double>
  ret <4 x double> %FC125
}
