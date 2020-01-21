//===-- TestClangASTContext.cpp ---------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "TestingSupport/SubsystemRAII.h"
#include "TestingSupport/Symbol/ClangTestUtils.h"
#include "lldb/Host/FileSystem.h"
#include "lldb/Host/HostInfo.h"
#include "lldb/Symbol/ClangASTContext.h"
#include "lldb/Symbol/ClangUtil.h"
#include "lldb/Symbol/Declaration.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/ExprCXX.h"
#include "gtest/gtest.h"

using namespace clang;
using namespace lldb;
using namespace lldb_private;

class TestClangASTContext : public testing::Test {
public:
  SubsystemRAII<FileSystem, HostInfo> subsystems;

  void SetUp() override {
    m_ast.reset(new ClangASTContext(HostInfo::GetTargetTriple()));
  }

  void TearDown() override { m_ast.reset(); }

protected:
  std::unique_ptr<ClangASTContext> m_ast;

  QualType GetBasicQualType(BasicType type) const {
    return ClangUtil::GetQualType(m_ast->GetBasicTypeFromAST(type));
  }

  QualType GetBasicQualType(const char *name) const {
    return ClangUtil::GetQualType(
        m_ast->GetBuiltinTypeByName(ConstString(name)));
  }
};

TEST_F(TestClangASTContext, TestGetBasicTypeFromEnum) {
  clang::ASTContext &context = m_ast->getASTContext();

  EXPECT_TRUE(
      context.hasSameType(GetBasicQualType(eBasicTypeBool), context.BoolTy));
  EXPECT_TRUE(
      context.hasSameType(GetBasicQualType(eBasicTypeChar), context.CharTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeChar16),
                                  context.Char16Ty));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeChar32),
                                  context.Char32Ty));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeDouble),
                                  context.DoubleTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeDoubleComplex),
                                  context.DoubleComplexTy));
  EXPECT_TRUE(
      context.hasSameType(GetBasicQualType(eBasicTypeFloat), context.FloatTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeFloatComplex),
                                  context.FloatComplexTy));
  EXPECT_TRUE(
      context.hasSameType(GetBasicQualType(eBasicTypeHalf), context.HalfTy));
  EXPECT_TRUE(
      context.hasSameType(GetBasicQualType(eBasicTypeInt), context.IntTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeInt128),
                                  context.Int128Ty));
  EXPECT_TRUE(
      context.hasSameType(GetBasicQualType(eBasicTypeLong), context.LongTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeLongDouble),
                                  context.LongDoubleTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeLongDoubleComplex),
                                  context.LongDoubleComplexTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeLongLong),
                                  context.LongLongTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeNullPtr),
                                  context.NullPtrTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeObjCClass),
                                  context.getObjCClassType()));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeObjCID),
                                  context.getObjCIdType()));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeObjCSel),
                                  context.getObjCSelType()));
  EXPECT_TRUE(
      context.hasSameType(GetBasicQualType(eBasicTypeShort), context.ShortTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeSignedChar),
                                  context.SignedCharTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeUnsignedChar),
                                  context.UnsignedCharTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeUnsignedInt),
                                  context.UnsignedIntTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeUnsignedInt128),
                                  context.UnsignedInt128Ty));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeUnsignedLong),
                                  context.UnsignedLongTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeUnsignedLongLong),
                                  context.UnsignedLongLongTy));
  EXPECT_TRUE(context.hasSameType(GetBasicQualType(eBasicTypeUnsignedShort),
                                  context.UnsignedShortTy));
  EXPECT_TRUE(
      context.hasSameType(GetBasicQualType(eBasicTypeVoid), context.VoidTy));
  EXPECT_TRUE(
      context.hasSameType(GetBasicQualType(eBasicTypeWChar), context.WCharTy));
}

