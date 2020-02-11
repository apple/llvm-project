; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -mtriple=x86_64-pc-linux -mattr=+fma < %s | FileCheck %s

define <1 x float> @constrained_vector_fma_v1f32() #0 {
; CHECK-LABEL: constrained_vector_fma_v1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vfmadd213ss {{.*#+}} xmm0 = (xmm1 * xmm0) + mem
; CHECK-NEXT:    retq
entry:
  %fma = call <1 x float> @llvm.experimental.constrained.fma.v1f32(
           <1 x float> <float 0.5>,
           <1 x float> <float 2.5>,
           <1 x float> <float 4.5>,
           metadata !"round.dynamic",
           metadata !"fpexcept.strict") #0
  ret <1 x float> %fma
}

define <2 x double> @constrained_vector_fma_v2f64() #0 {
; CHECK-LABEL: constrained_vector_fma_v2f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovapd {{.*#+}} xmm1 = [1.5E+0,5.0E-1]
; CHECK-NEXT:    vmovapd {{.*#+}} xmm0 = [3.5E+0,2.5E+0]
; CHECK-NEXT:    vfmadd213pd {{.*#+}} xmm0 = (xmm1 * xmm0) + mem
; CHECK-NEXT:    retq
entry:
  %fma = call <2 x double> @llvm.experimental.constrained.fma.v2f64(
           <2 x double> <double 1.5, double 0.5>,
           <2 x double> <double 3.5, double 2.5>,
           <2 x double> <double 5.5, double 4.5>,
           metadata !"round.dynamic",
           metadata !"fpexcept.strict") #0
  ret <2 x double> %fma
}

define <3 x float> @constrained_vector_fma_v3f32() #0 {
; CHECK-LABEL: constrained_vector_fma_v3f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    vfmadd213ss {{.*#+}} xmm1 = (xmm0 * xmm1) + mem
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vmovss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; CHECK-NEXT:    vfmadd213ss {{.*#+}} xmm2 = (xmm0 * xmm2) + mem
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vmovss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; CHECK-NEXT:    vfmadd213ss {{.*#+}} xmm3 = (xmm0 * xmm3) + mem
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm2[0],xmm3[0],xmm2[2,3]
; CHECK-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0],xmm0[3]
; CHECK-NEXT:    retq
entry:
  %fma = call <3 x float> @llvm.experimental.constrained.fma.v3f32(
           <3 x float> <float 2.5, float 1.5, float 0.5>,
           <3 x float> <float 5.5, float 4.5, float 3.5>,
           <3 x float> <float 8.5, float 7.5, float 6.5>,
           metadata !"round.dynamic",
           metadata !"fpexcept.strict") #0
  ret <3 x float> %fma
}

define <3 x double> @constrained_vector_fma_v3f64() #0 {
; CHECK-LABEL: constrained_vector_fma_v3f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    vfmadd213sd {{.*#+}} xmm1 = (xmm0 * xmm1) + mem
; CHECK-NEXT:    vmovapd {{.*#+}} xmm0 = [2.5E+0,1.5E+0]
; CHECK-NEXT:    vmovapd {{.*#+}} xmm2 = [5.5E+0,4.5E+0]
; CHECK-NEXT:    vfmadd213pd {{.*#+}} xmm2 = (xmm0 * xmm2) + mem
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm0
; CHECK-NEXT:    retq
entry:
  %fma = call <3 x double> @llvm.experimental.constrained.fma.v3f64(
           <3 x double> <double 2.5, double 1.5, double 0.5>,
           <3 x double> <double 5.5, double 4.5, double 3.5>,
           <3 x double> <double 8.5, double 7.5, double 6.5>,
           metadata !"round.dynamic",
           metadata !"fpexcept.strict") #0
  ret <3 x double> %fma
}

define <4 x double> @constrained_vector_fma_v4f64() #0 {
; CHECK-LABEL: constrained_vector_fma_v4f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovapd {{.*#+}} ymm1 = [3.5E+0,2.5E+0,1.5E+0,5.0E-1]
; CHECK-NEXT:    vmovapd {{.*#+}} ymm0 = [7.5E+0,6.5E+0,5.5E+0,4.5E+0]
; CHECK-NEXT:    vfmadd213pd {{.*#+}} ymm0 = (ymm1 * ymm0) + mem
; CHECK-NEXT:    retq
entry:
  %fma = call <4 x double> @llvm.experimental.constrained.fma.v4f64(
           <4 x double> <double 3.5, double 2.5, double 1.5, double 0.5>,
           <4 x double> <double 7.5, double 6.5, double 5.5, double 4.5>,
           <4 x double> <double 11.5, double 10.5, double 9.5, double 8.5>,
           metadata !"round.dynamic",
           metadata !"fpexcept.strict") #0
  ret <4 x double> %fma
}

define <4 x float> @constrained_vector_fma_v4f32() #0 {
; CHECK-LABEL: constrained_vector_fma_v4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovaps {{.*#+}} xmm1 = [3.5E+0,2.5E+0,1.5E+0,5.0E-1]
; CHECK-NEXT:    vmovaps {{.*#+}} xmm0 = [7.5E+0,6.5E+0,5.5E+0,4.5E+0]
; CHECK-NEXT:    vfmadd213ps {{.*#+}} xmm0 = (xmm1 * xmm0) + mem
; CHECK-NEXT:    retq
entry:
  %fma = call <4 x float> @llvm.experimental.constrained.fma.v4f32(
           <4 x float> <float 3.5, float 2.5, float 1.5, float 0.5>,
           <4 x float> <float 7.5, float 6.5, float 5.5, float 4.5>,
           <4 x float> <float 11.5, float 10.5, float 9.5, float 8.5>,
           metadata !"round.dynamic",
           metadata !"fpexcept.strict") #0
  ret <4 x float> %fma
}

define <8 x float> @constrained_vector_fma_v8f32() #0 {
; CHECK-LABEL: constrained_vector_fma_v8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovaps {{.*#+}} ymm1 = [3.5E+0,2.5E+0,1.5E+0,5.0E-1,7.5E+0,6.5E+0,5.5E+0,4.5E+0]
; CHECK-NEXT:    vmovaps {{.*#+}} ymm0 = [7.5E+0,6.5E+0,5.5E+0,4.5E+0,1.15E+1,1.05E+1,9.5E+0,8.5E+0]
; CHECK-NEXT:    vfmadd213ps {{.*#+}} ymm0 = (ymm1 * ymm0) + mem
; CHECK-NEXT:    retq
entry:
  %fma = call <8 x float> @llvm.experimental.constrained.fma.v8f32(
           <8 x float> <float 3.5, float 2.5, float 1.5, float 0.5,
                        float 7.5, float 6.5, float 5.5, float 4.5>,
           <8 x float> <float 7.5, float 6.5, float 5.5, float 4.5,
                        float 11.5, float 10.5, float 9.5, float 8.5>,
           <8 x float> <float 11.5, float 10.5, float 9.5, float 8.5,
                        float 15.5, float 14.5, float 13.5, float 12.5>,
           metadata !"round.dynamic",
           metadata !"fpexcept.strict") #0
  ret <8 x float> %fma
}

attributes #0 = { strictfp }

; Single width declarations
declare <2 x double> @llvm.experimental.constrained.fma.v2f64(<2 x double>, <2 x double>, <2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fma.v4f32(<4 x float>, <4 x float>, <4 x float>, metadata, metadata)

; Scalar width declarations
declare <1 x float> @llvm.experimental.constrained.fma.v1f32(<1 x float>, <1 x float>, <1 x float>, metadata, metadata)

; Illegal width declarations
declare <3 x float> @llvm.experimental.constrained.fma.v3f32(<3 x float>, <3 x float>, <3 x float>, metadata, metadata)
declare <3 x double> @llvm.experimental.constrained.fma.v3f64(<3 x double>, <3 x double>, <3 x double>, metadata, metadata)

; Double width declarations
declare <4 x double> @llvm.experimental.constrained.fma.v4f64(<4 x double>, <4 x double>, <4 x double>, metadata, metadata)
declare <8 x float> @llvm.experimental.constrained.fma.v8f32(<8 x float>, <8 x float>, <8 x float>, metadata, metadata)
