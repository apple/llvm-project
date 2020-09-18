; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the strncat libcall simplifier works correctly.
;
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

@hello = constant [6 x i8] c"hello\00"
@empty = constant [1 x i8] c"\00"
@a = common global [32 x i8] zeroinitializer, align 1
declare i8* @strncat(i8*, i8*, i32)

define void @test_simplify1() {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    [[STRLEN:%.*]] = call i32 @strlen(i8* nonnull dereferenceable(1) getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 0))
; CHECK-NEXT:    [[ENDPTR:%.*]] = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 [[STRLEN]]
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull align 1 dereferenceable(6) [[ENDPTR]], i8* nonnull align 1 dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @hello, i32 0, i32 0), i32 6, i1 false)
; CHECK-NEXT:    ret void
;

  %dst = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  call i8* @strncat(i8* %dst, i8* %src, i32 13)
  ret void
}

define void @test_simplify2() {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    ret void
;

  %dst = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %src = getelementptr [1 x i8], [1 x i8]* @empty, i32 0, i32 0
  call i8* @strncat(i8* %dst, i8* %src, i32 13)
  ret void
}

define void @test_simplify3() {
; CHECK-LABEL: @test_simplify3(
; CHECK-NEXT:    ret void
;

  %dst = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  call i8* @strncat(i8* %dst, i8* %src, i32 0)
  ret void
}

define void @test_nosimplify1() {
; CHECK-LABEL: @test_nosimplify1(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @strncat(i8* nonnull dereferenceable(1) getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 0), i8* nonnull dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @hello, i32 0, i32 0), i32 1)
; CHECK-NEXT:    ret void
;

  %dst = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  call i8* @strncat(i8* %dst, i8* %src, i32 1)
  ret void
}

; strncat(nonnull x, nonnull y, n)  -> strncat(nonnull x, y, n)
define i8* @test1(i8* %str1, i8* %str2, i32 %n) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[TEMP1:%.*]] = call i8* @strncat(i8* nonnull [[STR1:%.*]], i8* nonnull [[STR2:%.*]], i32 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[TEMP1]]
;

  %temp1 = call i8* @strncat(i8* nonnull %str1, i8* nonnull %str2, i32 %n)
  ret i8* %temp1
}

; strncat(x, y, 0)  -> x
define i8* @test2(i8* %str1, i8* %str2, i32 %n) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i8* [[STR1:%.*]]
;

  %temp1 = call i8* @strncat(i8* %str1, i8* %str2, i32 0)
  ret i8* %temp1
}

; strncat(x, y, 5)  -> strncat(nonnull x, nonnull y, 5)
define i8* @test3(i8* %str1, i8* %str2, i32 %n) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[TEMP1:%.*]] = call i8* @strncat(i8* nonnull dereferenceable(1) [[STR1:%.*]], i8* nonnull dereferenceable(1) [[STR2:%.*]], i32 5)
; CHECK-NEXT:    ret i8* [[TEMP1]]
;

  %temp1 = call i8* @strncat(i8* %str1, i8* %str2, i32 5)
  ret i8* %temp1
}

define i8* @test4(i8* %str1, i8* %str2, i32 %n) null_pointer_is_valid {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TEMP1:%.*]] = call i8* @strncat(i8* [[STR1:%.*]], i8* [[STR2:%.*]], i32 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[TEMP1]]
;

  %temp1 = call i8* @strncat(i8* %str1, i8* %str2, i32 %n)
  ret i8* %temp1
}

define i8* @test5(i8* %str, i32 %n) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[STRLEN:%.*]] = call i32 @strlen(i8* nonnull dereferenceable(1) [[STR:%.*]])
; CHECK-NEXT:    [[ENDPTR:%.*]] = getelementptr i8, i8* [[STR]], i32 [[STRLEN]]
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull align 1 dereferenceable(6) [[ENDPTR]], i8* nonnull align 1 dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @hello, i32 0, i32 0), i32 6, i1 false)
; CHECK-NEXT:    ret i8* [[STR]]
;
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  %temp1 = call i8* @strncat(i8* %str, i8* %src, i32 10)
  ret i8* %temp1
}
