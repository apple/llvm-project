; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse,+sse2,+avx,+avx2 | FileCheck %s

; Given:
;   icmp eq/ne (urem %x, C), 0
; Iff C is not a power of two (those should not get to here though),
; and %x may have at most one bit set, omit the 'urem':
;   icmp eq/ne %x, 0

;------------------------------------------------------------------------------;
; Basic scalar tests
;------------------------------------------------------------------------------;

define i1 @p0_scalar_urem_by_const(i32 %x, i32 %y) {
; CHECK-LABEL: p0_scalar_urem_by_const:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $128, %edi
; CHECK-NEXT:    movl $2863311531, %eax # imm = 0xAAAAAAAB
; CHECK-NEXT:    imulq %rdi, %rax
; CHECK-NEXT:    shrq $34, %rax
; CHECK-NEXT:    addl %eax, %eax
; CHECK-NEXT:    leal (%rax,%rax,2), %eax
; CHECK-NEXT:    cmpl %eax, %edi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %t0 = and i32 %x, 128 ; clearly a power-of-two or zero
  %t1 = urem i32 %t0, 6 ; '6' is clearly not a power of two
  %t2 = icmp eq i32 %t1, 0
  ret i1 %t2
}

define i1 @p1_scalar_urem_by_nonconst(i32 %x, i32 %y) {
; CHECK-LABEL: p1_scalar_urem_by_nonconst:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl $128, %eax
; CHECK-NEXT:    orl $6, %esi
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %esi
; CHECK-NEXT:    testl %edx, %edx
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %t0 = and i32 %x, 128 ; clearly a power-of-two or zero
  %t1 = or i32 %y, 6 ; two bits set, clearly not a power of two
  %t2 = urem i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  ret i1 %t3
}

define i1 @p2_scalar_shifted_urem_by_const(i32 %x, i32 %y) {
; CHECK-LABEL: p2_scalar_shifted_urem_by_const:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    # kill: def $cl killed $cl killed $ecx
; CHECK-NEXT:    shll %cl, %edi
; CHECK-NEXT:    movl $2863311531, %eax # imm = 0xAAAAAAAB
; CHECK-NEXT:    imulq %rdi, %rax
; CHECK-NEXT:    shrq $33, %rax
; CHECK-NEXT:    leal (%rax,%rax,2), %eax
; CHECK-NEXT:    cmpl %eax, %edi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %t0 = and i32 %x, 1 ; clearly a power-of-two or zero
  %t1 = shl i32 %t0, %y ; will still be a power-of-two or zero with any %y
  %t2 = urem i32 %t1, 3 ; '3' is clearly not a power of two
  %t3 = icmp eq i32 %t2, 0
  ret i1 %t3
}

define i1 @p3_scalar_shifted2_urem_by_const(i32 %x, i32 %y) {
; CHECK-LABEL: p3_scalar_shifted2_urem_by_const:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $2, %edi
; CHECK-NEXT:    # kill: def $cl killed $cl killed $ecx
; CHECK-NEXT:    shll %cl, %edi
; CHECK-NEXT:    movl $2863311531, %eax # imm = 0xAAAAAAAB
; CHECK-NEXT:    imulq %rdi, %rax
; CHECK-NEXT:    shrq $33, %rax
; CHECK-NEXT:    leal (%rax,%rax,2), %eax
; CHECK-NEXT:    cmpl %eax, %edi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %t0 = and i32 %x, 2 ; clearly a power-of-two or zero
  %t1 = shl i32 %t0, %y ; will still be a power-of-two or zero with any %y
  %t2 = urem i32 %t1, 3 ; '3' is clearly not a power of two
  %t3 = icmp eq i32 %t2, 0
  ret i1 %t3
}

;------------------------------------------------------------------------------;
; Basic vector tests
;------------------------------------------------------------------------------;

define <4 x i1> @p4_vector_urem_by_const__splat(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: p4_vector_urem_by_const__splat:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [128,128,128,128]
; CHECK-NEXT:    vpand %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [2863311531,2863311531,2863311531,2863311531]
; CHECK-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpmuludq %xmm2, %xmm0, %xmm2
; CHECK-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-NEXT:    vpsrld $2, %xmm1, %xmm1
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [6,6,6,6]
; CHECK-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = and <4 x i32> %x, <i32 128, i32 128, i32 128, i32 128> ; clearly a power-of-two or zero
  %t1 = urem <4 x i32> %t0, <i32 6, i32 6, i32 6, i32 6> ; '6' is clearly not a power of two
  %t2 = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %t2
}

