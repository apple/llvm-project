; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O0 -mtriple=x86_64-unknown-unknown -mcpu=corei7 -verify-machineinstrs | FileCheck %s -check-prefixes=X64,X64-CMOV
; RUN: llc < %s -O0 -mtriple=i686-unknown-unknown -mcpu=corei7 -verify-machineinstrs | FileCheck %s -check-prefixes=X86,X86-CMOV
; RUN: llc < %s -O0 -mtriple=i686-unknown-unknown -mcpu=corei7 -mattr=-cmov,-sse -verify-machineinstrs | FileCheck %s --check-prefixes=X86,X86-NOCMOV
; RUN: llc < %s -O0 -mtriple=i686-unknown-unknown -mcpu=corei7 -mattr=-cmov,-sse,-x87 -verify-machineinstrs | FileCheck %s --check-prefixes=X86,X86-NOX87

@sc32 = external global i32
@fsc32 = external global float

define void @atomic_fetch_add32() nounwind {
; X64-LABEL: atomic_fetch_add32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    lock incl {{.*}}(%rip)
; X64-NEXT:    lock addl $3, {{.*}}(%rip)
; X64-NEXT:    movl $5, %eax
; X64-NEXT:    lock xaddl %eax, {{.*}}(%rip)
; X64-NEXT:    lock addl %eax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; X86-LABEL: atomic_fetch_add32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    lock incl sc32
; X86-NEXT:    lock addl $3, sc32
; X86-NEXT:    movl $5, %eax
; X86-NEXT:    lock xaddl %eax, sc32
; X86-NEXT:    lock addl %eax, sc32
; X86-NEXT:    retl
entry:
  %t1 = atomicrmw add  i32* @sc32, i32 1 acquire
  %t2 = atomicrmw add  i32* @sc32, i32 3 acquire
  %t3 = atomicrmw add  i32* @sc32, i32 5 acquire
  %t4 = atomicrmw add  i32* @sc32, i32 %t3 acquire
  ret void
}

define void @atomic_fetch_sub32() nounwind {
; X64-LABEL: atomic_fetch_sub32:
; X64:       # %bb.0:
; X64-NEXT:    lock decl {{.*}}(%rip)
; X64-NEXT:    lock subl $3, {{.*}}(%rip)
; X64-NEXT:    movl $-5, %eax
; X64-NEXT:    lock xaddl %eax, {{.*}}(%rip)
; X64-NEXT:    lock subl %eax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; X86-LABEL: atomic_fetch_sub32:
; X86:       # %bb.0:
; X86-NEXT:    lock decl sc32
; X86-NEXT:    lock subl $3, sc32
; X86-NEXT:    movl $-5, %eax
; X86-NEXT:    lock xaddl %eax, sc32
; X86-NEXT:    lock subl %eax, sc32
; X86-NEXT:    retl
  %t1 = atomicrmw sub  i32* @sc32, i32 1 acquire
  %t2 = atomicrmw sub  i32* @sc32, i32 3 acquire
  %t3 = atomicrmw sub  i32* @sc32, i32 5 acquire
  %t4 = atomicrmw sub  i32* @sc32, i32 %t3 acquire
  ret void
}

define void @atomic_fetch_and32() nounwind {
; X64-LABEL: atomic_fetch_and32:
; X64:       # %bb.0:
; X64-NEXT:    lock andl $3, {{.*}}(%rip)
; X64-NEXT:    movl sc32, %eax
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:  .LBB2_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    andl $5, %ecx
; X64-NEXT:    lock cmpxchgl %ecx, {{.*}}(%rip)
; X64-NEXT:    sete %dl
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    movl %ecx, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    jne .LBB2_2
; X64-NEXT:    jmp .LBB2_1
; X64-NEXT:  .LBB2_2: # %atomicrmw.end
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    lock andl %eax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; X86-LABEL: atomic_fetch_and32:
; X86:       # %bb.0:
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    lock andl $3, sc32
; X86-NEXT:    movl sc32, %eax
; X86-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NEXT:  .LBB2_1: # %atomicrmw.start
; X86-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    andl $5, %ecx
; X86-NEXT:    lock cmpxchgl %ecx, sc32
; X86-NEXT:    sete %dl
; X86-NEXT:    testb $1, %dl
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NEXT:    jne .LBB2_2
; X86-NEXT:    jmp .LBB2_1
; X86-NEXT:  .LBB2_2: # %atomicrmw.end
; X86-NEXT:    movl (%esp), %eax # 4-byte Reload
; X86-NEXT:    lock andl %eax, sc32
; X86-NEXT:    addl $8, %esp
; X86-NEXT:    retl
  %t1 = atomicrmw and  i32* @sc32, i32 3 acquire
  %t2 = atomicrmw and  i32* @sc32, i32 5 acquire
  %t3 = atomicrmw and  i32* @sc32, i32 %t2 acquire
  ret void
}

