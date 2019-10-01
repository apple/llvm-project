; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-linux-gnu | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s --check-prefix=X64

define i32 @fn(i32 %a0, i32 %a1) {
; X86-LABEL: fn:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %ebx
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebx, -8
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl $1, {{[0-9]+}}(%esp)
; X86-NEXT:    sete %cl
; X86-NEXT:    setne %al
; X86-NEXT:    cmpl $1, {{[0-9]+}}(%esp)
; X86-NEXT:    sete %dl
; X86-NEXT:    negl %eax
; X86-NEXT:    addb %cl, %cl
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    shll %cl, %ebx
; X86-NEXT:    addb %dl, %dl
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    shll %cl, %eax
; X86-NEXT:    .p2align 4, 0x90
; X86-NEXT:  .LBB0_1: # %bb1
; X86-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NEXT:    testl %ebx, %ebx
; X86-NEXT:    je .LBB0_1
; X86-NEXT:  # %bb.2: # %bb2
; X86-NEXT:    popl %ebx
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: fn:
; X64:       # %bb.0: # %entry
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpl $1, %edi
; X64-NEXT:    sete %cl
; X64-NEXT:    setne %al
; X64-NEXT:    cmpl $1, %esi
; X64-NEXT:    sete %dl
; X64-NEXT:    negl %eax
; X64-NEXT:    addb %cl, %cl
; X64-NEXT:    movl %eax, %esi
; X64-NEXT:    shll %cl, %esi
; X64-NEXT:    addb %dl, %dl
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shll %cl, %eax
; X64-NEXT:    .p2align 4, 0x90
; X64-NEXT:  .LBB0_1: # %bb1
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    testl %esi, %esi
; X64-NEXT:    je .LBB0_1
; X64-NEXT:  # %bb.2: # %bb2
; X64-NEXT:    retq
entry:
  %cmp1 = icmp ne i32 %a0, 1
  %cmp2 = icmp eq i32 %a1, 1
  %sel1 = select i1 %cmp1, i32 0, i32 2
  %sel2 = select i1 %cmp2, i32 2, i32 0
  %sext = sext i1 %cmp1 to i32
  %shl1 = shl i32 %sext, %sel1
  %shl2 = shl i32 %sext, %sel2
  %tobool = icmp eq i32 %shl1, 0
  br label %bb1

bb1:                                              ; preds = %bb1, %entry
  br i1 %tobool, label %bb1, label %bb2

bb2:                                              ; preds = %bb1
  ret i32 %shl2
}
