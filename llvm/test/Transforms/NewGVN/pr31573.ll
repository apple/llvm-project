; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -newgvn -S | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

define void @patatino(i8* %blah) {
; CHECK-LABEL: @patatino(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    [[MEH:%.*]] = phi i8* [ [[BLAH:%.*]], [[ENTRY:%.*]] ], [ null, [[WHILE_BODY:%.*]] ]
; CHECK-NEXT:    switch i32 undef, label [[WHILE_BODY]] [
; CHECK-NEXT:    i32 666, label [[WHILE_END:%.*]]
; CHECK-NEXT:    ]
; CHECK:       while.body:
; CHECK-NEXT:    br label [[WHILE_COND]]
; CHECK:       while.end:
; CHECK-NEXT:    store i8 0, i8* [[MEH]], align 1
; CHECK-NEXT:    store i8 0, i8* [[BLAH]], align 1
; CHECK-NEXT:    ret void
;
entry:
  br label %while.cond

while.cond:
  %meh = phi i8* [ %blah, %entry ], [ null, %while.body ]
  switch i32 undef, label %while.body [
  i32 666, label %while.end
  ]

while.body:
  br label %while.cond

while.end:
;; These two stores will initially be considered equivalent, but then proven not.
;; the second store would previously end up deciding it's equivalent to a previous
;; store, but it was really just finding an optimistic version of itself
;; in the congruence class.
  store i8 0, i8* %meh, align 1
  store i8 0, i8* %blah, align 1
  ret void
}
