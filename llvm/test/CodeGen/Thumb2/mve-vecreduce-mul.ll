; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK

define arm_aapcs_vfpcc i32 @mul_v2i32(<2 x i32> %x) {
; CHECK-LABEL: mul_v2i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i32 @llvm.experimental.vector.reduce.mul.v2i32(<2 x i32> %x)
  ret i32 %z
}

define arm_aapcs_vfpcc i32 @mul_v4i32(<4 x i32> %x) {
; CHECK-LABEL: mul_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s3
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i32 @llvm.experimental.vector.reduce.mul.v4i32(<4 x i32> %x)
  ret i32 %z
}

define arm_aapcs_vfpcc i32 @mul_v8i32(<8 x i32> %x) {
; CHECK-LABEL: mul_v8i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i32 q0, q0, q1
; CHECK-NEXT:    vmov r0, s3
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i32 @llvm.experimental.vector.reduce.mul.v8i32(<8 x i32> %x)
  ret i32 %z
}

define arm_aapcs_vfpcc i16 @mul_v4i16(<4 x i16> %x) {
; CHECK-LABEL: mul_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s3
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i16 @llvm.experimental.vector.reduce.mul.v4i16(<4 x i16> %x)
  ret i16 %z
}

define arm_aapcs_vfpcc i16 @mul_v8i16(<8 x i16> %x) {
; CHECK-LABEL: mul_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vrev32.16 q1, q0
; CHECK-NEXT:    vmul.i16 q0, q0, q1
; CHECK-NEXT:    vmov.u16 r0, q0[6]
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    vmov.u16 r1, q0[2]
; CHECK-NEXT:    vmov.u16 r2, q0[0]
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i16 @llvm.experimental.vector.reduce.mul.v8i16(<8 x i16> %x)
  ret i16 %z
}

define arm_aapcs_vfpcc i16 @mul_v16i16(<16 x i16> %x) {
; CHECK-LABEL: mul_v16i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i16 q0, q0, q1
; CHECK-NEXT:    vrev32.16 q1, q0
; CHECK-NEXT:    vmul.i16 q0, q0, q1
; CHECK-NEXT:    vmov.u16 r0, q0[6]
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    vmov.u16 r1, q0[2]
; CHECK-NEXT:    vmov.u16 r2, q0[0]
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i16 @llvm.experimental.vector.reduce.mul.v16i16(<16 x i16> %x)
  ret i16 %z
}

define arm_aapcs_vfpcc i8 @mul_v8i8(<8 x i8> %x) {
; CHECK-LABEL: mul_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vrev32.16 q1, q0
; CHECK-NEXT:    vmul.i16 q0, q0, q1
; CHECK-NEXT:    vmov.u16 r0, q0[6]
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    vmov.u16 r1, q0[2]
; CHECK-NEXT:    vmov.u16 r2, q0[0]
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i8 @llvm.experimental.vector.reduce.mul.v8i8(<8 x i8> %x)
  ret i8 %z
}

define arm_aapcs_vfpcc i8 @mul_v16i8(<16 x i8> %x) {
; CHECK-LABEL: mul_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vrev16.8 q1, q0
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    vrev32.8 q1, q0
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    vmov.u8 r0, q0[12]
; CHECK-NEXT:    vmov.u8 r1, q0[8]
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    vmov.u8 r1, q0[4]
; CHECK-NEXT:    vmov.u8 r2, q0[0]
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i8 @llvm.experimental.vector.reduce.mul.v16i8(<16 x i8> %x)
  ret i8 %z
}

define arm_aapcs_vfpcc i8 @mul_v32i8(<32 x i8> %x) {
; CHECK-LABEL: mul_v32i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    vrev16.8 q1, q0
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    vrev32.8 q1, q0
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    vmov.u8 r0, q0[12]
; CHECK-NEXT:    vmov.u8 r1, q0[8]
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    vmov.u8 r1, q0[4]
; CHECK-NEXT:    vmov.u8 r2, q0[0]
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i8 @llvm.experimental.vector.reduce.mul.v32i8(<32 x i8> %x)
  ret i8 %z
}

