; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -indvars -S | FileCheck %s
target triple = "aarch64--linux-gnu"

; Provide legal integer types.
target datalayout = "n8:16:32:64"


; Check the loop exit i32 compare instruction and operand are widened to i64
; instead of truncating IV before its use in the i32 compare instruction.

@idx = common global i32 0, align 4
@e = common global i32 0, align 4
@ptr = common global i32* null, align 8


define i32 @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 -1, i32* @idx, align 4
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @e, align 4
; CHECK-NEXT:    [[CMP4:%.*]] = icmp slt i32 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[CMP4]], label [[FOR_END_LOOPEXIT:%.*]], label [[FOR_BODY_LR_PH:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    [[TMP1:%.*]] = load i32*, i32** @ptr, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* @e, align 4
; CHECK-NEXT:    [[TMP3:%.*]] = icmp sgt i32 [[TMP2]], 0
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP3]], i32 [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = add nuw i32 [[SMAX]], 1
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[TMP4]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nuw nsw i64 [[INDVARS_IV:%.*]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_COND_FOR_END_LOOPEXIT_CRIT_EDGE:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV]] = phi i64 [ [[INDVARS_IV_NEXT]], [[FOR_COND:%.*]] ], [ 0, [[FOR_BODY_LR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TMP5]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[IF_THEN:%.*]], label [[FOR_COND]]
; CHECK:       if.then:
; CHECK-NEXT:    [[I_05_LCSSA_WIDE:%.*]] = phi i64 [ [[INDVARS_IV]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP6:%.*]] = trunc i64 [[I_05_LCSSA_WIDE]] to i32
; CHECK-NEXT:    store i32 [[TMP6]], i32* @idx, align 4
; CHECK-NEXT:    br label [[FOR_END:%.*]]
; CHECK:       for.cond.for.end.loopexit_crit_edge:
; CHECK-NEXT:    br label [[FOR_END_LOOPEXIT]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, i32* @idx, align 4
; CHECK-NEXT:    ret i32 [[TMP7]]
;
entry:
  store i32 -1, i32* @idx, align 4
  %0 = load i32, i32* @e, align 4
  %cmp4 = icmp slt i32 %0, 0
  br i1 %cmp4, label %for.end.loopexit, label %for.body.lr.ph

for.body.lr.ph:
  %1 = load i32*, i32** @ptr, align 8
  %2 = load i32, i32* @e, align 4
  br label %for.body

for.cond:
  %inc = add nsw i32 %i.05, 1
  %cmp = icmp slt i32 %i.05, %2
  br i1 %cmp, label %for.body, label %for.cond.for.end.loopexit_crit_edge

for.body:
  %i.05 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.cond ]
  %idxprom = sext i32 %i.05 to i64
  %arrayidx = getelementptr inbounds i32, i32* %1, i64 %idxprom
  %3 = load i32, i32* %arrayidx, align 4
  %tobool = icmp eq i32 %3, 0
  br i1 %tobool, label %if.then, label %for.cond

if.then:
  %i.05.lcssa = phi i32 [ %i.05, %for.body ]
  store i32 %i.05.lcssa, i32* @idx, align 4
  br label %for.end

for.cond.for.end.loopexit_crit_edge:
  br label %for.end.loopexit

for.end.loopexit:
  br label %for.end

for.end:
  %4 = load i32, i32* @idx, align 4
  ret i32 %4
}


