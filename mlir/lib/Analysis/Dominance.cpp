//===- Dominance.cpp - Dominator analysis for CFGs ------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Implementation of dominance related classes and instantiations of extern
// templates.
//
//===----------------------------------------------------------------------===//

#include "mlir/Analysis/Dominance.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/Support/GenericDomTreeConstruction.h"

using namespace mlir;
using namespace mlir::detail;

template class llvm::DominatorTreeBase<Block, /*IsPostDom=*/false>;
template class llvm::DominatorTreeBase<Block, /*IsPostDom=*/true>;
template class llvm::DomTreeNodeBase<Block>;

//===----------------------------------------------------------------------===//
// DominanceInfoBase
//===----------------------------------------------------------------------===//

template <bool IsPostDom>
void DominanceInfoBase<IsPostDom>::recalculate(Operation *op) {
  dominanceInfos.clear();

  /// Build the dominance for each of the operation regions.
  op->walk([&](Operation *op) {
    for (auto &region : op->getRegions()) {
      // Don't compute dominance if the region is empty.
      if (region.empty())
        continue;
      auto opDominance = std::make_unique<base>();
      opDominance->recalculate(region);
      dominanceInfos.try_emplace(&region, std::move(opDominance));
    }
  });
}

/// Walks up the list of containers of the given block and calls the
/// user-defined traversal function for every pair of a region and block that
/// could be found during traversal. If the user-defined function returns true
/// for a given pair, traverseAncestors will return the current block. Nullptr
/// otherwise.
template <typename FuncT>
Block *traverseAncestors(Block *block, const FuncT &func) {
  // Invoke the user-defined traversal function in the beginning for the current
  // block.
  if (func(block))
    return block;

  Region *region = block->getParent();
  while (region) {
    Operation *ancestor = region->getParentOp();
    // If we have reached to top... return.
    if (!ancestor || !(block = ancestor->getBlock()))
      break;

    // Update the nested region using the new ancestor block.
    region = block->getParent();

    // Invoke the user-defined traversal function and check whether we can
    // already return.
    if (func(block))
      return block;
  }
  return nullptr;
}

/// Tries to update the given block references to live in the same region by
/// exploring the relationship of both blocks with respect to their regions.
static bool tryGetBlocksInSameRegion(Block *&a, Block *&b) {
  // If both block do not live in the same region, we will have to check their
  // parent operations.
  if (a->getParent() == b->getParent())
    return true;

  // Iterate over all ancestors of a and insert them into the map. This allows
  // for efficient lookups to find a commonly shared region.
  llvm::SmallDenseMap<Region *, Block *, 4> ancestors;
  traverseAncestors(a, [&](Block *block) {
    ancestors[block->getParent()] = block;
    return false;
  });

  // Try to find a common ancestor starting with regionB.
  b = traverseAncestors(
      b, [&](Block *block) { return ancestors.count(block->getParent()) > 0; });

  // If there is no match, we will not be able to find a common dominator since
  // both regions do not share a common parent region.
  if (!b)
    return false;

  // We have found a common parent region. Update block a to refer to this
  // region.
  auto it = ancestors.find(b->getParent());
  assert(it != ancestors.end());
  a = it->second;
  return true;
}

template <bool IsPostDom>
Block *
DominanceInfoBase<IsPostDom>::findNearestCommonDominator(Block *a,
                                                         Block *b) const {
  // If either a or b are null, then conservatively return nullptr.
  if (!a || !b)
    return nullptr;

  // Try to find blocks that are in the same region.
  if (!tryGetBlocksInSameRegion(a, b))
    return nullptr;

  // Get and verify dominance information of the common parent region.
  Region *parentRegion = a->getParent();
  auto infoAIt = dominanceInfos.find(parentRegion);
  if (infoAIt == dominanceInfos.end())
    return nullptr;

  // Since the blocks live in the same region, we can rely on already
  // existing dominance functionality.
  return infoAIt->second->findNearestCommonDominator(a, b);
}

template <bool IsPostDom>
DominanceInfoNode *DominanceInfoBase<IsPostDom>::getNode(Block *a) {
  auto *region = a->getParent();
  assert(dominanceInfos.count(region) != 0);
  return dominanceInfos[region]->getNode(a);
}

