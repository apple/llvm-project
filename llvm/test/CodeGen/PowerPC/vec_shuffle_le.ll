; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64le-unknown-linux-gnu -mattr=+altivec -mattr=-vsx -mcpu=pwr7 | FileCheck %s

define void @VPKUHUM_xy(<16 x i8>* %A, <16 x i8>* %B) {
; CHECK-LABEL: VPKUHUM_xy:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    lvx 3, 0, 4
; CHECK-NEXT:    vpkuhum 2, 3, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = load <16 x i8>, <16 x i8>* %B
        %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp2, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
        store <16 x i8> %tmp3, <16 x i8>* %A
        ret void
}

define void @VPKUHUM_xx(<16 x i8>* %A) {
; CHECK-LABEL: VPKUHUM_xx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    vpkuhum 2, 2, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
        store <16 x i8> %tmp2, <16 x i8>* %A
        ret void
}

define void @VPKUWUM_xy(<16 x i8>* %A, <16 x i8>* %B) {
; CHECK-LABEL: VPKUWUM_xy:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    lvx 3, 0, 4
; CHECK-NEXT:    vpkuwum 2, 3, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = load <16 x i8>, <16 x i8>* %B
        %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp2, <16 x i32> <i32 0, i32 1, i32 4, i32 5, i32 8, i32 9, i32 12, i32 13, i32 16, i32 17, i32 20, i32 21, i32 24, i32 25, i32 28, i32 29>
        store <16 x i8> %tmp3, <16 x i8>* %A
        ret void
}

define void @VPKUWUM_xx(<16 x i8>* %A) {
; CHECK-LABEL: VPKUWUM_xx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    vpkuwum 2, 2, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp, <16 x i32> <i32 0, i32 1, i32 4, i32 5, i32 8, i32 9, i32 12, i32 13, i32 0, i32 1, i32 4, i32 5, i32 8, i32 9, i32 12, i32 13>
        store <16 x i8> %tmp2, <16 x i8>* %A
        ret void
}

define void @VMRGLB_xy(<16 x i8>* %A, <16 x i8>* %B) {
; CHECK-LABEL: VMRGLB_xy:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    lvx 3, 0, 4
; CHECK-NEXT:    vmrglb 2, 3, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = load <16 x i8>, <16 x i8>* %B
        %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp2, <16 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23>
        store <16 x i8> %tmp3, <16 x i8>* %A
        ret void
}

define void @VMRGLB_xx(<16 x i8>* %A) {
; CHECK-LABEL: VMRGLB_xx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    vmrglb 2, 2, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp, <16 x i32> <i32 0, i32 0, i32 1, i32 1, i32 2, i32 2, i32 3, i32 3, i32 4, i32 4, i32 5, i32 5, i32 6, i32 6, i32 7, i32 7>
        store <16 x i8> %tmp2, <16 x i8>* %A
        ret void
}

define void @VMRGHB_xy(<16 x i8>* %A, <16 x i8>* %B) {
; CHECK-LABEL: VMRGHB_xy:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    lvx 3, 0, 4
; CHECK-NEXT:    vmrghb 2, 3, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = load <16 x i8>, <16 x i8>* %B
        %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp2, <16 x i32> <i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>
        store <16 x i8> %tmp3, <16 x i8>* %A
        ret void
}

define void @VMRGHB_xx(<16 x i8>* %A) {
; CHECK-LABEL: VMRGHB_xx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    vmrghb 2, 2, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp, <16 x i32> <i32 8, i32 8, i32 9, i32 9, i32 10, i32 10, i32 11, i32 11, i32 12, i32 12, i32 13, i32 13, i32 14, i32 14, i32 15, i32 15>
        store <16 x i8> %tmp2, <16 x i8>* %A
        ret void
}

define void @VMRGLH_xy(<16 x i8>* %A, <16 x i8>* %B) {
; CHECK-LABEL: VMRGLH_xy:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    lvx 3, 0, 4
; CHECK-NEXT:    vmrglh 2, 3, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = load <16 x i8>, <16 x i8>* %B
        %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp2, <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 2, i32 3, i32 18, i32 19, i32 4, i32 5, i32 20, i32 21, i32 6, i32 7, i32 22, i32 23>
        store <16 x i8> %tmp3, <16 x i8>* %A
        ret void
}

