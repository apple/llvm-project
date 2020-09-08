// RUN: mlir-opt %s -mlir-disable-threading=true -pass-pipeline='func(cse,canonicalize)' -print-ir-before=cse  -o /dev/null 2>&1 | FileCheck -check-prefix=BEFORE %s
// RUN: mlir-opt %s -mlir-disable-threading=true -pass-pipeline='func(cse,canonicalize)' -print-ir-before-all -o /dev/null 2>&1 | FileCheck -check-prefix=BEFORE_ALL %s
// RUN: mlir-opt %s -mlir-disable-threading=true -pass-pipeline='func(cse,canonicalize)' -print-ir-after=cse -o /dev/null 2>&1 | FileCheck -check-prefix=AFTER %s
// RUN: mlir-opt %s -mlir-disable-threading=true -pass-pipeline='func(cse,canonicalize)' -print-ir-after-all -o /dev/null 2>&1 | FileCheck -check-prefix=AFTER_ALL %s
// RUN: mlir-opt %s -mlir-disable-threading=true -pass-pipeline='func(cse,canonicalize)' -print-ir-before=cse -print-ir-module-scope -o /dev/null 2>&1 | FileCheck -check-prefix=BEFORE_MODULE %s
// RUN: mlir-opt %s -mlir-disable-threading=true -pass-pipeline='func(cse,cse)' -print-ir-after-all -print-ir-after-change -o /dev/null 2>&1 | FileCheck -check-prefix=AFTER_ALL_CHANGE %s

func @foo() {
  %0 = constant 0 : i32
  return
}

func @bar() {
  return
}

// BEFORE: *** IR Dump Before{{.*}}CSE ***
// BEFORE-NEXT: func @foo()
// BEFORE: *** IR Dump Before{{.*}}CSE ***
// BEFORE-NEXT: func @bar()
// BEFORE-NOT: *** IR Dump Before{{.*}}Canonicalizer ***
// BEFORE-NOT: *** IR Dump After

// BEFORE_ALL: *** IR Dump Before{{.*}}CSE ***
// BEFORE_ALL-NEXT: func @foo()
// BEFORE_ALL: *** IR Dump Before{{.*}}Canonicalizer ***
// BEFORE_ALL-NEXT: func @foo()
// BEFORE_ALL: *** IR Dump Before{{.*}}CSE ***
// BEFORE_ALL-NEXT: func @bar()
// BEFORE_ALL: *** IR Dump Before{{.*}}Canonicalizer ***
// BEFORE_ALL-NEXT: func @bar()
// BEFORE_ALL-NOT: *** IR Dump After

// AFTER-NOT: *** IR Dump Before
// AFTER: *** IR Dump After{{.*}}CSE ***
// AFTER-NEXT: func @foo()
// AFTER: *** IR Dump After{{.*}}CSE ***
// AFTER-NEXT: func @bar()
// AFTER-NOT: *** IR Dump After{{.*}}Canonicalizer ***

// AFTER_ALL-NOT: *** IR Dump Before
// AFTER_ALL: *** IR Dump After{{.*}}CSE ***
// AFTER_ALL-NEXT: func @foo()
// AFTER_ALL: *** IR Dump After{{.*}}Canonicalizer ***
// AFTER_ALL-NEXT: func @foo()
// AFTER_ALL: *** IR Dump After{{.*}}CSE ***
// AFTER_ALL-NEXT: func @bar()
// AFTER_ALL: *** IR Dump After{{.*}}Canonicalizer ***
// AFTER_ALL-NEXT: func @bar()

// BEFORE_MODULE: *** IR Dump Before{{.*}}CSE *** ('func' operation: @foo)
// BEFORE_MODULE: func @foo()
// BEFORE_MODULE: func @bar()
// BEFORE_MODULE: *** IR Dump Before{{.*}}CSE *** ('func' operation: @bar)
// BEFORE_MODULE: func @foo()
// BEFORE_MODULE: func @bar()

// AFTER_ALL_CHANGE: *** IR Dump After{{.*}}CSE ***
// AFTER_ALL_CHANGE-NEXT: func @foo()
// AFTER_ALL_CHANGE-NOT: *** IR Dump After{{.*}}CSE ***
// We expect that only 'foo' changed during CSE, and the second run of CSE did
// nothing.