define void @test2([8 x i8]* %a, i8* %b, i8 %limit) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = zext i8 [[LIMIT:%.*]] to i32
; CHECK-NEXT:    br i1 undef, label [[FOR_COND1_PREHEADER_PREHEADER:%.*]], label [[FOR_COND1_PREHEADER_US_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader.us.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i32 [[CONV]], 1
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP0]], i32 [[CONV]], i32 1
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER_US:%.*]]
; CHECK:       for.cond1.preheader.preheader:
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader.us:
; CHECK-NEXT:    [[INDVARS_IV2:%.*]] = phi i64 [ 0, [[FOR_COND1_PREHEADER_US_PREHEADER]] ], [ [[INDVARS_IV_NEXT3:%.*]], [[FOR_INC13_US:%.*]] ]
; CHECK-NEXT:    br i1 true, label [[FOR_BODY4_LR_PH_US:%.*]], label [[FOR_INC13_US]]
; CHECK:       for.inc13.us.loopexit:
; CHECK-NEXT:    br label [[FOR_INC13_US]]
; CHECK:       for.inc13.us:
; CHECK-NEXT:    [[INDVARS_IV_NEXT3]] = add nuw nsw i64 [[INDVARS_IV2]], 1
; CHECK-NEXT:    [[EXITCOND4:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT3]], 4
; CHECK-NEXT:    br i1 [[EXITCOND4]], label [[FOR_COND1_PREHEADER_US]], label [[FOR_END_LOOPEXIT1:%.*]]
; CHECK:       for.body4.us:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[FOR_BODY4_LR_PH_US]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY4_US:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX6_US:%.*]] = getelementptr inbounds [8 x i8], [8 x i8]* [[A:%.*]], i64 [[INDVARS_IV2]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, i8* [[ARRAYIDX6_US]], align 1
; CHECK-NEXT:    [[IDXPROM7_US:%.*]] = zext i8 [[TMP1]] to i64
; CHECK-NEXT:    [[ARRAYIDX8_US:%.*]] = getelementptr inbounds i8, i8* [[B:%.*]], i64 [[IDXPROM7_US]]
; CHECK-NEXT:    [[TMP2:%.*]] = load i8, i8* [[ARRAYIDX8_US]], align 1
; CHECK-NEXT:    store i8 [[TMP2]], i8* [[ARRAYIDX6_US]], align 1
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT:%.*]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY4_US]], label [[FOR_INC13_US_LOOPEXIT:%.*]]
; CHECK:       for.body4.lr.ph.us:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT]] = zext i32 [[SMAX]] to i64
; CHECK-NEXT:    br label [[FOR_BODY4_US]]
; CHECK:       for.cond1.preheader:
; CHECK-NEXT:    br i1 false, label [[FOR_INC13:%.*]], label [[FOR_INC13]]
; CHECK:       for.inc13:
; CHECK-NEXT:    br i1 false, label [[FOR_COND1_PREHEADER]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END:%.*]]
; CHECK:       for.end.loopexit1:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %conv = zext i8 %limit to i32
  br i1 undef, label %for.cond1.preheader, label %for.cond1.preheader.us

for.cond1.preheader.us:
  %storemerge5.us = phi i32 [ 0, %entry ], [ %inc14.us, %for.inc13.us ]
  br i1 true, label %for.body4.lr.ph.us, label %for.inc13.us

for.inc13.us:
  %inc14.us = add nsw i32 %storemerge5.us, 1
  %cmp.us = icmp slt i32 %inc14.us, 4
  br i1 %cmp.us, label %for.cond1.preheader.us, label %for.end

for.body4.us:
  %storemerge14.us = phi i32 [ 0, %for.body4.lr.ph.us ], [ %inc.us, %for.body4.us ]
  %idxprom.us = sext i32 %storemerge14.us to i64
  %arrayidx6.us = getelementptr inbounds [8 x i8], [8 x i8]* %a, i64 %idxprom5.us, i64 %idxprom.us
  %0 = load i8, i8* %arrayidx6.us, align 1
  %idxprom7.us = zext i8 %0 to i64
  %arrayidx8.us = getelementptr inbounds i8, i8* %b, i64 %idxprom7.us
  %1 = load i8, i8* %arrayidx8.us, align 1
  store i8 %1, i8* %arrayidx6.us, align 1
  %inc.us = add nsw i32 %storemerge14.us, 1
  %cmp2.us = icmp slt i32 %inc.us, %conv
  br i1 %cmp2.us, label %for.body4.us, label %for.inc13.us

