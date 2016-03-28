//===--- APINotesYAMLCompiler.cpp - API Notes YAML format reader *- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file reads API notes specified in YAML format.
//
//===----------------------------------------------------------------------===//
#include "clang/APINotes/APINotesYAMLCompiler.h"
#include "clang/APINotes/APINotesReader.h"
#include "clang/APINotes/Types.h"
#include "clang/APINotes/APINotesWriter.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/YAMLParser.h"
#include "llvm/Support/YAMLTraits.h"
#include <algorithm>

/*
 
 YAML Format specification.

 Nullability should be expressed using one of the following values:
   O - Optional (or Nullable)
   N - Not Optional
   S - Scalar
   U - Unknown
 Note, the API is considered 'audited' when at least the return value or a
 parameter has a nullability value. For 'audited' APIs, we assume the default
 nullability for any underspecified type.

 FactoryAsInit can have the following values:
   C - Treat as class method.
   I - Treat as initializer.
   A - Automatically infer based on the name and type (default).

---
 Name: AppKit             # The name of the framework

 Availability: OSX        # Optional: Specifies which platform the API is
                          # available on. [OSX / iOS / none/
                          #                available / nonswift]

 AvailabilityMsg: ""  # Optional: Custom availability message to display to
                          # the user, when API is not available.

 Classes:                 # List of classes
 ...
 Protocols:               # List of protocols
 ...
 Functions:               # List of functions
 ...
 Globals:                 # List of globals
 ...
 Tags:                    # List of tags (struct/union/enum/C++ class)
 ...
 Typedefs:                # List of typedef-names and C++11 type aliases
 ...

 Each class and protocol is defined as following:

 - Name: NSView                       # The name of the class
 
   AuditedForNullability: false       # Optional: Specifies if the whole class
                                      # has been audited for nullability.
                                      # If yes, we assume all the methods and
                                      # properties of the class have default
                                      # nullability unless it is overwritten by
                                      # a method/property specific info below.
                                      # This applies to all classes, extensions,
                                      # and categories of the class defined in
                                      # the current framework/module.
                                      # (false/true)

   Availability: OSX

   AvailabilityMsg: ""

   Methods:
     - Selector: "setSubviews:"       # Full name

       MethodKind: Instance           # [Class/Instance]

       Nullability: [N, N, O, S]      # The nullability of parameters in
                                      # the signature.

       NullabilityOfRet: O            # The nullability of the return value.

       Availability: OSX

       AvailabilityMsg: ""

       FactoryAsInit: C               # Optional: Specifies if this method is a
                                      # factory initializer (false/true)
       DesignatedInit: false          # Optional: Specifies if this method is a
                                      # designated initializer (false/true)

       Required: false                # Optional: Specifies if this method is a
                                      # required initializer (false/true)

   Properties:
     - Name: window

       Nullability: O

       Availability: OSX

       AvailabilityMsg: ""

 The protocol definition format is the same as the class definition.

 Each function definition is of the following form:

 - Name: "myGlobalFunction"           # Full name

   Nullability: [N, N, O, S]          # The nullability of parameters in
                                      # the signature.

   NullabilityOfRet: O                # The nullability of the return value.

   Availability: OSX

   AvailabilityMsg: ""

Each global variable definition is of the following form:

 - Name: MyGlobalVar

   Nullability: O

   Availability: OSX

   AvailabilityMsg: ""

*/

using llvm::StringRef;
using namespace clang;
namespace {
  enum class APIAvailability {
    Available = 0,
    OSX,
    IOS,
    None,
    NonSwift,
  };

  enum class MethodKind {
    Class,
    Instance,
  };

  struct AvailabilityItem {
    APIAvailability Mode = APIAvailability::Available;
    StringRef Msg;
    AvailabilityItem() : Mode(APIAvailability::Available), Msg("") {}
  };

  static llvm::Optional<NullabilityKind> AbsentNullability = llvm::None;
  static llvm::Optional<NullabilityKind> DefaultNullability =
    NullabilityKind::NonNull;
  typedef std::vector<clang::NullabilityKind> NullabilitySeq;

