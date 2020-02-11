; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IM

; The patterns for the 'W' suffixed RV64M instructions have the potential of
; missing cases. This file checks all the variants of
; sign-extended/zero-extended/any-extended inputs and outputs.

define i32 @aext_mulw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_mulw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define i32 @aext_mulw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_mulw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define i32 @aext_mulw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_mulw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define i32 @aext_mulw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_mulw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define i32 @aext_mulw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_mulw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define i32 @aext_mulw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_mulw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define i32 @aext_mulw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_mulw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define i32 @aext_mulw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_mulw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define i32 @aext_mulw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_mulw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_mulw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_mulw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_mulw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_mulw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_mulw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_mulw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_mulw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_mulw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_mulw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_mulw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_mulw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_mulw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_mulw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_mulw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_mulw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_mulw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_mulw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_mulw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_mulw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_mulw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_mulw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_mulw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_mulw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_mulw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_mulw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_mulw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_mulw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_mulw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_mulw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_mulw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_mulw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_mulw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_mulw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_mulw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_mulw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_mulw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define i32 @aext_divuw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_divuw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divuw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_divuw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divuw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_divuw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divuw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_divuw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divuw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_divuw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divuw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_divuw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divuw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_divuw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divuw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_divuw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divuw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_divuw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divuw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_divuw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divuw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_divuw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divuw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_divuw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divuw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_divuw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divuw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_divuw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divuw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_divuw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divuw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_divuw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divuw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_divuw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divuw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_divuw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divuw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_divuw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divuw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_divuw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divuw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_divuw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divuw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_divuw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divuw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_divuw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divuw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_divuw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divuw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_divuw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divuw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_divuw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divuw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_divuw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divu a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_divw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_divw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_divw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_divw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_divw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_divw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_divw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_divw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_divw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_divw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_divw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_divw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_divw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_divw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_divw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_divw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_divw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_divw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_divw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_divw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_divw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_divw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_divw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_divw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_divw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_divw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_divw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_divw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_divw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_divw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    divw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @aext_remw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_remw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_remw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_remw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_remw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_remw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_remw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_remw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_remw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_remw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_remw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_remw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_remw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_remw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_remw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_remw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_remw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_remw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_remw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_remw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_remw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_remw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_remw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_remw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_remw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_remw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_remw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_remw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = srem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remuw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_remuw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remuw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_remuw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remuw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_remuw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remuw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_remuw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remuw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_remuw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remuw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_remuw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remuw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: aext_remuw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remuw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: aext_remuw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define i32 @aext_remuw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: aext_remuw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remuw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_remuw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remuw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_remuw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remuw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_remuw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remuw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_remuw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remuw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_remuw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remuw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_remuw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remuw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: sext_remuw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remuw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: sext_remuw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define signext i32 @sext_remuw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: sext_remuw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remuw_aext_aext(i32 %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_remuw_aext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remuw_aext_sext(i32 %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_remuw_aext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remuw_aext_zext(i32 %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_remuw_aext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remuw_sext_aext(i32 signext %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_remuw_sext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remuw_sext_sext(i32 signext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_remuw_sext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remuw_sext_zext(i32 signext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_remuw_sext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remuw_zext_aext(i32 zeroext %a, i32 %b) nounwind {
; RV64IM-LABEL: zext_remuw_zext_aext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remuw_zext_sext(i32 zeroext %a, i32 signext %b) nounwind {
; RV64IM-LABEL: zext_remuw_zext_sext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remuw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}

define zeroext i32 @zext_remuw_zext_zext(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV64IM-LABEL: zext_remuw_zext_zext:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    remu a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %a, %b
  ret i32 %1
}
