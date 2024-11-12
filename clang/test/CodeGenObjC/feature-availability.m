// RUN: %clang_cc1 -triple arm64-apple-macosx -fblocks -ffeature-availability=feature1:on -ffeature-availability=feature2:off -emit-llvm -o - %s | FileCheck %s

// CHECK: @"OBJC_CLASS_$_C0" =
// CHECK: @"OBJC_METACLASS_$_C0" =
// CHECK: @OBJC_CLASS_NAME_ = private unnamed_addr constant [3 x i8] c"C0\00",
// CHECK: @"_OBJC_METACLASS_RO_$_C0" =
// CHECK: @OBJC_METH_VAR_NAME_ = private unnamed_addr constant [3 x i8] c"m0\00",
// CHECK: @"_OBJC_$_INSTANCE_METHODS_C0" =
// CHECK: @"_OBJC_CLASS_RO_$_C0" =
// CHECK: @OBJC_CLASS_NAME_.1 = private unnamed_addr constant [5 x i8] c"Cat0\00",
// CHECK-NOT: C1
// CHECK-NOT: Cat1
// CHECK: @"OBJC_LABEL_CLASS_$" = private global [1 x ptr] [ptr @"OBJC_CLASS_$_C0"], section "__DATA,__objc_classlist,regular,no_dead_strip", align 8

__attribute__((feature(feature1)))
@interface C0
-(void)m0;
@end

// CHECK: define internal void @"\01-[C0 m0]"(

@implementation C0
-(void)m0 {
}
@end

@interface C0(Cat0)
@end

@implementation C0(Cat0)
@end

__attribute__((feature(feature2)))
@interface C1
-(void)m1;
@end

// CHECK-NOT: void @"\01-[C1 m1]"(
@implementation C1
-(void)m1 {
}
@end

@interface C1(Cat1)
@end

@implementation C1(Cat1)
@end

