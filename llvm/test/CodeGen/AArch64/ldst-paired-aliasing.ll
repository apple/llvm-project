; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu cortex-a53 < %s | FileCheck %s
target datalayout = "e-m:e-i64:64-i128:128-n8:16:32:64-S128"
target triple = "aarch64--linux-gnu"

declare void @f(i8*, i8*)
declare void @f2(i8*, i8*)
declare void @_Z5setupv()
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) #3

define i32 @main() local_unnamed_addr #1 {
; Make sure the stores happen in the correct order (the exact instructions could change).
; CHECK-LABEL: main:
; CHECK:       // %bb.0: // %for.body.lr.ph.i.i.i.i.i.i63
; CHECK-NEXT:    sub sp, sp, #112 // =112
; CHECK-NEXT:    str x30, [sp, #96] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 112
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    bl _Z5setupv
; CHECK-NEXT:    movi v0.4s, #1
; CHECK-NEXT:    mov w9, #1
; CHECK-NEXT:    add x0, sp, #48 // =48
; CHECK-NEXT:    mov x1, sp
; CHECK-NEXT:    str xzr, [sp, #80]
; CHECK-NEXT:    str w9, [sp, #80]
; CHECK-NEXT:    stp q0, q0, [sp, #48]
; CHECK-NEXT:    ldr w8, [sp, #48]
; CHECK-NEXT:    cmp w8, #1 // =1
; CHECK-NEXT:    b.ne .LBB0_2
; CHECK-NEXT:  // %bb.1: // %for.inc
; CHECK-NEXT:    bl f
; CHECK-NEXT:    b .LBB0_3
; CHECK-NEXT:  .LBB0_2: // %if.then
; CHECK-NEXT:    bl f2
; CHECK-NEXT:  .LBB0_3: // %for.inc
; CHECK-NEXT:    ldr x30, [sp, #96] // 8-byte Folded Reload
; CHECK-NEXT:    mov w0, wzr
; CHECK-NEXT:    add sp, sp, #112 // =112
; CHECK-NEXT:    ret


for.body.lr.ph.i.i.i.i.i.i63:
  %b1 = alloca [10 x i32], align 16
  %x0 = bitcast [10 x i32]* %b1 to i8*
  %b2 = alloca [10 x i32], align 16
  %x1 = bitcast [10 x i32]* %b2 to i8*
  tail call void @_Z5setupv()
  %x2 = getelementptr inbounds [10 x i32], [10 x i32]* %b1, i64 0, i64 6
  %x3 = bitcast i32* %x2 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %x3, i8 0, i64 16, i1 false)
  %arraydecay2 = getelementptr inbounds [10 x i32], [10 x i32]* %b1, i64 0, i64 0
  %x4 = bitcast [10 x i32]* %b1 to <4 x i32>*
  store <4 x i32> <i32 1, i32 1, i32 1, i32 1>, <4 x i32>* %x4, align 16
  %incdec.ptr.i7.i.i.i.i.i.i64.3 = getelementptr inbounds [10 x i32], [10 x i32]* %b1, i64 0, i64 4
  %x5 = bitcast i32* %incdec.ptr.i7.i.i.i.i.i.i64.3 to <4 x i32>*
  store <4 x i32> <i32 1, i32 1, i32 1, i32 1>, <4 x i32>* %x5, align 16
  %incdec.ptr.i7.i.i.i.i.i.i64.7 = getelementptr inbounds [10 x i32], [10 x i32]* %b1, i64 0, i64 8
  store i32 1, i32* %incdec.ptr.i7.i.i.i.i.i.i64.7, align 16
  %x6 = load i32, i32* %arraydecay2, align 16
  %cmp6 = icmp eq i32 %x6, 1
  br i1 %cmp6, label %for.inc, label %if.then

for.inc:
  call void @f(i8* %x0, i8* %x1)
  ret i32 0

if.then:
  call void @f2(i8* %x0, i8* %x1)
  ret i32 0
}
