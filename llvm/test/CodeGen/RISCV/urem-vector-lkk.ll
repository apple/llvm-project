; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV32I %s
; RUN: llc -mtriple=riscv32 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV32IM %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV64I %s
; RUN: llc -mtriple=riscv64 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV64IM %s


define <4 x i16> @fold_urem_vec_1(<4 x i16> %x) nounwind {
; RV32I-LABEL: fold_urem_vec_1:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp)
; RV32I-NEXT:    sw s0, 24(sp)
; RV32I-NEXT:    sw s1, 20(sp)
; RV32I-NEXT:    sw s2, 16(sp)
; RV32I-NEXT:    sw s3, 12(sp)
; RV32I-NEXT:    sw s4, 8(sp)
; RV32I-NEXT:    sw s5, 4(sp)
; RV32I-NEXT:    lhu s2, 12(a1)
; RV32I-NEXT:    lhu s3, 8(a1)
; RV32I-NEXT:    lhu s0, 4(a1)
; RV32I-NEXT:    lhu a2, 0(a1)
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s4, a0
; RV32I-NEXT:    addi a1, zero, 124
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s5, a0
; RV32I-NEXT:    addi a1, zero, 98
; RV32I-NEXT:    mv a0, s3
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    addi a1, zero, 1003
; RV32I-NEXT:    mv a0, s2
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    sh a0, 6(s1)
; RV32I-NEXT:    sh s0, 4(s1)
; RV32I-NEXT:    sh s5, 2(s1)
; RV32I-NEXT:    sh s4, 0(s1)
; RV32I-NEXT:    lw s5, 4(sp)
; RV32I-NEXT:    lw s4, 8(sp)
; RV32I-NEXT:    lw s3, 12(sp)
; RV32I-NEXT:    lw s2, 16(sp)
; RV32I-NEXT:    lw s1, 20(sp)
; RV32I-NEXT:    lw s0, 24(sp)
; RV32I-NEXT:    lw ra, 28(sp)
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: fold_urem_vec_1:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lhu a6, 12(a1)
; RV32IM-NEXT:    lhu a3, 8(a1)
; RV32IM-NEXT:    lhu a4, 0(a1)
; RV32IM-NEXT:    lhu a1, 4(a1)
; RV32IM-NEXT:    lui a5, 364242
; RV32IM-NEXT:    addi a5, a5, 777
; RV32IM-NEXT:    mulhu a5, a4, a5
; RV32IM-NEXT:    sub a2, a4, a5
; RV32IM-NEXT:    srli a2, a2, 1
; RV32IM-NEXT:    add a2, a2, a5
; RV32IM-NEXT:    srli a2, a2, 6
; RV32IM-NEXT:    addi a5, zero, 95
; RV32IM-NEXT:    mul a2, a2, a5
; RV32IM-NEXT:    sub a2, a4, a2
; RV32IM-NEXT:    srli a4, a1, 2
; RV32IM-NEXT:    lui a5, 135300
; RV32IM-NEXT:    addi a5, a5, 529
; RV32IM-NEXT:    mulhu a4, a4, a5
; RV32IM-NEXT:    srli a4, a4, 2
; RV32IM-NEXT:    addi a5, zero, 124
; RV32IM-NEXT:    mul a4, a4, a5
; RV32IM-NEXT:    sub a1, a1, a4
; RV32IM-NEXT:    lui a4, 342392
; RV32IM-NEXT:    addi a4, a4, 669
; RV32IM-NEXT:    mulhu a4, a3, a4
; RV32IM-NEXT:    srli a4, a4, 5
; RV32IM-NEXT:    addi a5, zero, 98
; RV32IM-NEXT:    mul a4, a4, a5
; RV32IM-NEXT:    sub a3, a3, a4
; RV32IM-NEXT:    lui a4, 267633
; RV32IM-NEXT:    addi a4, a4, -1809
; RV32IM-NEXT:    mulhu a4, a6, a4
; RV32IM-NEXT:    srli a4, a4, 8
; RV32IM-NEXT:    addi a5, zero, 1003
; RV32IM-NEXT:    mul a4, a4, a5
; RV32IM-NEXT:    sub a4, a6, a4
; RV32IM-NEXT:    sh a4, 6(a0)
; RV32IM-NEXT:    sh a3, 4(a0)
; RV32IM-NEXT:    sh a1, 2(a0)
; RV32IM-NEXT:    sh a2, 0(a0)
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: fold_urem_vec_1:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -64
; RV64I-NEXT:    sd ra, 56(sp)
; RV64I-NEXT:    sd s0, 48(sp)
; RV64I-NEXT:    sd s1, 40(sp)
; RV64I-NEXT:    sd s2, 32(sp)
; RV64I-NEXT:    sd s3, 24(sp)
; RV64I-NEXT:    sd s4, 16(sp)
; RV64I-NEXT:    sd s5, 8(sp)
; RV64I-NEXT:    lhu s2, 24(a1)
; RV64I-NEXT:    lhu s3, 16(a1)
; RV64I-NEXT:    lhu s0, 8(a1)
; RV64I-NEXT:    lhu a2, 0(a1)
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s4, a0
; RV64I-NEXT:    addi a1, zero, 124
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s5, a0
; RV64I-NEXT:    addi a1, zero, 98
; RV64I-NEXT:    mv a0, s3
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    addi a1, zero, 1003
; RV64I-NEXT:    mv a0, s2
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    sh a0, 6(s1)
; RV64I-NEXT:    sh s0, 4(s1)
; RV64I-NEXT:    sh s5, 2(s1)
; RV64I-NEXT:    sh s4, 0(s1)
; RV64I-NEXT:    ld s5, 8(sp)
; RV64I-NEXT:    ld s4, 16(sp)
; RV64I-NEXT:    ld s3, 24(sp)
; RV64I-NEXT:    ld s2, 32(sp)
; RV64I-NEXT:    ld s1, 40(sp)
; RV64I-NEXT:    ld s0, 48(sp)
; RV64I-NEXT:    ld ra, 56(sp)
; RV64I-NEXT:    addi sp, sp, 64
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: fold_urem_vec_1:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lhu a6, 24(a1)
; RV64IM-NEXT:    lhu a3, 16(a1)
; RV64IM-NEXT:    lhu a4, 8(a1)
; RV64IM-NEXT:    lhu a1, 0(a1)
; RV64IM-NEXT:    lui a5, 1423
; RV64IM-NEXT:    addiw a5, a5, -733
; RV64IM-NEXT:    slli a5, a5, 15
; RV64IM-NEXT:    addi a5, a5, 1035
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, -1811
; RV64IM-NEXT:    slli a5, a5, 12
; RV64IM-NEXT:    addi a5, a5, 561
; RV64IM-NEXT:    mulhu a5, a1, a5
; RV64IM-NEXT:    sub a2, a1, a5
; RV64IM-NEXT:    srli a2, a2, 1
; RV64IM-NEXT:    add a2, a2, a5
; RV64IM-NEXT:    srli a2, a2, 6
; RV64IM-NEXT:    addi a5, zero, 95
; RV64IM-NEXT:    mul a2, a2, a5
; RV64IM-NEXT:    sub a1, a1, a2
; RV64IM-NEXT:    srli a2, a4, 2
; RV64IM-NEXT:    lui a5, 264
; RV64IM-NEXT:    addiw a5, a5, 1057
; RV64IM-NEXT:    slli a5, a5, 15
; RV64IM-NEXT:    addi a5, a5, 1057
; RV64IM-NEXT:    slli a5, a5, 15
; RV64IM-NEXT:    addi a5, a5, 1057
; RV64IM-NEXT:    slli a5, a5, 12
; RV64IM-NEXT:    addi a5, a5, 133
; RV64IM-NEXT:    mulhu a2, a2, a5
; RV64IM-NEXT:    srli a2, a2, 3
; RV64IM-NEXT:    addi a5, zero, 124
; RV64IM-NEXT:    mul a2, a2, a5
; RV64IM-NEXT:    sub a2, a4, a2
; RV64IM-NEXT:    srli a4, a3, 1
; RV64IM-NEXT:    lui a5, 2675
; RV64IM-NEXT:    addiw a5, a5, -251
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, 1839
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, 167
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, 1505
; RV64IM-NEXT:    mulhu a4, a4, a5
; RV64IM-NEXT:    srli a4, a4, 4
; RV64IM-NEXT:    addi a5, zero, 98
; RV64IM-NEXT:    mul a4, a4, a5
; RV64IM-NEXT:    sub a3, a3, a4
; RV64IM-NEXT:    lui a4, 8364
; RV64IM-NEXT:    addiw a4, a4, -1977
; RV64IM-NEXT:    slli a4, a4, 12
; RV64IM-NEXT:    addi a4, a4, 1907
; RV64IM-NEXT:    slli a4, a4, 12
; RV64IM-NEXT:    addi a4, a4, 453
; RV64IM-NEXT:    slli a4, a4, 12
; RV64IM-NEXT:    addi a4, a4, 1213
; RV64IM-NEXT:    mulhu a4, a6, a4
; RV64IM-NEXT:    srli a4, a4, 7
; RV64IM-NEXT:    addi a5, zero, 1003
; RV64IM-NEXT:    mul a4, a4, a5
; RV64IM-NEXT:    sub a4, a6, a4
; RV64IM-NEXT:    sh a4, 6(a0)
; RV64IM-NEXT:    sh a3, 4(a0)
; RV64IM-NEXT:    sh a2, 2(a0)
; RV64IM-NEXT:    sh a1, 0(a0)
; RV64IM-NEXT:    ret
  %1 = urem <4 x i16> %x, <i16 95, i16 124, i16 98, i16 1003>
  ret <4 x i16> %1
}

