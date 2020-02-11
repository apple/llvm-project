//===--------------------- SummaryView.cpp -------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
///
/// This file implements the functionalities used by the SummaryView to print
/// the report information.
///
//===----------------------------------------------------------------------===//

#include "Views/SummaryView.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/MCA/Support.h"
#include "llvm/Support/Format.h"

namespace llvm {
namespace mca {

#define DEBUG_TYPE "llvm-mca"

SummaryView::SummaryView(const MCSchedModel &Model, ArrayRef<MCInst> S,
                         unsigned Width)
    : SM(Model), Source(S), DispatchWidth(Width?Width: Model.IssueWidth),
      LastInstructionIdx(0),
      TotalCycles(0), NumMicroOps(0),
      ProcResourceUsage(Model.getNumProcResourceKinds(), 0),
      ProcResourceMasks(Model.getNumProcResourceKinds()),
      ResIdx2ProcResID(Model.getNumProcResourceKinds(), 0) {
  computeProcResourceMasks(SM, ProcResourceMasks);
  for (unsigned I = 1, E = SM.getNumProcResourceKinds(); I < E; ++I) {
    unsigned Index = getResourceStateIndex(ProcResourceMasks[I]);
    ResIdx2ProcResID[Index] = I;
  }
}

void SummaryView::onEvent(const HWInstructionEvent &Event) {
  if (Event.Type == HWInstructionEvent::Dispatched)
    LastInstructionIdx = Event.IR.getSourceIndex();

  // We are only interested in the "instruction retired" events generated by
  // the retire stage for instructions that are part of iteration #0.
  if (Event.Type != HWInstructionEvent::Retired ||
      Event.IR.getSourceIndex() >= Source.size())
    return;

  // Update the cumulative number of resource cycles based on the processor
  // resource usage information available from the instruction descriptor. We
  // need to compute the cumulative number of resource cycles for every
  // processor resource which is consumed by an instruction of the block.
  const Instruction &Inst = *Event.IR.getInstruction();
  const InstrDesc &Desc = Inst.getDesc();
  NumMicroOps += Desc.NumMicroOps;
  for (const std::pair<uint64_t, ResourceUsage> &RU : Desc.Resources) {
    if (RU.second.size()) {
      unsigned ProcResID = ResIdx2ProcResID[getResourceStateIndex(RU.first)];
      ProcResourceUsage[ProcResID] += RU.second.size();
    }
  }
}

void SummaryView::printView(raw_ostream &OS) const {
  unsigned Instructions = Source.size();
  unsigned Iterations = (LastInstructionIdx / Instructions) + 1;
  unsigned TotalInstructions = Instructions * Iterations;
  unsigned TotalUOps = NumMicroOps * Iterations;
  double IPC = (double)TotalInstructions / TotalCycles;
  double UOpsPerCycle = (double)TotalUOps / TotalCycles;
  double BlockRThroughput = computeBlockRThroughput(
      SM, DispatchWidth, NumMicroOps, ProcResourceUsage);

  std::string Buffer;
  raw_string_ostream TempStream(Buffer);
  TempStream << "Iterations:        " << Iterations;
  TempStream << "\nInstructions:      " << TotalInstructions;
  TempStream << "\nTotal Cycles:      " << TotalCycles;
  TempStream << "\nTotal uOps:        " << TotalUOps << '\n';
  TempStream << "\nDispatch Width:    " << DispatchWidth;
  TempStream << "\nuOps Per Cycle:    "
             << format("%.2f", floor((UOpsPerCycle * 100) + 0.5) / 100);
  TempStream << "\nIPC:               "
             << format("%.2f", floor((IPC * 100) + 0.5) / 100);
  TempStream << "\nBlock RThroughput: "
             << format("%.1f", floor((BlockRThroughput * 10) + 0.5) / 10)
             << '\n';
  TempStream.flush();
  OS << Buffer;
}

} // namespace mca.
} // namespace llvm
