//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// UNSUPPORTED: libcpp-has-no-threads
//  ... test crashes clang

// <atomic>

// template <class Integral>
//     Integral
//     atomic_fetch_add_explicit(volatile atomic<Integral>* obj, Integral op,
//                               memory_order m);
// template <class Integral>
//     Integral
//     atomic_fetch_add_explicit(atomic<Integral>* obj, Integral op,
//                               memory_order m);
// template <class T>
//     T*
//     atomic_fetch_add_explicit(volatile atomic<T*>* obj, ptrdiff_t op,
//                               memory_order m);
// template <class T>
//     T*
//     atomic_fetch_add_explicit(atomic<T*>* obj, ptrdiff_t op, memory_order m);

#include <atomic>
#include <type_traits>
#include <cassert>

#include "test_macros.h"
#include "atomic_helpers.h"

template <class T>
struct TestFn {
  void operator()() const {
    {
        typedef std::atomic<T> A;
        A t;
        std::atomic_init(&t, T(1));
        assert(std::atomic_fetch_add_explicit(&t, T(2),
                                            std::memory_order_seq_cst) == T(1));
        assert(t == T(3));
    }
    {
        typedef std::atomic<T> A;
        volatile A t;
        std::atomic_init(&t, T(1));
        assert(std::atomic_fetch_add_explicit(&t, T(2),
                                            std::memory_order_seq_cst) == T(1));
        assert(t == T(3));
    }
  }
};

template <class T>
void
testp()
{
    {
        typedef std::atomic<T> A;
        typedef typename std::remove_pointer<T>::type X;
        A t;
        std::atomic_init(&t, T(1*sizeof(X)));
        assert(std::atomic_fetch_add_explicit(&t, 2,
                                  std::memory_order_seq_cst) == T(1*sizeof(X)));
        std::atomic_fetch_add_explicit<X>(&t, 0, std::memory_order_relaxed);
        assert(t == T(3*sizeof(X)));
    }
    {
        typedef std::atomic<T> A;
        typedef typename std::remove_pointer<T>::type X;
        volatile A t;
        std::atomic_init(&t, T(1*sizeof(X)));
        assert(std::atomic_fetch_add_explicit(&t, 2,
                                  std::memory_order_seq_cst) == T(1*sizeof(X)));
        std::atomic_fetch_add_explicit<X>(&t, 0, std::memory_order_relaxed);
        assert(t == T(3*sizeof(X)));
    }
}

int main(int, char**)
{
    TestEachIntegralType<TestFn>()();
    testp<int*>();
    testp<const int*>();

  return 0;
}
