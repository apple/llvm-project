; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -dse -enable-dse-memoryssa -S | FileCheck %s

; Both stores should be emitted because we can't tell if the gather aliases.

define <4 x i32> @bar(<4 x i32> %arg, i32* %arg1) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    store i32 5, i32* [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP:%.*]] = tail call <4 x i32> @llvm.x86.avx2.gather.d.d(<4 x i32> zeroinitializer, i8* null, <4 x i32> [[ARG:%.*]], <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, i8 1)
; CHECK-NEXT:    store i32 10, i32* [[ARG1]]
; CHECK-NEXT:    ret <4 x i32> [[TMP]]
;
bb:
  store i32 5, i32* %arg1
  %tmp = tail call <4 x i32> @llvm.x86.avx2.gather.d.d(<4 x i32> zeroinitializer, i8* null, <4 x i32> %arg, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, i8 1)
  store i32 10, i32* %arg1
  ret <4 x i32> %tmp
}

declare <4 x i32> @llvm.x86.avx2.gather.d.d(<4 x i32>, i8*, <4 x i32>, <4 x i32>, i8)
