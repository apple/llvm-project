; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -mtriple=x86_64-apple-macosx -mcpu=core-avx2 -S | FileCheck %s

define <2 x double> @constant_blendvpd(<2 x double> %xy, <2 x double> %ab) {
; CHECK-LABEL: @constant_blendvpd(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[AB:%.*]], <2 x double> [[XY:%.*]], <2 x i32> <i32 0, i32 3>
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = tail call <2 x double> @llvm.x86.sse41.blendvpd(<2 x double> %xy, <2 x double> %ab, <2 x double> <double 0xFFFFFFFFE0000000, double 0.000000e+00>)
  ret <2 x double> %1
}

define <2 x double> @constant_blendvpd_zero(<2 x double> %xy, <2 x double> %ab) {
; CHECK-LABEL: @constant_blendvpd_zero(
; CHECK-NEXT:    ret <2 x double> [[XY:%.*]]
;
  %1 = tail call <2 x double> @llvm.x86.sse41.blendvpd(<2 x double> %xy, <2 x double> %ab, <2 x double> zeroinitializer)
  ret <2 x double> %1
}

define <2 x double> @constant_blendvpd_dup(<2 x double> %xy, <2 x double> %sel) {
; CHECK-LABEL: @constant_blendvpd_dup(
; CHECK-NEXT:    ret <2 x double> [[XY:%.*]]
;
  %1 = tail call <2 x double> @llvm.x86.sse41.blendvpd(<2 x double> %xy, <2 x double> %xy, <2 x double> %sel)
  ret <2 x double> %1
}

define <4 x float> @constant_blendvps(<4 x float> %xyzw, <4 x float> %abcd) {
; CHECK-LABEL: @constant_blendvps(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x float> [[XYZW:%.*]], <4 x float> [[ABCD:%.*]], <4 x i32> <i32 0, i32 1, i32 2, i32 7>
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %xyzw, <4 x float> %abcd, <4 x float> <float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0xFFFFFFFFE0000000>)
  ret <4 x float> %1
}

define <4 x float> @constant_blendvps_zero(<4 x float> %xyzw, <4 x float> %abcd) {
; CHECK-LABEL: @constant_blendvps_zero(
; CHECK-NEXT:    ret <4 x float> [[XYZW:%.*]]
;
  %1 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %xyzw, <4 x float> %abcd, <4 x float> zeroinitializer)
  ret <4 x float> %1
}

define <4 x float> @constant_blendvps_dup(<4 x float> %xyzw, <4 x float> %sel) {
; CHECK-LABEL: @constant_blendvps_dup(
; CHECK-NEXT:    ret <4 x float> [[XYZW:%.*]]
;
  %1 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %xyzw, <4 x float> %xyzw, <4 x float> %sel)
  ret <4 x float> %1
}

define <16 x i8> @constant_pblendvb(<16 x i8> %xyzw, <16 x i8> %abcd) {
; CHECK-LABEL: @constant_pblendvb(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <16 x i8> [[XYZW:%.*]], <16 x i8> [[ABCD:%.*]], <16 x i32> <i32 0, i32 1, i32 18, i32 3, i32 20, i32 21, i32 22, i32 7, i32 8, i32 9, i32 26, i32 11, i32 28, i32 29, i32 30, i32 15>
; CHECK-NEXT:    ret <16 x i8> [[TMP1]]
;
  %1 = tail call <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8> %xyzw, <16 x i8> %abcd, <16 x i8> <i8 0, i8 0, i8 255, i8 0, i8 255, i8 255, i8 255, i8 0, i8 0, i8 0, i8 255, i8 0, i8 255, i8 255, i8 255, i8 0>)
  ret <16 x i8> %1
}

define <16 x i8> @constant_pblendvb_zero(<16 x i8> %xyzw, <16 x i8> %abcd) {
; CHECK-LABEL: @constant_pblendvb_zero(
; CHECK-NEXT:    ret <16 x i8> [[XYZW:%.*]]
;
  %1 = tail call <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8> %xyzw, <16 x i8> %abcd, <16 x i8> zeroinitializer)
  ret <16 x i8> %1
}

define <16 x i8> @constant_pblendvb_dup(<16 x i8> %xyzw, <16 x i8> %sel) {
; CHECK-LABEL: @constant_pblendvb_dup(
; CHECK-NEXT:    ret <16 x i8> [[XYZW:%.*]]
;
  %1 = tail call <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8> %xyzw, <16 x i8> %xyzw, <16 x i8> %sel)
  ret <16 x i8> %1
}

define <4 x double> @constant_blendvpd_avx(<4 x double> %xy, <4 x double> %ab) {
; CHECK-LABEL: @constant_blendvpd_avx(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x double> [[AB:%.*]], <4 x double> [[XY:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    ret <4 x double> [[TMP1]]
;
  %1 = tail call <4 x double> @llvm.x86.avx.blendv.pd.256(<4 x double> %xy, <4 x double> %ab, <4 x double> <double 0xFFFFFFFFE0000000, double 0.000000e+00, double 0xFFFFFFFFE0000000, double 0.000000e+00>)
  ret <4 x double> %1
}

define <4 x double> @constant_blendvpd_avx_zero(<4 x double> %xy, <4 x double> %ab) {
; CHECK-LABEL: @constant_blendvpd_avx_zero(
; CHECK-NEXT:    ret <4 x double> [[XY:%.*]]
;
  %1 = tail call <4 x double> @llvm.x86.avx.blendv.pd.256(<4 x double> %xy, <4 x double> %ab, <4 x double> zeroinitializer)
  ret <4 x double> %1
}

define <4 x double> @constant_blendvpd_avx_dup(<4 x double> %xy, <4 x double> %sel) {
; CHECK-LABEL: @constant_blendvpd_avx_dup(
; CHECK-NEXT:    ret <4 x double> [[XY:%.*]]
;
  %1 = tail call <4 x double> @llvm.x86.avx.blendv.pd.256(<4 x double> %xy, <4 x double> %xy, <4 x double> %sel)
  ret <4 x double> %1
}

define <8 x float> @constant_blendvps_avx(<8 x float> %xyzw, <8 x float> %abcd) {
; CHECK-LABEL: @constant_blendvps_avx(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x float> [[XYZW:%.*]], <8 x float> [[ABCD:%.*]], <8 x i32> <i32 0, i32 1, i32 2, i32 11, i32 4, i32 5, i32 6, i32 15>
; CHECK-NEXT:    ret <8 x float> [[TMP1]]
;
  %1 = tail call <8 x float> @llvm.x86.avx.blendv.ps.256(<8 x float> %xyzw, <8 x float> %abcd, <8 x float> <float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0xFFFFFFFFE0000000, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0xFFFFFFFFE0000000>)
  ret <8 x float> %1
}

define <8 x float> @constant_blendvps_avx_zero(<8 x float> %xyzw, <8 x float> %abcd) {
; CHECK-LABEL: @constant_blendvps_avx_zero(
; CHECK-NEXT:    ret <8 x float> [[XYZW:%.*]]
;
  %1 = tail call <8 x float> @llvm.x86.avx.blendv.ps.256(<8 x float> %xyzw, <8 x float> %abcd, <8 x float> zeroinitializer)
  ret <8 x float> %1
}

define <8 x float> @constant_blendvps_avx_dup(<8 x float> %xyzw, <8 x float> %sel) {
; CHECK-LABEL: @constant_blendvps_avx_dup(
; CHECK-NEXT:    ret <8 x float> [[XYZW:%.*]]
;
  %1 = tail call <8 x float> @llvm.x86.avx.blendv.ps.256(<8 x float> %xyzw, <8 x float> %xyzw, <8 x float> %sel)
  ret <8 x float> %1
}

define <32 x i8> @constant_pblendvb_avx2(<32 x i8> %xyzw, <32 x i8> %abcd) {
; CHECK-LABEL: @constant_pblendvb_avx2(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <32 x i8> [[XYZW:%.*]], <32 x i8> [[ABCD:%.*]], <32 x i32> <i32 0, i32 1, i32 34, i32 3, i32 36, i32 37, i32 38, i32 7, i32 8, i32 9, i32 42, i32 11, i32 44, i32 45, i32 46, i32 15, i32 16, i32 17, i32 50, i32 19, i32 52, i32 53, i32 54, i32 23, i32 24, i32 25, i32 58, i32 27, i32 60, i32 61, i32 62, i32 31>
; CHECK-NEXT:    ret <32 x i8> [[TMP1]]
;
  %1 = tail call <32 x i8> @llvm.x86.avx2.pblendvb(<32 x i8> %xyzw, <32 x i8> %abcd,
  <32 x i8> <i8 0, i8 0, i8 255, i8 0, i8 255, i8 255, i8 255, i8 0,
  i8 0, i8 0, i8 255, i8 0, i8 255, i8 255, i8 255, i8 0,
  i8 0, i8 0, i8 255, i8 0, i8 255, i8 255, i8 255, i8 0,
  i8 0, i8 0, i8 255, i8 0, i8 255, i8 255, i8 255, i8 0>)
  ret <32 x i8> %1
}

define <32 x i8> @constant_pblendvb_avx2_zero(<32 x i8> %xyzw, <32 x i8> %abcd) {
; CHECK-LABEL: @constant_pblendvb_avx2_zero(
; CHECK-NEXT:    ret <32 x i8> [[XYZW:%.*]]
;
  %1 = tail call <32 x i8> @llvm.x86.avx2.pblendvb(<32 x i8> %xyzw, <32 x i8> %abcd, <32 x i8> zeroinitializer)
  ret <32 x i8> %1
}

define <32 x i8> @constant_pblendvb_avx2_dup(<32 x i8> %xyzw, <32 x i8> %sel) {
; CHECK-LABEL: @constant_pblendvb_avx2_dup(
; CHECK-NEXT:    ret <32 x i8> [[XYZW:%.*]]
;
  %1 = tail call <32 x i8> @llvm.x86.avx2.pblendvb(<32 x i8> %xyzw, <32 x i8> %xyzw, <32 x i8> %sel)
  ret <32 x i8> %1
}

define <4 x float> @sel_v4f32(<4 x float> %x, <4 x float> %y, <4 x i1> %cond) {
; CHECK-LABEL: @sel_v4f32(
; CHECK-NEXT:    [[R:%.*]] = select <4 x i1> [[COND:%.*]], <4 x float> [[Y:%.*]], <4 x float> [[X:%.*]]
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %s = sext <4 x i1> %cond to <4 x i32>
  %b = bitcast <4 x i32> %s to <4 x float>
  %r = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %x, <4 x float> %y, <4 x float> %b)
  ret <4 x float> %r
}

define <2 x double> @sel_v2f64(<2 x double> %x, <2 x double> %y, <2 x i1> %cond) {
; CHECK-LABEL: @sel_v2f64(
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[COND:%.*]], <2 x double> [[Y:%.*]], <2 x double> [[X:%.*]]
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %s = sext <2 x i1> %cond to <2 x i64>
  %b = bitcast <2 x i64> %s to <2 x double>
  %r = call <2 x double> @llvm.x86.sse41.blendvpd(<2 x double> %x, <2 x double> %y, <2 x double> %b)
  ret <2 x double> %r
}

; Bitcast X, Y, and the select and remove the intrinsic.

define <16 x i8> @sel_v4i32(<16 x i8> %x, <16 x i8> %y, <4 x i1> %cond) {
; CHECK-LABEL: @sel_v4i32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <16 x i8> [[X:%.*]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <16 x i8> [[Y:%.*]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[COND:%.*]], <4 x i32> [[TMP2]], <4 x i32> [[TMP1]]
; CHECK-NEXT:    [[R:%.*]] = bitcast <4 x i32> [[TMP3]] to <16 x i8>
; CHECK-NEXT:    ret <16 x i8> [[R]]
;
  %s = sext <4 x i1> %cond to <4 x i32>
  %b = bitcast <4 x i32> %s to <16 x i8>
  %r = call <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8> %x, <16 x i8> %y, <16 x i8> %b)
  ret <16 x i8> %r
}

define <16 x i8> @sel_v16i8(<16 x i8> %x, <16 x i8> %y, <16 x i1> %cond) {
; CHECK-LABEL: @sel_v16i8(
; CHECK-NEXT:    [[R:%.*]] = select <16 x i1> [[COND:%.*]], <16 x i8> [[Y:%.*]], <16 x i8> [[X:%.*]]
; CHECK-NEXT:    ret <16 x i8> [[R]]
;
  %s = sext <16 x i1> %cond to <16 x i8>
  %r = tail call <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8> %x, <16 x i8> %y, <16 x i8> %s)
  ret <16 x i8> %r
}

; PR38814: https://bugs.llvm.org/show_bug.cgi?id=38814
; Repeat the tests above using the minimal form that we expect when using C intrinsics in code.
; This verifies that nothing is interfering with the blend transform. This also tests the
; expected IR when 1 of the blend operands is a constant 0 vector. Potentially, this could
; be transformed to bitwise logic in IR, but currently that transform is left to the backend.

define <4 x float> @sel_v4f32_sse_reality(<4 x float>* %x, <4 x float> %y, <4 x float> %z) {
; CHECK-LABEL: @sel_v4f32_sse_reality(
; CHECK-NEXT:    [[LD:%.*]] = load <4 x float>, <4 x float>* [[X:%.*]], align 16
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt <4 x float> [[Z:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = select <4 x i1> [[CMP]], <4 x float> zeroinitializer, <4 x float> [[LD]]
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %ld = load <4 x float>, <4 x float>* %x, align 16
  %cmp = fcmp olt <4 x float> %z, %y
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cond = bitcast <4 x i32> %sext to <4 x float>
  %r = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %ld, <4 x float> zeroinitializer, <4 x float> %cond)
  ret <4 x float> %r
}

define <2 x double> @sel_v2f64_sse_reality(<2 x double>* nocapture readonly %x, <2 x double> %y, <2 x double> %z) {
; CHECK-LABEL: @sel_v2f64_sse_reality(
; CHECK-NEXT:    [[LD:%.*]] = load <2 x double>, <2 x double>* [[X:%.*]], align 16
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt <2 x double> [[Z:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[CMP]], <2 x double> zeroinitializer, <2 x double> [[LD]]
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %ld = load <2 x double>, <2 x double>* %x, align 16
  %cmp = fcmp olt <2 x double> %z, %y
  %sext = sext <2 x i1> %cmp to <2 x i64>
  %cond = bitcast <2 x i64> %sext to <2 x double>
  %r = tail call <2 x double> @llvm.x86.sse41.blendvpd(<2 x double> %ld, <2 x double> zeroinitializer, <2 x double> %cond)
  ret <2 x double> %r
}

; Bitcast the inputs and the result and remove the intrinsic.

define <2 x i64> @sel_v4i32_sse_reality(<2 x i64>* nocapture readonly %x, <2 x i64> %y, <2 x i64> %z) {
; CHECK-LABEL: @sel_v4i32_sse_reality(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64>* [[X:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[LD1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 16
; CHECK-NEXT:    [[YCAST:%.*]] = bitcast <2 x i64> [[Y:%.*]] to <4 x i32>
; CHECK-NEXT:    [[ZCAST:%.*]] = bitcast <2 x i64> [[Z:%.*]] to <4 x i32>
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt <4 x i32> [[YCAST]], [[ZCAST]]
; CHECK-NEXT:    [[TMP2:%.*]] = select <4 x i1> [[CMP]], <4 x i32> zeroinitializer, <4 x i32> [[LD1]]
; CHECK-NEXT:    [[RCAST:%.*]] = bitcast <4 x i32> [[TMP2]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[RCAST]]
;
  %xcast = bitcast <2 x i64>* %x to <16 x i8>*
  %ld = load <16 x i8>, <16 x i8>* %xcast, align 16
  %ycast = bitcast <2 x i64> %y to <4 x i32>
  %zcast = bitcast <2 x i64> %z to <4 x i32>
  %cmp = icmp sgt <4 x i32> %ycast, %zcast
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cond = bitcast <4 x i32> %sext to <16 x i8>
  %r = tail call <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8> %ld, <16 x i8> zeroinitializer, <16 x i8> %cond)
  %rcast = bitcast <16 x i8> %r to <2 x i64>
  ret <2 x i64> %rcast
}

define <2 x i64> @sel_v16i8_sse_reality(<2 x i64>* nocapture readonly %x, <2 x i64> %y, <2 x i64> %z) {
; CHECK-LABEL: @sel_v16i8_sse_reality(
; CHECK-NEXT:    [[XCAST:%.*]] = bitcast <2 x i64>* [[X:%.*]] to <16 x i8>*
; CHECK-NEXT:    [[LD:%.*]] = load <16 x i8>, <16 x i8>* [[XCAST]], align 16
; CHECK-NEXT:    [[YCAST:%.*]] = bitcast <2 x i64> [[Y:%.*]] to <16 x i8>
; CHECK-NEXT:    [[ZCAST:%.*]] = bitcast <2 x i64> [[Z:%.*]] to <16 x i8>
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt <16 x i8> [[YCAST]], [[ZCAST]]
; CHECK-NEXT:    [[R:%.*]] = select <16 x i1> [[CMP]], <16 x i8> zeroinitializer, <16 x i8> [[LD]]
; CHECK-NEXT:    [[RCAST:%.*]] = bitcast <16 x i8> [[R]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[RCAST]]
;
  %xcast = bitcast <2 x i64>* %x to <16 x i8>*
  %ld = load <16 x i8>, <16 x i8>* %xcast, align 16
  %ycast = bitcast <2 x i64> %y to <16 x i8>
  %zcast = bitcast <2 x i64> %z to <16 x i8>
  %cmp = icmp sgt <16 x i8> %ycast, %zcast
  %sext = sext <16 x i1> %cmp to <16 x i8>
  %r = tail call <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8> %ld, <16 x i8> zeroinitializer, <16 x i8> %sext)
  %rcast = bitcast <16 x i8> %r to <2 x i64>
  ret <2 x i64> %rcast
}

declare <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8>, <16 x i8>, <16 x i8>)
declare <4 x float> @llvm.x86.sse41.blendvps(<4 x float>, <4 x float>, <4 x float>)
declare <2 x double> @llvm.x86.sse41.blendvpd(<2 x double>, <2 x double>, <2 x double>)

declare <32 x i8> @llvm.x86.avx2.pblendvb(<32 x i8>, <32 x i8>, <32 x i8>)
declare <8 x float> @llvm.x86.avx.blendv.ps.256(<8 x float>, <8 x float>, <8 x float>)
declare <4 x double> @llvm.x86.avx.blendv.pd.256(<4 x double>, <4 x double>, <4 x double>)

