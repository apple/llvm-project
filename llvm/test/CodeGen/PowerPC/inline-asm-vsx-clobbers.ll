; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr9 -mtriple=powerpc64le-unknown-unknown \
; RUN:   -verify-machineinstrs -ppc-vsr-nums-as-vr \
; RUN:   -ppc-asm-full-reg-names < %s | FileCheck %s

define dso_local void @clobberVR(<4 x i32> %a, <4 x i32> %b) local_unnamed_addr {
; CHECK-LABEL: clobberVR:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    stxv v22, -160(r1) # 16-byte Folded Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    lxv v22, -160(r1) # 16-byte Folded Reload
; CHECK-NEXT:    blr
entry:
  tail call void asm sideeffect "nop", "~{vs54}"()
  ret void
}

define dso_local void @clobberFPR(<4 x i32> %a, <4 x i32> %b) local_unnamed_addr {
; CHECK-LABEL: clobberFPR:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    stfd f14, -144(r1) # 8-byte Folded Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    lfd f14, -144(r1) # 8-byte Folded Reload
; CHECK-NEXT:    blr
entry:
  tail call void asm sideeffect "nop", "~{vs14}"()
  ret void
}