TEST_F(TestClangASTContext, TestGetBasicTypeFromName) {
  EXPECT_EQ(GetBasicQualType(eBasicTypeChar), GetBasicQualType("char"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeSignedChar),
            GetBasicQualType("signed char"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedChar),
            GetBasicQualType("unsigned char"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeWChar), GetBasicQualType("wchar_t"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeSignedWChar),
            GetBasicQualType("signed wchar_t"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedWChar),
            GetBasicQualType("unsigned wchar_t"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeShort), GetBasicQualType("short"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeShort), GetBasicQualType("short int"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedShort),
            GetBasicQualType("unsigned short"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedShort),
            GetBasicQualType("unsigned short int"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeInt), GetBasicQualType("int"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeInt), GetBasicQualType("signed int"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedInt),
            GetBasicQualType("unsigned int"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedInt),
            GetBasicQualType("unsigned"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeLong), GetBasicQualType("long"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeLong), GetBasicQualType("long int"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedLong),
            GetBasicQualType("unsigned long"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedLong),
            GetBasicQualType("unsigned long int"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeLongLong),
            GetBasicQualType("long long"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeLongLong),
            GetBasicQualType("long long int"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedLongLong),
            GetBasicQualType("unsigned long long"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedLongLong),
            GetBasicQualType("unsigned long long int"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeInt128), GetBasicQualType("__int128_t"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeUnsignedInt128),
            GetBasicQualType("__uint128_t"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeVoid), GetBasicQualType("void"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeBool), GetBasicQualType("bool"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeFloat), GetBasicQualType("float"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeDouble), GetBasicQualType("double"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeLongDouble),
            GetBasicQualType("long double"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeObjCID), GetBasicQualType("id"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeObjCSel), GetBasicQualType("SEL"));
  EXPECT_EQ(GetBasicQualType(eBasicTypeNullPtr), GetBasicQualType("nullptr"));
}

void VerifyEncodingAndBitSize(ClangASTContext &clang_context,
                              lldb::Encoding encoding, unsigned int bit_size) {
  clang::ASTContext &context = clang_context.getASTContext();

  CompilerType type =
      clang_context.GetBuiltinTypeForEncodingAndBitSize(encoding, bit_size);
  EXPECT_TRUE(type.IsValid());

  QualType qtype = ClangUtil::GetQualType(type);
  EXPECT_FALSE(qtype.isNull());
  if (qtype.isNull())
    return;

  uint64_t actual_size = context.getTypeSize(qtype);
  EXPECT_EQ(bit_size, actual_size);

  const clang::Type *type_ptr = qtype.getTypePtr();
  EXPECT_NE(nullptr, type_ptr);
  if (!type_ptr)
    return;

  EXPECT_TRUE(type_ptr->isBuiltinType());
  switch (encoding) {
  case eEncodingSint:
    EXPECT_TRUE(type_ptr->isSignedIntegerType());
    break;
  case eEncodingUint:
    EXPECT_TRUE(type_ptr->isUnsignedIntegerType());
    break;
  case eEncodingIEEE754:
    EXPECT_TRUE(type_ptr->isFloatingType());
    break;
  default:
    FAIL() << "Unexpected encoding";
    break;
  }
}

TEST_F(TestClangASTContext, TestBuiltinTypeForEncodingAndBitSize) {
  // Make sure we can get types of every possible size in every possible
  // encoding.
  // We can't make any guarantee about which specific type we get, because the
  // standard
  // isn't that specific.  We only need to make sure the compiler hands us some
  // type that
  // is both a builtin type and matches the requested bit size.
  VerifyEncodingAndBitSize(*m_ast, eEncodingSint, 8);
  VerifyEncodingAndBitSize(*m_ast, eEncodingSint, 16);
  VerifyEncodingAndBitSize(*m_ast, eEncodingSint, 32);
  VerifyEncodingAndBitSize(*m_ast, eEncodingSint, 64);
  VerifyEncodingAndBitSize(*m_ast, eEncodingSint, 128);

  VerifyEncodingAndBitSize(*m_ast, eEncodingUint, 8);
  VerifyEncodingAndBitSize(*m_ast, eEncodingUint, 16);
  VerifyEncodingAndBitSize(*m_ast, eEncodingUint, 32);
  VerifyEncodingAndBitSize(*m_ast, eEncodingUint, 64);
  VerifyEncodingAndBitSize(*m_ast, eEncodingUint, 128);

  VerifyEncodingAndBitSize(*m_ast, eEncodingIEEE754, 32);
  VerifyEncodingAndBitSize(*m_ast, eEncodingIEEE754, 64);
}

