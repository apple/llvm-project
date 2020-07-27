//===--- PPC.h - Declare PPC target feature support -------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares PPC TargetInfo objects.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CLANG_LIB_BASIC_TARGETS_PPC_H
#define LLVM_CLANG_LIB_BASIC_TARGETS_PPC_H

#include "OSTargets.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/Basic/TargetOptions.h"
#include "llvm/ADT/Triple.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/Support/Compiler.h"

namespace clang {
namespace targets {

// PPC abstract base class
class LLVM_LIBRARY_VISIBILITY PPCTargetInfo : public TargetInfo {

  /// Flags for architecture specific defines.
  typedef enum {
    ArchDefineNone = 0,
    ArchDefineName = 1 << 0, // <name> is substituted for arch name.
    ArchDefinePpcgr = 1 << 1,
    ArchDefinePpcsq = 1 << 2,
    ArchDefine440 = 1 << 3,
    ArchDefine603 = 1 << 4,
    ArchDefine604 = 1 << 5,
    ArchDefinePwr4 = 1 << 6,
    ArchDefinePwr5 = 1 << 7,
    ArchDefinePwr5x = 1 << 8,
    ArchDefinePwr6 = 1 << 9,
    ArchDefinePwr6x = 1 << 10,
    ArchDefinePwr7 = 1 << 11,
    ArchDefinePwr8 = 1 << 12,
    ArchDefinePwr9 = 1 << 13,
    ArchDefinePwr10 = 1 << 14,
    ArchDefineFuture = 1 << 15,
    ArchDefineA2 = 1 << 16,
    ArchDefineA2q = 1 << 17,
    ArchDefineE500 = 1 << 18
  } ArchDefineTypes;

  ArchDefineTypes ArchDefs = ArchDefineNone;
  static const Builtin::Info BuiltinInfo[];
  static const char *const GCCRegNames[];
  static const TargetInfo::GCCRegAlias GCCRegAliases[];
  std::string CPU;
  enum PPCFloatABI { HardFloat, SoftFloat } FloatABI;

  // Target cpu features.
  bool HasAltivec = false;
  bool HasVSX = false;
  bool HasP8Vector = false;
  bool HasP8Crypto = false;
  bool HasDirectMove = false;
  bool HasQPX = false;
  bool HasHTM = false;
  bool HasBPERMD = false;
  bool HasExtDiv = false;
  bool HasP9Vector = false;
  bool HasSPE = false;
  bool HasP10Vector = false;
  bool HasPCRelativeMemops = false;

protected:
  std::string ABI;

public:
  PPCTargetInfo(const llvm::Triple &Triple, const TargetOptions &)
      : TargetInfo(Triple) {
    SuitableAlign = 128;
    SimdDefaultAlign = 128;
    LongDoubleWidth = LongDoubleAlign = 128;
    LongDoubleFormat = &llvm::APFloat::PPCDoubleDouble();
  }

  // Set the language option for altivec based on our value.
  void adjust(LangOptions &Opts) override;

  // Note: GCC recognizes the following additional cpus:
  //  401, 403, 405, 405fp, 440fp, 464, 464fp, 476, 476fp, 505, 740, 801,
  //  821, 823, 8540, e300c2, e300c3, e500mc64, e6500, 860, cell, titan, rs64.
  bool isValidCPUName(StringRef Name) const override;
  void fillValidCPUList(SmallVectorImpl<StringRef> &Values) const override;

