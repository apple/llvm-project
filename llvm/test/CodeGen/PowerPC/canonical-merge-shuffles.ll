; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr8 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P8
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P9
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr8 -mattr=-vsx -ppc-asm-full-reg-names \
; RUN:     -ppc-vsr-nums-as-vr < %s | FileCheck %s --check-prefix=CHECK-NOVSX

define dso_local <16 x i8> @testmrghb(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrghb:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrghb v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrghb:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrghb v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrghb:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    vmrghb v2, v3, v2
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrghb2(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrghb2:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrghb v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrghb2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrghb v2, v2, v3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrghb2:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-NOVSX-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-NOVSX-NEXT:    lvx v4, 0, r3
; CHECK-NOVSX-NEXT:    vperm v2, v3, v2, v4
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 24, i32 8, i32 25, i32 9, i32 26, i32 10, i32 27, i32 11, i32 28, i32 12, i32 29, i32 13, i32 30, i32 14, i32 31, i32 15>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrghh(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrghh:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrghh v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrghh:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrghh v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrghh:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    vmrghh v2, v3, v2
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 8, i32 9, i32 24, i32 25, i32 10, i32 11, i32 26, i32 27, i32 12, i32 13, i32 28, i32 29, i32 14, i32 15, i32 30, i32 31>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrghh2(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrghh2:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrghh v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrghh2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrghh v2, v2, v3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrghh2:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    addis r3, r2, .LCPI3_0@toc@ha
; CHECK-NOVSX-NEXT:    addi r3, r3, .LCPI3_0@toc@l
; CHECK-NOVSX-NEXT:    lvx v4, 0, r3
; CHECK-NOVSX-NEXT:    vperm v2, v3, v2, v4
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 24, i32 25, i32 8, i32 9, i32 26, i32 27, i32 10, i32 11, i32 28, i32 29, i32 12, i32 13, i32 30, i32 31, i32 14, i32 15>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrglb(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrglb:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrglb v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrglb:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrglb v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrglb:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    vmrglb v2, v3, v2
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrglb2(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrglb2:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrglb v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrglb2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrglb v2, v2, v3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrglb2:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    addis r3, r2, .LCPI5_0@toc@ha
; CHECK-NOVSX-NEXT:    addi r3, r3, .LCPI5_0@toc@l
; CHECK-NOVSX-NEXT:    lvx v4, 0, r3
; CHECK-NOVSX-NEXT:    vperm v2, v3, v2, v4
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 16, i32 0, i32 17, i32 1, i32 18, i32 2, i32 19, i32 3, i32 20, i32 4, i32 21, i32 5, i32 22, i32 6, i32 23, i32 7>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrglh(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrglh:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrglh v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrglh:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrglh v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrglh:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    vmrglh v2, v3, v2
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 2, i32 3, i32 18, i32 19, i32 4, i32 5, i32 20, i32 21, i32 6, i32 7, i32 22, i32 23>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrglh2(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrglh2:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrglh v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrglh2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrglh v2, v2, v3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrglh2:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    addis r3, r2, .LCPI7_0@toc@ha
; CHECK-NOVSX-NEXT:    addi r3, r3, .LCPI7_0@toc@l
; CHECK-NOVSX-NEXT:    lvx v4, 0, r3
; CHECK-NOVSX-NEXT:    vperm v2, v3, v2, v4
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 16, i32 17, i32 0, i32 1, i32 18, i32 19, i32 2, i32 3, i32 20, i32 21, i32 4, i32 5, i32 22, i32 23, i32 6, i32 7>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrghw(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrghw:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrghw v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrghw:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrghw v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrghw:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    vmrghw v2, v3, v2
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 24, i32 25, i32 26, i32 27, i32 12, i32 13, i32 14, i32 15, i32 28, i32 29, i32 30, i32 31>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrghw2(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrghw2:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrghw v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrghw2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrghw v2, v2, v3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrghw2:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    addis r3, r2, .LCPI9_0@toc@ha
; CHECK-NOVSX-NEXT:    addi r3, r3, .LCPI9_0@toc@l
; CHECK-NOVSX-NEXT:    lvx v4, 0, r3
; CHECK-NOVSX-NEXT:    vperm v2, v3, v2, v4
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 24, i32 25, i32 26, i32 27, i32 8, i32 9, i32 10, i32 11, i32 28, i32 29, i32 30, i32 31, i32 12, i32 13, i32 14, i32 15>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrglw(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrglw:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrglw v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrglw:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrglw v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrglw:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    vmrglw v2, v3, v2
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 4, i32 5, i32 6, i32 7, i32 20, i32 21, i32 22, i32 23>
  ret <16 x i8> %shuffle
}
define dso_local <16 x i8> @testmrglw2(<16 x i8> %a, <16 x i8> %b) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrglw2:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vmrglw v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrglw2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vmrglw v2, v2, v3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrglw2:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    addis r3, r2, .LCPI11_0@toc@ha
; CHECK-NOVSX-NEXT:    addi r3, r3, .LCPI11_0@toc@l
; CHECK-NOVSX-NEXT:    lvx v4, 0, r3
; CHECK-NOVSX-NEXT:    vperm v2, v3, v2, v4
; CHECK-NOVSX-NEXT:    blr
entry:
  %shuffle = shufflevector <16 x i8> %a, <16 x i8> %b, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 0, i32 1, i32 2, i32 3, i32 20, i32 21, i32 22, i32 23, i32 4, i32 5, i32 6, i32 7>
  ret <16 x i8> %shuffle
}

define dso_local <8 x i16> @testmrglb3(<8 x i8>* nocapture readonly %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testmrglb3:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    ld r3, 0(r3)
; CHECK-P8-NEXT:    xxlxor v2, v2, v2
; CHECK-P8-NEXT:    mtvsrd v3, r3
; CHECK-P8-NEXT:    vmrghb v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testmrglb3:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxsd v2, 0(r3)
; CHECK-P9-NEXT:    xxlxor v3, v3, v3
; CHECK-P9-NEXT:    vmrghb v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testmrglb3:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    vxor v2, v2, v2
; CHECK-NOVSX-NEXT:    ld r3, 0(r3)
; CHECK-NOVSX-NEXT:    addis r4, r2, .LCPI12_0@toc@ha
; CHECK-NOVSX-NEXT:    addi r4, r4, .LCPI12_0@toc@l
; CHECK-NOVSX-NEXT:    lvx v3, 0, r4
; CHECK-NOVSX-NEXT:    std r3, -16(r1)
; CHECK-NOVSX-NEXT:    addi r3, r1, -16
; CHECK-NOVSX-NEXT:    lvx v4, 0, r3
; CHECK-NOVSX-NEXT:    vperm v2, v4, v2, v3
; CHECK-NOVSX-NEXT:    blr
entry:
  %0 = load <8 x i8>, <8 x i8>* %a, align 8
  %1 = zext <8 x i8> %0 to <8 x i16>
  ret <8 x i16> %1
}

define dso_local void @no_crash_elt0_from_RHS(<2 x double>* noalias nocapture dereferenceable(16) %.vtx6) #0 {
; CHECK-P8-LABEL: no_crash_elt0_from_RHS:
; CHECK-P8:       # %bb.0: # %test_entry
; CHECK-P8-NEXT:    mflr r0
; CHECK-P8-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    std r0, 16(r1)
; CHECK-P8-NEXT:    stdu r1, -48(r1)
; CHECK-P8-NEXT:    mr r30, r3
; CHECK-P8-NEXT:    bl dummy
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    xxlxor f0, f0, f0
; CHECK-P8-NEXT:    # kill: def $f1 killed $f1 def $vsl1
; CHECK-P8-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    stxvd2x vs0, 0, r30
;
; CHECK-P9-LABEL: no_crash_elt0_from_RHS:
; CHECK-P9:       # %bb.0: # %test_entry
; CHECK-P9-NEXT:    mflr r0
; CHECK-P9-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-P9-NEXT:    std r0, 16(r1)
; CHECK-P9-NEXT:    stdu r1, -48(r1)
; CHECK-P9-NEXT:    mr r30, r3
; CHECK-P9-NEXT:    bl dummy
; CHECK-P9-NEXT:    nop
; CHECK-P9-NEXT:    xxlxor f0, f0, f0
; CHECK-P9-NEXT:    # kill: def $f1 killed $f1 def $vsl1
; CHECK-P9-NEXT:    xxmrghd vs0, vs1, vs0
; CHECK-P9-NEXT:    stxv vs0, 0(r30)
;
; CHECK-NOVSX-LABEL: no_crash_elt0_from_RHS:
; CHECK-NOVSX:       # %bb.0: # %test_entry
; CHECK-NOVSX-NEXT:    mflr r0
; CHECK-NOVSX-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NOVSX-NEXT:    std r0, 16(r1)
; CHECK-NOVSX-NEXT:    stdu r1, -48(r1)
; CHECK-NOVSX-NEXT:    mr r30, r3
; CHECK-NOVSX-NEXT:    bl dummy
; CHECK-NOVSX-NEXT:    nop
; CHECK-NOVSX-NEXT:    li r3, 0
; CHECK-NOVSX-NEXT:    stfd f1, 8(r30)
; CHECK-NOVSX-NEXT:    std r3, 0(r30)
test_entry:
  %_div_result = tail call double @dummy()
  %oldret = insertvalue { double, double } undef, double %_div_result, 0
  %0 = extractvalue { double, double } %oldret, 0
  %.splatinsert = insertelement <2 x double> undef, double %0, i32 0
  %.splat = shufflevector <2 x double> %.splatinsert, <2 x double> undef, <2 x i32> zeroinitializer
  %1 = shufflevector <2 x double> zeroinitializer, <2 x double> %.splat, <2 x i32> <i32 0, i32 3>
  store <2 x double> %1, <2 x double>* %.vtx6, align 16
  unreachable
}

define dso_local <16 x i8> @no_crash_bitcast(i32 %a) {
; CHECK-P8-LABEL: no_crash_bitcast:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mtvsrwz v2, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: no_crash_bitcast:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtvsrws v2, r3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: no_crash_bitcast:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    addis r4, r2, .LCPI14_0@toc@ha
; CHECK-NOVSX-NEXT:    stw r3, -16(r1)
; CHECK-NOVSX-NEXT:    addi r3, r1, -16
; CHECK-NOVSX-NEXT:    addi r4, r4, .LCPI14_0@toc@l
; CHECK-NOVSX-NEXT:    lvx v3, 0, r3
; CHECK-NOVSX-NEXT:    lvx v2, 0, r4
; CHECK-NOVSX-NEXT:    vperm v2, v3, v3, v2
; CHECK-NOVSX-NEXT:    blr
entry:
  %cast = bitcast i32 %a to <4 x i8>
  %ret = shufflevector <4 x i8> %cast, <4 x i8> undef, <16 x i32> <i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
  ret <16 x i8> %ret
}

define dso_local <4 x i32> @replace_undefs_in_splat(<4 x i32> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: replace_undefs_in_splat:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r3, r2, .LCPI15_0@toc@ha
; CHECK-P8-NEXT:    addi r3, r3, .LCPI15_0@toc@l
; CHECK-P8-NEXT:    lvx v3, 0, r3
; CHECK-P8-NEXT:    vmrgow v2, v3, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: replace_undefs_in_splat:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addis r3, r2, .LCPI15_0@toc@ha
; CHECK-P9-NEXT:    addi r3, r3, .LCPI15_0@toc@l
; CHECK-P9-NEXT:    lxvx v3, 0, r3
; CHECK-P9-NEXT:    vmrgow v2, v3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: replace_undefs_in_splat:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    addis r3, r2, .LCPI15_0@toc@ha
; CHECK-NOVSX-NEXT:    addis r4, r2, .LCPI15_1@toc@ha
; CHECK-NOVSX-NEXT:    addi r3, r3, .LCPI15_0@toc@l
; CHECK-NOVSX-NEXT:    lvx v3, 0, r3
; CHECK-NOVSX-NEXT:    addi r3, r4, .LCPI15_1@toc@l
; CHECK-NOVSX-NEXT:    lvx v4, 0, r3
; CHECK-NOVSX-NEXT:    vperm v2, v4, v2, v3
; CHECK-NOVSX-NEXT:    blr
entry:
  %vecins1 = shufflevector <4 x i32> %a, <4 x i32> <i32 undef, i32 566, i32 undef, i32 566>, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  ret <4 x i32> %vecins1
}

define dso_local <16 x i8> @no_RAUW_in_combine_during_legalize(i32* nocapture readonly %ptr, i32 signext %offset) local_unnamed_addr #0 {
; CHECK-P8-LABEL: no_RAUW_in_combine_during_legalize:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r5, r2, .LCPI16_0@toc@ha
; CHECK-P8-NEXT:    sldi r4, r4, 2
; CHECK-P8-NEXT:    xxlxor v4, v4, v4
; CHECK-P8-NEXT:    addi r5, r5, .LCPI16_0@toc@l
; CHECK-P8-NEXT:    lxsiwzx v2, r3, r4
; CHECK-P8-NEXT:    lvx v3, 0, r5
; CHECK-P8-NEXT:    vperm v2, v4, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: no_RAUW_in_combine_during_legalize:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    sldi r4, r4, 2
; CHECK-P9-NEXT:    lxsiwzx v2, r3, r4
; CHECK-P9-NEXT:    addis r3, r2, .LCPI16_0@toc@ha
; CHECK-P9-NEXT:    addi r3, r3, .LCPI16_0@toc@l
; CHECK-P9-NEXT:    lxvx v3, 0, r3
; CHECK-P9-NEXT:    xxlxor v4, v4, v4
; CHECK-P9-NEXT:    vperm v2, v4, v2, v3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: no_RAUW_in_combine_during_legalize:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    sldi r4, r4, 2
; CHECK-NOVSX-NEXT:    vxor v2, v2, v2
; CHECK-NOVSX-NEXT:    lwzx r3, r3, r4
; CHECK-NOVSX-NEXT:    std r3, -16(r1)
; CHECK-NOVSX-NEXT:    addi r3, r1, -16
; CHECK-NOVSX-NEXT:    lvx v3, 0, r3
; CHECK-NOVSX-NEXT:    vmrglb v2, v2, v3
; CHECK-NOVSX-NEXT:    blr
entry:
  %idx.ext = sext i32 %offset to i64
  %add.ptr = getelementptr inbounds i32, i32* %ptr, i64 %idx.ext
  %0 = load i32, i32* %add.ptr, align 4
  %conv = zext i32 %0 to i64
  %splat.splatinsert = insertelement <2 x i64> undef, i64 %conv, i32 0
  %1 = bitcast <2 x i64> %splat.splatinsert to <16 x i8>
  %shuffle = shufflevector <16 x i8> %1, <16 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>, <16 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23>
  ret <16 x i8> %shuffle
}

define dso_local <4 x i32> @testSplat4Low(<8 x i8>* nocapture readonly %ptr) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testSplat4Low:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    ld r3, 0(r3)
; CHECK-P8-NEXT:    mtfprd f0, r3
; CHECK-P8-NEXT:    xxspltw v2, vs0, 0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testSplat4Low:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addi r3, r3, 4
; CHECK-P9-NEXT:    lxvwsx v2, 0, r3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testSplat4Low:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    ld r3, 0(r3)
; CHECK-NOVSX-NEXT:    addi r4, r1, -16
; CHECK-NOVSX-NEXT:    std r3, -16(r1)
; CHECK-NOVSX-NEXT:    lvx v2, 0, r4
; CHECK-NOVSX-NEXT:    vspltw v2, v2, 2
; CHECK-NOVSX-NEXT:    blr
entry:
  %0 = load <8 x i8>, <8 x i8>* %ptr, align 8
  %vecinit18 = shufflevector <8 x i8> %0, <8 x i8> undef, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %1 = bitcast <16 x i8> %vecinit18 to <4 x i32>
  ret <4 x i32> %1
}

; Function Attrs: norecurse nounwind readonly
define dso_local <4 x i32> @testSplat4hi(<8 x i8>* nocapture readonly %ptr) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testSplat4hi:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    ld r3, 0(r3)
; CHECK-P8-NEXT:    mtfprd f0, r3
; CHECK-P8-NEXT:    xxspltw v2, vs0, 1
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testSplat4hi:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxvwsx v2, 0, r3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testSplat4hi:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    ld r3, 0(r3)
; CHECK-NOVSX-NEXT:    addi r4, r1, -16
; CHECK-NOVSX-NEXT:    std r3, -16(r1)
; CHECK-NOVSX-NEXT:    lvx v2, 0, r4
; CHECK-NOVSX-NEXT:    vspltw v2, v2, 3
; CHECK-NOVSX-NEXT:    blr
entry:
  %0 = load <8 x i8>, <8 x i8>* %ptr, align 8
  %vecinit22 = shufflevector <8 x i8> %0, <8 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %1 = bitcast <16 x i8> %vecinit22 to <4 x i32>
  ret <4 x i32> %1
}

; Function Attrs: norecurse nounwind readonly
define dso_local <2 x i64> @testSplat8(<8 x i8>* nocapture readonly %ptr) local_unnamed_addr #0 {
; CHECK-P8-LABEL: testSplat8:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    lxvdsx v2, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: testSplat8:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxvdsx v2, 0, r3
; CHECK-P9-NEXT:    blr
;
; CHECK-NOVSX-LABEL: testSplat8:
; CHECK-NOVSX:       # %bb.0: # %entry
; CHECK-NOVSX-NEXT:    ld r3, 0(r3)
; CHECK-NOVSX-NEXT:    addis r4, r2, .LCPI19_0@toc@ha
; CHECK-NOVSX-NEXT:    addi r4, r4, .LCPI19_0@toc@l
; CHECK-NOVSX-NEXT:    lvx v2, 0, r4
; CHECK-NOVSX-NEXT:    std r3, -16(r1)
; CHECK-NOVSX-NEXT:    addi r3, r1, -16
; CHECK-NOVSX-NEXT:    lvx v3, 0, r3
; CHECK-NOVSX-NEXT:    vperm v2, v3, v3, v2
; CHECK-NOVSX-NEXT:    blr
entry:
  %0 = load <8 x i8>, <8 x i8>* %ptr, align 8
  %vecinit30 = shufflevector <8 x i8> %0, <8 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %1 = bitcast <16 x i8> %vecinit30 to <2 x i64>
  ret <2 x i64> %1
}

declare double @dummy() local_unnamed_addr
attributes #0 = { nounwind }
