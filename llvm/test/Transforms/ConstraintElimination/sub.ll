; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -constraint-elimination -S %s | FileCheck %s

define void @test.not.uge.ult(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.ult(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB_PTR_I:%.*]] = sub i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[SUB_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[T_0:%.*]] = icmp ult i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_0]])
; CHECK-NEXT:    [[START_1:%.*]] = sub i8 [[START]], 1
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[START_2:%.*]] = sub i8 [[START]], 2
; CHECK-NEXT:    [[T_2:%.*]] = icmp ult i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    [[START_3:%.*]] = sub i8 [[START]], 3
; CHECK-NEXT:    [[T_3:%.*]] = icmp ult i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_3]])
; CHECK-NEXT:    [[START_4:%.*]] = sub i8 [[START]], 4
; CHECK-NEXT:    [[C_4:%.*]] = icmp ult i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
;
entry:
  %sub.ptr.i = sub i8 %start, 3
  %c.1 = icmp uge i8 %sub.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %t.0 = icmp ult i8 %start, %high
  call void @use(i1 %t.0)
  %start.1 = sub i8 %start, 1
  %t.1 = icmp ult i8 %start.1, %high
  call void @use(i1 %t.1)
  %start.2 = sub i8 %start, 2
  %t.2 = icmp ult i8 %start.2, %high
  call void @use(i1 %t.2)
  %start.3 = sub i8 %start, 3
  %t.3 = icmp ult i8 %start.3, %high
  call void @use(i1 %t.3)
  %start.4 = sub i8 %start, 4
  %c.4 = icmp ult i8 %start.4, %high
  call void @use(i1 %c.4)
  ret void
}

define void @test.not.uge.ule(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.ule(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB_PTR_I:%.*]] = sub i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[SUB_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[T_0:%.*]] = icmp ule i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_0]])
; CHECK-NEXT:    [[START_1:%.*]] = sub i8 [[START]], 1
; CHECK-NEXT:    [[T_1:%.*]] = icmp ule i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[START_2:%.*]] = sub i8 [[START]], 2
; CHECK-NEXT:    [[T_2:%.*]] = icmp ule i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    [[START_3:%.*]] = sub i8 [[START]], 3
; CHECK-NEXT:    [[T_3:%.*]] = icmp ule i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_3]])
; CHECK-NEXT:    [[START_4:%.*]] = sub i8 [[START]], 4
; CHECK-NEXT:    [[T_4:%.*]] = icmp ule i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[T_4]])
; CHECK-NEXT:    [[START_5:%.*]] = sub i8 [[START]], 5
; CHECK-NEXT:    [[C_5:%.*]] = icmp ule i8 [[START_5]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
entry:
  %sub.ptr.i = sub i8 %start, 3
  %c.1 = icmp uge i8 %sub.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %t.0 = icmp ule i8 %start, %high
  call void @use(i1 %t.0)
  %start.1 = sub i8 %start, 1
  %t.1 = icmp ule i8 %start.1, %high
  call void @use(i1 %t.1)
  %start.2 = sub i8 %start, 2
  %t.2 = icmp ule i8 %start.2, %high
  call void @use(i1 %t.2)
  %start.3 = sub i8 %start, 3
  %t.3 = icmp ule i8 %start.3, %high
  call void @use(i1 %t.3)
  %start.4 = sub i8 %start, 4
  %t.4 = icmp ule i8 %start.4, %high
  call void @use(i1 %t.4)

  %start.5 = sub i8 %start, 5
  %c.5 = icmp ule i8 %start.5, %high
  call void @use(i1 %c.5)

  ret void
}

define void @test.not.uge.ugt(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.ugt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB_PTR_I:%.*]] = sub i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[SUB_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[F_0:%.*]] = icmp ugt i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_0]])
; CHECK-NEXT:    [[START_1:%.*]] = sub i8 [[START]], 1
; CHECK-NEXT:    [[F_1:%.*]] = icmp ugt i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_1]])
; CHECK-NEXT:    [[START_2:%.*]] = sub i8 [[START]], 2
; CHECK-NEXT:    [[F_2:%.*]] = icmp ugt i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_2]])
; CHECK-NEXT:    [[START_3:%.*]] = sub i8 [[START]], 3
; CHECK-NEXT:    [[F_3:%.*]] = icmp ugt i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_3]])
; CHECK-NEXT:    [[START_4:%.*]] = sub i8 [[START]], 4
; CHECK-NEXT:    [[F_4:%.*]] = icmp ugt i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_4]])
; CHECK-NEXT:    [[START_5:%.*]] = sub i8 [[START]], 5
; CHECK-NEXT:    [[C_5:%.*]] = icmp ugt i8 [[START_5]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
entry:
  %sub.ptr.i = sub i8 %start, 3
  %c.1 = icmp uge i8 %sub.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %f.0 = icmp ugt i8 %start, %high
  call void @use(i1 %f.0)

  %start.1 = sub i8 %start, 1
  %f.1 = icmp ugt i8 %start.1, %high
  call void @use(i1 %f.1)

  %start.2 = sub i8 %start, 2
  %f.2 = icmp ugt i8 %start.2, %high
  call void @use(i1 %f.2)

  %start.3 = sub i8 %start, 3
  %f.3 = icmp ugt i8 %start.3, %high
  call void @use(i1 %f.3)

  %start.4 = sub i8 %start, 4
  %f.4 = icmp ugt i8 %start.4, %high
  call void @use(i1 %f.4)

  %start.5 = sub i8 %start, 5
  %c.5 = icmp ugt i8 %start.5, %high
  call void @use(i1 %c.5)

  ret void
}

define void @test.not.uge.uge(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.uge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB_PTR_I:%.*]] = sub i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[SUB_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[F_0:%.*]] = icmp ugt i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_0]])
; CHECK-NEXT:    [[START_1:%.*]] = sub i8 [[START]], 1
; CHECK-NEXT:    [[F_1:%.*]] = icmp uge i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_1]])
; CHECK-NEXT:    [[START_2:%.*]] = sub i8 [[START]], 2
; CHECK-NEXT:    [[F_2:%.*]] = icmp uge i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_2]])
; CHECK-NEXT:    [[START_3:%.*]] = sub i8 [[START]], 3
; CHECK-NEXT:    [[F_3:%.*]] = icmp uge i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[F_3]])
; CHECK-NEXT:    [[START_4:%.*]] = sub i8 [[START]], 4
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[START_5:%.*]] = sub i8 [[START]], 5
; CHECK-NEXT:    [[C_5:%.*]] = icmp uge i8 [[START_5]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
entry:
  %sub.ptr.i = sub i8 %start, 3
  %c.1 = icmp uge i8 %sub.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %f.0 = icmp ugt i8 %start, %high
  call void @use(i1 %f.0)

  %start.1 = sub i8 %start, 1
  %f.1 = icmp uge i8 %start.1, %high
  call void @use(i1 %f.1)

  %start.2 = sub i8 %start, 2
  %f.2 = icmp uge i8 %start.2, %high
  call void @use(i1 %f.2)

  %start.3 = sub i8 %start, 3
  %f.3 = icmp uge i8 %start.3, %high
  call void @use(i1 %f.3)

  %start.4 = sub i8 %start, 4
  %c.4 = icmp uge i8 %start.4, %high
  call void @use(i1 %c.4)

  %start.5 = sub i8 %start, 5
  %c.5 = icmp uge i8 %start.5, %high
  call void @use(i1 %c.5)

  ret void
}


declare void @use(i1)
declare void @llvm.trap()
