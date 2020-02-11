; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mattr=sse2 -slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: opt < %s -mattr=avx2 -slp-vectorizer -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX

; TODO:
; With AVX, we are able to vectorize the 1st 4 elements as 256-bit vector ops,
; but the final 2 elements remain scalar. They should get vectorized using
; 128-bit ops identically to what happens with SSE.

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @PR28457(double* noalias nocapture align 32 %q, double* noalias nocapture readonly align 32 %p) {
; SSE-LABEL: @PR28457(
; SSE-NEXT:    [[P0:%.*]] = getelementptr inbounds double, double* [[P:%.*]], i64 0
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds double, double* [[P]], i64 1
; SSE-NEXT:    [[P2:%.*]] = getelementptr inbounds double, double* [[P]], i64 2
; SSE-NEXT:    [[P3:%.*]] = getelementptr inbounds double, double* [[P]], i64 3
; SSE-NEXT:    [[P4:%.*]] = getelementptr inbounds double, double* [[P]], i64 4
; SSE-NEXT:    [[P5:%.*]] = getelementptr inbounds double, double* [[P]], i64 5
; SSE-NEXT:    [[Q0:%.*]] = getelementptr inbounds double, double* [[Q:%.*]], i64 0
; SSE-NEXT:    [[Q1:%.*]] = getelementptr inbounds double, double* [[Q]], i64 1
; SSE-NEXT:    [[Q2:%.*]] = getelementptr inbounds double, double* [[Q]], i64 2
; SSE-NEXT:    [[Q3:%.*]] = getelementptr inbounds double, double* [[Q]], i64 3
; SSE-NEXT:    [[Q4:%.*]] = getelementptr inbounds double, double* [[Q]], i64 4
; SSE-NEXT:    [[Q5:%.*]] = getelementptr inbounds double, double* [[Q]], i64 5
; SSE-NEXT:    [[TMP1:%.*]] = bitcast double* [[P0]] to <2 x double>*
; SSE-NEXT:    [[TMP2:%.*]] = load <2 x double>, <2 x double>* [[TMP1]], align 8
; SSE-NEXT:    [[TMP3:%.*]] = bitcast double* [[P2]] to <2 x double>*
; SSE-NEXT:    [[TMP4:%.*]] = load <2 x double>, <2 x double>* [[TMP3]], align 8
; SSE-NEXT:    [[TMP5:%.*]] = bitcast double* [[P4]] to <2 x double>*
; SSE-NEXT:    [[TMP6:%.*]] = load <2 x double>, <2 x double>* [[TMP5]], align 8
; SSE-NEXT:    [[TMP7:%.*]] = fadd <2 x double> [[TMP2]], <double 1.000000e+00, double 1.000000e+00>
; SSE-NEXT:    [[TMP8:%.*]] = fadd <2 x double> [[TMP4]], <double 1.000000e+00, double 1.000000e+00>
; SSE-NEXT:    [[TMP9:%.*]] = fadd <2 x double> [[TMP6]], <double 1.000000e+00, double 1.000000e+00>
; SSE-NEXT:    [[TMP10:%.*]] = bitcast double* [[Q0]] to <2 x double>*
; SSE-NEXT:    store <2 x double> [[TMP7]], <2 x double>* [[TMP10]], align 8
; SSE-NEXT:    [[TMP11:%.*]] = bitcast double* [[Q2]] to <2 x double>*
; SSE-NEXT:    store <2 x double> [[TMP8]], <2 x double>* [[TMP11]], align 8
; SSE-NEXT:    [[TMP12:%.*]] = bitcast double* [[Q4]] to <2 x double>*
; SSE-NEXT:    store <2 x double> [[TMP9]], <2 x double>* [[TMP12]], align 8
; SSE-NEXT:    ret void
;
; AVX-LABEL: @PR28457(
; AVX-NEXT:    [[P0:%.*]] = getelementptr inbounds double, double* [[P:%.*]], i64 0
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds double, double* [[P]], i64 1
; AVX-NEXT:    [[P2:%.*]] = getelementptr inbounds double, double* [[P]], i64 2
; AVX-NEXT:    [[P3:%.*]] = getelementptr inbounds double, double* [[P]], i64 3
; AVX-NEXT:    [[P4:%.*]] = getelementptr inbounds double, double* [[P]], i64 4
; AVX-NEXT:    [[P5:%.*]] = getelementptr inbounds double, double* [[P]], i64 5
; AVX-NEXT:    [[Q0:%.*]] = getelementptr inbounds double, double* [[Q:%.*]], i64 0
; AVX-NEXT:    [[Q1:%.*]] = getelementptr inbounds double, double* [[Q]], i64 1
; AVX-NEXT:    [[Q2:%.*]] = getelementptr inbounds double, double* [[Q]], i64 2
; AVX-NEXT:    [[Q3:%.*]] = getelementptr inbounds double, double* [[Q]], i64 3
; AVX-NEXT:    [[Q4:%.*]] = getelementptr inbounds double, double* [[Q]], i64 4
; AVX-NEXT:    [[Q5:%.*]] = getelementptr inbounds double, double* [[Q]], i64 5
; AVX-NEXT:    [[TMP1:%.*]] = bitcast double* [[P0]] to <4 x double>*
; AVX-NEXT:    [[TMP2:%.*]] = load <4 x double>, <4 x double>* [[TMP1]], align 8
; AVX-NEXT:    [[TMP3:%.*]] = bitcast double* [[P4]] to <2 x double>*
; AVX-NEXT:    [[TMP4:%.*]] = load <2 x double>, <2 x double>* [[TMP3]], align 8
; AVX-NEXT:    [[TMP5:%.*]] = fadd <4 x double> [[TMP2]], <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>
; AVX-NEXT:    [[TMP6:%.*]] = fadd <2 x double> [[TMP4]], <double 1.000000e+00, double 1.000000e+00>
; AVX-NEXT:    [[TMP7:%.*]] = bitcast double* [[Q0]] to <4 x double>*
; AVX-NEXT:    store <4 x double> [[TMP5]], <4 x double>* [[TMP7]], align 8
; AVX-NEXT:    [[TMP8:%.*]] = bitcast double* [[Q4]] to <2 x double>*
; AVX-NEXT:    store <2 x double> [[TMP6]], <2 x double>* [[TMP8]], align 8
; AVX-NEXT:    ret void
;
  %p0 = getelementptr inbounds double, double* %p, i64 0
  %p1 = getelementptr inbounds double, double* %p, i64 1
  %p2 = getelementptr inbounds double, double* %p, i64 2
  %p3 = getelementptr inbounds double, double* %p, i64 3
  %p4 = getelementptr inbounds double, double* %p, i64 4
  %p5 = getelementptr inbounds double, double* %p, i64 5

  %q0 = getelementptr inbounds double, double* %q, i64 0
  %q1 = getelementptr inbounds double, double* %q, i64 1
  %q2 = getelementptr inbounds double, double* %q, i64 2
  %q3 = getelementptr inbounds double, double* %q, i64 3
  %q4 = getelementptr inbounds double, double* %q, i64 4
  %q5 = getelementptr inbounds double, double* %q, i64 5

  %d0 = load double, double* %p0
  %d1 = load double, double* %p1
  %d2 = load double, double* %p2
  %d3 = load double, double* %p3
  %d4 = load double, double* %p4
  %d5 = load double, double* %p5

  %a0 = fadd double %d0, 1.0
  %a1 = fadd double %d1, 1.0
  %a2 = fadd double %d2, 1.0
  %a3 = fadd double %d3, 1.0
  %a4 = fadd double %d4, 1.0
  %a5 = fadd double %d5, 1.0

  store double %a0, double* %q0
  store double %a1, double* %q1
  store double %a2, double* %q2
  store double %a3, double* %q3
  store double %a4, double* %q4
  store double %a5, double* %q5
  ret void
}
