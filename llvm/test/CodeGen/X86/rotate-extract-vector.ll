; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx512bw | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512bw | FileCheck %s --check-prefixes=CHECK,X64

; Check that under certain conditions we can factor out a rotate
; from the following idioms:
;   (a*c0) >> s1 | (a*c1)
;   (a/c0) << s1 | (a/c1)
; This targets cases where instcombine has folded a shl/srl/mul/udiv
; with one of the shifts from the rotate idiom

define <4 x i32> @vroll_v4i32_extract_shl(<4 x i32> %i) {
; CHECK-LABEL: vroll_v4i32_extract_shl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpslld $3, %xmm0, %xmm0
; CHECK-NEXT:    vprold $7, %zmm0, %zmm0
; CHECK-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %lhs_mul = shl <4 x i32> %i, <i32 3, i32 3, i32 3, i32 3>
  %rhs_mul = shl <4 x i32> %i, <i32 10, i32 10, i32 10, i32 10>
  %lhs_shift = lshr <4 x i32> %lhs_mul, <i32 25, i32 25, i32 25, i32 25>
  %out = or <4 x i32> %lhs_shift, %rhs_mul
  ret <4 x i32> %out
}

define <4 x i64> @vrolq_v4i64_extract_shrl(<4 x i64> %i) nounwind {
; CHECK-LABEL: vrolq_v4i64_extract_shrl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrlq $5, %ymm0, %ymm0
; CHECK-NEXT:    vprolq $29, %zmm0, %zmm0
; CHECK-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %lhs_div = lshr <4 x i64> %i, <i64 40, i64 40, i64 40, i64 40>
  %rhs_div = lshr <4 x i64> %i, <i64 5, i64 5, i64 5, i64 5>
  %rhs_shift = shl <4 x i64> %rhs_div, <i64 29, i64 29, i64 29, i64 29>
  %out = or <4 x i64> %lhs_div, %rhs_shift
  ret <4 x i64> %out
}

