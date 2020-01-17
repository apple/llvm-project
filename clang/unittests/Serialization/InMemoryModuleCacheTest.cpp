//===- InMemoryModuleCacheTest.cpp - InMemoryModuleCache tests ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "clang/Serialization/InMemoryModuleCache.h"
#include "llvm/Support/MemoryBuffer.h"
#include "gtest/gtest.h"

using namespace llvm;
using namespace clang;

namespace {

std::unique_ptr<MemoryBuffer> getBuffer(int I) {
  SmallVector<char, 8> Bytes;
  raw_svector_ostream(Bytes) << "data:" << I;
  return MemoryBuffer::getMemBuffer(StringRef(Bytes.data(), Bytes.size()), "",
                                    /* RequiresNullTerminator = */ false);
}

TEST(InMemoryModuleCacheTest, initialState) {
  InMemoryModuleCache Cache;
  EXPECT_EQ(nullptr, Cache.lookupPCM("B"));
  EXPECT_FALSE(Cache.isPCMFinal("B"));

#if !defined(NDEBUG) && GTEST_HAS_DEATH_TEST
  EXPECT_DEATH(Cache.tryToRemovePCM("B"), "PCM to remove is unknown");
  EXPECT_DEATH(Cache.finalizePCM("B"), "PCM to finalize is unknown");
#endif
}

TEST(InMemoryModuleCacheTest, addPCM) {
  auto B = getBuffer(1);
  auto *RawB = B.get();

  InMemoryModuleCache Cache;
  EXPECT_EQ(RawB, &Cache.addPCM("B", std::move(B)));
  EXPECT_EQ(RawB, Cache.lookupPCM("B"));
  EXPECT_FALSE(Cache.isPCMFinal("B"));

#if !defined(NDEBUG) && GTEST_HAS_DEATH_TEST
  EXPECT_DEATH(Cache.addPCM("B", getBuffer(2)), "Already has a PCM");
  EXPECT_DEATH(Cache.addFinalPCM("B", getBuffer(2)),
               "Already has a non-final PCM");
#endif
}

TEST(InMemoryModuleCacheTest, addFinalPCM) {
  auto B = getBuffer(1);
  auto *RawB = B.get();

  InMemoryModuleCache Cache;
  EXPECT_EQ(RawB, &Cache.addFinalPCM("B", std::move(B)));
  EXPECT_EQ(RawB, Cache.lookupPCM("B"));
  EXPECT_TRUE(Cache.isPCMFinal("B"));

#if !defined(NDEBUG) && GTEST_HAS_DEATH_TEST
  EXPECT_DEATH(Cache.addPCM("B", getBuffer(2)), "Already has a PCM");
  EXPECT_DEATH(Cache.addFinalPCM("B", getBuffer(2)),
               "Trying to override finalized PCM");
#endif
}

TEST(InMemoryModuleCacheTest, tryToRemovePCM) {
  auto B1 = getBuffer(1);
  auto B2 = getBuffer(2);
  auto *RawB1 = B1.get();
  auto *RawB2 = B2.get();
  ASSERT_NE(RawB1, RawB2);

  InMemoryModuleCache Cache;
  EXPECT_EQ(RawB1, &Cache.addPCM("B", std::move(B1)));
  EXPECT_FALSE(Cache.tryToRemovePCM("B"));
  EXPECT_EQ(nullptr, Cache.lookupPCM("B"));
  EXPECT_FALSE(Cache.isPCMFinal("B"));

#if !defined(NDEBUG) && GTEST_HAS_DEATH_TEST
  EXPECT_DEATH(Cache.tryToRemovePCM("B"), "PCM to remove is unknown");
  EXPECT_DEATH(Cache.finalizePCM("B"), "PCM to finalize is unknown");
#endif

  // Add a new one.
  EXPECT_EQ(RawB2, &Cache.addFinalPCM("B", std::move(B2)));
  EXPECT_TRUE(Cache.isPCMFinal("B"));

  // Can try to drop again, but this should error and do nothing.
  EXPECT_TRUE(Cache.tryToRemovePCM("B"));
  EXPECT_EQ(RawB2, Cache.lookupPCM("B"));
}

TEST(InMemoryModuleCacheTest, finalizePCM) {
  auto B = getBuffer(1);
  auto *RawB = B.get();

  InMemoryModuleCache Cache;
  EXPECT_EQ(RawB, &Cache.addPCM("B", std::move(B)));

  // Call finalize.
  Cache.finalizePCM("B");
  EXPECT_TRUE(Cache.isPCMFinal("B"));
}

} // namespace
