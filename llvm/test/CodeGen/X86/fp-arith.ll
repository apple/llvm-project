; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s --check-prefixes=X64

;
; FADD
;

define x86_fp80 @fiadd_fp80_i16(x86_fp80 %a0, i16 %a1) {
; X86-LABEL: fiadd_fp80_i16:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fiadds {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fiadd_fp80_i16:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movw %di, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fiadds -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i16 %a1 to x86_fp80
  %2 = fadd x86_fp80 %a0, %1
  ret x86_fp80 %2
}

define x86_fp80 @fiadd_fp80_i16_ld(x86_fp80 %a0, i16 *%a1) {
; X86-LABEL: fiadd_fp80_i16_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl (%eax), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fiadds {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fiadd_fp80_i16_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movzwl (%rdi), %eax
; X64-NEXT:    movw %ax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fiadds -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i16, i16 *%a1
  %2 = sitofp i16 %1 to x86_fp80
  %3 = fadd x86_fp80 %a0, %2
  ret x86_fp80 %3
}

define x86_fp80 @fiadd_fp80_i32(x86_fp80 %a0, i32 %a1) {
; X86-LABEL: fiadd_fp80_i32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fiaddl (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fiadd_fp80_i32:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl %edi, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fiaddl -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i32 %a1 to x86_fp80
  %2 = fadd x86_fp80 %a0, %1
  ret x86_fp80 %2
}

define x86_fp80 @fiadd_fp80_i32_ld(x86_fp80 %a0, i32 *%a1) {
; X86-LABEL: fiadd_fp80_i32_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl (%eax), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fiaddl (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fiadd_fp80_i32_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl (%rdi), %eax
; X64-NEXT:    movl %eax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fiaddl -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i32, i32 *%a1
  %2 = sitofp i32 %1 to x86_fp80
  %3 = fadd x86_fp80 %a0, %2
  ret x86_fp80 %3
}

;
; FSUB
;

define x86_fp80 @fisub_fp80_i16(x86_fp80 %a0, i16 %a1) {
; X86-LABEL: fisub_fp80_i16:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fisubs {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fisub_fp80_i16:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movw %di, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fisubs -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i16 %a1 to x86_fp80
  %2 = fsub x86_fp80 %a0, %1
  ret x86_fp80 %2
}

define x86_fp80 @fisub_fp80_i16_ld(x86_fp80 %a0, i16 *%a1) {
; X86-LABEL: fisub_fp80_i16_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl (%eax), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fisubs {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fisub_fp80_i16_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movzwl (%rdi), %eax
; X64-NEXT:    movw %ax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fisubs -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i16, i16 *%a1
  %2 = sitofp i16 %1 to x86_fp80
  %3 = fsub x86_fp80 %a0, %2
  ret x86_fp80 %3
}

define x86_fp80 @fisub_fp80_i32(x86_fp80 %a0, i32 %a1) {
; X86-LABEL: fisub_fp80_i32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fisubl (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fisub_fp80_i32:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl %edi, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fisubl -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i32 %a1 to x86_fp80
  %2 = fsub x86_fp80 %a0, %1
  ret x86_fp80 %2
}

define x86_fp80 @fisub_fp80_i32_ld(x86_fp80 %a0, i32 *%a1) {
; X86-LABEL: fisub_fp80_i32_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl (%eax), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fisubl (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fisub_fp80_i32_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl (%rdi), %eax
; X64-NEXT:    movl %eax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fisubl -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i32, i32 *%a1
  %2 = sitofp i32 %1 to x86_fp80
  %3 = fsub x86_fp80 %a0, %2
  ret x86_fp80 %3
}

;
; FSUBR
;

define x86_fp80 @fisubr_fp80_i16(x86_fp80 %a0, i16 %a1) {
; X86-LABEL: fisubr_fp80_i16:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fisubrs {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fisubr_fp80_i16:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movw %di, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fisubrs -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i16 %a1 to x86_fp80
  %2 = fsub x86_fp80 %1, %a0
  ret x86_fp80 %2
}

define x86_fp80 @fisubr_fp80_i16_ld(x86_fp80 %a0, i16 *%a1) {
; X86-LABEL: fisubr_fp80_i16_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl (%eax), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fisubrs {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fisubr_fp80_i16_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movzwl (%rdi), %eax
; X64-NEXT:    movw %ax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fisubrs -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i16, i16 *%a1
  %2 = sitofp i16 %1 to x86_fp80
  %3 = fsub x86_fp80 %2, %a0
  ret x86_fp80 %3
}

define x86_fp80 @fisubr_fp80_i32(x86_fp80 %a0, i32 %a1) {
; X86-LABEL: fisubr_fp80_i32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fisubrl (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fisubr_fp80_i32:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl %edi, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fisubrl -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i32 %a1 to x86_fp80
  %2 = fsub x86_fp80 %1, %a0
  ret x86_fp80 %2
}

define x86_fp80 @fisubr_fp80_i32_ld(x86_fp80 %a0, i32 *%a1) {
; X86-LABEL: fisubr_fp80_i32_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl (%eax), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fisubrl (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fisubr_fp80_i32_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl (%rdi), %eax
; X64-NEXT:    movl %eax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fisubrl -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i32, i32 *%a1
  %2 = sitofp i32 %1 to x86_fp80
  %3 = fsub x86_fp80 %2, %a0
  ret x86_fp80 %3
}

;
; FMUL
;

define x86_fp80 @fimul_fp80_i16(x86_fp80 %a0, i16 %a1) {
; X86-LABEL: fimul_fp80_i16:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fimuls {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fimul_fp80_i16:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movw %di, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fimuls -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i16 %a1 to x86_fp80
  %2 = fmul x86_fp80 %a0, %1
  ret x86_fp80 %2
}

define x86_fp80 @fimul_fp80_i16_ld(x86_fp80 %a0, i16 *%a1) {
; X86-LABEL: fimul_fp80_i16_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl (%eax), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fimuls {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fimul_fp80_i16_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movzwl (%rdi), %eax
; X64-NEXT:    movw %ax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fimuls -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i16, i16 *%a1
  %2 = sitofp i16 %1 to x86_fp80
  %3 = fmul x86_fp80 %a0, %2
  ret x86_fp80 %3
}

define x86_fp80 @fimul_fp80_i32(x86_fp80 %a0, i32 %a1) {
; X86-LABEL: fimul_fp80_i32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fimull (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fimul_fp80_i32:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl %edi, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fimull -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i32 %a1 to x86_fp80
  %2 = fmul x86_fp80 %a0, %1
  ret x86_fp80 %2
}

define x86_fp80 @fimul_fp80_i32_ld(x86_fp80 %a0, i32 *%a1) {
; X86-LABEL: fimul_fp80_i32_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl (%eax), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fimull (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fimul_fp80_i32_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl (%rdi), %eax
; X64-NEXT:    movl %eax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fimull -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i32, i32 *%a1
  %2 = sitofp i32 %1 to x86_fp80
  %3 = fmul x86_fp80 %a0, %2
  ret x86_fp80 %3
}

;
; FDIV
;

define x86_fp80 @fidiv_fp80_i16(x86_fp80 %a0, i16 %a1) {
; X86-LABEL: fidiv_fp80_i16:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fidivs {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fidiv_fp80_i16:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movw %di, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fidivs -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i16 %a1 to x86_fp80
  %2 = fdiv x86_fp80 %a0, %1
  ret x86_fp80 %2
}

define x86_fp80 @fidiv_fp80_i16_ld(x86_fp80 %a0, i16 *%a1) {
; X86-LABEL: fidiv_fp80_i16_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl (%eax), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fidivs {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fidiv_fp80_i16_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movzwl (%rdi), %eax
; X64-NEXT:    movw %ax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fidivs -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i16, i16 *%a1
  %2 = sitofp i16 %1 to x86_fp80
  %3 = fdiv x86_fp80 %a0, %2
  ret x86_fp80 %3
}

define x86_fp80 @fidiv_fp80_i32(x86_fp80 %a0, i32 %a1) {
; X86-LABEL: fidiv_fp80_i32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fidivl (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fidiv_fp80_i32:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl %edi, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fidivl -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i32 %a1 to x86_fp80
  %2 = fdiv x86_fp80 %a0, %1
  ret x86_fp80 %2
}

define x86_fp80 @fidiv_fp80_i32_ld(x86_fp80 %a0, i32 *%a1) {
; X86-LABEL: fidiv_fp80_i32_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl (%eax), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fidivl (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fidiv_fp80_i32_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl (%rdi), %eax
; X64-NEXT:    movl %eax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fidivl -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i32, i32 *%a1
  %2 = sitofp i32 %1 to x86_fp80
  %3 = fdiv x86_fp80 %a0, %2
  ret x86_fp80 %3
}

;
; FDIVR
;

define x86_fp80 @fidivr_fp80_i16(x86_fp80 %a0, i16 %a1) {
; X86-LABEL: fidivr_fp80_i16:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fidivrs {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fidivr_fp80_i16:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movw %di, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fidivrs -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i16 %a1 to x86_fp80
  %2 = fdiv x86_fp80 %1, %a0
  ret x86_fp80 %2
}

define x86_fp80 @fidivr_fp80_i16_ld(x86_fp80 %a0, i16 *%a1) {
; X86-LABEL: fidivr_fp80_i16_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl (%eax), %eax
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    fidivrs {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fidivr_fp80_i16_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movzwl (%rdi), %eax
; X64-NEXT:    movw %ax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fidivrs -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i16, i16 *%a1
  %2 = sitofp i16 %1 to x86_fp80
  %3 = fdiv x86_fp80 %2, %a0
  ret x86_fp80 %3
}

define x86_fp80 @fidivr_fp80_i32(x86_fp80 %a0, i32 %a1) {
; X86-LABEL: fidivr_fp80_i32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fidivrl (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fidivr_fp80_i32:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl %edi, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fidivrl -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = sitofp i32 %a1 to x86_fp80
  %2 = fdiv x86_fp80 %1, %a0
  ret x86_fp80 %2
}

define x86_fp80 @fidivr_fp80_i32_ld(x86_fp80 %a0, i32 *%a1) {
; X86-LABEL: fidivr_fp80_i32_ld:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl (%eax), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    fidivrl (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fidivr_fp80_i32_ld:
; X64:       # %bb.0:
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    movl (%rdi), %eax
; X64-NEXT:    movl %eax, -{{[0-9]+}}(%rsp)
; X64-NEXT:    fidivrl -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = load i32, i32 *%a1
  %2 = sitofp i32 %1 to x86_fp80
  %3 = fdiv x86_fp80 %2, %a0
  ret x86_fp80 %3
}