define arm_aapcs_vfpcc i64 @mul_v1i64(<1 x i64> %x) {
; CHECK-LABEL: mul_v1i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %z = call i64 @llvm.experimental.vector.reduce.mul.v1i64(<1 x i64> %x)
  ret i64 %z
}

define arm_aapcs_vfpcc i64 @mul_v2i64(<2 x i64> %x) {
; CHECK-LABEL: mul_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov r3, s3
; CHECK-NEXT:    umull r0, r12, r2, r1
; CHECK-NEXT:    mla r2, r2, r3, r12
; CHECK-NEXT:    vmov r3, s1
; CHECK-NEXT:    mla r1, r3, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %z = call i64 @llvm.experimental.vector.reduce.mul.v2i64(<2 x i64> %x)
  ret i64 %z
}

define arm_aapcs_vfpcc i64 @mul_v4i64(<4 x i64> %x) {
; CHECK-LABEL: mul_v4i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, lr}
; CHECK-NEXT:    push.w {r4, r5, r6, r7, r8, lr}
; CHECK-NEXT:    vmov lr, s2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov r1, s4
; CHECK-NEXT:    vmov r6, s6
; CHECK-NEXT:    vmov r5, s7
; CHECK-NEXT:    umull r3, r12, r2, lr
; CHECK-NEXT:    umull r4, r8, r3, r1
; CHECK-NEXT:    umull r0, r7, r4, r6
; CHECK-NEXT:    mla r4, r4, r5, r7
; CHECK-NEXT:    vmov r5, s5
; CHECK-NEXT:    vmov r7, s1
; CHECK-NEXT:    mla r3, r3, r5, r8
; CHECK-NEXT:    vmov r5, s3
; CHECK-NEXT:    mla r2, r2, r5, r12
; CHECK-NEXT:    mla r2, r7, lr, r2
; CHECK-NEXT:    mla r1, r2, r1, r3
; CHECK-NEXT:    mla r1, r1, r6, r4
; CHECK-NEXT:    pop.w {r4, r5, r6, r7, r8, pc}
entry:
  %z = call i64 @llvm.experimental.vector.reduce.mul.v4i64(<4 x i64> %x)
  ret i64 %z
}

define arm_aapcs_vfpcc i32 @mul_v2i32_acc(<2 x i32> %x, i32 %y) {
; CHECK-LABEL: mul_v2i32_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i32 @llvm.experimental.vector.reduce.mul.v2i32(<2 x i32> %x)
  %r = mul i32 %y, %z
  ret i32 %r
}

define arm_aapcs_vfpcc i32 @mul_v4i32_acc(<4 x i32> %x, i32 %y) {
; CHECK-LABEL: mul_v4i32_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    vmov r2, s1
; CHECK-NEXT:    muls r2, r3, r2
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i32 @llvm.experimental.vector.reduce.mul.v4i32(<4 x i32> %x)
  %r = mul i32 %y, %z
  ret i32 %r
}

define arm_aapcs_vfpcc i32 @mul_v8i32_acc(<8 x i32> %x, i32 %y) {
; CHECK-LABEL: mul_v8i32_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i32 q0, q0, q1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    vmov r2, s1
; CHECK-NEXT:    muls r2, r3, r2
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i32 @llvm.experimental.vector.reduce.mul.v8i32(<8 x i32> %x)
  %r = mul i32 %y, %z
  ret i32 %r
}

define arm_aapcs_vfpcc i16 @mul_v4i16_acc(<4 x i16> %x, i16 %y) {
; CHECK-LABEL: mul_v4i16_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    vmov r2, s1
; CHECK-NEXT:    muls r2, r3, r2
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i16 @llvm.experimental.vector.reduce.mul.v4i16(<4 x i16> %x)
  %r = mul i16 %y, %z
  ret i16 %r
}

