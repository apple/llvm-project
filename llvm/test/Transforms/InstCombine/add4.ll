; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s
; ModuleID = 'test/Transforms/InstCombine/add4.ll'
source_filename = "test/Transforms/InstCombine/add4.ll"

define i64 @match_unsigned(i64 %x) {
; CHECK-LABEL: @match_unsigned(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[X:%.*]], 19136
; CHECK-NEXT:    ret i64 [[UREM]]
;
bb:
  %tmp = urem i64 %x, 299
  %tmp1 = udiv i64 %x, 299
  %tmp2 = urem i64 %tmp1, 64
  %tmp3 = mul i64 %tmp2, 299
  %tmp4 = add i64 %tmp, %tmp3
  ret i64 %tmp4
}

define <2 x i64> @match_unsigned_vector(<2 x i64> %x) {
; CHECK-LABEL: @match_unsigned_vector(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[UREM:%.*]] = urem <2 x i64> [[X:%.*]], <i64 19136, i64 19136>
; CHECK-NEXT:    ret <2 x i64> [[UREM]]
;
bb:
  %tmp = urem <2 x i64> %x, <i64 299, i64 299>
  %tmp1 = udiv <2 x i64> %x, <i64 299, i64 299>
  %tmp2 = urem <2 x i64> %tmp1, <i64 64, i64 64>
  %tmp3 = mul <2 x i64> %tmp2, <i64 299, i64 299>
  %tmp4 = add <2 x i64> %tmp, %tmp3
  ret <2 x i64> %tmp4
}
define i64 @match_andAsRem_lshrAsDiv_shlAsMul(i64 %x) {
; CHECK-LABEL: @match_andAsRem_lshrAsDiv_shlAsMul(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[X:%.*]], 576
; CHECK-NEXT:    ret i64 [[UREM]]
;
bb:
  %tmp = and i64 %x, 63
  %tmp1 = lshr i64 %x, 6
  %tmp2 = urem i64 %tmp1, 9
  %tmp3 = shl i64 %tmp2, 6
  %tmp4 = add i64 %tmp, %tmp3
  ret i64 %tmp4
}

define i64 @match_signed(i64 %x) {
; CHECK-LABEL: @match_signed(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[SREM1:%.*]] = srem i64 [[X:%.*]], 172224
; CHECK-NEXT:    ret i64 [[SREM1]]
;
bb:
  %tmp = srem i64 %x, 299
  %tmp1 = sdiv i64 %x, 299
  %tmp2 = srem i64 %tmp1, 64
  %tmp3 = sdiv i64 %x, 19136
  %tmp4 = srem i64 %tmp3, 9
  %tmp5 = mul i64 %tmp2, 299
  %tmp6 = add i64 %tmp, %tmp5
  %tmp7 = mul i64 %tmp4, 19136
  %tmp8 = add i64 %tmp6, %tmp7
  ret i64 %tmp8
}

define <2 x i64> @match_signed_vector(<2 x i64> %x) {
; CHECK-LABEL: @match_signed_vector(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[SREM1:%.*]] = srem <2 x i64> [[X:%.*]], <i64 172224, i64 172224>
; CHECK-NEXT:    ret <2 x i64> [[SREM1]]
;
bb:
  %tmp = srem <2 x i64> %x, <i64 299, i64 299>
  %tmp1 = sdiv <2 x i64> %x, <i64 299, i64 299>
  %tmp2 = srem <2 x i64> %tmp1, <i64 64, i64 64>
  %tmp3 = sdiv <2 x i64> %x, <i64 19136, i64 19136>
  %tmp4 = srem <2 x i64> %tmp3, <i64 9, i64 9>
  %tmp5 = mul <2 x i64> %tmp2, <i64 299, i64 299>
  %tmp6 = add <2 x i64> %tmp, %tmp5
  %tmp7 = mul <2 x i64> %tmp4, <i64 19136, i64 19136>
  %tmp8 = add <2 x i64> %tmp6, %tmp7
  ret <2 x i64> %tmp8
}

define i64 @not_match_inconsistent_signs(i64 %x) {
; CHECK-LABEL: @not_match_inconsistent_signs(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = urem i64 [[X:%.*]], 299
; CHECK-NEXT:    [[TMP1:%.*]] = sdiv i64 [[X]], 299
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP1]], 63
; CHECK-NEXT:    [[TMP3:%.*]] = mul nuw nsw i64 [[TMP2]], 299
; CHECK-NEXT:    [[TMP4:%.*]] = add nuw nsw i64 [[TMP]], [[TMP3]]
; CHECK-NEXT:    ret i64 [[TMP4]]
;
bb:
  %tmp = urem i64 %x, 299
  %tmp1 = sdiv i64 %x, 299
  %tmp2 = urem i64 %tmp1, 64
  %tmp3 = mul i64 %tmp2, 299
  %tmp4 = add i64 %tmp, %tmp3
  ret i64 %tmp4
}

define i64 @not_match_inconsistent_values(i64 %x) {
; CHECK-LABEL: @not_match_inconsistent_values(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = urem i64 [[X:%.*]], 299
; CHECK-NEXT:    [[TMP1:%.*]] = udiv i64 [[X]], 29
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP1]], 63
; CHECK-NEXT:    [[TMP3:%.*]] = mul nuw nsw i64 [[TMP2]], 299
; CHECK-NEXT:    [[TMP4:%.*]] = add nuw nsw i64 [[TMP]], [[TMP3]]
; CHECK-NEXT:    ret i64 [[TMP4]]
;
bb:
  %tmp = urem i64 %x, 299
  %tmp1 = udiv i64 %x, 29
  %tmp2 = urem i64 %tmp1, 64
  %tmp3 = mul i64 %tmp2, 299
  %tmp4 = add i64 %tmp, %tmp3
  ret i64 %tmp4
}

define i32 @not_match_overflow(i32 %x) {
; CHECK-LABEL: @not_match_overflow(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = urem i32 [[X:%.*]], 299
; CHECK-NEXT:    [[TMP0:%.*]] = urem i32 [[X]], 299
; CHECK-NEXT:    [[TMP3:%.*]] = sub i32 [[X]], [[TMP0]]
; CHECK-NEXT:    [[TMP4:%.*]] = add i32 [[TMP]], [[TMP3]]
; CHECK-NEXT:    ret i32 [[TMP4]]
;
bb:
  %tmp = urem i32 %x, 299
  %tmp1 = udiv i32 %x,299
  %tmp2 = urem i32 %tmp1, 147483647
  %tmp3 = mul i32 %tmp2, 299
  %tmp4 = add i32 %tmp, %tmp3
  ret i32 %tmp4
}