  bool setCPU(const std::string &Name) override {
    bool CPUKnown = isValidCPUName(Name);
    if (CPUKnown) {
      CPU = Name;

      // CPU identification.
      ArchDefs =
          (ArchDefineTypes)llvm::StringSwitch<int>(CPU)
              .Case("440", ArchDefineName)
              .Case("450", ArchDefineName | ArchDefine440)
              .Case("601", ArchDefineName)
              .Case("602", ArchDefineName | ArchDefinePpcgr)
              .Case("603", ArchDefineName | ArchDefinePpcgr)
              .Case("603e", ArchDefineName | ArchDefine603 | ArchDefinePpcgr)
              .Case("603ev", ArchDefineName | ArchDefine603 | ArchDefinePpcgr)
              .Case("604", ArchDefineName | ArchDefinePpcgr)
              .Case("604e", ArchDefineName | ArchDefine604 | ArchDefinePpcgr)
              .Case("620", ArchDefineName | ArchDefinePpcgr)
              .Case("630", ArchDefineName | ArchDefinePpcgr)
              .Case("7400", ArchDefineName | ArchDefinePpcgr)
              .Case("7450", ArchDefineName | ArchDefinePpcgr)
              .Case("750", ArchDefineName | ArchDefinePpcgr)
              .Case("970", ArchDefineName | ArchDefinePwr4 | ArchDefinePpcgr |
                               ArchDefinePpcsq)
              .Case("a2", ArchDefineA2)
              .Case("a2q", ArchDefineName | ArchDefineA2 | ArchDefineA2q)
              .Cases("power3", "pwr3", ArchDefinePpcgr)
              .Cases("power4", "pwr4",
                     ArchDefinePwr4 | ArchDefinePpcgr | ArchDefinePpcsq)
              .Cases("power5", "pwr5",
                     ArchDefinePwr5 | ArchDefinePwr4 | ArchDefinePpcgr |
                         ArchDefinePpcsq)
              .Cases("power5x", "pwr5x",
                     ArchDefinePwr5x | ArchDefinePwr5 | ArchDefinePwr4 |
                         ArchDefinePpcgr | ArchDefinePpcsq)
              .Cases("power6", "pwr6",
                     ArchDefinePwr6 | ArchDefinePwr5x | ArchDefinePwr5 |
                         ArchDefinePwr4 | ArchDefinePpcgr | ArchDefinePpcsq)
              .Cases("power6x", "pwr6x",
                     ArchDefinePwr6x | ArchDefinePwr6 | ArchDefinePwr5x |
                         ArchDefinePwr5 | ArchDefinePwr4 | ArchDefinePpcgr |
                         ArchDefinePpcsq)
              .Cases("power7", "pwr7",
                     ArchDefinePwr7 | ArchDefinePwr6 | ArchDefinePwr5x |
                         ArchDefinePwr5 | ArchDefinePwr4 | ArchDefinePpcgr |
                         ArchDefinePpcsq)
              // powerpc64le automatically defaults to at least power8.
              .Cases("power8", "pwr8", "ppc64le",
                     ArchDefinePwr8 | ArchDefinePwr7 | ArchDefinePwr6 |
                         ArchDefinePwr5x | ArchDefinePwr5 | ArchDefinePwr4 |
                         ArchDefinePpcgr | ArchDefinePpcsq)
              .Cases("power9", "pwr9",
                     ArchDefinePwr9 | ArchDefinePwr8 | ArchDefinePwr7 |
                         ArchDefinePwr6 | ArchDefinePwr5x | ArchDefinePwr5 |
                         ArchDefinePwr4 | ArchDefinePpcgr | ArchDefinePpcsq)
              .Cases("power10", "pwr10",
                     ArchDefinePwr10 | ArchDefinePwr9 | ArchDefinePwr8 |
                         ArchDefinePwr7 | ArchDefinePwr6 | ArchDefinePwr5x |
                         ArchDefinePwr5 | ArchDefinePwr4 | ArchDefinePpcgr |
                         ArchDefinePpcsq)
              .Case("future",
                    ArchDefineFuture | ArchDefinePwr10 | ArchDefinePwr9 |
                        ArchDefinePwr8 | ArchDefinePwr7 | ArchDefinePwr6 |
                        ArchDefinePwr5x | ArchDefinePwr5 | ArchDefinePwr4 |
                        ArchDefinePpcgr | ArchDefinePpcsq)
              .Cases("8548", "e500", ArchDefineE500)
              .Default(ArchDefineNone);
    }
    return CPUKnown;
  }

  StringRef getABI() const override { return ABI; }

  ArrayRef<Builtin::Info> getTargetBuiltins() const override;

  bool isCLZForZeroUndef() const override { return false; }

  void getTargetDefines(const LangOptions &Opts,
                        MacroBuilder &Builder) const override;

