; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

; If we have some pattern that leaves only some low bits set, lshr then performs
; left-shift of those bits, we can combine those two shifts into a shift+mask.

; There are many variants to this pattern:
;   e)  (trunc (((x << maskNbits) l>> maskNbits))) << shiftNbits
; simplify to:
;   ((trunc(x)) << shiftNbits) & (-1 >> ((-(maskNbits+shiftNbits))+32))

; Simple tests.

declare void @use32(i32)
declare void @use64(i64)

define i32 @t0_basic(i64 %x, i32 %nbits) {
; CHECK-LABEL: @t0_basic(
; CHECK-NEXT:    [[T0:%.*]] = zext i32 [[NBITS:%.*]] to i64
; CHECK-NEXT:    [[T1:%.*]] = shl i64 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[NBITS]], -32
; CHECK-NEXT:    [[T3:%.*]] = lshr i64 [[T1]], [[T0]]
; CHECK-NEXT:    call void @use64(i64 [[T0]])
; CHECK-NEXT:    call void @use64(i64 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use64(i64 [[T3]])
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[X]] to i32
; CHECK-NEXT:    [[T5:%.*]] = shl i32 [[TMP1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T5]]
;
  %t0 = zext i32 %nbits to i64
  %t1 = shl i64 %x, %t0
  %t2 = add i32 %nbits, -32
  %t3 = lshr i64 %t1, %t0

  call void @use64(i64 %t0)
  call void @use64(i64 %t1)
  call void @use32(i32 %t2)
  call void @use64(i64 %t3)

  %t4 = trunc i64 %t3 to i32
  %t5 = shl i32 %t4, %t2
  ret i32 %t5
}

; Vectors

declare void @use8xi32(<8 x i32>)
declare void @use8xi64(<8 x i64>)

define <8 x i32> @t1_vec_splat(<8 x i64> %x, <8 x i32> %nbits) {
; CHECK-LABEL: @t1_vec_splat(
; CHECK-NEXT:    [[T0:%.*]] = zext <8 x i32> [[NBITS:%.*]] to <8 x i64>
; CHECK-NEXT:    [[T1:%.*]] = shl <8 x i64> [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add <8 x i32> [[NBITS]], <i32 -32, i32 -32, i32 -32, i32 -32, i32 -32, i32 -32, i32 -32, i32 -32>
; CHECK-NEXT:    [[T3:%.*]] = lshr <8 x i64> [[T1]], [[T0]]
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T0]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T1]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T2]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T3]])
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <8 x i64> [[X]] to <8 x i32>
; CHECK-NEXT:    [[T5:%.*]] = shl <8 x i32> [[TMP1]], [[T2]]
; CHECK-NEXT:    ret <8 x i32> [[T5]]
;
  %t0 = zext <8 x i32> %nbits to <8 x i64>
  %t1 = shl <8 x i64> %x, %t0
  %t2 = add <8 x i32> %nbits, <i32 -32, i32 -32, i32 -32, i32 -32, i32 -32, i32 -32, i32 -32, i32 -32>
  %t3 = lshr <8 x i64> %t1, %t0

  call void @use8xi64(<8 x i64> %t0)
  call void @use8xi64(<8 x i64> %t1)
  call void @use8xi32(<8 x i32> %t2)
  call void @use8xi64(<8 x i64> %t3)

  %t4 = trunc <8 x i64> %t3 to <8 x i32>
  %t5 = shl <8 x i32> %t4, %t2
  ret <8 x i32> %t5
}

