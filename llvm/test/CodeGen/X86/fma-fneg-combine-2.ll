; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx,fma | FileCheck %s --check-prefixes=CHECK,FMA3
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx,fma4 | FileCheck %s --check-prefixes=CHECK,FMA4

define float @test_fneg_fma_subx_y_negz_f32(float %w, float %x, float %y, float %z)  {
; FMA3-LABEL: test_fneg_fma_subx_y_negz_f32:
; FMA3:       # %bb.0: # %entry
; FMA3-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; FMA3-NEXT:    vfnmadd213ss {{.*#+}} xmm0 = -(xmm2 * xmm0) + xmm3
; FMA3-NEXT:    retq
;
; FMA4-LABEL: test_fneg_fma_subx_y_negz_f32:
; FMA4:       # %bb.0: # %entry
; FMA4-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; FMA4-NEXT:    vfnmaddss {{.*#+}} xmm0 = -(xmm0 * xmm2) + xmm3
; FMA4-NEXT:    retq
entry:
  %subx = fsub nsz float %w, %x
  %negz = fsub float -0.000000e+00, %z
  %0 = tail call nsz float @llvm.fma.f32(float %subx, float %y, float %negz)
  %1 = fsub float -0.000000e+00, %0
  ret float %1
}

define float @test_fneg_fma_x_suby_negz_f32(float %w, float %x, float %y, float %z)  {
; FMA3-LABEL: test_fneg_fma_x_suby_negz_f32:
; FMA3:       # %bb.0: # %entry
; FMA3-NEXT:    vsubss %xmm2, %xmm0, %xmm0
; FMA3-NEXT:    vfnmadd213ss {{.*#+}} xmm0 = -(xmm1 * xmm0) + xmm3
; FMA3-NEXT:    retq
;
; FMA4-LABEL: test_fneg_fma_x_suby_negz_f32:
; FMA4:       # %bb.0: # %entry
; FMA4-NEXT:    vsubss %xmm2, %xmm0, %xmm0
; FMA4-NEXT:    vfnmaddss {{.*#+}} xmm0 = -(xmm1 * xmm0) + xmm3
; FMA4-NEXT:    retq
entry:
  %suby = fsub nsz float %w, %y
  %negz = fsub float -0.000000e+00, %z
  %0 = tail call nsz float @llvm.fma.f32(float %x, float %suby, float %negz)
  %1 = fsub float -0.000000e+00, %0
  ret float %1
}

define float @test_fneg_fma_subx_suby_negz_f32(float %w, float %x, float %y, float %z)  {
; FMA3-LABEL: test_fneg_fma_subx_suby_negz_f32:
; FMA3:       # %bb.0: # %entry
; FMA3-NEXT:    vsubss %xmm1, %xmm0, %xmm1
; FMA3-NEXT:    vsubss %xmm2, %xmm0, %xmm0
; FMA3-NEXT:    vfnmadd213ss {{.*#+}} xmm0 = -(xmm1 * xmm0) + xmm3
; FMA3-NEXT:    retq
;
; FMA4-LABEL: test_fneg_fma_subx_suby_negz_f32:
; FMA4:       # %bb.0: # %entry
; FMA4-NEXT:    vsubss %xmm1, %xmm0, %xmm1
; FMA4-NEXT:    vsubss %xmm2, %xmm0, %xmm0
; FMA4-NEXT:    vfnmaddss {{.*#+}} xmm0 = -(xmm1 * xmm0) + xmm3
; FMA4-NEXT:    retq
entry:
  %subx = fsub nsz float %w, %x
  %suby = fsub nsz float %w, %y
  %negz = fsub float -0.000000e+00, %z
  %0 = tail call nsz float @llvm.fma.f32(float %subx, float %suby, float %negz)
  %1 = fsub float -0.000000e+00, %0
  ret float %1
}

define float @test_fneg_fma_subx_negy_negz_f32(float %w, float %x, float %y, float %z)  {
; FMA3-LABEL: test_fneg_fma_subx_negy_negz_f32:
; FMA3:       # %bb.0: # %entry
; FMA3-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; FMA3-NEXT:    vfmadd213ss {{.*#+}} xmm0 = (xmm2 * xmm0) + xmm3
; FMA3-NEXT:    retq
;
; FMA4-LABEL: test_fneg_fma_subx_negy_negz_f32:
; FMA4:       # %bb.0: # %entry
; FMA4-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; FMA4-NEXT:    vfmaddss {{.*#+}} xmm0 = (xmm0 * xmm2) + xmm3
; FMA4-NEXT:    retq
entry:
  %subx = fsub nsz float %w, %x
  %negy = fsub float -0.000000e+00, %y
  %negz = fsub float -0.000000e+00, %z
  %0 = tail call nsz float @llvm.fma.f32(float %subx, float %negy, float %negz)
  %1 = fsub float -0.000000e+00, %0
  ret float %1
}

define <4 x float> @test_fma_rcp_fneg_v4f32(<4 x float> %x, <4 x float> %y, <4 x float> %z)  {
; FMA3-LABEL: test_fma_rcp_fneg_v4f32:
; FMA3:       # %bb.0: # %entry
; FMA3-NEXT:    vrcpps %xmm2, %xmm2
; FMA3-NEXT:    vfmsub213ps {{.*#+}} xmm0 = (xmm1 * xmm0) - xmm2
; FMA3-NEXT:    retq
;
; FMA4-LABEL: test_fma_rcp_fneg_v4f32:
; FMA4:       # %bb.0: # %entry
; FMA4-NEXT:    vrcpps %xmm2, %xmm2
; FMA4-NEXT:    vfmsubps {{.*#+}} xmm0 = (xmm0 * xmm1) - xmm2
; FMA4-NEXT:    retq
entry:
  %0 = fneg <4 x float> %z
  %1 = tail call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %0)
  %2 = tail call nsz <4 x float> @llvm.fma.v4f32(<4 x float> %x, <4 x float> %y, <4 x float> %1)
  ret <4 x float> %2
}
declare <4 x float> @llvm.x86.sse.rcp.ps(<4 x float>)

; This would crash while trying getNegatedExpression().

define float @negated_constant(float %x) {
; FMA3-LABEL: negated_constant:
; FMA3:       # %bb.0:
; FMA3-NEXT:    vmulss {{.*}}(%rip), %xmm0, %xmm1
; FMA3-NEXT:    vfnmsub132ss {{.*#+}} xmm0 = -(xmm0 * mem) - xmm1
; FMA3-NEXT:    retq
;
; FMA4-LABEL: negated_constant:
; FMA4:       # %bb.0:
; FMA4-NEXT:    vmulss {{.*}}(%rip), %xmm0, %xmm1
; FMA4-NEXT:    vfnmsubss {{.*#+}} xmm0 = -(xmm0 * mem) - xmm1
; FMA4-NEXT:    retq
  %m = fmul float %x, 42.0
  %fma = call nsz float @llvm.fma.f32(float %x, float -42.0, float %m)
  %nfma = fneg float %fma
  ret float %nfma
}

declare float @llvm.fma.f32(float, float, float)
declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>)