TEST_F(TestClangASTContext, TestIsClangType) {
  clang::ASTContext &context = m_ast->getASTContext();
  lldb::opaque_compiler_type_t bool_ctype =
      ClangASTContext::GetOpaqueCompilerType(&context, lldb::eBasicTypeBool);
  CompilerType bool_type(m_ast.get(), bool_ctype);
  CompilerType record_type = m_ast->CreateRecordType(
      nullptr, lldb::eAccessPublic, "FooRecord", clang::TTK_Struct,
      lldb::eLanguageTypeC_plus_plus, nullptr);
  // Clang builtin type and record type should pass
  EXPECT_TRUE(ClangUtil::IsClangType(bool_type));
  EXPECT_TRUE(ClangUtil::IsClangType(record_type));

  // Default constructed type should fail
  EXPECT_FALSE(ClangUtil::IsClangType(CompilerType()));
}

TEST_F(TestClangASTContext, TestRemoveFastQualifiers) {
  CompilerType record_type = m_ast->CreateRecordType(
      nullptr, lldb::eAccessPublic, "FooRecord", clang::TTK_Struct,
      lldb::eLanguageTypeC_plus_plus, nullptr);
  QualType qt;

  qt = ClangUtil::GetQualType(record_type);
  EXPECT_EQ(0u, qt.getLocalFastQualifiers());
  record_type = record_type.AddConstModifier();
  record_type = record_type.AddVolatileModifier();
  record_type = record_type.AddRestrictModifier();
  qt = ClangUtil::GetQualType(record_type);
  EXPECT_NE(0u, qt.getLocalFastQualifiers());
  record_type = ClangUtil::RemoveFastQualifiers(record_type);
  qt = ClangUtil::GetQualType(record_type);
  EXPECT_EQ(0u, qt.getLocalFastQualifiers());
}

TEST_F(TestClangASTContext, TestConvertAccessTypeToAccessSpecifier) {
  EXPECT_EQ(AS_none,
            ClangASTContext::ConvertAccessTypeToAccessSpecifier(eAccessNone));
  EXPECT_EQ(AS_none, ClangASTContext::ConvertAccessTypeToAccessSpecifier(
                         eAccessPackage));
  EXPECT_EQ(AS_public,
            ClangASTContext::ConvertAccessTypeToAccessSpecifier(eAccessPublic));
  EXPECT_EQ(AS_private, ClangASTContext::ConvertAccessTypeToAccessSpecifier(
                            eAccessPrivate));
  EXPECT_EQ(AS_protected, ClangASTContext::ConvertAccessTypeToAccessSpecifier(
                              eAccessProtected));
}

TEST_F(TestClangASTContext, TestUnifyAccessSpecifiers) {
  // Unifying two of the same type should return the same type
  EXPECT_EQ(AS_public,
            ClangASTContext::UnifyAccessSpecifiers(AS_public, AS_public));
  EXPECT_EQ(AS_private,
            ClangASTContext::UnifyAccessSpecifiers(AS_private, AS_private));
  EXPECT_EQ(AS_protected,
            ClangASTContext::UnifyAccessSpecifiers(AS_protected, AS_protected));

  // Otherwise the result should be the strictest of the two.
  EXPECT_EQ(AS_private,
            ClangASTContext::UnifyAccessSpecifiers(AS_private, AS_public));
  EXPECT_EQ(AS_private,
            ClangASTContext::UnifyAccessSpecifiers(AS_private, AS_protected));
  EXPECT_EQ(AS_private,
            ClangASTContext::UnifyAccessSpecifiers(AS_public, AS_private));
  EXPECT_EQ(AS_private,
            ClangASTContext::UnifyAccessSpecifiers(AS_protected, AS_private));
  EXPECT_EQ(AS_protected,
            ClangASTContext::UnifyAccessSpecifiers(AS_protected, AS_public));
  EXPECT_EQ(AS_protected,
            ClangASTContext::UnifyAccessSpecifiers(AS_public, AS_protected));

  // None is stricter than everything (by convention)
  EXPECT_EQ(AS_none,
            ClangASTContext::UnifyAccessSpecifiers(AS_none, AS_public));
  EXPECT_EQ(AS_none,
            ClangASTContext::UnifyAccessSpecifiers(AS_none, AS_protected));
  EXPECT_EQ(AS_none,
            ClangASTContext::UnifyAccessSpecifiers(AS_none, AS_private));
  EXPECT_EQ(AS_none,
            ClangASTContext::UnifyAccessSpecifiers(AS_public, AS_none));
  EXPECT_EQ(AS_none,
            ClangASTContext::UnifyAccessSpecifiers(AS_protected, AS_none));
  EXPECT_EQ(AS_none,
            ClangASTContext::UnifyAccessSpecifiers(AS_private, AS_none));
}

