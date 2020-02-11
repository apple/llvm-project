# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1500 -timeline -timeline-max-iterations=3 < %s | FileCheck %s

# perf stat reports a throughput of 0.60 IPC for this code snippet.
# Each lzcnt has a false dependency on %ecx; the first lzcnt has to wait on the
# imul. However, the folded load can start immediately.
# The last lzcnt has a false dependency on %cx. However, even in this case, the
# folded load can start immediately.

imul %edx, %ecx
lzcnt (%rsp), %cx
lzcnt 2(%rsp), %cx

# CHECK:      Iterations:        1500
# CHECK-NEXT: Instructions:      4500
# CHECK-NEXT: Total Cycles:      7503
# CHECK-NEXT: Total uOps:        4500

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.60
# CHECK-NEXT: IPC:               0.60
# CHECK-NEXT: Block RThroughput: 2.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        imull	%edx, %ecx
# CHECK-NEXT:  1      4     1.00    *                   lzcntw	(%rsp), %cx
# CHECK-NEXT:  1      4     1.00    *                   lzcntw	2(%rsp), %cx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -     2.00   1.00    -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -     1.00    -      -      -      -      -     imull	%edx, %ecx
# CHECK-NEXT: 1.00    -      -      -      -      -      -     1.00    -      -      -      -      -      -     lzcntw	(%rsp), %cx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     lzcntw	2(%rsp), %cx

# CHECK:      Timeline view:
# CHECK-NEXT:                     01234567
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeER    .    . .   imull	%edx, %ecx
# CHECK-NEXT: [0,1]     DeeeeER   .    . .   lzcntw	(%rsp), %cx
# CHECK-NEXT: [0,2]     .DeeeeER  .    . .   lzcntw	2(%rsp), %cx
# CHECK-NEXT: [1,0]     .D====eeeER    . .   imull	%edx, %ecx
# CHECK-NEXT: [1,1]     . D===eeeeER   . .   lzcntw	(%rsp), %cx
# CHECK-NEXT: [1,2]     . D====eeeeER  . .   lzcntw	2(%rsp), %cx
# CHECK-NEXT: [2,0]     .  D=======eeeER .   imull	%edx, %ecx
# CHECK-NEXT: [2,1]     .  D=======eeeeER.   lzcntw	(%rsp), %cx
# CHECK-NEXT: [2,2]     .   D=======eeeeER   lzcntw	2(%rsp), %cx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     4.7    0.3    0.0       imull	%edx, %ecx
# CHECK-NEXT: 1.     3     4.3    0.0    0.0       lzcntw	(%rsp), %cx
# CHECK-NEXT: 2.     3     4.7    0.0    0.0       lzcntw	2(%rsp), %cx
# CHECK-NEXT:        3     4.6    0.1    0.0       <total>
