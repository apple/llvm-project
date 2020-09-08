; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2            | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3           | FileCheck %s --check-prefixes=SSE,SSSE3,SSSE3-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3,fast-hops | FileCheck %s --check-prefixes=SSE,SSSE3,SSSE3-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx             | FileCheck %s --check-prefixes=AVX,AVX1,AVX1-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx,fast-hops   | FileCheck %s --check-prefixes=AVX,AVX1,AVX1-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2            | FileCheck %s --check-prefixes=AVX,AVX2

; PR37890 - subvector reduction followed by shuffle reduction

define i32 @PR37890_v4i32(<4 x i32> %a)  {
; SSE2-LABEL: PR37890_v4i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR37890_v4i32:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSSE3-SLOW-NEXT:    paddd %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSSE3-SLOW-NEXT:    paddd %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR37890_v4i32:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSSE3-FAST-NEXT:    movd %xmm0, %eax
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR37890_v4i32:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX1-SLOW-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX1-SLOW-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR37890_v4i32:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vmovd %xmm0, %eax
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR37890_v4i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    retq
  %hi0 = shufflevector <4 x i32> %a, <4 x i32> undef, <2 x i32> <i32 2, i32 3>
  %lo0 = shufflevector <4 x i32> %a, <4 x i32> undef, <2 x i32> <i32 0, i32 1>
  %sum0 = add <2 x i32> %lo0, %hi0
  %hi1 = shufflevector <2 x i32> %sum0, <2 x i32> undef, <2 x i32> <i32 1, i32 undef>
  %sum1 = add <2 x i32> %sum0, %hi1
  %e = extractelement <2 x i32> %sum1, i32 0
  ret i32 %e
}

define i16 @PR37890_v8i16(<8 x i16> %a)  {
; SSE2-LABEL: PR37890_v8i16:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE2-NEXT:    paddw %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSE2-NEXT:    paddw %xmm1, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    psrld $16, %xmm1
; SSE2-NEXT:    paddw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR37890_v8i16:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSSE3-SLOW-NEXT:    paddw %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSSE3-SLOW-NEXT:    paddw %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movdqa %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    psrld $16, %xmm1
; SSSE3-SLOW-NEXT:    paddw %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    movd %xmm1, %eax
; SSSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR37890_v8i16:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSSE3-FAST-NEXT:    movd %xmm0, %eax
; SSSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR37890_v8i16:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX1-SLOW-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX1-SLOW-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpsrld $16, %xmm0, %xmm1
; AVX1-SLOW-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX1-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR37890_v8i16:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vmovd %xmm0, %eax
; AVX1-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR37890_v8i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX2-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpsrld $16, %xmm0, %xmm1
; AVX2-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX2-NEXT:    retq
  %hi0 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %lo0 = shufflevector <8 x i16> %a, <8 x i16> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %sum0 = add <4 x i16> %lo0, %hi0
  %hi1 = shufflevector <4 x i16> %sum0, <4 x i16> undef, <2 x i32> <i32 2, i32 3>
  %lo1 = shufflevector <4 x i16> %sum0, <4 x i16> undef, <2 x i32> <i32 0, i32 1>
  %sum1 = add <2 x i16> %lo1, %hi1
  %hi2 = shufflevector <2 x i16> %sum1, <2 x i16> undef, <2 x i32> <i32 1, i32 undef>
  %sum2 = add <2 x i16> %sum1, %hi2
  %e = extractelement <2 x i16> %sum2, i32 0
  ret i16 %e
}

define i32 @PR37890_v8i32(<8 x i32> %a)  {
; SSE2-LABEL: PR37890_v8i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR37890_v8i32:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    paddd %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSSE3-SLOW-NEXT:    paddd %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSSE3-SLOW-NEXT:    paddd %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR37890_v8i32:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    paddd %xmm1, %xmm0
; SSSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSSE3-FAST-NEXT:    movd %xmm0, %eax
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR37890_v8i32:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-SLOW-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX1-SLOW-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX1-SLOW-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX1-SLOW-NEXT:    vzeroupper
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR37890_v8i32:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-FAST-NEXT:    vphaddd %xmm0, %xmm1, %xmm0
; AVX1-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vmovd %xmm0, %eax
; AVX1-FAST-NEXT:    vzeroupper
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR37890_v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %hi0 = shufflevector <8 x i32> %a, <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %lo0 = shufflevector <8 x i32> %a, <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %sum0 = add <4 x i32> %lo0, %hi0
  %hi1 = shufflevector <4 x i32> %sum0, <4 x i32> undef, <2 x i32> <i32 2, i32 3>
  %lo1 = shufflevector <4 x i32> %sum0, <4 x i32> undef, <2 x i32> <i32 0, i32 1>
  %sum1 = add <2 x i32> %lo1, %hi1
  %hi2 = shufflevector <2 x i32> %sum1, <2 x i32> undef, <2 x i32> <i32 1, i32 undef>
  %sum2 = add <2 x i32> %sum1, %hi2
  %e = extractelement <2 x i32> %sum2, i32 0
  ret i32 %e
}

