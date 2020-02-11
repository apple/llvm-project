; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

; This tests whether or not we generate vectors large than preferred vector width when
; lowering memmove.

; Function Attrs: nounwind uwtable
define weak_odr dso_local void @A(i8* %src, i8* %dst) local_unnamed_addr #0 {
; CHECK-LABEL: A:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovups (%rdi), %xmm0
; CHECK-NEXT:    vmovups 16(%rdi), %xmm1
; CHECK-NEXT:    vmovups %xmm1, 16(%rsi)
; CHECK-NEXT:    vmovups %xmm0, (%rsi)
; CHECK-NEXT:    retq
entry:
  call void @llvm.memmove.p0i8.p0i8.i64(i8* align 1 %dst, i8* align 1 %src, i64 32, i1 false)
  ret void
}

; Function Attrs: nounwind uwtable
define weak_odr dso_local void @B(i8* %src, i8* %dst) local_unnamed_addr #0 {
; CHECK-LABEL: B:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovups (%rdi), %xmm0
; CHECK-NEXT:    vmovups 16(%rdi), %xmm1
; CHECK-NEXT:    vmovups 32(%rdi), %xmm2
; CHECK-NEXT:    vmovups 48(%rdi), %xmm3
; CHECK-NEXT:    vmovups %xmm3, 48(%rsi)
; CHECK-NEXT:    vmovups %xmm2, 32(%rsi)
; CHECK-NEXT:    vmovups %xmm1, 16(%rsi)
; CHECK-NEXT:    vmovups %xmm0, (%rsi)
; CHECK-NEXT:    retq
entry:
  call void @llvm.memmove.p0i8.p0i8.i64(i8* align 1 %dst, i8* align 1 %src, i64 64, i1 false)
  ret void
}

; Function Attrs: nounwind uwtable
define weak_odr dso_local void @C(i8* %src, i8* %dst) local_unnamed_addr #2 {
; CHECK-LABEL: C:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovups (%rdi), %ymm0
; CHECK-NEXT:    vmovups %ymm0, (%rsi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  call void @llvm.memmove.p0i8.p0i8.i64(i8* align 1 %dst, i8* align 1 %src, i64 32, i1 false)
  ret void
}

; Function Attrs: nounwind uwtable
define weak_odr dso_local void @D(i8* %src, i8* %dst) local_unnamed_addr #2 {
; CHECK-LABEL: D:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovups (%rdi), %ymm0
; CHECK-NEXT:    vmovups 32(%rdi), %ymm1
; CHECK-NEXT:    vmovups %ymm1, 32(%rsi)
; CHECK-NEXT:    vmovups %ymm0, (%rsi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  call void @llvm.memmove.p0i8.p0i8.i64(i8* align 1 %dst, i8* align 1 %src, i64 64, i1 false)
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memmove.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i1 immarg) #1

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "frame-pointer"="none" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "prefer-vector-width"="128" "stack-protector-buffer-size"="8" "target-cpu"="skylake-avx512" "target-features"="+adx,+aes,+avx,+avx2,+avx512bw,+avx512cd,+avx512dq,+avx512f,+avx512vl,+bmi,+bmi2,+clflushopt,+clwb,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+pku,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsavec,+xsaveopt,+xsaves" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "frame-pointer"="none" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "prefer-vector-width"="256" "stack-protector-buffer-size"="8" "target-cpu"="skylake-avx512" "target-features"="+adx,+aes,+avx,+avx2,+avx512bw,+avx512cd,+avx512dq,+avx512f,+avx512vl,+bmi,+bmi2,+clflushopt,+clwb,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+pku,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsavec,+xsaveopt,+xsaves" "unsafe-fp-math"="false" "use-soft-float"="false" }

!0 = !{i32 1, !"wchar_size", i32 4}