define void @atomic_fetch_or32() nounwind {
; X64-LABEL: atomic_fetch_or32:
; X64:       # %bb.0:
; X64-NEXT:    lock orl $3, {{.*}}(%rip)
; X64-NEXT:    movl sc32, %eax
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:  .LBB3_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    orl $5, %ecx
; X64-NEXT:    lock cmpxchgl %ecx, {{.*}}(%rip)
; X64-NEXT:    sete %dl
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    movl %ecx, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    jne .LBB3_2
; X64-NEXT:    jmp .LBB3_1
; X64-NEXT:  .LBB3_2: # %atomicrmw.end
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    lock orl %eax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; X86-LABEL: atomic_fetch_or32:
; X86:       # %bb.0:
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    lock orl $3, sc32
; X86-NEXT:    movl sc32, %eax
; X86-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NEXT:  .LBB3_1: # %atomicrmw.start
; X86-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    orl $5, %ecx
; X86-NEXT:    lock cmpxchgl %ecx, sc32
; X86-NEXT:    sete %dl
; X86-NEXT:    testb $1, %dl
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NEXT:    jne .LBB3_2
; X86-NEXT:    jmp .LBB3_1
; X86-NEXT:  .LBB3_2: # %atomicrmw.end
; X86-NEXT:    movl (%esp), %eax # 4-byte Reload
; X86-NEXT:    lock orl %eax, sc32
; X86-NEXT:    addl $8, %esp
; X86-NEXT:    retl
  %t1 = atomicrmw or   i32* @sc32, i32 3 acquire
  %t2 = atomicrmw or   i32* @sc32, i32 5 acquire
  %t3 = atomicrmw or   i32* @sc32, i32 %t2 acquire
  ret void
}

define void @atomic_fetch_xor32() nounwind {
; X64-LABEL: atomic_fetch_xor32:
; X64:       # %bb.0:
; X64-NEXT:    lock xorl $3, {{.*}}(%rip)
; X64-NEXT:    movl sc32, %eax
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:  .LBB4_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    xorl $5, %ecx
; X64-NEXT:    lock cmpxchgl %ecx, {{.*}}(%rip)
; X64-NEXT:    sete %dl
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    movl %ecx, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    jne .LBB4_2
; X64-NEXT:    jmp .LBB4_1
; X64-NEXT:  .LBB4_2: # %atomicrmw.end
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    lock xorl %eax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; X86-LABEL: atomic_fetch_xor32:
; X86:       # %bb.0:
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    lock xorl $3, sc32
; X86-NEXT:    movl sc32, %eax
; X86-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NEXT:  .LBB4_1: # %atomicrmw.start
; X86-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    xorl $5, %ecx
; X86-NEXT:    lock cmpxchgl %ecx, sc32
; X86-NEXT:    sete %dl
; X86-NEXT:    testb $1, %dl
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NEXT:    jne .LBB4_2
; X86-NEXT:    jmp .LBB4_1
; X86-NEXT:  .LBB4_2: # %atomicrmw.end
; X86-NEXT:    movl (%esp), %eax # 4-byte Reload
; X86-NEXT:    lock xorl %eax, sc32
; X86-NEXT:    addl $8, %esp
; X86-NEXT:    retl
  %t1 = atomicrmw xor  i32* @sc32, i32 3 acquire
  %t2 = atomicrmw xor  i32* @sc32, i32 5 acquire
  %t3 = atomicrmw xor  i32* @sc32, i32 %t2 acquire
  ret void
}

