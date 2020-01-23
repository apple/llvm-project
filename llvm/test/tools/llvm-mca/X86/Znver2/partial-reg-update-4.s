# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver2 -iterations=1500 -timeline -timeline-max-iterations=7 < %s | FileCheck %s

# The lzcnt cannot execute in parallel with the imul because there is a false
# dependency on %bx.

imul %ax, %bx
lzcnt %ax, %bx
add %cx, %bx

# CHECK:      Iterations:        1500
# CHECK-NEXT: Instructions:      4500
# CHECK-NEXT: Total Cycles:      7503
# CHECK-NEXT: Total uOps:        4500

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.60
# CHECK-NEXT: IPC:               0.60
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        imulw	%ax, %bx
# CHECK-NEXT:  1      1     0.25                        lzcntw	%ax, %bx
# CHECK-NEXT:  1      1     0.25                        addw	%cx, %bx

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
# CHECK-NEXT:  -      -      -     0.67   1.00   0.67   0.67    -      -      -      -      -     1.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   imulw	%ax, %bx
# CHECK-NEXT:  -      -      -     0.33    -     0.33   0.33    -      -      -      -      -      -     lzcntw	%ax, %bx
# CHECK-NEXT:  -      -      -     0.33    -     0.33   0.33    -      -      -      -      -      -     addw	%cx, %bx

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          01234567
# CHECK-NEXT: Index     0123456789          0123456789

# CHECK:      [0,0]     DeeeER    .    .    .    .    .    . .   imulw	%ax, %bx
# CHECK-NEXT: [0,1]     D===eER   .    .    .    .    .    . .   lzcntw	%ax, %bx
# CHECK-NEXT: [0,2]     D====eER  .    .    .    .    .    . .   addw	%cx, %bx
# CHECK-NEXT: [1,0]     D=====eeeER    .    .    .    .    . .   imulw	%ax, %bx
# CHECK-NEXT: [1,1]     .D=======eER   .    .    .    .    . .   lzcntw	%ax, %bx
# CHECK-NEXT: [1,2]     .D========eER  .    .    .    .    . .   addw	%cx, %bx
# CHECK-NEXT: [2,0]     .D=========eeeER    .    .    .    . .   imulw	%ax, %bx
# CHECK-NEXT: [2,1]     .D============eER   .    .    .    . .   lzcntw	%ax, %bx
# CHECK-NEXT: [2,2]     . D============eER  .    .    .    . .   addw	%cx, %bx
# CHECK-NEXT: [3,0]     . D=============eeeER    .    .    . .   imulw	%ax, %bx
# CHECK-NEXT: [3,1]     . D================eER   .    .    . .   lzcntw	%ax, %bx
# CHECK-NEXT: [3,2]     . D=================eER  .    .    . .   addw	%cx, %bx
# CHECK-NEXT: [4,0]     .  D=================eeeER    .    . .   imulw	%ax, %bx
# CHECK-NEXT: [4,1]     .  D====================eER   .    . .   lzcntw	%ax, %bx
# CHECK-NEXT: [4,2]     .  D=====================eER  .    . .   addw	%cx, %bx
# CHECK-NEXT: [5,0]     .  D======================eeeER    . .   imulw	%ax, %bx
# CHECK-NEXT: [5,1]     .   D========================eER   . .   lzcntw	%ax, %bx
# CHECK-NEXT: [5,2]     .   D=========================eER  . .   addw	%cx, %bx
# CHECK-NEXT: [6,0]     .   D==========================eeeER .   imulw	%ax, %bx
# CHECK-NEXT: [6,1]     .   D=============================eER.   lzcntw	%ax, %bx
# CHECK-NEXT: [6,2]     .    D=============================eER   addw	%cx, %bx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     7     14.1   0.1    0.0       imulw	%ax, %bx
# CHECK-NEXT: 1.     7     16.9   0.0    0.0       lzcntw	%ax, %bx
# CHECK-NEXT: 2.     7     17.6   0.0    0.0       addw	%cx, %bx
# CHECK-NEXT:        7     16.2   0.0    0.0       <total>
