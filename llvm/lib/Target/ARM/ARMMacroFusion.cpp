//===- ARMMacroFusion.cpp - ARM Macro Fusion ----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
/// \file This file contains the ARM implementation of the DAG scheduling
///  mutation to pair instructions back to back.
//
//===----------------------------------------------------------------------===//

#include "ARMMacroFusion.h"
#include "ARMSubtarget.h"
#include "llvm/CodeGen/MacroFusion.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

namespace llvm {

// Fuse AES crypto encoding or decoding.
static bool isAESPair(const MachineInstr *FirstMI,
                      const MachineInstr &SecondMI) {
  // Assume the 1st instr to be a wildcard if it is unspecified.
  unsigned FirstOpcode =
      FirstMI ? FirstMI->getOpcode()
              : static_cast<unsigned>(ARM::INSTRUCTION_LIST_END);
  unsigned SecondOpcode = SecondMI.getOpcode();

  switch(SecondOpcode) {
  // AES encode.
  case ARM::AESMC :
    return FirstOpcode == ARM::AESE ||
           FirstOpcode == ARM::INSTRUCTION_LIST_END;
  // AES decode.
  case ARM::AESIMC:
    return FirstOpcode == ARM::AESD ||
           FirstOpcode == ARM::INSTRUCTION_LIST_END;
  }

  return false;
}

// Fuse literal generation.
static bool isLiteralsPair(const MachineInstr *FirstMI,
                           const MachineInstr &SecondMI) {
  // Assume the 1st instr to be a wildcard if it is unspecified.
  unsigned FirstOpcode =
      FirstMI ? FirstMI->getOpcode()
              : static_cast<unsigned>(ARM::INSTRUCTION_LIST_END);
  unsigned SecondOpcode = SecondMI.getOpcode();

  // 32 bit immediate.
  if ((FirstOpcode == ARM::INSTRUCTION_LIST_END ||
       FirstOpcode == ARM::MOVi16) &&
      SecondOpcode == ARM::MOVTi16)
    return true;

  return false;
}

/// Check if the instr pair, FirstMI and SecondMI, should be fused
/// together. Given SecondMI, when FirstMI is unspecified, then check if
/// SecondMI may be part of a fused pair at all.
static bool shouldScheduleAdjacent(const TargetInstrInfo &TII,
                                   const TargetSubtargetInfo &TSI,
                                   const MachineInstr *FirstMI,
                                   const MachineInstr &SecondMI) {
  const ARMSubtarget &ST = static_cast<const ARMSubtarget&>(TSI);

  if (ST.hasFuseAES() && isAESPair(FirstMI, SecondMI))
    return true;
  if (ST.hasFuseLiterals() && isLiteralsPair(FirstMI, SecondMI))
    return true;

  return false;
}

std::unique_ptr<ScheduleDAGMutation> createARMMacroFusionDAGMutation () {
  return createMacroFusionDAGMutation(shouldScheduleAdjacent);
}

} // end namespace llvm
