; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s

; PR31754
;
; #include <x86intrin.h>
; using u64 = unsigned long long;
;
; template<u64 K>
; void test(u64& alo, u64& ahi)
; {
;     u64 blo = K;
;     u64 bhi = 0;
;     bool cf = (alo += blo) < blo;
;     _addcarry_u64(cf, ahi, bhi, &ahi);
; }
;
; template void test<0ull>(u64&, u64&);
; template void test<1ull>(u64&, u64&);
; template void test<2ull>(u64&, u64&);
; template void test<3ull>(u64&, u64&);
; template void test<4ull>(u64&, u64&);
; template void test<0x7fffffffffffffffull>(u64&, u64&);
; template void test<0x8000000000000000ull>(u64&, u64&);
; template void test<0x8000000000000001ull>(u64&, u64&);
; template void test<0xffffffff80000000ull>(u64&, u64&);
; template void test<0xfffffffffffffffdull>(u64&, u64&);
; template void test<0xfffffffffffffffeull>(u64&, u64&);
; template void test<0xffffffffffffffffull>(u64&, u64&);

define void @test_0(i64*, i64*) {
; CHECK-LABEL: test_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %3 = load i64, i64* %1, align 8
  %4 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 0, i64 %3, i64 0)
  %5 = extractvalue { i8, i64 } %4, 1
  store i64 %5, i64* %1, align 8
  ret void
}

