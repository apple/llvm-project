//===- OperationSupportTest.cpp - Operation support unit tests ------------===//
//
// Part of the MLIR Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/IR/OperationSupport.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/StandardTypes.h"
#include "gtest/gtest.h"

using namespace mlir;
using namespace mlir::detail;

namespace {
Operation *createOp(MLIRContext *context, bool resizableOperands,
                    ArrayRef<Value> operands = llvm::None,
                    ArrayRef<Type> resultTypes = llvm::None) {
  return Operation::create(
      UnknownLoc::get(context), OperationName("foo.bar", context), resultTypes,
      operands, llvm::None, llvm::None, 0, resizableOperands);
}

TEST(OperandStorageTest, NonResizable) {
  MLIRContext context;
  Builder builder(&context);

  Operation *useOp =
      createOp(&context, /*resizableOperands=*/false, /*operands=*/llvm::None,
               builder.getIntegerType(16));
  Value operand = useOp->getResult(0);

  // Create a non-resizable operation with one operand.
  Operation *user = createOp(&context, /*resizableOperands=*/false, operand,
                             builder.getIntegerType(16));

  // Sanity check the storage.
  EXPECT_EQ(user->hasResizableOperandsList(), false);

  // The same number of operands is okay.
  user->setOperands(operand);
  EXPECT_EQ(user->getNumOperands(), 1u);

  // Removing is okay.
  user->setOperands(llvm::None);
  EXPECT_EQ(user->getNumOperands(), 0u);

  // Destroy the operations.
  user->destroy();
  useOp->destroy();
}

TEST(OperandStorageDeathTest, AddToNonResizable) {
  MLIRContext context;
  Builder builder(&context);

  Operation *useOp =
      createOp(&context, /*resizableOperands=*/false, /*operands=*/llvm::None,
               builder.getIntegerType(16));
  Value operand = useOp->getResult(0);

  // Create a non-resizable operation with one operand.
  Operation *user = createOp(&context, /*resizableOperands=*/false, operand,
                             builder.getIntegerType(16));

  // Sanity check the storage.
  EXPECT_EQ(user->hasResizableOperandsList(), false);

  // Adding operands to a non resizable operation should result in a failure.
  ASSERT_DEATH(user->setOperands({operand, operand}), "");
}

TEST(OperandStorageTest, Resizable) {
  MLIRContext context;
  Builder builder(&context);

  Operation *useOp =
      createOp(&context, /*resizableOperands=*/false, /*operands=*/llvm::None,
               builder.getIntegerType(16));
  Value operand = useOp->getResult(0);

  // Create a resizable operation with one operand.
  Operation *user = createOp(&context, /*resizableOperands=*/true, operand,
                             builder.getIntegerType(16));

  // Sanity check the storage.
  EXPECT_EQ(user->hasResizableOperandsList(), true);

  // The same number of operands is okay.
  user->setOperands(operand);
  EXPECT_EQ(user->getNumOperands(), 1u);

  // Removing is okay.
  user->setOperands(llvm::None);
  EXPECT_EQ(user->getNumOperands(), 0u);

  // Adding more operands is okay.
  user->setOperands({operand, operand, operand});
  EXPECT_EQ(user->getNumOperands(), 3u);

  // Destroy the operations.
  user->destroy();
  useOp->destroy();
}

} // end namespace
