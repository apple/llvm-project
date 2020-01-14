// RUN: %clang_cc1 -emit-interface-stubs -o - %s | FileCheck %s

// CHECK: --- !experimental-ifs-v1
// CHECK-NEXT: IfsVersion: 1.0
// CHECK-NEXT: Triple:
// CHECK-NEXT: ObjectFileFormat: ELF
// CHECK-NEXT: Symbols:
// CHECK-NEXT:   f" : { Type: Object, Size: 1 }
// CHECK-NEXT: ...
auto f = [](void* data) { int i; };