define <4 x i16> @fold_urem_vec_2(<4 x i16> %x) nounwind {
; RV32I-LABEL: fold_urem_vec_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp)
; RV32I-NEXT:    sw s0, 24(sp)
; RV32I-NEXT:    sw s1, 20(sp)
; RV32I-NEXT:    sw s2, 16(sp)
; RV32I-NEXT:    sw s3, 12(sp)
; RV32I-NEXT:    sw s4, 8(sp)
; RV32I-NEXT:    sw s5, 4(sp)
; RV32I-NEXT:    lhu s2, 12(a1)
; RV32I-NEXT:    lhu s3, 8(a1)
; RV32I-NEXT:    lhu s0, 4(a1)
; RV32I-NEXT:    lhu a2, 0(a1)
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s4, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s5, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s3
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s2
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    sh a0, 6(s1)
; RV32I-NEXT:    sh s0, 4(s1)
; RV32I-NEXT:    sh s5, 2(s1)
; RV32I-NEXT:    sh s4, 0(s1)
; RV32I-NEXT:    lw s5, 4(sp)
; RV32I-NEXT:    lw s4, 8(sp)
; RV32I-NEXT:    lw s3, 12(sp)
; RV32I-NEXT:    lw s2, 16(sp)
; RV32I-NEXT:    lw s1, 20(sp)
; RV32I-NEXT:    lw s0, 24(sp)
; RV32I-NEXT:    lw ra, 28(sp)
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: fold_urem_vec_2:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lhu a6, 12(a1)
; RV32IM-NEXT:    lhu a7, 8(a1)
; RV32IM-NEXT:    lhu a4, 0(a1)
; RV32IM-NEXT:    lhu a1, 4(a1)
; RV32IM-NEXT:    lui a5, 364242
; RV32IM-NEXT:    addi a5, a5, 777
; RV32IM-NEXT:    mulhu a2, a4, a5
; RV32IM-NEXT:    sub a3, a4, a2
; RV32IM-NEXT:    srli a3, a3, 1
; RV32IM-NEXT:    add a2, a3, a2
; RV32IM-NEXT:    srli a2, a2, 6
; RV32IM-NEXT:    addi a3, zero, 95
; RV32IM-NEXT:    mul a2, a2, a3
; RV32IM-NEXT:    sub t0, a4, a2
; RV32IM-NEXT:    mulhu a4, a1, a5
; RV32IM-NEXT:    sub a2, a1, a4
; RV32IM-NEXT:    srli a2, a2, 1
; RV32IM-NEXT:    add a2, a2, a4
; RV32IM-NEXT:    srli a2, a2, 6
; RV32IM-NEXT:    mul a2, a2, a3
; RV32IM-NEXT:    sub a1, a1, a2
; RV32IM-NEXT:    mulhu a2, a7, a5
; RV32IM-NEXT:    sub a4, a7, a2
; RV32IM-NEXT:    srli a4, a4, 1
; RV32IM-NEXT:    add a2, a4, a2
; RV32IM-NEXT:    srli a2, a2, 6
; RV32IM-NEXT:    mul a2, a2, a3
; RV32IM-NEXT:    sub a2, a7, a2
; RV32IM-NEXT:    mulhu a4, a6, a5
; RV32IM-NEXT:    sub a5, a6, a4
; RV32IM-NEXT:    srli a5, a5, 1
; RV32IM-NEXT:    add a4, a5, a4
; RV32IM-NEXT:    srli a4, a4, 6
; RV32IM-NEXT:    mul a3, a4, a3
; RV32IM-NEXT:    sub a3, a6, a3
; RV32IM-NEXT:    sh a3, 6(a0)
; RV32IM-NEXT:    sh a2, 4(a0)
; RV32IM-NEXT:    sh a1, 2(a0)
; RV32IM-NEXT:    sh t0, 0(a0)
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: fold_urem_vec_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -64
; RV64I-NEXT:    sd ra, 56(sp)
; RV64I-NEXT:    sd s0, 48(sp)
; RV64I-NEXT:    sd s1, 40(sp)
; RV64I-NEXT:    sd s2, 32(sp)
; RV64I-NEXT:    sd s3, 24(sp)
; RV64I-NEXT:    sd s4, 16(sp)
; RV64I-NEXT:    sd s5, 8(sp)
; RV64I-NEXT:    lhu s2, 24(a1)
; RV64I-NEXT:    lhu s3, 16(a1)
; RV64I-NEXT:    lhu s0, 8(a1)
; RV64I-NEXT:    lhu a2, 0(a1)
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s4, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s5, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s3
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s2
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    sh a0, 6(s1)
; RV64I-NEXT:    sh s0, 4(s1)
; RV64I-NEXT:    sh s5, 2(s1)
; RV64I-NEXT:    sh s4, 0(s1)
; RV64I-NEXT:    ld s5, 8(sp)
; RV64I-NEXT:    ld s4, 16(sp)
; RV64I-NEXT:    ld s3, 24(sp)
; RV64I-NEXT:    ld s2, 32(sp)
; RV64I-NEXT:    ld s1, 40(sp)
; RV64I-NEXT:    ld s0, 48(sp)
; RV64I-NEXT:    ld ra, 56(sp)
; RV64I-NEXT:    addi sp, sp, 64
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: fold_urem_vec_2:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lhu a6, 24(a1)
; RV64IM-NEXT:    lhu a7, 16(a1)
; RV64IM-NEXT:    lhu a4, 8(a1)
; RV64IM-NEXT:    lhu a1, 0(a1)
; RV64IM-NEXT:    lui a5, 1423
; RV64IM-NEXT:    addiw a5, a5, -733
; RV64IM-NEXT:    slli a5, a5, 15
; RV64IM-NEXT:    addi a5, a5, 1035
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, -1811
; RV64IM-NEXT:    slli a5, a5, 12
; RV64IM-NEXT:    addi a5, a5, 561
; RV64IM-NEXT:    mulhu a2, a1, a5
; RV64IM-NEXT:    sub a3, a1, a2
; RV64IM-NEXT:    srli a3, a3, 1
; RV64IM-NEXT:    add a2, a3, a2
; RV64IM-NEXT:    srli a2, a2, 6
; RV64IM-NEXT:    addi a3, zero, 95
; RV64IM-NEXT:    mul a2, a2, a3
; RV64IM-NEXT:    sub t0, a1, a2
; RV64IM-NEXT:    mulhu a2, a4, a5
; RV64IM-NEXT:    sub a1, a4, a2
; RV64IM-NEXT:    srli a1, a1, 1
; RV64IM-NEXT:    add a1, a1, a2
; RV64IM-NEXT:    srli a1, a1, 6
; RV64IM-NEXT:    mul a1, a1, a3
; RV64IM-NEXT:    sub a1, a4, a1
; RV64IM-NEXT:    mulhu a2, a7, a5
; RV64IM-NEXT:    sub a4, a7, a2
; RV64IM-NEXT:    srli a4, a4, 1
; RV64IM-NEXT:    add a2, a4, a2
; RV64IM-NEXT:    srli a2, a2, 6
; RV64IM-NEXT:    mul a2, a2, a3
; RV64IM-NEXT:    sub a2, a7, a2
; RV64IM-NEXT:    mulhu a4, a6, a5
; RV64IM-NEXT:    sub a5, a6, a4
; RV64IM-NEXT:    srli a5, a5, 1
; RV64IM-NEXT:    add a4, a5, a4
; RV64IM-NEXT:    srli a4, a4, 6
; RV64IM-NEXT:    mul a3, a4, a3
; RV64IM-NEXT:    sub a3, a6, a3
; RV64IM-NEXT:    sh a3, 6(a0)
; RV64IM-NEXT:    sh a2, 4(a0)
; RV64IM-NEXT:    sh a1, 2(a0)
; RV64IM-NEXT:    sh t0, 0(a0)
; RV64IM-NEXT:    ret
  %1 = urem <4 x i16> %x, <i16 95, i16 95, i16 95, i16 95>
  ret <4 x i16> %1
}