define i16 @PR37890_v16i16(<16 x i16> %a)  {
; SSE2-LABEL: PR37890_v16i16:
; SSE2:       # %bb.0:
; SSE2-NEXT:    paddw %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE2-NEXT:    paddw %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSE2-NEXT:    paddw %xmm1, %xmm0
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    psrld $16, %xmm1
; SSE2-NEXT:    paddw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR37890_v16i16:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    paddw %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSSE3-SLOW-NEXT:    paddw %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSSE3-SLOW-NEXT:    paddw %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    movdqa %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    psrld $16, %xmm1
; SSSE3-SLOW-NEXT:    paddw %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    movd %xmm1, %eax
; SSSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR37890_v16i16:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    paddw %xmm1, %xmm0
; SSSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSSE3-FAST-NEXT:    movd %xmm0, %eax
; SSSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR37890_v16i16:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-SLOW-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX1-SLOW-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX1-SLOW-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpsrld $16, %xmm0, %xmm1
; AVX1-SLOW-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX1-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX1-SLOW-NEXT:    vzeroupper
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR37890_v16i16:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-FAST-NEXT:    vphaddw %xmm0, %xmm1, %xmm0
; AVX1-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vmovd %xmm0, %eax
; AVX1-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX1-FAST-NEXT:    vzeroupper
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR37890_v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX2-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpsrld $16, %xmm0, %xmm1
; AVX2-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %hi0 = shufflevector <16 x i16> %a, <16 x i16> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %lo0 = shufflevector <16 x i16> %a, <16 x i16> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %sum0 = add <8 x i16> %lo0, %hi0
  %hi1 = shufflevector <8 x i16> %sum0, <8 x i16> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %lo1 = shufflevector <8 x i16> %sum0, <8 x i16> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %sum1 = add <4 x i16> %lo1, %hi1
  %hi2 = shufflevector <4 x i16> %sum1, <4 x i16> undef, <2 x i32> <i32 2, i32 3>
  %lo2 = shufflevector <4 x i16> %sum1, <4 x i16> undef, <2 x i32> <i32 0, i32 1>
  %sum2 = add <2 x i16> %lo2, %hi2
  %hi3 = shufflevector <2 x i16> %sum2, <2 x i16> undef, <2 x i32> <i32 1, i32 undef>
  %sum3 = add <2 x i16> %sum2, %hi3
  %e = extractelement <2 x i16> %sum3, i32 0
  ret i16 %e
}

define i32 @PR37890_v16i32(<16 x i32> %a)  {
; SSE2-LABEL: PR37890_v16i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    paddd %xmm3, %xmm1
; SSE2-NEXT:    paddd %xmm2, %xmm1
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,0,1]
; SSE2-NEXT:    paddd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; SSE2-NEXT:    paddd %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; SSSE3-SLOW-LABEL: PR37890_v16i32:
; SSSE3-SLOW:       # %bb.0:
; SSSE3-SLOW-NEXT:    paddd %xmm3, %xmm1
; SSSE3-SLOW-NEXT:    paddd %xmm2, %xmm1
; SSSE3-SLOW-NEXT:    paddd %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,0,1]
; SSSE3-SLOW-NEXT:    paddd %xmm1, %xmm0
; SSSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; SSSE3-SLOW-NEXT:    paddd %xmm0, %xmm1
; SSSE3-SLOW-NEXT:    movd %xmm1, %eax
; SSSE3-SLOW-NEXT:    retq
;
; SSSE3-FAST-LABEL: PR37890_v16i32:
; SSSE3-FAST:       # %bb.0:
; SSSE3-FAST-NEXT:    paddd %xmm3, %xmm1
; SSSE3-FAST-NEXT:    paddd %xmm2, %xmm1
; SSSE3-FAST-NEXT:    paddd %xmm0, %xmm1
; SSSE3-FAST-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,0,1]
; SSSE3-FAST-NEXT:    paddd %xmm1, %xmm0
; SSSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSSE3-FAST-NEXT:    movd %xmm0, %eax
; SSSE3-FAST-NEXT:    retq
;
; AVX1-SLOW-LABEL: PR37890_v16i32:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-SLOW-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-SLOW-NEXT:    vpaddd %xmm2, %xmm3, %xmm2
; AVX1-SLOW-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX1-SLOW-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX1-SLOW-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX1-SLOW-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX1-SLOW-NEXT:    vzeroupper
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: PR37890_v16i32:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vpaddd %xmm1, %xmm0, %xmm2
; AVX1-FAST-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-FAST-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-FAST-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vphaddd %xmm2, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vmovd %xmm0, %eax
; AVX1-FAST-NEXT:    vzeroupper
; AVX1-FAST-NEXT:    retq
;
; AVX2-LABEL: PR37890_v16i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %hi0 = shufflevector <16 x i32> %a, <16 x i32> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %lo0 = shufflevector <16 x i32> %a, <16 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %sum0 = add <8 x i32> %lo0, %hi0
  %hi1 = shufflevector <8 x i32> %sum0, <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %lo1 = shufflevector <8 x i32> %sum0, <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %sum1 = add <4 x i32> %lo1, %hi1
  %hi2 = shufflevector <4 x i32> %sum1, <4 x i32> undef, <2 x i32> <i32 2, i32 3>
  %lo2 = shufflevector <4 x i32> %sum1, <4 x i32> undef, <2 x i32> <i32 0, i32 1>
  %sum2 = add <2 x i32> %lo2, %hi2
  %hi3 = shufflevector <2 x i32> %sum2, <2 x i32> undef, <2 x i32> <i32 1, i32 undef>
  %sum3 = add <2 x i32> %sum2, %hi3
  %e = extractelement <2 x i32> %sum3, i32 0
  ret i32 %e
}
