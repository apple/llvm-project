; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @sub1(i32 %x) {
; CHECK-LABEL: @sub1(
; CHECK-NEXT:    [[Y:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = sdiv i32 [[Y]], 337
; CHECK-NEXT:    ret i32 [[Z]]
;
  %y = sub i32 0, %x
  %z = sdiv i32 %y, 337
  ret i32 %z
}

define i32 @sub2(i32 %x) {
; CHECK-LABEL: @sub2(
; CHECK-NEXT:    [[Z:%.*]] = sdiv i32 [[X:%.*]], -337
; CHECK-NEXT:    ret i32 [[Z]]
;
  %y = sub nsw i32 0, %x
  %z = sdiv i32 %y, 337
  ret i32 %z
}

define i1 @shl_icmp(i64 %X) {
; CHECK-LABEL: @shl_icmp(
; CHECK-NEXT:    [[B:%.*]] = icmp eq i64 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[B]]
;
  %A = shl nuw i64 %X, 2   ; X/4
  %B = icmp eq i64 %A, 0
  ret i1 %B
}

define i64 @shl1(i64 %X, i64* %P) {
; CHECK-LABEL: @shl1(
; CHECK-NEXT:    [[A:%.*]] = and i64 [[X:%.*]], 312
; CHECK-NEXT:    store i64 [[A]], i64* [[P:%.*]], align 4
; CHECK-NEXT:    [[B:%.*]] = shl nuw nsw i64 [[A]], 8
; CHECK-NEXT:    ret i64 [[B]]
;
  %A = and i64 %X, 312
  store i64 %A, i64* %P  ; multiple uses of A.
  %B = shl i64 %A, 8
  ret i64 %B
}

define i32 @preserve1(i32 %x) {
; CHECK-LABEL: @preserve1(
; CHECK-NEXT:    [[ADD3:%.*]] = add nsw i32 [[X:%.*]], 5
; CHECK-NEXT:    ret i32 [[ADD3]]
;
  %add = add nsw i32 %x, 2
  %add3 = add nsw i32 %add, 3
  ret i32 %add3
}

define i8 @nopreserve1(i8 %x) {
; CHECK-LABEL: @nopreserve1(
; CHECK-NEXT:    [[ADD3:%.*]] = add i8 [[X:%.*]], -126
; CHECK-NEXT:    ret i8 [[ADD3]]
;
  %add = add nsw i8 %x, 127
  %add3 = add nsw i8 %add, 3
  ret i8 %add3
}

define i8 @nopreserve2(i8 %x) {
; CHECK-LABEL: @nopreserve2(
; CHECK-NEXT:    [[ADD3:%.*]] = add i8 [[X:%.*]], 3
; CHECK-NEXT:    ret i8 [[ADD3]]
;
  %add = add i8 %x, 1
  %add3 = add nsw i8 %add, 2
  ret i8 %add3
}

define i8 @nopreserve3(i8 %A, i8 %B) {
; CHECK-LABEL: @nopreserve3(
; CHECK-NEXT:    [[Y:%.*]] = add i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[Y]], 20
; CHECK-NEXT:    ret i8 [[ADD]]
;
  %x = add i8 %A, 10
  %y = add i8 %B, 10
  %add = add nsw i8 %x, %y
  ret i8 %add
}

define i8 @nopreserve4(i8 %A, i8 %B) {
; CHECK-LABEL: @nopreserve4(
; CHECK-NEXT:    [[Y:%.*]] = add i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[Y]], 20
; CHECK-NEXT:    ret i8 [[ADD]]
;
  %x = add nsw i8 %A, 10
  %y = add nsw i8 %B, 10
  %add = add nsw i8 %x, %y
  ret i8 %add
}

define <3 x i32> @shl_nuw_nsw_shuffle_splat_vec(<2 x i8> %x) {
; CHECK-LABEL: @shl_nuw_nsw_shuffle_splat_vec(
; CHECK-NEXT:    [[T2:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[SHUF:%.*]] = shufflevector <2 x i32> [[T2]], <2 x i32> undef, <3 x i32> <i32 1, i32 0, i32 1>
; CHECK-NEXT:    [[T3:%.*]] = shl nuw nsw <3 x i32> [[SHUF]], <i32 17, i32 17, i32 17>
; CHECK-NEXT:    ret <3 x i32> [[T3]]
;
  %t2 = zext <2 x i8> %x to <2 x i32>
  %shuf = shufflevector <2 x i32> %t2, <2 x i32> undef, <3 x i32> <i32 1, i32 0, i32 1>
  %t3 = shl <3 x i32> %shuf, <i32 17, i32 17, i32 17>
  ret <3 x i32> %t3
}

; Negative test - if the shuffle mask contains an undef, we bail out to
; avoid propagating information that may not be used consistently by callers.

define <3 x i32> @shl_nuw_nsw_shuffle_undef_elt_splat_vec(<2 x i8> %x) {
; CHECK-LABEL: @shl_nuw_nsw_shuffle_undef_elt_splat_vec(
; CHECK-NEXT:    [[T2:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[SHUF:%.*]] = shufflevector <2 x i32> [[T2]], <2 x i32> undef, <3 x i32> <i32 1, i32 undef, i32 0>
; CHECK-NEXT:    [[T3:%.*]] = shl <3 x i32> [[SHUF]], <i32 17, i32 17, i32 17>
; CHECK-NEXT:    ret <3 x i32> [[T3]]
;
  %t2 = zext <2 x i8> %x to <2 x i32>
  %shuf = shufflevector <2 x i32> %t2, <2 x i32> undef, <3 x i32> <i32 1, i32 undef, i32 0>
  %t3 = shl <3 x i32> %shuf, <i32 17, i32 17, i32 17>
  ret <3 x i32> %t3
}