define void @test_1(i64*, i64*) {
; CHECK-LABEL: test_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq $1, (%rdi)
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = add i64 %3, 1
  store i64 %4, i64* %0, align 8
  %5 = icmp eq i64 %4, 0
  %6 = zext i1 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define void @test_2(i64*, i64*) {
; CHECK-LABEL: test_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq $2, (%rdi)
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = add i64 %3, 2
  store i64 %4, i64* %0, align 8
  %5 = icmp ult i64 %4, 2
  %6 = zext i1 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define void @test_3(i64*, i64*) {
; CHECK-LABEL: test_3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq $3, (%rdi)
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = add i64 %3, 3
  store i64 %4, i64* %0, align 8
  %5 = icmp ult i64 %4, 3
  %6 = zext i1 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define void @test_4(i64*, i64*) {
; CHECK-LABEL: test_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq $4, (%rdi)
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = add i64 %3, 4
  store i64 %4, i64* %0, align 8
  %5 = icmp ult i64 %4, 4
  %6 = zext i1 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define void @test_9223372036854775807(i64*, i64*) {
; CHECK-LABEL: test_9223372036854775807:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movabsq $9223372036854775807, %rax # imm = 0x7FFFFFFFFFFFFFFF
; CHECK-NEXT:    addq %rax, (%rdi)
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = add i64 %3, 9223372036854775807
  store i64 %4, i64* %0, align 8
  %5 = icmp ult i64 %4, 9223372036854775807
  %6 = zext i1 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define void @test_9223372036854775808(i64*, i64*) {
; CHECK-LABEL: test_9223372036854775808:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movabsq $-9223372036854775808, %rcx # imm = 0x8000000000000000
; CHECK-NEXT:    xorq %rax, %rcx
; CHECK-NEXT:    movq %rcx, (%rdi)
; CHECK-NEXT:    shrq $63, %rax
; CHECK-NEXT:    addb $-1, %al
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = xor i64 %3, -9223372036854775808
  store i64 %4, i64* %0, align 8
  %5 = lshr i64 %3, 63
  %6 = trunc i64 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define void @test_9223372036854775809(i64*, i64*) {
; CHECK-LABEL: test_9223372036854775809:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movabsq $-9223372036854775807, %rax # imm = 0x8000000000000001
; CHECK-NEXT:    addq %rax, (%rdi)
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = add i64 %3, -9223372036854775807
  store i64 %4, i64* %0, align 8
  %5 = icmp ult i64 %4, -9223372036854775807
  %6 = zext i1 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define void @test_18446744071562067968(i64*, i64*) {
; CHECK-LABEL: test_18446744071562067968:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq $-2147483648, (%rdi) # imm = 0x80000000
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = add i64 %3, -2147483648
  store i64 %4, i64* %0, align 8
  %5 = icmp ult i64 %4, -2147483648
  %6 = zext i1 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define void @test_18446744073709551613(i64*, i64*) {
; CHECK-LABEL: test_18446744073709551613:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq $-3, (%rdi)
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = add i64 %3, -3
  store i64 %4, i64* %0, align 8
  %5 = icmp ult i64 %4, -3
  %6 = zext i1 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define void @test_18446744073709551614(i64*, i64*) {
; CHECK-LABEL: test_18446744073709551614:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq $-2, (%rdi)
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = add i64 %3, -2
  store i64 %4, i64* %0, align 8
  %5 = icmp ult i64 %4, -2
  %6 = zext i1 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define void @test_18446744073709551615(i64*, i64*) {
; CHECK-LABEL: test_18446744073709551615:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq $-1, (%rdi)
; CHECK-NEXT:    adcq $0, (%rsi)
; CHECK-NEXT:    retq
  %3 = load i64, i64* %0, align 8
  %4 = add i64 %3, -1
  store i64 %4, i64* %0, align 8
  %5 = icmp ne i64 %3, 0
  %6 = zext i1 %5 to i8
  %7 = load i64, i64* %1, align 8
  %8 = tail call { i8, i64 } @llvm.x86.addcarry.64(i8 %6, i64 %7, i64 0)
  %9 = extractvalue { i8, i64 } %8, 1
  store i64 %9, i64* %1, align 8
  ret void
}

define i1 @illegal_type(i17 %x, i17* %p) {
; CHECK-LABEL: illegal_type:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addl $29, %edi
; CHECK-NEXT:    movw %di, (%rsi)
; CHECK-NEXT:    andl $131071, %edi # imm = 0x1FFFF
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    shrl $16, %eax
; CHECK-NEXT:    movb %al, 2(%rsi)
; CHECK-NEXT:    cmpl $29, %edi
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    retq
  %a = add i17 %x, 29
  store i17 %a, i17* %p
  %ov = icmp ult i17 %a, 29
  ret i1 %ov
}

; The overflow check may be against the input rather than the sum.

define i1 @uaddo_i64_increment_alt(i64 %x, i64* %p) {
; CHECK-LABEL: uaddo_i64_increment_alt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    incq %rdi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    movq %rdi, (%rsi)
; CHECK-NEXT:    retq
  %a = add i64 %x, 1
  store i64 %a, i64* %p
  %ov = icmp eq i64 %x, -1
  ret i1 %ov
}

; Make sure insertion is done correctly based on dominance.

define i1 @uaddo_i64_increment_alt_dom(i64 %x, i64* %p) {
; CHECK-LABEL: uaddo_i64_increment_alt_dom:
; CHECK:       # %bb.0:
; CHECK-NEXT:    incq %rdi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    movq %rdi, (%rsi)
; CHECK-NEXT:    retq
  %ov = icmp eq i64 %x, -1
  %a = add i64 %x, 1
  store i64 %a, i64* %p
  ret i1 %ov
}

; The overflow check may be against the input rather than the sum.

define i1 @uaddo_i64_decrement_alt(i64 %x, i64* %p) {
; CHECK-LABEL: uaddo_i64_decrement_alt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq $-1, %rdi
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movq %rdi, (%rsi)
; CHECK-NEXT:    retq
  %a = add i64 %x, -1
  store i64 %a, i64* %p
  %ov = icmp ne i64 %x, 0
  ret i1 %ov
}

; Make sure insertion is done correctly based on dominance.

define i1 @uaddo_i64_decrement_alt_dom(i64 %x, i64* %p) {
; CHECK-LABEL: uaddo_i64_decrement_alt_dom:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq $-1, %rdi
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    movq %rdi, (%rsi)
; CHECK-NEXT:    retq
  %ov = icmp ne i64 %x, 0
  %a = add i64 %x, -1
  store i64 %a, i64* %p
  ret i1 %ov
}

declare { i8, i64 } @llvm.x86.addcarry.64(i8, i64, i64)
