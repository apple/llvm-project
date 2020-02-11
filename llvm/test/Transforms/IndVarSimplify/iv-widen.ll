; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -indvars -S | FileCheck %s
; RUN: opt < %s -S -passes='lcssa,loop-simplify,require<targetir>,require<scalar-evolution>,require<domtree>,loop(indvars)' | FileCheck %s

; Provide legal integer types.
target datalayout = "n8:16:32:64"


target triple = "x86_64-apple-darwin"

declare void @use(i64 %x)

; Only one phi now.
; One trunc for the gep.
; One trunc for the dummy() call.
define void @loop_0(i32* %a) {
; CHECK-LABEL: @loop_0(
; CHECK-NEXT:  Prologue:
; CHECK-NEXT:    br i1 undef, label [[B18_PREHEADER:%.*]], label [[B6:%.*]]
; CHECK:       B18.preheader:
; CHECK-NEXT:    br label [[B18:%.*]]
; CHECK:       B18:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[B18_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[B24:%.*]] ]
; CHECK-NEXT:    call void @use(i64 [[INDVARS_IV]])
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[O:%.*]] = getelementptr i32, i32* [[A:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[O]]
; CHECK-NEXT:    [[T:%.*]] = icmp eq i32 [[V]], 0
; CHECK-NEXT:    br i1 [[T]], label [[EXIT24:%.*]], label [[B24]]
; CHECK:       B24:
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 20
; CHECK-NEXT:    br i1 [[T2]], label [[B6_LOOPEXIT:%.*]], label [[B18]]
; CHECK:       B6.loopexit:
; CHECK-NEXT:    br label [[B6]]
; CHECK:       B6:
; CHECK-NEXT:    ret void
; CHECK:       exit24:
; CHECK-NEXT:    [[DOT02_LCSSA_WIDE:%.*]] = phi i64 [ [[INDVARS_IV]], [[B18]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[DOT02_LCSSA_WIDE]] to i32
; CHECK-NEXT:    call void @dummy(i32 [[TMP1]])
; CHECK-NEXT:    unreachable
;
Prologue:
  br i1 undef, label %B18, label %B6

B18:                                        ; preds = %B24, %Prologue
  %.02 = phi i32 [ 0, %Prologue ], [ %tmp33, %B24 ]
  %tmp23 = zext i32 %.02 to i64
  call void @use(i64 %tmp23)
  %tmp33 = add i32 %.02, 1
  %o = getelementptr i32, i32* %a, i32 %.02
  %v = load i32, i32* %o
  %t = icmp eq i32 %v, 0
  br i1 %t, label %exit24, label %B24

B24:                                        ; preds = %B18
  %t2 = icmp eq i32 %tmp33, 20
  br i1 %t2, label %B6, label %B18

B6:                                       ; preds = %Prologue
  ret void

exit24:                      ; preds = %B18
  call void @dummy(i32 %.02)
  unreachable
}

; Make sure that dead zext is removed and no widening happens.
define void @loop_0_dead(i32* %a) {
; CHECK-LABEL: @loop_0_dead(
; CHECK-NEXT:  Prologue:
; CHECK-NEXT:    br i1 undef, label [[B18_PREHEADER:%.*]], label [[B6:%.*]]
; CHECK:       B18.preheader:
; CHECK-NEXT:    br label [[B18:%.*]]
; CHECK:       B18:
; CHECK-NEXT:    [[DOT02:%.*]] = phi i32 [ [[TMP33:%.*]], [[B24:%.*]] ], [ 0, [[B18_PREHEADER]] ]
; CHECK-NEXT:    [[TMP33]] = add nuw i32 [[DOT02]], 1
; CHECK-NEXT:    [[O:%.*]] = getelementptr i32, i32* [[A:%.*]], i32 [[DOT02]]
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[O]]
; CHECK-NEXT:    [[T:%.*]] = icmp eq i32 [[V]], 0
; CHECK-NEXT:    br i1 [[T]], label [[EXIT24:%.*]], label [[B24]]
; CHECK:       B24:
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[TMP33]], 20
; CHECK-NEXT:    br i1 [[T2]], label [[B6_LOOPEXIT:%.*]], label [[B18]]
; CHECK:       B6.loopexit:
; CHECK-NEXT:    br label [[B6]]
; CHECK:       B6:
; CHECK-NEXT:    ret void
; CHECK:       exit24:
; CHECK-NEXT:    [[DOT02_LCSSA:%.*]] = phi i32 [ [[DOT02]], [[B18]] ]
; CHECK-NEXT:    call void @dummy(i32 [[DOT02_LCSSA]])
; CHECK-NEXT:    unreachable
;
Prologue:
  br i1 undef, label %B18, label %B6

B18:                                        ; preds = %B24, %Prologue
  %.02 = phi i32 [ 0, %Prologue ], [ %tmp33, %B24 ]
  %tmp23 = zext i32 %.02 to i64
  %tmp33 = add i32 %.02, 1
  %o = getelementptr i32, i32* %a, i32 %.02
  %v = load i32, i32* %o
  %t = icmp eq i32 %v, 0
  br i1 %t, label %exit24, label %B24

B24:                                        ; preds = %B18
  %t2 = icmp eq i32 %tmp33, 20
  br i1 %t2, label %B6, label %B18

B6:                                       ; preds = %Prologue
  ret void

exit24:                      ; preds = %B18
  call void @dummy(i32 %.02)
  unreachable
}

