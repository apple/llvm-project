; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -newgvn -S | FileCheck %s
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

;; Function Attrs: nounwind ssp uwtable
;; We should eliminate the sub, and one of the phi nodes
define void @vnum_test1(i32* %data) #0 {
; CHECK-LABEL: @vnum_test1(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = getelementptr inbounds i32, i32* [[DATA:%.*]], i64 3
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 4
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP2]], align 4
; CHECK-NEXT:    br label [[BB4:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    [[M_0:%.*]] = phi i32 [ [[TMP3]], [[BB:%.*]] ], [ [[TMP15:%.*]], [[BB17:%.*]] ]
; CHECK-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[BB]] ], [ [[TMP18:%.*]], [[BB17]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp slt i32 [[I_0]], [[TMP1]]
; CHECK-NEXT:    br i1 [[TMP5]], label [[BB6:%.*]], label [[BB19:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 2
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP9:%.*]] = sext i32 [[TMP8]] to i64
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 [[TMP9]]
; CHECK-NEXT:    store i32 2, i32* [[TMP10]], align 4
; CHECK-NEXT:    store i32 0, i32* [[DATA]], align 4
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 1
; CHECK-NEXT:    [[TMP14:%.*]] = load i32, i32* [[TMP13]], align 4
; CHECK-NEXT:    [[TMP15]] = add nsw i32 [[M_0]], [[TMP14]]
; CHECK-NEXT:    br label [[BB17]]
; CHECK:       bb17:
; CHECK-NEXT:    [[TMP18]] = add nsw i32 [[I_0]], 1
; CHECK-NEXT:    br label [[BB4]]
; CHECK:       bb19:
; CHECK-NEXT:    ret void
;
bb:
  %tmp = getelementptr inbounds i32, i32* %data, i64 3
  %tmp1 = load i32, i32* %tmp, align 4
  %tmp2 = getelementptr inbounds i32, i32* %data, i64 4
  %tmp3 = load i32, i32* %tmp2, align 4
  br label %bb4

bb4:                                              ; preds = %bb17, %bb
  %m.0 = phi i32 [ %tmp3, %bb ], [ %tmp15, %bb17 ]
  %i.0 = phi i32 [ 0, %bb ], [ %tmp18, %bb17 ]
  %n.0 = phi i32 [ %tmp3, %bb ], [ %tmp16, %bb17 ]
  %tmp5 = icmp slt i32 %i.0, %tmp1
  br i1 %tmp5, label %bb6, label %bb19

bb6:                                              ; preds = %bb4
  %tmp7 = getelementptr inbounds i32, i32* %data, i64 2
  %tmp8 = load i32, i32* %tmp7, align 4
  %tmp9 = sext i32 %tmp8 to i64
  %tmp10 = getelementptr inbounds i32, i32* %data, i64 %tmp9
  store i32 2, i32* %tmp10, align 4
  %tmp11 = sub nsw i32 %m.0, %n.0
  %tmp12 = getelementptr inbounds i32, i32* %data, i64 0
  store i32 %tmp11, i32* %tmp12, align 4
  %tmp13 = getelementptr inbounds i32, i32* %data, i64 1
  %tmp14 = load i32, i32* %tmp13, align 4
  %tmp15 = add nsw i32 %m.0, %tmp14
  %tmp16 = add nsw i32 %n.0, %tmp14
  br label %bb17

bb17:                                             ; preds = %bb6
  %tmp18 = add nsw i32 %i.0, 1
  br label %bb4

bb19:                                             ; preds = %bb4
  ret void
}

;; Function Attrs: nounwind ssp uwtable
;; We should eliminate the sub, one of the phi nodes, prove the store of the sub
;; and the load of data are equivalent, that the load always produces constant 0, and
;; delete the load replacing it with constant 0.
define i32 @vnum_test2(i32* %data) #0 {
; CHECK-LABEL: @vnum_test2(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = getelementptr inbounds i32, i32* [[DATA:%.*]], i64 3
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 4
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP2]], align 4
; CHECK-NEXT:    br label [[BB4:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    [[M_0:%.*]] = phi i32 [ [[TMP3]], [[BB:%.*]] ], [ [[TMP15:%.*]], [[BB19:%.*]] ]
; CHECK-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[BB]] ], [ [[TMP20:%.*]], [[BB19]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp slt i32 [[I_0]], [[TMP1]]
; CHECK-NEXT:    br i1 [[TMP5]], label [[BB6:%.*]], label [[BB21:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 2
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP9:%.*]] = sext i32 [[TMP8]] to i64
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 [[TMP9]]
; CHECK-NEXT:    store i32 2, i32* [[TMP10]], align 4
; CHECK-NEXT:    store i32 0, i32* [[DATA]], align 4
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 1
; CHECK-NEXT:    [[TMP14:%.*]] = load i32, i32* [[TMP13]], align 4
; CHECK-NEXT:    [[TMP15]] = add nsw i32 [[M_0]], [[TMP14]]
; CHECK-NEXT:    br label [[BB19]]
; CHECK:       bb19:
; CHECK-NEXT:    [[TMP20]] = add nsw i32 [[I_0]], 1
; CHECK-NEXT:    br label [[BB4]]
; CHECK:       bb21:
; CHECK-NEXT:    ret i32 0
;
bb:
  %tmp = getelementptr inbounds i32, i32* %data, i64 3
  %tmp1 = load i32, i32* %tmp, align 4
  %tmp2 = getelementptr inbounds i32, i32* %data, i64 4
  %tmp3 = load i32, i32* %tmp2, align 4
  br label %bb4

bb4:                                              ; preds = %bb19, %bb
  %m.0 = phi i32 [ %tmp3, %bb ], [ %tmp15, %bb19 ]
  %n.0 = phi i32 [ %tmp3, %bb ], [ %tmp16, %bb19 ]
  %i.0 = phi i32 [ 0, %bb ], [ %tmp20, %bb19 ]
  %p.0 = phi i32 [ undef, %bb ], [ %tmp18, %bb19 ]
  %tmp5 = icmp slt i32 %i.0, %tmp1
  br i1 %tmp5, label %bb6, label %bb21

bb6:                                              ; preds = %bb4
  %tmp7 = getelementptr inbounds i32, i32* %data, i64 2
  %tmp8 = load i32, i32* %tmp7, align 4
  %tmp9 = sext i32 %tmp8 to i64
  %tmp10 = getelementptr inbounds i32, i32* %data, i64 %tmp9
  store i32 2, i32* %tmp10, align 4
  %tmp11 = sub nsw i32 %m.0, %n.0
  %tmp12 = getelementptr inbounds i32, i32* %data, i64 0
  store i32 %tmp11, i32* %tmp12, align 4
  %tmp13 = getelementptr inbounds i32, i32* %data, i64 1
  %tmp14 = load i32, i32* %tmp13, align 4
  %tmp15 = add nsw i32 %m.0, %tmp14
  %tmp16 = add nsw i32 %n.0, %tmp14
  %tmp17 = getelementptr inbounds i32, i32* %data, i64 0
  %tmp18 = load i32, i32* %tmp17, align 4
  br label %bb19

bb19:                                             ; preds = %bb6
  %tmp20 = add nsw i32 %i.0, 1
  br label %bb4

bb21:                                             ; preds = %bb4
  ret i32 %p.0
}


; Function Attrs: nounwind ssp uwtable
;; Same as test 2, with a conditional store of m-n, so it has to also discover
;; that data ends up with the same value no matter what branch is taken.
define i32 @vnum_test3(i32* %data) #0 {
; CHECK-LABEL: @vnum_test3(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = getelementptr inbounds i32, i32* [[DATA:%.*]], i64 3
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 4
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP2]], align 4
; CHECK-NEXT:    br label [[BB4:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    [[N_0:%.*]] = phi i32 [ [[TMP3]], [[BB:%.*]] ], [ [[TMP19:%.*]], [[BB21:%.*]] ]
; CHECK-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[BB]] ], [ [[TMP22:%.*]], [[BB21]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp slt i32 [[I_0]], [[TMP1]]
; CHECK-NEXT:    br i1 [[TMP5]], label [[BB6:%.*]], label [[BB23:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 2
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 5
; CHECK-NEXT:    store i32 0, i32* [[TMP9]], align 4
; CHECK-NEXT:    [[TMP10:%.*]] = icmp slt i32 [[I_0]], 30
; CHECK-NEXT:    br i1 [[TMP10]], label [[BB11:%.*]], label [[BB14:%.*]]
; CHECK:       bb11:
; CHECK-NEXT:    br label [[BB14]]
; CHECK:       bb14:
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i32, i32* [[DATA]], i64 1
; CHECK-NEXT:    [[TMP18:%.*]] = load i32, i32* [[TMP17]], align 4
; CHECK-NEXT:    [[TMP19]] = add nsw i32 [[N_0]], [[TMP18]]
; CHECK-NEXT:    br label [[BB21]]
; CHECK:       bb21:
; CHECK-NEXT:    [[TMP22]] = add nsw i32 [[I_0]], 1
; CHECK-NEXT:    br label [[BB4]]
; CHECK:       bb23:
; CHECK-NEXT:    ret i32 0
;
bb:
  %tmp = getelementptr inbounds i32, i32* %data, i64 3
  %tmp1 = load i32, i32* %tmp, align 4
  %tmp2 = getelementptr inbounds i32, i32* %data, i64 4
  %tmp3 = load i32, i32* %tmp2, align 4
  br label %bb4

bb4:                                              ; preds = %bb21, %bb
  %n.0 = phi i32 [ %tmp3, %bb ], [ %tmp20, %bb21 ]
  %m.0 = phi i32 [ %tmp3, %bb ], [ %tmp19, %bb21 ]
  %p.0 = phi i32 [ 0, %bb ], [ %tmp16, %bb21 ]
  %i.0 = phi i32 [ 0, %bb ], [ %tmp22, %bb21 ]
  %tmp5 = icmp slt i32 %i.0, %tmp1
  br i1 %tmp5, label %bb6, label %bb23

bb6:                                              ; preds = %bb4
  %tmp7 = getelementptr inbounds i32, i32* %data, i64 2
  %tmp8 = load i32, i32* %tmp7, align 4
  %tmp9 = getelementptr inbounds i32, i32* %data, i64 5
  store i32 0, i32* %tmp9, align 4
  %tmp10 = icmp slt i32 %i.0, 30
  br i1 %tmp10, label %bb11, label %bb14

bb11:                                             ; preds = %bb6
  %tmp12 = sub nsw i32 %m.0, %n.0
  %tmp13 = getelementptr inbounds i32, i32* %data, i64 5
  store i32 %tmp12, i32* %tmp13, align 4
  br label %bb14

bb14:                                             ; preds = %bb11, %bb6
  %tmp15 = getelementptr inbounds i32, i32* %data, i64 5
  %tmp16 = load i32, i32* %tmp15, align 4
  %tmp17 = getelementptr inbounds i32, i32* %data, i64 1
  %tmp18 = load i32, i32* %tmp17, align 4
  %tmp19 = add nsw i32 %m.0, %tmp18
  %tmp20 = add nsw i32 %n.0, %tmp18
  br label %bb21

bb21:                                             ; preds = %bb14
  %tmp22 = add nsw i32 %i.0, 1
  br label %bb4

bb23:                                             ; preds = %bb4
  ret i32 %p.0
}

;; This is an irreducible test case that will cause a memoryphi node loop
;; in the two blocks.
;; It's equivalent to something like
;; *a = 0
;; if (<....>) goto loopmiddle
;; loopstart:
;; loopmiddle:
;; load *a
;; *a = 0
;; if (<....>) goto loopstart otherwise goto loopend
;; loopend:
;; load *a
;; add the results of the loads
;; return them
;;
;; Both loads should equal 0, but it requires being
;; completely optimistic about MemoryPhis, otherwise
;; we will not be able to see through the cycle.
define i8 @irreducible_memoryphi(i8* noalias %arg, i8* noalias %arg2) {
; CHECK-LABEL: @irreducible_memoryphi(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    store i8 0, i8* [[ARG:%.*]]
; CHECK-NEXT:    br i1 undef, label [[BB2:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    br i1 undef, label [[BB1]], label [[BB3:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i8 0
;
bb:
  store i8 0, i8 *%arg
  br i1 undef, label %bb2, label %bb1

bb1:                                              ; preds = %bb2, %bb
  br label %bb2

bb2:                                              ; preds = %bb1, %bb
  %tmp2 = load i8, i8* %arg
  store i8 0, i8 *%arg
  br i1 undef, label %bb1, label %bb3

bb3:                                              ; preds = %bb2
  %tmp = load i8, i8* %arg
  %tmp3 = add i8 %tmp, %tmp2
  ret i8 %tmp3
}
;; This is an irreducible test case that will cause a phi node loop
;; in the two blocks
;;
;; It should return 0, but it requires being
;; completely optimistic about phis, otherwise
;; we will not be able to see through the cycle.
define i32 @irreducible_phi(i32 %arg) {
; CHECK-LABEL: @irreducible_phi(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 undef, label [[BB2:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    br i1 undef, label [[BB1]], label [[BB3:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
bb:
  %tmp = add i32 0, %arg
  br i1 undef, label %bb2, label %bb1

bb1:                                              ; preds = %bb2, %bb
  %phi1 = phi i32 [%tmp, %bb], [%phi2, %bb2]
  br label %bb2

bb2:                                              ; preds = %bb1, %bb
  %phi2 = phi i32 [%tmp, %bb], [%phi1, %bb1]
  br i1 undef, label %bb1, label %bb3

bb3:                                              ; preds = %bb2
  ; This should be zero
  %tmp3 = sub i32 %tmp, %phi2
  ret i32 %tmp3
}
attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "frame-pointer"="all" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0, !0, !0}

!0 = !{!"Apple LLVM version 6.0 (clang-600.0.56) (based on LLVM 3.5svn)"}
