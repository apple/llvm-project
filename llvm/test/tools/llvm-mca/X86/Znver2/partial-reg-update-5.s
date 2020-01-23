# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver2 -iterations=1500 -timeline -timeline-max-iterations=8 < %s | FileCheck %s

lzcnt %ax, %bx  ## partial register stall.

# CHECK:      Iterations:        1500
# CHECK-NEXT: Instructions:      1500
# CHECK-NEXT: Total Cycles:      1503
# CHECK-NEXT: Total uOps:        1500

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    1.00
# CHECK-NEXT: IPC:               1.00
# CHECK-NEXT: Block RThroughput: 0.3

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.25                        lzcntw	%ax, %bx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn2AGU0
# CHECK-NEXT: [1]   - Zn2AGU1
# CHECK-NEXT: [2]   - Zn2AGU2
# CHECK-NEXT: [3]   - Zn2ALU0
# CHECK-NEXT: [4]   - Zn2ALU1
# CHECK-NEXT: [5]   - Zn2ALU2
# CHECK-NEXT: [6]   - Zn2ALU3
# CHECK-NEXT: [7]   - Zn2Divider
# CHECK-NEXT: [8]   - Zn2FPU0
# CHECK-NEXT: [9]   - Zn2FPU1
# CHECK-NEXT: [10]  - Zn2FPU2
# CHECK-NEXT: [11]  - Zn2FPU3
# CHECK-NEXT: [12]  - Zn2Multiplier

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]
# CHECK-NEXT:  -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT:  -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -     lzcntw	%ax, %bx

# CHECK:      Timeline view:
# CHECK-NEXT:                     0
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeER .    .   lzcntw	%ax, %bx
# CHECK-NEXT: [1,0]     D=eER.    .   lzcntw	%ax, %bx
# CHECK-NEXT: [2,0]     D==eER    .   lzcntw	%ax, %bx
# CHECK-NEXT: [3,0]     D===eER   .   lzcntw	%ax, %bx
# CHECK-NEXT: [4,0]     .D===eER  .   lzcntw	%ax, %bx
# CHECK-NEXT: [5,0]     .D====eER .   lzcntw	%ax, %bx
# CHECK-NEXT: [6,0]     .D=====eER.   lzcntw	%ax, %bx
# CHECK-NEXT: [7,0]     .D======eER   lzcntw	%ax, %bx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     8     4.0    0.1    0.0       lzcntw	%ax, %bx