  struct Method {
    StringRef Selector;
    MethodKind Kind;
    NullabilitySeq Nullability;
    llvm::Optional<NullabilityKind> NullabilityOfRet;
    AvailabilityItem Availability;
    StringRef SwiftName;
    api_notes::FactoryAsInitKind FactoryAsInit
      = api_notes::FactoryAsInitKind::Infer;
    bool DesignatedInit = false;
    bool Required = false;
  };
  typedef std::vector<Method> MethodsSeq;

  struct Property {
    StringRef Name;
    llvm::Optional<NullabilityKind> Nullability;
    AvailabilityItem Availability;
    StringRef SwiftName;
  };
  typedef std::vector<Property> PropertiesSeq;

  struct Class {
    StringRef Name;
    bool AuditedForNullability = false;
    AvailabilityItem Availability;
    StringRef SwiftName;
    StringRef SwiftBridge;
    MethodsSeq Methods;
    PropertiesSeq Properties;
  };
  typedef std::vector<Class> ClassesSeq;

  struct Function {
    StringRef Name;
    NullabilitySeq Nullability;
    llvm::Optional<NullabilityKind> NullabilityOfRet;
    AvailabilityItem Availability;
    StringRef SwiftName;
  };
  typedef std::vector<Function> FunctionsSeq;

  struct GlobalVariable {
    StringRef Name;
    llvm::Optional<NullabilityKind> Nullability;
    AvailabilityItem Availability;
    StringRef SwiftName;
  };
  typedef std::vector<GlobalVariable> GlobalVariablesSeq;

  struct Tag {
    StringRef Name;
    AvailabilityItem Availability;
    StringRef SwiftName;
    StringRef SwiftBridge;
  };
  typedef std::vector<Tag> TagsSeq;

  struct Typedef {
    StringRef Name;
    AvailabilityItem Availability;
    StringRef SwiftName;
    StringRef SwiftBridge;
  };
  typedef std::vector<Typedef> TypedefsSeq;

  struct Module {
    StringRef Name;
    AvailabilityItem Availability;
    ClassesSeq Classes;
    ClassesSeq Protocols;
    FunctionsSeq Functions;
    GlobalVariablesSeq Globals;
    TagsSeq Tags;
    TypedefsSeq Typedefs;

    LLVM_ATTRIBUTE_DEPRECATED(
      void dump() LLVM_ATTRIBUTE_USED,
      "only for use within the debugger");
  };
}

LLVM_YAML_IS_FLOW_SEQUENCE_VECTOR(clang::NullabilityKind)
LLVM_YAML_IS_SEQUENCE_VECTOR(Method)
LLVM_YAML_IS_SEQUENCE_VECTOR(Property)
LLVM_YAML_IS_SEQUENCE_VECTOR(Class)
LLVM_YAML_IS_SEQUENCE_VECTOR(Function)
LLVM_YAML_IS_SEQUENCE_VECTOR(GlobalVariable)
LLVM_YAML_IS_SEQUENCE_VECTOR(Tag)
LLVM_YAML_IS_SEQUENCE_VECTOR(Typedef)

namespace llvm {
  namespace yaml {

    template <>
    struct ScalarEnumerationTraits<NullabilityKind > {
      static void enumeration(IO &io, NullabilityKind  &value) {
        io.enumCase(value, "N", NullabilityKind::NonNull);
        io.enumCase(value, "O", NullabilityKind::Nullable);
        io.enumCase(value, "U", NullabilityKind::Unspecified);
        // TODO: Mapping this to it's own value would allow for better cross
        // checking. Also the default should be Unknown.
        io.enumCase(value, "S", NullabilityKind::Unspecified);
      }
    };

    template <>
    struct ScalarEnumerationTraits<api_notes::FactoryAsInitKind > {
      static void enumeration(IO &io, api_notes::FactoryAsInitKind  &value) {
        io.enumCase(value, "A", api_notes::FactoryAsInitKind::Infer);
        io.enumCase(value, "C", api_notes::FactoryAsInitKind::AsClassMethod);
        io.enumCase(value, "I", api_notes::FactoryAsInitKind::AsInitializer);
      }
    };

    template <>
    struct ScalarEnumerationTraits<MethodKind> {
      static void enumeration(IO &io, MethodKind &value) {
        io.enumCase(value, "Class",    MethodKind::Class);
        io.enumCase(value, "Instance", MethodKind::Instance);
      }
    };

