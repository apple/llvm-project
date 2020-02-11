; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IFD %s

; Sanity checks for calling convention lowering for RV32D. This can be
; somewhat error-prone for soft-float RV32D due to the fact that f64 is legal
; but i64 is not, and there is no instruction to move values directly between
; the GPRs and 64-bit FPRs.

define double @callee_double_inreg(double %a, double %b) nounwind {
; RV32IFD-LABEL: callee_double_inreg:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw a2, 8(sp)
; RV32IFD-NEXT:    sw a3, 12(sp)
; RV32IFD-NEXT:    fld ft0, 8(sp)
; RV32IFD-NEXT:    sw a0, 8(sp)
; RV32IFD-NEXT:    sw a1, 12(sp)
; RV32IFD-NEXT:    fld ft1, 8(sp)
; RV32IFD-NEXT:    fadd.d ft0, ft1, ft0
; RV32IFD-NEXT:    fsd ft0, 8(sp)
; RV32IFD-NEXT:    lw a0, 8(sp)
; RV32IFD-NEXT:    lw a1, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
  %1 = fadd double %a, %b
  ret double %1
}

; TODO: code quality for loading and then passing f64 constants is poor.

define double @caller_double_inreg() nounwind {
; RV32IFD-LABEL: caller_double_inreg:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    lui a0, 262236
; RV32IFD-NEXT:    addi a1, a0, 655
; RV32IFD-NEXT:    lui a0, 377487
; RV32IFD-NEXT:    addi a0, a0, 1475
; RV32IFD-NEXT:    lui a2, 262364
; RV32IFD-NEXT:    addi a3, a2, 655
; RV32IFD-NEXT:    mv a2, a0
; RV32IFD-NEXT:    call callee_double_inreg
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
  %1 = call double @callee_double_inreg(double 2.720000e+00, double 3.720000e+00)
  ret double %1
}

define double @callee_double_split_reg_stack(i32 %a, i64 %b, i64 %c, double %d, double %e) nounwind {
; RV32IFD-LABEL: callee_double_split_reg_stack:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    lw a0, 16(sp)
; RV32IFD-NEXT:    sw a7, 8(sp)
; RV32IFD-NEXT:    sw a0, 12(sp)
; RV32IFD-NEXT:    fld ft0, 8(sp)
; RV32IFD-NEXT:    sw a5, 8(sp)
; RV32IFD-NEXT:    sw a6, 12(sp)
; RV32IFD-NEXT:    fld ft1, 8(sp)
; RV32IFD-NEXT:    fadd.d ft0, ft1, ft0
; RV32IFD-NEXT:    fsd ft0, 8(sp)
; RV32IFD-NEXT:    lw a0, 8(sp)
; RV32IFD-NEXT:    lw a1, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
  %1 = fadd double %d, %e
  ret double %1
}

define double @caller_double_split_reg_stack() nounwind {
; RV32IFD-LABEL: caller_double_split_reg_stack:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    lui a0, 262510
; RV32IFD-NEXT:    addi a2, a0, 327
; RV32IFD-NEXT:    lui a0, 262446
; RV32IFD-NEXT:    addi a6, a0, 327
; RV32IFD-NEXT:    lui a0, 713032
; RV32IFD-NEXT:    addi a5, a0, -1311
; RV32IFD-NEXT:    addi a0, zero, 1
; RV32IFD-NEXT:    addi a1, zero, 2
; RV32IFD-NEXT:    addi a3, zero, 3
; RV32IFD-NEXT:    sw a2, 0(sp)
; RV32IFD-NEXT:    mv a2, zero
; RV32IFD-NEXT:    mv a4, zero
; RV32IFD-NEXT:    mv a7, a5
; RV32IFD-NEXT:    call callee_double_split_reg_stack
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
  %1 = call double @callee_double_split_reg_stack(i32 1, i64 2, i64 3, double 4.72, double 5.72)
  ret double %1
}

define double @callee_double_stack(i64 %a, i64 %b, i64 %c, i64 %d, double %e, double %f) nounwind {
; RV32IFD-LABEL: callee_double_stack:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    fld ft0, 24(sp)
; RV32IFD-NEXT:    fld ft1, 16(sp)
; RV32IFD-NEXT:    fadd.d ft0, ft1, ft0
; RV32IFD-NEXT:    fsd ft0, 8(sp)
; RV32IFD-NEXT:    lw a0, 8(sp)
; RV32IFD-NEXT:    lw a1, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
  %1 = fadd double %e, %f
  ret double %1
}

define double @caller_double_stack() nounwind {
; RV32IFD-LABEL: caller_double_stack:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -32
; RV32IFD-NEXT:    sw ra, 28(sp)
; RV32IFD-NEXT:    lui a0, 262510
; RV32IFD-NEXT:    addi a0, a0, 327
; RV32IFD-NEXT:    sw a0, 4(sp)
; RV32IFD-NEXT:    lui a0, 713032
; RV32IFD-NEXT:    addi a1, a0, -1311
; RV32IFD-NEXT:    sw a1, 0(sp)
; RV32IFD-NEXT:    lui a0, 262574
; RV32IFD-NEXT:    addi a0, a0, 327
; RV32IFD-NEXT:    sw a0, 12(sp)
; RV32IFD-NEXT:    addi a0, zero, 1
; RV32IFD-NEXT:    addi a2, zero, 2
; RV32IFD-NEXT:    addi a4, zero, 3
; RV32IFD-NEXT:    addi a6, zero, 4
; RV32IFD-NEXT:    sw a1, 8(sp)
; RV32IFD-NEXT:    mv a1, zero
; RV32IFD-NEXT:    mv a3, zero
; RV32IFD-NEXT:    mv a5, zero
; RV32IFD-NEXT:    mv a7, zero
; RV32IFD-NEXT:    call callee_double_stack
; RV32IFD-NEXT:    lw ra, 28(sp)
; RV32IFD-NEXT:    addi sp, sp, 32
; RV32IFD-NEXT:    ret
  %1 = call double @callee_double_stack(i64 1, i64 2, i64 3, i64 4, double 5.72, double 6.72)
  ret double %1
}
