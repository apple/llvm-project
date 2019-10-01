; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512ifma --show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512ifma --show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X64

declare <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64>, <8 x i64>, <8 x i64>, i8)

define <8 x i64>@test_int_x86_avx512_mask_vpmadd52h_uq_512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpmadd52h_uq_512:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm3 # encoding: [0x62,0xf2,0xf5,0x48,0xb5,0xda]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax # encoding: [0x0f,0xb6,0x44,0x24,0x04]
; X86-NEXT:    kmovw %eax, %k1 # encoding: [0xc5,0xf8,0x92,0xc8]
; X86-NEXT:    vmovdqa64 %zmm0, %zmm4 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xe0]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm4 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb5,0xe2]
; X86-NEXT:    vpxor %xmm2, %xmm2, %xmm2 # encoding: [0xc5,0xe9,0xef,0xd2]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb5,0xc2]
; X86-NEXT:    vpaddq %zmm0, %zmm4, %zmm0 # encoding: [0x62,0xf1,0xdd,0x48,0xd4,0xc0]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm2 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0xd2]
; X86-NEXT:    vpaddq %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0xed,0x48,0xd4,0xc0]
; X86-NEXT:    vpaddq %zmm0, %zmm3, %zmm0 # encoding: [0x62,0xf1,0xe5,0x48,0xd4,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpmadd52h_uq_512:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X64-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm3 # encoding: [0x62,0xf2,0xf5,0x48,0xb5,0xda]
; X64-NEXT:    kmovw %edi, %k1 # encoding: [0xc5,0xf8,0x92,0xcf]
; X64-NEXT:    vmovdqa64 %zmm0, %zmm4 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xe0]
; X64-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm4 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb5,0xe2]
; X64-NEXT:    vpxor %xmm2, %xmm2, %xmm2 # encoding: [0xc5,0xe9,0xef,0xd2]
; X64-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb5,0xc2]
; X64-NEXT:    vpaddq %zmm0, %zmm4, %zmm0 # encoding: [0x62,0xf1,0xdd,0x48,0xd4,0xc0]
; X64-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm2 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0xd2]
; X64-NEXT:    vpaddq %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0xed,0x48,0xd4,0xc0]
; X64-NEXT:    vpaddq %zmm0, %zmm3, %zmm0 # encoding: [0x62,0xf1,0xe5,0x48,0xd4,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]

  %res = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> zeroinitializer, i8 %x3)
  %res2 = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> zeroinitializer, <8 x i64> %x1, <8 x i64> zeroinitializer, i8 %x3)
  %res3 = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 -1)
  %res4 = add <8 x i64> %res, %res1
  %res5 = add <8 x i64> %res3, %res2
  %res6 = add <8 x i64> %res5, %res4
  ret <8 x i64> %res6
}

declare <8 x i64> @llvm.x86.avx512.maskz.vpmadd52h.uq.512(<8 x i64>, <8 x i64>, <8 x i64>, i8)

define <8 x i64>@test_int_x86_avx512_maskz_vpmadd52h_uq_512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_maskz_vpmadd52h_uq_512:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm3 # encoding: [0x62,0xf2,0xf5,0x48,0xb5,0xda]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax # encoding: [0x0f,0xb6,0x44,0x24,0x04]
; X86-NEXT:    kmovw %eax, %k1 # encoding: [0xc5,0xf8,0x92,0xc8]
; X86-NEXT:    vmovdqa64 %zmm0, %zmm4 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xe0]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm4 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0xe2]
; X86-NEXT:    vpxor %xmm2, %xmm2, %xmm2 # encoding: [0xc5,0xe9,0xef,0xd2]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0xc2]
; X86-NEXT:    vpaddq %zmm0, %zmm4, %zmm0 # encoding: [0x62,0xf1,0xdd,0x48,0xd4,0xc0]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm2 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0xd2]
; X86-NEXT:    vpaddq %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0xed,0x48,0xd4,0xc0]
; X86-NEXT:    vpaddq %zmm0, %zmm3, %zmm0 # encoding: [0x62,0xf1,0xe5,0x48,0xd4,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_maskz_vpmadd52h_uq_512:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X64-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm3 # encoding: [0x62,0xf2,0xf5,0x48,0xb5,0xda]
; X64-NEXT:    kmovw %edi, %k1 # encoding: [0xc5,0xf8,0x92,0xcf]
; X64-NEXT:    vmovdqa64 %zmm0, %zmm4 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xe0]
; X64-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm4 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0xe2]
; X64-NEXT:    vpxor %xmm2, %xmm2, %xmm2 # encoding: [0xc5,0xe9,0xef,0xd2]
; X64-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0xc2]
; X64-NEXT:    vpaddq %zmm0, %zmm4, %zmm0 # encoding: [0x62,0xf1,0xdd,0x48,0xd4,0xc0]
; X64-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm2 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0xd2]
; X64-NEXT:    vpaddq %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0xed,0x48,0xd4,0xc0]
; X64-NEXT:    vpaddq %zmm0, %zmm3, %zmm0 # encoding: [0x62,0xf1,0xe5,0x48,0xd4,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]

  %res = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  %res1 = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> zeroinitializer, i8 %x3)
  %res2 = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52h.uq.512(<8 x i64> zeroinitializer, <8 x i64> %x1, <8 x i64> zeroinitializer, i8 %x3)
  %res3 = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 -1)
  %res4 = add <8 x i64> %res, %res1
  %res5 = add <8 x i64> %res3, %res2
  %res6 = add <8 x i64> %res5, %res4
  ret <8 x i64> %res6
}