define void @atomic_fetch_nand32(i32 %x) nounwind {
; X64-LABEL: atomic_fetch_nand32:
; X64:       # %bb.0:
; X64-NEXT:    movl sc32, %eax
; X64-NEXT:    movl %edi, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:  .LBB5_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %edx # 4-byte Reload
; X64-NEXT:    andl %edx, %ecx
; X64-NEXT:    notl %ecx
; X64-NEXT:    lock cmpxchgl %ecx, {{.*}}(%rip)
; X64-NEXT:    sete %sil
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    jne .LBB5_2
; X64-NEXT:    jmp .LBB5_1
; X64-NEXT:  .LBB5_2: # %atomicrmw.end
; X64-NEXT:    retq
;
; X86-LABEL: atomic_fetch_nand32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebx
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl sc32, %ecx
; X86-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NEXT:    movl %ecx, (%esp) # 4-byte Spill
; X86-NEXT:  .LBB5_1: # %atomicrmw.start
; X86-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NEXT:    movl (%esp), %eax # 4-byte Reload
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-NEXT:    andl %edx, %ecx
; X86-NEXT:    notl %ecx
; X86-NEXT:    lock cmpxchgl %ecx, sc32
; X86-NEXT:    sete %bl
; X86-NEXT:    testb $1, %bl
; X86-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NEXT:    jne .LBB5_2
; X86-NEXT:    jmp .LBB5_1
; X86-NEXT:  .LBB5_2: # %atomicrmw.end
; X86-NEXT:    addl $8, %esp
; X86-NEXT:    popl %ebx
; X86-NEXT:    retl
  %t1 = atomicrmw nand i32* @sc32, i32 %x acquire
  ret void
}

define void @atomic_fetch_max32(i32 %x) nounwind {
; X64-LABEL: atomic_fetch_max32:
; X64:       # %bb.0:
; X64-NEXT:    movl sc32, %eax
; X64-NEXT:    movl %edi, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:  .LBB6_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %edx # 4-byte Reload
; X64-NEXT:    subl %edx, %ecx
; X64-NEXT:    cmovgel %eax, %edx
; X64-NEXT:    lock cmpxchgl %edx, {{.*}}(%rip)
; X64-NEXT:    sete %sil
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %ecx, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    jne .LBB6_2
; X64-NEXT:    jmp .LBB6_1
; X64-NEXT:  .LBB6_2: # %atomicrmw.end
; X64-NEXT:    retq
;
; X86-CMOV-LABEL: atomic_fetch_max32:
; X86-CMOV:       # %bb.0:
; X86-CMOV-NEXT:    pushl %ebx
; X86-CMOV-NEXT:    subl $12, %esp
; X86-CMOV-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-CMOV-NEXT:    movl sc32, %ecx
; X86-CMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:  .LBB6_1: # %atomicrmw.start
; X86-CMOV-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-CMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-CMOV-NEXT:    movl %eax, %ecx
; X86-CMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-CMOV-NEXT:    subl %edx, %ecx
; X86-CMOV-NEXT:    cmovgel %eax, %edx
; X86-CMOV-NEXT:    lock cmpxchgl %edx, sc32
; X86-CMOV-NEXT:    sete %bl
; X86-CMOV-NEXT:    testb $1, %bl
; X86-CMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:    movl %ecx, (%esp) # 4-byte Spill
; X86-CMOV-NEXT:    jne .LBB6_2
; X86-CMOV-NEXT:    jmp .LBB6_1
; X86-CMOV-NEXT:  .LBB6_2: # %atomicrmw.end
; X86-CMOV-NEXT:    addl $12, %esp
; X86-CMOV-NEXT:    popl %ebx
; X86-CMOV-NEXT:    retl
;
; X86-NOCMOV-LABEL: atomic_fetch_max32:
; X86-NOCMOV:       # %bb.0:
; X86-NOCMOV-NEXT:    pushl %ebx
; X86-NOCMOV-NEXT:    pushl %esi
; X86-NOCMOV-NEXT:    subl $20, %esp
; X86-NOCMOV-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOCMOV-NEXT:    movl sc32, %ecx
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:  .LBB6_1: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, %ecx
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-NOCMOV-NEXT:    subl %edx, %ecx
; X86-NOCMOV-NEXT:    movl %eax, %esi
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    jge .LBB6_4
; X86-NOCMOV-NEXT:  # %bb.3: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # in Loop: Header=BB6_1 Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:  .LBB6_4: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # in Loop: Header=BB6_1 Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %ecx, %eax
; X86-NOCMOV-NEXT:    movl (%esp), %edx # 4-byte Reload
; X86-NOCMOV-NEXT:    lock cmpxchgl %edx, sc32
; X86-NOCMOV-NEXT:    sete %bl
; X86-NOCMOV-NEXT:    testb $1, %bl
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    jne .LBB6_2
; X86-NOCMOV-NEXT:    jmp .LBB6_1
; X86-NOCMOV-NEXT:  .LBB6_2: # %atomicrmw.end
; X86-NOCMOV-NEXT:    addl $20, %esp
; X86-NOCMOV-NEXT:    popl %esi
; X86-NOCMOV-NEXT:    popl %ebx
; X86-NOCMOV-NEXT:    retl
;
; X86-NOX87-LABEL: atomic_fetch_max32:
; X86-NOX87:       # %bb.0:
; X86-NOX87-NEXT:    pushl %ebx
; X86-NOX87-NEXT:    pushl %esi
; X86-NOX87-NEXT:    subl $20, %esp
; X86-NOX87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOX87-NEXT:    movl sc32, %ecx
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:  .LBB6_1: # %atomicrmw.start
; X86-NOX87-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, %ecx
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-NOX87-NEXT:    subl %edx, %ecx
; X86-NOX87-NEXT:    movl %eax, %esi
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    jge .LBB6_4
; X86-NOX87-NEXT:  # %bb.3: # %atomicrmw.start
; X86-NOX87-NEXT:    # in Loop: Header=BB6_1 Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:  .LBB6_4: # %atomicrmw.start
; X86-NOX87-NEXT:    # in Loop: Header=BB6_1 Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NOX87-NEXT:    movl %ecx, %eax
; X86-NOX87-NEXT:    movl (%esp), %edx # 4-byte Reload
; X86-NOX87-NEXT:    lock cmpxchgl %edx, sc32
; X86-NOX87-NEXT:    sete %bl
; X86-NOX87-NEXT:    testb $1, %bl
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    jne .LBB6_2
; X86-NOX87-NEXT:    jmp .LBB6_1
; X86-NOX87-NEXT:  .LBB6_2: # %atomicrmw.end
; X86-NOX87-NEXT:    addl $20, %esp
; X86-NOX87-NEXT:    popl %esi
; X86-NOX87-NEXT:    popl %ebx
; X86-NOX87-NEXT:    retl
  %t1 = atomicrmw max  i32* @sc32, i32 %x acquire
  ret void
}

