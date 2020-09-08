; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @max_na_b_minux_na(i32 %A, i32 %B) {
; CHECK-LABEL: @max_na_b_minux_na(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[NOT]], i32 [[B:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = sub i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %not = xor i32 %A, -1
  %l0 = icmp ult i32 %not, %B
  %l1 = select i1 %l0, i32 %not, i32 %B
  %x = sub i32 %l1, %not
  ret i32 %x
}

define i32 @na_minus_max_na_b(i32 %A, i32 %B) {
; CHECK-LABEL: @na_minus_max_na_b(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[NOT]], i32 [[B:%.*]])
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %not = xor i32 %A, -1
  %l0 = icmp ult i32 %not, %B
  %l1 = select i1 %l0, i32 %not, i32 %B
  %x = sub i32 %not, %l1
  ret i32 %x
}

define i32 @max_b_na_minus_na(i32 %A, i32 %B) {
; CHECK-LABEL: @max_b_na_minus_na(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[NOT]], i32 [[B:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = sub i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %not = xor i32 %A, -1
  %l0 = icmp ugt i32 %not, %B
  %l1 = select i1 %l0, i32 %B, i32 %not
  %x = sub i32 %l1, %not
  ret i32 %x
}

define i32 @na_minus_max_b_na(i32 %A, i32 %B) {
; CHECK-LABEL: @na_minus_max_b_na(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[NOT]], i32 [[B:%.*]])
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %not = xor i32 %A, -1
  %l0 = icmp ugt i32 %not, %B
  %l1 = select i1 %l0, i32 %B, i32 %not
  %x = sub i32 %not, %l1
  ret i32 %x
}


define i32 @max_na_bi_minux_na(i32 %A, i32 %Bi) {
; CHECK-LABEL: @max_na_bi_minux_na(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[BI:%.*]], i32 [[A:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = sub i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %B =  xor i32 %Bi, -1
  %not = xor i32 %A, -1
  %l0 = icmp ult i32 %not, %B
  %l1 = select i1 %l0, i32 %not, i32 %B
  %x = sub i32 %l1, %not
  ret i32 %x
}

define i32 @na_minus_max_na_bi(i32 %A, i32 %Bi) {
; CHECK-LABEL: @na_minus_max_na_bi(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[BI:%.*]], i32 [[A:%.*]])
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %B =  xor i32 %Bi, -1
  %not = xor i32 %A, -1
  %l0 = icmp ult i32 %not, %B
  %l1 = select i1 %l0, i32 %not, i32 %B
  %x = sub i32 %not, %l1
  ret i32 %x
}

define i32 @max_bi_na_minus_na(i32 %A, i32 %Bi) {
; CHECK-LABEL: @max_bi_na_minus_na(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[BI:%.*]], i32 [[A:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = sub i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %B =  xor i32 %Bi, -1
  %not = xor i32 %A, -1
  %l0 = icmp ugt i32 %not, %B
  %l1 = select i1 %l0, i32 %B, i32 %not
  %x = sub i32 %l1, %not
  ret i32 %x
}

define i32 @na_minus_max_bi_na(i32 %A, i32 %Bi) {
; CHECK-LABEL: @na_minus_max_bi_na(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[BI:%.*]], i32 [[A:%.*]])
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %B =  xor i32 %Bi, -1
  %not = xor i32 %A, -1
  %l0 = icmp ugt i32 %not, %B
  %l1 = select i1 %l0, i32 %B, i32 %not
  %x = sub i32 %not, %l1
  ret i32 %x
}


define i32 @max_na_bi_minux_na_use(i32 %A, i32 %Bi) {
; CHECK-LABEL: @max_na_bi_minux_na_use(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[A:%.*]], -32
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[A]], i32 -32
; CHECK-NEXT:    [[L1:%.*]] = xor i32 [[TMP2]], -1
; CHECK-NEXT:    [[X:%.*]] = sub i32 [[A]], [[TMP2]]
; CHECK-NEXT:    call void @use32(i32 [[L1]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %not = xor i32 %A, -1
  %l0 = icmp ult i32 %not, 31
  %l1 = select i1 %l0, i32 %not, i32 31
  %x = sub i32 %l1, %not
  call void @use32(i32 %l1)
  ret i32 %x
}

define i32 @na_minus_max_na_bi_use(i32 %A, i32 %Bi) {
; CHECK-LABEL: @na_minus_max_na_bi_use(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[A:%.*]], -32
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[A]], i32 -32
; CHECK-NEXT:    [[L1:%.*]] = xor i32 [[TMP2]], -1
; CHECK-NEXT:    [[X:%.*]] = sub i32 [[TMP2]], [[A]]
; CHECK-NEXT:    call void @use32(i32 [[L1]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %not = xor i32 %A, -1
  %l0 = icmp ult i32 %not, 31
  %l1 = select i1 %l0, i32 %not, i32 31
  %x = sub i32 %not, %l1
  call void @use32(i32 %l1)
  ret i32 %x
}

define i32 @max_bi_na_minus_na_use(i32 %A, i32 %Bi) {
; CHECK-LABEL: @max_bi_na_minus_na_use(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[BI:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[BI]], i32 [[A]]
; CHECK-NEXT:    [[L1:%.*]] = xor i32 [[TMP2]], -1
; CHECK-NEXT:    [[X:%.*]] = sub i32 [[A]], [[TMP2]]
; CHECK-NEXT:    call void @use32(i32 [[L1]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %not = xor i32 %A, -1
  %B = xor i32 %Bi, -1
  %l0 = icmp ult i32 %B, %not
  %l1 = select i1 %l0, i32 %B, i32 %not
  %x = sub i32 %l1, %not
  call void @use32(i32 %l1)
  ret i32 %x
}

define i32 @na_minus_max_bi_na_use(i32 %A, i32 %Bi) {
; CHECK-LABEL: @na_minus_max_bi_na_use(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[BI:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[BI]], i32 [[A]]
; CHECK-NEXT:    [[L1:%.*]] = xor i32 [[TMP2]], -1
; CHECK-NEXT:    [[X:%.*]] = sub i32 [[TMP2]], [[A]]
; CHECK-NEXT:    call void @use32(i32 [[L1]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %not = xor i32 %A, -1
  %B = xor i32 %Bi, -1
  %l0 = icmp ult i32 %B, %not
  %l1 = select i1 %l0, i32 %B, i32 %not
  %x = sub i32 %not, %l1
  call void @use32(i32 %l1)
  ret i32 %x
}


define i32 @max_na_bi_minux_na_use2(i32 %A, i32 %Bi) {
; CHECK-LABEL: @max_na_bi_minux_na_use2(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[L0:%.*]] = icmp ult i32 [[NOT]], 31
; CHECK-NEXT:    [[L1:%.*]] = select i1 [[L0]], i32 [[NOT]], i32 31
; CHECK-NEXT:    [[X:%.*]] = sub i32 [[L1]], [[NOT]]
; CHECK-NEXT:    call void @use32(i32 [[L1]])
; CHECK-NEXT:    call void @use32(i32 [[NOT]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %not = xor i32 %A, -1
  %l0 = icmp ult i32 %not, 31
  %l1 = select i1 %l0, i32 %not, i32 31
  %x = sub i32 %l1, %not
  call void @use32(i32 %l1)
  call void @use32(i32 %not)
  ret i32 %x
}

define i32 @na_minus_max_na_bi_use2(i32 %A, i32 %Bi) {
; CHECK-LABEL: @na_minus_max_na_bi_use2(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[L0:%.*]] = icmp ult i32 [[NOT]], 31
; CHECK-NEXT:    [[L1:%.*]] = select i1 [[L0]], i32 [[NOT]], i32 31
; CHECK-NEXT:    [[X:%.*]] = sub i32 [[NOT]], [[L1]]
; CHECK-NEXT:    call void @use32(i32 [[L1]])
; CHECK-NEXT:    call void @use32(i32 [[NOT]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %not = xor i32 %A, -1
  %l0 = icmp ult i32 %not, 31
  %l1 = select i1 %l0, i32 %not, i32 31
  %x = sub i32 %not, %l1
  call void @use32(i32 %l1)
  call void @use32(i32 %not)
  ret i32 %x
}

define i32 @max_bi_na_minus_na_use2(i32 %A, i32 %Bi) {
; CHECK-LABEL: @max_bi_na_minus_na_use2(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[BI:%.*]], [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[BI]], i32 [[A]]
; CHECK-NEXT:    [[L1:%.*]] = xor i32 [[TMP2]], -1
; CHECK-NEXT:    [[X:%.*]] = sub i32 [[A]], [[TMP2]]
; CHECK-NEXT:    call void @use32(i32 [[L1]])
; CHECK-NEXT:    call void @use32(i32 [[NOT]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %not = xor i32 %A, -1
  %B = xor i32 %Bi, -1
  %l0 = icmp ult i32 %B, %not
  %l1 = select i1 %l0, i32 %B, i32 %not
  %x = sub i32 %l1, %not
  call void @use32(i32 %l1)
  call void @use32(i32 %not)
  ret i32 %x
}

define i32 @na_minus_max_bi_na_use2(i32 %A, i32 %Bi) {
; CHECK-LABEL: @na_minus_max_bi_na_use2(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[BI:%.*]], [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[BI]], i32 [[A]]
; CHECK-NEXT:    [[L1:%.*]] = xor i32 [[TMP2]], -1
; CHECK-NEXT:    [[X:%.*]] = sub i32 [[TMP2]], [[A]]
; CHECK-NEXT:    call void @use32(i32 [[L1]])
; CHECK-NEXT:    call void @use32(i32 [[NOT]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %not = xor i32 %A, -1
  %B = xor i32 %Bi, -1
  %l0 = icmp ult i32 %B, %not
  %l1 = select i1 %l0, i32 %B, i32 %not
  %x = sub i32 %not, %l1
  call void @use32(i32 %l1)
  call void @use32(i32 %not)
  ret i32 %x
}

define i8 @umin_not_sub(i8 %x, i8 %y) {
; CHECK-LABEL: @umin_not_sub(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i8 [[X]], i8 [[Y]]
; CHECK-NEXT:    [[MINXY:%.*]] = xor i8 [[TMP2]], -1
; CHECK-NEXT:    [[SUBX:%.*]] = sub i8 [[TMP2]], [[X]]
; CHECK-NEXT:    [[SUBY:%.*]] = sub i8 [[TMP2]], [[Y]]
; CHECK-NEXT:    call void @use8(i8 [[SUBX]])
; CHECK-NEXT:    call void @use8(i8 [[SUBY]])
; CHECK-NEXT:    ret i8 [[MINXY]]
;
  %nx = xor i8 %x, -1
  %ny = xor i8 %y, -1
  %cmpxy = icmp ult i8 %nx, %ny
  %minxy = select i1 %cmpxy, i8 %nx, i8 %ny
  %subx = sub i8 %nx, %minxy
  %suby = sub i8 %ny, %minxy
  call void @use8(i8 %subx)
  call void @use8(i8 %suby)
  ret i8 %minxy
}

define i8 @umin_not_sub_rev(i8 %x, i8 %y) {
; CHECK-LABEL: @umin_not_sub_rev(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i8 [[X]], i8 [[Y]]
; CHECK-NEXT:    [[MINXY:%.*]] = xor i8 [[TMP2]], -1
; CHECK-NEXT:    [[SUBX:%.*]] = sub i8 [[X]], [[TMP2]]
; CHECK-NEXT:    [[SUBY:%.*]] = sub i8 [[Y]], [[TMP2]]
; CHECK-NEXT:    call void @use8(i8 [[SUBX]])
; CHECK-NEXT:    call void @use8(i8 [[SUBY]])
; CHECK-NEXT:    ret i8 [[MINXY]]
;
  %nx = xor i8 %x, -1
  %ny = xor i8 %y, -1
  %cmpxy = icmp ult i8 %nx, %ny
  %minxy = select i1 %cmpxy, i8 %nx, i8 %ny
  %subx = sub i8 %minxy, %nx
  %suby = sub i8 %minxy, %ny
  call void @use8(i8 %subx)
  call void @use8(i8 %suby)
  ret i8 %minxy
}

define void @umin3_not_all_ops_extra_uses_invert_subs(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @umin3_not_all_ops_extra_uses_invert_subs(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i8 [[X]], i8 [[Z]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ugt i8 [[TMP2]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP3]], i8 [[TMP2]], i8 [[Y]]
; CHECK-NEXT:    [[TMP5:%.*]] = xor i8 [[TMP4]], -1
; CHECK-NEXT:    [[XMIN:%.*]] = sub i8 [[TMP4]], [[X]]
; CHECK-NEXT:    [[YMIN:%.*]] = sub i8 [[TMP4]], [[Y]]
; CHECK-NEXT:    [[ZMIN:%.*]] = sub i8 [[TMP4]], [[Z]]
; CHECK-NEXT:    call void @use8(i8 [[TMP5]])
; CHECK-NEXT:    call void @use8(i8 [[XMIN]])
; CHECK-NEXT:    call void @use8(i8 [[YMIN]])
; CHECK-NEXT:    call void @use8(i8 [[ZMIN]])
; CHECK-NEXT:    ret void
;
  %xn = xor i8 %x, -1
  %yn = xor i8 %y, -1
  %zn = xor i8 %z, -1
  %cmpxz = icmp ult i8 %xn, %zn
  %minxz = select i1 %cmpxz, i8 %xn, i8 %zn
  %cmpxyz = icmp ult i8 %minxz, %yn
  %minxyz = select i1 %cmpxyz, i8 %minxz, i8 %yn
  %xmin = sub i8 %xn, %minxyz
  %ymin = sub i8 %yn, %minxyz
  %zmin = sub i8 %zn, %minxyz
  call void @use8(i8 %minxyz)
  call void @use8(i8 %xmin)
  call void @use8(i8 %ymin)
  call void @use8(i8 %zmin)
  ret void
}

declare void @use8(i8)
declare void @use32(i32 %u)
