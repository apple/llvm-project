// RUN: rm -rf %t.dir
// RUN: rm -rf %t.cdb
// RUN: mkdir -p %t.dir
// RUN: cp %s %t.dir/modules_cdb_input.cpp
// RUN: sed -e "s|DIR|%/t.dir|g" -e "s|FRAMEWORKS|%S/Inputs/frameworks|g" \
// RUN:   %S/Inputs/modules_inferred_cdb.json > %t.cdb
//
// RUN: echo -%t.dir > %t.result
// RUN: echo -%S >> %t.result
// RUN: clang-scan-deps -compilation-database %t.cdb -j 1 -full-command-line \
// RUN:   -mode preprocess-minimized-sources -format experimental-full >> %t.result
// RUN: cat %t.result | sed 's/\\/\//g' | FileCheck --check-prefixes=CHECK %s

#include <Inferred/Inferred.h>

inferred a = 0;

// CHECK: -[[PREFIX:.*]]
// CHECK-NEXT: -[[SOURCEDIR:.*]]
// CHECK-NEXT: {
// CHECK-NEXT:   "modules": [
// CHECK-NEXT:     {
// CHECK-NEXT:       "clang-module-deps": [],
// CHECK-NEXT:       "clang-modulemap-file": "[[SOURCEDIR]]/Inputs/frameworks/module.modulemap",
// CHECK-NEXT:       "command-line": [
// CHECK-NEXT:         "-remove-preceeding-explicit-module-build-incompatible-options",
// CHECK-NEXT:         "-fno-implicit-modules",
// CHECK-NEXT:         "-emit-module",
// CHECK-NEXT:         "-fmodule-name=Inferred"
// CHECK-NEXT:       ],
// CHECK-NEXT:       "context-hash": "[[CONTEXT_HASH_H1:[A-Z0-9]+]]",
// CHECK-NEXT:       "file-deps": [
// CHECK-NEXT:         "[[SOURCEDIR]]/Inputs/frameworks/Inferred.framework/Frameworks/Sub.framework/Headers/Sub.h",
// CHECK-NEXT:         "[[SOURCEDIR]]/Inputs/frameworks/Inferred.framework/Headers/Inferred.h",
// CHECK-NEXT:         "[[SOURCEDIR]]/Inputs/frameworks/Inferred.framework/__inferred_module.map"
// CHECK-NEXT:       ],
// CHECK-NEXT:       "name": "Inferred"
// CHECK-NEXT:     }
// CHECK-NEXT:   ],
// CHECK-NEXT:   "translation-units": [
// CHECK-NEXT:     {
// CHECK-NEXT:       "clang-context-hash": "[[CONTEXT_HASH_H1]]",
// CHECK-NEXT:       "clang-module-deps": [
// CHECK-NEXT:         {
// CHECK-NEXT:           "context-hash": "[[CONTEXT_HASH_H1]]",
// CHECK-NEXT:           "module-name": "Inferred"
// CHECK-NEXT:         }
// CHECK-NEXT:       ],
// CHECK-NEXT:       "command-line": [
// CHECK-NEXT:         "-fno-implicit-modules",
// CHECK-NEXT:         "-fno-implicit-module-maps",
// CHECK-NEXT:         "-fmodule-file=[[PREFIX]]/module-cache/[[CONTEXT_HASH_H1]]/Inferred-{{[A-Z0-9]+}}.pcm",
// CHECK-NEXT:         "-fmodule-map-file=[[SOURCEDIR]]/Inputs/frameworks/module.modulemap"
// CHECK-NEXT:       ],
// CHECK-NEXT:       "file-deps": [
// CHECK-NEXT:         "[[PREFIX]]/modules_cdb_input.cpp"
// CHECK-NEXT:       ],
// CHECK-NEXT:       "input-file": "[[PREFIX]]/modules_cdb_input.cpp"
// CHECK-NEXT:     }
// CHECK-NEXT:   ]
// CHECK-NEXT: }
