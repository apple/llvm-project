; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"
target triple = "i686-apple-darwin9"

define i80 @from() {
; CHECK-LABEL: @from(
; CHECK-NEXT:    ret i80 302245289961712575840256
;
  %tmp = bitcast x86_fp80 0xK4000C000000000000000 to i80
  ret i80 %tmp
}

define x86_fp80 @to() {
; CHECK-LABEL: @to(
; CHECK-NEXT:    ret x86_fp80 0xK40018000000000000000
;
  %tmp = bitcast i80 302259125019767858003968 to x86_fp80
  ret x86_fp80 %tmp
}