/// Return true if the specified block A properly dominates block B.
template <bool IsPostDom>
bool DominanceInfoBase<IsPostDom>::properlyDominates(Block *a, Block *b) {
  // A block dominates itself but does not properly dominate itself.
  if (a == b)
    return false;

  // If either a or b are null, then conservatively return false.
  if (!a || !b)
    return false;

  // If both blocks are not in the same region, 'a' properly dominates 'b' if
  // 'b' is defined in an operation region that (recursively) ends up being
  // dominated by 'a'. Walk up the list of containers enclosing B.
  auto *regionA = a->getParent();
  if (regionA != b->getParent()) {
    b = traverseAncestors(
        b, [&](Block *block) { return block->getParent() == regionA; });

    // If we could not find a valid block b then it is either a not a dominator
    // or a post dominator.
    if (!b)
      return IsPostDom;

    // Check to see if the ancestor of 'b' is the same block as 'a'.
    if (a == b)
      return true;
  }

  // Otherwise, use the standard dominance functionality.

  // If we don't have a dominance information for this region, assume that b is
  // dominated by anything.
  auto baseInfoIt = dominanceInfos.find(regionA);
  if (baseInfoIt == dominanceInfos.end())
    return true;
  return baseInfoIt->second->properlyDominates(a, b);
}

template class mlir::detail::DominanceInfoBase</*IsPostDom=*/true>;
template class mlir::detail::DominanceInfoBase</*IsPostDom=*/false>;

//===----------------------------------------------------------------------===//
// DominanceInfo
//===----------------------------------------------------------------------===//

/// Return true if operation A properly dominates operation B.
bool DominanceInfo::properlyDominates(Operation *a, Operation *b) {
  auto *aBlock = a->getBlock(), *bBlock = b->getBlock();

  // If a or b are not within a block, then a does not dominate b.
  if (!aBlock || !bBlock)
    return false;

  // If the blocks are the same, then check if b is before a in the block.
  if (aBlock == bBlock)
    return a->isBeforeInBlock(b);

  // Traverse up b's hierarchy to check if b's block is contained in a's.
  if (auto *bAncestor = aBlock->findAncestorOpInBlock(*b)) {
    // Since we already know that aBlock != bBlock, here bAncestor != b.
    // a and bAncestor are in the same block; check if 'a' dominates
    // bAncestor.
    return dominates(a, bAncestor);
  }

  // If the blocks are different, check if a's block dominates b's.
  return properlyDominates(aBlock, bBlock);
}

/// Return true if value A properly dominates operation B.
bool DominanceInfo::properlyDominates(Value a, Operation *b) {
  if (auto *aOp = a.getDefiningOp()) {
    // The values defined by an operation do *not* dominate any nested
    // operations.
    if (aOp->getParentRegion() != b->getParentRegion() && aOp->isAncestor(b))
      return false;
    return properlyDominates(aOp, b);
  }

  // block arguments properly dominate all operations in their own block, so
  // we use a dominates check here, not a properlyDominates check.
  return dominates(a.cast<BlockArgument>().getOwner(), b->getBlock());
}

void DominanceInfo::updateDFSNumbers() {
  for (auto &iter : dominanceInfos)
    iter.second->updateDFSNumbers();
}

//===----------------------------------------------------------------------===//
// PostDominanceInfo
//===----------------------------------------------------------------------===//

/// Returns true if statement 'a' properly postdominates statement b.
bool PostDominanceInfo::properlyPostDominates(Operation *a, Operation *b) {
  auto *aBlock = a->getBlock(), *bBlock = b->getBlock();

  // If a or b are not within a block, then a does not post dominate b.
  if (!aBlock || !bBlock)
    return false;

  // If the blocks are the same, check if b is before a in the block.
  if (aBlock == bBlock)
    return b->isBeforeInBlock(a);

  // Traverse up b's hierarchy to check if b's block is contained in a's.
  if (auto *bAncestor = a->getBlock()->findAncestorOpInBlock(*b))
    // Since we already know that aBlock != bBlock, here bAncestor != b.
    // a and bAncestor are in the same block; check if 'a' postdominates
    // bAncestor.
    return postDominates(a, bAncestor);

  // If the blocks are different, check if a's block post dominates b's.
  return properlyDominates(aBlock, bBlock);
}
