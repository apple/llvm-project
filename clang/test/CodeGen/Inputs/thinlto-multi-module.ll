target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @f2() {
  ret void
}

!0 = !{i32 1, !"ThinLTO", i32 0}
!llvm.module.flags = !{ !0 }