; Don't fold if we can combine urem with udiv.
define <4 x i16> @combine_urem_udiv(<4 x i16> %x) nounwind {
; RV32I-LABEL: combine_urem_udiv:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -48
; RV32I-NEXT:    sw ra, 44(sp)
; RV32I-NEXT:    sw s0, 40(sp)
; RV32I-NEXT:    sw s1, 36(sp)
; RV32I-NEXT:    sw s2, 32(sp)
; RV32I-NEXT:    sw s3, 28(sp)
; RV32I-NEXT:    sw s4, 24(sp)
; RV32I-NEXT:    sw s5, 20(sp)
; RV32I-NEXT:    sw s6, 16(sp)
; RV32I-NEXT:    sw s7, 12(sp)
; RV32I-NEXT:    sw s8, 8(sp)
; RV32I-NEXT:    sw s9, 4(sp)
; RV32I-NEXT:    lhu s2, 0(a1)
; RV32I-NEXT:    lhu s3, 4(a1)
; RV32I-NEXT:    lhu s4, 8(a1)
; RV32I-NEXT:    lhu s1, 12(a1)
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s5, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s4
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s6, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s3
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s7, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s2
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s8, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    call __udivsi3
; RV32I-NEXT:    mv s9, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s4
; RV32I-NEXT:    call __udivsi3
; RV32I-NEXT:    mv s4, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s3
; RV32I-NEXT:    call __udivsi3
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s2
; RV32I-NEXT:    call __udivsi3
; RV32I-NEXT:    add a0, s8, a0
; RV32I-NEXT:    add a1, s7, s1
; RV32I-NEXT:    add a2, s6, s4
; RV32I-NEXT:    add a3, s5, s9
; RV32I-NEXT:    sh a3, 6(s0)
; RV32I-NEXT:    sh a2, 4(s0)
; RV32I-NEXT:    sh a1, 2(s0)
; RV32I-NEXT:    sh a0, 0(s0)
; RV32I-NEXT:    lw s9, 4(sp)
; RV32I-NEXT:    lw s8, 8(sp)
; RV32I-NEXT:    lw s7, 12(sp)
; RV32I-NEXT:    lw s6, 16(sp)
; RV32I-NEXT:    lw s5, 20(sp)
; RV32I-NEXT:    lw s4, 24(sp)
; RV32I-NEXT:    lw s3, 28(sp)
; RV32I-NEXT:    lw s2, 32(sp)
; RV32I-NEXT:    lw s1, 36(sp)
; RV32I-NEXT:    lw s0, 40(sp)
; RV32I-NEXT:    lw ra, 44(sp)
; RV32I-NEXT:    addi sp, sp, 48
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: combine_urem_udiv:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lhu a6, 0(a1)
; RV32IM-NEXT:    lhu a7, 4(a1)
; RV32IM-NEXT:    lhu a4, 12(a1)
; RV32IM-NEXT:    lhu a1, 8(a1)
; RV32IM-NEXT:    lui a5, 364242
; RV32IM-NEXT:    addi a5, a5, 777
; RV32IM-NEXT:    mulhu a2, a4, a5
; RV32IM-NEXT:    sub a3, a4, a2
; RV32IM-NEXT:    srli a3, a3, 1
; RV32IM-NEXT:    add a2, a3, a2
; RV32IM-NEXT:    srli t3, a2, 6
; RV32IM-NEXT:    addi t0, zero, 95
; RV32IM-NEXT:    mul a3, t3, t0
; RV32IM-NEXT:    sub t1, a4, a3
; RV32IM-NEXT:    mulhu a4, a1, a5
; RV32IM-NEXT:    sub a3, a1, a4
; RV32IM-NEXT:    srli a3, a3, 1
; RV32IM-NEXT:    add a3, a3, a4
; RV32IM-NEXT:    srli a3, a3, 6
; RV32IM-NEXT:    mul a4, a3, t0
; RV32IM-NEXT:    sub t2, a1, a4
; RV32IM-NEXT:    mulhu a4, a7, a5
; RV32IM-NEXT:    sub a1, a7, a4
; RV32IM-NEXT:    srli a1, a1, 1
; RV32IM-NEXT:    add a1, a1, a4
; RV32IM-NEXT:    srli a1, a1, 6
; RV32IM-NEXT:    mul a4, a1, t0
; RV32IM-NEXT:    sub a4, a7, a4
; RV32IM-NEXT:    mulhu a5, a6, a5
; RV32IM-NEXT:    sub a2, a6, a5
; RV32IM-NEXT:    srli a2, a2, 1
; RV32IM-NEXT:    add a2, a2, a5
; RV32IM-NEXT:    srli a2, a2, 6
; RV32IM-NEXT:    mul a5, a2, t0
; RV32IM-NEXT:    sub a5, a6, a5
; RV32IM-NEXT:    add a2, a5, a2
; RV32IM-NEXT:    add a1, a4, a1
; RV32IM-NEXT:    add a3, t2, a3
; RV32IM-NEXT:    add a4, t1, t3
; RV32IM-NEXT:    sh a4, 6(a0)
; RV32IM-NEXT:    sh a3, 4(a0)
; RV32IM-NEXT:    sh a1, 2(a0)
; RV32IM-NEXT:    sh a2, 0(a0)
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: combine_urem_udiv:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -96
; RV64I-NEXT:    sd ra, 88(sp)
; RV64I-NEXT:    sd s0, 80(sp)
; RV64I-NEXT:    sd s1, 72(sp)
; RV64I-NEXT:    sd s2, 64(sp)
; RV64I-NEXT:    sd s3, 56(sp)
; RV64I-NEXT:    sd s4, 48(sp)
; RV64I-NEXT:    sd s5, 40(sp)
; RV64I-NEXT:    sd s6, 32(sp)
; RV64I-NEXT:    sd s7, 24(sp)
; RV64I-NEXT:    sd s8, 16(sp)
; RV64I-NEXT:    sd s9, 8(sp)
; RV64I-NEXT:    lhu s2, 0(a1)
; RV64I-NEXT:    lhu s3, 8(a1)
; RV64I-NEXT:    lhu s4, 16(a1)
; RV64I-NEXT:    lhu s1, 24(a1)
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s5, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s4
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s6, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s3
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s7, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s2
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s8, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    call __udivdi3
; RV64I-NEXT:    mv s9, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s4
; RV64I-NEXT:    call __udivdi3
; RV64I-NEXT:    mv s4, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s3
; RV64I-NEXT:    call __udivdi3
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s2
; RV64I-NEXT:    call __udivdi3
; RV64I-NEXT:    add a0, s8, a0
; RV64I-NEXT:    add a1, s7, s1
; RV64I-NEXT:    add a2, s6, s4
; RV64I-NEXT:    add a3, s5, s9
; RV64I-NEXT:    sh a3, 6(s0)
; RV64I-NEXT:    sh a2, 4(s0)
; RV64I-NEXT:    sh a1, 2(s0)
; RV64I-NEXT:    sh a0, 0(s0)
; RV64I-NEXT:    ld s9, 8(sp)
; RV64I-NEXT:    ld s8, 16(sp)
; RV64I-NEXT:    ld s7, 24(sp)
; RV64I-NEXT:    ld s6, 32(sp)
; RV64I-NEXT:    ld s5, 40(sp)
; RV64I-NEXT:    ld s4, 48(sp)
; RV64I-NEXT:    ld s3, 56(sp)
; RV64I-NEXT:    ld s2, 64(sp)
; RV64I-NEXT:    ld s1, 72(sp)
; RV64I-NEXT:    ld s0, 80(sp)
; RV64I-NEXT:    ld ra, 88(sp)
; RV64I-NEXT:    addi sp, sp, 96
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: combine_urem_udiv:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lhu a6, 0(a1)
; RV64IM-NEXT:    lhu a7, 8(a1)
; RV64IM-NEXT:    lhu a4, 16(a1)
; RV64IM-NEXT:    lhu a1, 24(a1)
; RV64IM-NEXT:    lui a5, 1423
; RV64IM-NEXT:    addiw a5, a5, -733
; RV64IM-NEXT:    slli a5, a5, 15
; RV64IM-NEXT:    addi a5, a5, 1035
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, -1811
; RV64IM-NEXT:    slli a5, a5, 12
; RV64IM-NEXT:    addi a5, a5, 561
; RV64IM-NEXT:    mulhu a2, a1, a5
; RV64IM-NEXT:    sub a3, a1, a2
; RV64IM-NEXT:    srli a3, a3, 1
; RV64IM-NEXT:    add a2, a3, a2
; RV64IM-NEXT:    srli t3, a2, 6
; RV64IM-NEXT:    addi t0, zero, 95
; RV64IM-NEXT:    mul a3, t3, t0
; RV64IM-NEXT:    sub t1, a1, a3
; RV64IM-NEXT:    mulhu a3, a4, a5
; RV64IM-NEXT:    sub a1, a4, a3
; RV64IM-NEXT:    srli a1, a1, 1
; RV64IM-NEXT:    add a1, a1, a3
; RV64IM-NEXT:    srli a1, a1, 6
; RV64IM-NEXT:    mul a3, a1, t0
; RV64IM-NEXT:    sub t2, a4, a3
; RV64IM-NEXT:    mulhu a4, a7, a5
; RV64IM-NEXT:    sub a3, a7, a4
; RV64IM-NEXT:    srli a3, a3, 1
; RV64IM-NEXT:    add a3, a3, a4
; RV64IM-NEXT:    srli a3, a3, 6
; RV64IM-NEXT:    mul a4, a3, t0
; RV64IM-NEXT:    sub a4, a7, a4
; RV64IM-NEXT:    mulhu a5, a6, a5
; RV64IM-NEXT:    sub a2, a6, a5
; RV64IM-NEXT:    srli a2, a2, 1
; RV64IM-NEXT:    add a2, a2, a5
; RV64IM-NEXT:    srli a2, a2, 6
; RV64IM-NEXT:    mul a5, a2, t0
; RV64IM-NEXT:    sub a5, a6, a5
; RV64IM-NEXT:    add a2, a5, a2
; RV64IM-NEXT:    add a3, a4, a3
; RV64IM-NEXT:    add a1, t2, a1
; RV64IM-NEXT:    add a4, t1, t3
; RV64IM-NEXT:    sh a4, 6(a0)
; RV64IM-NEXT:    sh a1, 4(a0)
; RV64IM-NEXT:    sh a3, 2(a0)
; RV64IM-NEXT:    sh a2, 0(a0)
; RV64IM-NEXT:    ret
  %1 = urem <4 x i16> %x, <i16 95, i16 95, i16 95, i16 95>
  %2 = udiv <4 x i16> %x, <i16 95, i16 95, i16 95, i16 95>
  %3 = add <4 x i16> %1, %2
  ret <4 x i16> %3
}

