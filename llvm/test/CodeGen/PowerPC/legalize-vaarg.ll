; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;RUN: llc < %s --mtriple=powerpc64-unknown-linux-gnu -mattr=+altivec | FileCheck %s -check-prefix=BE
;RUN: llc < %s --mtriple=powerpc64le-unknown-linux-gnu -mattr=+altivec | FileCheck %s -check-prefix=LE

define <8 x i32> @test_large_vec_vaarg(i32 %n, ...) {
; BE-LABEL: test_large_vec_vaarg:
; BE:       # %bb.0:
; BE-NEXT:    std 4, 56(1)
; BE-NEXT:    std 5, 64(1)
; BE-NEXT:    std 6, 72(1)
; BE-NEXT:    std 7, 80(1)
; BE-NEXT:    std 8, 88(1)
; BE-NEXT:    std 9, 96(1)
; BE-NEXT:    std 10, 104(1)
; BE-NEXT:    ld 3, -8(1)
; BE-NEXT:    addi 3, 3, 15
; BE-NEXT:    rldicr 3, 3, 0, 59
; BE-NEXT:    addi 4, 3, 16
; BE-NEXT:    addi 5, 3, 31
; BE-NEXT:    std 4, -8(1)
; BE-NEXT:    rldicr 4, 5, 0, 59
; BE-NEXT:    lvx 2, 0, 3
; BE-NEXT:    addi 3, 4, 16
; BE-NEXT:    std 3, -8(1)
; BE-NEXT:    lvx 3, 0, 4
; BE-NEXT:    blr
;
; LE-LABEL: test_large_vec_vaarg:
; LE:       # %bb.0:
; LE-NEXT:    std 4, 40(1)
; LE-NEXT:    std 5, 48(1)
; LE-NEXT:    std 6, 56(1)
; LE-NEXT:    std 7, 64(1)
; LE-NEXT:    std 8, 72(1)
; LE-NEXT:    std 9, 80(1)
; LE-NEXT:    std 10, 88(1)
; LE-NEXT:    ld 3, -8(1)
; LE-NEXT:    addi 3, 3, 15
; LE-NEXT:    rldicr 3, 3, 0, 59
; LE-NEXT:    addi 4, 3, 31
; LE-NEXT:    addi 5, 3, 16
; LE-NEXT:    rldicr 4, 4, 0, 59
; LE-NEXT:    std 5, -8(1)
; LE-NEXT:    addi 5, 4, 16
; LE-NEXT:    lvx 2, 0, 3
; LE-NEXT:    std 5, -8(1)
; LE-NEXT:    lvx 3, 0, 4
; LE-NEXT:    blr
  %args = alloca i8*, align 4
  %x = va_arg i8** %args, <8 x i32>
  ret <8 x i32> %x
}
