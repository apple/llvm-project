//===-- TestTypeSystemSwiftTypeRef.cpp ------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#include "gtest/gtest.h"

#include "lldb/Symbol/SwiftASTContext.h"
#include "swift/Demangling/Demangle.h"
#include "swift/Demangling/Demangler.h"
#include "swift/Strings.h"

using namespace lldb;
using namespace lldb_private;
using namespace llvm;

struct TestTypeSystemSwiftTypeRef : public testing::Test {
  TypeSystemSwiftTypeRef m_swift_ts = TypeSystemSwiftTypeRef(nullptr);
  CompilerType GetCompilerType(const std::string &mangled_name) {
    ConstString internalized(mangled_name);
    return m_swift_ts.GetTypeFromMangledTypename(internalized);
  }
};

/// Helper class to conveniently construct demangle tree hierarchies.
class NodeBuilder {
  using NodePointer = swift::Demangle::NodePointer;
  using Kind = swift::Demangle::Node::Kind;
  
  swift::Demangle::Demangler &m_dem;

public:
  NodeBuilder(swift::Demangle::Demangler &dem) : m_dem(dem) {}
  NodePointer Node(Kind kind, StringRef text) {
    return m_dem.createNode(kind, text);
  }
  NodePointer Node(Kind kind, NodePointer child0 = nullptr,
                   NodePointer child1 = nullptr) {
    NodePointer node = m_dem.createNode(kind);

    if (child0)
      node->addChild(child0, m_dem);
    if (child1)
      node->addChild(child1, m_dem);
    return node;
  }

  std::string Mangle(NodePointer node) { return mangleNode(node); }
};

TEST_F(TestTypeSystemSwiftTypeRef, Array) {
  using namespace swift::Demangle;
  Demangler dem;
  NodeBuilder b(dem);
  NodePointer n = b.Node(
      Node::Kind::Global,
      b.Node(
          Node::Kind::TypeMangling,
          b.Node(
              Node::Kind::Type,
              b.Node(
                  Node::Kind::BoundGenericStructure,
                  b.Node(Node::Kind::Type,
                         b.Node(Node::Kind::Structure,
                                b.Node(Node::Kind::Module, swift::STDLIB_NAME),
                                b.Node(Node::Kind::Identifier, "Array"))),
                  b.Node(
                      Node::Kind::TypeList,
                      b.Node(
                          Node::Kind::Type,
                          b.Node(Node::Kind::Structure,
                                 b.Node(Node::Kind::Module, swift::STDLIB_NAME),
                                 b.Node(Node::Kind::Identifier,
                                        swift::BUILTIN_TYPE_NAME_INT))))))));
  CompilerType int_array = GetCompilerType(b.Mangle(n));
  ASSERT_TRUE(int_array.IsArrayType(nullptr, nullptr, nullptr));
}

TEST_F(TestTypeSystemSwiftTypeRef, Function) {
  using namespace swift::Demangle;
  Demangler dem;
  NodeBuilder b(dem);
  {
    NodePointer n = b.Node(
        Node::Kind::Global,
        b.Node(Node::Kind::TypeMangling,
               b.Node(Node::Kind::Type,
                      b.Node(Node::Kind::FunctionType,
                             b.Node(Node::Kind::ArgumentTuple,
                                    b.Node(Node::Kind::Type,
                                           b.Node(Node::Kind::Tuple))),
                             b.Node(Node::Kind::ReturnType,
                                    b.Node(Node::Kind::Type,
                                           b.Node(Node::Kind::Tuple)))))));
    CompilerType void_void = GetCompilerType(b.Mangle(n));
    ASSERT_TRUE(void_void.IsFunctionType(nullptr));
  }
  {
    NodePointer n =
        b.Node(Node::Kind::Global,
               b.Node(Node::Kind::TypeMangling,
                      b.Node(Node::Kind::Type,
                             b.Node(Node::Kind::ImplFunctionType,
                                    b.Node(Node::Kind::ImplEscaping),
                                    b.Node(Node::Kind::ImplConvention,
                                           "@callee_guaranteed")))));
    CompilerType opaque = GetCompilerType(b.Mangle(n));
    ASSERT_TRUE(opaque.IsFunctionType(nullptr));
  }
}
