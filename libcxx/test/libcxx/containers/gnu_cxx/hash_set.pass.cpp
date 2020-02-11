//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//


// Prevent emission of the deprecated warning.
#ifdef __clang__
#pragma clang diagnostic ignored "-W#warnings"
#endif

#include <ext/hash_set>
#include <cassert>

#include "test_macros.h"
#include "count_new.h"

void test_default_does_not_allocate() {
  DisableAllocationGuard g;
  ((void)g);
  {
    __gnu_cxx::hash_set<int> h;
    assert(h.bucket_count() == 0);
  }
  {
    __gnu_cxx::hash_multiset<int> h;
    assert(h.bucket_count() == 0);
  }
}

int main(int, char**) {
  test_default_does_not_allocate();
}