  bool
  initFeatureMap(llvm::StringMap<bool> &Features, DiagnosticsEngine &Diags,
                 StringRef CPU,
                 const std::vector<std::string> &FeaturesVec) const override;

  void addP10SpecificFeatures(llvm::StringMap<bool> &Features) const;
  void addFutureSpecificFeatures(llvm::StringMap<bool> &Features) const;

  bool handleTargetFeatures(std::vector<std::string> &Features,
                            DiagnosticsEngine &Diags) override;

  bool hasFeature(StringRef Feature) const override;

  void setFeatureEnabled(llvm::StringMap<bool> &Features, StringRef Name,
                         bool Enabled) const override;

  ArrayRef<const char *> getGCCRegNames() const override;

  ArrayRef<TargetInfo::GCCRegAlias> getGCCRegAliases() const override;

  ArrayRef<TargetInfo::AddlRegName> getGCCAddlRegNames() const override;

  bool validateAsmConstraint(const char *&Name,
                             TargetInfo::ConstraintInfo &Info) const override {
    switch (*Name) {
    default:
      return false;
    case 'O': // Zero
      break;
    case 'f': // Floating point register
      // Don't use floating point registers on soft float ABI.
      if (FloatABI == SoftFloat)
        return false;
      LLVM_FALLTHROUGH;
    case 'b': // Base register
      Info.setAllowsRegister();
      break;
    // FIXME: The following are added to allow parsing.
    // I just took a guess at what the actions should be.
    // Also, is more specific checking needed?  I.e. specific registers?
    case 'd': // Floating point register (containing 64-bit value)
    case 'v': // Altivec vector register
      // Don't use floating point and altivec vector registers
      // on soft float ABI
      if (FloatABI == SoftFloat)
        return false;
      Info.setAllowsRegister();
      break;
    case 'w':
      switch (Name[1]) {
      case 'd': // VSX vector register to hold vector double data
      case 'f': // VSX vector register to hold vector float data
      case 's': // VSX vector register to hold scalar double data
      case 'w': // VSX vector register to hold scalar double data
      case 'a': // Any VSX register
      case 'c': // An individual CR bit
      case 'i': // FP or VSX register to hold 64-bit integers data
        break;
      default:
        return false;
      }
      Info.setAllowsRegister();
      Name++; // Skip over 'w'.
      break;
    case 'h': // `MQ', `CTR', or `LINK' register
    case 'q': // `MQ' register
    case 'c': // `CTR' register
    case 'l': // `LINK' register
    case 'x': // `CR' register (condition register) number 0
    case 'y': // `CR' register (condition register)
    case 'z': // `XER[CA]' carry bit (part of the XER register)
      Info.setAllowsRegister();
      break;
    case 'I': // Signed 16-bit constant
    case 'J': // Unsigned 16-bit constant shifted left 16 bits
              //  (use `L' instead for SImode constants)
    case 'K': // Unsigned 16-bit constant
    case 'L': // Signed 16-bit constant shifted left 16 bits
    case 'M': // Constant larger than 31
    case 'N': // Exact power of 2
    case 'P': // Constant whose negation is a signed 16-bit constant
    case 'G': // Floating point constant that can be loaded into a
              // register with one instruction per word
    case 'H': // Integer/Floating point constant that can be loaded
              // into a register using three instructions
      break;
    case 'm': // Memory operand. Note that on PowerPC targets, m can
              // include addresses that update the base register. It
              // is therefore only safe to use `m' in an asm statement
              // if that asm statement accesses the operand exactly once.
              // The asm statement must also use `%U<opno>' as a
              // placeholder for the "update" flag in the corresponding
              // load or store instruction. For example:
              // asm ("st%U0 %1,%0" : "=m" (mem) : "r" (val));
              // is correct but:
              // asm ("st %1,%0" : "=m" (mem) : "r" (val));
              // is not. Use es rather than m if you don't want the base
              // register to be updated.
    case 'e':
      if (Name[1] != 's')
        return false;
      // es: A "stable" memory operand; that is, one which does not
      // include any automodification of the base register. Unlike
      // `m', this constraint can be used in asm statements that
      // might access the operand several times, or that might not
      // access it at all.
      Info.setAllowsMemory();
      Name++; // Skip over 'e'.
      break;
    case 'Q': // Memory operand that is an offset from a register (it is
              // usually better to use `m' or `es' in asm statements)
      Info.setAllowsRegister();
      LLVM_FALLTHROUGH;
    case 'Z': // Memory operand that is an indexed or indirect from a
              // register (it is usually better to use `m' or `es' in
              // asm statements)
      Info.setAllowsMemory();
      break;
    case 'R': // AIX TOC entry
    case 'a': // Address operand that is an indexed or indirect from a
              // register (`p' is preferable for asm statements)
    case 'S': // Constant suitable as a 64-bit mask operand
    case 'T': // Constant suitable as a 32-bit mask operand
    case 'U': // System V Release 4 small data area reference
    case 't': // AND masks that can be performed by two rldic{l, r}
              // instructions
    case 'W': // Vector constant that does not require memory
    case 'j': // Vector constant that is all zeros.
      break;
      // End FIXME.
    }
    return true;
  }

