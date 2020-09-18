; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --verify-machineinstrs -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve %s -o - | FileCheck %s -check-prefix=CHECK --check-prefix=CHECK-MVE
; RUN: llc --verify-machineinstrs -mtriple=thumbv8.1m.main-none-eabi -mattr=+dsp %s -o - | FileCheck %s -check-prefix=CHECK --check-prefix=CHECK-NOMVE

define void @test1(i32* %p0, i32 *%p1, i32 *%p2, i32 *%pDst) {
; CHECK-LABEL: test1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldr r1, [r1]
; CHECK-NEXT:    ldr r2, [r2]
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    smmul r1, r2, r1
; CHECK-NEXT:    add.w r0, r0, r1, lsl #1
; CHECK-NEXT:    str r0, [r3]
; CHECK-NEXT:    bx lr
entry:
  %l3 = load i32, i32* %p0, align 4
  %l4 = load i32, i32* %p1, align 4
  %conv5.us = sext i32 %l4 to i64
  %l5 = load i32, i32* %p2, align 4
  %conv6.us = sext i32 %l5 to i64
  %mul.us = mul nsw i64 %conv6.us, %conv5.us
  %l6 = lshr i64 %mul.us, 31
  %l7 = trunc i64 %l6 to i32
  %shl.us = and i32 %l7, -2
  %add.us = add nsw i32 %shl.us, %l3
  store i32 %add.us, i32* %pDst, align 4
  ret void
}

define void @test2(i32* %p0, i32 *%p1, i32 *%p2, i32 *%pDst) {
; CHECK-LABEL: test2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldr r1, [r1]
; CHECK-NEXT:    ldr r2, [r2]
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    smmul r1, r2, r1
; CHECK-NEXT:    add.w r0, r0, r1, lsl #1
; CHECK-NEXT:    str r0, [r3]
; CHECK-NEXT:    bx lr
entry:
  %l3 = load i32, i32* %p0, align 4
  %l4 = load i32, i32* %p1, align 4
  %conv5.us = sext i32 %l4 to i64
  %l5 = load i32, i32* %p2, align 4
  %conv6.us = sext i32 %l5 to i64
  %mul.us = mul nsw i64 %conv6.us, %conv5.us
  %l6 = lshr i64 %mul.us, 32
  %shl74.us = shl nuw nsw i64 %l6, 1
  %shl.us = trunc i64 %shl74.us to i32
  %add.us = add nsw i32 %l3, %shl.us
  store i32 %add.us, i32* %pDst, align 4
  ret void
}
