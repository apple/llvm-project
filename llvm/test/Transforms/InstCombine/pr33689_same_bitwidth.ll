; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine %s -o - | FileCheck %s

; All the "useless" instructions should be removed and we shouldn't crash.

target datalayout = "p:16:16"

%i64_t = type i64

@a = external global i16
@b = external global i16*

define void @f(i1 %cond) {
; CHECK-LABEL: @f(
; CHECK-NEXT:  bb0:
; CHECK-NEXT:    [[TMP12:%.*]] = alloca [2 x i32], align 8
; CHECK-NEXT:    [[TMP12_SUB:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[TMP12]], i16 0, i16 0
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP8:%.*]] = ptrtoint [2 x i32]* [[TMP12]] to i16
; CHECK-NEXT:    store i16 [[TMP8]], i16* @a, align 2
; CHECK-NEXT:    unreachable
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP9:%.*]] = load i16*, i16** @b, align 2
; CHECK-NEXT:    store i16 0, i16* [[TMP9]], align 2
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32* [[TMP12_SUB]], align 8
; CHECK-NEXT:    [[TMP11:%.*]] = add i32 [[TMP10]], -1
; CHECK-NEXT:    store i32 [[TMP11]], i32* [[TMP12_SUB]], align 8
; CHECK-NEXT:    ret void
;
bb0:
  %tmp1 = alloca %i64_t
  %tmp2 = bitcast %i64_t* %tmp1 to i32*
  %useless3 = bitcast %i64_t* %tmp1 to i16*
  %useless4 = getelementptr inbounds i16, i16* %useless3, i16 undef
  %useless5 = bitcast i16* %useless4 to i32*
  br i1 %cond, label %bb1, label %bb2

bb1:                                              ; preds = %bb0
  %useless6 = insertvalue [1 x i32*] undef, i32* %tmp2, 0
  %useless7 = insertvalue [1 x i32*] %useless6, i32* null, 0
  %tmp8 = ptrtoint i32* %tmp2 to i16
  store i16 %tmp8, i16* @a
  unreachable

bb2:                                              ; preds = %bb0
  %tmp9 = load i16*, i16** @b
  store i16 0, i16* %tmp9
  %tmp10 = load i32, i32* %tmp2
  %tmp11 = sub i32 %tmp10, 1
  store i32 %tmp11, i32* %tmp2
  ret void
}