define void @atomic_fetch_min32(i32 %x) nounwind {
; X64-LABEL: atomic_fetch_min32:
; X64:       # %bb.0:
; X64-NEXT:    movl sc32, %eax
; X64-NEXT:    movl %edi, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:  .LBB7_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %edx # 4-byte Reload
; X64-NEXT:    subl %edx, %ecx
; X64-NEXT:    cmovlel %eax, %edx
; X64-NEXT:    lock cmpxchgl %edx, {{.*}}(%rip)
; X64-NEXT:    sete %sil
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %ecx, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    jne .LBB7_2
; X64-NEXT:    jmp .LBB7_1
; X64-NEXT:  .LBB7_2: # %atomicrmw.end
; X64-NEXT:    retq
;
; X86-CMOV-LABEL: atomic_fetch_min32:
; X86-CMOV:       # %bb.0:
; X86-CMOV-NEXT:    pushl %ebx
; X86-CMOV-NEXT:    subl $12, %esp
; X86-CMOV-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-CMOV-NEXT:    movl sc32, %ecx
; X86-CMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:  .LBB7_1: # %atomicrmw.start
; X86-CMOV-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-CMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-CMOV-NEXT:    movl %eax, %ecx
; X86-CMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-CMOV-NEXT:    subl %edx, %ecx
; X86-CMOV-NEXT:    cmovlel %eax, %edx
; X86-CMOV-NEXT:    lock cmpxchgl %edx, sc32
; X86-CMOV-NEXT:    sete %bl
; X86-CMOV-NEXT:    testb $1, %bl
; X86-CMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:    movl %ecx, (%esp) # 4-byte Spill
; X86-CMOV-NEXT:    jne .LBB7_2
; X86-CMOV-NEXT:    jmp .LBB7_1
; X86-CMOV-NEXT:  .LBB7_2: # %atomicrmw.end
; X86-CMOV-NEXT:    addl $12, %esp
; X86-CMOV-NEXT:    popl %ebx
; X86-CMOV-NEXT:    retl
;
; X86-NOCMOV-LABEL: atomic_fetch_min32:
; X86-NOCMOV:       # %bb.0:
; X86-NOCMOV-NEXT:    pushl %ebx
; X86-NOCMOV-NEXT:    pushl %esi
; X86-NOCMOV-NEXT:    subl $20, %esp
; X86-NOCMOV-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOCMOV-NEXT:    movl sc32, %ecx
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:  .LBB7_1: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, %ecx
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-NOCMOV-NEXT:    subl %edx, %ecx
; X86-NOCMOV-NEXT:    movl %eax, %esi
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    jle .LBB7_4
; X86-NOCMOV-NEXT:  # %bb.3: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # in Loop: Header=BB7_1 Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:  .LBB7_4: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # in Loop: Header=BB7_1 Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %ecx, %eax
; X86-NOCMOV-NEXT:    movl (%esp), %edx # 4-byte Reload
; X86-NOCMOV-NEXT:    lock cmpxchgl %edx, sc32
; X86-NOCMOV-NEXT:    sete %bl
; X86-NOCMOV-NEXT:    testb $1, %bl
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    jne .LBB7_2
; X86-NOCMOV-NEXT:    jmp .LBB7_1
; X86-NOCMOV-NEXT:  .LBB7_2: # %atomicrmw.end
; X86-NOCMOV-NEXT:    addl $20, %esp
; X86-NOCMOV-NEXT:    popl %esi
; X86-NOCMOV-NEXT:    popl %ebx
; X86-NOCMOV-NEXT:    retl
;
; X86-NOX87-LABEL: atomic_fetch_min32:
; X86-NOX87:       # %bb.0:
; X86-NOX87-NEXT:    pushl %ebx
; X86-NOX87-NEXT:    pushl %esi
; X86-NOX87-NEXT:    subl $20, %esp
; X86-NOX87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOX87-NEXT:    movl sc32, %ecx
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:  .LBB7_1: # %atomicrmw.start
; X86-NOX87-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, %ecx
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-NOX87-NEXT:    subl %edx, %ecx
; X86-NOX87-NEXT:    movl %eax, %esi
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    jle .LBB7_4
; X86-NOX87-NEXT:  # %bb.3: # %atomicrmw.start
; X86-NOX87-NEXT:    # in Loop: Header=BB7_1 Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:  .LBB7_4: # %atomicrmw.start
; X86-NOX87-NEXT:    # in Loop: Header=BB7_1 Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NOX87-NEXT:    movl %ecx, %eax
; X86-NOX87-NEXT:    movl (%esp), %edx # 4-byte Reload
; X86-NOX87-NEXT:    lock cmpxchgl %edx, sc32
; X86-NOX87-NEXT:    sete %bl
; X86-NOX87-NEXT:    testb $1, %bl
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    jne .LBB7_2
; X86-NOX87-NEXT:    jmp .LBB7_1
; X86-NOX87-NEXT:  .LBB7_2: # %atomicrmw.end
; X86-NOX87-NEXT:    addl $20, %esp
; X86-NOX87-NEXT:    popl %esi
; X86-NOX87-NEXT:    popl %ebx
; X86-NOX87-NEXT:    retl
  %t1 = atomicrmw min  i32* @sc32, i32 %x acquire
  ret void
}

