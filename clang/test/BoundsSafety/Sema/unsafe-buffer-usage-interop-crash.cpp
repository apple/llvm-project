// RUN: %clang_cc1 -std=c++20 -Wno-all -fexperimental-bounds-safety-attributes -verify %s
#include <ptrcheck.h>
typedef unsigned size_t;
class MyClass {
  size_t m;
  int q[__counted_by(m)]; // expected-error{{arrow notation not allowed for struct member in count parameter}}

  // The error is because we do not have FAM support right now.  Previously, this example will crash.
};
