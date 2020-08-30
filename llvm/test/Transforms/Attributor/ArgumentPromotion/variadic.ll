; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; Unused arguments from variadic functions cannot be eliminated as that changes
; their classiciation according to the SysV amd64 ABI. Clang and other frontends
; bake in the classification when they use things like byval, as in this test.

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.tt0 = type { i64, i64 }
%struct.__va_list_tag = type { i32, i32, i8*, i8* }

@t45 = internal global %struct.tt0 { i64 1335139741, i64 438042995 }, align 8

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** nocapture readnone %argv) #0 {
; CHECK-LABEL: define {{[^@]+}}@main
; CHECK-SAME: (i32 [[ARGC:%.*]], i8** nocapture nofree readnone [[ARGV:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    tail call void (i8*, i8*, i8*, i8*, i8*, ...) @callee_t0f(i8* undef, i8* undef, i8* undef, i8* undef, i8* undef, %struct.tt0* noundef nonnull byval align 8 dereferenceable(16) @t45)
; CHECK-NEXT:    ret i32 0
;
entry:
  tail call void (i8*, i8*, i8*, i8*, i8*, ...) @callee_t0f(i8* undef, i8* undef, i8* undef, i8* undef, i8* undef, %struct.tt0* byval align 8 @t45)
  ret i32 0
}

; Function Attrs: nounwind uwtable
define internal void @callee_t0f(i8* nocapture readnone %tp13, i8* nocapture readnone %tp14, i8* nocapture readnone %tp15, i8* nocapture readnone %tp16, i8* nocapture readnone %tp17, ...) {
; CHECK-LABEL: define {{[^@]+}}@callee_t0f
; CHECK-SAME: (i8* noalias nocapture nofree nonnull readnone [[TP13:%.*]], i8* noalias nocapture nofree nonnull readnone [[TP14:%.*]], i8* noalias nocapture nofree nonnull readnone [[TP15:%.*]], i8* noalias nocapture nofree nonnull readnone [[TP16:%.*]], i8* noalias nocapture nofree nonnull readnone [[TP17:%.*]], ...) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @sink(i32 noundef 0)
; CHECK-NEXT:    ret void
;
entry:
  call void @sink(i32 0)
  ret void
}

declare void @sink(i32)
