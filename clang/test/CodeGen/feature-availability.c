// RUN: %clang_cc1 -triple arm64-apple-macosx -fblocks -ffeature-availability=feature1:on -ffeature-availability=feature2:off -emit-llvm -o - %s | FileCheck %s

// CHECK: %[[STRUCT_S0:.*]] = type { i32 }
// CHECK: @g0 = external global i32, align 4
// CHECK-NOT: @g1
// CHECK-NOT: @g2

__attribute__((feature(feature1))) int func0(void);
__attribute__((feature(feature2))) int func1(void);
int func2(void);

__attribute__((feature(feature1))) extern int g0;
__attribute__((feature(feature2))) int g1 = 100;
__attribute__((feature(feature2))) int g2;

struct __attribute__((feature(feature1))) S0 {
  int d0;
};

// CHECK-LABEL: define void @test0()
// CHECK-NOT: br
// CHECK: call i32 @func0()
// CHECK: store i32 123, ptr @g0, align 4
// CHECK-NOT: func1()
// CHECK-NOT: func2()
void test0(void) {
  if (__builtin_feature(feature1)) {
    func0();
    g0 = 123;
  }

  if (__builtin_feature(feature2)) {
    func1();
    g1 = 123;
  }

  if (__builtin_feature(feature1))
    if (__builtin_feature(feature2)) {
      func2();
    }
}

// CHECK-LABEL: define void @test1()
__attribute__((feature(feature1)))
void test1(void) {
}

// CHECK-NOT: @test2(
__attribute__((feature(feature2)))
void test2(void) {
}

// CHECK-LABEL: define void @test3(
// CHECK: %[[D0:.*]] = getelementptr inbounds nuw %[[STRUCT_S0]], ptr %{{.*}}, i32 0, i32 0
// CHECK: store i32 134, ptr %[[D0]], align 4
__attribute__((feature(feature1)))
void test3(struct S0 *s0) {
  s0->d0 = 134;
}
