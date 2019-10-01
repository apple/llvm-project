; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv32 -mattr=+a -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s
; RUN: llc -mtriple=riscv64 -mattr=+a -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s

define void @fence_acquire() nounwind {
; RV32I-LABEL: fence_acquire:
; RV32I:       # %bb.0:
; RV32I-NEXT:    fence r, rw
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fence_acquire:
; RV64I:       # %bb.0:
; RV64I-NEXT:    fence r, rw
; RV64I-NEXT:    ret
  fence acquire
  ret void
}

define void @fence_release() nounwind {
; RV32I-LABEL: fence_release:
; RV32I:       # %bb.0:
; RV32I-NEXT:    fence rw, w
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fence_release:
; RV64I:       # %bb.0:
; RV64I-NEXT:    fence rw, w
; RV64I-NEXT:    ret
  fence release
  ret void
}

define void @fence_acq_rel() nounwind {
; RV32I-LABEL: fence_acq_rel:
; RV32I:       # %bb.0:
; RV32I-NEXT:    fence.tso
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fence_acq_rel:
; RV64I:       # %bb.0:
; RV64I-NEXT:    fence.tso
; RV64I-NEXT:    ret
  fence acq_rel
  ret void
}

define void @fence_seq_cst() nounwind {
; RV32I-LABEL: fence_seq_cst:
; RV32I:       # %bb.0:
; RV32I-NEXT:    fence rw, rw
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fence_seq_cst:
; RV64I:       # %bb.0:
; RV64I-NEXT:    fence rw, rw
; RV64I-NEXT:    ret
  fence seq_cst
  ret void
}