  std::string convertConstraint(const char *&Constraint) const override {
    std::string R;
    switch (*Constraint) {
    case 'e':
    case 'w':
      // Two-character constraint; add "^" hint for later parsing.
      R = std::string("^") + std::string(Constraint, 2);
      Constraint++;
      break;
    default:
      return TargetInfo::convertConstraint(Constraint);
    }
    return R;
  }

  const char *getClobbers() const override { return ""; }
  int getEHDataRegisterNumber(unsigned RegNo) const override {
    if (RegNo == 0)
      return 3;
    if (RegNo == 1)
      return 4;
    return -1;
  }

  bool hasSjLjLowering() const override { return true; }

  const char *getLongDoubleMangling() const override {
    if (LongDoubleWidth == 64)
      return "e";
    return LongDoubleFormat == &llvm::APFloat::PPCDoubleDouble()
               ? "g"
               : "u9__ieee128";
  }
  const char *getFloat128Mangling() const override { return "u9__ieee128"; }

  bool hasExtIntType() const override { return true; }

  bool isSPRegName(StringRef RegName) const override {
    return RegName.equals("r1") || RegName.equals("x1");
  }
};

class LLVM_LIBRARY_VISIBILITY PPC32TargetInfo : public PPCTargetInfo {
public:
  PPC32TargetInfo(const llvm::Triple &Triple, const TargetOptions &Opts)
      : PPCTargetInfo(Triple, Opts) {
    if (Triple.isOSAIX())
      resetDataLayout("E-m:a-p:32:32-i64:64-n32");
    else
      resetDataLayout("E-m:e-p:32:32-i64:64-n32");

    switch (getTriple().getOS()) {
    case llvm::Triple::Linux:
    case llvm::Triple::FreeBSD:
    case llvm::Triple::NetBSD:
      SizeType = UnsignedInt;
      PtrDiffType = SignedInt;
      IntPtrType = SignedInt;
      break;
    case llvm::Triple::AIX:
      SizeType = UnsignedLong;
      PtrDiffType = SignedLong;
      IntPtrType = SignedLong;
      SuitableAlign = 64;
      LongDoubleWidth = 64;
      LongDoubleAlign = DoubleAlign = 32;
      LongDoubleFormat = &llvm::APFloat::IEEEdouble();
      break;
    default:
      break;
    }

    if (Triple.isOSFreeBSD() || Triple.isOSNetBSD() || Triple.isOSOpenBSD() ||
        Triple.isMusl()) {
      LongDoubleWidth = LongDoubleAlign = 64;
      LongDoubleFormat = &llvm::APFloat::IEEEdouble();
    }

    // PPC32 supports atomics up to 4 bytes.
    MaxAtomicPromoteWidth = MaxAtomicInlineWidth = 32;
  }

