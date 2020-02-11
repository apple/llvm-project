; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

; RUN: llc -march=mips -verify-machineinstrs \
; RUN:   < %s | FileCheck %s -check-prefix=MIPS32
; RUN: llc -march=mips -verify-machineinstrs -relocation-model=pic \
; RUN:   < %s | FileCheck %s -check-prefix=MIPS32-PIC
; RUN: llc -march=mips64 -verify-machineinstrs \
; RUN:   < %s | FileCheck %s -check-prefix=MIPS64
; RUN: llc -march=mips64 -verify-machineinstrs -relocation-model=pic \
; RUN:   < %s | FileCheck %s -check-prefix=MIPS64-PIC
; RUN: llc -march=mips -verify-machineinstrs -mattr=+micromips \
; RUN:   < %s | FileCheck %s -check-prefix=MIPS32-MM
; RUN: llc -march=mips -verify-machineinstrs -relocation-model=pic -mattr=+micromips \
; RUN:   < %s | FileCheck %s -check-prefix=MIPS32-MM-PIC

; Test that checks ABI for _mcount calls.

; Function Attrs: noinline nounwind optnone
define void @foo() #0 {
; MIPS32-LABEL: foo:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    move $1, $ra
; MIPS32-NEXT:    jal _mcount
; MIPS32-NEXT:    addiu $sp, $sp, -8
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    addiu $sp, $sp, 24
;
; MIPS32-PIC-LABEL: foo:
; MIPS32-PIC:       # %bb.0: # %entry
; MIPS32-PIC-NEXT:    lui $2, %hi(_gp_disp)
; MIPS32-PIC-NEXT:    addiu $2, $2, %lo(_gp_disp)
; MIPS32-PIC-NEXT:    addiu $sp, $sp, -24
; MIPS32-PIC-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-PIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-PIC-NEXT:    .cfi_offset 31, -4
; MIPS32-PIC-NEXT:    addu $gp, $2, $25
; MIPS32-PIC-NEXT:    lw $25, %call16(_mcount)($gp)
; MIPS32-PIC-NEXT:    move $1, $ra
; MIPS32-PIC-NEXT:    .reloc ($tmp0), R_MIPS_JALR, _mcount
; MIPS32-PIC-NEXT:  $tmp0:
; MIPS32-PIC-NEXT:    jalr $25
; MIPS32-PIC-NEXT:    addiu $sp, $sp, -8
; MIPS32-PIC-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-PIC-NEXT:    jr $ra
; MIPS32-PIC-NEXT:    addiu $sp, $sp, 24
;
; MIPS64-LABEL: foo:
; MIPS64:       # %bb.0: # %entry
; MIPS64-NEXT:    daddiu $sp, $sp, -16
; MIPS64-NEXT:    .cfi_def_cfa_offset 16
; MIPS64-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; MIPS64-NEXT:    .cfi_offset 31, -8
; MIPS64-NEXT:    move $1, $ra
; MIPS64-NEXT:    jal _mcount
; MIPS64-NEXT:    nop
; MIPS64-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; MIPS64-NEXT:    jr $ra
; MIPS64-NEXT:    daddiu $sp, $sp, 16
;
; MIPS64-PIC-LABEL: foo:
; MIPS64-PIC:       # %bb.0: # %entry
; MIPS64-PIC-NEXT:    daddiu $sp, $sp, -16
; MIPS64-PIC-NEXT:    .cfi_def_cfa_offset 16
; MIPS64-PIC-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; MIPS64-PIC-NEXT:    sd $gp, 0($sp) # 8-byte Folded Spill
; MIPS64-PIC-NEXT:    .cfi_offset 31, -8
; MIPS64-PIC-NEXT:    .cfi_offset 28, -16
; MIPS64-PIC-NEXT:    lui $1, %hi(%neg(%gp_rel(foo)))
; MIPS64-PIC-NEXT:    daddu $1, $1, $25
; MIPS64-PIC-NEXT:    daddiu $gp, $1, %lo(%neg(%gp_rel(foo)))
; MIPS64-PIC-NEXT:    ld $25, %call16(_mcount)($gp)
; MIPS64-PIC-NEXT:    move $1, $ra
; MIPS64-PIC-NEXT:    .reloc .Ltmp0, R_MIPS_JALR, _mcount
; MIPS64-PIC-NEXT:  .Ltmp0:
; MIPS64-PIC-NEXT:    jalr $25
; MIPS64-PIC-NEXT:    nop
; MIPS64-PIC-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; MIPS64-PIC-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; MIPS64-PIC-NEXT:    jr $ra
; MIPS64-PIC-NEXT:    daddiu $sp, $sp, 16
;
; MIPS32-MM-LABEL: foo:
; MIPS32-MM:       # %bb.0: # %entry
; MIPS32-MM-NEXT:    addiu $sp, $sp, -24
; MIPS32-MM-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-MM-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-MM-NEXT:    .cfi_offset 31, -4
; MIPS32-MM-NEXT:    move $1, $ra
; MIPS32-MM-NEXT:    jal _mcount
; MIPS32-MM-NEXT:    addiu $sp, $sp, -8
; MIPS32-MM-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-MM-NEXT:    jr $ra
; MIPS32-MM-NEXT:    addiu $sp, $sp, 24
;
; MIPS32-MM-PIC-LABEL: foo:
; MIPS32-MM-PIC:       # %bb.0: # %entry
; MIPS32-MM-PIC-NEXT:    lui $2, %hi(_gp_disp)
; MIPS32-MM-PIC-NEXT:    addiu $2, $2, %lo(_gp_disp)
; MIPS32-MM-PIC-NEXT:    addiu $sp, $sp, -24
; MIPS32-MM-PIC-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-MM-PIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-MM-PIC-NEXT:    .cfi_offset 31, -4
; MIPS32-MM-PIC-NEXT:    addu $2, $2, $25
; MIPS32-MM-PIC-NEXT:    lw $25, %call16(_mcount)($2)
; MIPS32-MM-PIC-NEXT:    move $gp, $2
; MIPS32-MM-PIC-NEXT:    move $1, $ra
; MIPS32-MM-PIC-NEXT:    .reloc ($tmp0), R_MICROMIPS_JALR, _mcount
; MIPS32-MM-PIC-NEXT:  $tmp0:
; MIPS32-MM-PIC-NEXT:    jalr $25
; MIPS32-MM-PIC-NEXT:    addiu $sp, $sp, -8
; MIPS32-MM-PIC-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-MM-PIC-NEXT:    jr $ra
; MIPS32-MM-PIC-NEXT:    addiu $sp, $sp, 24
entry:
  ret void
}

attributes #0 = { "instrument-function-entry-inlined"="_mcount" }
