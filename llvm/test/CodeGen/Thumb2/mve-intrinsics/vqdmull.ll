; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -verify-machineinstrs -o - %s | FileCheck %s

declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32)

declare <4 x i32> @llvm.arm.mve.vqdmull.v4i32.v8i16(<8 x i16>, <8 x i16>, i32)
declare <2 x i64> @llvm.arm.mve.vqdmull.v2i64.v4i32(<4 x i32>, <4 x i32>, i32)
declare <4 x i32> @llvm.arm.mve.vqdmull.predicated.v4i32.v8i16.v4i1(<8 x i16>, <8 x i16>, i32, <4 x i1>, <4 x i32>)
declare <2 x i64> @llvm.arm.mve.vqdmull.predicated.v2i64.v4i32.v4i1(<4 x i32>, <4 x i32>, i32, <4 x i1>, <2 x i64>)

define arm_aapcs_vfpcc <4 x i32> @test_vqdmullbq_s16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test_vqdmullbq_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqdmullb.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.arm.mve.vqdmull.v4i32.v8i16(<8 x i16> %a, <8 x i16> %b, i32 0)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @test_vqdmullbq_s32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vqdmullbq_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqdmullb.s32 q2, q0, q1
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <2 x i64> @llvm.arm.mve.vqdmull.v2i64.v4i32(<4 x i32> %a, <4 x i32> %b, i32 0)
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vqdmullbq_m_s16(<4 x i32> %inactive, <8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vqdmullbq_m_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vqdmullbt.s16 q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vqdmull.predicated.v4i32.v8i16.v4i1(<8 x i16> %a, <8 x i16> %b, i32 0, <4 x i1> %1, <4 x i32> %inactive)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <2 x i64> @test_vqdmullbq_m_s32(<2 x i64> %inactive, <4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vqdmullbq_m_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vqdmullbt.s32 q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <2 x i64> @llvm.arm.mve.vqdmull.predicated.v2i64.v4i32.v4i1(<4 x i32> %a, <4 x i32> %b, i32 0, <4 x i1> %1, <2 x i64> %inactive)
  ret <2 x i64> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vqdmullbq_n_s16(<8 x i16> %a, i16 signext %b) {
; CHECK-LABEL: test_vqdmullbq_n_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqdmullb.s16 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <8 x i16> undef, i16 %b, i32 0
  %.splat = shufflevector <8 x i16> %.splatinsert, <8 x i16> undef, <8 x i32> zeroinitializer
  %0 = call <4 x i32> @llvm.arm.mve.vqdmull.v4i32.v8i16(<8 x i16> %a, <8 x i16> %.splat, i32 0)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @test_vqdmullbq_n_s32(<4 x i32> %a, i32 %b) #0 {
; CHECK-LABEL: test_vqdmullbq_n_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqdmullb.s32 q1, q0, r0
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <4 x i32> undef, i32 %b, i32 0
  %.splat = shufflevector <4 x i32> %.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %0 = call <2 x i64> @llvm.arm.mve.vqdmull.v2i64.v4i32(<4 x i32> %a, <4 x i32> %.splat, i32 0)
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vqdmullbq_m_n_s16(<4 x i32> %inactive, <8 x i16> %a, i16 signext %b, i16 zeroext %p) {
; CHECK-LABEL: test_vqdmullbq_m_n_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vqdmullbt.s16 q0, q1, r0
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <8 x i16> undef, i16 %b, i32 0
  %.splat = shufflevector <8 x i16> %.splatinsert, <8 x i16> undef, <8 x i32> zeroinitializer
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vqdmull.predicated.v4i32.v8i16.v4i1(<8 x i16> %a, <8 x i16> %.splat, i32 0, <4 x i1> %1, <4 x i32> %inactive)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <2 x i64> @test_vqdmullbq_m_n_s32(<2 x i64> %inactive, <4 x i32> %a, i32 %b, i16 zeroext %p) {
; CHECK-LABEL: test_vqdmullbq_m_n_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vqdmullbt.s32 q0, q1, r0
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <4 x i32> undef, i32 %b, i32 0
  %.splat = shufflevector <4 x i32> %.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <2 x i64> @llvm.arm.mve.vqdmull.predicated.v2i64.v4i32.v4i1(<4 x i32> %a, <4 x i32> %.splat, i32 0, <4 x i1> %1, <2 x i64> %inactive)
  ret <2 x i64> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vqdmulltq_s16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: test_vqdmulltq_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqdmullt.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.arm.mve.vqdmull.v4i32.v8i16(<8 x i16> %a, <8 x i16> %b, i32 1)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @test_vqdmulltq_s32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test_vqdmulltq_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqdmullt.s32 q2, q0, q1
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = call <2 x i64> @llvm.arm.mve.vqdmull.v2i64.v4i32(<4 x i32> %a, <4 x i32> %b, i32 1)
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vqdmulltq_m_s16(<4 x i32> %inactive, <8 x i16> %a, <8 x i16> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vqdmulltq_m_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vqdmulltt.s16 q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vqdmull.predicated.v4i32.v8i16.v4i1(<8 x i16> %a, <8 x i16> %b, i32 1, <4 x i1> %1, <4 x i32> %inactive)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <2 x i64> @test_vqdmulltq_m_s32(<2 x i64> %inactive, <4 x i32> %a, <4 x i32> %b, i16 zeroext %p) {
; CHECK-LABEL: test_vqdmulltq_m_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vqdmulltt.s32 q0, q1, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <2 x i64> @llvm.arm.mve.vqdmull.predicated.v2i64.v4i32.v4i1(<4 x i32> %a, <4 x i32> %b, i32 1, <4 x i1> %1, <2 x i64> %inactive)
  ret <2 x i64> %2
}

define arm_aapcs_vfpcc <4 x i32> @test_vqdmulltq_n_s16(<8 x i16> %a, i16 signext %b) {
; CHECK-LABEL: test_vqdmulltq_n_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqdmullt.s16 q0, q0, r0
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <8 x i16> undef, i16 %b, i32 0
  %.splat = shufflevector <8 x i16> %.splatinsert, <8 x i16> undef, <8 x i32> zeroinitializer
  %0 = call <4 x i32> @llvm.arm.mve.vqdmull.v4i32.v8i16(<8 x i16> %a, <8 x i16> %.splat, i32 1)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @test_vqdmulltq_n_s32(<4 x i32> %a, i32 %b) {
; CHECK-LABEL: test_vqdmulltq_n_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqdmullt.s32 q1, q0, r0
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <4 x i32> undef, i32 %b, i32 0
  %.splat = shufflevector <4 x i32> %.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %0 = call <2 x i64> @llvm.arm.mve.vqdmull.v2i64.v4i32(<4 x i32> %a, <4 x i32> %.splat, i32 1)
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <4 x i32> @test_vqdmulltq_m_n_s16(<4 x i32> %inactive, <8 x i16> %a, i16 signext %b, i16 zeroext %p) {
; CHECK-LABEL: test_vqdmulltq_m_n_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vqdmulltt.s16 q0, q1, r0
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <8 x i16> undef, i16 %b, i32 0
  %.splat = shufflevector <8 x i16> %.splatinsert, <8 x i16> undef, <8 x i32> zeroinitializer
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <4 x i32> @llvm.arm.mve.vqdmull.predicated.v4i32.v8i16.v4i1(<8 x i16> %a, <8 x i16> %.splat, i32 1, <4 x i1> %1, <4 x i32> %inactive)
  ret <4 x i32> %2
}

define arm_aapcs_vfpcc <2 x i64> @test_vqdmulltq_m_n_s32(<2 x i64> %inactive, <4 x i32> %a, i32 %b, i16 zeroext %p) {
; CHECK-LABEL: test_vqdmulltq_m_n_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vqdmulltt.s32 q0, q1, r0
; CHECK-NEXT:    bx lr
entry:
  %.splatinsert = insertelement <4 x i32> undef, i32 %b, i32 0
  %.splat = shufflevector <4 x i32> %.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %0 = zext i16 %p to i32
  %1 = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %0)
  %2 = call <2 x i64> @llvm.arm.mve.vqdmull.predicated.v2i64.v4i32.v4i1(<4 x i32> %a, <4 x i32> %.splat, i32 1, <4 x i1> %1, <2 x i64> %inactive)
  ret <2 x i64> %2
}
