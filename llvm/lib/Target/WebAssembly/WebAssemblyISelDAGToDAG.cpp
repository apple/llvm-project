//- WebAssemblyISelDAGToDAG.cpp - A dag to dag inst selector for WebAssembly -//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file defines an instruction selector for the WebAssembly target.
///
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/WebAssemblyMCTargetDesc.h"
#include "WebAssembly.h"
#include "WebAssemblyTargetMachine.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/IR/Function.h" // To access function attributes.
#include "llvm/Support/Debug.h"
#include "llvm/Support/KnownBits.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "wasm-isel"

//===--------------------------------------------------------------------===//
/// WebAssembly-specific code to select WebAssembly machine instructions for
/// SelectionDAG operations.
///
namespace {
class WebAssemblyDAGToDAGISel final : public SelectionDAGISel {
  /// Keep a pointer to the WebAssemblySubtarget around so that we can make the
  /// right decision when generating code for different targets.
  const WebAssemblySubtarget *Subtarget;

  bool ForCodeSize;

public:
  WebAssemblyDAGToDAGISel(WebAssemblyTargetMachine &TM,
                          CodeGenOpt::Level OptLevel)
      : SelectionDAGISel(TM, OptLevel), Subtarget(nullptr), ForCodeSize(false) {
  }

  StringRef getPassName() const override {
    return "WebAssembly Instruction Selection";
  }

  bool runOnMachineFunction(MachineFunction &MF) override {
    LLVM_DEBUG(dbgs() << "********** ISelDAGToDAG **********\n"
                         "********** Function: "
                      << MF.getName() << '\n');

    ForCodeSize = MF.getFunction().hasOptSize();
    Subtarget = &MF.getSubtarget<WebAssemblySubtarget>();
    return SelectionDAGISel::runOnMachineFunction(MF);
  }

  void Select(SDNode *Node) override;

  bool SelectInlineAsmMemoryOperand(const SDValue &Op, unsigned ConstraintID,
                                    std::vector<SDValue> &OutOps) override;

// Include the pieces autogenerated from the target description.
#include "WebAssemblyGenDAGISel.inc"

private:
  // add select functions here...
};
} // end anonymous namespace

void WebAssemblyDAGToDAGISel::Select(SDNode *Node) {
  // If we have a custom node, we already have selected!
  if (Node->isMachineOpcode()) {
    LLVM_DEBUG(errs() << "== "; Node->dump(CurDAG); errs() << "\n");
    Node->setNodeId(-1);
    return;
  }

  // Few custom selection stuff.
  SDLoc DL(Node);
  MachineFunction &MF = CurDAG->getMachineFunction();
  switch (Node->getOpcode()) {
  case ISD::ATOMIC_FENCE: {
    if (!MF.getSubtarget<WebAssemblySubtarget>().hasAtomics())
      break;

    uint64_t SyncScopeID =
        cast<ConstantSDNode>(Node->getOperand(2).getNode())->getZExtValue();
    switch (SyncScopeID) {
    case SyncScope::SingleThread: {
      // We lower a single-thread fence to a pseudo compiler barrier instruction
      // preventing instruction reordering. This will not be emitted in final
      // binary.
      MachineSDNode *Fence =
          CurDAG->getMachineNode(WebAssembly::COMPILER_FENCE,
                                 DL,                 // debug loc
                                 MVT::Other,         // outchain type
                                 Node->getOperand(0) // inchain
          );
      ReplaceNode(Node, Fence);
      CurDAG->RemoveDeadNode(Node);
      return;
    }

    case SyncScope::System: {
      // For non-emscripten systems, we have not decided on what we should
      // traslate fences to yet.
      if (!Subtarget->getTargetTriple().isOSEmscripten())
        report_fatal_error(
            "ATOMIC_FENCE is not yet supported in non-emscripten OSes");

      // Wasm does not have a fence instruction, but because all atomic
      // instructions in wasm are sequentially consistent, we translate a
      // fence to an idempotent atomic RMW instruction to a linear memory
      // address. All atomic instructions in wasm are sequentially consistent,
      // but this is to ensure a fence also prevents reordering of non-atomic
      // instructions in the VM. Even though LLVM IR's fence instruction does
      // not say anything about its relationship with non-atomic instructions,
      // we think this is more user-friendly.
      //
      // While any address can work, here we use a value stored in
      // __stack_pointer wasm global because there's high chance that area is
      // in cache.
      //
      // So the selected instructions will be in the form of:
      //   %addr = get_global $__stack_pointer
      //   %0 = i32.const 0
      //   i32.atomic.rmw.or %addr, %0
      SDValue StackPtrSym = CurDAG->getTargetExternalSymbol(
          "__stack_pointer", TLI->getPointerTy(CurDAG->getDataLayout()));
      MachineSDNode *GetGlobal =
          CurDAG->getMachineNode(WebAssembly::GLOBAL_GET_I32, // opcode
                                 DL,                          // debug loc
                                 MVT::i32,                    // result type
                                 StackPtrSym // __stack_pointer symbol
          );

      SDValue Zero = CurDAG->getTargetConstant(0, DL, MVT::i32);
      auto *MMO = MF.getMachineMemOperand(
          MachinePointerInfo::getUnknownStack(MF),
          // FIXME Volatile isn't really correct, but currently all LLVM
          // atomic instructions are treated as volatiles in the backend, so
          // we should be consistent.
          MachineMemOperand::MOVolatile | MachineMemOperand::MOLoad |
              MachineMemOperand::MOStore,
          4, 4, AAMDNodes(), nullptr, SyncScope::System,
          AtomicOrdering::SequentiallyConsistent);
      MachineSDNode *Const0 =
          CurDAG->getMachineNode(WebAssembly::CONST_I32, DL, MVT::i32, Zero);
      MachineSDNode *AtomicRMW = CurDAG->getMachineNode(
          WebAssembly::ATOMIC_RMW_OR_I32, // opcode
          DL,                             // debug loc
          MVT::i32,                       // result type
          MVT::Other,                     // outchain type
          {
              Zero,                  // alignment
              Zero,                  // offset
              SDValue(GetGlobal, 0), // __stack_pointer
              SDValue(Const0, 0),    // OR with 0 to make it idempotent
              Node->getOperand(0)    // inchain
          });

      CurDAG->setNodeMemRefs(AtomicRMW, {MMO});
      ReplaceUses(SDValue(Node, 0), SDValue(AtomicRMW, 1));
      CurDAG->RemoveDeadNode(Node);
      return;
    }
    default:
      llvm_unreachable("Unknown scope!");
    }
  }

  default:
    break;
  }

  // Select the default instruction.
  SelectCode(Node);
}

bool WebAssemblyDAGToDAGISel::SelectInlineAsmMemoryOperand(
    const SDValue &Op, unsigned ConstraintID, std::vector<SDValue> &OutOps) {
  switch (ConstraintID) {
  case InlineAsm::Constraint_i:
  case InlineAsm::Constraint_m:
    // We just support simple memory operands that just have a single address
    // operand and need no special handling.
    OutOps.push_back(Op);
    return false;
  default:
    break;
  }

  return true;
}

/// This pass converts a legalized DAG into a WebAssembly-specific DAG, ready
/// for instruction scheduling.
FunctionPass *llvm::createWebAssemblyISelDag(WebAssemblyTargetMachine &TM,
                                             CodeGenOpt::Level OptLevel) {
  return new WebAssemblyDAGToDAGISel(TM, OptLevel);
}
