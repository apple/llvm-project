; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,AVX512F
; RUN: llc < %s -mattr=+avx512f,+avx512vl,+avx512bw,+avx512dq | FileCheck %s --check-prefixes=CHECK,AVX512VL

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @test(<4 x i64> %a, <4 x x86_fp80> %b, <8 x x86_fp80>* %c) local_unnamed_addr {
; CHECK-LABEL: test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovq %xmm0, %rax
; CHECK-NEXT:    vpextrq $1, %xmm0, %rcx
; CHECK-NEXT:    vextracti128 $1, %ymm0, %xmm0
; CHECK-NEXT:    vmovq %xmm0, %rdx
; CHECK-NEXT:    vpextrq $1, %xmm0, %rsi
; CHECK-NEXT:    cmpq $3, %rsi
; CHECK-NEXT:    fld1
; CHECK-NEXT:    fldz
; CHECK-NEXT:    fld %st(0)
; CHECK-NEXT:    fcmove %st(2), %st
; CHECK-NEXT:    cmpq $2, %rdx
; CHECK-NEXT:    fld %st(1)
; CHECK-NEXT:    fcmove %st(3), %st
; CHECK-NEXT:    cmpq $1, %rcx
; CHECK-NEXT:    fld %st(2)
; CHECK-NEXT:    fcmove %st(4), %st
; CHECK-NEXT:    testq %rax, %rax
; CHECK-NEXT:    fxch %st(3)
; CHECK-NEXT:    fcmove %st(4), %st
; CHECK-NEXT:    fstp %st(4)
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    fstpt 70(%rdi)
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    fstpt 50(%rdi)
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    fstpt 30(%rdi)
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    fstpt 10(%rdi)
; CHECK-NEXT:    fxch %st(1)
; CHECK-NEXT:    fadd %st, %st(0)
; CHECK-NEXT:    fstpt 60(%rdi)
; CHECK-NEXT:    fadd %st, %st(0)
; CHECK-NEXT:    fstpt 40(%rdi)
; CHECK-NEXT:    fadd %st, %st(0)
; CHECK-NEXT:    fstpt 20(%rdi)
; CHECK-NEXT:    fadd %st, %st(0)
; CHECK-NEXT:    fstpt (%rdi)
  %1 = icmp eq <4 x i64> <i64 0, i64 1, i64 2, i64 3>, %a
  %2 = select <4 x i1> %1, <4 x x86_fp80> <x86_fp80 0xK3FFF8000000000000000, x86_fp80 0xK3FFF8000000000000000, x86_fp80 0xK3FFF8000000000000000, x86_fp80 0xK3FFF8000000000000000>, <4 x x86_fp80> zeroinitializer
  %3 = fadd <4 x x86_fp80> %2, %2
  %4 = shufflevector <4 x x86_fp80> %3, <4 x x86_fp80> %b, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  store <8 x x86_fp80> %4, <8 x x86_fp80>* %c, align 16
  unreachable
}