TEST_F(TestClangASTContext, TestRecordHasFields) {
  CompilerType int_type = m_ast->GetBasicType(eBasicTypeInt);

  // Test that a record with no fields returns false
  CompilerType empty_base = m_ast->CreateRecordType(
      nullptr, lldb::eAccessPublic, "EmptyBase", clang::TTK_Struct,
      lldb::eLanguageTypeC_plus_plus, nullptr);
  ClangASTContext::StartTagDeclarationDefinition(empty_base);
  ClangASTContext::CompleteTagDeclarationDefinition(empty_base);

  RecordDecl *empty_base_decl = ClangASTContext::GetAsRecordDecl(empty_base);
  EXPECT_NE(nullptr, empty_base_decl);
  EXPECT_FALSE(ClangASTContext::RecordHasFields(empty_base_decl));

  // Test that a record with direct fields returns true
  CompilerType non_empty_base = m_ast->CreateRecordType(
      nullptr, lldb::eAccessPublic, "NonEmptyBase", clang::TTK_Struct,
      lldb::eLanguageTypeC_plus_plus, nullptr);
  ClangASTContext::StartTagDeclarationDefinition(non_empty_base);
  FieldDecl *non_empty_base_field_decl = m_ast->AddFieldToRecordType(
      non_empty_base, "MyField", int_type, eAccessPublic, 0);
  ClangASTContext::CompleteTagDeclarationDefinition(non_empty_base);
  RecordDecl *non_empty_base_decl =
      ClangASTContext::GetAsRecordDecl(non_empty_base);
  EXPECT_NE(nullptr, non_empty_base_decl);
  EXPECT_NE(nullptr, non_empty_base_field_decl);
  EXPECT_TRUE(ClangASTContext::RecordHasFields(non_empty_base_decl));

  std::vector<std::unique_ptr<clang::CXXBaseSpecifier>> bases;

  // Test that a record with no direct fields, but fields in a base returns true
  CompilerType empty_derived = m_ast->CreateRecordType(
      nullptr, lldb::eAccessPublic, "EmptyDerived", clang::TTK_Struct,
      lldb::eLanguageTypeC_plus_plus, nullptr);
  ClangASTContext::StartTagDeclarationDefinition(empty_derived);
  std::unique_ptr<clang::CXXBaseSpecifier> non_empty_base_spec =
      m_ast->CreateBaseClassSpecifier(non_empty_base.GetOpaqueQualType(),
                                      lldb::eAccessPublic, false, false);
  bases.push_back(std::move(non_empty_base_spec));
  bool result = m_ast->TransferBaseClasses(empty_derived.GetOpaqueQualType(),
                                           std::move(bases));
  ClangASTContext::CompleteTagDeclarationDefinition(empty_derived);
  EXPECT_TRUE(result);
  CXXRecordDecl *empty_derived_non_empty_base_cxx_decl =
      m_ast->GetAsCXXRecordDecl(empty_derived.GetOpaqueQualType());
  RecordDecl *empty_derived_non_empty_base_decl =
      ClangASTContext::GetAsRecordDecl(empty_derived);
  EXPECT_EQ(1u, ClangASTContext::GetNumBaseClasses(
                    empty_derived_non_empty_base_cxx_decl, false));
  EXPECT_TRUE(
      ClangASTContext::RecordHasFields(empty_derived_non_empty_base_decl));

  // Test that a record with no direct fields, but fields in a virtual base
  // returns true
  CompilerType empty_derived2 = m_ast->CreateRecordType(
      nullptr, lldb::eAccessPublic, "EmptyDerived2", clang::TTK_Struct,
      lldb::eLanguageTypeC_plus_plus, nullptr);
  ClangASTContext::StartTagDeclarationDefinition(empty_derived2);
  std::unique_ptr<CXXBaseSpecifier> non_empty_vbase_spec =
      m_ast->CreateBaseClassSpecifier(non_empty_base.GetOpaqueQualType(),
                                      lldb::eAccessPublic, true, false);
  bases.push_back(std::move(non_empty_vbase_spec));
  result = m_ast->TransferBaseClasses(empty_derived2.GetOpaqueQualType(),
                                      std::move(bases));
  ClangASTContext::CompleteTagDeclarationDefinition(empty_derived2);
  EXPECT_TRUE(result);
  CXXRecordDecl *empty_derived_non_empty_vbase_cxx_decl =
      m_ast->GetAsCXXRecordDecl(empty_derived2.GetOpaqueQualType());
  RecordDecl *empty_derived_non_empty_vbase_decl =
      ClangASTContext::GetAsRecordDecl(empty_derived2);
  EXPECT_EQ(1u, ClangASTContext::GetNumBaseClasses(
                    empty_derived_non_empty_vbase_cxx_decl, false));
  EXPECT_TRUE(
      ClangASTContext::RecordHasFields(empty_derived_non_empty_vbase_decl));
}