    template <>
    struct ScalarEnumerationTraits<APIAvailability> {
      static void enumeration(IO &io, APIAvailability &value) {
        io.enumCase(value, "OSX",       APIAvailability::OSX);
        io.enumCase(value, "iOS",       APIAvailability::IOS);
        io.enumCase(value, "none",      APIAvailability::None);
        io.enumCase(value, "nonswift",  APIAvailability::NonSwift);
        io.enumCase(value, "available", APIAvailability::Available);
      }
    };

    template <>
    struct MappingTraits<Property> {
      static void mapping(IO &io, Property& p) {
        io.mapRequired("Name",            p.Name);
        io.mapOptional("Nullability",     p.Nullability, 
                                          AbsentNullability);
        io.mapOptional("Availability",    p.Availability.Mode);
        io.mapOptional("AvailabilityMsg", p.Availability.Msg);
        io.mapOptional("SwiftName",       p.SwiftName);
      }
    };

    template <>
    struct MappingTraits<Method> {
      static void mapping(IO &io, Method& m) {
        io.mapRequired("Selector",        m.Selector);
        io.mapRequired("MethodKind",      m.Kind);
        io.mapOptional("Nullability",     m.Nullability);
        io.mapOptional("NullabilityOfRet",  m.NullabilityOfRet,
                                            AbsentNullability);
        io.mapOptional("Availability",    m.Availability.Mode);
        io.mapOptional("AvailabilityMsg", m.Availability.Msg);
        io.mapOptional("SwiftName",       m.SwiftName);
        io.mapOptional("FactoryAsInit",   m.FactoryAsInit,
                                          api_notes::FactoryAsInitKind::Infer);
        io.mapOptional("DesignatedInit",  m.DesignatedInit, false);
        io.mapOptional("Required",        m.Required, false);
      }
    };

    template <>
    struct MappingTraits<Class> {
      static void mapping(IO &io, Class& c) {
        io.mapRequired("Name",                  c.Name);
        io.mapOptional("AuditedForNullability", c.AuditedForNullability, false);
        io.mapOptional("Availability",          c.Availability.Mode);
        io.mapOptional("AvailabilityMsg",       c.Availability.Msg);
        io.mapOptional("SwiftName",             c.SwiftName);
        io.mapOptional("SwiftBridge",           c.SwiftBridge);
        io.mapOptional("Methods",               c.Methods);
        io.mapOptional("Properties",            c.Properties);
      }
    };

    template <>
    struct MappingTraits<Function> {
      static void mapping(IO &io, Function& f) {
        io.mapRequired("Name",             f.Name);
        io.mapOptional("Nullability",      f.Nullability);
        io.mapOptional("NullabilityOfRet", f.NullabilityOfRet,
                                           AbsentNullability);
        io.mapOptional("Availability",     f.Availability.Mode);
        io.mapOptional("AvailabilityMsg",  f.Availability.Msg);
        io.mapOptional("SwiftName",        f.SwiftName);
      }
    };

    template <>
    struct MappingTraits<GlobalVariable> {
      static void mapping(IO &io, GlobalVariable& v) {
        io.mapRequired("Name",            v.Name);
        io.mapOptional("Nullability",     v.Nullability,
                                          AbsentNullability);
        io.mapOptional("Availability",    v.Availability.Mode);
        io.mapOptional("AvailabilityMsg", v.Availability.Msg);
        io.mapOptional("SwiftName",       v.SwiftName);
      }
    };

    template <>
    struct MappingTraits<Tag> {
      static void mapping(IO &io, Tag& t) {
        io.mapRequired("Name",                  t.Name);
        io.mapOptional("Availability",          t.Availability.Mode);
        io.mapOptional("AvailabilityMsg",       t.Availability.Msg);
        io.mapOptional("SwiftName",             t.SwiftName);
        io.mapOptional("SwiftBridge",           t.SwiftBridge);
      }
    };

    template <>
    struct MappingTraits<Typedef> {
      static void mapping(IO &io, Typedef& t) {
        io.mapRequired("Name",                  t.Name);
        io.mapOptional("Availability",          t.Availability.Mode);
        io.mapOptional("AvailabilityMsg",       t.Availability.Msg);
        io.mapOptional("SwiftName",             t.SwiftName);
        io.mapOptional("SwiftBridge",           t.SwiftBridge);
      }
    };