declare <8 x i64> @llvm.x86.avx512.mask.vpmadd52l.uq.512(<8 x i64>, <8 x i64>, <8 x i64>, i8)

define <8 x i64>@test_int_x86_avx512_mask_vpmadd52l_uq_512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpmadd52l_uq_512:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X86-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm3 # encoding: [0x62,0xf2,0xf5,0x48,0xb4,0xda]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax # encoding: [0x0f,0xb6,0x44,0x24,0x04]
; X86-NEXT:    kmovw %eax, %k1 # encoding: [0xc5,0xf8,0x92,0xc8]
; X86-NEXT:    vmovdqa64 %zmm0, %zmm4 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xe0]
; X86-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm4 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb4,0xe2]
; X86-NEXT:    vpxor %xmm2, %xmm2, %xmm2 # encoding: [0xc5,0xe9,0xef,0xd2]
; X86-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb4,0xc2]
; X86-NEXT:    vpaddq %zmm0, %zmm4, %zmm0 # encoding: [0x62,0xf1,0xdd,0x48,0xd4,0xc0]
; X86-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm2 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb4,0xd2]
; X86-NEXT:    vpaddq %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0xed,0x48,0xd4,0xc0]
; X86-NEXT:    vpaddq %zmm0, %zmm3, %zmm0 # encoding: [0x62,0xf1,0xe5,0x48,0xd4,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpmadd52l_uq_512:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X64-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm3 # encoding: [0x62,0xf2,0xf5,0x48,0xb4,0xda]
; X64-NEXT:    kmovw %edi, %k1 # encoding: [0xc5,0xf8,0x92,0xcf]
; X64-NEXT:    vmovdqa64 %zmm0, %zmm4 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xe0]
; X64-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm4 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb4,0xe2]
; X64-NEXT:    vpxor %xmm2, %xmm2, %xmm2 # encoding: [0xc5,0xe9,0xef,0xd2]
; X64-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb4,0xc2]
; X64-NEXT:    vpaddq %zmm0, %zmm4, %zmm0 # encoding: [0x62,0xf1,0xdd,0x48,0xd4,0xc0]
; X64-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm2 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb4,0xd2]
; X64-NEXT:    vpaddq %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0xed,0x48,0xd4,0xc0]
; X64-NEXT:    vpaddq %zmm0, %zmm3, %zmm0 # encoding: [0x62,0xf1,0xe5,0x48,0xd4,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]

  %res = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52l.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52l.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> zeroinitializer, i8 %x3)
  %res2 = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52l.uq.512(<8 x i64> zeroinitializer, <8 x i64> %x1, <8 x i64> zeroinitializer, i8 %x3)
  %res3 = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52l.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 -1)
  %res4 = add <8 x i64> %res, %res1
  %res5 = add <8 x i64> %res3, %res2
  %res6 = add <8 x i64> %res5, %res4
  ret <8 x i64> %res6
}

declare <8 x i64> @llvm.x86.avx512.maskz.vpmadd52l.uq.512(<8 x i64>, <8 x i64>, <8 x i64>, i8)

