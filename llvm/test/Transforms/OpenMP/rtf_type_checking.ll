; RUN: opt -S -openmpopt -stats < %s 2>&1 | FileCheck %s
; REQUIRES: asserts

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@.str = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@0 = private unnamed_addr global %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8
@1 = private unnamed_addr global %struct.ident_t { i32 0, i32 322, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8

define i32 @main() {
entry:

  call void (%struct.ident_t*, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @0, void (i32*, i32*, ...)* bitcast (void (i32*, i32*)* @.omp_outlined. to void (i32*, i32*, ...)*))
  ret i32 0
}

; Only the last runtime call will be matched due that the rest of the "runtime function" calls
; have some type mismatch compared to the real runtime function. See the check at bottom.
define internal void @.omp_outlined.(i32* noalias %.global_tid., i32* noalias %.bound_tid.) {
entry:

  call void @__kmpc_master(%struct.ident_t* nonnull @0)
  call void @__kmpc_end_master(%struct.ident_t* nonnull @0, i32 0, i32 0)
  call void @__kmpc_barrier(%struct.ident_t* nonnull @1, float 0.0)
  call void @omp_get_thread_num()
  call void @__kmpc_flush(%struct.ident_t* nonnull @0)
  ret void
}
; Fewer arguments than expected in variadic function.
declare !callback !2 void @__kmpc_fork_call(%struct.ident_t*, void (i32*, i32*, ...)*, ...)

; Fewer number of arguments in non variadic function.
declare void @__kmpc_master(%struct.ident_t*)

; Bigger number of arguments in non variadic function.
declare void @__kmpc_end_master(%struct.ident_t*, i32, i32)

; Different argument type than the expected.
declare void @__kmpc_barrier(%struct.ident_t*, float)

; Proper use of runtime function.
declare void @__kmpc_flush(%struct.ident_t*)

; Different return type.
declare void @omp_get_thread_num()

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang"}
!2 = !{!3}
!3 = !{i64 2, i64 -1, i64 -1, i1 true}
; ===-------------------------------------------------------------------------===
;                         ... Statistics Collected ...
; ===-------------------------------------------------------------------------===
;
; CHECK: 1 cgscc-passmgr - Maximum CGSCCPassMgr iterations on one SCC
; CHECK: 2 openmp-opt{{.*}}Number of OpenMP runtime functions identified
;
; There are two matches since the pass is run once per function.