define <8 x i32> @vroll_extract_mul(<8 x i32> %i) nounwind {
; CHECK-LABEL: vroll_extract_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastd {{.*#+}} ymm1 = [10,10,10,10,10,10,10,10]
; CHECK-NEXT:    vpmulld %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vprold $6, %zmm0, %zmm0
; CHECK-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %lhs_mul = mul <8 x i32> %i, <i32 640, i32 640, i32 640, i32 640, i32 640, i32 640, i32 640, i32 640>
  %rhs_mul = mul <8 x i32> %i, <i32 10, i32 10, i32 10, i32 10, i32 10, i32 10, i32 10, i32 10>
  %rhs_shift = lshr <8 x i32> %rhs_mul, <i32 26, i32 26, i32 26, i32 26, i32 26, i32 26, i32 26, i32 26>
  %out = or <8 x i32> %lhs_mul, %rhs_shift
  ret <8 x i32> %out
}

define <2 x i64> @vrolq_extract_udiv(<2 x i64> %i) nounwind {
; X86-LABEL: vrolq_extract_udiv:
; X86:       # %bb.0:
; X86-NEXT:    subl $44, %esp
; X86-NEXT:    vmovups %xmm0, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; X86-NEXT:    vextractps $1, %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $3, {{[0-9]+}}(%esp)
; X86-NEXT:    calll __udivdi3
; X86-NEXT:    vmovups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; X86-NEXT:    vextractps $3, %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    vextractps $2, %xmm0, (%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $3, {{[0-9]+}}(%esp)
; X86-NEXT:    vmovd %eax, %xmm0
; X86-NEXT:    vpinsrd $1, %edx, %xmm0, %xmm0
; X86-NEXT:    vmovdqu %xmm0, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; X86-NEXT:    calll __udivdi3
; X86-NEXT:    vmovdqu {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; X86-NEXT:    vpinsrd $2, %eax, %xmm0, %xmm0
; X86-NEXT:    vpinsrd $3, %edx, %xmm0, %xmm0
; X86-NEXT:    vprolq $57, %zmm0, %zmm0
; X86-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; X86-NEXT:    addl $44, %esp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: vrolq_extract_udiv:
; X64:       # %bb.0:
; X64-NEXT:    vpextrq $1, %xmm0, %rax
; X64-NEXT:    movabsq $-6148914691236517205, %rcx # imm = 0xAAAAAAAAAAAAAAAB
; X64-NEXT:    mulq %rcx
; X64-NEXT:    vmovq %rdx, %xmm1
; X64-NEXT:    vmovq %xmm0, %rax
; X64-NEXT:    mulq %rcx
; X64-NEXT:    vmovq %rdx, %xmm0
; X64-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-NEXT:    vpsrlq $1, %xmm0, %xmm0
; X64-NEXT:    vprolq $57, %zmm0, %zmm0
; X64-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %lhs_div = udiv <2 x i64> %i, <i64 3, i64 3>
  %rhs_div = udiv <2 x i64> %i, <i64 384, i64 384>
  %lhs_shift = shl <2 x i64> %lhs_div, <i64 57, i64 57>
  %out = or <2 x i64> %lhs_shift, %rhs_div
  ret <2 x i64> %out
}

define <4 x i32> @vrolw_extract_mul_with_mask(<4 x i32> %i) nounwind {
; X86-LABEL: vrolw_extract_mul_with_mask:
; X86:       # %bb.0:
; X86-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [9,9,9,9]
; X86-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; X86-NEXT:    vprold $7, %zmm0, %zmm0
; X86-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: vrolw_extract_mul_with_mask:
; X64:       # %bb.0:
; X64-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [9,9,9,9]
; X64-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; X64-NEXT:    vprold $7, %zmm0, %zmm0
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %lhs_mul = mul <4 x i32> %i, <i32 1152, i32 1152, i32 1152, i32 1152>
  %rhs_mul = mul <4 x i32> %i, <i32 9, i32 9, i32 9, i32 9>
  %lhs_and = and <4 x i32> %lhs_mul, <i32 160, i32 160, i32 160, i32 160>
  %rhs_shift = lshr <4 x i32> %rhs_mul, <i32 25, i32 25, i32 25, i32 25>
  %out = or <4 x i32> %lhs_and, %rhs_shift
  ret <4 x i32> %out
}

define <32 x i16> @illegal_no_extract_mul(<32 x i16> %i) nounwind {
; X86-LABEL: illegal_no_extract_mul:
; X86:       # %bb.0:
; X86-NEXT:    vpmullw {{\.LCPI.*}}, %zmm0, %zmm1
; X86-NEXT:    vpmullw {{\.LCPI.*}}, %zmm0, %zmm0
; X86-NEXT:    vpsrlw $10, %zmm0, %zmm0
; X86-NEXT:    vporq %zmm0, %zmm1, %zmm0
; X86-NEXT:    retl
;
; X64-LABEL: illegal_no_extract_mul:
; X64:       # %bb.0:
; X64-NEXT:    vpmullw {{.*}}(%rip), %zmm0, %zmm1
; X64-NEXT:    vpmullw {{.*}}(%rip), %zmm0, %zmm0
; X64-NEXT:    vpsrlw $10, %zmm0, %zmm0
; X64-NEXT:    vporq %zmm0, %zmm1, %zmm0
; X64-NEXT:    retq
  %lhs_mul = mul <32 x i16> %i, <i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640, i16 640>
  %rhs_mul = mul <32 x i16> %i, <i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10>
  %rhs_shift = lshr <32 x i16> %rhs_mul, <i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10>
  %out = or <32 x i16> %lhs_mul, %rhs_shift
  ret <32 x i16> %out
}

; Result would undershift
define <4 x i64> @no_extract_shl(<4 x i64> %i) nounwind {
; CHECK-LABEL: no_extract_shl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsllq $11, %ymm0, %ymm1
; CHECK-NEXT:    vpsllq $24, %ymm0, %ymm0
; CHECK-NEXT:    vpsrlq $50, %ymm1, %ymm1
; CHECK-NEXT:    vpor %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %lhs_mul = shl <4 x i64> %i, <i64 11, i64 11, i64 11, i64 11>
  %rhs_mul = shl <4 x i64> %i, <i64 24, i64 24, i64 24, i64 24>
  %lhs_shift = lshr <4 x i64> %lhs_mul, <i64 50, i64 50, i64 50, i64 50>
  %out = or <4 x i64> %lhs_shift, %rhs_mul
  ret <4 x i64> %out
}

; Result would overshift
define <4 x i32> @no_extract_shrl(<4 x i32> %i) nounwind {
; CHECK-LABEL: no_extract_shrl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [4026531840,4026531840,4026531840,4026531840]
; CHECK-NEXT:    vpslld $25, %xmm0, %xmm2
; CHECK-NEXT:    vpand %xmm1, %xmm2, %xmm1
; CHECK-NEXT:    vpsrld $9, %xmm0, %xmm0
; CHECK-NEXT:    vpor %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %lhs_div = lshr <4 x i32> %i, <i32 3, i32 3, i32 3, i32 3>
  %rhs_div = lshr <4 x i32> %i, <i32 9, i32 9, i32 9, i32 9>
  %lhs_shift = shl <4 x i32> %lhs_div, <i32 28, i32 28, i32 28, i32 28>
  %out = or <4 x i32> %lhs_shift, %rhs_div
  ret <4 x i32> %out
}

; Can factor 512 from 1536, but result is 3 instead of 9
define <8 x i32> @no_extract_mul(<8 x i32> %i) nounwind {
; CHECK-LABEL: no_extract_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastd {{.*#+}} ymm1 = [1536,1536,1536,1536,1536,1536,1536,1536]
; CHECK-NEXT:    vpmulld %ymm1, %ymm0, %ymm1
; CHECK-NEXT:    vpbroadcastd {{.*#+}} ymm2 = [9,9,9,9,9,9,9,9]
; CHECK-NEXT:    vpmulld %ymm2, %ymm0, %ymm0
; CHECK-NEXT:    vpsrld $23, %ymm0, %ymm0
; CHECK-NEXT:    vpor %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %lhs_mul = mul <8 x i32> %i, <i32 1536, i32 1536, i32 1536, i32 1536, i32 1536, i32 1536, i32 1536, i32 1536>
  %rhs_mul = mul <8 x i32> %i, <i32 9, i32 9, i32 9, i32 9, i32 9, i32 9, i32 9, i32 9>
  %rhs_shift = lshr <8 x i32> %rhs_mul, <i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23>
  %out = or <8 x i32> %lhs_mul, %rhs_shift
  ret <8 x i32> %out
}

; Can't evenly factor 256 from 770
define <2 x i64> @no_extract_udiv(<2 x i64> %i) nounwind {
; X86-LABEL: no_extract_udiv:
; X86:       # %bb.0:
; X86-NEXT:    subl $60, %esp
; X86-NEXT:    vmovups %xmm0, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; X86-NEXT:    vextractps $1, %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $3, {{[0-9]+}}(%esp)
; X86-NEXT:    calll __udivdi3
; X86-NEXT:    vmovups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; X86-NEXT:    vextractps $3, %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    vextractps $2, %xmm0, (%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $3, {{[0-9]+}}(%esp)
; X86-NEXT:    vmovd %eax, %xmm0
; X86-NEXT:    vmovdqu %xmm0, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; X86-NEXT:    calll __udivdi3
; X86-NEXT:    vmovdqu {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; X86-NEXT:    vpinsrd $2, %eax, %xmm0, %xmm0
; X86-NEXT:    vmovdqu %xmm0, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; X86-NEXT:    vmovups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; X86-NEXT:    vextractps $1, %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $770, {{[0-9]+}}(%esp) # imm = 0x302
; X86-NEXT:    calll __udivdi3
; X86-NEXT:    vmovups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; X86-NEXT:    vextractps $3, %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    vextractps $2, %xmm0, (%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $770, {{[0-9]+}}(%esp) # imm = 0x302
; X86-NEXT:    vmovd %eax, %xmm0
; X86-NEXT:    vpinsrd $1, %edx, %xmm0, %xmm0
; X86-NEXT:    vmovdqu %xmm0, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; X86-NEXT:    calll __udivdi3
; X86-NEXT:    vmovdqu {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; X86-NEXT:    vpinsrd $2, %eax, %xmm0, %xmm0
; X86-NEXT:    vpinsrd $3, %edx, %xmm0, %xmm0
; X86-NEXT:    vmovdqu {{[-0-9]+}}(%e{{[sb]}}p), %xmm1 # 16-byte Reload
; X86-NEXT:    vpsllq $56, %xmm1, %xmm1
; X86-NEXT:    vpor %xmm0, %xmm1, %xmm0
; X86-NEXT:    addl $60, %esp
; X86-NEXT:    retl
;
; X64-LABEL: no_extract_udiv:
; X64:       # %bb.0:
; X64-NEXT:    vpextrq $1, %xmm0, %rcx
; X64-NEXT:    movabsq $-6148914691236517205, %rdi # imm = 0xAAAAAAAAAAAAAAAB
; X64-NEXT:    movq %rcx, %rax
; X64-NEXT:    mulq %rdi
; X64-NEXT:    vmovq %rdx, %xmm1
; X64-NEXT:    vmovq %xmm0, %rsi
; X64-NEXT:    movq %rsi, %rax
; X64-NEXT:    mulq %rdi
; X64-NEXT:    vmovq %rdx, %xmm0
; X64-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-NEXT:    vpsrlq $1, %xmm0, %xmm0
; X64-NEXT:    movabsq $-6180857105216966645, %rdi # imm = 0xAA392F35DC17F00B
; X64-NEXT:    movq %rcx, %rax
; X64-NEXT:    mulq %rdi
; X64-NEXT:    vmovq %rdx, %xmm1
; X64-NEXT:    movq %rsi, %rax
; X64-NEXT:    mulq %rdi
; X64-NEXT:    vmovq %rdx, %xmm2
; X64-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm2[0],xmm1[0]
; X64-NEXT:    vpsrlq $9, %xmm1, %xmm1
; X64-NEXT:    vpsllq $56, %xmm0, %xmm0
; X64-NEXT:    vpor %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
  %lhs_div = udiv <2 x i64> %i, <i64 3, i64 3>
  %rhs_div = udiv <2 x i64> %i, <i64 770, i64 770>
  %lhs_shift = shl <2 x i64> %lhs_div, <i64 56, i64 56>
  %out = or <2 x i64> %lhs_shift, %rhs_div
  ret <2 x i64> %out
}

; DAGCombiner transforms shl X, 1 into add X, X.
define <4 x i32> @extract_add_1(<4 x i32> %i) nounwind {
; CHECK-LABEL: extract_add_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; CHECK-NEXT:    vprold $1, %zmm0, %zmm0
; CHECK-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %ii = add <4 x i32> %i, %i
  %rhs = lshr <4 x i32> %i, <i32 31, i32 31, i32 31, i32 31>
  %out = or <4 x i32> %ii, %rhs
  ret <4 x i32> %out
}

define <4 x i32> @extract_add_1_comut(<4 x i32> %i) nounwind {
; CHECK-LABEL: extract_add_1_comut:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; CHECK-NEXT:    vprold $1, %zmm0, %zmm0
; CHECK-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %ii = add <4 x i32> %i, %i
  %lhs = lshr <4 x i32> %i, <i32 31, i32 31, i32 31, i32 31>
  %out = or <4 x i32> %lhs, %ii
  ret <4 x i32> %out
}

define <4 x i32> @no_extract_add_1(<4 x i32> %i) nounwind {
; CHECK-LABEL: no_extract_add_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpaddd %xmm0, %xmm0, %xmm1
; CHECK-NEXT:    vpsrld $27, %xmm0, %xmm0
; CHECK-NEXT:    vpor %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %ii = add <4 x i32> %i, %i
  %rhs = lshr <4 x i32> %i, <i32 27, i32 27, i32 27, i32 27>
  %out = or <4 x i32> %ii, %rhs
  ret <4 x i32> %out
}
