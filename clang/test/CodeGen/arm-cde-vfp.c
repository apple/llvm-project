// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple thumbv8.1m.main-arm-none-eabi \
// RUN:   -target-feature +cdecp0 -target-feature +cdecp1 \
// RUN:   -mfloat-abi hard -O0 -disable-O0-optnone \
// RUN:   -S -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s

#include <arm_cde.h>

// CHECK-LABEL: @test_vcx1_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call float @llvm.arm.cde.vcx1.f32(i32 0, i32 11)
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast float [[TMP0]] to i32
// CHECK-NEXT:    ret i32 [[TMP1]]
//
uint32_t test_vcx1_u32(void) {
  return __arm_vcx1_u32(0, 11);
}

// CHECK-LABEL: @test_vcx1a_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32 [[ACC:%.*]] to float
// CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.arm.cde.vcx1a.f32(i32 1, float [[TMP0]], i32 12)
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast float [[TMP1]] to i32
// CHECK-NEXT:    ret i32 [[TMP2]]
//
uint32_t test_vcx1a_u32(uint32_t acc) {
  return __arm_vcx1a_u32(1, acc, 12);
}

// CHECK-LABEL: @test_vcx2_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32 [[N:%.*]] to float
// CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.arm.cde.vcx2.f32(i32 0, float [[TMP0]], i32 21)
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast float [[TMP1]] to i32
// CHECK-NEXT:    ret i32 [[TMP2]]
//
uint32_t test_vcx2_u32(uint32_t n) {
  return __arm_vcx2_u32(0, n, 21);
}

// CHECK-LABEL: @test_vcx2a_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32 [[ACC:%.*]] to float
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32 [[N:%.*]] to float
// CHECK-NEXT:    [[TMP2:%.*]] = call float @llvm.arm.cde.vcx2a.f32(i32 0, float [[TMP0]], float [[TMP1]], i32 22)
// CHECK-NEXT:    [[TMP3:%.*]] = bitcast float [[TMP2]] to i32
// CHECK-NEXT:    ret i32 [[TMP3]]
//
uint32_t test_vcx2a_u32(uint32_t acc, uint32_t n) {
  return __arm_vcx2a_u32(0, acc, n, 22);
}

// CHECK-LABEL: @test_vcx3_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32 [[N:%.*]] to float
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32 [[M:%.*]] to float
// CHECK-NEXT:    [[TMP2:%.*]] = call float @llvm.arm.cde.vcx3.f32(i32 1, float [[TMP0]], float [[TMP1]], i32 3)
// CHECK-NEXT:    [[TMP3:%.*]] = bitcast float [[TMP2]] to i32
// CHECK-NEXT:    ret i32 [[TMP3]]
//
uint32_t test_vcx3_u32(uint32_t n, uint32_t m) {
  return __arm_vcx3_u32(1, n, m, 3);
}

// CHECK-LABEL: @test_vcx3a_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32 [[ACC:%.*]] to float
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32 [[N:%.*]] to float
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32 [[M:%.*]] to float
// CHECK-NEXT:    [[TMP3:%.*]] = call float @llvm.arm.cde.vcx3a.f32(i32 0, float [[TMP0]], float [[TMP1]], float [[TMP2]], i32 5)
// CHECK-NEXT:    [[TMP4:%.*]] = bitcast float [[TMP3]] to i32
// CHECK-NEXT:    ret i32 [[TMP4]]
//
uint32_t test_vcx3a_u32(uint32_t acc, uint32_t n, uint32_t m) {
  return __arm_vcx3a_u32(0, acc, n, m, 5);
}

// CHECK-LABEL: @test_vcx1d_u64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call double @llvm.arm.cde.vcx1.f64(i32 0, i32 11)
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast double [[TMP0]] to i64
// CHECK-NEXT:    ret i64 [[TMP1]]
//
uint64_t test_vcx1d_u64(void) {
  return __arm_vcx1d_u64(0, 11);
}

// CHECK-LABEL: @test_vcx1da_u64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i64 [[ACC:%.*]] to double
// CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.arm.cde.vcx1a.f64(i32 1, double [[TMP0]], i32 12)
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast double [[TMP1]] to i64
// CHECK-NEXT:    ret i64 [[TMP2]]
//
uint64_t test_vcx1da_u64(uint64_t acc) {
  return __arm_vcx1da_u64(1, acc, 12);
}

// CHECK-LABEL: @test_vcx2d_u64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i64 [[N:%.*]] to double
// CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.arm.cde.vcx2.f64(i32 0, double [[TMP0]], i32 21)
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast double [[TMP1]] to i64
// CHECK-NEXT:    ret i64 [[TMP2]]
//
uint64_t test_vcx2d_u64(uint64_t n) {
  return __arm_vcx2d_u64(0, n, 21);
}

// CHECK-LABEL: @test_vcx2da_u64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i64 [[ACC:%.*]] to double
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i64 [[N:%.*]] to double
// CHECK-NEXT:    [[TMP2:%.*]] = call double @llvm.arm.cde.vcx2a.f64(i32 0, double [[TMP0]], double [[TMP1]], i32 22)
// CHECK-NEXT:    [[TMP3:%.*]] = bitcast double [[TMP2]] to i64
// CHECK-NEXT:    ret i64 [[TMP3]]
//
uint64_t test_vcx2da_u64(uint64_t acc, uint64_t n) {
  return __arm_vcx2da_u64(0, acc, n, 22);
}

// CHECK-LABEL: @test_vcx3d_u64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i64 [[N:%.*]] to double
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i64 [[M:%.*]] to double
// CHECK-NEXT:    [[TMP2:%.*]] = call double @llvm.arm.cde.vcx3.f64(i32 1, double [[TMP0]], double [[TMP1]], i32 3)
// CHECK-NEXT:    [[TMP3:%.*]] = bitcast double [[TMP2]] to i64
// CHECK-NEXT:    ret i64 [[TMP3]]
//
uint64_t test_vcx3d_u64(uint64_t n, uint64_t m) {
  return __arm_vcx3d_u64(1, n, m, 3);
}

// CHECK-LABEL: @test_vcx3da_u64(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast i64 [[ACC:%.*]] to double
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i64 [[N:%.*]] to double
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast i64 [[M:%.*]] to double
// CHECK-NEXT:    [[TMP3:%.*]] = call double @llvm.arm.cde.vcx3a.f64(i32 0, double [[TMP0]], double [[TMP1]], double [[TMP2]], i32 5)
// CHECK-NEXT:    [[TMP4:%.*]] = bitcast double [[TMP3]] to i64
// CHECK-NEXT:    ret i64 [[TMP4]]
//
uint64_t test_vcx3da_u64(uint64_t acc, uint64_t n, uint64_t m) {
  return __arm_vcx3da_u64(0, acc, n, m, 5);
}