define arm_aapcs_vfpcc i16 @mul_v8i16_acc(<8 x i16> %x, i16 %y) {
; CHECK-LABEL: mul_v8i16_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vrev32.16 q1, q0
; CHECK-NEXT:    vmul.i16 q0, q0, q1
; CHECK-NEXT:    vmov.u16 r1, q0[6]
; CHECK-NEXT:    vmov.u16 r2, q0[4]
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    vmov.u16 r2, q0[2]
; CHECK-NEXT:    vmov.u16 r3, q0[0]
; CHECK-NEXT:    muls r2, r3, r2
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i16 @llvm.experimental.vector.reduce.mul.v8i16(<8 x i16> %x)
  %r = mul i16 %y, %z
  ret i16 %r
}

define arm_aapcs_vfpcc i16 @mul_v16i16_acc(<16 x i16> %x, i16 %y) {
; CHECK-LABEL: mul_v16i16_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i16 q0, q0, q1
; CHECK-NEXT:    vrev32.16 q1, q0
; CHECK-NEXT:    vmul.i16 q0, q0, q1
; CHECK-NEXT:    vmov.u16 r1, q0[6]
; CHECK-NEXT:    vmov.u16 r2, q0[4]
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    vmov.u16 r2, q0[2]
; CHECK-NEXT:    vmov.u16 r3, q0[0]
; CHECK-NEXT:    muls r2, r3, r2
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i16 @llvm.experimental.vector.reduce.mul.v16i16(<16 x i16> %x)
  %r = mul i16 %y, %z
  ret i16 %r
}

define arm_aapcs_vfpcc i8 @mul_v8i8_acc(<8 x i8> %x, i8 %y) {
; CHECK-LABEL: mul_v8i8_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vrev32.16 q1, q0
; CHECK-NEXT:    vmul.i16 q0, q0, q1
; CHECK-NEXT:    vmov.u16 r1, q0[6]
; CHECK-NEXT:    vmov.u16 r2, q0[4]
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    vmov.u16 r2, q0[2]
; CHECK-NEXT:    vmov.u16 r3, q0[0]
; CHECK-NEXT:    muls r2, r3, r2
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i8 @llvm.experimental.vector.reduce.mul.v8i8(<8 x i8> %x)
  %r = mul i8 %y, %z
  ret i8 %r
}

define arm_aapcs_vfpcc i8 @mul_v16i8_acc(<16 x i8> %x, i8 %y) {
; CHECK-LABEL: mul_v16i8_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vrev16.8 q1, q0
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    vrev32.8 q1, q0
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    vmov.u8 r1, q0[12]
; CHECK-NEXT:    vmov.u8 r2, q0[8]
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    vmov.u8 r2, q0[4]
; CHECK-NEXT:    vmov.u8 r3, q0[0]
; CHECK-NEXT:    muls r2, r3, r2
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i8 @llvm.experimental.vector.reduce.mul.v16i8(<16 x i8> %x)
  %r = mul i8 %y, %z
  ret i8 %r
}

define arm_aapcs_vfpcc i8 @mul_v32i8_acc(<32 x i8> %x, i8 %y) {
; CHECK-LABEL: mul_v32i8_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    vrev16.8 q1, q0
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    vrev32.8 q1, q0
; CHECK-NEXT:    vmul.i8 q0, q0, q1
; CHECK-NEXT:    vmov.u8 r1, q0[12]
; CHECK-NEXT:    vmov.u8 r2, q0[8]
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    vmov.u8 r2, q0[4]
; CHECK-NEXT:    vmov.u8 r3, q0[0]
; CHECK-NEXT:    muls r2, r3, r2
; CHECK-NEXT:    muls r1, r2, r1
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
entry:
  %z = call i8 @llvm.experimental.vector.reduce.mul.v32i8(<32 x i8> %x)
  %r = mul i8 %y, %z
  ret i8 %r
}

