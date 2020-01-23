; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -attributor -attributor-disable=false < %s | FileCheck %s --check-prefixes=ALL,CHECK
; RUN: opt -S -aa-pipeline='basic-aa' -passes=attributor -attributor-disable=false -attributor-annotate-decl-cs < %s | FileCheck %s --check-prefixes=ALL,DECL_CS
;
; Mostly check we do not crash on these uses

define internal void @internal(void (i8*)* %fp) {
; CHECK-LABEL: define {{[^@]+}}@internal
; CHECK-SAME: (void (i8*)* [[FP:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[TMP:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    call void @foo(i32* nocapture nofree nonnull readnone align 4 dereferenceable(4) undef)
; CHECK-NEXT:    call void [[FP]](i8* bitcast (void (i32*)* @foo to i8*))
; CHECK-NEXT:    call void @callback1(void (i32*)* nonnull @foo)
; CHECK-NEXT:    call void @callback2(void (i8*)* bitcast (void (i32*)* @foo to void (i8*)*))
; CHECK-NEXT:    call void @callback2(void (i8*)* [[FP]])
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    call void [[FP]](i8* [[TMP1]])
; CHECK-NEXT:    ret void
;
; DECL_CS-LABEL: define {{[^@]+}}@internal
; DECL_CS-SAME: (void (i8*)* [[FP:%.*]])
; DECL_CS-NEXT:  entry:
; DECL_CS-NEXT:    [[A:%.*]] = alloca i32, align 4
; DECL_CS-NEXT:    [[TMP:%.*]] = bitcast i32* [[A]] to i8*
; DECL_CS-NEXT:    call void @foo(i32* nocapture nofree nonnull readnone align 4 dereferenceable(4) undef)
; DECL_CS-NEXT:    call void [[FP]](i8* bitcast (void (i32*)* @foo to i8*))
; DECL_CS-NEXT:    call void @callback1(void (i32*)* nonnull @foo)
; DECL_CS-NEXT:    call void @callback2(void (i8*)* nonnull bitcast (void (i32*)* @foo to void (i8*)*))
; DECL_CS-NEXT:    call void @callback2(void (i8*)* [[FP]])
; DECL_CS-NEXT:    [[TMP1:%.*]] = bitcast i32* [[A]] to i8*
; DECL_CS-NEXT:    call void [[FP]](i8* [[TMP1]])
; DECL_CS-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %tmp = bitcast i32* %a to i8*
  call void @foo(i32* nonnull %a)
  call void %fp(i8* bitcast (void (i32*)* @foo to i8*))
  call void @callback1(void (i32*)* nonnull @foo)
  call void @callback2(void (i8*)* bitcast (void (i32*)* @foo to void (i8*)*))
  call void @callback2(void (i8*)* %fp)
  %tmp1 = bitcast i32* %a to i8*
  call void %fp(i8* %tmp1)
  ret void
}

define void @external(void (i8*)* %fp) {
; CHECK-LABEL: define {{[^@]+}}@external
; CHECK-SAME: (void (i8*)* [[FP:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[TMP:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    call void @foo(i32* nocapture nofree nonnull readnone align 4 dereferenceable(4) undef)
; CHECK-NEXT:    call void @callback1(void (i32*)* nonnull @foo)
; CHECK-NEXT:    call void @callback2(void (i8*)* bitcast (void (i32*)* @foo to void (i8*)*))
; CHECK-NEXT:    call void @callback2(void (i8*)* [[FP]])
; CHECK-NEXT:    call void [[FP]](i8* bitcast (void (i32*)* @foo to i8*))
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    call void [[FP]](i8* [[TMP1]])
; CHECK-NEXT:    call void @internal(void (i8*)* [[FP]])
; CHECK-NEXT:    ret void
;
; DECL_CS-LABEL: define {{[^@]+}}@external
; DECL_CS-SAME: (void (i8*)* [[FP:%.*]])
; DECL_CS-NEXT:  entry:
; DECL_CS-NEXT:    [[A:%.*]] = alloca i32, align 4
; DECL_CS-NEXT:    [[TMP:%.*]] = bitcast i32* [[A]] to i8*
; DECL_CS-NEXT:    call void @foo(i32* nocapture nofree nonnull readnone align 4 dereferenceable(4) undef)
; DECL_CS-NEXT:    call void @callback1(void (i32*)* nonnull @foo)
; DECL_CS-NEXT:    call void @callback2(void (i8*)* nonnull bitcast (void (i32*)* @foo to void (i8*)*))
; DECL_CS-NEXT:    call void @callback2(void (i8*)* [[FP]])
; DECL_CS-NEXT:    call void [[FP]](i8* bitcast (void (i32*)* @foo to i8*))
; DECL_CS-NEXT:    [[TMP1:%.*]] = bitcast i32* [[A]] to i8*
; DECL_CS-NEXT:    call void [[FP]](i8* [[TMP1]])
; DECL_CS-NEXT:    call void @internal(void (i8*)* [[FP]])
; DECL_CS-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %tmp = bitcast i32* %a to i8*
  call void @foo(i32* nonnull %a)
  call void @callback1(void (i32*)* nonnull @foo)
  call void @callback2(void (i8*)* bitcast (void (i32*)* @foo to void (i8*)*))
  call void @callback2(void (i8*)* %fp)
  call void %fp(i8* bitcast (void (i32*)* @foo to i8*))
  %tmp1 = bitcast i32* %a to i8*
  call void %fp(i8* %tmp1)
  call void @internal(void (i8*)* %fp)
  ret void
}

define internal void @foo(i32* %a) {
; ALL-LABEL: define {{[^@]+}}@foo
; ALL-SAME: (i32* nocapture nofree readnone [[A:%.*]])
; ALL-NEXT:  entry:
; ALL-NEXT:    ret void
;
entry:
  ret void
}

declare void @callback1(void (i32*)*)
declare void @callback2(void (i8*)*)
