// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple thumbv8.1m.main-none-none-eabi -target-feature +mve.fp -mfloat-abi hard -fallow-half-arguments-and-returns -O3 -disable-O0-optnone -S -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s
// RUN: %clang_cc1 -triple thumbv8.1m.main-none-none-eabi -target-feature +mve.fp -mfloat-abi hard -fallow-half-arguments-and-returns -O3 -disable-O0-optnone -DPOLYMORPHIC -S -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s

#include <arm_mve.h>

// CHECK-LABEL: @test_vmaxaq_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = icmp slt <16 x i8> [[B:%.*]], zeroinitializer
// CHECK-NEXT:    [[TMP1:%.*]] = sub <16 x i8> zeroinitializer, [[B]]
// CHECK-NEXT:    [[TMP2:%.*]] = select <16 x i1> [[TMP0]], <16 x i8> [[TMP1]], <16 x i8> [[B]]
// CHECK-NEXT:    [[TMP3:%.*]] = icmp ugt <16 x i8> [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    [[TMP4:%.*]] = select <16 x i1> [[TMP3]], <16 x i8> [[TMP2]], <16 x i8> [[A]]
// CHECK-NEXT:    ret <16 x i8> [[TMP4]]
//
uint8x16_t test_vmaxaq_s8(uint8x16_t a, int8x16_t b)
{
#ifdef POLYMORPHIC
    return vmaxaq(a, b);
#else /* POLYMORPHIC */
    return vmaxaq_s8(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmaxaq_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = icmp slt <8 x i16> [[B:%.*]], zeroinitializer
// CHECK-NEXT:    [[TMP1:%.*]] = sub <8 x i16> zeroinitializer, [[B]]
// CHECK-NEXT:    [[TMP2:%.*]] = select <8 x i1> [[TMP0]], <8 x i16> [[TMP1]], <8 x i16> [[B]]
// CHECK-NEXT:    [[TMP3:%.*]] = icmp ugt <8 x i16> [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    [[TMP4:%.*]] = select <8 x i1> [[TMP3]], <8 x i16> [[TMP2]], <8 x i16> [[A]]
// CHECK-NEXT:    ret <8 x i16> [[TMP4]]
//
uint16x8_t test_vmaxaq_s16(uint16x8_t a, int16x8_t b)
{
#ifdef POLYMORPHIC
    return vmaxaq(a, b);
#else /* POLYMORPHIC */
    return vmaxaq_s16(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmaxaq_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = icmp slt <4 x i32> [[B:%.*]], zeroinitializer
// CHECK-NEXT:    [[TMP1:%.*]] = sub <4 x i32> zeroinitializer, [[B]]
// CHECK-NEXT:    [[TMP2:%.*]] = select <4 x i1> [[TMP0]], <4 x i32> [[TMP1]], <4 x i32> [[B]]
// CHECK-NEXT:    [[TMP3:%.*]] = icmp ugt <4 x i32> [[TMP2]], [[A:%.*]]
// CHECK-NEXT:    [[TMP4:%.*]] = select <4 x i1> [[TMP3]], <4 x i32> [[TMP2]], <4 x i32> [[A]]
// CHECK-NEXT:    ret <4 x i32> [[TMP4]]
//
uint32x4_t test_vmaxaq_s32(uint32x4_t a, int32x4_t b)
{
#ifdef POLYMORPHIC
    return vmaxaq(a, b);
#else /* POLYMORPHIC */
    return vmaxaq_s32(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmaxaq_m_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = tail call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = tail call <16 x i8> @llvm.arm.mve.vmaxa.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], <16 x i8> [[B:%.*]], <16 x i1> [[TMP1]])
// CHECK-NEXT:    ret <16 x i8> [[TMP2]]
//
uint8x16_t test_vmaxaq_m_s8(uint8x16_t a, int8x16_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmaxaq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmaxaq_m_s8(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmaxaq_m_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = tail call <8 x i16> @llvm.arm.mve.vmaxa.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], <8 x i16> [[B:%.*]], <8 x i1> [[TMP1]])
// CHECK-NEXT:    ret <8 x i16> [[TMP2]]
//
uint16x8_t test_vmaxaq_m_s16(uint16x8_t a, int16x8_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmaxaq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmaxaq_m_s16(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmaxaq_m_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = tail call <4 x i32> @llvm.arm.mve.vmaxa.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], <4 x i32> [[B:%.*]], <4 x i1> [[TMP1]])
// CHECK-NEXT:    ret <4 x i32> [[TMP2]]
//
uint32x4_t test_vmaxaq_m_s32(uint32x4_t a, int32x4_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmaxaq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmaxaq_m_s32(a, b, p);
#endif /* POLYMORPHIC */
}