; Don't fold for divisors that are a power of two.
define <4 x i16> @dont_fold_urem_power_of_two(<4 x i16> %x) nounwind {
; RV32I-LABEL: dont_fold_urem_power_of_two:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp)
; RV32I-NEXT:    sw s0, 24(sp)
; RV32I-NEXT:    sw s1, 20(sp)
; RV32I-NEXT:    sw s2, 16(sp)
; RV32I-NEXT:    sw s3, 12(sp)
; RV32I-NEXT:    lhu s2, 8(a1)
; RV32I-NEXT:    lhu s3, 4(a1)
; RV32I-NEXT:    lhu s1, 0(a1)
; RV32I-NEXT:    lhu a2, 12(a1)
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    andi a1, s1, 63
; RV32I-NEXT:    andi a2, s3, 31
; RV32I-NEXT:    andi a3, s2, 7
; RV32I-NEXT:    sh a0, 6(s0)
; RV32I-NEXT:    sh a3, 4(s0)
; RV32I-NEXT:    sh a2, 2(s0)
; RV32I-NEXT:    sh a1, 0(s0)
; RV32I-NEXT:    lw s3, 12(sp)
; RV32I-NEXT:    lw s2, 16(sp)
; RV32I-NEXT:    lw s1, 20(sp)
; RV32I-NEXT:    lw s0, 24(sp)
; RV32I-NEXT:    lw ra, 28(sp)
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: dont_fold_urem_power_of_two:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lhu a6, 8(a1)
; RV32IM-NEXT:    lhu a3, 4(a1)
; RV32IM-NEXT:    lhu a4, 12(a1)
; RV32IM-NEXT:    lhu a1, 0(a1)
; RV32IM-NEXT:    lui a5, 364242
; RV32IM-NEXT:    addi a5, a5, 777
; RV32IM-NEXT:    mulhu a5, a4, a5
; RV32IM-NEXT:    sub a2, a4, a5
; RV32IM-NEXT:    srli a2, a2, 1
; RV32IM-NEXT:    add a2, a2, a5
; RV32IM-NEXT:    srli a2, a2, 6
; RV32IM-NEXT:    addi a5, zero, 95
; RV32IM-NEXT:    mul a2, a2, a5
; RV32IM-NEXT:    sub a2, a4, a2
; RV32IM-NEXT:    andi a1, a1, 63
; RV32IM-NEXT:    andi a3, a3, 31
; RV32IM-NEXT:    andi a4, a6, 7
; RV32IM-NEXT:    sh a4, 4(a0)
; RV32IM-NEXT:    sh a3, 2(a0)
; RV32IM-NEXT:    sh a1, 0(a0)
; RV32IM-NEXT:    sh a2, 6(a0)
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: dont_fold_urem_power_of_two:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -48
; RV64I-NEXT:    sd ra, 40(sp)
; RV64I-NEXT:    sd s0, 32(sp)
; RV64I-NEXT:    sd s1, 24(sp)
; RV64I-NEXT:    sd s2, 16(sp)
; RV64I-NEXT:    sd s3, 8(sp)
; RV64I-NEXT:    lhu s2, 16(a1)
; RV64I-NEXT:    lhu s3, 8(a1)
; RV64I-NEXT:    lhu s1, 0(a1)
; RV64I-NEXT:    lhu a2, 24(a1)
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    andi a1, s1, 63
; RV64I-NEXT:    andi a2, s3, 31
; RV64I-NEXT:    andi a3, s2, 7
; RV64I-NEXT:    sh a0, 6(s0)
; RV64I-NEXT:    sh a3, 4(s0)
; RV64I-NEXT:    sh a2, 2(s0)
; RV64I-NEXT:    sh a1, 0(s0)
; RV64I-NEXT:    ld s3, 8(sp)
; RV64I-NEXT:    ld s2, 16(sp)
; RV64I-NEXT:    ld s1, 24(sp)
; RV64I-NEXT:    ld s0, 32(sp)
; RV64I-NEXT:    ld ra, 40(sp)
; RV64I-NEXT:    addi sp, sp, 48
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: dont_fold_urem_power_of_two:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lhu a6, 16(a1)
; RV64IM-NEXT:    lhu a3, 8(a1)
; RV64IM-NEXT:    lhu a4, 0(a1)
; RV64IM-NEXT:    lhu a1, 24(a1)
; RV64IM-NEXT:    lui a5, 1423
; RV64IM-NEXT:    addiw a5, a5, -733
; RV64IM-NEXT:    slli a5, a5, 15
; RV64IM-NEXT:    addi a5, a5, 1035
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, -1811
; RV64IM-NEXT:    slli a5, a5, 12
; RV64IM-NEXT:    addi a5, a5, 561
; RV64IM-NEXT:    mulhu a5, a1, a5
; RV64IM-NEXT:    sub a2, a1, a5
; RV64IM-NEXT:    srli a2, a2, 1
; RV64IM-NEXT:    add a2, a2, a5
; RV64IM-NEXT:    srli a2, a2, 6
; RV64IM-NEXT:    addi a5, zero, 95
; RV64IM-NEXT:    mul a2, a2, a5
; RV64IM-NEXT:    sub a1, a1, a2
; RV64IM-NEXT:    andi a2, a4, 63
; RV64IM-NEXT:    andi a3, a3, 31
; RV64IM-NEXT:    andi a4, a6, 7
; RV64IM-NEXT:    sh a4, 4(a0)
; RV64IM-NEXT:    sh a3, 2(a0)
; RV64IM-NEXT:    sh a2, 0(a0)
; RV64IM-NEXT:    sh a1, 6(a0)
; RV64IM-NEXT:    ret
  %1 = urem <4 x i16> %x, <i16 64, i16 32, i16 8, i16 95>
  ret <4 x i16> %1
}

