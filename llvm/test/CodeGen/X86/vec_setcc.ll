; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX

define <16 x i8> @v16i8_icmp_uge(<16 x i8> %a, <16 x i8> %b) nounwind readnone ssp uwtable {
; SSE-LABEL: v16i8_icmp_uge:
; SSE:       # %bb.0:
; SSE-NEXT:    pmaxub %xmm0, %xmm1
; SSE-NEXT:    pcmpeqb %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v16i8_icmp_uge:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmaxub %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpcmpeqb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp uge <16 x i8> %a, %b
  %2 = sext <16 x i1> %1 to <16 x i8>
  ret <16 x i8> %2
}

define <16 x i8> @v16i8_icmp_ule(<16 x i8> %a, <16 x i8> %b) nounwind readnone ssp uwtable {
; SSE-LABEL: v16i8_icmp_ule:
; SSE:       # %bb.0:
; SSE-NEXT:    pminub %xmm0, %xmm1
; SSE-NEXT:    pcmpeqb %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v16i8_icmp_ule:
; AVX:       # %bb.0:
; AVX-NEXT:    vpminub %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpcmpeqb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp ule <16 x i8> %a, %b
  %2 = sext <16 x i1> %1 to <16 x i8>
  ret <16 x i8> %2
}

define <8 x i16> @v8i16_icmp_uge(<8 x i16> %a, <8 x i16> %b) nounwind readnone ssp uwtable {
; SSE2-LABEL: v8i16_icmp_uge:
; SSE2:       # %bb.0:
; SSE2-NEXT:    psubusw %xmm0, %xmm1
; SSE2-NEXT:    pxor %xmm0, %xmm0
; SSE2-NEXT:    pcmpeqw %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: v8i16_icmp_uge:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmaxuw %xmm0, %xmm1
; SSE41-NEXT:    pcmpeqw %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: v8i16_icmp_uge:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmaxuw %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp uge <8 x i16> %a, %b
  %2 = sext <8 x i1> %1 to <8 x i16>
  ret <8 x i16> %2
}

define <8 x i16> @v8i16_icmp_ule(<8 x i16> %a, <8 x i16> %b) nounwind readnone ssp uwtable {
; SSE2-LABEL: v8i16_icmp_ule:
; SSE2:       # %bb.0:
; SSE2-NEXT:    psubusw %xmm1, %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    pcmpeqw %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: v8i16_icmp_ule:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pminuw %xmm0, %xmm1
; SSE41-NEXT:    pcmpeqw %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: v8i16_icmp_ule:
; AVX:       # %bb.0:
; AVX-NEXT:    vpminuw %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp ule <8 x i16> %a, %b
  %2 = sext <8 x i1> %1 to <8 x i16>
  ret <8 x i16> %2
}

define <4 x i32> @v4i32_icmp_uge(<4 x i32> %a, <4 x i32> %b) nounwind readnone ssp uwtable {
; SSE2-LABEL: v4i32_icmp_uge:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm2
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm2
; SSE2-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: v4i32_icmp_uge:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmaxud %xmm0, %xmm1
; SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: v4i32_icmp_uge:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmaxud %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp uge <4 x i32> %a, %b
  %2 = sext <4 x i1> %1 to <4 x i32>
  ret <4 x i32> %2
}

define <4 x i32> @v4i32_icmp_ule(<4 x i32> %a, <4 x i32> %b) nounwind readnone ssp uwtable {
; SSE2-LABEL: v4i32_icmp_ule:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; SSE2-NEXT:    pxor %xmm2, %xmm1
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE2-NEXT:    pxor %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: v4i32_icmp_ule:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pminud %xmm0, %xmm1
; SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: v4i32_icmp_ule:
; AVX:       # %bb.0:
; AVX-NEXT:    vpminud %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = icmp ule <4 x i32> %a, %b
  %2 = sext <4 x i1> %1 to <4 x i32>
  ret <4 x i32> %2
}