define <8 x i64>@test_int_x86_avx512_maskz_vpmadd52l_uq_512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_maskz_vpmadd52l_uq_512:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X86-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm3 # encoding: [0x62,0xf2,0xf5,0x48,0xb4,0xda]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax # encoding: [0x0f,0xb6,0x44,0x24,0x04]
; X86-NEXT:    kmovw %eax, %k1 # encoding: [0xc5,0xf8,0x92,0xc8]
; X86-NEXT:    vmovdqa64 %zmm0, %zmm4 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xe0]
; X86-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm4 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb4,0xe2]
; X86-NEXT:    vpxor %xmm2, %xmm2, %xmm2 # encoding: [0xc5,0xe9,0xef,0xd2]
; X86-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb4,0xc2]
; X86-NEXT:    vpaddq %zmm0, %zmm4, %zmm0 # encoding: [0x62,0xf1,0xdd,0x48,0xd4,0xc0]
; X86-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm2 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb4,0xd2]
; X86-NEXT:    vpaddq %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0xed,0x48,0xd4,0xc0]
; X86-NEXT:    vpaddq %zmm0, %zmm3, %zmm0 # encoding: [0x62,0xf1,0xe5,0x48,0xd4,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_maskz_vpmadd52l_uq_512:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X64-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm3 # encoding: [0x62,0xf2,0xf5,0x48,0xb4,0xda]
; X64-NEXT:    kmovw %edi, %k1 # encoding: [0xc5,0xf8,0x92,0xcf]
; X64-NEXT:    vmovdqa64 %zmm0, %zmm4 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xe0]
; X64-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm4 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb4,0xe2]
; X64-NEXT:    vpxor %xmm2, %xmm2, %xmm2 # encoding: [0xc5,0xe9,0xef,0xd2]
; X64-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb4,0xc2]
; X64-NEXT:    vpaddq %zmm0, %zmm4, %zmm0 # encoding: [0x62,0xf1,0xdd,0x48,0xd4,0xc0]
; X64-NEXT:    vpmadd52luq %zmm2, %zmm1, %zmm2 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb4,0xd2]
; X64-NEXT:    vpaddq %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0xed,0x48,0xd4,0xc0]
; X64-NEXT:    vpaddq %zmm0, %zmm3, %zmm0 # encoding: [0x62,0xf1,0xe5,0x48,0xd4,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]

  %res = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52l.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  %res1 = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52l.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> zeroinitializer, i8 %x3)
  %res2 = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52l.uq.512(<8 x i64> zeroinitializer, <8 x i64> %x1, <8 x i64> zeroinitializer, i8 %x3)
  %res3 = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52l.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 -1)
  %res4 = add <8 x i64> %res, %res1
  %res5 = add <8 x i64> %res3, %res2
  %res6 = add <8 x i64> %res5, %res4
  ret <8 x i64> %res6
}

