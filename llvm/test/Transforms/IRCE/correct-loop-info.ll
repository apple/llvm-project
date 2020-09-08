; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -irce < %s -S | FileCheck %s
; RUN: opt -passes='require<branch-prob>,irce' < %s -S | FileCheck %s

; REQUIRES: asserts

; IRCE creates the pre and post loop, and invokes the
; canonicalizing these loops to LCSSA and loop-simplfy structure. Make sure that the update to the loopinfo does not
; incorrectly change the header while canonicalizing these pre/post loops. We
; were incorrectly updating LI when the split loop is a subloop as in the case below.
source_filename = "correct-loop-info.ll"

define void @baz() personality i32* ()* @ham {
; CHECK-LABEL: @baz(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[OUTERHEADER:%.*]]
; CHECK:       outerheader:
; CHECK-NEXT:    [[TMP:%.*]] = icmp slt i32 undef, 84
; CHECK-NEXT:    br i1 [[TMP]], label [[BB2:%.*]], label [[BB16:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br i1 false, label [[INNERHEADER_PRELOOP_PREHEADER:%.*]], label [[PRELOOP_PSEUDO_EXIT:%.*]]
; CHECK:       innerheader.preloop.preheader:
; CHECK-NEXT:    br label [[INNERHEADER_PRELOOP:%.*]]
; CHECK:       mainloop:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp slt i32 [[INDVAR_END:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP0]], label [[INNERHEADER_PREHEADER:%.*]], label [[MAIN_PSEUDO_EXIT:%.*]]
; CHECK:       innerheader.preheader:
; CHECK-NEXT:    br label [[INNERHEADER:%.*]]
; CHECK:       innerheader:
; CHECK-NEXT:    [[TMP4:%.*]] = phi i32 [ [[TMP6:%.*]], [[BB8:%.*]] ], [ [[TMP4_PRELOOP_COPY:%.*]], [[INNERHEADER_PREHEADER]] ]
; CHECK-NEXT:    invoke void @pluto()
; CHECK-NEXT:    to label [[BB5:%.*]] unwind label %outer_exiting.loopexit.split-lp.loopexit.split-lp
; CHECK:       bb5:
; CHECK-NEXT:    [[TMP6]] = add i32 [[TMP4]], 1
; CHECK-NEXT:    [[TMP7:%.*]] = icmp slt i32 [[TMP6]], 1
; CHECK-NEXT:    br i1 true, label [[BB8]], label [[EXIT3_LOOPEXIT5:%.*]]
; CHECK:       bb8:
; CHECK-NEXT:    [[TMP9:%.*]] = icmp slt i32 [[TMP6]], 84
; CHECK-NEXT:    [[TMP1:%.*]] = icmp slt i32 [[TMP6]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[INNERHEADER]], label [[MAIN_EXIT_SELECTOR:%.*]]
; CHECK:       main.exit.selector:
; CHECK-NEXT:    [[TMP6_LCSSA:%.*]] = phi i32 [ [[TMP6]], [[BB8]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i32 [[TMP6_LCSSA]], 84
; CHECK-NEXT:    br i1 [[TMP2]], label [[MAIN_PSEUDO_EXIT]], label [[BB13:%.*]]
; CHECK:       main.pseudo.exit:
; CHECK-NEXT:    [[TMP4_COPY:%.*]] = phi i32 [ [[TMP4_PRELOOP_COPY]], [[MAINLOOP:%.*]] ], [ [[TMP6_LCSSA]], [[MAIN_EXIT_SELECTOR]] ]
; CHECK-NEXT:    [[INDVAR_END1:%.*]] = phi i32 [ [[INDVAR_END]], [[MAINLOOP]] ], [ [[TMP6_LCSSA]], [[MAIN_EXIT_SELECTOR]] ]
; CHECK-NEXT:    br label [[POSTLOOP:%.*]]
; CHECK:       outer_exiting.loopexit:
; CHECK-NEXT:    [[LPAD_LOOPEXIT:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    br label [[OUTER_EXITING:%.*]]
; CHECK:       outer_exiting.loopexit.split-lp.loopexit:
; CHECK-NEXT:    [[LPAD_LOOPEXIT2:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    br label %outer_exiting.loopexit.split-lp
; CHECK:       outer_exiting.loopexit.split-lp.loopexit.split-lp:
; CHECK-NEXT:    %lpad.loopexit.split-lp3 = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    br label %outer_exiting.loopexit.split-lp
; CHECK:       outer_exiting.loopexit.split-lp:
; CHECK-NEXT:    br label [[OUTER_EXITING]]
; CHECK:       outer_exiting:
; CHECK-NEXT:    switch i32 undef, label [[EXIT2:%.*]] [
; CHECK-NEXT:    i32 142, label [[BB14:%.*]]
; CHECK-NEXT:    i32 448, label [[EXIT:%.*]]
; CHECK-NEXT:    ]
; CHECK:       exit3.loopexit:
; CHECK-NEXT:    br label [[EXIT3:%.*]]
; CHECK:       exit3.loopexit4:
; CHECK-NEXT:    br label [[EXIT3]]
; CHECK:       exit3.loopexit5:
; CHECK-NEXT:    br label [[EXIT3]]
; CHECK:       exit3:
; CHECK-NEXT:    ret void
; CHECK:       bb13.loopexit:
; CHECK-NEXT:    br label [[BB13]]
; CHECK:       bb13:
; CHECK-NEXT:    unreachable
; CHECK:       bb14:
; CHECK-NEXT:    br label [[OUTERHEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       bb16:
; CHECK-NEXT:    ret void
; CHECK:       exit2:
; CHECK-NEXT:    ret void
; CHECK:       innerheader.preloop:
; CHECK-NEXT:    [[TMP4_PRELOOP:%.*]] = phi i32 [ [[TMP6_PRELOOP:%.*]], [[BB8_PRELOOP:%.*]] ], [ undef, [[INNERHEADER_PRELOOP_PREHEADER]] ]
; CHECK-NEXT:    invoke void @pluto()
; CHECK-NEXT:    to label [[BB5_PRELOOP:%.*]] unwind label [[OUTER_EXITING_LOOPEXIT:%.*]]
; CHECK:       bb5.preloop:
; CHECK-NEXT:    [[TMP6_PRELOOP]] = add i32 [[TMP4_PRELOOP]], 1
; CHECK-NEXT:    [[TMP7_PRELOOP:%.*]] = icmp slt i32 [[TMP6_PRELOOP]], 1
; CHECK-NEXT:    br i1 [[TMP7_PRELOOP]], label [[BB8_PRELOOP]], label [[EXIT3_LOOPEXIT:%.*]]
; CHECK:       bb8.preloop:
; CHECK-NEXT:    [[TMP9_PRELOOP:%.*]] = icmp slt i32 [[TMP6_PRELOOP]], 84
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i32 [[TMP6_PRELOOP]], -1
; CHECK-NEXT:    br i1 [[TMP3]], label [[INNERHEADER_PRELOOP]], label [[PRELOOP_EXIT_SELECTOR:%.*]], !llvm.loop !0, !irce.loop.clone !5
; CHECK:       preloop.exit.selector:
; CHECK-NEXT:    [[TMP6_PRELOOP_LCSSA:%.*]] = phi i32 [ [[TMP6_PRELOOP]], [[BB8_PRELOOP]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp slt i32 [[TMP6_PRELOOP_LCSSA]], 84
; CHECK-NEXT:    br i1 [[TMP4]], label [[PRELOOP_PSEUDO_EXIT]], label [[BB13]]
; CHECK:       preloop.pseudo.exit:
; CHECK-NEXT:    [[TMP4_PRELOOP_COPY]] = phi i32 [ undef, [[BB2]] ], [ [[TMP6_PRELOOP_LCSSA]], [[PRELOOP_EXIT_SELECTOR]] ]
; CHECK-NEXT:    [[INDVAR_END]] = phi i32 [ undef, [[BB2]] ], [ [[TMP6_PRELOOP_LCSSA]], [[PRELOOP_EXIT_SELECTOR]] ]
; CHECK-NEXT:    br label [[MAINLOOP]]
; CHECK:       postloop:
; CHECK-NEXT:    br label [[INNERHEADER_POSTLOOP:%.*]]
; CHECK:       innerheader.postloop:
; CHECK-NEXT:    [[TMP4_POSTLOOP:%.*]] = phi i32 [ [[TMP6_POSTLOOP:%.*]], [[BB8_POSTLOOP:%.*]] ], [ [[TMP4_COPY]], [[POSTLOOP]] ]
; CHECK-NEXT:    invoke void @pluto()
; CHECK-NEXT:    to label [[BB5_POSTLOOP:%.*]] unwind label %outer_exiting.loopexit.split-lp.loopexit
; CHECK:       bb5.postloop:
; CHECK-NEXT:    [[TMP6_POSTLOOP]] = add i32 [[TMP4_POSTLOOP]], 1
; CHECK-NEXT:    [[TMP7_POSTLOOP:%.*]] = icmp slt i32 [[TMP6_POSTLOOP]], 1
; CHECK-NEXT:    br i1 [[TMP7_POSTLOOP]], label [[BB8_POSTLOOP]], label [[EXIT3_LOOPEXIT4:%.*]]
; CHECK:       bb8.postloop:
; CHECK-NEXT:    [[TMP9_POSTLOOP:%.*]] = icmp slt i32 [[TMP6_POSTLOOP]], 84
; CHECK-NEXT:    br i1 [[TMP9_POSTLOOP]], label [[INNERHEADER_POSTLOOP]], label [[BB13_LOOPEXIT:%.*]], !llvm.loop !6, !irce.loop.clone !5
;
bb:
  br label %outerheader

outerheader:                                              ; preds = %bb14, %bb
  %tmp = icmp slt i32 undef, 84
  br i1 %tmp, label %bb2, label %bb16

bb2:                                              ; preds = %outerheader
  br label %innerheader

innerheader:                                              ; preds = %bb8, %bb2
  %tmp4 = phi i32 [ %tmp6, %bb8 ], [ undef, %bb2 ]
  invoke void @pluto()
  to label %bb5 unwind label %outer_exiting

bb5:                                              ; preds = %innerheader
  %tmp6 = add i32 %tmp4, 1
  %tmp7 = icmp slt i32 %tmp6, 1
  br i1 %tmp7, label %bb8, label %exit3

bb8:                                              ; preds = %bb5
  %tmp9 = icmp slt i32 %tmp6, 84
  br i1 %tmp9, label %innerheader, label %bb13

outer_exiting:                                             ; preds = %innerheader
  %tmp11 = landingpad { i8*, i32 }
  cleanup
  switch i32 undef, label %exit2 [
  i32 142, label %bb14
  i32 448, label %exit
  ]

exit3:                                             ; preds = %bb5
  ret void

bb13:                                             ; preds = %bb8
  unreachable

bb14:                                             ; preds = %outer_exiting
  br label %outerheader

exit:                                             ; preds = %outer_exiting
  ret void

bb16:                                             ; preds = %outerheader
  ret void

exit2:                                             ; preds = %outer_exiting
  ret void
}

declare i32* @ham()

declare void @pluto()

!0 = distinct !{!0, !1, !2, !3, !4}
!1 = !{!"llvm.loop.unroll.disable"}
!2 = !{!"llvm.loop.vectorize.enable", i1 false}
!3 = !{!"llvm.loop.licm_versioning.disable"}
!4 = !{!"llvm.loop.distribute.enable", i1 false}
!5 = !{}
!6 = distinct !{!6, !1, !2, !3, !4}
