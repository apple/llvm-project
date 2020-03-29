; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=core2 | FileCheck %s

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind
declare void @llvm.memcpy.inline.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind

define void @test1(i8* %a, i8* %b) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq (%rsi), %rax
; CHECK-NEXT:    movq %rax, (%rdi)
; CHECK-NEXT:    retq
  tail call void @llvm.memcpy.inline.p0i8.p0i8.i64(i8* %a, i8* %b, i64 8, i1 0 )
  ret void
}

define void @regular_memcpy_calls_external_function(i8* %a, i8* %b) nounwind {
; CHECK-LABEL: regular_memcpy_calls_external_function:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $128, %edx
; CHECK-NEXT:    jmp memcpy # TAILCALL
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %a, i8* %b, i64 128, i1 0 )
  ret void
}

define void @inlined_copy_doesnt_call_external_function(i8* %a, i8* %b) nounwind {
; CHECK-LABEL: inlined_copy_doesnt_call_external_function:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $128, %ecx
; CHECK-NEXT:    rep;movsb (%rsi), %es:(%rdi)
; CHECK-NEXT:    retq
  tail call void @llvm.memcpy.inline.p0i8.p0i8.i64(i8* %a, i8* %b, i64 128, i1 0 )
  ret void
}