    template <>
    struct MappingTraits<Module> {
      static void mapping(IO &io, Module& m) {
        io.mapRequired("Name",            m.Name);
        io.mapOptional("Availability",    m.Availability.Mode);
        io.mapOptional("AvailabilityMsg", m.Availability.Msg);
        io.mapOptional("Classes",         m.Classes);
        io.mapOptional("Protocols",       m.Protocols);
        io.mapOptional("Functions",       m.Functions);
        io.mapOptional("Globals",         m.Globals);
        io.mapOptional("Tags",            m.Tags);
        io.mapOptional("Typedefs",        m.Typedefs);
      }
    };
  }
}

using llvm::yaml::Input;
using llvm::yaml::Output;

void Module::dump() {
  Output yout(llvm::errs());
  yout << *this;
}

static bool parseAPINotes(StringRef yamlInput, Module &module,
                          llvm::SourceMgr::DiagHandlerTy diagHandler,
                          void *diagHandlerCtxt) {
  Input yin(yamlInput, nullptr, diagHandler, diagHandlerCtxt);
  yin >> module;

  return static_cast<bool>(yin.error());
}

namespace {
  using namespace api_notes;

  class YAMLConverter {
    const Module &TheModule;
    APINotesWriter *Writer;
    OSType TargetOS;
    llvm::raw_ostream &OS;
    llvm::SourceMgr::DiagHandlerTy DiagHandler;
    void *DiagHandlerCtxt;
    bool ErrorOccured;

    /// Emit a diagnostic
    bool emitError(llvm::Twine message) {
      DiagHandler(llvm::SMDiagnostic("", llvm::SourceMgr::DK_Error,
                                     message.str()),
                  DiagHandlerCtxt);
      ErrorOccured = true;
      return true;
    }

  public:
    YAMLConverter(const Module &module,
                 OSType targetOS,
                 llvm::raw_ostream &os,
                 llvm::SourceMgr::DiagHandlerTy diagHandler,
                 void *diagHandlerCtxt) :
      TheModule(module), Writer(0), TargetOS(targetOS), OS(os),
      DiagHandler(diagHandler), DiagHandlerCtxt(diagHandlerCtxt),
      ErrorOccured(false) {}

    bool isAvailable(const AvailabilityItem &in) {
      // Check if the API is available on the OS for which we are building.
      if (in.Mode == APIAvailability::OSX && TargetOS != OSType::OSX)
        return false;
      if (in.Mode == APIAvailability::IOS && TargetOS != OSType::IOS)
        return false;
      return true;
    }

    bool convertAvailability(const AvailabilityItem &in,
                             CommonEntityInfo &outInfo,
                             llvm::StringRef apiName) {
      // Populate the unavailability information.
      outInfo.Unavailable = (in.Mode == APIAvailability::None);
      outInfo.UnavailableInSwift = (in.Mode == APIAvailability::NonSwift);
      if (outInfo.Unavailable || outInfo.UnavailableInSwift) {
        outInfo.UnavailableMsg = in.Msg;
      } else {
        if (!in.Msg.empty()) {
          emitError("availability message for available API '" +
                    apiName + "' will not be used");
        }
      }
      return false;
    }

    void convertNullability(const NullabilitySeq &nullability,
                            Optional<NullabilityKind> nullabilityOfRet,
                            FunctionInfo &outInfo,
                            llvm::StringRef apiName) {
      if (nullability.size() > FunctionInfo::getMaxNullabilityIndex()) {
        emitError("nullability info for " + apiName + " does not fit");
        return;
      }

      bool audited = false;
      unsigned int idx = 1;
      for (auto i = nullability.begin(),
                e = nullability.end(); i != e; ++i, ++idx){
        outInfo.addTypeInfo(idx, *i);
        audited = true;
      }
      if (nullabilityOfRet) {
        outInfo.addTypeInfo(0, *nullabilityOfRet);
        audited = true;
      } else if (audited) {
        outInfo.addTypeInfo(0, *DefaultNullability);
      }
      if (audited) {
        outInfo.NullabilityAudited = audited;
        outInfo.NumAdjustedNullable = idx;
      }
    }

    /// Convert the common parts of an entity from YAML.
    template<typename T>
    bool convertCommon(const T& common, CommonEntityInfo &info,
                       StringRef apiName) {
      if (!isAvailable(common.Availability))
        return true;

      convertAvailability(common.Availability, info, apiName);
      info.SwiftName = common.SwiftName;
      return false;
    }
    