define arm_aapcs_vfpcc i64 @mul_v1i64_acc(<1 x i64> %x, i64 %y) {
; CHECK-LABEL: mul_v1i64_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    umull r12, lr, r2, r0
; CHECK-NEXT:    mla r1, r2, r1, lr
; CHECK-NEXT:    mla r1, r3, r0, r1
; CHECK-NEXT:    mov r0, r12
; CHECK-NEXT:    pop {r7, pc}
entry:
  %z = call i64 @llvm.experimental.vector.reduce.mul.v1i64(<1 x i64> %x)
  %r = mul i64 %y, %z
  ret i64 %r
}

define arm_aapcs_vfpcc i64 @mul_v2i64_acc(<2 x i64> %x, i64 %y) {
; CHECK-LABEL: mul_v2i64_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r4, s3
; CHECK-NEXT:    umull r12, lr, r3, r2
; CHECK-NEXT:    mla r3, r3, r4, lr
; CHECK-NEXT:    vmov r4, s1
; CHECK-NEXT:    mla r3, r4, r2, r3
; CHECK-NEXT:    umull r2, r4, r0, r12
; CHECK-NEXT:    mla r0, r0, r3, r4
; CHECK-NEXT:    mla r1, r1, r12, r0
; CHECK-NEXT:    mov r0, r2
; CHECK-NEXT:    pop {r4, pc}
entry:
  %z = call i64 @llvm.experimental.vector.reduce.mul.v2i64(<2 x i64> %x)
  %r = mul i64 %y, %z
  ret i64 %r
}

define arm_aapcs_vfpcc i64 @mul_v4i64_acc(<4 x i64> %x, i64 %y) {
; CHECK-LABEL: mul_v4i64_acc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, r9, r10, lr}
; CHECK-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, lr}
; CHECK-NEXT:    vmov r12, s2
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r4, s4
; CHECK-NEXT:    vmov r7, s6
; CHECK-NEXT:    vmov r6, s7
; CHECK-NEXT:    umull r2, lr, r3, r12
; CHECK-NEXT:    umull r5, r8, r2, r4
; CHECK-NEXT:    umull r10, r9, r5, r7
; CHECK-NEXT:    mla r5, r5, r6, r9
; CHECK-NEXT:    vmov r6, s5
; CHECK-NEXT:    mla r2, r2, r6, r8
; CHECK-NEXT:    vmov r6, s3
; CHECK-NEXT:    mla r3, r3, r6, lr
; CHECK-NEXT:    vmov r6, s1
; CHECK-NEXT:    mla r3, r6, r12, r3
; CHECK-NEXT:    mla r2, r3, r4, r2
; CHECK-NEXT:    mla r3, r2, r7, r5
; CHECK-NEXT:    umull r2, r7, r0, r10
; CHECK-NEXT:    mla r0, r0, r3, r7
; CHECK-NEXT:    mla r1, r1, r10, r0
; CHECK-NEXT:    mov r0, r2
; CHECK-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, pc}
entry:
  %z = call i64 @llvm.experimental.vector.reduce.mul.v4i64(<4 x i64> %x)
  %r = mul i64 %y, %z
  ret i64 %r
}

declare i16 @llvm.experimental.vector.reduce.mul.v16i16(<16 x i16>)
declare i16 @llvm.experimental.vector.reduce.mul.v4i16(<4 x i16>)
declare i16 @llvm.experimental.vector.reduce.mul.v8i16(<8 x i16>)
declare i32 @llvm.experimental.vector.reduce.mul.v2i32(<2 x i32>)
declare i32 @llvm.experimental.vector.reduce.mul.v4i32(<4 x i32>)
declare i32 @llvm.experimental.vector.reduce.mul.v8i32(<8 x i32>)
declare i64 @llvm.experimental.vector.reduce.mul.v1i64(<1 x i64>)
declare i64 @llvm.experimental.vector.reduce.mul.v2i64(<2 x i64>)
declare i64 @llvm.experimental.vector.reduce.mul.v4i64(<4 x i64>)
declare i8 @llvm.experimental.vector.reduce.mul.v16i8(<16 x i8>)
declare i8 @llvm.experimental.vector.reduce.mul.v32i8(<32 x i8>)
declare i8 @llvm.experimental.vector.reduce.mul.v8i8(<8 x i8>)
