; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

; For pattern ((X << Y) & signbit) ==/!= 0
; it may be optimal to fold into (X << Y) >=/< 0
; rather than X & (signbit l>> Y) ==/!= 0

; Scalar tests

define i1 @scalar_i8_shl_and_signbit_eq(i8 %x, i8 %y) {
; CHECK-LABEL: @scalar_i8_shl_and_signbit_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i8 -128, [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i8 %x, %y
  %and = and i8 %shl, 128
  %r = icmp eq i8 %and, 0
  ret i1 %r
}

define i1 @scalar_i16_shl_and_signbit_eq(i16 %x, i16 %y) {
; CHECK-LABEL: @scalar_i16_shl_and_signbit_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i16 -32768, [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i16 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq i16 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i16 %x, %y
  %and = and i16 %shl, 32768
  %r = icmp eq i16 %and, 0
  ret i1 %r
}

define i1 @scalar_i32_shl_and_signbit_eq(i32 %x, i32 %y) {
; CHECK-LABEL: @scalar_i32_shl_and_signbit_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 -2147483648, [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq i32 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i32 %x, %y
  %and = and i32 %shl, 2147483648
  %r = icmp eq i32 %and, 0
  ret i1 %r
}

define i1 @scalar_i64_shl_and_signbit_eq(i64 %x, i64 %y) {
; CHECK-LABEL: @scalar_i64_shl_and_signbit_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 -9223372036854775808, [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq i64 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i64 %x, %y
  %and = and i64 %shl, 9223372036854775808
  %r = icmp eq i64 %and, 0
  ret i1 %r
}

define i1 @scalar_i32_shl_and_signbit_ne(i32 %x, i32 %y) {
; CHECK-LABEL: @scalar_i32_shl_and_signbit_ne(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 -2147483648, [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ne i32 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i32 %x, %y
  %and = and i32 %shl, 2147483648
  %r = icmp ne i32 %and, 0  ; check 'ne' predicate
  ret i1 %r
}

; Vector tests

define <4 x i1> @vec_4xi32_shl_and_signbit_eq(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @vec_4xi32_shl_and_signbit_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <4 x i32> <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>, [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and <4 x i32> [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq <4 x i32> [[TMP2]], zeroinitializer
; CHECK-NEXT:    ret <4 x i1> [[R]]
;
  %shl = shl <4 x i32> %x, %y
  %and = and <4 x i32> %shl, <i32 2147483648, i32 2147483648, i32 2147483648, i32 2147483648>
  %r = icmp eq <4 x i32> %and, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %r
}

define <4 x i1> @vec_4xi32_shl_and_signbit_eq_undef1(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @vec_4xi32_shl_and_signbit_eq_undef1(
; CHECK-NEXT:    [[SHL:%.*]] = shl <4 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and <4 x i32> [[SHL]], <i32 -2147483648, i32 undef, i32 -2147483648, i32 -2147483648>
; CHECK-NEXT:    [[R:%.*]] = icmp eq <4 x i32> [[AND]], zeroinitializer
; CHECK-NEXT:    ret <4 x i1> [[R]]
;
  %shl = shl <4 x i32> %x, %y
  %and = and <4 x i32> %shl, <i32 2147483648, i32 undef, i32 2147483648, i32 2147483648>
  %r = icmp eq <4 x i32> %and, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %r
}

define <4 x i1> @vec_4xi32_shl_and_signbit_eq_undef2(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @vec_4xi32_shl_and_signbit_eq_undef2(
; CHECK-NEXT:    [[SHL:%.*]] = shl <4 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and <4 x i32> [[SHL]], <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
; CHECK-NEXT:    [[R:%.*]] = icmp eq <4 x i32> [[AND]], <i32 undef, i32 0, i32 0, i32 0>
; CHECK-NEXT:    ret <4 x i1> [[R]]
;
  %shl = shl <4 x i32> %x, %y
  %and = and <4 x i32> %shl, <i32 2147483648, i32 2147483648, i32 2147483648, i32 2147483648>
  %r = icmp eq <4 x i32> %and, <i32 undef, i32 0, i32 0, i32 0>
  ret <4 x i1> %r
}

define <4 x i1> @vec_4xi32_shl_and_signbit_eq_undef3(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @vec_4xi32_shl_and_signbit_eq_undef3(
; CHECK-NEXT:    [[SHL:%.*]] = shl <4 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and <4 x i32> [[SHL]], <i32 -2147483648, i32 undef, i32 -2147483648, i32 -2147483648>
; CHECK-NEXT:    [[R:%.*]] = icmp eq <4 x i32> [[AND]], <i32 0, i32 0, i32 0, i32 undef>
; CHECK-NEXT:    ret <4 x i1> [[R]]
;
  %shl = shl <4 x i32> %x, %y
  %and = and <4 x i32> %shl, <i32 2147483648, i32 undef, i32 2147483648, i32 2147483648>
  %r = icmp eq <4 x i32> %and, <i32 0, i32 0, i32 0, i32 undef>
  ret <4 x i1> %r
}

; Extra use

; Fold happened
define i1 @scalar_shl_and_signbit_eq_extra_use_shl(i32 %x, i32 %y, i32 %z, i32* %p) {
; CHECK-LABEL: @scalar_shl_and_signbit_eq_extra_use_shl(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[SHL]], [[Z:%.*]]
; CHECK-NEXT:    store i32 [[XOR]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i32 [[SHL]], -1
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i32 %x, %y
  %xor = xor i32 %shl, %z  ; extra use of shl
  store i32 %xor, i32* %p
  %and = and i32 %shl, 2147483648
  %r = icmp eq i32 %and, 0
  ret i1 %r
}

; Not fold
define i1 @scalar_shl_and_signbit_eq_extra_use_and(i32 %x, i32 %y, i32 %z, i32* %p) {
; CHECK-LABEL: @scalar_shl_and_signbit_eq_extra_use_and(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SHL]], -2147483648
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[AND]], [[Z:%.*]]
; CHECK-NEXT:    store i32 [[MUL]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i32 %x, %y
  %and = and i32 %shl, 2147483648
  %mul = mul i32 %and, %z  ; extra use of and
  store i32 %mul, i32* %p
  %r = icmp eq i32 %and, 0
  ret i1 %r
}

; Not fold
define i1 @scalar_shl_and_signbit_eq_extra_use_shl_and(i32 %x, i32 %y, i32 %z, i32* %p, i32* %q) {
; CHECK-LABEL: @scalar_shl_and_signbit_eq_extra_use_shl_and(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SHL]], -2147483648
; CHECK-NEXT:    store i32 [[AND]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[SHL]], [[Z:%.*]]
; CHECK-NEXT:    store i32 [[ADD]], i32* [[Q:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i32 %x, %y
  %and = and i32 %shl, 2147483648
  store i32 %and, i32* %p  ; extra use of and
  %add = add i32 %shl, %z  ; extra use of shl
  store i32 %add, i32* %q
  %r = icmp eq i32 %and, 0
  ret i1 %r
}

; Negative tests

; X is constant

define i1 @scalar_i32_shl_and_signbit_eq_X_is_constant1(i32 %y) {
; CHECK-LABEL: @scalar_i32_shl_and_signbit_eq_X_is_constant1(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 12345, [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i32 [[SHL]], -1
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i32 12345, %y
  %and = and i32 %shl, 2147483648
  %r = icmp eq i32 %and, 0
  ret i1 %r
}

define i1 @scalar_i32_shl_and_signbit_eq_X_is_constant2(i32 %y) {
; CHECK-LABEL: @scalar_i32_shl_and_signbit_eq_X_is_constant2(
; CHECK-NEXT:    [[R:%.*]] = icmp ne i32 [[Y:%.*]], 31
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i32 1, %y
  %and = and i32 %shl, 2147483648
  %r = icmp eq i32 %and, 0
  ret i1 %r
}

; Check 'slt' predicate

define i1 @scalar_i32_shl_and_signbit_slt(i32 %x, i32 %y) {
; CHECK-LABEL: @scalar_i32_shl_and_signbit_slt(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp slt i32 [[SHL]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %shl = shl i32 %x, %y
  %and = and i32 %shl, 2147483648
  %r = icmp slt i32 %and, 0
  ret i1 %r
}

; Compare with nonzero

define i1 @scalar_i32_shl_and_signbit_eq_nonzero(i32 %x, i32 %y) {
; CHECK-LABEL: @scalar_i32_shl_and_signbit_eq_nonzero(
; CHECK-NEXT:    ret i1 false
;
  %shl = shl i32 %x, %y
  %and = and i32 %shl, 2147483648
  %r = icmp eq i32 %and, 1  ; should be comparing with 0
  ret i1 %r
}
