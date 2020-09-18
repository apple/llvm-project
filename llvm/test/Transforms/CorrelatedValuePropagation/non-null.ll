; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -correlated-propagation -S | FileCheck %s

define void @test1(i8* %ptr) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[A:%.*]] = load i8, i8* [[PTR:%.*]], align 1
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    ret void
;
  %A = load i8, i8* %ptr
  br label %bb
bb:
  icmp ne i8* %ptr, null
  ret void
}

define void @test1_no_null_opt(i8* %ptr) #0 {
; CHECK-LABEL: @test1_no_null_opt(
; CHECK-NEXT:    [[A:%.*]] = load i8, i8* [[PTR:%.*]], align 1
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i8* [[PTR]], null
; CHECK-NEXT:    ret void
;
  %A = load i8, i8* %ptr
  br label %bb
bb:
  icmp ne i8* %ptr, null
  ret void
}

define void @test2(i8* %ptr) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    store i8 0, i8* [[PTR:%.*]], align 1
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    ret void
;
  store i8 0, i8* %ptr
  br label %bb
bb:
  icmp ne i8* %ptr, null
  ret void
}

define void @test2_no_null_opt(i8* %ptr) #0 {
; CHECK-LABEL: @test2_no_null_opt(
; CHECK-NEXT:    store i8 0, i8* [[PTR:%.*]], align 1
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i8* [[PTR]], null
; CHECK-NEXT:    ret void
;
  store i8 0, i8* %ptr
  br label %bb
bb:
  icmp ne i8* %ptr, null
  ret void
}

define void @test3() {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[PTR:%.*]] = alloca i8, align 1
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    ret void
;
  %ptr = alloca i8
  br label %bb
bb:
  icmp ne i8* %ptr, null
  ret void
}

;; OK to remove icmp here since ptr is coming from alloca.

define void @test3_no_null_opt() #0 {
; CHECK-LABEL: @test3_no_null_opt(
; CHECK-NEXT:    [[PTR:%.*]] = alloca i8, align 1
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    ret void
;
  %ptr = alloca i8
  br label %bb
bb:
  icmp ne i8* %ptr, null
  ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define void @test4(i8* %dest, i8* %src) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* [[DEST:%.*]], i8* [[SRC:%.*]], i32 1, i1 false)
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    ret void
;
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %dest, i8* %src, i32 1, i1 false)
  br label %bb
bb:
  icmp ne i8* %dest, null
  icmp ne i8* %src, null
  ret void
}

define void @test4_no_null_opt(i8* %dest, i8* %src) #0 {
; CHECK-LABEL: @test4_no_null_opt(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* [[DEST:%.*]], i8* [[SRC:%.*]], i32 1, i1 false)
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i8* [[DEST]], null
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i8* [[SRC]], null
; CHECK-NEXT:    ret void
;
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %dest, i8* %src, i32 1, i1 false)
  br label %bb
bb:
  icmp ne i8* %dest, null
  icmp ne i8* %src, null
  ret void
}

declare void @llvm.memmove.p0i8.p0i8.i32(i8*, i8*, i32, i1)
define void @test5(i8* %dest, i8* %src) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i32(i8* [[DEST:%.*]], i8* [[SRC:%.*]], i32 1, i1 false)
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    ret void
;
  call void @llvm.memmove.p0i8.p0i8.i32(i8* %dest, i8* %src, i32 1, i1 false)
  br label %bb
bb:
  icmp ne i8* %dest, null
  icmp ne i8* %src, null
  ret void
}

define void @test5_no_null_opt(i8* %dest, i8* %src) #0 {
; CHECK-LABEL: @test5_no_null_opt(
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i32(i8* [[DEST:%.*]], i8* [[SRC:%.*]], i32 1, i1 false)
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i8* [[DEST]], null
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i8* [[SRC]], null
; CHECK-NEXT:    ret void
;
  call void @llvm.memmove.p0i8.p0i8.i32(i8* %dest, i8* %src, i32 1, i1 false)
  br label %bb
bb:
  icmp ne i8* %dest, null
  icmp ne i8* %src, null
  ret void
}

declare void @llvm.memset.p0i8.i32(i8*, i8, i32, i1)
define void @test6(i8* %dest) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* [[DEST:%.*]], i8 -1, i32 1, i1 false)
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i32(i8* %dest, i8 255, i32 1, i1 false)
  br label %bb
bb:
  icmp ne i8* %dest, null
  ret void
}

define void @test6_no_null_opt(i8* %dest) #0 {
; CHECK-LABEL: @test6_no_null_opt(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* [[DEST:%.*]], i8 -1, i32 1, i1 false)
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i8* [[DEST]], null
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i32(i8* %dest, i8 255, i32 1, i1 false)
  br label %bb
bb:
  icmp ne i8* %dest, null
  ret void
}

define void @test7(i8* %dest, i8* %src, i32 %len) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* [[DEST:%.*]], i8* [[SRC:%.*]], i32 [[LEN:%.*]], i1 false)
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[KEEP1:%.*]] = icmp ne i8* [[DEST]], null
; CHECK-NEXT:    [[KEEP2:%.*]] = icmp ne i8* [[SRC]], null
; CHECK-NEXT:    ret void
;
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %dest, i8* %src, i32 %len, i1 false)
  br label %bb
bb:
  %KEEP1 = icmp ne i8* %dest, null
  %KEEP2 = icmp ne i8* %src, null
  ret void
}