define void @atomic_fetch_umax32(i32 %x) nounwind {
; X64-LABEL: atomic_fetch_umax32:
; X64:       # %bb.0:
; X64-NEXT:    movl sc32, %eax
; X64-NEXT:    movl %edi, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:  .LBB8_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %edx # 4-byte Reload
; X64-NEXT:    subl %edx, %ecx
; X64-NEXT:    cmoval %eax, %edx
; X64-NEXT:    lock cmpxchgl %edx, {{.*}}(%rip)
; X64-NEXT:    sete %sil
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %ecx, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    jne .LBB8_2
; X64-NEXT:    jmp .LBB8_1
; X64-NEXT:  .LBB8_2: # %atomicrmw.end
; X64-NEXT:    retq
;
; X86-CMOV-LABEL: atomic_fetch_umax32:
; X86-CMOV:       # %bb.0:
; X86-CMOV-NEXT:    pushl %ebx
; X86-CMOV-NEXT:    subl $12, %esp
; X86-CMOV-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-CMOV-NEXT:    movl sc32, %ecx
; X86-CMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:  .LBB8_1: # %atomicrmw.start
; X86-CMOV-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-CMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-CMOV-NEXT:    movl %eax, %ecx
; X86-CMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-CMOV-NEXT:    subl %edx, %ecx
; X86-CMOV-NEXT:    cmoval %eax, %edx
; X86-CMOV-NEXT:    lock cmpxchgl %edx, sc32
; X86-CMOV-NEXT:    sete %bl
; X86-CMOV-NEXT:    testb $1, %bl
; X86-CMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:    movl %ecx, (%esp) # 4-byte Spill
; X86-CMOV-NEXT:    jne .LBB8_2
; X86-CMOV-NEXT:    jmp .LBB8_1
; X86-CMOV-NEXT:  .LBB8_2: # %atomicrmw.end
; X86-CMOV-NEXT:    addl $12, %esp
; X86-CMOV-NEXT:    popl %ebx
; X86-CMOV-NEXT:    retl
;
; X86-NOCMOV-LABEL: atomic_fetch_umax32:
; X86-NOCMOV:       # %bb.0:
; X86-NOCMOV-NEXT:    pushl %ebx
; X86-NOCMOV-NEXT:    pushl %esi
; X86-NOCMOV-NEXT:    subl $20, %esp
; X86-NOCMOV-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOCMOV-NEXT:    movl sc32, %ecx
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:  .LBB8_1: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, %ecx
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-NOCMOV-NEXT:    subl %edx, %ecx
; X86-NOCMOV-NEXT:    movl %eax, %esi
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    ja .LBB8_4
; X86-NOCMOV-NEXT:  # %bb.3: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # in Loop: Header=BB8_1 Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:  .LBB8_4: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # in Loop: Header=BB8_1 Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %ecx, %eax
; X86-NOCMOV-NEXT:    movl (%esp), %edx # 4-byte Reload
; X86-NOCMOV-NEXT:    lock cmpxchgl %edx, sc32
; X86-NOCMOV-NEXT:    sete %bl
; X86-NOCMOV-NEXT:    testb $1, %bl
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    jne .LBB8_2
; X86-NOCMOV-NEXT:    jmp .LBB8_1
; X86-NOCMOV-NEXT:  .LBB8_2: # %atomicrmw.end
; X86-NOCMOV-NEXT:    addl $20, %esp
; X86-NOCMOV-NEXT:    popl %esi
; X86-NOCMOV-NEXT:    popl %ebx
; X86-NOCMOV-NEXT:    retl
;
; X86-NOX87-LABEL: atomic_fetch_umax32:
; X86-NOX87:       # %bb.0:
; X86-NOX87-NEXT:    pushl %ebx
; X86-NOX87-NEXT:    pushl %esi
; X86-NOX87-NEXT:    subl $20, %esp
; X86-NOX87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOX87-NEXT:    movl sc32, %ecx
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:  .LBB8_1: # %atomicrmw.start
; X86-NOX87-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, %ecx
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-NOX87-NEXT:    subl %edx, %ecx
; X86-NOX87-NEXT:    movl %eax, %esi
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    ja .LBB8_4
; X86-NOX87-NEXT:  # %bb.3: # %atomicrmw.start
; X86-NOX87-NEXT:    # in Loop: Header=BB8_1 Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:  .LBB8_4: # %atomicrmw.start
; X86-NOX87-NEXT:    # in Loop: Header=BB8_1 Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NOX87-NEXT:    movl %ecx, %eax
; X86-NOX87-NEXT:    movl (%esp), %edx # 4-byte Reload
; X86-NOX87-NEXT:    lock cmpxchgl %edx, sc32
; X86-NOX87-NEXT:    sete %bl
; X86-NOX87-NEXT:    testb $1, %bl
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    jne .LBB8_2
; X86-NOX87-NEXT:    jmp .LBB8_1
; X86-NOX87-NEXT:  .LBB8_2: # %atomicrmw.end
; X86-NOX87-NEXT:    addl $20, %esp
; X86-NOX87-NEXT:    popl %esi
; X86-NOX87-NEXT:    popl %ebx
; X86-NOX87-NEXT:    retl
  %t1 = atomicrmw umax i32* @sc32, i32 %x acquire
  ret void
}