TEST_F(TestClangASTContext, TemplateArguments) {
  ClangASTContext::TemplateParameterInfos infos;
  infos.names.push_back("T");
  infos.args.push_back(TemplateArgument(m_ast->getASTContext().IntTy));
  infos.names.push_back("I");
  llvm::APSInt arg(llvm::APInt(8, 47));
  infos.args.push_back(TemplateArgument(m_ast->getASTContext(), arg,
                                        m_ast->getASTContext().IntTy));

  // template<typename T, int I> struct foo;
  ClassTemplateDecl *decl = m_ast->CreateClassTemplateDecl(
      m_ast->GetTranslationUnitDecl(), eAccessPublic, "foo", TTK_Struct, infos);
  ASSERT_NE(decl, nullptr);

  // foo<int, 47>
  ClassTemplateSpecializationDecl *spec_decl =
      m_ast->CreateClassTemplateSpecializationDecl(
          m_ast->GetTranslationUnitDecl(), decl, TTK_Struct, infos);
  ASSERT_NE(spec_decl, nullptr);
  CompilerType type = m_ast->CreateClassTemplateSpecializationType(spec_decl);
  ASSERT_TRUE(type);
  m_ast->StartTagDeclarationDefinition(type);
  m_ast->CompleteTagDeclarationDefinition(type);

  // typedef foo<int, 47> foo_def;
  CompilerType typedef_type = m_ast->CreateTypedefType(
      type, "foo_def", m_ast->CreateDeclContext(m_ast->GetTranslationUnitDecl()));

  CompilerType auto_type(
      m_ast.get(),
      m_ast->getASTContext()
          .getAutoType(ClangUtil::GetCanonicalQualType(typedef_type),
                       clang::AutoTypeKeyword::Auto, false)
          .getAsOpaquePtr());

  CompilerType int_type(m_ast.get(),
                        m_ast->getASTContext().IntTy.getAsOpaquePtr());
  for (CompilerType t : {type, typedef_type, auto_type}) {
    SCOPED_TRACE(t.GetTypeName().AsCString());

    EXPECT_EQ(m_ast->GetTemplateArgumentKind(t.GetOpaqueQualType(), 0),
              eTemplateArgumentKindType);
    EXPECT_EQ(m_ast->GetTypeTemplateArgument(t.GetOpaqueQualType(), 0),
              int_type);
    EXPECT_EQ(llvm::None,
              m_ast->GetIntegralTemplateArgument(t.GetOpaqueQualType(), 0));

    EXPECT_EQ(m_ast->GetTemplateArgumentKind(t.GetOpaqueQualType(), 1),
              eTemplateArgumentKindIntegral);
    EXPECT_EQ(m_ast->GetTypeTemplateArgument(t.GetOpaqueQualType(), 1),
              CompilerType());
    auto result = m_ast->GetIntegralTemplateArgument(t.GetOpaqueQualType(), 1);
    ASSERT_NE(llvm::None, result);
    EXPECT_EQ(arg, result->value);
    EXPECT_EQ(int_type, result->type);
  }
}

static QualType makeConstInt(clang::ASTContext &ctxt) {
  QualType result(ctxt.IntTy);
  result.addConst();
  return result;
}

