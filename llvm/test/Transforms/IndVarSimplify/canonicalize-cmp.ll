; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -indvars < %s | FileCheck %s

; Check that we replace signed comparisons between non-negative values with
; unsigned comparisons if we can.

target datalayout = "n8:16:32:64"

define i32 @test_01(i32 %a, i32 %b, i32* %p) {
; CHECK-LABEL: @test_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_ENTRY:%.*]]
; CHECK:       loop.entry:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_BE:%.*]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[IV]], 100
; CHECK-NEXT:    br i1 [[CMP1]], label [[B1:%.*]], label [[B2:%.*]]
; CHECK:       b1:
; CHECK-NEXT:    store i32 [[IV]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       b2:
; CHECK-NEXT:    store i32 [[A:%.*]], i32* [[P]], align 4
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i32 [[IV]], 100
; CHECK-NEXT:    br i1 [[CMP2]], label [[B3:%.*]], label [[B4:%.*]]
; CHECK:       b3:
; CHECK-NEXT:    store i32 [[IV]], i32* [[P]], align 4
; CHECK-NEXT:    br label [[LOOP_BE]]
; CHECK:       b4:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[P]], align 4
; CHECK-NEXT:    br label [[LOOP_BE]]
; CHECK:       loop.be:
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_ENTRY]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 999
;

entry:
  br label %loop.entry

loop.entry:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop.be ]
  %cmp1 = icmp slt i32 %iv, 100
  br i1 %cmp1, label %b1, label %b2

b1:
  store i32 %iv, i32* %p
  br label %merge

b2:
  store i32 %a, i32* %p
  br label %merge

merge:
  %cmp2 = icmp ult i32 %iv, 100
  br i1 %cmp2, label %b3, label %b4

b3:
  store i32 %iv, i32* %p
  br label %loop.be

b4:
  store i32 %b, i32* %p
  br label %loop.be

loop.be:
  %iv.next = add i32 %iv, 1
  %cmp3 = icmp slt i32 %iv.next, 1000
  br i1 %cmp3, label %loop.entry, label %exit

exit:
  ret i32 %iv
}

define i32 @test_02(i32 %a, i32 %b, i32* %p) {
; CHECK-LABEL: @test_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_ENTRY:%.*]]
; CHECK:       loop.entry:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_BE:%.*]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i32 100, [[IV]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[B1:%.*]], label [[B2:%.*]]
; CHECK:       b1:
; CHECK-NEXT:    store i32 [[IV]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       b2:
; CHECK-NEXT:    store i32 [[A:%.*]], i32* [[P]], align 4
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 100, [[IV]]
; CHECK-NEXT:    br i1 [[CMP2]], label [[B3:%.*]], label [[B4:%.*]]
; CHECK:       b3:
; CHECK-NEXT:    store i32 [[IV]], i32* [[P]], align 4
; CHECK-NEXT:    br label [[LOOP_BE]]
; CHECK:       b4:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[P]], align 4
; CHECK-NEXT:    br label [[LOOP_BE]]
; CHECK:       loop.be:
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_ENTRY]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 999
;

entry:
  br label %loop.entry

loop.entry:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop.be ]
  %cmp1 = icmp sgt i32 100, %iv
  br i1 %cmp1, label %b1, label %b2

b1:
  store i32 %iv, i32* %p
  br label %merge

b2:
  store i32 %a, i32* %p
  br label %merge

merge:
  %cmp2 = icmp ugt i32 100, %iv
  br i1 %cmp2, label %b3, label %b4

b3:
  store i32 %iv, i32* %p
  br label %loop.be

b4:
  store i32 %b, i32* %p
  br label %loop.be

loop.be:
  %iv.next = add i32 %iv, 1
  %cmp3 = icmp sgt i32 1000, %iv.next
  br i1 %cmp3, label %loop.entry, label %exit

exit:
  ret i32 %iv
}