define void @atomic_fetch_umin32(i32 %x) nounwind {
; X64-LABEL: atomic_fetch_umin32:
; X64:       # %bb.0:
; X64-NEXT:    movl sc32, %eax
; X64-NEXT:    movl %edi, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:  .LBB9_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %edx # 4-byte Reload
; X64-NEXT:    subl %edx, %ecx
; X64-NEXT:    cmovbel %eax, %edx
; X64-NEXT:    lock cmpxchgl %edx, {{.*}}(%rip)
; X64-NEXT:    sete %sil
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movl %ecx, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    jne .LBB9_2
; X64-NEXT:    jmp .LBB9_1
; X64-NEXT:  .LBB9_2: # %atomicrmw.end
; X64-NEXT:    retq
;
; X86-CMOV-LABEL: atomic_fetch_umin32:
; X86-CMOV:       # %bb.0:
; X86-CMOV-NEXT:    pushl %ebx
; X86-CMOV-NEXT:    subl $12, %esp
; X86-CMOV-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-CMOV-NEXT:    movl sc32, %ecx
; X86-CMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:  .LBB9_1: # %atomicrmw.start
; X86-CMOV-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-CMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-CMOV-NEXT:    movl %eax, %ecx
; X86-CMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-CMOV-NEXT:    subl %edx, %ecx
; X86-CMOV-NEXT:    cmovbel %eax, %edx
; X86-CMOV-NEXT:    lock cmpxchgl %edx, sc32
; X86-CMOV-NEXT:    sete %bl
; X86-CMOV-NEXT:    testb $1, %bl
; X86-CMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-CMOV-NEXT:    movl %ecx, (%esp) # 4-byte Spill
; X86-CMOV-NEXT:    jne .LBB9_2
; X86-CMOV-NEXT:    jmp .LBB9_1
; X86-CMOV-NEXT:  .LBB9_2: # %atomicrmw.end
; X86-CMOV-NEXT:    addl $12, %esp
; X86-CMOV-NEXT:    popl %ebx
; X86-CMOV-NEXT:    retl
;
; X86-NOCMOV-LABEL: atomic_fetch_umin32:
; X86-NOCMOV:       # %bb.0:
; X86-NOCMOV-NEXT:    pushl %ebx
; X86-NOCMOV-NEXT:    pushl %esi
; X86-NOCMOV-NEXT:    subl $20, %esp
; X86-NOCMOV-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOCMOV-NEXT:    movl sc32, %ecx
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:  .LBB9_1: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, %ecx
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-NOCMOV-NEXT:    subl %edx, %ecx
; X86-NOCMOV-NEXT:    movl %eax, %esi
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    jbe .LBB9_4
; X86-NOCMOV-NEXT:  # %bb.3: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # in Loop: Header=BB9_1 Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:  .LBB9_4: # %atomicrmw.start
; X86-NOCMOV-NEXT:    # in Loop: Header=BB9_1 Depth=1
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOCMOV-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; X86-NOCMOV-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NOCMOV-NEXT:    movl %ecx, %eax
; X86-NOCMOV-NEXT:    movl (%esp), %edx # 4-byte Reload
; X86-NOCMOV-NEXT:    lock cmpxchgl %edx, sc32
; X86-NOCMOV-NEXT:    sete %bl
; X86-NOCMOV-NEXT:    testb $1, %bl
; X86-NOCMOV-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOCMOV-NEXT:    jne .LBB9_2
; X86-NOCMOV-NEXT:    jmp .LBB9_1
; X86-NOCMOV-NEXT:  .LBB9_2: # %atomicrmw.end
; X86-NOCMOV-NEXT:    addl $20, %esp
; X86-NOCMOV-NEXT:    popl %esi
; X86-NOCMOV-NEXT:    popl %ebx
; X86-NOCMOV-NEXT:    retl
;
; X86-NOX87-LABEL: atomic_fetch_umin32:
; X86-NOX87:       # %bb.0:
; X86-NOX87-NEXT:    pushl %ebx
; X86-NOX87-NEXT:    pushl %esi
; X86-NOX87-NEXT:    subl $20, %esp
; X86-NOX87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOX87-NEXT:    movl sc32, %ecx
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:  .LBB9_1: # %atomicrmw.start
; X86-NOX87-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, %ecx
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; X86-NOX87-NEXT:    subl %edx, %ecx
; X86-NOX87-NEXT:    movl %eax, %esi
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    jbe .LBB9_4
; X86-NOX87-NEXT:  # %bb.3: # %atomicrmw.start
; X86-NOX87-NEXT:    # in Loop: Header=BB9_1 Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:  .LBB9_4: # %atomicrmw.start
; X86-NOX87-NEXT:    # in Loop: Header=BB9_1 Depth=1
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NOX87-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; X86-NOX87-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NOX87-NEXT:    movl %ecx, %eax
; X86-NOX87-NEXT:    movl (%esp), %edx # 4-byte Reload
; X86-NOX87-NEXT:    lock cmpxchgl %edx, sc32
; X86-NOX87-NEXT:    sete %bl
; X86-NOX87-NEXT:    testb $1, %bl
; X86-NOX87-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NOX87-NEXT:    jne .LBB9_2
; X86-NOX87-NEXT:    jmp .LBB9_1
; X86-NOX87-NEXT:  .LBB9_2: # %atomicrmw.end
; X86-NOX87-NEXT:    addl $20, %esp
; X86-NOX87-NEXT:    popl %esi
; X86-NOX87-NEXT:    popl %ebx
; X86-NOX87-NEXT:    retl
  %t1 = atomicrmw umin i32* @sc32, i32 %x acquire
  ret void
}