define <8 x i64>@test_int_x86_avx512_vpmadd52h_uq_512_load(<8 x i64> %x0, <8 x i64> %x1, <8 x i64>* %x2ptr) {
; X86-LABEL: test_int_x86_avx512_vpmadd52h_uq_512_load:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vpmadd52huq (%eax), %zmm1, %zmm0 # encoding: [0x62,0xf2,0xf5,0x48,0xb5,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_vpmadd52h_uq_512_load:
; X64:       # %bb.0:
; X64-NEXT:    vpmadd52huq (%rdi), %zmm1, %zmm0 # encoding: [0x62,0xf2,0xf5,0x48,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x2 = load <8 x i64>, <8 x i64>* %x2ptr
  %res = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 -1)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_vpmadd52h_uq_512_load_bcast(<8 x i64> %x0, <8 x i64> %x1, i64* %x2ptr) {
; X86-LABEL: test_int_x86_avx512_vpmadd52h_uq_512_load_bcast:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vpbroadcastq (%eax), %zmm2 # encoding: [0x62,0xf2,0xfd,0x48,0x59,0x10]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm0 # encoding: [0x62,0xf2,0xf5,0x48,0xb5,0xc2]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_vpmadd52h_uq_512_load_bcast:
; X64:       # %bb.0:
; X64-NEXT:    vpmadd52huq (%rdi){1to8}, %zmm1, %zmm0 # encoding: [0x62,0xf2,0xf5,0x58,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x2load = load i64, i64* %x2ptr
  %x2insert = insertelement <8 x i64> undef, i64 %x2load, i64 0
  %x2 = shufflevector <8 x i64> %x2insert, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 -1)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_vpmadd52h_uq_512_load_commute(<8 x i64> %x0, <8 x i64>* %x1ptr, <8 x i64> %x2) {
; X86-LABEL: test_int_x86_avx512_vpmadd52h_uq_512_load_commute:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vpmadd52huq (%eax), %zmm1, %zmm0 # encoding: [0x62,0xf2,0xf5,0x48,0xb5,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_vpmadd52h_uq_512_load_commute:
; X64:       # %bb.0:
; X64-NEXT:    vpmadd52huq (%rdi), %zmm1, %zmm0 # encoding: [0x62,0xf2,0xf5,0x48,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x1 = load <8 x i64>, <8 x i64>* %x1ptr
  %res = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 -1)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_vpmadd52h_uq_512_load_commute_bcast(<8 x i64> %x0, i64* %x1ptr, <8 x i64> %x2) {
; X86-LABEL: test_int_x86_avx512_vpmadd52h_uq_512_load_commute_bcast:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vpbroadcastq (%eax), %zmm2 # encoding: [0x62,0xf2,0xfd,0x48,0x59,0x10]
; X86-NEXT:    vpmadd52huq %zmm1, %zmm2, %zmm0 # encoding: [0x62,0xf2,0xed,0x48,0xb5,0xc1]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_vpmadd52h_uq_512_load_commute_bcast:
; X64:       # %bb.0:
; X64-NEXT:    vpmadd52huq (%rdi){1to8}, %zmm1, %zmm0 # encoding: [0x62,0xf2,0xf5,0x58,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x1load = load i64, i64* %x1ptr
  %x1insert = insertelement <8 x i64> undef, i64 %x1load, i64 0
  %x1 = shufflevector <8 x i64> %x1insert, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 -1)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_mask_vpmadd52h_uq_512_load(<8 x i64> %x0, <8 x i64> %x1, <8 x i64>* %x2ptr, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpmadd52h_uq_512_load:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx # encoding: [0x0f,0xb6,0x4c,0x24,0x08]
; X86-NEXT:    kmovw %ecx, %k1 # encoding: [0xc5,0xf8,0x92,0xc9]
; X86-NEXT:    vpmadd52huq (%eax), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb5,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpmadd52h_uq_512_load:
; X64:       # %bb.0:
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpmadd52huq (%rdi), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x2 = load <8 x i64>, <8 x i64>* %x2ptr
  %res = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_mask_vpmadd52h_uq_512_load_bcast(<8 x i64> %x0, <8 x i64> %x1, i64* %x2ptr, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpmadd52h_uq_512_load_bcast:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vpbroadcastq (%eax), %zmm2 # encoding: [0x62,0xf2,0xfd,0x48,0x59,0x10]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax # encoding: [0x0f,0xb6,0x44,0x24,0x08]
; X86-NEXT:    kmovw %eax, %k1 # encoding: [0xc5,0xf8,0x92,0xc8]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb5,0xc2]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpmadd52h_uq_512_load_bcast:
; X64:       # %bb.0:
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpmadd52huq (%rdi){1to8}, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x59,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x2load = load i64, i64* %x2ptr
  %x2insert = insertelement <8 x i64> undef, i64 %x2load, i64 0
  %x2 = shufflevector <8 x i64> %x2insert, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_mask_vpmadd52h_uq_512_load_commute(<8 x i64> %x0, <8 x i64>* %x1ptr, <8 x i64> %x2, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpmadd52h_uq_512_load_commute:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx # encoding: [0x0f,0xb6,0x4c,0x24,0x08]
; X86-NEXT:    kmovw %ecx, %k1 # encoding: [0xc5,0xf8,0x92,0xc9]
; X86-NEXT:    vpmadd52huq (%eax), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb5,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpmadd52h_uq_512_load_commute:
; X64:       # %bb.0:
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpmadd52huq (%rdi), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x49,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x1 = load <8 x i64>, <8 x i64>* %x1ptr
  %res = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_mask_vpmadd52h_uq_512_load_commute_bcast(<8 x i64> %x0, i64* %x1ptr, <8 x i64> %x2, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpmadd52h_uq_512_load_commute_bcast:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vpbroadcastq (%eax), %zmm2 # encoding: [0x62,0xf2,0xfd,0x48,0x59,0x10]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax # encoding: [0x0f,0xb6,0x44,0x24,0x08]
; X86-NEXT:    kmovw %eax, %k1 # encoding: [0xc5,0xf8,0x92,0xc8]
; X86-NEXT:    vpmadd52huq %zmm1, %zmm2, %zmm0 {%k1} # encoding: [0x62,0xf2,0xed,0x49,0xb5,0xc1]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpmadd52h_uq_512_load_commute_bcast:
; X64:       # %bb.0:
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpmadd52huq (%rdi){1to8}, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0xf5,0x59,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x1load = load i64, i64* %x1ptr
  %x1insert = insertelement <8 x i64> undef, i64 %x1load, i64 0
  %x1 = shufflevector <8 x i64> %x1insert, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = call <8 x i64> @llvm.x86.avx512.mask.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_maskz_vpmadd52h_uq_512_load(<8 x i64> %x0, <8 x i64> %x1, <8 x i64>* %x2ptr, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_maskz_vpmadd52h_uq_512_load:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx # encoding: [0x0f,0xb6,0x4c,0x24,0x08]
; X86-NEXT:    kmovw %ecx, %k1 # encoding: [0xc5,0xf8,0x92,0xc9]
; X86-NEXT:    vpmadd52huq (%eax), %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_maskz_vpmadd52h_uq_512_load:
; X64:       # %bb.0:
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpmadd52huq (%rdi), %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x2 = load <8 x i64>, <8 x i64>* %x2ptr
  %res = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_maskz_vpmadd52h_uq_512_load_bcast(<8 x i64> %x0, <8 x i64> %x1, i64* %x2ptr, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_maskz_vpmadd52h_uq_512_load_bcast:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vpbroadcastq (%eax), %zmm2 # encoding: [0x62,0xf2,0xfd,0x48,0x59,0x10]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax # encoding: [0x0f,0xb6,0x44,0x24,0x08]
; X86-NEXT:    kmovw %eax, %k1 # encoding: [0xc5,0xf8,0x92,0xc8]
; X86-NEXT:    vpmadd52huq %zmm2, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0xc2]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_maskz_vpmadd52h_uq_512_load_bcast:
; X64:       # %bb.0:
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpmadd52huq (%rdi){1to8}, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xd9,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x2load = load i64, i64* %x2ptr
  %x2insert = insertelement <8 x i64> undef, i64 %x2load, i64 0
  %x2 = shufflevector <8 x i64> %x2insert, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_maskz_vpmadd52h_uq_512_load_commute(<8 x i64> %x0, <8 x i64>* %x1ptr, <8 x i64> %x2, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_maskz_vpmadd52h_uq_512_load_commute:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx # encoding: [0x0f,0xb6,0x4c,0x24,0x08]
; X86-NEXT:    kmovw %ecx, %k1 # encoding: [0xc5,0xf8,0x92,0xc9]
; X86-NEXT:    vpmadd52huq (%eax), %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_maskz_vpmadd52h_uq_512_load_commute:
; X64:       # %bb.0:
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpmadd52huq (%rdi), %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xc9,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x1 = load <8 x i64>, <8 x i64>* %x1ptr
  %res = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  ret <8 x i64> %res
}

define <8 x i64>@test_int_x86_avx512_maskz_vpmadd52h_uq_512_load_commute_bcast(<8 x i64> %x0, i64* %x1ptr, <8 x i64> %x2, i8 %x3) {
; X86-LABEL: test_int_x86_avx512_maskz_vpmadd52h_uq_512_load_commute_bcast:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vpbroadcastq (%eax), %zmm2 # encoding: [0x62,0xf2,0xfd,0x48,0x59,0x10]
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax # encoding: [0x0f,0xb6,0x44,0x24,0x08]
; X86-NEXT:    kmovw %eax, %k1 # encoding: [0xc5,0xf8,0x92,0xc8]
; X86-NEXT:    vpmadd52huq %zmm1, %zmm2, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xed,0xc9,0xb5,0xc1]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_maskz_vpmadd52h_uq_512_load_commute_bcast:
; X64:       # %bb.0:
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpmadd52huq (%rdi){1to8}, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xf5,0xd9,0xb5,0x07]
; X64-NEXT:    retq # encoding: [0xc3]

  %x1load = load i64, i64* %x1ptr
  %x1insert = insertelement <8 x i64> undef, i64 %x1load, i64 0
  %x1 = shufflevector <8 x i64> %x1insert, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = call <8 x i64> @llvm.x86.avx512.maskz.vpmadd52h.uq.512(<8 x i64> %x0, <8 x i64> %x1, <8 x i64> %x2, i8 %x3)
  ret <8 x i64> %res
}
