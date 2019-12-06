; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"


define void @test4(i32* noalias %P) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]]
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P]]
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P]]
; CHECK-NEXT:    ret void
;
  store i32 0, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  %x = load i32, i32* %P
  br label %bb3
bb3:
  store i32 0, i32* %P
  ret void
}

define void @test5(i32* noalias %P) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]]
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 1, i32* [[P]]
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P]]
; CHECK-NEXT:    ret void
;
  br i1 true, label %bb1, label %bb2
bb1:
  store i32 1, i32* %P
  br label %bb3
bb2:
  store i32 1, i32* %P
  br label %bb3
bb3:
  store i32 0, i32* %P
  ret void
}

define void @test8(i32* %P, i32* %Q) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]]
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 1, i32* [[Q:%.*]]
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P]]
; CHECK-NEXT:    ret void
;
  br i1 true, label %bb1, label %bb2
bb1:
  store i32 1, i32* %P
  br label %bb3
bb2:
  store i32 1, i32* %Q
  br label %bb3
bb3:
  store i32 0, i32* %P
  ret void
}

define void @test10(i32* noalias %P) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[P2:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    store i32 0, i32* [[P]]
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i8 1, i8* [[P2]]
; CHECK-NEXT:    ret void
;
  %P2 = bitcast i32* %P to i8*
  store i32 0, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  store i8 1, i8* %P2
  ret void
}