declare void @llvm.memcpy.p1i8.p1i8.i32(i8 addrspace(1) *, i8 addrspace(1) *, i32, i1)
define void @test8(i8 addrspace(1) * %dest, i8 addrspace(1) * %src) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    call void @llvm.memcpy.p1i8.p1i8.i32(i8 addrspace(1)* [[DEST:%.*]], i8 addrspace(1)* [[SRC:%.*]], i32 1, i1 false)
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[KEEP1:%.*]] = icmp ne i8 addrspace(1)* [[DEST]], null
; CHECK-NEXT:    [[KEEP2:%.*]] = icmp ne i8 addrspace(1)* [[SRC]], null
; CHECK-NEXT:    ret void
;
  call void @llvm.memcpy.p1i8.p1i8.i32(i8 addrspace(1) * %dest, i8 addrspace(1) * %src, i32 1, i1 false)
  br label %bb
bb:
  %KEEP1 = icmp ne i8 addrspace(1) * %dest, null
  %KEEP2 = icmp ne i8 addrspace(1) * %src, null
  ret void
}

define void @test9(i8* %dest, i8* %src) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* [[DEST:%.*]], i8* [[SRC:%.*]], i32 1, i1 true)
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[KEEP1:%.*]] = icmp ne i8* [[DEST]], null
; CHECK-NEXT:    [[KEEP2:%.*]] = icmp ne i8* [[SRC]], null
; CHECK-NEXT:    ret void
;
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %dest, i8* %src, i32 1, i1 true)
  br label %bb
bb:
  %KEEP1 = icmp ne i8* %dest, null
  %KEEP2 = icmp ne i8* %src, null
  ret void
}

declare void @test10_helper(i8* %arg1, i8* %arg2, i32 %non-pointer-arg)

define void @test10(i8* %arg1, i8* %arg2, i32 %non-pointer-arg) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IS_NULL:%.*]] = icmp eq i8* [[ARG1:%.*]], null
; CHECK-NEXT:    br i1 [[IS_NULL]], label [[NULL:%.*]], label [[NON_NULL:%.*]]
; CHECK:       non_null:
; CHECK-NEXT:    call void @test10_helper(i8* nonnull [[ARG1]], i8* [[ARG2:%.*]], i32 [[NON_POINTER_ARG:%.*]])
; CHECK-NEXT:    br label [[NULL]]
; CHECK:       null:
; CHECK-NEXT:    call void @test10_helper(i8* [[ARG1]], i8* [[ARG2]], i32 [[NON_POINTER_ARG]])
; CHECK-NEXT:    ret void
;
entry:
  %is_null = icmp eq i8* %arg1, null
  br i1 %is_null, label %null, label %non_null

non_null:
  call void @test10_helper(i8* %arg1, i8* %arg2, i32 %non-pointer-arg)
  br label %null

null:
  call void @test10_helper(i8* %arg1, i8* %arg2, i32 %non-pointer-arg)
  ret void
}

declare void @test11_helper(i8* %arg)

define void @test11(i8* %arg1, i8** %arg2) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IS_NULL:%.*]] = icmp eq i8* [[ARG1:%.*]], null
; CHECK-NEXT:    br i1 [[IS_NULL]], label [[NULL:%.*]], label [[NON_NULL:%.*]]
; CHECK:       non_null:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       null:
; CHECK-NEXT:    [[ANOTHER_ARG:%.*]] = alloca i8, align 1
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[MERGED_ARG:%.*]] = phi i8* [ [[ANOTHER_ARG]], [[NULL]] ], [ [[ARG1]], [[NON_NULL]] ]
; CHECK-NEXT:    call void @test11_helper(i8* nonnull [[MERGED_ARG]])
; CHECK-NEXT:    ret void
;
entry:
  %is_null = icmp eq i8* %arg1, null
  br i1 %is_null, label %null, label %non_null

non_null:
  br label %merge

null:
  %another_arg = alloca i8
  br label %merge

merge:
  %merged_arg = phi i8* [%another_arg, %null], [%arg1, %non_null]
  call void @test11_helper(i8* %merged_arg)
  ret void
}

declare void @test12_helper(i8* %arg)

define void @test12(i8* %arg1, i8** %arg2) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IS_NULL:%.*]] = icmp eq i8* [[ARG1:%.*]], null
; CHECK-NEXT:    br i1 [[IS_NULL]], label [[NULL:%.*]], label [[NON_NULL:%.*]]
; CHECK:       non_null:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       null:
; CHECK-NEXT:    [[ANOTHER_ARG:%.*]] = load i8*, i8** [[ARG2:%.*]], align 8, !nonnull !0
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[MERGED_ARG:%.*]] = phi i8* [ [[ANOTHER_ARG]], [[NULL]] ], [ [[ARG1]], [[NON_NULL]] ]
; CHECK-NEXT:    call void @test12_helper(i8* nonnull [[MERGED_ARG]])
; CHECK-NEXT:    ret void
;
entry:
  %is_null = icmp eq i8* %arg1, null
  br i1 %is_null, label %null, label %non_null

non_null:
  br label %merge

null:
  %another_arg = load i8*, i8** %arg2, !nonnull !{}
  br label %merge

merge:
  %merged_arg = phi i8* [%another_arg, %null], [%arg1, %non_null]
  call void @test12_helper(i8* %merged_arg)
  ret void
}

define i1 @test_store_same_block(i8* %arg) {
; CHECK-LABEL: @test_store_same_block(
; CHECK-NEXT:    store i8 0, i8* [[ARG:%.*]], align 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i8* [[ARG]], null
; CHECK-NEXT:    ret i1 [[CMP]]
;
  store i8 0, i8* %arg
  %cmp = icmp ne i8* %arg, null
  ret i1 %cmp
}

attributes #0 = { null_pointer_is_valid }
