; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-linux-gnu -global-isel -verify-machineinstrs < %s -o - | FileCheck %s --check-prefix=X64

define i64 @test_shl_i64(i64 %arg1, i64 %arg2) {
; X64-LABEL: test_shl_i64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    movq %rsi, %rcx
; X64-NEXT:    # kill: def $cl killed $cl killed $rcx
; X64-NEXT:    shlq %cl, %rax
; X64-NEXT:    retq
  %res = shl i64 %arg1, %arg2
  ret i64 %res
}

define i64 @test_shl_i64_imm(i64 %arg1) {
; X64-LABEL: test_shl_i64_imm:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    shlq $5, %rax
; X64-NEXT:    retq
  %res = shl i64 %arg1, 5
  ret i64 %res
}

define i64 @test_shl_i64_imm1(i64 %arg1) {
; X64-LABEL: test_shl_i64_imm1:
; X64:       # %bb.0:
; X64-NEXT:    leaq (%rdi,%rdi), %rax
; X64-NEXT:    retq
  %res = shl i64 %arg1, 1
  ret i64 %res
}

define i32 @test_shl_i32(i32 %arg1, i32 %arg2) {
; X64-LABEL: test_shl_i32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shll %cl, %eax
; X64-NEXT:    retq
  %res = shl i32 %arg1, %arg2
  ret i32 %res
}

define i32 @test_shl_i32_imm(i32 %arg1) {
; X64-LABEL: test_shl_i32_imm:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $5, %eax
; X64-NEXT:    retq
  %res = shl i32 %arg1, 5
  ret i32 %res
}

define i32 @test_shl_i32_imm1(i32 %arg1) {
; X64-LABEL: test_shl_i32_imm1:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi), %eax
; X64-NEXT:    retq
  %res = shl i32 %arg1, 1
  ret i32 %res
}

define i16 @test_shl_i16(i32 %arg1, i32 %arg2) {
; X64-LABEL: test_shl_i16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shlw %cl, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %a = trunc i32 %arg1 to i16
  %a2 = trunc i32 %arg2 to i16
  %res = shl i16 %a, %a2
  ret i16 %res
}

define i16 @test_shl_i16_imm(i32 %arg1) {
; X64-LABEL: test_shl_i16_imm:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlw $5, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %a = trunc i32 %arg1 to i16
  %res = shl i16 %a, 5
  ret i16 %res
}

define i16 @test_shl_i16_imm1(i32 %arg1) {
; X64-LABEL: test_shl_i16_imm1:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi), %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %a = trunc i32 %arg1 to i16
  %res = shl i16 %a, 1
  ret i16 %res
}

define i8 @test_shl_i8(i32 %arg1, i32 %arg2) {
; X64-LABEL: test_shl_i8:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shlb %cl, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %a = trunc i32 %arg1 to i8
  %a2 = trunc i32 %arg2 to i8
  %res = shl i8 %a, %a2
  ret i8 %res
}

define i8 @test_shl_i8_imm(i32 %arg1) {
; X64-LABEL: test_shl_i8_imm:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlb $5, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %a = trunc i32 %arg1 to i8
  %res = shl i8 %a, 5
  ret i8 %res
}

define i8 @test_shl_i8_imm1(i32 %arg1) {
; X64-LABEL: test_shl_i8_imm1:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal (%rdi,%rdi), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %a = trunc i32 %arg1 to i8
  %res = shl i8 %a, 1
  ret i8 %res
}

define i1 @test_shl_i1(i32 %arg1, i32 %arg2) {
; X64-LABEL: test_shl_i1:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    andb $1, %cl
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shlb %cl, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %a = trunc i32 %arg1 to i1
  %a2 = trunc i32 %arg2 to i1
  %res = shl i1 %a, %a2
  ret i1 %res
}

define i1 @test_shl_i1_imm1(i32 %arg1) {
; X64-LABEL: test_shl_i1_imm1:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movb $1, %cl
; X64-NEXT:    andb $1, %cl
; X64-NEXT:    shlb %cl, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %a = trunc i32 %arg1 to i1
  %res = shl i1 %a, 1
  ret i1 %res
}