define void @loop_1(i32 %lim) {
; CHECK-LABEL: @loop_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ENTRY_COND:%.*]] = icmp ne i32 [[LIM:%.*]], 0
; CHECK-NEXT:    br i1 [[ENTRY_COND]], label [[LOOP_PREHEADER:%.*]], label [[LEAVE:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[LIM]] to i64
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 1, [[LOOP_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw i64 [[INDVARS_IV]], -1
; CHECK-NEXT:    call void @dummy.i64(i64 [[TMP1]])
; CHECK-NEXT:    [[BE_COND:%.*]] = icmp ult i64 [[INDVARS_IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[BE_COND]], label [[LOOP]], label [[LEAVE_LOOPEXIT:%.*]]
; CHECK:       leave.loopexit:
; CHECK-NEXT:    br label [[LEAVE]]
; CHECK:       leave:
; CHECK-NEXT:    ret void
;
  entry:
  %entry.cond = icmp ne i32 %lim, 0
  br i1 %entry.cond, label %loop, label %leave

  loop:

  %iv = phi i32 [ 1, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add i32 %iv, 1
  %iv.inc.sub = add i32 %iv, -1
  %iv.inc.sub.zext = zext i32 %iv.inc.sub to i64
  call void @dummy.i64(i64 %iv.inc.sub.zext)
  %be.cond = icmp ult i32 %iv.inc, %lim
  br i1 %be.cond, label %loop, label %leave

  leave:
  ret void
}

declare void @dummy(i32)
declare void @dummy.i64(i64)


define void @loop_2(i32 %size, i32 %nsteps, i32 %hsize, i32* %lined, i8 %tmp1) {
; CHECK-LABEL: @loop_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP215:%.*]] = icmp sgt i32 [[SIZE:%.*]], 1
; CHECK-NEXT:    [[BC0:%.*]] = bitcast i32* [[LINED:%.*]] to i8*
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[SIZE]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[HSIZE:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = sext i32 [[NSTEPS:%.*]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV7:%.*]] = phi i64 [ [[INDVARS_IV_NEXT8:%.*]], [[FOR_INC:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = mul nsw i64 [[INDVARS_IV7]], [[TMP0]]
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw i64 [[TMP3]], [[TMP1]]
; CHECK-NEXT:    br i1 [[CMP215]], label [[FOR_BODY2_PREHEADER:%.*]], label [[FOR_INC]]
; CHECK:       for.body2.preheader:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[SIZE]] to i64
; CHECK-NEXT:    br label [[FOR_BODY2:%.*]]
; CHECK:       for.body2:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 1, [[FOR_BODY2_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY2]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw i64 [[TMP4]], [[INDVARS_IV]]
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i8, i8* [[BC0]], i64 [[TMP5]]
; CHECK-NEXT:    store i8 [[TMP1:%.*]], i8* [[ADD_PTR]], align 1
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY2]], label [[FOR_BODY3_PREHEADER:%.*]]
; CHECK:       for.body3.preheader:
; CHECK-NEXT:    [[TMP6:%.*]] = trunc i64 [[TMP4]] to i32
; CHECK-NEXT:    [[TMP7:%.*]] = zext i32 [[TMP6]] to i64
; CHECK-NEXT:    [[WIDE_TRIP_COUNT5:%.*]] = zext i32 [[SIZE]] to i64
; CHECK-NEXT:    br label [[FOR_BODY3:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    [[INDVARS_IV2:%.*]] = phi i64 [ 1, [[FOR_BODY3_PREHEADER]] ], [ [[INDVARS_IV_NEXT3:%.*]], [[FOR_BODY3]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = add nuw nsw i64 [[TMP7]], [[INDVARS_IV2]]
; CHECK-NEXT:    [[ADD_PTR2:%.*]] = getelementptr inbounds i8, i8* [[BC0]], i64 [[TMP8]]
; CHECK-NEXT:    store i8 [[TMP1]], i8* [[ADD_PTR2]], align 1
; CHECK-NEXT:    [[INDVARS_IV_NEXT3]] = add nuw nsw i64 [[INDVARS_IV2]], 1
; CHECK-NEXT:    [[EXITCOND6:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT3]], [[WIDE_TRIP_COUNT5]]
; CHECK-NEXT:    br i1 [[EXITCOND6]], label [[FOR_BODY3]], label [[FOR_INC_LOOPEXIT:%.*]]
; CHECK:       for.inc.loopexit:
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INDVARS_IV_NEXT8]] = add nuw nsw i64 [[INDVARS_IV7]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[INDVARS_IV_NEXT8]], [[TMP2]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp215 = icmp sgt i32 %size, 1
  %bc0 = bitcast i32* %lined to i8*
  br label %for.body

for.body:
  %j = phi i32 [ 0, %entry ], [ %inc6, %for.inc ]
  %mul = mul nsw i32 %j, %size
  %add = add nsw i32 %mul, %hsize
  br i1 %cmp215, label %for.body2, label %for.inc

; check that the induction variable of the inner loop has been widened after indvars.
for.body2:
  %k = phi i32 [ %inc, %for.body2 ], [ 1, %for.body ]
  %add4 = add nsw i32 %add, %k
  %idx.ext = sext i32 %add4 to i64
  %add.ptr = getelementptr inbounds i8, i8* %bc0, i64 %idx.ext
  store i8 %tmp1, i8* %add.ptr, align 1
  %inc = add nsw i32 %k, 1
  %cmp2 = icmp slt i32 %inc, %size
  br i1 %cmp2, label %for.body2, label %for.body3

; check that the induction variable of the inner loop has been widened after indvars.
for.body3:
  %l = phi i32 [ %inc2, %for.body3 ], [ 1, %for.body2 ]
  %add5 = add nuw i32 %add, %l
  %idx.ext2 = zext i32 %add5 to i64
  %add.ptr2 = getelementptr inbounds i8, i8* %bc0, i64 %idx.ext2
  store i8 %tmp1, i8* %add.ptr2, align 1
  %inc2 = add nsw i32 %l, 1
  %cmp3 = icmp slt i32 %inc2, %size
  br i1 %cmp3, label %for.body3, label %for.inc

for.inc:
  %inc6 = add nsw i32 %j, 1
  %cmp = icmp slt i32 %inc6, %nsteps
  br i1 %cmp, label %for.body, label %for.end.loopexit

for.end.loopexit:
  ret void
}
