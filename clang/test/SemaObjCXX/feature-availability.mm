// RUN: %clang_cc1 -fblocks -ffeature-availability=feature1:on -ffeature-availability=feature2:on -fsyntax-only -verify %s

void func0();
__attribute__((feature(feature1))) int func1();
__attribute__((feature(feature2))) void func2();

__attribute__((feature(feature1))) extern int g0;
__attribute__((feature(feature1))) int g1;
int g2 = func1(); // expected-error {{use of 'func1' needs guard for feature feature1}}
__attribute__((feature(feature1))) int g3 = func1();

struct S0 {
  void m0() {
    func1(); // expected-error{{use of 'func1' needs guard for feature feature1}}
  }
  __attribute__((feature(feature1))) void m1();
  __attribute__((feature(feature1))) int d1;
};

struct __attribute__((feature(feature1))) S1 {
  void m0() {
    func1();
    func2(); // expected-error{{use of 'func2' needs guard for feature feature2}}
  }
  __attribute__((feature(feature2))) void m1();
  __attribute__((feature(feature2))) int d1;
};

struct S2 {
  S1 s1; // expected-error{{use of 'S1' needs guard for feature feature1}}
};

struct __attribute__((feature(feature2))) S3 : S1 {}; // expected-error {{use of 'S1' needs guard for feature feature1}}
struct __attribute__((feature(feature1))) S4 : S1 {};

__attribute__((feature(feature1)))
@interface Base0
@end

@interface Derived0 : Base0 { // expected-error {{use of 'Base0' needs guard for feature feature1}}
  S1 *ivar0; // expected-error {{use of 'S1' needs guard for feature feature1}}
}
@property S1 *p0; // expected-error {{use of 'S1' needs guard for feature feature1}}
@property int p1 __attribute__((feature(feature1)));
@end

@interface Derived0()
@property S1 *p0_Ext; // expected-error {{use of 'S1' needs guard for feature feature1}}
@end

@implementation Derived0
-(void)m0 {
  func1(); // expected-error {{use of 'func1' needs guard for feature feature1}}
}
-(void)m1 {
  self.p1 = 1; // expected-error {{use of 'setP1:' needs guard for feature feature1}}
}
@end

@interface Derived0(C0)
@property S1 *p0_C0; // expected-error {{use of 'S1' needs guard for feature feature1}}
@end

__attribute__((feature(feature1)))
@interface Derived1 : Base0 {
  S1 *ivar0;
}
@property S1 *p0;
@end

@interface Derived1()
@property S1 *p0_Ext;
@end

@implementation Derived1
-(void)m0 {
  func1();
}
@end

@interface Derived1(C0)
@property S1 *p0_C0;
@end

@protocol P0
@property S1 *p0; // expected-error {{use of 'S1' needs guard for feature feature1}}
@end

void test0(S0 *s0) {
  func0();
  func1(); // expected-error{{use of 'func1' needs guard for feature feature1}}
  s0->m0();
  s0->m1(); // expected-error{{use of 'm1' needs guard for feature feature1}}
  s0->d1 = 0; // expected-error{{use of 'd1' needs guard for feature feature1}}

  if (__builtin_feature(feature1))
    if (__builtin_feature(feature2))
      func1();

  if (__builtin_feature(feature2))
    func1(); // expected-error{{use of 'func1' needs guard for feature feature1}}

  if (__builtin_feature(feature1))
    label0: // expected-error{{labels cannot appear in regions conditionally guarded by features}}
      ;

  if (__builtin_feature(feature1)) {
    [](){
      func1();
      func2(); // expected-error{{use of 'func2' needs guard for feature feature2}}
    }();

    ^{
      func1();
      func2(); // expected-error{{use of 'func2' needs guard for feature feature2}}
    }();
  }

  label1:
    ;
}

__attribute__((feature(feature1)))
void test1(S0 *s0) {
  func0();
  func1();
  s0->m0();
  s0->m1();
  s0->d1 = 0;

  if (__builtin_feature(feature1))
    if (__builtin_feature(feature2))
      func1();

  if (__builtin_feature(feature2))
    func1();

  if (__builtin_feature(feature1))
    label0: // expected-error{{labels cannot appear in regions conditionally guarded by features}}
      ;

  if (__builtin_feature(feature1)) {
    [](){
      func1();
      func2(); // expected-error{{use of 'func2' needs guard for feature feature2}}
    }();

    ^{
      func1();
      func2(); // expected-error{{use of 'func2' needs guard for feature feature2}}
    }();
  }

  label1:
    ;
}

void test2(S1 *s1) { // expected-error{{use of 'S1' needs guard for feature feature1}}
  s1->m1(); // expected-error{{use of 'm1' needs guard for feature feature2}}
  s1->d1 = 0; // expected-error{{use of 'd1' needs guard for feature feature2}}

  if (__builtin_feature(feature1)) {
    s1->m1(); // expected-error{{use of 'm1' needs guard for feature feature2}}
    s1->d1 = 0; // expected-error{{use of 'd1' needs guard for feature feature2}}
  }

  if (__builtin_feature(feature2)) {
    s1->m1();
    s1->d1 = 0;
  }

  if (__builtin_feature(feature1))
    if (__builtin_feature(feature2)) {
      s1->m1();
      s1->d1 = 0;
    }
}