define <8 x i32> @t2_vec_splat_undef(<8 x i64> %x, <8 x i32> %nbits) {
; CHECK-LABEL: @t2_vec_splat_undef(
; CHECK-NEXT:    [[T0:%.*]] = zext <8 x i32> [[NBITS:%.*]] to <8 x i64>
; CHECK-NEXT:    [[T1:%.*]] = shl <8 x i64> [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add <8 x i32> [[NBITS]], <i32 -32, i32 -32, i32 -32, i32 -32, i32 -32, i32 -32, i32 undef, i32 -32>
; CHECK-NEXT:    [[T3:%.*]] = lshr <8 x i64> [[T1]], [[T0]]
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T0]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T1]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T2]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T3]])
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <8 x i64> [[X]] to <8 x i32>
; CHECK-NEXT:    [[T5:%.*]] = shl <8 x i32> [[TMP1]], [[T2]]
; CHECK-NEXT:    ret <8 x i32> [[T5]]
;
  %t0 = zext <8 x i32> %nbits to <8 x i64>
  %t1 = shl <8 x i64> %x, %t0
  %t2 = add <8 x i32> %nbits, <i32 -32, i32 -32, i32 -32, i32 -32, i32 -32, i32 -32, i32 undef, i32 -32>
  %t3 = lshr <8 x i64> %t1, %t0

  call void @use8xi64(<8 x i64> %t0)
  call void @use8xi64(<8 x i64> %t1)
  call void @use8xi32(<8 x i32> %t2)
  call void @use8xi64(<8 x i64> %t3)

  %t4 = trunc <8 x i64> %t3 to <8 x i32>
  %t5 = shl <8 x i32> %t4, %t2
  ret <8 x i32> %t5
}

define <8 x i32> @t3_vec_nonsplat(<8 x i64> %x, <8 x i32> %nbits) {
; CHECK-LABEL: @t3_vec_nonsplat(
; CHECK-NEXT:    [[T0:%.*]] = zext <8 x i32> [[NBITS:%.*]] to <8 x i64>
; CHECK-NEXT:    [[T1:%.*]] = shl <8 x i64> [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add <8 x i32> [[NBITS]], <i32 -32, i32 -1, i32 0, i32 1, i32 31, i32 32, i32 undef, i32 64>
; CHECK-NEXT:    [[T3:%.*]] = lshr <8 x i64> [[T1]], [[T0]]
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T0]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T1]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T2]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T3]])
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <8 x i64> [[X]] to <8 x i32>
; CHECK-NEXT:    [[T5:%.*]] = shl <8 x i32> [[TMP1]], [[T2]]
; CHECK-NEXT:    ret <8 x i32> [[T5]]
;
  %t0 = zext <8 x i32> %nbits to <8 x i64>
  %t1 = shl <8 x i64> %x, %t0
  %t2 = add <8 x i32> %nbits, <i32 -32, i32 -1, i32 0, i32 1, i32 31, i32 32, i32 undef, i32 64>
  %t3 = lshr <8 x i64> %t1, %t0

  call void @use8xi64(<8 x i64> %t0)
  call void @use8xi64(<8 x i64> %t1)
  call void @use8xi32(<8 x i32> %t2)
  call void @use8xi64(<8 x i64> %t3)

  %t4 = trunc <8 x i64> %t3 to <8 x i32>
  %t5 = shl <8 x i32> %t4, %t2
  ret <8 x i32> %t5
}

; Extra uses.

define i32 @n4_extrause(i64 %x, i32 %nbits) {
; CHECK-LABEL: @n4_extrause(
; CHECK-NEXT:    [[T0:%.*]] = zext i32 [[NBITS:%.*]] to i64
; CHECK-NEXT:    [[T1:%.*]] = shl i64 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[NBITS]], -32
; CHECK-NEXT:    [[T3:%.*]] = lshr i64 [[T1]], [[T0]]
; CHECK-NEXT:    call void @use64(i64 [[T0]])
; CHECK-NEXT:    call void @use64(i64 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use64(i64 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = trunc i64 [[T3]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = shl i32 [[T4]], [[T2]]
; CHECK-NEXT:    ret i32 [[T5]]
;
  %t0 = zext i32 %nbits to i64
  %t1 = shl i64 %x, %t0
  %t2 = add i32 %nbits, -32
  %t3 = lshr i64 %t1, %t0

  call void @use64(i64 %t0)
  call void @use64(i64 %t1)
  call void @use32(i32 %t2)
  call void @use64(i64 %t3)

  %t4 = trunc i64 %t3 to i32
  call void @use32(i32 %t4)
  %t5 = shl i32 %t4, %t2
  ret i32 %t5
}
