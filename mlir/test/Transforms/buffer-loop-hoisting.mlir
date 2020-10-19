// RUN: mlir-opt -buffer-loop-hoisting -split-input-file %s | FileCheck %s

// This file checks the behavior of BufferLoopHoisting pass for moving Alloc
// operations in their correct positions.

// Test Case:
//    bb0
//   /   \
//  bb1  bb2 <- Initial position of AllocOp
//   \   /
//    bb3
// BufferLoopHoisting expected behavior: It should not move the AllocOp.

#map0 = affine_map<(d0) -> (d0)>

// CHECK-LABEL: func @condBranch
func @condBranch(%arg0: i1, %arg1: memref<2xf32>, %arg2: memref<2xf32>) {
  cond_br %arg0, ^bb1, ^bb2
^bb1:
  br ^bb3(%arg1 : memref<2xf32>)
^bb2:
  %0 = alloc() : memref<2xf32>
  linalg.generic {indexing_maps = [#map0, #map0], iterator_types = ["parallel"]}
    ins(%arg1: memref<2xf32>)
    outs(%0: memref<2xf32>) {
  ^bb0(%gen1_arg0: f32, %gen1_arg1: f32):
    %tmp1 = exp %gen1_arg0 : f32
    linalg.yield %tmp1 : f32
  }
  br ^bb3(%0 : memref<2xf32>)
^bb3(%1: memref<2xf32>):
  "linalg.copy"(%1, %arg2) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}

// CHECK-NEXT: cond_br
//      CHECK: %[[ALLOC:.*]] = alloc()

// -----

// Test Case:
//    bb0
//   /   \
//  bb1  bb2 <- Initial position of AllocOp
//   \   /
//    bb3
// BufferLoopHoisting expected behavior: It should not move the existing AllocOp
// to any other block since the alloc has a dynamic dependency to block argument
// %0 in bb2.

#map0 = affine_map<(d0) -> (d0)>

// CHECK-LABEL: func @condBranchDynamicType
func @condBranchDynamicType(
  %arg0: i1,
  %arg1: memref<?xf32>,
  %arg2: memref<?xf32>,
  %arg3: index) {
  cond_br %arg0, ^bb1, ^bb2(%arg3: index)
^bb1:
  br ^bb3(%arg1 : memref<?xf32>)
^bb2(%0: index):
  %1 = alloc(%0) : memref<?xf32>
  linalg.generic {indexing_maps = [#map0, #map0], iterator_types = ["parallel"]}
    ins(%arg1: memref<?xf32>)
    outs(%1: memref<?xf32>) {
  ^bb0(%gen1_arg0: f32, %gen1_arg1: f32):
    %tmp1 = exp %gen1_arg0 : f32
    linalg.yield %tmp1 : f32
  }
  br ^bb3(%1 : memref<?xf32>)
^bb3(%2: memref<?xf32>):
  "linalg.copy"(%2, %arg2) : (memref<?xf32>, memref<?xf32>) -> ()
  return
}

// CHECK-NEXT: cond_br
//      CHECK: ^bb2
//      CHECK: ^bb2(%[[IDX:.*]]:{{.*}})
// CHECK-NEXT: %[[ALLOC0:.*]] = alloc(%[[IDX]])
// CHECK-NEXT: linalg.generic

// -----

// Test Case: Nested regions - This test defines a GenericOp inside the region
// of another GenericOp.
// BufferLoopHoisting expected behavior: The AllocOp of inner GenericOp should
// remain inside the region of outer GenericOp. The AllocOp of the outer
// GenericOp should not be moved during this pass.

#map0 = affine_map<(d0) -> (d0)>

// CHECK-LABEL: func @nested_regions_and_cond_branch
func @nested_regions_and_cond_branch(
  %arg0: i1,
  %arg1: memref<2xf32>,
  %arg2: memref<2xf32>) {
  cond_br %arg0, ^bb1, ^bb2
^bb1:
  br ^bb3(%arg1 : memref<2xf32>)
^bb2:
  %0 = alloc() : memref<2xf32>
  linalg.generic {
    indexing_maps = [#map0, #map0],
    iterator_types = ["parallel"]}
    ins(%arg1: memref<2xf32>)
    outs(%0: memref<2xf32>) {
  ^bb0(%gen1_arg0: f32, %gen1_arg1: f32):
    %1 = alloc() : memref<2xf32>
    linalg.generic {
      indexing_maps = [#map0, #map0],
      iterator_types = ["parallel"]}
      ins(%arg1: memref<2xf32>)
      outs(%1: memref<2xf32>) {
    ^bb0(%gen2_arg0: f32, %gen2_arg1: f32):
      %tmp2 = exp %gen2_arg0 : f32
      linalg.yield %tmp2 : f32
    }
    %tmp1 = exp %gen1_arg0 : f32
    linalg.yield %tmp1 : f32
  }
  br ^bb3(%0 : memref<2xf32>)
^bb3(%1: memref<2xf32>):
  "linalg.copy"(%1, %arg2) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}
// CHECK-NEXT:   cond_br
//      CHECK:   %[[ALLOC0:.*]] = alloc()
//      CHECK:   linalg.generic
//      CHECK:     %[[ALLOC1:.*]] = alloc()
// CHECK-NEXT:     linalg.generic

// -----

// Test Case: nested region control flow
// The alloc position of %1 does not need to be changed and flows through
// both if branches until it is finally returned.

// CHECK-LABEL: func @nested_region_control_flow
func @nested_region_control_flow(
  %arg0 : index,
  %arg1 : index) -> memref<?x?xf32> {
  %0 = cmpi "eq", %arg0, %arg1 : index
  %1 = alloc(%arg0, %arg0) : memref<?x?xf32>
  %2 = scf.if %0 -> (memref<?x?xf32>) {
    scf.yield %1 : memref<?x?xf32>
  } else {
    %3 = alloc(%arg0, %arg1) : memref<?x?xf32>
    scf.yield %1 : memref<?x?xf32>
  }
  return %2 : memref<?x?xf32>
}

//      CHECK: %[[ALLOC0:.*]] = alloc(%arg0, %arg0)
// CHECK-NEXT: %{{.*}} = scf.if
//      CHECK: else
// CHECK-NEXT: %[[ALLOC1:.*]] = alloc(%arg0, %arg1)

// -----

// Test Case: structured control-flow loop using a nested alloc.
// The alloc positions of %3 should not be changed.

// CHECK-LABEL: func @loop_alloc
func @loop_alloc(
  %lb: index,
  %ub: index,
  %step: index,
  %buf: memref<2xf32>,
  %res: memref<2xf32>) {
  %0 = alloc() : memref<2xf32>
  %1 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<2xf32> {
    %2 = cmpi "eq", %i, %ub : index
    %3 = alloc() : memref<2xf32>
    scf.yield %3 : memref<2xf32>
  }
  "linalg.copy"(%1, %res) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}

//      CHECK: %[[ALLOC0:.*]] = alloc()
// CHECK-NEXT: {{.*}} scf.for
//      CHECK: %[[ALLOC1:.*]] = alloc()

// -----

// Test Case: structured control-flow loop with a nested if operation using
// a deeply nested buffer allocation.
// The allocation %4 should not be moved upwards due to a back-edge dependency.

// CHECK-LABEL: func @loop_nested_if_alloc
func @loop_nested_if_alloc(
  %lb: index,
  %ub: index,
  %step: index,
  %buf: memref<2xf32>) -> memref<2xf32> {
  %0 = alloc() : memref<2xf32>
  %1 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<2xf32> {
    %2 = cmpi "eq", %i, %ub : index
    %3 = scf.if %2 -> (memref<2xf32>) {
      %4 = alloc() : memref<2xf32>
      scf.yield %4 : memref<2xf32>
    } else {
      scf.yield %0 : memref<2xf32>
    }
    scf.yield %3 : memref<2xf32>
  }
  return %1 : memref<2xf32>
}

//      CHECK: %[[ALLOC0:.*]] = alloc()
// CHECK-NEXT: {{.*}} scf.for
//      CHECK: %[[ALLOC1:.*]] = alloc()

// -----

// Test Case: several nested structured control-flow loops with deeply nested
// buffer allocations inside an if operation.
// Behavior: The allocs %0, %4 and %9 are moved upwards, while %7 and %8 stay
// in their positions.

// CHECK-LABEL: func @loop_nested_alloc
func @loop_nested_alloc(
  %lb: index,
  %ub: index,
  %step: index,
  %buf: memref<2xf32>,
  %res: memref<2xf32>) {
  %0 = alloc() : memref<2xf32>
  %1 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<2xf32> {
    %2 = scf.for %i2 = %lb to %ub step %step
      iter_args(%iterBuf2 = %iterBuf) -> memref<2xf32> {
      %3 = scf.for %i3 = %lb to %ub step %step
        iter_args(%iterBuf3 = %iterBuf2) -> memref<2xf32> {
        %4 = alloc() : memref<2xf32>
        %5 = cmpi "eq", %i, %ub : index
        %6 = scf.if %5 -> (memref<2xf32>) {
          %7 = alloc() : memref<2xf32>
          %8 = alloc() : memref<2xf32>
          scf.yield %8 : memref<2xf32>
        } else {
          scf.yield %iterBuf3 : memref<2xf32>
        }
        %9 = alloc() : memref<2xf32>
        scf.yield %6 : memref<2xf32>
      }
      scf.yield %3 : memref<2xf32>
    }
    scf.yield %2 : memref<2xf32>
  }
  "linalg.copy"(%1, %res) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}

//      CHECK: %[[ALLOC0:.*]] = alloc()
// CHECK-NEXT: %[[ALLOC1:.*]] = alloc()
// CHECK-NEXT: %[[ALLOC2:.*]] = alloc()
// CHECK-NEXT: {{.*}} = scf.for
// CHECK-NEXT: {{.*}} = scf.for
// CHECK-NEXT: {{.*}} = scf.for
//      CHECK: {{.*}} = scf.if
//      CHECK: %[[ALLOC3:.*]] = alloc()
//      CHECK: %[[ALLOC4:.*]] = alloc()

// -----

// CHECK-LABEL: func @loop_nested_alloc_dyn_dependency
func @loop_nested_alloc_dyn_dependency(
  %lb: index,
  %ub: index,
  %step: index,
  %arg0: index,
  %buf: memref<?xf32>,
  %res: memref<?xf32>) {
  %0 = alloc(%arg0) : memref<?xf32>
  %1 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<?xf32> {
    %2 = scf.for %i2 = %lb to %ub step %step
      iter_args(%iterBuf2 = %iterBuf) -> memref<?xf32> {
      %3 = scf.for %i3 = %lb to %ub step %step
        iter_args(%iterBuf3 = %iterBuf2) -> memref<?xf32> {
        %4 = alloc(%i3) : memref<?xf32>
        %5 = cmpi "eq", %i, %ub : index
        %6 = scf.if %5 -> (memref<?xf32>) {
          %7 = alloc(%i3) : memref<?xf32>
          scf.yield %7 : memref<?xf32>
        } else {
          scf.yield %iterBuf3 : memref<?xf32>
        }
        %8 = alloc(%i3) : memref<?xf32>
        scf.yield %6 : memref<?xf32>
      }
      scf.yield %3 : memref<?xf32>
    }
    scf.yield %0 : memref<?xf32>
  }
  "linalg.copy"(%1, %res) : (memref<?xf32>, memref<?xf32>) -> ()
  return
}

//      CHECK: %[[ALLOC0:.*]] = alloc({{.*}})
// CHECK-NEXT: {{.*}} = scf.for
// CHECK-NEXT: {{.*}} = scf.for
// CHECK-NEXT: {{.*}} = scf.for
//      CHECK: %[[ALLOC1:.*]] = alloc({{.*}})
//      CHECK: %[[ALLOC2:.*]] = alloc({{.*}})

// -----

// CHECK-LABEL: func @hoist_one_loop
func @hoist_one_loop(
  %lb: index,
  %ub: index,
  %step: index,
  %buf: memref<2xf32>,
  %res: memref<2xf32>) {
  %0 = alloc() : memref<2xf32>
  %1 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<2xf32> {
      %2 = alloc() : memref<2xf32>
      scf.yield %0 : memref<2xf32>
  }
  "linalg.copy"(%1, %res) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}

//      CHECK: %[[ALLOC0:.*]] = alloc({{.*}})
// CHECK-NEXT: %[[ALLOC1:.*]] = alloc({{.*}})
// CHECK-NEXT: {{.*}} = scf.for

// -----

// CHECK-LABEL: func @no_hoist_one_loop
func @no_hoist_one_loop(
  %lb: index,
  %ub: index,
  %step: index,
  %buf: memref<2xf32>,
  %res: memref<2xf32>) {
  %0 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<2xf32> {
      %1 = alloc() : memref<2xf32>
      scf.yield %1 : memref<2xf32>
  }
  "linalg.copy"(%0, %res) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}

//      CHECK: {{.*}} = scf.for
// CHECK-NEXT: %[[ALLOC0:.*]] = alloc({{.*}})

// -----

// CHECK-LABEL: func @hoist_multiple_loop
func @hoist_multiple_loop(
  %lb: index,
  %ub: index,
  %step: index,
  %buf: memref<2xf32>,
  %res: memref<2xf32>) {
  %0 = alloc() : memref<2xf32>
  %1 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<2xf32> {
    %2 = scf.for %i2 = %lb to %ub step %step
      iter_args(%iterBuf2 = %iterBuf) -> memref<2xf32> {
        %3 = alloc() : memref<2xf32>
        scf.yield %0 : memref<2xf32>
    }
    scf.yield %0 : memref<2xf32>
  }
  "linalg.copy"(%1, %res) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}

//      CHECK: %[[ALLOC0:.*]] = alloc({{.*}})
// CHECK-NEXT: %[[ALLOC1:.*]] = alloc({{.*}})
// CHECK-NEXT: {{.*}} = scf.for

// -----

// CHECK-LABEL: func @no_hoist_one_loop_conditional
func @no_hoist_one_loop_conditional(
  %lb: index,
  %ub: index,
  %step: index,
  %buf: memref<2xf32>,
  %res: memref<2xf32>) {
  %0 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<2xf32> {
      %1 = cmpi "eq", %i, %ub : index
      %2 = scf.if %1 -> (memref<2xf32>) {
        %3 = alloc() : memref<2xf32>
        scf.yield %3 : memref<2xf32>
      } else {
        scf.yield %iterBuf : memref<2xf32>
      }
    scf.yield %2 : memref<2xf32>
  }
  "linalg.copy"(%0, %res) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}

//      CHECK: {{.*}} = scf.for
//      CHECK: {{.*}} = scf.if
// CHECK-NEXT: %[[ALLOC0:.*]] = alloc({{.*}})

// -----

// CHECK-LABEL: func @hoist_one_loop_conditional
func @hoist_one_loop_conditional(
  %lb: index,
  %ub: index,
  %step: index,
  %buf: memref<2xf32>,
  %res: memref<2xf32>) {
  %0 = alloc() : memref<2xf32>
  %1 = cmpi "eq", %lb, %ub : index
  %2 = scf.if %1 -> (memref<2xf32>) {
    %3 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<2xf32> {
      %4 = alloc() : memref<2xf32>
      scf.yield %0 : memref<2xf32>
    }
    scf.yield %0 : memref<2xf32>
  }
  else
  {
    scf.yield %0 : memref<2xf32>
  }
  "linalg.copy"(%2, %res) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}

//      CHECK: {{.*}} = scf.if
// CHECK-NEXT: %[[ALLOC0:.*]] = alloc({{.*}})
//      CHECK: {{.*}} = scf.for

// -----

// CHECK-LABEL: func @no_hoist_one_loop_dependency
func @no_hoist_one_loop_dependency(
  %lb: index,
  %ub: index,
  %step: index,
  %buf: memref<2xf32>,
  %res: memref<2xf32>) {
  %0 = alloc() : memref<2xf32>
  %1 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<2xf32> {
      %2 = alloc(%i) : memref<?xf32>
      scf.yield %0 : memref<2xf32>
  }
  "linalg.copy"(%1, %res) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}

//      CHECK: %[[ALLOC0:.*]] = alloc({{.*}})
// CHECK-NEXT: {{.*}} = scf.for
// CHECK-NEXT: %[[ALLOC1:.*]] = alloc({{.*}})

// -----

// CHECK-LABEL: func @partial_hoist_multiple_loop_dependency
func @partial_hoist_multiple_loop_dependency(
  %lb: index,
  %ub: index,
  %step: index,
  %buf: memref<2xf32>,
  %res: memref<2xf32>) {
  %0 = alloc() : memref<2xf32>
  %1 = scf.for %i = %lb to %ub step %step
    iter_args(%iterBuf = %buf) -> memref<2xf32> {
    %2 = scf.for %i2 = %lb to %ub step %step
      iter_args(%iterBuf2 = %iterBuf) -> memref<2xf32> {
        %3 = alloc(%i) : memref<?xf32>
        scf.yield %0 : memref<2xf32>
    }
    scf.yield %0 : memref<2xf32>
  }
  "linalg.copy"(%1, %res) : (memref<2xf32>, memref<2xf32>) -> ()
  return
}

//      CHECK: %[[ALLOC0:.*]] = alloc({{.*}})
// CHECK-NEXT: {{.*}} = scf.for
// CHECK-NEXT: %[[ALLOC1:.*]] = alloc({{.*}})
// CHECK-NEXT: {{.*}} = scf.for