; Don't fold if the divisor is one.
define <4 x i16> @dont_fold_urem_one(<4 x i16> %x) nounwind {
; RV32I-LABEL: dont_fold_urem_one:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp)
; RV32I-NEXT:    sw s0, 24(sp)
; RV32I-NEXT:    sw s1, 20(sp)
; RV32I-NEXT:    sw s2, 16(sp)
; RV32I-NEXT:    sw s3, 12(sp)
; RV32I-NEXT:    lhu s2, 12(a1)
; RV32I-NEXT:    lhu s1, 8(a1)
; RV32I-NEXT:    lhu a2, 4(a1)
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    addi a1, zero, 654
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s3, a0
; RV32I-NEXT:    addi a1, zero, 23
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    lui a0, 1
; RV32I-NEXT:    addi a1, a0, 1327
; RV32I-NEXT:    mv a0, s2
; RV32I-NEXT:    call __umodsi3
; RV32I-NEXT:    sh zero, 0(s0)
; RV32I-NEXT:    sh a0, 6(s0)
; RV32I-NEXT:    sh s1, 4(s0)
; RV32I-NEXT:    sh s3, 2(s0)
; RV32I-NEXT:    lw s3, 12(sp)
; RV32I-NEXT:    lw s2, 16(sp)
; RV32I-NEXT:    lw s1, 20(sp)
; RV32I-NEXT:    lw s0, 24(sp)
; RV32I-NEXT:    lw ra, 28(sp)
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: dont_fold_urem_one:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lhu a2, 4(a1)
; RV32IM-NEXT:    lhu a3, 12(a1)
; RV32IM-NEXT:    lhu a1, 8(a1)
; RV32IM-NEXT:    srli a4, a2, 1
; RV32IM-NEXT:    lui a5, 820904
; RV32IM-NEXT:    addi a5, a5, -1903
; RV32IM-NEXT:    mulhu a4, a4, a5
; RV32IM-NEXT:    srli a4, a4, 8
; RV32IM-NEXT:    addi a5, zero, 654
; RV32IM-NEXT:    mul a4, a4, a5
; RV32IM-NEXT:    sub a2, a2, a4
; RV32IM-NEXT:    lui a4, 729444
; RV32IM-NEXT:    addi a4, a4, 713
; RV32IM-NEXT:    mulhu a4, a1, a4
; RV32IM-NEXT:    srli a4, a4, 4
; RV32IM-NEXT:    addi a5, zero, 23
; RV32IM-NEXT:    mul a4, a4, a5
; RV32IM-NEXT:    sub a1, a1, a4
; RV32IM-NEXT:    lui a4, 395996
; RV32IM-NEXT:    addi a4, a4, -2009
; RV32IM-NEXT:    mulhu a4, a3, a4
; RV32IM-NEXT:    srli a4, a4, 11
; RV32IM-NEXT:    lui a5, 1
; RV32IM-NEXT:    addi a5, a5, 1327
; RV32IM-NEXT:    mul a4, a4, a5
; RV32IM-NEXT:    sub a3, a3, a4
; RV32IM-NEXT:    sh zero, 0(a0)
; RV32IM-NEXT:    sh a3, 6(a0)
; RV32IM-NEXT:    sh a1, 4(a0)
; RV32IM-NEXT:    sh a2, 2(a0)
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: dont_fold_urem_one:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -48
; RV64I-NEXT:    sd ra, 40(sp)
; RV64I-NEXT:    sd s0, 32(sp)
; RV64I-NEXT:    sd s1, 24(sp)
; RV64I-NEXT:    sd s2, 16(sp)
; RV64I-NEXT:    sd s3, 8(sp)
; RV64I-NEXT:    lhu s2, 24(a1)
; RV64I-NEXT:    lhu s1, 16(a1)
; RV64I-NEXT:    lhu a2, 8(a1)
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    addi a1, zero, 654
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s3, a0
; RV64I-NEXT:    addi a1, zero, 23
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    lui a0, 1
; RV64I-NEXT:    addiw a1, a0, 1327
; RV64I-NEXT:    mv a0, s2
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    sh zero, 0(s0)
; RV64I-NEXT:    sh a0, 6(s0)
; RV64I-NEXT:    sh s1, 4(s0)
; RV64I-NEXT:    sh s3, 2(s0)
; RV64I-NEXT:    ld s3, 8(sp)
; RV64I-NEXT:    ld s2, 16(sp)
; RV64I-NEXT:    ld s1, 24(sp)
; RV64I-NEXT:    ld s0, 32(sp)
; RV64I-NEXT:    ld ra, 40(sp)
; RV64I-NEXT:    addi sp, sp, 48
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: dont_fold_urem_one:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lhu a2, 24(a1)
; RV64IM-NEXT:    lhu a3, 8(a1)
; RV64IM-NEXT:    lhu a1, 16(a1)
; RV64IM-NEXT:    lui a4, 3206
; RV64IM-NEXT:    addiw a4, a4, -1781
; RV64IM-NEXT:    slli a4, a4, 13
; RV64IM-NEXT:    addi a4, a4, 1069
; RV64IM-NEXT:    slli a4, a4, 12
; RV64IM-NEXT:    addi a4, a4, -1959
; RV64IM-NEXT:    slli a4, a4, 14
; RV64IM-NEXT:    addi a4, a4, 713
; RV64IM-NEXT:    mulhu a4, a1, a4
; RV64IM-NEXT:    sub a5, a1, a4
; RV64IM-NEXT:    srli a5, a5, 1
; RV64IM-NEXT:    add a4, a5, a4
; RV64IM-NEXT:    srli a4, a4, 4
; RV64IM-NEXT:    addi a5, zero, 23
; RV64IM-NEXT:    mul a4, a4, a5
; RV64IM-NEXT:    sub a1, a1, a4
; RV64IM-NEXT:    srli a4, a3, 1
; RV64IM-NEXT:    lui a5, 6413
; RV64IM-NEXT:    addiw a5, a5, 1265
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, 1027
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, 1077
; RV64IM-NEXT:    slli a5, a5, 12
; RV64IM-NEXT:    addi a5, a5, 965
; RV64IM-NEXT:    mulhu a4, a4, a5
; RV64IM-NEXT:    srli a4, a4, 7
; RV64IM-NEXT:    addi a5, zero, 654
; RV64IM-NEXT:    mul a4, a4, a5
; RV64IM-NEXT:    sub a3, a3, a4
; RV64IM-NEXT:    lui a4, 1044567
; RV64IM-NEXT:    addiw a4, a4, -575
; RV64IM-NEXT:    slli a4, a4, 12
; RV64IM-NEXT:    addi a4, a4, 883
; RV64IM-NEXT:    slli a4, a4, 14
; RV64IM-NEXT:    addi a4, a4, -861
; RV64IM-NEXT:    slli a4, a4, 12
; RV64IM-NEXT:    addi a4, a4, -179
; RV64IM-NEXT:    mulhu a4, a2, a4
; RV64IM-NEXT:    srli a4, a4, 12
; RV64IM-NEXT:    lui a5, 1
; RV64IM-NEXT:    addiw a5, a5, 1327
; RV64IM-NEXT:    mul a4, a4, a5
; RV64IM-NEXT:    sub a2, a2, a4
; RV64IM-NEXT:    sh zero, 0(a0)
; RV64IM-NEXT:    sh a2, 6(a0)
; RV64IM-NEXT:    sh a3, 2(a0)
; RV64IM-NEXT:    sh a1, 4(a0)
; RV64IM-NEXT:    ret
  %1 = urem <4 x i16> %x, <i16 1, i16 654, i16 23, i16 5423>
  ret <4 x i16> %1
}