define void @atomic_fetch_cmpxchg32() nounwind {
; X64-LABEL: atomic_fetch_cmpxchg32:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    movl $1, %ecx
; X64-NEXT:    lock cmpxchgl %ecx, {{.*}}(%rip)
; X64-NEXT:    retq
;
; X86-LABEL: atomic_fetch_cmpxchg32:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    movl $1, %ecx
; X86-NEXT:    lock cmpxchgl %ecx, sc32
; X86-NEXT:    retl
  %t1 = cmpxchg i32* @sc32, i32 0, i32 1 acquire acquire
  ret void
}

define void @atomic_fetch_store32(i32 %x) nounwind {
; X64-LABEL: atomic_fetch_store32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, {{.*}}(%rip)
; X64-NEXT:    retq
;
; X86-LABEL: atomic_fetch_store32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, sc32
; X86-NEXT:    retl
  store atomic i32 %x, i32* @sc32 release, align 4
  ret void
}

define void @atomic_fetch_swap32(i32 %x) nounwind {
; X64-LABEL: atomic_fetch_swap32:
; X64:       # %bb.0:
; X64-NEXT:    xchgl %edi, {{.*}}(%rip)
; X64-NEXT:    retq
;
; X86-LABEL: atomic_fetch_swap32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    xchgl %eax, sc32
; X86-NEXT:    retl
  %t1 = atomicrmw xchg i32* @sc32, i32 %x acquire
  ret void
}

