; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s

@vi8 = common dso_local local_unnamed_addr global i8 0, align 1
@vi16 = common dso_local local_unnamed_addr global i16 0, align 2
@vi32 = common dso_local local_unnamed_addr global i32 0, align 4
@vi64 = common dso_local local_unnamed_addr global i64 0, align 8
@vf32 = common dso_local local_unnamed_addr global float 0.000000e+00, align 4
@vf64 = common dso_local local_unnamed_addr global double 0.000000e+00, align 8

; Function Attrs: norecurse nounwind readonly
define void @storef64com(double %0) {
; CHECK-LABEL: storef64com:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, vf64@lo
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    lea.sl %s1, vf64@hi(, %s1)
; CHECK-NEXT:    st %s0, (, %s1)
; CHECK-NEXT:    or %s11, 0, %s9
  store double %0, double* @vf64, align 8
  ret void
}

; Function Attrs: norecurse nounwind readonly
define void @storef32com(float %0) {
; CHECK-LABEL: storef32com:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, vf32@lo
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    lea.sl %s1, vf32@hi(, %s1)
; CHECK-NEXT:    stu %s0, (, %s1)
; CHECK-NEXT:    or %s11, 0, %s9
  store float %0, float* @vf32, align 4
  ret void
}

; Function Attrs: norecurse nounwind readonly
define void @storei64com(i64 %0) {
; CHECK-LABEL: storei64com:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, vi64@lo
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    lea.sl %s1, vi64@hi(, %s1)
; CHECK-NEXT:    st %s0, (, %s1)
; CHECK-NEXT:    or %s11, 0, %s9
  store i64 %0, i64* @vi64, align 8
  ret void
}

; Function Attrs: norecurse nounwind readonly
define void @storei32com(i32 %0) {
; CHECK-LABEL: storei32com:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, vi32@lo
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    lea.sl %s1, vi32@hi(, %s1)
; CHECK-NEXT:    stl %s0, (, %s1)
; CHECK-NEXT:    or %s11, 0, %s9
  store i32 %0, i32* @vi32, align 4
  ret void
}

; Function Attrs: norecurse nounwind readonly
define void @storei16com(i16 %0) {
; CHECK-LABEL: storei16com:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, vi16@lo
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    lea.sl %s1, vi16@hi(, %s1)
; CHECK-NEXT:    st2b %s0, (, %s1)
; CHECK-NEXT:    or %s11, 0, %s9
  store i16 %0, i16* @vi16, align 2
  ret void
}

; Function Attrs: norecurse nounwind readonly
define void @storei8com(i8 %0) {
; CHECK-LABEL: storei8com:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, vi8@lo
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    lea.sl %s1, vi8@hi(, %s1)
; CHECK-NEXT:    st1b %s0, (, %s1)
; CHECK-NEXT:    or %s11, 0, %s9
  store i8 %0, i8* @vi8, align 1
  ret void
}

