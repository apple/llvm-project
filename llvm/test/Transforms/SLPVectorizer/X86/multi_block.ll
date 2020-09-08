; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.7.0"

; int bar(double *A, int d) {
;   double A0 = A[0];
;   double A1 = A[1];
;   float F0 = A0;
;   float F1 = A1;
;   if (d) foo(); <----- This splits the blocks
;   F0+=4.0;
;   F1+=5.0;
;   A[8] = 9.0 + F0;
;   A[9] = 5.0 + F1;
; }


define i32 @bar(double* nocapture %A, i32 %d) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast double* [[A:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x double>, <2 x double>* [[TMP1]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = fptrunc <2 x double> [[TMP2]] to <2 x float>
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i32 [[D:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[TMP7:%.*]], label [[TMP5:%.*]]
; CHECK:         [[TMP6:%.*]] = tail call i32 (...) @foo()
; CHECK-NEXT:    br label [[TMP7]]
; CHECK:         [[TMP8:%.*]] = fadd <2 x float> [[TMP3]], <float 4.000000e+00, float 5.000000e+00>
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds double, double* [[A]], i64 8
; CHECK-NEXT:    [[TMP10:%.*]] = fpext <2 x float> [[TMP8]] to <2 x double>
; CHECK-NEXT:    [[TMP11:%.*]] = fadd <2 x double> [[TMP10]], <double 9.000000e+00, double 5.000000e+00>
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast double* [[TMP9]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP11]], <2 x double>* [[TMP12]], align 8
; CHECK-NEXT:    ret i32 undef
;
  %1 = load double, double* %A, align 8
  %2 = getelementptr inbounds double, double* %A, i64 1
  %3 = load double, double* %2, align 8
  %4 = fptrunc double %1 to float
  %5 = fptrunc double %3 to float
  %6 = icmp eq i32 %d, 0
  br i1 %6, label %9, label %7

; <label>:7                                       ; preds = %0
  %8 = tail call i32 (...) @foo()
  br label %9

; <label>:9                                       ; preds = %0, %7
  %10 = fadd float %4, 4.000000e+00
  %11 = fadd float %5, 5.000000e+00
  %12 = fpext float %10 to double
  %13 = fadd double %12, 9.000000e+00
  %14 = getelementptr inbounds double, double* %A, i64 8
  store double %13, double* %14, align 8
  %15 = fpext float %11 to double
  %16 = fadd double %15, 5.000000e+00
  %17 = getelementptr inbounds double, double* %A, i64 9
  store double %16, double* %17, align 8
  ret i32 undef
}

declare i32 @foo(...)

