; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android -mattr=+mmx \
; RUN:     -enable-legalize-types-checking | FileCheck %s
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu -mattr=+mmx \
; RUN:     -enable-legalize-types-checking | FileCheck %s

define i32 @TestComp128GT(fp128 %d1, fp128 %d2) {
; CHECK-LABEL: TestComp128GT:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq __gttf2
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    setg %cl
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %cmp = fcmp ogt fp128 %d1, %d2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @TestComp128GE(fp128 %d1, fp128 %d2) {
; CHECK-LABEL: TestComp128GE:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq __getf2
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    setns %cl
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %cmp = fcmp oge fp128 %d1, %d2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @TestComp128LT(fp128 %d1, fp128 %d2) {
; CHECK-LABEL: TestComp128LT:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq __lttf2
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    sets %cl
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %cmp = fcmp olt fp128 %d1, %d2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
; FIXME: This used to generate a shrl to move the sign bit of eax into bit 0.
; This no longer happens with fp128 compares being expanded by LegalizeDAG.
; We can add a new DAG combine for X86ISD::CMP/SETCC to restore this.
}

define i32 @TestComp128LE(fp128 %d1, fp128 %d2) {
; CHECK-LABEL: TestComp128LE:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq __letf2
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    setle %cl
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %cmp = fcmp ole fp128 %d1, %d2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @TestComp128EQ(fp128 %d1, fp128 %d2) {
; CHECK-LABEL: TestComp128EQ:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq __eqtf2
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    sete %cl
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %cmp = fcmp oeq fp128 %d1, %d2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @TestComp128NE(fp128 %d1, fp128 %d2) {
; CHECK-LABEL: TestComp128NE:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq __netf2
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    setne %cl
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %cmp = fcmp une fp128 %d1, %d2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @TestComp128UEQ(fp128 %d1, fp128 %d2) {
; CHECK-LABEL: TestComp128UEQ:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    subq $32, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; CHECK-NEXT:    callq __eqtf2
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    sete %bl
; CHECK-NEXT:    movaps (%rsp), %xmm0 # 16-byte Reload
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    callq __unordtf2
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    orb %bl, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    addq $32, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %cmp = fcmp ueq fp128 %d1, %d2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @TestComp128ONE(fp128 %d1, fp128 %d2) {
; CHECK-LABEL: TestComp128ONE:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    subq $32, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; CHECK-NEXT:    callq __eqtf2
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    setne %bl
; CHECK-NEXT:    movaps (%rsp), %xmm0 # 16-byte Reload
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    callq __unordtf2
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    andb %bl, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    addq $32, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %cmp = fcmp one fp128 %d1, %d2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define fp128 @TestMax(fp128 %x, fp128 %y) {
; CHECK-LABEL: TestMax:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subq $40, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps %xmm1, (%rsp) # 16-byte Spill
; CHECK-NEXT:    callq __gttf2
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    jg .LBB8_2
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    movaps (%rsp), %xmm0 # 16-byte Reload
; CHECK-NEXT:  .LBB8_2: # %entry
; CHECK-NEXT:    addq $40, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %cmp = fcmp ogt fp128 %x, %y
  %cond = select i1 %cmp, fp128 %x, fp128 %y
  ret fp128 %cond
}