; Don't fold if the divisor is 2^16.
define <4 x i16> @dont_fold_urem_i16_smax(<4 x i16> %x) nounwind {
; CHECK-LABEL: dont_fold_urem_i16_smax:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %1 = urem <4 x i16> %x, <i16 1, i16 65536, i16 23, i16 5423>
  ret <4 x i16> %1
}

; Don't fold i64 urem.
define <4 x i64> @dont_fold_urem_i64(<4 x i64> %x) nounwind {
; RV32I-LABEL: dont_fold_urem_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -48
; RV32I-NEXT:    sw ra, 44(sp)
; RV32I-NEXT:    sw s0, 40(sp)
; RV32I-NEXT:    sw s1, 36(sp)
; RV32I-NEXT:    sw s2, 32(sp)
; RV32I-NEXT:    sw s3, 28(sp)
; RV32I-NEXT:    sw s4, 24(sp)
; RV32I-NEXT:    sw s5, 20(sp)
; RV32I-NEXT:    sw s6, 16(sp)
; RV32I-NEXT:    sw s7, 12(sp)
; RV32I-NEXT:    sw s8, 8(sp)
; RV32I-NEXT:    sw s9, 4(sp)
; RV32I-NEXT:    lw s2, 24(a1)
; RV32I-NEXT:    lw s3, 28(a1)
; RV32I-NEXT:    lw s4, 16(a1)
; RV32I-NEXT:    lw s5, 20(a1)
; RV32I-NEXT:    lw s6, 8(a1)
; RV32I-NEXT:    lw s1, 12(a1)
; RV32I-NEXT:    lw a3, 0(a1)
; RV32I-NEXT:    lw a1, 4(a1)
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    addi a2, zero, 1
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:    mv a3, zero
; RV32I-NEXT:    call __umoddi3
; RV32I-NEXT:    mv s7, a0
; RV32I-NEXT:    mv s8, a1
; RV32I-NEXT:    addi a2, zero, 654
; RV32I-NEXT:    mv a0, s6
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    mv a3, zero
; RV32I-NEXT:    call __umoddi3
; RV32I-NEXT:    mv s6, a0
; RV32I-NEXT:    mv s9, a1
; RV32I-NEXT:    addi a2, zero, 23
; RV32I-NEXT:    mv a0, s4
; RV32I-NEXT:    mv a1, s5
; RV32I-NEXT:    mv a3, zero
; RV32I-NEXT:    call __umoddi3
; RV32I-NEXT:    mv s4, a0
; RV32I-NEXT:    mv s1, a1
; RV32I-NEXT:    lui a0, 1
; RV32I-NEXT:    addi a2, a0, 1327
; RV32I-NEXT:    mv a0, s2
; RV32I-NEXT:    mv a1, s3
; RV32I-NEXT:    mv a3, zero
; RV32I-NEXT:    call __umoddi3
; RV32I-NEXT:    sw a1, 28(s0)
; RV32I-NEXT:    sw a0, 24(s0)
; RV32I-NEXT:    sw s1, 20(s0)
; RV32I-NEXT:    sw s4, 16(s0)
; RV32I-NEXT:    sw s9, 12(s0)
; RV32I-NEXT:    sw s6, 8(s0)
; RV32I-NEXT:    sw s8, 4(s0)
; RV32I-NEXT:    sw s7, 0(s0)
; RV32I-NEXT:    lw s9, 4(sp)
; RV32I-NEXT:    lw s8, 8(sp)
; RV32I-NEXT:    lw s7, 12(sp)
; RV32I-NEXT:    lw s6, 16(sp)
; RV32I-NEXT:    lw s5, 20(sp)
; RV32I-NEXT:    lw s4, 24(sp)
; RV32I-NEXT:    lw s3, 28(sp)
; RV32I-NEXT:    lw s2, 32(sp)
; RV32I-NEXT:    lw s1, 36(sp)
; RV32I-NEXT:    lw s0, 40(sp)
; RV32I-NEXT:    lw ra, 44(sp)
; RV32I-NEXT:    addi sp, sp, 48
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: dont_fold_urem_i64:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi sp, sp, -48
; RV32IM-NEXT:    sw ra, 44(sp)
; RV32IM-NEXT:    sw s0, 40(sp)
; RV32IM-NEXT:    sw s1, 36(sp)
; RV32IM-NEXT:    sw s2, 32(sp)
; RV32IM-NEXT:    sw s3, 28(sp)
; RV32IM-NEXT:    sw s4, 24(sp)
; RV32IM-NEXT:    sw s5, 20(sp)
; RV32IM-NEXT:    sw s6, 16(sp)
; RV32IM-NEXT:    sw s7, 12(sp)
; RV32IM-NEXT:    sw s8, 8(sp)
; RV32IM-NEXT:    sw s9, 4(sp)
; RV32IM-NEXT:    lw s2, 24(a1)
; RV32IM-NEXT:    lw s3, 28(a1)
; RV32IM-NEXT:    lw s4, 16(a1)
; RV32IM-NEXT:    lw s5, 20(a1)
; RV32IM-NEXT:    lw s6, 8(a1)
; RV32IM-NEXT:    lw s1, 12(a1)
; RV32IM-NEXT:    lw a3, 0(a1)
; RV32IM-NEXT:    lw a1, 4(a1)
; RV32IM-NEXT:    mv s0, a0
; RV32IM-NEXT:    addi a2, zero, 1
; RV32IM-NEXT:    mv a0, a3
; RV32IM-NEXT:    mv a3, zero
; RV32IM-NEXT:    call __umoddi3
; RV32IM-NEXT:    mv s7, a0
; RV32IM-NEXT:    mv s8, a1
; RV32IM-NEXT:    addi a2, zero, 654
; RV32IM-NEXT:    mv a0, s6
; RV32IM-NEXT:    mv a1, s1
; RV32IM-NEXT:    mv a3, zero
; RV32IM-NEXT:    call __umoddi3
; RV32IM-NEXT:    mv s6, a0
; RV32IM-NEXT:    mv s9, a1
; RV32IM-NEXT:    addi a2, zero, 23
; RV32IM-NEXT:    mv a0, s4
; RV32IM-NEXT:    mv a1, s5
; RV32IM-NEXT:    mv a3, zero
; RV32IM-NEXT:    call __umoddi3
; RV32IM-NEXT:    mv s4, a0
; RV32IM-NEXT:    mv s1, a1
; RV32IM-NEXT:    lui a0, 1
; RV32IM-NEXT:    addi a2, a0, 1327
; RV32IM-NEXT:    mv a0, s2
; RV32IM-NEXT:    mv a1, s3
; RV32IM-NEXT:    mv a3, zero
; RV32IM-NEXT:    call __umoddi3
; RV32IM-NEXT:    sw a1, 28(s0)
; RV32IM-NEXT:    sw a0, 24(s0)
; RV32IM-NEXT:    sw s1, 20(s0)
; RV32IM-NEXT:    sw s4, 16(s0)
; RV32IM-NEXT:    sw s9, 12(s0)
; RV32IM-NEXT:    sw s6, 8(s0)
; RV32IM-NEXT:    sw s8, 4(s0)
; RV32IM-NEXT:    sw s7, 0(s0)
; RV32IM-NEXT:    lw s9, 4(sp)
; RV32IM-NEXT:    lw s8, 8(sp)
; RV32IM-NEXT:    lw s7, 12(sp)
; RV32IM-NEXT:    lw s6, 16(sp)
; RV32IM-NEXT:    lw s5, 20(sp)
; RV32IM-NEXT:    lw s4, 24(sp)
; RV32IM-NEXT:    lw s3, 28(sp)
; RV32IM-NEXT:    lw s2, 32(sp)
; RV32IM-NEXT:    lw s1, 36(sp)
; RV32IM-NEXT:    lw s0, 40(sp)
; RV32IM-NEXT:    lw ra, 44(sp)
; RV32IM-NEXT:    addi sp, sp, 48
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: dont_fold_urem_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -48
; RV64I-NEXT:    sd ra, 40(sp)
; RV64I-NEXT:    sd s0, 32(sp)
; RV64I-NEXT:    sd s1, 24(sp)
; RV64I-NEXT:    sd s2, 16(sp)
; RV64I-NEXT:    sd s3, 8(sp)
; RV64I-NEXT:    ld s2, 24(a1)
; RV64I-NEXT:    ld s1, 16(a1)
; RV64I-NEXT:    ld a2, 8(a1)
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    addi a1, zero, 654
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s3, a0
; RV64I-NEXT:    addi a1, zero, 23
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    lui a0, 1
; RV64I-NEXT:    addiw a1, a0, 1327
; RV64I-NEXT:    mv a0, s2
; RV64I-NEXT:    call __umoddi3
; RV64I-NEXT:    sd zero, 0(s0)
; RV64I-NEXT:    sd a0, 24(s0)
; RV64I-NEXT:    sd s1, 16(s0)
; RV64I-NEXT:    sd s3, 8(s0)
; RV64I-NEXT:    ld s3, 8(sp)
; RV64I-NEXT:    ld s2, 16(sp)
; RV64I-NEXT:    ld s1, 24(sp)
; RV64I-NEXT:    ld s0, 32(sp)
; RV64I-NEXT:    ld ra, 40(sp)
; RV64I-NEXT:    addi sp, sp, 48
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: dont_fold_urem_i64:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    ld a2, 24(a1)
; RV64IM-NEXT:    ld a3, 8(a1)
; RV64IM-NEXT:    ld a1, 16(a1)
; RV64IM-NEXT:    lui a4, 3206
; RV64IM-NEXT:    addiw a4, a4, -1781
; RV64IM-NEXT:    slli a4, a4, 13
; RV64IM-NEXT:    addi a4, a4, 1069
; RV64IM-NEXT:    slli a4, a4, 12
; RV64IM-NEXT:    addi a4, a4, -1959
; RV64IM-NEXT:    slli a4, a4, 14
; RV64IM-NEXT:    addi a4, a4, 713
; RV64IM-NEXT:    mulhu a4, a1, a4
; RV64IM-NEXT:    sub a5, a1, a4
; RV64IM-NEXT:    srli a5, a5, 1
; RV64IM-NEXT:    add a4, a5, a4
; RV64IM-NEXT:    srli a4, a4, 4
; RV64IM-NEXT:    addi a5, zero, 23
; RV64IM-NEXT:    mul a4, a4, a5
; RV64IM-NEXT:    sub a1, a1, a4
; RV64IM-NEXT:    srli a4, a3, 1
; RV64IM-NEXT:    lui a5, 6413
; RV64IM-NEXT:    addiw a5, a5, 1265
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, 1027
; RV64IM-NEXT:    slli a5, a5, 13
; RV64IM-NEXT:    addi a5, a5, 1077
; RV64IM-NEXT:    slli a5, a5, 12
; RV64IM-NEXT:    addi a5, a5, 965
; RV64IM-NEXT:    mulhu a4, a4, a5
; RV64IM-NEXT:    srli a4, a4, 7
; RV64IM-NEXT:    addi a5, zero, 654
; RV64IM-NEXT:    mul a4, a4, a5
; RV64IM-NEXT:    sub a3, a3, a4
; RV64IM-NEXT:    lui a4, 1044567
; RV64IM-NEXT:    addiw a4, a4, -575
; RV64IM-NEXT:    slli a4, a4, 12
; RV64IM-NEXT:    addi a4, a4, 883
; RV64IM-NEXT:    slli a4, a4, 14
; RV64IM-NEXT:    addi a4, a4, -861
; RV64IM-NEXT:    slli a4, a4, 12
; RV64IM-NEXT:    addi a4, a4, -179
; RV64IM-NEXT:    mulhu a4, a2, a4
; RV64IM-NEXT:    srli a4, a4, 12
; RV64IM-NEXT:    lui a5, 1
; RV64IM-NEXT:    addiw a5, a5, 1327
; RV64IM-NEXT:    mul a4, a4, a5
; RV64IM-NEXT:    sub a2, a2, a4
; RV64IM-NEXT:    sd zero, 0(a0)
; RV64IM-NEXT:    sd a2, 24(a0)
; RV64IM-NEXT:    sd a3, 8(a0)
; RV64IM-NEXT:    sd a1, 16(a0)
; RV64IM-NEXT:    ret
  %1 = urem <4 x i64> %x, <i64 1, i64 654, i64 23, i64 5423>
  ret <4 x i64> %1
}
