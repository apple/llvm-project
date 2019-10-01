; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon | FileCheck %s --check-prefix=CHECK

declare half @llvm.experimental.vector.reduce.v2.fadd.f16.v1f16(half, <1 x half>)
declare float @llvm.experimental.vector.reduce.v2.fadd.f32.v1f32(float, <1 x float>)
declare double @llvm.experimental.vector.reduce.v2.fadd.f64.v1f64(double, <1 x double>)
declare fp128 @llvm.experimental.vector.reduce.v2.fadd.f128.v1f128(fp128, <1 x fp128>)

declare float @llvm.experimental.vector.reduce.v2.fadd.f32.v3f32(float, <3 x float>)
declare fp128 @llvm.experimental.vector.reduce.v2.fadd.f128.v2f128(fp128, <2 x fp128>)
declare float @llvm.experimental.vector.reduce.v2.fadd.f32.v16f32(float, <16 x float>)

define half @test_v1f16(<1 x half> %a) nounwind {
; CHECK-LABEL: test_v1f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %b = call fast nnan half @llvm.experimental.vector.reduce.v2.fadd.f16.v1f16(half 0.0, <1 x half> %a)
  ret half %b
}

define float @test_v1f32(<1 x float> %a) nounwind {
; CHECK-LABEL: test_v1f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    // kill: def $s0 killed $s0 killed $q0
; CHECK-NEXT:    ret
  %b = call fast nnan float @llvm.experimental.vector.reduce.v2.fadd.f32.v1f32(float 0.0, <1 x float> %a)
  ret float %b
}

define double @test_v1f64(<1 x double> %a) nounwind {
; CHECK-LABEL: test_v1f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %b = call fast nnan double @llvm.experimental.vector.reduce.v2.fadd.f64.v1f64(double 0.0, <1 x double> %a)
  ret double %b
}

define fp128 @test_v1f128(<1 x fp128> %a) nounwind {
; CHECK-LABEL: test_v1f128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %b = call fast nnan fp128 @llvm.experimental.vector.reduce.v2.fadd.f128.v1f128(fp128 zeroinitializer, <1 x fp128> %a)
  ret fp128 %b
}

define float @test_v3f32(<3 x float> %a) nounwind {
; CHECK-LABEL: test_v3f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov s1, wzr
; CHECK-NEXT:    mov v0.s[3], v1.s[0]
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    fadd v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
  %b = call fast nnan float @llvm.experimental.vector.reduce.v2.fadd.f32.v3f32(float 0.0, <3 x float> %a)
  ret float %b
}

define fp128 @test_v2f128(<2 x fp128> %a) nounwind {
; CHECK-LABEL: test_v2f128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    bl __addtf3
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %b = call fast nnan fp128 @llvm.experimental.vector.reduce.v2.fadd.f128.v2f128(fp128 zeroinitializer, <2 x fp128> %a)
  ret fp128 %b
}

define float @test_v16f32(<16 x float> %a) nounwind {
; CHECK-LABEL: test_v16f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fadd v1.4s, v1.4s, v3.4s
; CHECK-NEXT:    fadd v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    fadd v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    fadd v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
  %b = call fast nnan float @llvm.experimental.vector.reduce.v2.fadd.f32.v16f32(float 0.0, <16 x float> %a)
  ret float %b
}