; At one point we were incorrectly constant-folding a setcc to 0x1 instead of
; 0xff, leading to a constpool load. The instruction doesn't matter here, but it
; should set all bits to 1.
define <16 x i8> @test_setcc_constfold_vi8(<16 x i8> %l, <16 x i8> %r) {
; SSE-LABEL: test_setcc_constfold_vi8:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_setcc_constfold_vi8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %test1 = icmp eq <16 x i8> %l, %r
  %mask1 = sext <16 x i1> %test1 to <16 x i8>
  %test2 = icmp ne <16 x i8> %l, %r
  %mask2 = sext <16 x i1> %test2 to <16 x i8>
  %res = or <16 x i8> %mask1, %mask2
  ret <16 x i8> %res
}

; Make sure sensible results come from doing extension afterwards
define <16 x i8> @test_setcc_constfold_vi1(<16 x i8> %l, <16 x i8> %r) {
; SSE-LABEL: test_setcc_constfold_vi1:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_setcc_constfold_vi1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %test1 = icmp eq <16 x i8> %l, %r
  %test2 = icmp ne <16 x i8> %l, %r
  %res = or <16 x i1> %test1, %test2
  %mask = sext <16 x i1> %res to <16 x i8>
  ret <16 x i8> %mask
}

; 64-bit case is also particularly important, as the constant "-1" is probably
; just 32-bits wide.
define <2 x i64> @test_setcc_constfold_vi64(<2 x i64> %l, <2 x i64> %r) {
; SSE-LABEL: test_setcc_constfold_vi64:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_setcc_constfold_vi64:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %test1 = icmp eq <2 x i64> %l, %r
  %mask1 = sext <2 x i1> %test1 to <2 x i64>
  %test2 = icmp ne <2 x i64> %l, %r
  %mask2 = sext <2 x i1> %test2 to <2 x i64>
  %res = or <2 x i64> %mask1, %mask2
  ret <2 x i64> %res
}

; This asserted in type legalization for v3i1 setcc after v3i16 was made
; a simple value type.
define <3 x i1> @test_setcc_v3i1_v3i16(<3 x i16>* %a) nounwind {
; SSE2-LABEL: test_setcc_v3i1_v3i16:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    pcmpeqw %xmm0, %xmm1
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; SSE2-NEXT:    movdqa %xmm1, -{{[0-9]+}}(%rsp)
; SSE2-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; SSE2-NEXT:    movb -{{[0-9]+}}(%rsp), %dl
; SSE2-NEXT:    movb -{{[0-9]+}}(%rsp), %cl
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_setcc_v3i1_v3i16:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE41-NEXT:    pxor %xmm1, %xmm1
; SSE41-NEXT:    pcmpeqw %xmm0, %xmm1
; SSE41-NEXT:    pextrb $0, %xmm1, %eax
; SSE41-NEXT:    pextrb $2, %xmm1, %edx
; SSE41-NEXT:    pextrb $4, %xmm1, %ecx
; SSE41-NEXT:    # kill: def $al killed $al killed $eax
; SSE41-NEXT:    # kill: def $dl killed $dl killed $edx
; SSE41-NEXT:    # kill: def $cl killed $cl killed $ecx
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_setcc_v3i1_v3i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpextrb $0, %xmm0, %eax
; AVX-NEXT:    vpextrb $2, %xmm0, %edx
; AVX-NEXT:    vpextrb $4, %xmm0, %ecx
; AVX-NEXT:    # kill: def $al killed $al killed $eax
; AVX-NEXT:    # kill: def $dl killed $dl killed $edx
; AVX-NEXT:    # kill: def $cl killed $cl killed $ecx
; AVX-NEXT:    retq
  %b = load <3 x i16>, <3 x i16>* %a
  %cmp = icmp eq <3 x i16> %b, <i16 0, i16 0, i16 0>
  ret <3 x i1> %cmp
}