define void @VMRGLH_xx(<16 x i8>* %A) {
; CHECK-LABEL: VMRGLH_xx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    vmrglh 2, 2, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp, <16 x i32> <i32 0, i32 1, i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 4, i32 5, i32 4, i32 5, i32 6, i32 7, i32 6, i32 7>
        store <16 x i8> %tmp2, <16 x i8>* %A
        ret void
}

define void @VMRGHH_xy(<16 x i8>* %A, <16 x i8>* %B) {
; CHECK-LABEL: VMRGHH_xy:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    lvx 3, 0, 4
; CHECK-NEXT:    vmrghh 2, 3, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = load <16 x i8>, <16 x i8>* %B
        %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp2, <16 x i32> <i32 8, i32 9, i32 24, i32 25, i32 10, i32 11, i32 26, i32 27, i32 12, i32 13, i32 28, i32 29, i32 14, i32 15, i32 30, i32 31>
        store <16 x i8> %tmp3, <16 x i8>* %A
        ret void
}

define void @VMRGHH_xx(<16 x i8>* %A) {
; CHECK-LABEL: VMRGHH_xx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    vmrghh 2, 2, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp, <16 x i32> <i32 8, i32 9, i32 8, i32 9, i32 10, i32 11, i32 10, i32 11, i32 12, i32 13, i32 12, i32 13, i32 14, i32 15, i32 14, i32 15>
        store <16 x i8> %tmp2, <16 x i8>* %A
        ret void
}

define void @VMRGLW_xy(<16 x i8>* %A, <16 x i8>* %B) {
; CHECK-LABEL: VMRGLW_xy:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    lvx 3, 0, 4
; CHECK-NEXT:    vmrglw 2, 3, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = load <16 x i8>, <16 x i8>* %B
        %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 4, i32 5, i32 6, i32 7, i32 20, i32 21, i32 22, i32 23>
        store <16 x i8> %tmp3, <16 x i8>* %A
        ret void
}

define void @VMRGLW_xx(<16 x i8>* %A) {
; CHECK-LABEL: VMRGLW_xx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    vmrglw 2, 2, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 4, i32 5, i32 6, i32 7>
        store <16 x i8> %tmp2, <16 x i8>* %A
        ret void
}

define void @VMRGHW_xy(<16 x i8>* %A, <16 x i8>* %B) {
; CHECK-LABEL: VMRGHW_xy:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    lvx 3, 0, 4
; CHECK-NEXT:    vmrghw 2, 3, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = load <16 x i8>, <16 x i8>* %B
        %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp2, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 24, i32 25, i32 26, i32 27, i32 12, i32 13, i32 14, i32 15, i32 28, i32 29, i32 30, i32 31>
        store <16 x i8> %tmp3, <16 x i8>* %A
        ret void
}

define void @VMRGHW_xx(<16 x i8>* %A) {
; CHECK-LABEL: VMRGHW_xx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    vmrghw 2, 2, 2
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 12, i32 13, i32 14, i32 15>
        store <16 x i8> %tmp2, <16 x i8>* %A
        ret void
}

define void @VSLDOI_xy(<16 x i8>* %A, <16 x i8>* %B) {
; CHECK-LABEL: VSLDOI_xy:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    lvx 3, 0, 4
; CHECK-NEXT:    vsldoi 2, 3, 2, 4
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = load <16 x i8>, <16 x i8>* %B
        %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp2, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27>
        store <16 x i8> %tmp3, <16 x i8>* %A
        ret void
}

define void @VSLDOI_xx(<16 x i8>* %A) {
; CHECK-LABEL: VSLDOI_xx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lvx 2, 0, 3
; CHECK-NEXT:    vsldoi 2, 2, 2, 4
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    blr
entry:
        %tmp = load <16 x i8>, <16 x i8>* %A
        %tmp2 = shufflevector <16 x i8> %tmp, <16 x i8> %tmp, <16 x i32> <i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11>
        store <16 x i8> %tmp2, <16 x i8>* %A
        ret void
}