    /// Convert the common parts of a type entity from YAML.
    template<typename T>
    bool convertCommonType(const T& common, CommonTypeInfo &info,
                           StringRef apiName) {
      if (convertCommon(common, info, apiName))
        return true;

      info.setSwiftBridge(common.SwiftBridge);
      return false;
    }

    // Translate from Method into ObjCMethodInfo and write it out.
    void convertMethod(const Method &meth,
                       ContextID classID, StringRef className) {
      ObjCMethodInfo mInfo;

      if (convertCommon(meth, mInfo, meth.Selector))
        return;

      // Check if the selector ends with ':' to determine if it takes arguments.
      bool takesArguments = meth.Selector.endswith(":");

      // Split the selector into pieces.
      llvm::SmallVector<StringRef, 4> a;
      meth.Selector.split(a, ":", /*MaxSplit*/ -1, /*KeepEmpty*/ false);
      if (!takesArguments && a.size() > 1 ) {
        emitError("selector " + meth.Selector + "is missing a ':' at the end");
        return;
      }

      // Construct ObjCSelectorRef.
      api_notes::ObjCSelectorRef selectorRef;
      selectorRef.NumPieces = !takesArguments ? 0 : a.size();
      selectorRef.Identifiers = a;

      // Translate the initializer info.
      mInfo.DesignatedInit = meth.DesignatedInit;
      mInfo.Required = meth.Required;
      if (meth.FactoryAsInit != FactoryAsInitKind::Infer)
        mInfo.setFactoryAsInitKind(meth.FactoryAsInit);

      // Translate nullability info.
      convertNullability(meth.Nullability, meth.NullabilityOfRet,
                         mInfo, meth.Selector);

      // Write it.
      Writer->addObjCMethod(classID, selectorRef,
                            meth.Kind == MethodKind::Instance,
                            mInfo);
    }

    void convertContext(const Class &cl, bool isClass) {
      // Write the class.
      ObjCContextInfo cInfo;

      if (convertCommonType(cl, cInfo, cl.Name))
        return;

      if (cl.AuditedForNullability)
        cInfo.setDefaultNullability(*DefaultNullability);

      ContextID clID = isClass ? Writer->addObjCClass(cl.Name, cInfo) :
                                 Writer->addObjCProtocol(cl.Name, cInfo);

      // Write all methods.
      llvm::StringMap<std::pair<bool, bool>> knownMethods;
      for (const auto &method : cl.Methods) {
        // Check for duplicate method definitions.
        bool isInstanceMethod = method.Kind == MethodKind::Instance;
        bool &known = isInstanceMethod ? knownMethods[method.Selector].first
                                       : knownMethods[method.Selector].second;
        if (known) {
          emitError(llvm::Twine("duplicate definition of method '") +
                    (isInstanceMethod? "-" : "+") + "[" + cl.Name + " " +
                    method.Selector + "]'");
          continue;
        }
        known = true;

        convertMethod(method, clID, cl.Name);
      }

      // Write all properties.
      llvm::StringSet<> knownProperties;
      for (const auto &prop : cl.Properties) {
        // Check for duplicate property definitions.
        if (!knownProperties.insert(prop.Name).second) {
          emitError("duplicate definition of property '" + cl.Name + "." +
                    prop.Name + "'");
          continue;
        }

        // Translate from Property into ObjCPropertyInfo.
        ObjCPropertyInfo pInfo;
        if (!isAvailable(prop.Availability))
          continue;
        convertAvailability(prop.Availability, pInfo, prop.Name);
        pInfo.SwiftName = prop.SwiftName;
        if (prop.Nullability)
          pInfo.setNullabilityAudited(*prop.Nullability);
        Writer->addObjCProperty(clID, prop.Name, pInfo);
      }
    }