define void @atomic_fetch_swapf32(float %x) nounwind {
; X64-LABEL: atomic_fetch_swapf32:
; X64:       # %bb.0:
; X64-NEXT:    movd %xmm0, %eax
; X64-NEXT:    xchgl %eax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; X86-CMOV-LABEL: atomic_fetch_swapf32:
; X86-CMOV:       # %bb.0:
; X86-CMOV-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-CMOV-NEXT:    movd %xmm0, %eax
; X86-CMOV-NEXT:    xchgl %eax, fsc32
; X86-CMOV-NEXT:    retl
;
; X86-NOCMOV-LABEL: atomic_fetch_swapf32:
; X86-NOCMOV:       # %bb.0:
; X86-NOCMOV-NEXT:    pushl %eax
; X86-NOCMOV-NEXT:    flds {{[0-9]+}}(%esp)
; X86-NOCMOV-NEXT:    fstps (%esp)
; X86-NOCMOV-NEXT:    movl (%esp), %eax
; X86-NOCMOV-NEXT:    xchgl %eax, fsc32
; X86-NOCMOV-NEXT:    popl %eax
; X86-NOCMOV-NEXT:    retl
;
; X86-NOX87-LABEL: atomic_fetch_swapf32:
; X86-NOX87:       # %bb.0:
; X86-NOX87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOX87-NEXT:    xchgl %eax, fsc32
; X86-NOX87-NEXT:    retl
  %t1 = atomicrmw xchg float* @fsc32, float %x acquire
  ret void
}
