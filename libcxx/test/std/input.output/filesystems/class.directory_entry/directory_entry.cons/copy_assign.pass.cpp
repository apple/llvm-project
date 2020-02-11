//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// UNSUPPORTED: c++98, c++03

// <filesystem>

// class directory_entry

// directory_entry& operator=(directory_entry const&) = default;
// directory_entry& operator=(directory_entry&&) noexcept = default;
// void assign(path const&);
// void replace_filename(path const&);

#include "filesystem_include.h"
#include <type_traits>
#include <cassert>

#include "test_macros.h"
#include "rapid-cxx-test.h"
#include "filesystem_test_helper.h"

TEST_SUITE(directory_entry_ctor_suite)

TEST_CASE(test_copy_assign_operator) {
  using namespace fs;
  // Copy
  {
    static_assert(std::is_copy_assignable<directory_entry>::value,
                  "directory_entry must be copy assignable");
    static_assert(!std::is_nothrow_copy_assignable<directory_entry>::value,
                  "directory_entry's copy assignment cannot be noexcept");
    const path p("foo/bar/baz");
    const path p2("abc");
    const directory_entry e(p);
    directory_entry e2;
    assert(e.path() == p && e2.path() == path());
    e2 = e;
    assert(e.path() == p && e2.path() == p);
    directory_entry e3(p2);
    e2 = e3;
    assert(e2.path() == p2 && e3.path() == p2);
  }
}

TEST_CASE(copy_assign_copies_cache) {
  using namespace fs;
  scoped_test_env env;
  const path dir = env.create_dir("dir");
  const path file = env.create_file("dir/file", 42);
  const path sym = env.create_symlink("dir/file", "sym");

  {
    directory_entry ent(sym);

    fs::remove(sym);

    directory_entry ent_cp;
    ent_cp = ent;
    TEST_CHECK(ent_cp.path() == sym);
    TEST_CHECK(ent_cp.is_symlink());
  }

  {
    directory_entry ent(file);

    fs::remove(file);

    directory_entry ent_cp;
    ent_cp = ent;
    TEST_CHECK(ent_cp.path() == file);
    TEST_CHECK(ent_cp.is_regular_file());
  }
}

TEST_SUITE_END()
