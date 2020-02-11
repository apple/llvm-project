; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel -mcpu=mips32r5 -mattr=+msa,+fp64,+nan2008 -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=P5600

declare <4 x float> @llvm.mips.fadd.w(<4 x float>, <4 x float>)
define void @fadd_v4f32_builtin(<4 x float>* %a, <4 x float>* %b, <4 x float>* %c) {
; P5600-LABEL: fadd_v4f32_builtin:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.w $w0, 0($4)
; P5600-NEXT:    ld.w $w1, 0($5)
; P5600-NEXT:    fadd.w $w0, $w0, $w1
; P5600-NEXT:    st.w $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %1 = load <4 x float>, <4 x float>* %b, align 16
  %2 = tail call <4 x float> @llvm.mips.fadd.w(<4 x float> %0, <4 x float> %1)
  store <4 x float> %2, <4 x float>* %c, align 16
  ret void
}

declare <2 x double> @llvm.mips.fadd.d(<2 x double>, <2 x double>)
define void @fadd_v2f64_builtin(<2 x double>* %a, <2 x double>* %b, <2 x double>* %c) {
; P5600-LABEL: fadd_v2f64_builtin:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.d $w0, 0($4)
; P5600-NEXT:    ld.d $w1, 0($5)
; P5600-NEXT:    fadd.d $w0, $w0, $w1
; P5600-NEXT:    st.d $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <2 x double>, <2 x double>* %a, align 16
  %1 = load <2 x double>, <2 x double>* %b, align 16
  %2 = tail call <2 x double> @llvm.mips.fadd.d(<2 x double> %0, <2 x double> %1)
  store <2 x double> %2, <2 x double>* %c, align 16
  ret void
}

declare <4 x float> @llvm.mips.fsub.w(<4 x float>, <4 x float>)
define void @fsub_v4f32_builtin(<4 x float>* %a, <4 x float>* %b, <4 x float>* %c) {
; P5600-LABEL: fsub_v4f32_builtin:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.w $w0, 0($4)
; P5600-NEXT:    ld.w $w1, 0($5)
; P5600-NEXT:    fsub.w $w0, $w0, $w1
; P5600-NEXT:    st.w $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %1 = load <4 x float>, <4 x float>* %b, align 16
  %2 = tail call <4 x float> @llvm.mips.fsub.w(<4 x float> %0, <4 x float> %1)
  store <4 x float> %2, <4 x float>* %c, align 16
  ret void
}

declare <2 x double> @llvm.mips.fsub.d(<2 x double>, <2 x double>)
define void @fsub_v2f64_builtin(<2 x double>* %a, <2 x double>* %b, <2 x double>* %c) {
; P5600-LABEL: fsub_v2f64_builtin:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.d $w0, 0($4)
; P5600-NEXT:    ld.d $w1, 0($5)
; P5600-NEXT:    fsub.d $w0, $w0, $w1
; P5600-NEXT:    st.d $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <2 x double>, <2 x double>* %a, align 16
  %1 = load <2 x double>, <2 x double>* %b, align 16
  %2 = tail call <2 x double> @llvm.mips.fsub.d(<2 x double> %0, <2 x double> %1)
  store <2 x double> %2, <2 x double>* %c, align 16
  ret void
}

declare <4 x float> @llvm.mips.fmul.w(<4 x float>, <4 x float>)
define void @fmul_v4f32_builtin(<4 x float>* %a, <4 x float>* %b, <4 x float>* %c) {
; P5600-LABEL: fmul_v4f32_builtin:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.w $w0, 0($4)
; P5600-NEXT:    ld.w $w1, 0($5)
; P5600-NEXT:    fmul.w $w0, $w0, $w1
; P5600-NEXT:    st.w $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %1 = load <4 x float>, <4 x float>* %b, align 16
  %2 = tail call <4 x float> @llvm.mips.fmul.w(<4 x float> %0, <4 x float> %1)
  store <4 x float> %2, <4 x float>* %c, align 16
  ret void
}

declare <2 x double> @llvm.mips.fmul.d(<2 x double>, <2 x double>)
define void @fmul_v2f64_builtin(<2 x double>* %a, <2 x double>* %b, <2 x double>* %c) {
; P5600-LABEL: fmul_v2f64_builtin:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.d $w0, 0($4)
; P5600-NEXT:    ld.d $w1, 0($5)
; P5600-NEXT:    fmul.d $w0, $w0, $w1
; P5600-NEXT:    st.d $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <2 x double>, <2 x double>* %a, align 16
  %1 = load <2 x double>, <2 x double>* %b, align 16
  %2 = tail call <2 x double> @llvm.mips.fmul.d(<2 x double> %0, <2 x double> %1)
  store <2 x double> %2, <2 x double>* %c, align 16
  ret void
}

declare <4 x float> @llvm.mips.fdiv.w(<4 x float>, <4 x float>)
define void @fdiv_v4f32_builtin(<4 x float>* %a, <4 x float>* %b, <4 x float>* %c) {
; P5600-LABEL: fdiv_v4f32_builtin:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.w $w0, 0($4)
; P5600-NEXT:    ld.w $w1, 0($5)
; P5600-NEXT:    fdiv.w $w0, $w0, $w1
; P5600-NEXT:    st.w $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %1 = load <4 x float>, <4 x float>* %b, align 16
  %2 = tail call <4 x float> @llvm.mips.fdiv.w(<4 x float> %0, <4 x float> %1)
  store <4 x float> %2, <4 x float>* %c, align 16
  ret void
}

declare <2 x double> @llvm.mips.fdiv.d(<2 x double>, <2 x double>)
define void @fdiv_v2f64_builtin(<2 x double>* %a, <2 x double>* %b, <2 x double>* %c) {
; P5600-LABEL: fdiv_v2f64_builtin:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.d $w0, 0($4)
; P5600-NEXT:    ld.d $w1, 0($5)
; P5600-NEXT:    fdiv.d $w0, $w0, $w1
; P5600-NEXT:    st.d $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <2 x double>, <2 x double>* %a, align 16
  %1 = load <2 x double>, <2 x double>* %b, align 16
  %2 = tail call <2 x double> @llvm.mips.fdiv.d(<2 x double> %0, <2 x double> %1)
  store <2 x double> %2, <2 x double>* %c, align 16
  ret void
}