    bool convertModule() {
      if (!isAvailable(TheModule.Availability))
        return false;

      // Set up the writer.
      // FIXME: This is kindof ugly.
      APINotesWriter writer(TheModule.Name);
      Writer = &writer;

      // Write all classes.
      llvm::StringSet<> knownClasses;
      for (const auto &cl : TheModule.Classes) {
        // Check for duplicate class definitions.
        if (!knownClasses.insert(cl.Name).second) {
          emitError("multiple definitions of class '" + cl.Name + "'");
          continue;
        }

        convertContext(cl, /*isClass*/ true);
      }

      // Write all protocols.
      llvm::StringSet<> knownProtocols;
      for (const auto &pr : TheModule.Protocols) {
        // Check for duplicate protocol definitions.
        if (!knownProtocols.insert(pr.Name).second) {
          emitError("multiple definitions of protocol '" + pr.Name + "'");
          continue;
        }

        convertContext(pr, /*isClass*/ false);
      }

      // Write all global variables.
      llvm::StringSet<> knownGlobals;
      for (const auto &global : TheModule.Globals) {
        // Check for duplicate global variables.
        if (!knownGlobals.insert(global.Name).second) {
          emitError("multiple definitions of global variable '" +
                    global.Name + "'");
          continue;
        }

        GlobalVariableInfo info;
        if (!isAvailable(global.Availability))
          continue;
        convertAvailability(global.Availability, info, global.Name);
        info.SwiftName = global.SwiftName;
        if (global.Nullability)
          info.setNullabilityAudited(*global.Nullability);
        Writer->addGlobalVariable(global.Name, info);
      }

      // Write all global functions.
      llvm::StringSet<> knownFunctions;
      for (const auto &function : TheModule.Functions) {
        // Check for duplicate global functions.
        if (!knownFunctions.insert(function.Name).second) {
          emitError("multiple definitions of global function '" +
                    function.Name + "'");
          continue;
        }

        GlobalFunctionInfo info;
        if (!isAvailable(function.Availability))
          continue;
        convertAvailability(function.Availability, info, function.Name);
        info.SwiftName = function.SwiftName;
        convertNullability(function.Nullability,
                           function.NullabilityOfRet,
                           info, function.Name);

        Writer->addGlobalFunction(function.Name, info);
      }

      // Write all tags.
      llvm::StringSet<> knownTags;
      for (const auto &t : TheModule.Tags) {
        // Check for duplicate tag definitions.
        if (!knownTags.insert(t.Name).second) {
          emitError("multiple definitions of tag '" + t.Name + "'");
          continue;
        }

        TagInfo tagInfo;
        if (convertCommonType(t, tagInfo, t.Name))
          continue;

        Writer->addTag(t.Name, tagInfo);
      }

      // Write all typedefs.
      llvm::StringSet<> knownTypedefs;
      for (const auto &t : TheModule.Typedefs) {
        // Check for duplicate typedef definitions.
        if (!knownTags.insert(t.Name).second) {
          emitError("multiple definitions of typedef '" + t.Name + "'");
          continue;
        }

        TypedefInfo typedefInfo;
        if (convertCommonType(t, typedefInfo, t.Name))
          continue;

        Writer->addTypedef(t.Name, typedefInfo);
      }

      if (!ErrorOccured)
        Writer->writeToStream(OS);

      return ErrorOccured;
    }
  };
}

static bool compile(const Module &module,
                    llvm::raw_ostream &os,
                    api_notes::OSType targetOS,
                    llvm::SourceMgr::DiagHandlerTy diagHandler,
                    void *diagHandlerCtxt){
  using namespace api_notes;

  YAMLConverter c(module, targetOS, os, diagHandler, diagHandlerCtxt);
  return c.convertModule();
}

bool api_notes::parseAndDumpAPINotes(StringRef yamlInput)  {
  Module module;

  if (parseAPINotes(yamlInput, module, nullptr, nullptr))
    return true;

  Output yout(llvm::outs());
  yout << module;

  return false;
}

/// Simple diagnostic handler that prints diagnostics to standard error.
static void printDiagnostic(const llvm::SMDiagnostic &diag, void *context) {
  diag.print(nullptr, llvm::errs());
}

bool api_notes::compileAPINotes(StringRef yamlInput,
                                llvm::raw_ostream &os,
                                OSType targetOS,
                                llvm::SourceMgr::DiagHandlerTy diagHandler,
                                void *diagHandlerCtxt) {
  Module module;

  if (!diagHandler) {
    diagHandler = &printDiagnostic;
  }

  if (parseAPINotes(yamlInput, module, diagHandler, diagHandlerCtxt))
    return true;

  return compile(module, os, targetOS, diagHandler, diagHandlerCtxt);
}

