// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple x86_64-unknown-unknown -emit-llvm -o - %s | FileCheck %s

// CHECK-LABEL: define {{[^@]+}}@test1
// CHECK-SAME: (i32* [[A:%.*]]) #0
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca i32*, align 8
// CHECK-NEXT:    store i32* [[A]], i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load i32*, i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[TMP0]] to i8*
// CHECK-NEXT:    [[PTRINT:%.*]] = ptrtoint i8* [[TMP1]] to i64
// CHECK-NEXT:    [[MASKEDPTR:%.*]] = and i64 [[PTRINT]], 31
// CHECK-NEXT:    [[MASKCOND:%.*]] = icmp eq i64 [[MASKEDPTR]], 0
// CHECK-NEXT:    call void @llvm.assume(i1 [[MASKCOND]])
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast i8* [[TMP1]] to i32*
// CHECK-NEXT:    store i32* [[TMP2]], i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP3:%.*]] = load i32*, i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[TMP3]], i64 0
// CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
// CHECK-NEXT:    ret i32 [[TMP4]]
//
int test1(int *a) {
  a = __builtin_assume_aligned(a, 32, 0ull);
  return a[0];
}

// CHECK-LABEL: define {{[^@]+}}@test2
// CHECK-SAME: (i32* [[A:%.*]]) #0
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca i32*, align 8
// CHECK-NEXT:    store i32* [[A]], i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load i32*, i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[TMP0]] to i8*
// CHECK-NEXT:    [[PTRINT:%.*]] = ptrtoint i8* [[TMP1]] to i64
// CHECK-NEXT:    [[MASKEDPTR:%.*]] = and i64 [[PTRINT]], 31
// CHECK-NEXT:    [[MASKCOND:%.*]] = icmp eq i64 [[MASKEDPTR]], 0
// CHECK-NEXT:    call void @llvm.assume(i1 [[MASKCOND]])
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast i8* [[TMP1]] to i32*
// CHECK-NEXT:    store i32* [[TMP2]], i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP3:%.*]] = load i32*, i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[TMP3]], i64 0
// CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
// CHECK-NEXT:    ret i32 [[TMP4]]
//
int test2(int *a) {
  a = __builtin_assume_aligned(a, 32, 0);
  return a[0];
}

// CHECK-LABEL: define {{[^@]+}}@test3
// CHECK-SAME: (i32* [[A:%.*]]) #0
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca i32*, align 8
// CHECK-NEXT:    store i32* [[A]], i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load i32*, i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[TMP0]] to i8*
// CHECK-NEXT:    [[PTRINT:%.*]] = ptrtoint i8* [[TMP1]] to i64
// CHECK-NEXT:    [[MASKEDPTR:%.*]] = and i64 [[PTRINT]], 31
// CHECK-NEXT:    [[MASKCOND:%.*]] = icmp eq i64 [[MASKEDPTR]], 0
// CHECK-NEXT:    call void @llvm.assume(i1 [[MASKCOND]])
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast i8* [[TMP1]] to i32*
// CHECK-NEXT:    store i32* [[TMP2]], i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP3:%.*]] = load i32*, i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[TMP3]], i64 0
// CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
// CHECK-NEXT:    ret i32 [[TMP4]]
//
int test3(int *a) {
  a = __builtin_assume_aligned(a, 32);
  return a[0];
}

// CHECK-LABEL: define {{[^@]+}}@test4
// CHECK-SAME: (i32* [[A:%.*]], i32 [[B:%.*]]) #0
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca i32*, align 8
// CHECK-NEXT:    [[B_ADDR:%.*]] = alloca i32, align 4
// CHECK-NEXT:    store i32* [[A]], i32** [[A_ADDR]], align 8
// CHECK-NEXT:    store i32 [[B]], i32* [[B_ADDR]], align 4
// CHECK-NEXT:    [[TMP0:%.*]] = load i32*, i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[TMP0]] to i8*
// CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[B_ADDR]], align 4
// CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[TMP2]] to i64
// CHECK-NEXT:    [[PTRINT:%.*]] = ptrtoint i8* [[TMP1]] to i64
// CHECK-NEXT:    [[OFFSETPTR:%.*]] = sub i64 [[PTRINT]], [[CONV]]
// CHECK-NEXT:    [[MASKEDPTR:%.*]] = and i64 [[OFFSETPTR]], 31
// CHECK-NEXT:    [[MASKCOND:%.*]] = icmp eq i64 [[MASKEDPTR]], 0
// CHECK-NEXT:    call void @llvm.assume(i1 [[MASKCOND]])
// CHECK-NEXT:    [[TMP3:%.*]] = bitcast i8* [[TMP1]] to i32*
// CHECK-NEXT:    store i32* [[TMP3]], i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP4:%.*]] = load i32*, i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i64 0
// CHECK-NEXT:    [[TMP5:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
// CHECK-NEXT:    ret i32 [[TMP5]]
//
int test4(int *a, int b) {
  a = __builtin_assume_aligned(a, 32, b);
  return a[0];
}

int *m1() __attribute__((assume_aligned(64)));

// CHECK-LABEL: define {{[^@]+}}@test5() #0
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[CALL:%.*]] = call align 64 i32* (...) @m1()
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[CALL]], align 4
// CHECK-NEXT:    ret i32 [[TMP0]]
//
int test5() {
  return *m1();
}

int *m2() __attribute__((assume_aligned(64, 12)));

// CHECK-LABEL: define {{[^@]+}}@test6() #0
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[CALL:%.*]] = call i32* (...) @m2()
// CHECK-NEXT:    [[PTRINT:%.*]] = ptrtoint i32* [[CALL]] to i64
// CHECK-NEXT:    [[OFFSETPTR:%.*]] = sub i64 [[PTRINT]], 12
// CHECK-NEXT:    [[MASKEDPTR:%.*]] = and i64 [[OFFSETPTR]], 63
// CHECK-NEXT:    [[MASKCOND:%.*]] = icmp eq i64 [[MASKEDPTR]], 0
// CHECK-NEXT:    call void @llvm.assume(i1 [[MASKCOND]])
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[CALL]], align 4
// CHECK-NEXT:    ret i32 [[TMP0]]
//
int test6() {
  return *m2();
}

// CHECK-LABEL: define {{[^@]+}}@pr43638
// CHECK-SAME: (i32* [[A:%.*]]) #0
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca i32*, align 8
// CHECK-NEXT:    store i32* [[A]], i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load i32*, i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[TMP0]] to i8*
// CHECK-NEXT:    [[PTRINT:%.*]] = ptrtoint i8* [[TMP1]] to i64
// CHECK-NEXT:    [[MASKEDPTR:%.*]] = and i64 [[PTRINT]], 536870911
// CHECK-NEXT:    [[MASKCOND:%.*]] = icmp eq i64 [[MASKEDPTR]], 0
// CHECK-NEXT:    call void @llvm.assume(i1 [[MASKCOND]])
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast i8* [[TMP1]] to i32*
// CHECK-NEXT:    store i32* [[TMP2]], i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP3:%.*]] = load i32*, i32** [[A_ADDR]], align 8
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[TMP3]], i64 0
// CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
// CHECK-NEXT:    ret i32 [[TMP4]]
//
int pr43638(int *a) {
  a = __builtin_assume_aligned(a, 4294967296);
return a[0];
}
