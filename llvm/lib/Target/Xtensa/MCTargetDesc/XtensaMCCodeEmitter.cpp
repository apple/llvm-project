//===-- XtensaMCCodeEmitter.cpp - Convert Xtensa Code to Machine Code -----===//
//
//                     The LLVM Compiler Infrastructure
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the XtensaMCCodeEmitter class.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "mccodeemitter"
#include "MCTargetDesc/XtensaFixupKinds.h"
#include "MCTargetDesc/XtensaMCExpr.h"
#include "MCTargetDesc/XtensaMCTargetDesc.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"

#define GET_INSTRMAP_INFO
#include "XtensaGenInstrInfo.inc"
#undef GET_INSTRMAP_INFO

using namespace llvm;

namespace {
class XtensaMCCodeEmitter : public MCCodeEmitter {
  const MCInstrInfo &MCII;
  MCContext &Ctx;
  bool IsLittleEndian;

public:
  XtensaMCCodeEmitter(const MCInstrInfo &mcii, MCContext &ctx, bool isLE)
      : MCII(mcii), Ctx(ctx), IsLittleEndian(isLE) {}

  ~XtensaMCCodeEmitter() {}

  // OVerride MCCodeEmitter.
  void encodeInstruction(const MCInst &MI, raw_ostream &OS,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const override;

private:
  // Automatically generated by TableGen.
  uint64_t getBinaryCodeForInstr(const MCInst &MI,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  // Called by the TableGen code to get the binary encoding of operand
  // MO in MI.  Fixups is the list of fixups against MI.
  uint32_t getMachineOpValue(const MCInst &MI, const MCOperand &MO,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;

  uint32_t getJumpTargetEncoding(const MCInst &MI, unsigned int OpNum,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  uint32_t getBranchTargetEncoding(const MCInst &MI, unsigned int OpNum,
                                   SmallVectorImpl<MCFixup> &Fixups,
                                   const MCSubtargetInfo &STI) const;

  uint32_t getCallEncoding(const MCInst &MI, unsigned int OpNum,
                           SmallVectorImpl<MCFixup> &Fixups,
                           const MCSubtargetInfo &STI) const;

  uint32_t getL32RTargetEncoding(const MCInst &MI, unsigned OpNum,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  uint32_t getMemRegEncoding(const MCInst &MI, unsigned OpNo,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;

  uint32_t getImm8OpValue(const MCInst &MI, unsigned OpNo,
                          SmallVectorImpl<MCFixup> &Fixups,
                          const MCSubtargetInfo &STI) const;

  uint32_t getImm8_sh8OpValue(const MCInst &MI, unsigned OpNo,
                              SmallVectorImpl<MCFixup> &Fixups,
                              const MCSubtargetInfo &STI) const;

  uint32_t getImm12OpValue(const MCInst &MI, unsigned OpNo,
                           SmallVectorImpl<MCFixup> &Fixups,
                           const MCSubtargetInfo &STI) const;

  uint32_t getUimm4OpValue(const MCInst &MI, unsigned OpNo,
                           SmallVectorImpl<MCFixup> &Fixups,
                           const MCSubtargetInfo &STI) const;

  uint32_t getUimm5OpValue(const MCInst &MI, unsigned OpNo,
                           SmallVectorImpl<MCFixup> &Fixups,
                           const MCSubtargetInfo &STI) const;

  uint32_t getImm1_16OpValue(const MCInst &MI, unsigned OpNo,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;

  uint32_t getImm1n_15OpValue(const MCInst &MI, unsigned OpNo,
                              SmallVectorImpl<MCFixup> &Fixups,
                              const MCSubtargetInfo &STI) const;

  uint32_t getImm32n_95OpValue(const MCInst &MI, unsigned OpNo,
                               SmallVectorImpl<MCFixup> &Fixups,
                               const MCSubtargetInfo &STI) const;

  uint32_t getImm8n_7OpValue(const MCInst &MI, unsigned OpNo,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;

  uint32_t getImm64n_4nOpValue(const MCInst &MI, unsigned OpNo,
                               SmallVectorImpl<MCFixup> &Fixups,
                               const MCSubtargetInfo &STI) const;

  uint32_t getEntry_Imm12OpValue(const MCInst &MI, unsigned OpNo,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  uint32_t getShimm1_31OpValue(const MCInst &MI, unsigned OpNo,
                               SmallVectorImpl<MCFixup> &Fixups,
                               const MCSubtargetInfo &STI) const;

  uint32_t getB4constOpValue(const MCInst &MI, unsigned OpNo,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;

  uint32_t getB4constuOpValue(const MCInst &MI, unsigned OpNo,
                              SmallVectorImpl<MCFixup> &Fixups,
                              const MCSubtargetInfo &STI) const;

  uint32_t getSeimm7_22OpValue(const MCInst &MI, unsigned OpNo,
                               SmallVectorImpl<MCFixup> &Fixups,
                               const MCSubtargetInfo &STI) const;
};
} // namespace

MCCodeEmitter *llvm::createXtensaMCCodeEmitter(const MCInstrInfo &MCII,
                                               const MCRegisterInfo &MRI,
                                               MCContext &Ctx) {
  return new XtensaMCCodeEmitter(MCII, Ctx, true);
}

void XtensaMCCodeEmitter::encodeInstruction(const MCInst &MI, raw_ostream &OS,
                                            SmallVectorImpl<MCFixup> &Fixups,
                                            const MCSubtargetInfo &STI) const {
  uint64_t Bits = getBinaryCodeForInstr(MI, Fixups, STI);
  unsigned Size = MCII.get(MI.getOpcode()).getSize();

  if (IsLittleEndian) {
    // Little-endian insertion of Size bytes.
    unsigned ShiftValue = 0;
    for (unsigned I = 0; I != Size; ++I) {
      OS << uint8_t(Bits >> ShiftValue);
      ShiftValue += 8;
    }
  } else {
    // TODO Big-endian insertion of Size bytes.
    llvm_unreachable("Big-endian mode currently is not supported!");
  }
}

uint32_t
XtensaMCCodeEmitter::getMachineOpValue(const MCInst &MI, const MCOperand &MO,
                                       SmallVectorImpl<MCFixup> &Fixups,
                                       const MCSubtargetInfo &STI) const {
  if (MO.isReg())
    return Ctx.getRegisterInfo()->getEncodingValue(MO.getReg());
  if (MO.isImm()) {
    uint32_t Res = static_cast<uint32_t>(MO.getImm());
    return Res;
  }

  llvm_unreachable("Unhandled expression!");
  return 0;
}

uint32_t
XtensaMCCodeEmitter::getJumpTargetEncoding(const MCInst &MI, unsigned int OpNum,
                                           SmallVectorImpl<MCFixup> &Fixups,
                                           const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNum);

  if (MO.isImm())
    return MO.getImm();

  const MCExpr *Expr = MO.getExpr();
  Fixups.push_back(MCFixup::create(
      0, Expr, MCFixupKind(Xtensa::fixup_xtensa_jump_18), MI.getLoc()));
  return 0;
}

uint32_t XtensaMCCodeEmitter::getBranchTargetEncoding(
    const MCInst &MI, unsigned int OpNum, SmallVectorImpl<MCFixup> &Fixups,
    const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNum);
  if (MO.isImm())
    return static_cast<uint32_t>(MO.getImm());

  const MCExpr *Expr = MO.getExpr();
  switch (MI.getOpcode()) {
  case Xtensa::BEQZ:
  case Xtensa::BGEZ:
  case Xtensa::BLTZ:
  case Xtensa::BNEZ:
    Fixups.push_back(MCFixup::create(
        0, Expr, MCFixupKind(Xtensa::fixup_xtensa_branch_12), MI.getLoc()));
    return 0;
  default:
    Fixups.push_back(MCFixup::create(
        0, Expr, MCFixupKind(Xtensa::fixup_xtensa_branch_8), MI.getLoc()));
    return 0;
  }
}

uint32_t
XtensaMCCodeEmitter::getCallEncoding(const MCInst &MI, unsigned int OpNum,
                                     SmallVectorImpl<MCFixup> &Fixups,
                                     const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNum);
  if (MO.isImm()) {
    int32_t Res = MO.getImm();
    if (Res & 0x3) {
      llvm_unreachable("Unexpected operand value!");
    }
    Res >>= 2;
    return Res;
  }

  assert((MO.isExpr()) && "Unexpected operand value!");
  const MCExpr *Expr = MO.getExpr();
  Fixups.push_back(MCFixup::create(
      0, Expr, MCFixupKind(Xtensa::fixup_xtensa_call_18), MI.getLoc()));
  return 0;
}

uint32_t
XtensaMCCodeEmitter::getL32RTargetEncoding(const MCInst &MI, unsigned OpNum,
                                           SmallVectorImpl<MCFixup> &Fixups,
                                           const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNum);
  if (MO.isImm()) {
    int32_t Res = MO.getImm();
    // We don't check first 2 bits, because in these bits we could store first 2
    // bits of instruction address
    Res >>= 2;
    return Res;
  }

  assert((MO.isExpr()) && "Unexpected operand value!");

  Fixups.push_back(MCFixup::create(
      0, MO.getExpr(), MCFixupKind(Xtensa::fixup_xtensa_l32r_16), MI.getLoc()));
  return 0;
}

uint32_t
XtensaMCCodeEmitter::getMemRegEncoding(const MCInst &MI, unsigned OpNo,
                                       SmallVectorImpl<MCFixup> &Fixups,
                                       const MCSubtargetInfo &STI) const {
  assert(MI.getOperand(OpNo + 1).isImm());

  uint32_t Res = static_cast<uint32_t>(MI.getOperand(OpNo + 1).getImm());

  switch (MI.getOpcode()) {
  case Xtensa::S16I:
  case Xtensa::L16SI:
  case Xtensa::L16UI:
    if (Res & 0x1) {
      llvm_unreachable("Unexpected operand value!");
    }
    Res >>= 1;
    break;
  case Xtensa::S32I:
  case Xtensa::L32I:
  case Xtensa::S32I_N:
  case Xtensa::L32I_N:
  case Xtensa::S32F:
  case Xtensa::L32F:
  case Xtensa::S32C1I:
    if (Res & 0x3) {
      llvm_unreachable("Unexpected operand value!");
    }
    Res >>= 2;
    break;
  }

  switch (MI.getOpcode()) {
  case Xtensa::S32I_N:
  case Xtensa::L32I_N:
    assert((isUInt<4>(Res)) && "Unexpected operand value!");
    break;
  default:
    assert((isUInt<8>(Res)) && "Unexpected operand value!");
    break;
  }

  uint32_t OffBits = Res << 4;
  uint32_t RegBits = getMachineOpValue(MI, MI.getOperand(OpNo), Fixups, STI);

  return ((OffBits & 0xFF0) | RegBits);
}

uint32_t XtensaMCCodeEmitter::getImm8OpValue(const MCInst &MI, unsigned OpNo,
                                             SmallVectorImpl<MCFixup> &Fixups,
                                             const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  int32_t Res = MO.getImm();

  assert(((Res >= -128) && (Res <= 127)) && "Unexpected operand value!");

  return (Res & 0xff);
}

uint32_t
XtensaMCCodeEmitter::getImm8_sh8OpValue(const MCInst &MI, unsigned OpNo,
                                        SmallVectorImpl<MCFixup> &Fixups,
                                        const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  int32_t Res = MO.getImm();

  assert(((Res >= -32768) && (Res <= 32512) && ((Res & 0xff) == 0)) &&
         "Unexpected operand value!");

  return (Res & 0xffff);
}

uint32_t
XtensaMCCodeEmitter::getImm12OpValue(const MCInst &MI, unsigned OpNo,
                                     SmallVectorImpl<MCFixup> &Fixups,
                                     const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  int32_t Res = MO.getImm();

  assert(((Res >= -2048) && (Res <= 2047)) && "Unexpected operand value!");

  return (Res & 0xfff);
}

uint32_t
XtensaMCCodeEmitter::getUimm4OpValue(const MCInst &MI, unsigned OpNo,
                                     SmallVectorImpl<MCFixup> &Fixups,
                                     const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  uint32_t Res = static_cast<uint32_t>(MO.getImm());

  assert((Res <= 15) && "Unexpected operand value!");

  return Res & 0xf;
}

uint32_t
XtensaMCCodeEmitter::getUimm5OpValue(const MCInst &MI, unsigned OpNo,
                                     SmallVectorImpl<MCFixup> &Fixups,
                                     const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  uint32_t Res = static_cast<uint32_t>(MO.getImm());

  assert((Res <= 31) && "Unexpected operand value!");

  return (Res & 0x1f);
}

uint32_t
XtensaMCCodeEmitter::getShimm1_31OpValue(const MCInst &MI, unsigned OpNo,
                                         SmallVectorImpl<MCFixup> &Fixups,
                                         const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  uint32_t Res = static_cast<uint32_t>(MO.getImm());

  assert(((Res >= 1) && (Res <= 31)) && "Unexpected operand value!");

  return ((32 - Res) & 0x1f);
}

uint32_t
XtensaMCCodeEmitter::getImm1_16OpValue(const MCInst &MI, unsigned OpNo,
                                       SmallVectorImpl<MCFixup> &Fixups,
                                       const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  uint32_t Res = static_cast<uint32_t>(MO.getImm());

  assert(((Res >= 1) && (Res <= 16)) && "Unexpected operand value!");

  return (Res - 1);
}

uint32_t
XtensaMCCodeEmitter::getImm1n_15OpValue(const MCInst &MI, unsigned OpNo,
                                        SmallVectorImpl<MCFixup> &Fixups,
                                        const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  int32_t Res = static_cast<int32_t>(MO.getImm());

  assert(((Res >= -1) && (Res <= 15) && (Res != 0)) &&
         "Unexpected operand value!");

  if (Res < 0)
    Res = 0;

  return Res;
}

uint32_t
XtensaMCCodeEmitter::getImm32n_95OpValue(const MCInst &MI, unsigned OpNo,
                                         SmallVectorImpl<MCFixup> &Fixups,
                                         const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  int32_t Res = static_cast<int32_t>(MO.getImm());

  assert(((Res >= -32) && (Res <= 95)) && "Unexpected operand value!");

  return Res;
}

uint32_t
XtensaMCCodeEmitter::getImm8n_7OpValue(const MCInst &MI, unsigned OpNo,
                                       SmallVectorImpl<MCFixup> &Fixups,
                                       const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  int32_t Res = static_cast<int32_t>(MO.getImm());

  assert(((Res >= -8) && (Res <= 7)) && "Unexpected operand value!");

  if (Res < 0)
    return Res + 16;

  return Res;
}

uint32_t
XtensaMCCodeEmitter::getImm64n_4nOpValue(const MCInst &MI, unsigned OpNo,
                                         SmallVectorImpl<MCFixup> &Fixups,
                                         const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  int32_t Res = static_cast<int32_t>(MO.getImm());

  assert(((Res >= -64) && (Res <= -4) && ((Res & 0x3) == 0)) &&
         "Unexpected operand value!");

  return Res & 0x3f;
}

uint32_t
XtensaMCCodeEmitter::getEntry_Imm12OpValue(const MCInst &MI, unsigned OpNo,
                                           SmallVectorImpl<MCFixup> &Fixups,
                                           const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  uint32_t res = static_cast<uint32_t>(MO.getImm());

  assert(((res & 0x7) == 0) && "Unexpected operand value!");

  return res;
}

uint32_t
XtensaMCCodeEmitter::getB4constOpValue(const MCInst &MI, unsigned OpNo,
                                       SmallVectorImpl<MCFixup> &Fixups,
                                       const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  uint32_t Res = static_cast<uint32_t>(MO.getImm());

  switch (Res) {
  case 0xffffffff:
    Res = 0;
    break;
  case 1:
  case 2:
  case 3:
  case 4:
  case 5:
  case 6:
  case 7:
  case 8:
    break;
  case 10:
    Res = 9;
    break;
  case 12:
    Res = 10;
    break;
  case 16:
    Res = 11;
    break;
  case 32:
    Res = 12;
    break;
  case 64:
    Res = 13;
    break;
  case 128:
    Res = 14;
    break;
  case 256:
    Res = 15;
    break;
  default:
    llvm_unreachable("Unexpected operand value!");
  }

  return Res;
}

uint32_t
XtensaMCCodeEmitter::getB4constuOpValue(const MCInst &MI, unsigned OpNo,
                                        SmallVectorImpl<MCFixup> &Fixups,
                                        const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  uint32_t Res = static_cast<uint32_t>(MO.getImm());

  switch (Res) {
  case 32768:
    Res = 0;
    break;
  case 65536:
    Res = 1;
    break;
  case 2:
  case 3:
  case 4:
  case 5:
  case 6:
  case 7:
  case 8:
    break;
  case 10:
    Res = 9;
    break;
  case 12:
    Res = 10;
    break;
  case 16:
    Res = 11;
    break;
  case 32:
    Res = 12;
    break;
  case 64:
    Res = 13;
    break;
  case 128:
    Res = 14;
    break;
  case 256:
    Res = 15;
    break;
  default:
    llvm_unreachable("Unexpected operand value!");
  }

  return Res;
}

uint32_t
XtensaMCCodeEmitter::getSeimm7_22OpValue(const MCInst &MI, unsigned OpNo,
                                         SmallVectorImpl<MCFixup> &Fixups,
                                         const MCSubtargetInfo &STI) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  uint32_t res = static_cast<uint32_t>(MO.getImm());

  res -= 7;
  assert(((res & 0xf) == res) && "Unexpected operand value!");

  return res;
}

#include "XtensaGenMCCodeEmitter.inc"
