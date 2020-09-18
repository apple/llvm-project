// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
 // RUN: %clang_cc1 -triple thumbv8.1m.main-none-none-eabi -target-feature +mve -mfloat-abi hard -O0 -disable-O0-optnone -S -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s
 // RUN: %clang_cc1 -triple thumbv8.1m.main-none-none-eabi -target-feature +mve -mfloat-abi hard -O0 -disable-O0-optnone -DPOLYMORPHIC -S -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s

#include <arm_mve.h>

// CHECK-LABEL: @test_vaddvq_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v16i8(<16 x i8> [[A:%.*]], i32 0)
// CHECK-NEXT:    ret i32 [[TMP0]]
//
int32_t test_vaddvq_s8(int8x16_t a) {
#ifdef POLYMORPHIC
  return vaddvq(a);
#else  /* POLYMORPHIC */
  return vaddvq_s8(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v8i16(<8 x i16> [[A:%.*]], i32 0)
// CHECK-NEXT:    ret i32 [[TMP0]]
//
int32_t test_vaddvq_s16(int16x8_t a) {
#ifdef POLYMORPHIC
  return vaddvq(a);
#else  /* POLYMORPHIC */
  return vaddvq_s16(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v4i32(<4 x i32> [[A:%.*]], i32 0)
// CHECK-NEXT:    ret i32 [[TMP0]]
//
int32_t test_vaddvq_s32(int32x4_t a) {
#ifdef POLYMORPHIC
  return vaddvq(a);
#else  /* POLYMORPHIC */
  return vaddvq_s32(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_u8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v16i8(<16 x i8> [[A:%.*]], i32 1)
// CHECK-NEXT:    ret i32 [[TMP0]]
//
uint32_t test_vaddvq_u8(uint8x16_t a) {
#ifdef POLYMORPHIC
  return vaddvq(a);
#else  /* POLYMORPHIC */
  return vaddvq_u8(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v8i16(<8 x i16> [[A:%.*]], i32 1)
// CHECK-NEXT:    ret i32 [[TMP0]]
//
uint32_t test_vaddvq_u16(uint16x8_t a) {
#ifdef POLYMORPHIC
  return vaddvq(a);
#else  /* POLYMORPHIC */
  return vaddvq_u16(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v4i32(<4 x i32> [[A:%.*]], i32 1)
// CHECK-NEXT:    ret i32 [[TMP0]]
//
uint32_t test_vaddvq_u32(uint32x4_t a) {
#ifdef POLYMORPHIC
  return vaddvq(a);
#else  /* POLYMORPHIC */
  return vaddvq_u32(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v16i8(<16 x i8> [[B:%.*]], i32 0)
// CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP1]]
//
int32_t test_vaddvaq_s8(int32_t a, int8x16_t b) {
#ifdef POLYMORPHIC
  return vaddvaq(a, b);
#else  /* POLYMORPHIC */
  return vaddvaq_s8(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v8i16(<8 x i16> [[B:%.*]], i32 0)
// CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP1]]
//
int32_t test_vaddvaq_s16(int32_t a, int16x8_t b) {
#ifdef POLYMORPHIC
  return vaddvaq(a, b);
#else  /* POLYMORPHIC */
  return vaddvaq_s16(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v4i32(<4 x i32> [[B:%.*]], i32 0)
// CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP1]]
//
int32_t test_vaddvaq_s32(int32_t a, int32x4_t b) {
#ifdef POLYMORPHIC
  return vaddvaq(a, b);
#else  /* POLYMORPHIC */
  return vaddvaq_s32(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_u8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v16i8(<16 x i8> [[B:%.*]], i32 1)
// CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP1]]
//
uint32_t test_vaddvaq_u8(uint32_t a, uint8x16_t b) {
#ifdef POLYMORPHIC
  return vaddvaq(a, b);
#else  /* POLYMORPHIC */
  return vaddvaq_u8(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v8i16(<8 x i16> [[B:%.*]], i32 1)
// CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP1]]
//
uint32_t test_vaddvaq_u16(uint32_t a, uint16x8_t b) {
#ifdef POLYMORPHIC
  return vaddvaq(a, b);
#else  /* POLYMORPHIC */
  return vaddvaq_u16(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.arm.mve.addv.v4i32(<4 x i32> [[B:%.*]], i32 1)
// CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP1]]
//
uint32_t test_vaddvaq_u32(uint32_t a, uint32x4_t b) {
#ifdef POLYMORPHIC
  return vaddvaq(a, b);
#else  /* POLYMORPHIC */
  return vaddvaq_u32(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_p_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], i32 0, <16 x i1> [[TMP1]])
// CHECK-NEXT:    ret i32 [[TMP2]]
//
int32_t test_vaddvq_p_s8(int8x16_t a, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvq_p(a, p);
#else  /* POLYMORPHIC */
  return vaddvq_p_s8(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_p_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], i32 0, <8 x i1> [[TMP1]])
// CHECK-NEXT:    ret i32 [[TMP2]]
//
int32_t test_vaddvq_p_s16(int16x8_t a, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvq_p(a, p);
#else  /* POLYMORPHIC */
  return vaddvq_p_s16(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_p_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], i32 0, <4 x i1> [[TMP1]])
// CHECK-NEXT:    ret i32 [[TMP2]]
//
int32_t test_vaddvq_p_s32(int32x4_t a, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvq_p(a, p);
#else  /* POLYMORPHIC */
  return vaddvq_p_s32(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_p_u8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], i32 1, <16 x i1> [[TMP1]])
// CHECK-NEXT:    ret i32 [[TMP2]]
//
uint32_t test_vaddvq_p_u8(uint8x16_t a, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvq_p(a, p);
#else  /* POLYMORPHIC */
  return vaddvq_p_u8(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_p_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], i32 1, <8 x i1> [[TMP1]])
// CHECK-NEXT:    ret i32 [[TMP2]]
//
uint32_t test_vaddvq_p_u16(uint16x8_t a, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvq_p(a, p);
#else  /* POLYMORPHIC */
  return vaddvq_p_u16(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvq_p_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], i32 1, <4 x i1> [[TMP1]])
// CHECK-NEXT:    ret i32 [[TMP2]]
//
uint32_t test_vaddvq_p_u32(uint32x4_t a, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvq_p(a, p);
#else  /* POLYMORPHIC */
  return vaddvq_p_u32(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_p_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v16i8.v16i1(<16 x i8> [[B:%.*]], i32 0, <16 x i1> [[TMP1]])
// CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP3]]
//
int32_t test_vaddvaq_p_s8(int32_t a, int8x16_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvaq_p(a, b, p);
#else  /* POLYMORPHIC */
  return vaddvaq_p_s8(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_p_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> [[B:%.*]], i32 0, <8 x i1> [[TMP1]])
// CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP3]]
//
int32_t test_vaddvaq_p_s16(int32_t a, int16x8_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvaq_p(a, b, p);
#else  /* POLYMORPHIC */
  return vaddvaq_p_s16(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_p_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> [[B:%.*]], i32 0, <4 x i1> [[TMP1]])
// CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP3]]
//
int32_t test_vaddvaq_p_s32(int32_t a, int32x4_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvaq_p(a, b, p);
#else  /* POLYMORPHIC */
  return vaddvaq_p_s32(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_p_u8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v16i8.v16i1(<16 x i8> [[B:%.*]], i32 1, <16 x i1> [[TMP1]])
// CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP3]]
//
uint32_t test_vaddvaq_p_u8(uint32_t a, uint8x16_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvaq_p(a, b, p);
#else  /* POLYMORPHIC */
  return vaddvaq_p_u8(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_p_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> [[B:%.*]], i32 1, <8 x i1> [[TMP1]])
// CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP3]]
//
uint32_t test_vaddvaq_p_u16(uint32_t a, uint16x8_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvaq_p(a, b, p);
#else  /* POLYMORPHIC */
  return vaddvaq_p_u16(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddvaq_p_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> [[B:%.*]], i32 1, <4 x i1> [[TMP1]])
// CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    ret i32 [[TMP3]]
//
uint32_t test_vaddvaq_p_u32(uint32_t a, uint32x4_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddvaq_p(a, b, p);
#else  /* POLYMORPHIC */
  return vaddvaq_p_u32(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddlvq_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.arm.mve.addlv.v4i32(<4 x i32> [[A:%.*]], i32 0)
// CHECK-NEXT:    ret i64 [[TMP0]]
//
int64_t test_vaddlvq_s32(int32x4_t a) {
#ifdef POLYMORPHIC
  return vaddlvq(a);
#else  /* POLYMORPHIC */
  return vaddlvq_s32(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddlvq_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.arm.mve.addlv.v4i32(<4 x i32> [[A:%.*]], i32 1)
// CHECK-NEXT:    ret i64 [[TMP0]]
//
uint64_t test_vaddlvq_u32(uint32x4_t a) {
#ifdef POLYMORPHIC
  return vaddlvq(a);
#else  /* POLYMORPHIC */
  return vaddlvq_u32(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddlvaq_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.arm.mve.addlv.v4i32(<4 x i32> [[B:%.*]], i32 0)
// CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[TMP0]], [[A:%.*]]
// CHECK-NEXT:    ret i64 [[TMP1]]
//
int64_t test_vaddlvaq_s32(int64_t a, int32x4_t b) {
#ifdef POLYMORPHIC
  return vaddlvaq(a, b);
#else  /* POLYMORPHIC */
  return vaddlvaq_s32(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddlvaq_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.arm.mve.addlv.v4i32(<4 x i32> [[B:%.*]], i32 1)
// CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[TMP0]], [[A:%.*]]
// CHECK-NEXT:    ret i64 [[TMP1]]
//
uint64_t test_vaddlvaq_u32(uint64_t a, uint32x4_t b) {
#ifdef POLYMORPHIC
  return vaddlvaq(a, b);
#else  /* POLYMORPHIC */
  return vaddlvaq_u32(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddlvq_p_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.arm.mve.addlv.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], i32 0, <4 x i1> [[TMP1]])
// CHECK-NEXT:    ret i64 [[TMP2]]
//
int64_t test_vaddlvq_p_s32(int32x4_t a, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddlvq_p(a, p);
#else  /* POLYMORPHIC */
  return vaddlvq_p_s32(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddlvq_p_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.arm.mve.addlv.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], i32 1, <4 x i1> [[TMP1]])
// CHECK-NEXT:    ret i64 [[TMP2]]
//
uint64_t test_vaddlvq_p_u32(uint32x4_t a, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddlvq_p(a, p);
#else  /* POLYMORPHIC */
  return vaddlvq_p_u32(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddlvaq_p_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.arm.mve.addlv.predicated.v4i32.v4i1(<4 x i32> [[B:%.*]], i32 0, <4 x i1> [[TMP1]])
// CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    ret i64 [[TMP3]]
//
int64_t test_vaddlvaq_p_s32(int64_t a, int32x4_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddlvaq_p(a, b, p);
#else  /* POLYMORPHIC */
  return vaddlvaq_p_s32(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vaddlvaq_p_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.arm.mve.addlv.predicated.v4i32.v4i1(<4 x i32> [[B:%.*]], i32 1, <4 x i1> [[TMP1]])
// CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    ret i64 [[TMP3]]
//
uint64_t test_vaddlvaq_p_u32(uint64_t a, uint32x4_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vaddlvaq_p(a, b, p);
#else  /* POLYMORPHIC */
  return vaddlvaq_p_u32(a, b, p);
#endif /* POLYMORPHIC */
}

