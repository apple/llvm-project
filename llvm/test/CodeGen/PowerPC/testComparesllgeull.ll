; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,LE

@glob = local_unnamed_addr global i64 0, align 8

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeull(i64 %a, i64 %b) {
; CHECK-LABEL: test_llgeull:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subfc r3, r4, r3
; CHECK-NEXT:    subfe r3, r4, r4
; CHECK-NEXT:    addi r3, r3, 1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, %b
  %conv1 = zext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeull_sext(i64 %a, i64 %b) {
; CHECK-LABEL: test_llgeull_sext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subfc r3, r4, r3
; CHECK-NEXT:    subfe r3, r4, r4
; CHECK-NEXT:    not r3, r3
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeull_z(i64 %a) {
; CHECK-LABEL: test_llgeull_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li r3, 1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, 0
  %conv1 = zext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeull_sext_z(i64 %a) {
; CHECK-LABEL: test_llgeull_sext_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li r3, -1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, 0
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind
define void @test_llgeull_store(i64 %a, i64 %b) {
; BE-LABEL: test_llgeull_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    subfc r3, r4, r3
; BE-NEXT:    ld r3, .LC0@toc@l(r5)
; BE-NEXT:    subfe r4, r4, r4
; BE-NEXT:    addi r4, r4, 1
; BE-NEXT:    std r4, 0(r3)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeull_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    subfc r3, r4, r3
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    subfe r3, r4, r4
; LE-NEXT:    addi r3, r3, 1
; LE-NEXT:    std r3, glob@toc@l(r5)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, %b
  %conv1 = zext i1 %cmp to i64
  store i64 %conv1, i64* @glob
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_llgeull_sext_store(i64 %a, i64 %b) {
; BE-LABEL: test_llgeull_sext_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    subfc r3, r4, r3
; BE-NEXT:    ld r3, .LC0@toc@l(r5)
; BE-NEXT:    subfe r4, r4, r4
; BE-NEXT:    not r4, r4
; BE-NEXT:    std r4, 0(r3)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeull_sext_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    subfc r3, r4, r3
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    subfe r3, r4, r4
; LE-NEXT:    not r3, r3
; LE-NEXT:    std r3, glob@toc@l(r5)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @glob
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_llgeull_z_store(i64 %a) {
; BE-LABEL: test_llgeull_z_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r3, r2, .LC0@toc@ha
; BE-NEXT:    li r4, 1
; BE-NEXT:    ld r3, .LC0@toc@l(r3)
; BE-NEXT:    std r4, 0(r3)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeull_z_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    addis r3, r2, glob@toc@ha
; LE-NEXT:    li r4, 1
; LE-NEXT:    std r4, glob@toc@l(r3)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, 0
  %conv1 = zext i1 %cmp to i64
  store i64 %conv1, i64* @glob
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_llgeull_sext_z_store(i64 %a) {
; BE-LABEL: test_llgeull_sext_z_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r3, r2, .LC0@toc@ha
; BE-NEXT:    li r4, -1
; BE-NEXT:    ld r3, .LC0@toc@l(r3)
; BE-NEXT:    std r4, 0(r3)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeull_sext_z_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    addis r3, r2, glob@toc@ha
; LE-NEXT:    li r4, -1
; LE-NEXT:    std r4, glob@toc@l(r3)
; LE-NEXT:    blr
entry:
  store i64 -1, i64* @glob
  ret void
}