  BuiltinVaListKind getBuiltinVaListKind() const override {
    // This is the ELF definition, and is overridden by the Darwin sub-target
    return TargetInfo::PowerABIBuiltinVaList;
  }
};

// Note: ABI differences may eventually require us to have a separate
// TargetInfo for little endian.
class LLVM_LIBRARY_VISIBILITY PPC64TargetInfo : public PPCTargetInfo {
public:
  PPC64TargetInfo(const llvm::Triple &Triple, const TargetOptions &Opts)
      : PPCTargetInfo(Triple, Opts) {
    LongWidth = LongAlign = PointerWidth = PointerAlign = 64;
    IntMaxType = SignedLong;
    Int64Type = SignedLong;

    if (Triple.isOSAIX()) {
      // TODO: Set appropriate ABI for AIX platform.
      resetDataLayout("E-m:a-i64:64-n32:64");
      SuitableAlign = 64;
      LongDoubleWidth = 64;
      LongDoubleAlign = DoubleAlign = 32;
      LongDoubleFormat = &llvm::APFloat::IEEEdouble();
    } else if ((Triple.getArch() == llvm::Triple::ppc64le)) {
      resetDataLayout("e-m:e-i64:64-n32:64");
      ABI = "elfv2";
    } else {
      resetDataLayout("E-m:e-i64:64-n32:64");
      ABI = "elfv1";
    }

    if (Triple.isOSFreeBSD() || Triple.isMusl()) {
      LongDoubleWidth = LongDoubleAlign = 64;
      LongDoubleFormat = &llvm::APFloat::IEEEdouble();
    }

    // PPC64 supports atomics up to 8 bytes.
    MaxAtomicPromoteWidth = MaxAtomicInlineWidth = 64;
  }

  BuiltinVaListKind getBuiltinVaListKind() const override {
    return TargetInfo::CharPtrBuiltinVaList;
  }

  // PPC64 Linux-specific ABI options.
  bool setABI(const std::string &Name) override {
    if (Name == "elfv1" || Name == "elfv1-qpx" || Name == "elfv2") {
      ABI = Name;
      return true;
    }
    return false;
  }

  CallingConvCheckResult checkCallingConvention(CallingConv CC) const override {
    switch (CC) {
    case CC_Swift:
      return CCCR_OK;
    default:
      return CCCR_Warning;
    }
  }
};

class LLVM_LIBRARY_VISIBILITY DarwinPPC32TargetInfo
    : public DarwinTargetInfo<PPC32TargetInfo> {
public:
  DarwinPPC32TargetInfo(const llvm::Triple &Triple, const TargetOptions &Opts)
      : DarwinTargetInfo<PPC32TargetInfo>(Triple, Opts) {
    HasAlignMac68kSupport = true;
    BoolWidth = BoolAlign = 32; // XXX support -mone-byte-bool?
    PtrDiffType = SignedInt; // for http://llvm.org/bugs/show_bug.cgi?id=15726
    LongLongAlign = 32;
    resetDataLayout("E-m:o-p:32:32-f64:32:64-n32");
  }

  BuiltinVaListKind getBuiltinVaListKind() const override {
    return TargetInfo::CharPtrBuiltinVaList;
  }
};

class LLVM_LIBRARY_VISIBILITY DarwinPPC64TargetInfo
    : public DarwinTargetInfo<PPC64TargetInfo> {
public:
  DarwinPPC64TargetInfo(const llvm::Triple &Triple, const TargetOptions &Opts)
      : DarwinTargetInfo<PPC64TargetInfo>(Triple, Opts) {
    HasAlignMac68kSupport = true;
    resetDataLayout("E-m:o-i64:64-n32:64");
  }
};

class LLVM_LIBRARY_VISIBILITY AIXPPC32TargetInfo :
  public AIXTargetInfo<PPC32TargetInfo> {
public:
  using AIXTargetInfo::AIXTargetInfo;
  BuiltinVaListKind getBuiltinVaListKind() const override {
    return TargetInfo::CharPtrBuiltinVaList;
  }
};

class LLVM_LIBRARY_VISIBILITY AIXPPC64TargetInfo :
  public AIXTargetInfo<PPC64TargetInfo> {
public:
  using AIXTargetInfo::AIXTargetInfo;
};

} // namespace targets
} // namespace clang
#endif // LLVM_CLANG_LIB_BASIC_TARGETS_PPC_H