TEST_F(TestClangASTContext, TestGetTypeClassDeclType) {
  clang::ASTContext &ctxt = m_ast->getASTContext();
  auto *nullptr_expr = new (ctxt) CXXNullPtrLiteralExpr(ctxt.NullPtrTy, SourceLocation());
  QualType t = ctxt.getDecltypeType(nullptr_expr, makeConstInt(ctxt));
  EXPECT_EQ(lldb::eTypeClassBuiltin, m_ast->GetTypeClass(t.getAsOpaquePtr()));
}

TEST_F(TestClangASTContext, TestGetTypeClassTypeOf) {
  clang::ASTContext &ctxt = m_ast->getASTContext();
  QualType t = ctxt.getTypeOfType(makeConstInt(ctxt));
  EXPECT_EQ(lldb::eTypeClassBuiltin, m_ast->GetTypeClass(t.getAsOpaquePtr()));
}

TEST_F(TestClangASTContext, TestGetTypeClassTypeOfExpr) {
  clang::ASTContext &ctxt = m_ast->getASTContext();
  auto *nullptr_expr = new (ctxt) CXXNullPtrLiteralExpr(ctxt.NullPtrTy, SourceLocation());
  QualType t = ctxt.getTypeOfExprType(nullptr_expr);
  EXPECT_EQ(lldb::eTypeClassBuiltin, m_ast->GetTypeClass(t.getAsOpaquePtr()));
}

TEST_F(TestClangASTContext, TestGetTypeClassNested) {
  clang::ASTContext &ctxt = m_ast->getASTContext();
  QualType t_base = ctxt.getTypeOfType(makeConstInt(ctxt));
  QualType t = ctxt.getTypeOfType(t_base);
  EXPECT_EQ(lldb::eTypeClassBuiltin, m_ast->GetTypeClass(t.getAsOpaquePtr()));
}

TEST_F(TestClangASTContext, TestFunctionTemplateConstruction) {
  // Tests creating a function template.

  CompilerType int_type = m_ast->GetBasicType(lldb::eBasicTypeInt);
  clang::TranslationUnitDecl *TU = m_ast->GetTranslationUnitDecl();

  // Prepare the declarations/types we need for the template.
  CompilerType clang_type =
      m_ast->CreateFunctionType(int_type, nullptr, 0U, false, 0U);
  FunctionDecl *func =
      m_ast->CreateFunctionDeclaration(TU, "foo", clang_type, 0, false);
  ClangASTContext::TemplateParameterInfos empty_params;

  // Create the actual function template.
  clang::FunctionTemplateDecl *func_template =
      m_ast->CreateFunctionTemplateDecl(TU, func, "foo", empty_params);

  EXPECT_EQ(TU, func_template->getDeclContext());
  EXPECT_EQ("foo", func_template->getName());
  EXPECT_EQ(clang::AccessSpecifier::AS_none, func_template->getAccess());
}

TEST_F(TestClangASTContext, TestFunctionTemplateInRecordConstruction) {
  // Tests creating a function template inside a record.

  CompilerType int_type = m_ast->GetBasicType(lldb::eBasicTypeInt);
  clang::TranslationUnitDecl *TU = m_ast->GetTranslationUnitDecl();

  // Create a record we can put the function template int.
  CompilerType record_type =
      clang_utils::createRecordWithField(*m_ast, "record", int_type, "field");
  clang::TagDecl *record = ClangUtil::GetAsTagDecl(record_type);

  // Prepare the declarations/types we need for the template.
  CompilerType clang_type =
      m_ast->CreateFunctionType(int_type, nullptr, 0U, false, 0U);
  // We create the FunctionDecl for the template in the TU DeclContext because:
  // 1. FunctionDecls can't be in a Record (only CXXMethodDecls can).
  // 2. It is mirroring the behavior of DWARFASTParserClang::ParseSubroutine.
  FunctionDecl *func =
      m_ast->CreateFunctionDeclaration(TU, "foo", clang_type, 0, false);
  ClangASTContext::TemplateParameterInfos empty_params;

  // Create the actual function template.
  clang::FunctionTemplateDecl *func_template =
      m_ast->CreateFunctionTemplateDecl(record, func, "foo", empty_params);

  EXPECT_EQ(record, func_template->getDeclContext());
  EXPECT_EQ("foo", func_template->getName());
  EXPECT_EQ(clang::AccessSpecifier::AS_public, func_template->getAccess());
}

