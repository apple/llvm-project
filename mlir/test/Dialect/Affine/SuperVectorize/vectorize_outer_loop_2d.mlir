// RUN: mlir-opt %s -affine-super-vectorize="virtual-vector-size=32,256 test-fastest-varying=2,0" | FileCheck %s

// Permutation maps used in vectorization.
// CHECK: #[[map_proj_d0d1d2_d0d2:map[0-9]+]] = affine_map<(d0, d1, d2) -> (d0, d2)>

func @vec2d(%A : memref<?x?x?xf32>) {
  %c0 = constant 0 : index
  %c1 = constant 1 : index
  %c2 = constant 2 : index
  %M = dim %A, %c0 : memref<?x?x?xf32>
  %N = dim %A, %c1 : memref<?x?x?xf32>
  %P = dim %A, %c2 : memref<?x?x?xf32>
  // CHECK: affine.for %{{.*}} = 0 to %{{.*}} step 32
  // CHECK:   affine.for %{{.*}} = 0 to %{{.*}} {
  // CHECK:     affine.for %{{.*}} = 0 to %{{.*}} step 256
  // CHECK:       {{.*}} = vector.transfer_read %{{.*}}[%{{.*}}, %{{.*}}, %{{.*}}], %{{.*}} {permutation_map = #[[map_proj_d0d1d2_d0d2]]} : memref<?x?x?xf32>,  vector<32x256xf32>
  affine.for %i0 = 0 to %M {
    affine.for %i1 = 0 to %N {
      affine.for %i2 = 0 to %P {
        %a2 = affine.load %A[%i0, %i1, %i2] : memref<?x?x?xf32>
      }
    }
  }
  // CHECK: for  {{.*}} = 0 to %{{.*}} {
  // CHECK:   for  {{.*}} = 0 to %{{.*}} {
  // CHECK:     for  {{.*}} = 0 to %{{.*}} {
  // For the case: --test-fastest-varying=2 --test-fastest-varying=0 no
  // vectorization happens because of loop nesting order
  affine.for %i3 = 0 to %M {
    affine.for %i4 = 0 to %N {
      affine.for %i5 = 0 to %P {
        %a5 = affine.load %A[%i4, %i5, %i3] : memref<?x?x?xf32>
      }
    }
  }
  return
}
