; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mtriple=armv8.6a-arm-none-eabi -mattr=+neon,+bf16,+fullfp16 | FileCheck %s

declare bfloat @llvm.arm.neon.vcvtbfp2bf(float)

; Hard float ABI
declare <4 x bfloat> @llvm.arm.neon.vcvtfp2bf.v4bf16(<4 x float>)

define arm_aapcs_vfpcc <4 x bfloat> @test_vcvt_bf16_f32_hardfp(<4 x float> %a) {
; CHECK-LABEL: test_vcvt_bf16_f32_hardfp:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvt.bf16.f32 d0, q0
; CHECK-NEXT:    bx lr
entry:
  %vcvtfp2bf1.i.i = call <4 x bfloat> @llvm.arm.neon.vcvtfp2bf.v4bf16(<4 x float> %a)
  ret <4 x bfloat> %vcvtfp2bf1.i.i
}

define arm_aapcs_vfpcc bfloat @test_vcvth_bf16_f32_hardfp(float %a) {
; CHECK-LABEL: test_vcvth_bf16_f32_hardfp:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vcvtb.bf16.f32 s0, s0
; CHECK-NEXT:    bx lr
entry:
  %vcvtbfp2bf.i = call bfloat @llvm.arm.neon.vcvtbfp2bf(float %a)
  ret bfloat %vcvtbfp2bf.i
}

; Soft float ABI
declare <4 x i16> @llvm.arm.neon.vcvtfp2bf.v4i16(<4 x float>)

define <2 x i32> @test_vcvt_bf16_f32_softfp(<4 x float> %a) {
; CHECK-LABEL: test_vcvt_bf16_f32_softfp:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d17, r2, r3
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vcvt.bf16.f32 d16, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    bx lr
entry:
  %vcvtfp2bf1.i.i = call <4 x i16> @llvm.arm.neon.vcvtfp2bf.v4i16(<4 x float> %a)
  %.cast = bitcast <4 x i16> %vcvtfp2bf1.i.i to <2 x i32>
  ret <2 x i32> %.cast
}

define bfloat @test_vcvth_bf16_f32_softfp(float %a) #1 {
; CHECK-LABEL: test_vcvth_bf16_f32_softfp:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov s0, r0
; CHECK-NEXT:    vcvtb.bf16.f32 s0, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %vcvtbfp2bf.i = call bfloat @llvm.arm.neon.vcvtbfp2bf(float %a) #3
  ret bfloat %vcvtbfp2bf.i
}