namespace {
  // Deserialize the API notes file into a module.
  class DecompileVisitor : public APINotesReader::Visitor {
    /// Allocator used to clone those strings that need it.
    llvm::BumpPtrAllocator Allocator;

    /// The module we're building.
    Module TheModule;

    /// A mapping from context ID to a pair (index, is-protocol) that indicates
    /// the index of that class or protocol in the global "classes" or
    /// "protocols" list.
    llvm::DenseMap<unsigned, std::pair<unsigned, bool>> knownContexts;

    /// Copy a string into allocated memory so it does disappear on us.
    StringRef copyString(StringRef string) {
      if (string.empty()) return StringRef();

      void *ptr = Allocator.Allocate(string.size(), 1);
      memcpy(ptr, string.data(), string.size());
      return StringRef(reinterpret_cast<const char *>(ptr), string.size());
    }

    template<typename T>
    void handleCommon(T &record, const CommonEntityInfo &info) {
      handleAvailability(record.Availability, info);
      record.SwiftName = copyString(info.SwiftName);
    }

    template<typename T>
    void handleCommonType(T &record, const CommonTypeInfo &info) {
      handleCommon(record, info);
      record.SwiftBridge = copyString(info.getSwiftBridge());      
    }

    /// Map Objective-C context info.
    void handleObjCContext(Class &record, StringRef name,
                           const ObjCContextInfo &info) {
      record.Name = name;

      handleCommonType(record, info);

      if (info.getDefaultNullability()) {
        record.AuditedForNullability = true;
      }
    }

    /// Map availability information, if present.
    void handleAvailability(AvailabilityItem &availability,
                            const CommonEntityInfo &info) {
      if (info.Unavailable) {
        availability.Mode = APIAvailability::None;
        availability.Msg = copyString(info.UnavailableMsg);
      }

      if (info.UnavailableInSwift) {
        availability.Mode = APIAvailability::NonSwift;
        availability.Msg = copyString(info.UnavailableMsg);
      }
    }

    /// Map nullability information for a function.
    void handleNullability(NullabilitySeq &nullability,
                           llvm::Optional<NullabilityKind> &nullabilityOfRet,
                           const FunctionInfo &info,
                           unsigned numParams) {
      if (info.NullabilityAudited) {
        nullabilityOfRet = info.getReturnTypeInfo();

        // Figure out the number of parameters from the selector.
        for (unsigned i = 0; i != numParams; ++i)
          nullability.push_back(info.getParamTypeInfo(i));
      }
    }

  public:
    virtual void visitObjCClass(ContextID contextID, StringRef name,
                                const ObjCContextInfo &info) {
      // Record this known context.
      knownContexts[contextID.Value] = { TheModule.Classes.size(), false };

      // Add the class.
      TheModule.Classes.push_back(Class());
      handleObjCContext(TheModule.Classes.back(), name, info);
    }

    virtual void visitObjCProtocol(ContextID contextID, StringRef name,
                                   const ObjCContextInfo &info) {
      // Record this known context.
      knownContexts[contextID.Value] = { TheModule.Protocols.size(), true };

      // Add the protocol.
      TheModule.Protocols.push_back(Class());
      handleObjCContext(TheModule.Protocols.back(), name, info);
    }

    virtual void visitObjCMethod(ContextID contextID, StringRef selector,
                                 bool isInstanceMethod,
                                 const ObjCMethodInfo &info) {
      Method method;
      method.Selector = copyString(selector);
      method.Kind = isInstanceMethod ? MethodKind::Instance : MethodKind::Class;

      handleCommon(method, info);
      handleNullability(method.Nullability, method.NullabilityOfRet, info,
                        selector.count(':'));
      method.FactoryAsInit = info.getFactoryAsInitKind();
      method.DesignatedInit = info.DesignatedInit;
      method.Required = info.Required;

      auto known = knownContexts[contextID.Value];
      if (known.second)
        TheModule.Protocols[known.first].Methods.push_back(method);
      else
        TheModule.Classes[known.first].Methods.push_back(method);
    }

    virtual void visitObjCProperty(ContextID contextID, StringRef name,
                                   const ObjCPropertyInfo &info) {
      Property property;
      property.Name = name;
      handleCommon(property, info);

      // FIXME: No way to represent "not audited for nullability".
      if (auto nullability = info.getNullability()) {
        property.Nullability = *nullability;
      }

      auto known = knownContexts[contextID.Value];
      if (known.second)
        TheModule.Protocols[known.first].Properties.push_back(property);
      else
        TheModule.Classes[known.first].Properties.push_back(property);
    }