TEST_F(TestClangASTContext, TestDeletingImplicitCopyCstrDueToMoveCStr) {
  // We need to simulate this behavior in our AST that we construct as we don't
  // have a Sema instance that can do this for us:
  // C++11 [class.copy]p7, p18:
  //  If the class definition declares a move constructor or move assignment
  //  operator, an implicitly declared copy constructor or copy assignment
  //  operator is defined as deleted.

  // Create a record and start defining it.
  llvm::StringRef class_name = "S";
  CompilerType t = clang_utils::createRecord(*m_ast, class_name);
  m_ast->StartTagDeclarationDefinition(t);

  // Create a move constructor that will delete the implicit copy constructor.
  CompilerType return_type = m_ast->GetBasicType(lldb::eBasicTypeVoid);
  CompilerType param_type = t.GetRValueReferenceType();
  CompilerType function_type =
      m_ast->CreateFunctionType(return_type, &param_type, /*num_params*/ 1,
                                /*variadic=*/false, /*quals*/ 0U);
  bool is_virtual = false;
  bool is_static = false;
  bool is_inline = false;
  bool is_explicit = true;
  bool is_attr_used = false;
  bool is_artificial = false;
  m_ast->AddMethodToCXXRecordType(
      t.GetOpaqueQualType(), class_name, nullptr, function_type,
      lldb::AccessType::eAccessPublic, is_virtual, is_static, is_inline,
      is_explicit, is_attr_used, is_artificial);

  // Complete the definition and check the created record.
  m_ast->CompleteTagDeclarationDefinition(t);
  auto *record = llvm::cast<CXXRecordDecl>(ClangUtil::GetAsTagDecl(t));
  // We can't call defaultedCopyConstructorIsDeleted() as this requires that
  // the Decl passes through Sema which will actually compute this field.
  // Instead we check that there is no copy constructor declared by the user
  // which only leaves a non-deleted defaulted copy constructor as an option
  // that our record will have no simple copy constructor.
  EXPECT_FALSE(record->hasUserDeclaredCopyConstructor());
  EXPECT_FALSE(record->hasSimpleCopyConstructor());
}

TEST_F(TestClangASTContext, TestNotDeletingUserCopyCstrDueToMoveCStr) {
  // Tests that we don't delete the a user-defined copy constructor when
  // a move constructor is provided.
  // See also the TestDeletingImplicitCopyCstrDueToMoveCStr test.
  llvm::StringRef class_name = "S";
  CompilerType t = clang_utils::createRecord(*m_ast, class_name);
  m_ast->StartTagDeclarationDefinition(t);

  CompilerType return_type = m_ast->GetBasicType(lldb::eBasicTypeVoid);
  bool is_virtual = false;
  bool is_static = false;
  bool is_inline = false;
  bool is_explicit = true;
  bool is_attr_used = false;
  bool is_artificial = false;
  // Create a move constructor.
  {
    CompilerType param_type = t.GetRValueReferenceType();
    CompilerType function_type =
        m_ast->CreateFunctionType(return_type, &param_type, /*num_params*/ 1,
                                  /*variadic=*/false, /*quals*/ 0U);
    m_ast->AddMethodToCXXRecordType(
        t.GetOpaqueQualType(), class_name, nullptr, function_type,
        lldb::AccessType::eAccessPublic, is_virtual, is_static, is_inline,
        is_explicit, is_attr_used, is_artificial);
  }
  // Create a copy constructor.
  {
    CompilerType param_type = t.GetLValueReferenceType().AddConstModifier();
    CompilerType function_type =
        m_ast->CreateFunctionType(return_type, &param_type, /*num_params*/ 1,
                                  /*variadic=*/false, /*quals*/ 0U);
    m_ast->AddMethodToCXXRecordType(
        t.GetOpaqueQualType(), class_name, nullptr, function_type,
        lldb::AccessType::eAccessPublic, is_virtual, is_static, is_inline,
        is_explicit, is_attr_used, is_artificial);
  }

  // Complete the definition and check the created record.
  m_ast->CompleteTagDeclarationDefinition(t);
  auto *record = llvm::cast<CXXRecordDecl>(ClangUtil::GetAsTagDecl(t));
  EXPECT_TRUE(record->hasUserDeclaredCopyConstructor());
}