for.body4.lr.ph.us:
  %idxprom5.us = sext i32 %storemerge5.us to i64
  br label %for.body4.us

for.cond1.preheader:
  %storemerge5 = phi i32 [ 0, %entry ], [ %inc14, %for.inc13 ]
  br i1 false, label %for.inc13, label %for.inc13

for.inc13:
  %inc14 = add nsw i32 %storemerge5, 1
  %cmp = icmp slt i32 %inc14, 4
  br i1 %cmp, label %for.cond1.preheader, label %for.end

for.end:
  ret void
}


define i32 @test3(i32* %a, i32 %b) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i32 [[B:%.*]], 0
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP0]], i32 [[B]], i32 0
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[SMAX]] to i64
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUM_0:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[SUM_0]], [[TMP1]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ [[SUM_0]], [[FOR_COND]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
;
entry:
  br label %for.cond

for.cond:
  %sum.0 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp slt i32 %i.0, %b
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %sum.0, %0
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:
  ret i32 %sum.0
}

declare i32 @fn1(i8 signext)

; PR21030

define i32 @test4(i32 %a) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i32 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ 253, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[A:%.*]], [[INDVARS_IV]]
; CHECK-NEXT:    [[CONV3:%.*]] = trunc i32 [[OR]] to i8
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @fn1(i8 signext [[CONV3]])
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nsw i32 [[INDVARS_IV]], -1
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i32 [[INDVARS_IV_NEXT]] to i8
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[TMP0]], -14
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %for.body

for.body:
  %c.07 = phi i8 [ -3, %entry ], [ %dec, %for.body ]
  %conv6 = zext i8 %c.07 to i32
  %or = or i32 %a, %conv6
  %conv3 = trunc i32 %or to i8
  %call = call i32 @fn1(i8 signext %conv3)
  %dec = add i8 %c.07, -1
  %cmp = icmp sgt i8 %dec, -14
  br i1 %cmp, label %for.body, label %for.end

for.end:
  ret i32 0
}


