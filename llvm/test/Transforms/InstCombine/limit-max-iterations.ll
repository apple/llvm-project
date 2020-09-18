; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine --instcombine-max-iterations=0 -S | FileCheck %s --check-prefix=ZERO
; RUN: opt < %s -instcombine --instcombine-max-iterations=1 -S | FileCheck %s --check-prefix=ONE
; RUN: opt < %s -instcombine -S | FileCheck %s --check-prefix=FIXPOINT
; RUN: not --crash opt < %s -instcombine -S --instcombine-infinite-loop-threshold=2 2>&1 | FileCheck %s --check-prefix=LOOP

; Based on builtin-dynamic-object-size.ll. This requires multiple iterations of
; InstCombine to reach a fixpoint.

define i64 @weird_identity_but_ok(i64 %sz) {
; ZERO-LABEL: @weird_identity_but_ok(
; ZERO-NEXT:  entry:
; ZERO-NEXT:    [[CALL:%.*]] = tail call i8* @malloc(i64 [[SZ:%.*]])
; ZERO-NEXT:    [[CALC_SIZE:%.*]] = tail call i64 @llvm.objectsize.i64.p0i8(i8* [[CALL]], i1 false, i1 true, i1 true)
; ZERO-NEXT:    tail call void @free(i8* [[CALL]])
; ZERO-NEXT:    ret i64 [[CALC_SIZE]]
;
; ONE-LABEL: @weird_identity_but_ok(
; ONE-NEXT:  entry:
; ONE-NEXT:    [[TMP0:%.*]] = sub i64 [[SZ:%.*]], 0
; ONE-NEXT:    [[TMP1:%.*]] = icmp ult i64 [[SZ]], 0
; ONE-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i64 0, i64 [[TMP0]]
; ONE-NEXT:    ret i64 [[TMP2]]
;
; FIXPOINT-LABEL: @weird_identity_but_ok(
; FIXPOINT-NEXT:  entry:
; FIXPOINT-NEXT:    ret i64 [[SZ:%.*]]
;
; LOOP: LLVM ERROR: Instruction Combining seems stuck in an infinite loop after 2 iterations.
entry:
  %call = tail call i8* @malloc(i64 %sz)
  %calc_size = tail call i64 @llvm.objectsize.i64.p0i8(i8* %call, i1 false, i1 true, i1 true)
  tail call void @free(i8* %call)
  ret i64 %calc_size
}

declare i64 @llvm.objectsize.i64.p0i8(i8*, i1, i1, i1)
declare i8* @malloc(i64)
declare void @free(i8*)
