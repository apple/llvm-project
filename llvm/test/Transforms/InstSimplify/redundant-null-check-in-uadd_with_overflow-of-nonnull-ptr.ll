; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instsimplify -S | FileCheck %s

; Here we have add some offset to a non-null pointer,
; and check that the result does not overflow and is not a null pointer.
; But since the base pointer is already non-null, and we check for overflow,
; that will already catch the get null pointer,
; so the separate null check is redundant and can be dropped.

define i1 @t0(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_OVERFLOW_DURING_ADJUSTMENT:%.*]] = icmp uge i64 [[ADJUSTED]], [[BASE_INT]]
; CHECK-NEXT:    ret i1 [[NO_OVERFLOW_DURING_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp ne i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp uge i64 %adjusted, %base_int
  %res = and i1 %non_null_after_adjustment, %no_overflow_during_adjustment
  ret i1 %res
}
define i1 @t1(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_OVERFLOW_DURING_ADJUSTMENT:%.*]] = icmp ule i64 [[BASE_INT]], [[ADJUSTED]]
; CHECK-NEXT:    ret i1 [[NO_OVERFLOW_DURING_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp ne i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ule i64 %base_int, %adjusted ; swapped
  %res = and i1 %non_null_after_adjustment, %no_overflow_during_adjustment
  ret i1 %res
}
define i1 @t2(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t2(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_OVERFLOW_DURING_ADJUSTMENT:%.*]] = icmp uge i64 [[ADJUSTED]], [[BASE_INT]]
; CHECK-NEXT:    ret i1 [[NO_OVERFLOW_DURING_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp ne i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp uge i64 %adjusted, %base_int
  %res = and i1 %no_overflow_during_adjustment, %non_null_after_adjustment ; swapped
  ret i1 %res
}
define i1 @t3(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t3(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_OVERFLOW_DURING_ADJUSTMENT:%.*]] = icmp ule i64 [[BASE_INT]], [[ADJUSTED]]
; CHECK-NEXT:    ret i1 [[NO_OVERFLOW_DURING_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp ne i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ule i64 %base_int, %adjusted ; swapped
  %res = and i1 %no_overflow_during_adjustment, %non_null_after_adjustment ; swapped
  ret i1 %res
}

; If the joining operator was 'or', i.e. we check that either we produced non-null
; pointer, or no overflow happened, then the overflow check itself is redundant.

define i1 @t4(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t4(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NON_NULL_AFTER_ADJUSTMENT:%.*]] = icmp ne i64 [[ADJUSTED]], 0
; CHECK-NEXT:    ret i1 [[NON_NULL_AFTER_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp ne i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp uge i64 %adjusted, %base_int
  %res = or i1 %non_null_after_adjustment, %no_overflow_during_adjustment
  ret i1 %res
}
define i1 @t5(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t5(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NON_NULL_AFTER_ADJUSTMENT:%.*]] = icmp ne i64 [[ADJUSTED]], 0
; CHECK-NEXT:    ret i1 [[NON_NULL_AFTER_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp ne i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ule i64 %base_int, %adjusted ; swapped
  %res = or i1 %non_null_after_adjustment, %no_overflow_during_adjustment
  ret i1 %res
}
define i1 @t6(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t6(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NON_NULL_AFTER_ADJUSTMENT:%.*]] = icmp ne i64 [[ADJUSTED]], 0
; CHECK-NEXT:    ret i1 [[NON_NULL_AFTER_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp ne i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp uge i64 %adjusted, %base_int
  %res = or i1 %no_overflow_during_adjustment, %non_null_after_adjustment ; swapped
  ret i1 %res
}
define i1 @t7(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t7(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NON_NULL_AFTER_ADJUSTMENT:%.*]] = icmp ne i64 [[ADJUSTED]], 0
; CHECK-NEXT:    ret i1 [[NON_NULL_AFTER_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp ne i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ule i64 %base_int, %adjusted ; swapped
  %res = or i1 %no_overflow_during_adjustment, %non_null_after_adjustment ; swapped
  ret i1 %res
}

; Or, we could be checking the reverse condition, that we either get null pointer,
; or overflow happens, then again, the standalone null check is redundant and
; can be dropped.

define i1 @t8(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t8(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_OVERFLOW_DURING_ADJUSTMENT:%.*]] = icmp ult i64 [[ADJUSTED]], [[BASE_INT]]
; CHECK-NEXT:    ret i1 [[NO_OVERFLOW_DURING_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp eq i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ult i64 %adjusted, %base_int
  %res = or i1 %non_null_after_adjustment, %no_overflow_during_adjustment
  ret i1 %res
}
define i1 @t9(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t9(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_OVERFLOW_DURING_ADJUSTMENT:%.*]] = icmp ugt i64 [[BASE_INT]], [[ADJUSTED]]
; CHECK-NEXT:    ret i1 [[NO_OVERFLOW_DURING_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp eq i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ugt i64 %base_int, %adjusted ; swapped
  %res = or i1 %non_null_after_adjustment, %no_overflow_during_adjustment
  ret i1 %res
}
define i1 @t10(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t10(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_OVERFLOW_DURING_ADJUSTMENT:%.*]] = icmp ult i64 [[ADJUSTED]], [[BASE_INT]]
; CHECK-NEXT:    ret i1 [[NO_OVERFLOW_DURING_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp eq i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ult i64 %adjusted, %base_int
  %res = or i1 %no_overflow_during_adjustment, %non_null_after_adjustment ; swapped
  ret i1 %res
}
define i1 @t11(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t11(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_OVERFLOW_DURING_ADJUSTMENT:%.*]] = icmp ugt i64 [[BASE_INT]], [[ADJUSTED]]
; CHECK-NEXT:    ret i1 [[NO_OVERFLOW_DURING_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp eq i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ugt i64 %base_int, %adjusted ; swapped
  %res = or i1 %no_overflow_during_adjustment, %non_null_after_adjustment ; swapped
  ret i1 %res
}

; If the joining operator was 'and', i.e. we check that we both get null pointer
; AND overflow happens, then the overflow check is redundant.

define i1 @t12(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t12(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NON_NULL_AFTER_ADJUSTMENT:%.*]] = icmp eq i64 [[ADJUSTED]], 0
; CHECK-NEXT:    ret i1 [[NON_NULL_AFTER_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp eq i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ult i64 %adjusted, %base_int
  %res = and i1 %non_null_after_adjustment, %no_overflow_during_adjustment
  ret i1 %res
}
define i1 @t13(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t13(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NON_NULL_AFTER_ADJUSTMENT:%.*]] = icmp eq i64 [[ADJUSTED]], 0
; CHECK-NEXT:    ret i1 [[NON_NULL_AFTER_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp eq i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ugt i64 %base_int, %adjusted ; swapped
  %res = and i1 %non_null_after_adjustment, %no_overflow_during_adjustment
  ret i1 %res
}
define i1 @t14(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t14(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NON_NULL_AFTER_ADJUSTMENT:%.*]] = icmp eq i64 [[ADJUSTED]], 0
; CHECK-NEXT:    ret i1 [[NON_NULL_AFTER_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp eq i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ult i64 %adjusted, %base_int
  %res = and i1 %no_overflow_during_adjustment, %non_null_after_adjustment ; swapped
  ret i1 %res
}
define i1 @t15(i8* nonnull %base, i64 %offset) {
; CHECK-LABEL: @t15(
; CHECK-NEXT:    [[BASE_INT:%.*]] = ptrtoint i8* [[BASE:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE_INT]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NON_NULL_AFTER_ADJUSTMENT:%.*]] = icmp eq i64 [[ADJUSTED]], 0
; CHECK-NEXT:    ret i1 [[NON_NULL_AFTER_ADJUSTMENT]]
;
  %base_int = ptrtoint i8* %base to i64
  %adjusted = add i64 %base_int, %offset
  %non_null_after_adjustment = icmp eq i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp ugt i64 %base_int, %adjusted ; swapped
  %res = and i1 %no_overflow_during_adjustment, %non_null_after_adjustment ; swapped
  ret i1 %res
}

declare void @llvm.assume(i1)
define i1 @t16(i64 %base, i64 %offset) {
; CHECK-LABEL: @t16(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[BASE:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[ADJUSTED:%.*]] = add i64 [[BASE]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_OVERFLOW_DURING_ADJUSTMENT:%.*]] = icmp uge i64 [[ADJUSTED]], [[BASE]]
; CHECK-NEXT:    ret i1 [[NO_OVERFLOW_DURING_ADJUSTMENT]]
;
  %cmp = icmp slt i64 %base, 0
  call void @llvm.assume(i1 %cmp)

  %adjusted = add i64 %base, %offset
  %non_null_after_adjustment = icmp ne i64 %adjusted, 0
  %no_overflow_during_adjustment = icmp uge i64 %adjusted, %base
  %res = and i1 %non_null_after_adjustment, %no_overflow_during_adjustment
  ret i1 %res
}
