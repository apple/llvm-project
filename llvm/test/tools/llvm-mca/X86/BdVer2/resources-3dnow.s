# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -instruction-tables < %s | FileCheck %s

femms

pavgusb     %mm0, %mm2
pavgusb     (%rax), %mm2

pf2id       %mm0, %mm2
pf2id       (%rax), %mm2

pf2iw       %mm0, %mm2
pf2iw       (%rax), %mm2

pfacc       %mm0, %mm2
pfacc       (%rax), %mm2

pfadd       %mm0, %mm2
pfadd       (%rax), %mm2

pfcmpeq     %mm0, %mm2
pfcmpeq     (%rax), %mm2

pfcmpge     %mm0, %mm2
pfcmpge     (%rax), %mm2

pfcmpgt     %mm0, %mm2
pfcmpgt     (%rax), %mm2

pfmax       %mm0, %mm2
pfmax       (%rax), %mm2

pfmin       %mm0, %mm2
pfmin       (%rax), %mm2

pfmul       %mm0, %mm2
pfmul       (%rax), %mm2

pfnacc      %mm0, %mm2
pfnacc      (%rax), %mm2

pfpnacc     %mm0, %mm2
pfpnacc     (%rax), %mm2

pfrcp       %mm0, %mm2
pfrcp       (%rax), %mm2

pfrcpit1    %mm0, %mm2
pfrcpit1    (%rax), %mm2

pfrcpit2    %mm0, %mm2
pfrcpit2    (%rax), %mm2

pfrsqit1    %mm0, %mm2
pfrsqit1    (%rax), %mm2

pfrsqrt     %mm0, %mm2
pfrsqrt     (%rax), %mm2

pfsub       %mm0, %mm2
pfsub       (%rax), %mm2

pfsubr      %mm0, %mm2
pfsubr      (%rax), %mm2

pi2fd       %mm0, %mm2
pi2fd       (%rax), %mm2

pi2fw       %mm0, %mm2
pi2fw       (%rax), %mm2

pmulhrw     %mm0, %mm2
pmulhrw     (%rax), %mm2

prefetch    (%rax)
prefetchw   (%rax)

pswapd      %mm0, %mm2
pswapd      (%rax), %mm2

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      2     0.50    *      *      U     femms
# CHECK-NEXT:  1      2     0.50                        pavgusb	%mm0, %mm2
# CHECK-NEXT:  1      7     1.50    *                   pavgusb	(%rax), %mm2
# CHECK-NEXT:  1      4     1.00                        pf2id	%mm0, %mm2
# CHECK-NEXT:  1      9     1.50    *                   pf2id	(%rax), %mm2
# CHECK-NEXT:  1      4     1.00                        pf2iw	%mm0, %mm2
# CHECK-NEXT:  1      9     1.50    *                   pf2iw	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfacc	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfacc	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfadd	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfadd	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfcmpeq	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfcmpeq	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfcmpge	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfcmpge	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfcmpgt	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfcmpgt	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfmax	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfmax	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfmin	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfmin	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfmul	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfmul	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfnacc	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfnacc	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfpnacc	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfpnacc	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfrcp	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfrcp	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfrcpit1	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfrcpit1	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfrcpit2	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfrcpit2	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfrsqit1	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfrsqit1	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfrsqrt	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfrsqrt	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfsub	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfsub	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        pfsubr	%mm0, %mm2
# CHECK-NEXT:  1      10    1.50    *                   pfsubr	(%rax), %mm2
# CHECK-NEXT:  1      4     1.00                        pi2fd	%mm0, %mm2
# CHECK-NEXT:  1      9     1.50    *                   pi2fd	(%rax), %mm2
# CHECK-NEXT:  1      4     1.00                        pi2fw	%mm0, %mm2
# CHECK-NEXT:  1      9     1.50    *                   pi2fw	(%rax), %mm2
# CHECK-NEXT:  1      4     1.00                        pmulhrw	%mm0, %mm2
# CHECK-NEXT:  1      9     1.50    *                   pmulhrw	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00    *      *            prefetch	(%rax)
# CHECK-NEXT:  1      5     1.00    *      *            prefetchw	(%rax)
# CHECK-NEXT:  1      2     1.00                        pswapd	%mm0, %mm2
# CHECK-NEXT:  1      7     1.50    *                   pswapd	(%rax), %mm2

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT: 38.00  38.00   -      -      -      -      -     8.00   17.50  17.50  3.00   3.00   2.00   8.00   46.50  2.50    -      -      -     38.00  38.00   -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -      -      -      -      -      -      -     femms
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     0.50   0.50    -      -     0.50   0.50    -      -      -      -      -      -      -     pavgusb	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -      -      -     0.50   0.50    -      -     0.50   0.50    -      -      -     1.50   1.50    -      -     pavgusb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -      -     1.00   1.00    -      -      -      -      -      -      -      -     pf2id	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -     1.00    -      -      -      -      -     1.00   1.00    -      -      -      -     1.50   1.50    -      -     pf2id	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -      -     1.00   1.00    -      -      -      -      -      -      -      -     pf2iw	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -     1.00    -      -      -      -      -     1.00   1.00    -      -      -      -     1.50   1.50    -      -     pf2iw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfacc	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfacc	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfadd	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfadd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfcmpeq	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfcmpeq	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfcmpge	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfcmpge	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfcmpgt	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfcmpgt	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfmax	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfmax	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfmin	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfmin	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfmul	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfmul	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfnacc	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfnacc	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfpnacc	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfpnacc	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfrcp	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfrcp	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfrcpit1	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfrcpit1	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfrcpit2	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfrcpit2	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfrsqit1	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfrsqit1	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfrsqrt	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfrsqrt	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfsub	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfsub	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -      -      -      -      -     pfsubr	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     0.50   0.50    -      -      -      -     1.00    -      -      -      -     1.50   1.50    -      -     pfsubr	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -      -     1.00   1.00    -      -      -      -      -      -      -      -     pi2fd	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -     1.00    -      -      -      -      -     1.00   1.00    -      -      -      -     1.50   1.50    -      -     pi2fd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -      -     1.00   1.00    -      -      -      -      -      -      -      -     pi2fw	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -     1.00    -      -      -      -      -     1.00   1.00    -      -      -      -     1.50   1.50    -      -     pi2fw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     pmulhrw	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -      -      -      -      -     1.00    -     1.00    -      -      -      -     1.50   1.50    -      -     pmulhrw	(%rax), %mm2
# CHECK-NEXT: 1.00   1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     1.00   1.00    -      -     prefetch	(%rax)
# CHECK-NEXT: 1.00   1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     1.00   1.00    -      -     prefetchw	(%rax)
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00   1.00    -      -     0.50   0.50    -      -      -      -      -      -      -     pswapd	%mm0, %mm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -      -      -     1.00   1.00    -      -     0.50   0.50    -      -      -     1.50   1.50    -      -     pswapd	(%rax), %mm2