define i32 @test5(i32* %a, i32 %b) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[B:%.*]] to i64
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUM_0:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i64 [[INDVARS_IV]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[SUM_0]], [[TMP1]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ [[SUM_0]], [[FOR_COND]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
;
entry:
  br label %for.cond

for.cond:
  %sum.0 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp ule i32 %i.0, %b
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idxprom = zext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %sum.0, %0
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:
  ret i32 %sum.0
}

define i32 @test6(i32* %a, i32 %b) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i32 [[B:%.*]], -1
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP0]], i32 [[B]], i32 -1
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[SMAX]], 1
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[TMP1]] to i64
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUM_0:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[SUM_0]], [[TMP2]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ [[SUM_0]], [[FOR_COND]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
;
entry:
  br label %for.cond

for.cond:
  %sum.0 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp sle i32 %i.0, %b
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idxprom = zext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %sum.0, %0
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:
  ret i32 %sum.0
}

define i32 @test7(i32* %a, i32 %b) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[B:%.*]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 [[B]], -1
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP1]], i32 [[B]], i32 -1
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[SMAX]], 2
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUM_0:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i64 [[INDVARS_IV]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[SUM_0]], [[TMP3]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ [[SUM_0]], [[FOR_BODY]] ], [ [[SUM_0]], [[FOR_COND]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
;
entry:
  br label %for.cond

for.cond:
  %sum.0 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp ule i32 %i.0, %b
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %sum.0, %0
  %inc = add nsw i32 %i.0, 1
  %cmp2 = icmp sle i32 %i.0, %b
  br i1 %cmp2, label %for.cond, label %for.end

for.end:
  ret i32 %sum.0
}

define i32 @test8(i32* %a, i32 %b, i32 %init) {
;     Note: %indvars.iv is the sign extension of %i.0
; CHECK-LABEL: @test8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[E:%.*]] = icmp sgt i32 [[INIT:%.*]], 0
; CHECK-NEXT:    br i1 [[E]], label [[FOR_COND_PREHEADER:%.*]], label [[LEAVE:%.*]]
; CHECK:       for.cond.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[INIT]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[B:%.*]] to i64
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[TMP0]], [[FOR_COND_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[SUM_0:%.*]] = phi i32 [ [[ADD:%.*]], [[FOR_BODY]] ], [ 0, [[FOR_COND_PREHEADER]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i64 [[INDVARS_IV]], [[TMP1]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[SUM_0]], [[TMP2]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i64 0, [[INDVARS_IV_NEXT]]
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_COND]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ [[SUM_0]], [[FOR_BODY]] ], [ [[SUM_0]], [[FOR_COND]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
; CHECK:       leave:
; CHECK-NEXT:    ret i32 0
;
entry:
  %e = icmp sgt i32 %init, 0
  br i1 %e, label %for.cond, label %leave

for.cond:
  %sum.0 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %i.0 = phi i32 [ %init, %entry ], [ %inc, %for.body ]
  %cmp = icmp ule i32 %i.0, %b
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %sum.0, %0
  %inc = add nsw i32 %i.0, 1
  %cmp2 = icmp slt i32 0, %inc
  br i1 %cmp2, label %for.cond, label %for.end

for.end:
  ret i32 %sum.0

leave:
  ret i32 0
}

define i32 @test9(i32* %a, i32 %b, i32 %init) {
;     Note: %indvars.iv is the zero extension of %i.0
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[E:%.*]] = icmp sgt i32 [[INIT:%.*]], 0
; CHECK-NEXT:    br i1 [[E]], label [[FOR_COND_PREHEADER:%.*]], label [[LEAVE:%.*]]
; CHECK:       for.cond.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[INIT]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 [[INIT]], [[B:%.*]]
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP1]], i32 [[INIT]], i32 [[B]]
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[SMAX]] to i64
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[TMP0]], [[FOR_COND_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[SUM_0:%.*]] = phi i32 [ [[ADD:%.*]], [[FOR_BODY]] ], [ 0, [[FOR_COND_PREHEADER]] ]
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[SUM_0]], [[TMP2]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 0, [[TMP3]]
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_COND]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ [[SUM_0]], [[FOR_BODY]] ], [ [[SUM_0]], [[FOR_COND]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
; CHECK:       leave:
; CHECK-NEXT:    ret i32 0
;
entry:
  %e = icmp sgt i32 %init, 0
  br i1 %e, label %for.cond, label %leave

for.cond:
  %sum.0 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %i.0 = phi i32 [ %init, %entry ], [ %inc, %for.body ]
  %cmp = icmp slt i32 %i.0, %b
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idxprom = zext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %sum.0, %0
  %inc = add nsw i32 %i.0, 1
  %cmp2 = icmp slt i32 0, %inc
  br i1 %cmp2, label %for.cond, label %for.end

for.end:
  ret i32 %sum.0

leave:
  ret i32 0
}

declare void @consume.i64(i64)
declare void @consume.i1(i1)

define i32 @test10(i32 %v) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SEXT:%.*]] = sext i32 [[V:%.*]] to i64
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[LOOP]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = mul nsw i64 [[INDVARS_IV]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[TMP0]], [[SEXT]]
; CHECK-NEXT:    call void @consume.i1(i1 [[TMP1]])
; CHECK-NEXT:    call void @consume.i64(i64 [[TMP0]])
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], 11
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[LEAVE:%.*]]
; CHECK:       leave:
; CHECK-NEXT:    ret i32 22
;
  entry:
  br label %loop

  loop:

  %i = phi i32 [ 0, %entry ], [ %i.inc, %loop ]
  %i.inc = add i32 %i, 1
  %iv = mul i32 %i, -1
  %cmp = icmp eq i32 %iv, %v
  call void @consume.i1(i1 %cmp)
  %be.cond = icmp slt i32 %i.inc, 11
  %ext = sext i32 %iv to i64
  call void @consume.i64(i64 %ext)
  br i1 %be.cond, label %loop, label %leave

  leave:
  ret i32 22
}