define <4 x i1> @p5_vector_urem_by_const__nonsplat(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: p5_vector_urem_by_const__nonsplat:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    vmovdqa {{.*#+}} xmm1 = [2863311531,3435973837,2863311531,954437177]
; CHECK-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; CHECK-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; CHECK-NEXT:    vpmuludq %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpmuludq %xmm1, %xmm0, %xmm1
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; CHECK-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; CHECK-NEXT:    vpsrlvd {{.*}}(%rip), %xmm1, %xmm1
; CHECK-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; CHECK-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = and <4 x i32> %x, <i32 128, i32 2, i32 4, i32 8>
  %t1 = urem <4 x i32> %t0, <i32 3, i32 5, i32 6, i32 9>
  %t2 = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %t2
}

define <4 x i1> @p6_vector_urem_by_const__nonsplat_undef0(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: p6_vector_urem_by_const__nonsplat_undef0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [128,128,128,128]
; CHECK-NEXT:    vpand %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [2863311531,2863311531,2863311531,2863311531]
; CHECK-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpmuludq %xmm2, %xmm0, %xmm2
; CHECK-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-NEXT:    vpsrld $2, %xmm1, %xmm1
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [6,6,6,6]
; CHECK-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = and <4 x i32> %x, <i32 128, i32 128, i32 undef, i32 128>
  %t1 = urem <4 x i32> %t0, <i32 6, i32 6, i32 6, i32 6> ; '6' is clearly not a power of two
  %t2 = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %t2
}

define <4 x i1> @p7_vector_urem_by_const__nonsplat_undef2(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: p7_vector_urem_by_const__nonsplat_undef2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [128,128,128,128]
; CHECK-NEXT:    vpand %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [2863311531,2863311531,2863311531,2863311531]
; CHECK-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpmuludq %xmm2, %xmm0, %xmm2
; CHECK-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-NEXT:    vpsrld $2, %xmm1, %xmm1
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [6,6,6,6]
; CHECK-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = and <4 x i32> %x, <i32 128, i32 128, i32 128, i32 128> ; clearly a power-of-two or zero
  %t1 = urem <4 x i32> %t0, <i32 6, i32 6, i32 6, i32 6> ; '6' is clearly not a power of two
  %t2 = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 undef, i32 0>
  ret <4 x i1> %t2
}

define <4 x i1> @p8_vector_urem_by_const__nonsplat_undef3(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: p8_vector_urem_by_const__nonsplat_undef3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [128,128,128,128]
; CHECK-NEXT:    vpand %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [2863311531,2863311531,2863311531,2863311531]
; CHECK-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpmuludq %xmm2, %xmm0, %xmm2
; CHECK-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; CHECK-NEXT:    vpblendd {{.*#+}} xmm1 = xmm2[0],xmm1[1],xmm2[2],xmm1[3]
; CHECK-NEXT:    vpsrld $2, %xmm1, %xmm1
; CHECK-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [6,6,6,6]
; CHECK-NEXT:    vpmulld %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t0 = and <4 x i32> %x, <i32 128, i32 128, i32 undef, i32 128>
  %t1 = urem <4 x i32> %t0, <i32 6, i32 6, i32 6, i32 6> ; '6' is clearly not a power of two
  %t2 = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 undef, i32 0>
  ret <4 x i1> %t2
}

;------------------------------------------------------------------------------;
; Basic negative tests
;------------------------------------------------------------------------------;

define i1 @n0_urem_of_maybe_not_power_of_two(i32 %x, i32 %y) {
; CHECK-LABEL: n0_urem_of_maybe_not_power_of_two:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $3, %edi
; CHECK-NEXT:    movl $2863311531, %eax # imm = 0xAAAAAAAB
; CHECK-NEXT:    imulq %rdi, %rax
; CHECK-NEXT:    shrq $33, %rax
; CHECK-NEXT:    leal (%rax,%rax,2), %eax
; CHECK-NEXT:    cmpl %eax, %edi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %t0 = and i32 %x, 3 ; up to two bits set, not power-of-two
  %t1 = urem i32 %t0, 3
  %t2 = icmp eq i32 %t1, 0
  ret i1 %t2
}

define i1 @n1_urem_by_maybe_power_of_two(i32 %x, i32 %y) {
; CHECK-LABEL: n1_urem_by_maybe_power_of_two:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl $128, %eax
; CHECK-NEXT:    orl $1, %esi
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %esi
; CHECK-NEXT:    testl %edx, %edx
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %t0 = and i32 %x, 128 ; clearly a power-of-two or zero
  %t1 = or i32 %y, 1 ; one low bit set, may be a power of two
  %t2 = urem i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  ret i1 %t3
}