    virtual void visitGlobalFunction(StringRef name,
                                     const GlobalFunctionInfo &info) {
      Function function;
      function.Name = name;
      handleCommon(function, info);
      if (info.NumAdjustedNullable > 0)
        handleNullability(function.Nullability, function.NullabilityOfRet,
                          info, info.NumAdjustedNullable-1);

      TheModule.Functions.push_back(function);
    }

    virtual void visitGlobalVariable(StringRef name,
                                     const GlobalVariableInfo &info) {
      GlobalVariable global;
      global.Name = name;
      handleCommon(global, info);

      // FIXME: No way to represent "not audited for nullability".
      if (auto nullability = info.getNullability()) {
        global.Nullability = *nullability;
      }

      TheModule.Globals.push_back(global);
    }

    virtual void visitTag(StringRef name, const TagInfo &info) {
      Tag tag;
      tag.Name = name;
      handleCommonType(tag, info);
      TheModule.Tags.push_back(tag);
    }

    virtual void visitTypedef(StringRef name, const TypedefInfo &info) {
      Typedef td;
      td.Name = name;
      handleCommonType(td, info);
      TheModule.Typedefs.push_back(td);
    }

    /// Retrieve the module.
    Module &getModule() { return TheModule; }
  };
}

bool api_notes::decompileAPINotes(std::unique_ptr<llvm::MemoryBuffer> input,
                                  llvm::raw_ostream &os) {
  // Try to read the file.
  auto reader = APINotesReader::get(std::move(input));
  if (!reader) {
    llvm::errs() << "not a well-formed API notes binary file\n";
    return true;
  }

  DecompileVisitor decompileVisitor;
  reader->visit(decompileVisitor);

  // Sort the data in the module, because the API notes reader doesn't preserve
  // order.
  auto &module = decompileVisitor.getModule();

  // Set module name.
  module.Name = reader->getModuleName();

  // Sort classes.
  std::sort(module.Classes.begin(), module.Classes.end(),
            [](const Class &lhs, const Class &rhs) -> bool {
              return lhs.Name < rhs.Name;
            });

  // Sort protocols.
  std::sort(module.Protocols.begin(), module.Protocols.end(),
            [](const Class &lhs, const Class &rhs) -> bool {
              return lhs.Name < rhs.Name;
            });

  // Sort methods and properties within each class and protocol.
  auto sortMembers = [](Class &record) {
    // Sort properties.
    std::sort(record.Properties.begin(), record.Properties.end(),
              [](const Property &lhs, const Property &rhs) -> bool {
                return lhs.Name < rhs.Name;
              });

    // Sort methods.
    std::sort(record.Methods.begin(), record.Methods.end(),
              [](const Method &lhs, const Method &rhs) -> bool {
                return lhs.Selector < rhs.Selector ||
                       (lhs.Selector == rhs.Selector &&
                        static_cast<unsigned>(lhs.Kind)
                          < static_cast<unsigned>(rhs.Kind));
              });
  };
  std::for_each(module.Classes.begin(), module.Classes.end(), sortMembers);
  std::for_each(module.Protocols.begin(), module.Protocols.end(), sortMembers);

  // Sort functions.
  std::sort(module.Functions.begin(), module.Functions.end(),
            [](const Function &lhs, const Function &rhs) -> bool {
              return lhs.Name < rhs.Name;
            });

  // Sort global variables.
  std::sort(module.Globals.begin(), module.Globals.end(),
            [](const GlobalVariable &lhs, const GlobalVariable &rhs) -> bool {
              return lhs.Name < rhs.Name;
            });

  // Sort tags.
  std::sort(module.Tags.begin(), module.Tags.end(),
            [](const Tag &lhs, const Tag &rhs) -> bool {
              return lhs.Name < rhs.Name;
            });

  // Sort typedefs.
  std::sort(module.Typedefs.begin(), module.Typedefs.end(),
            [](const Typedef &lhs, const Typedef &rhs) -> bool {
              return lhs.Name < rhs.Name;
            });

  // Output the YAML representation.
  Output yout(os);
  yout << module;

  return false;
}

