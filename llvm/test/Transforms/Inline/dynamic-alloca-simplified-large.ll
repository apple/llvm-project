; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -inline < %s -S -o - | FileCheck %s
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.15.0"

define void @caller1(i8 *%p1, i1 %b) {
; CHECK-LABEL: @caller1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i1 [[B:%.*]], true
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[SPLIT:%.*]]
; CHECK:       split:
; CHECK-NEXT:    call void @callee(i8* [[P1:%.*]], i32 0, i32 -1)
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cond = icmp eq i1 %b, true
  br i1 %cond, label %exit, label %split

split:
  ; This path may be generated from CS splitting and never taken at runtime.
  call void @callee(i8* %p1, i32 0, i32 -1)
  br label %exit

exit:
  ret void
}

define  void @callee(i8* %p1, i32 %l1, i32 %l2) {
entry:
  %ext = zext i32 %l2 to i64
  %vla = alloca float, i64 %ext, align 16
  call void @extern_call(float* nonnull %vla) #3
  ret void
}


define void @caller2_below_threshold(i8 *%p1, i1 %b) {
; CHECK-LABEL: @caller2_below_threshold(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VLA_I:%.*]] = alloca float, i64 15000, align 16
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i1 [[B:%.*]], true
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[SPLIT:%.*]]
; CHECK:       split:
; CHECK-NEXT:    [[SAVEDSTACK:%.*]] = call i8* @llvm.stacksave()
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast float* [[VLA_I]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 60000, i8* [[TMP0]])
; CHECK-NEXT:    call void @extern_call(float* nonnull [[VLA_I]]) #2
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[VLA_I]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 60000, i8* [[TMP1]])
; CHECK-NEXT:    call void @llvm.stackrestore(i8* [[SAVEDSTACK]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cond = icmp eq i1 %b, true
  br i1 %cond, label %exit, label %split

split:
  call void @callee(i8* %p1, i32 0, i32 15000)
  br label %exit

exit:
  ret void
}

define  void @callee2_not_in_entry(i8* %p1, i32 %l1, i32 %l2) {
entry:
  %ext = zext i32 %l2 to i64
  %c = icmp eq i32 %l1, 42
  br i1 %c, label %bb2, label %bb3
bb2:
  %vla = alloca float, i64 %ext, align 16
  call void @extern_call(float* nonnull %vla) #3
  ret void
bb3:
  ret void
}

define void @caller3_alloca_not_in_entry(i8 *%p1, i1 %b) {
; CHECK-LABEL: @caller3_alloca_not_in_entry(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i1 [[B:%.*]], true
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[SPLIT:%.*]]
; CHECK:       split:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cond = icmp eq i1 %b, true
  br i1 %cond, label %exit, label %split

split:
  call void @callee2_not_in_entry(i8* %p1, i32 0, i32 -1)
  br label %exit

exit:
  ret void
}

define void @caller4_over_threshold(i8 *%p1, i1 %b, i32 %len) {
; CHECK-LABEL: @caller4_over_threshold(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i1 [[B:%.*]], true
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[SPLIT:%.*]]
; CHECK:       split:
; CHECK-NEXT:    call void @callee(i8* [[P1:%.*]], i32 0, i32 16500)
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cond = icmp eq i1 %b, true
  br i1 %cond, label %exit, label %split

split:
  call void @callee(i8* %p1, i32 0, i32 16500)
  br label %exit

exit:
  ret void
}

declare noalias i8* @malloc(i64)
define i8* @stack_allocate(i32 %size) #2 {
entry:
  %cmp = icmp ult i32 %size, 100
  %conv = zext i32 %size to i64
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %0 = alloca i8, i64 %conv, align 8
  br label %return

if.end:                                           ; preds = %entry
  %call = tail call i8* @malloc(i64 %conv) #3
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i8* [ %0, %if.then ], [ %call, %if.end ]
  ret i8* %retval.0
}

define i8* @test_stack_allocate_always(i32 %size) {
; CHECK-LABEL: @test_stack_allocate_always(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SAVEDSTACK:%.*]] = call i8* @llvm.stacksave()
; CHECK-NEXT:    [[CMP_I:%.*]] = icmp ult i32 [[SIZE:%.*]], 100
; CHECK-NEXT:    [[CONV_I:%.*]] = zext i32 [[SIZE]] to i64
; CHECK-NEXT:    br i1 [[CMP_I]], label [[IF_THEN_I:%.*]], label [[IF_END_I:%.*]]
; CHECK:       if.then.i:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca i8, i64 [[CONV_I]], align 8
; CHECK-NEXT:    br label [[STACK_ALLOCATE_EXIT:%.*]]
; CHECK:       if.end.i:
; CHECK-NEXT:    [[CALL_I:%.*]] = tail call i8* @malloc(i64 [[CONV_I]]) #2
; CHECK-NEXT:    br label [[STACK_ALLOCATE_EXIT]]
; CHECK:       stack_allocate.exit:
; CHECK-NEXT:    [[RETVAL_0_I:%.*]] = phi i8* [ [[TMP0]], [[IF_THEN_I]] ], [ [[CALL_I]], [[IF_END_I]] ]
; CHECK-NEXT:    call void @llvm.stackrestore(i8* [[SAVEDSTACK]])
; CHECK-NEXT:    ret i8* [[RETVAL_0_I]]
;
entry:
  %call = tail call i8* @stack_allocate(i32 %size)
  ret i8* %call
}

declare void @extern_call(float*)

attributes #1 = { argmemonly nounwind willreturn writeonly }
attributes #2 = { alwaysinline }
attributes #3 = { nounwind }

