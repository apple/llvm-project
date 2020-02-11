# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m3 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M3
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m4 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M4
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m5 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M5

fmov	s31, #1.00000000
fdiv	s30, s31, s30

# Newton series for 1 / x.
frecpe	s1, s0
frecps	s2, s0, s1
fmul	s1, s1, s2
frecps	s0, s0, s1
fmul	s0, s1, s0

# ALL:      Iterations:        100
# ALL-NEXT: Instructions:      700

# M3-NEXT:  Total Cycles:      1803
# M4-NEXT:  Total Cycles:      1703
# M5-NEXT:  Total Cycles:      1703

# ALL-NEXT: Total uOps:        700

# ALL:      Dispatch Width:    6

# M3-NEXT:  uOps Per Cycle:    0.39
# M3-NEXT:  IPC:               0.39
# M3-NEXT:  Block RThroughput: 2.0

# M4-NEXT:  uOps Per Cycle:    0.41
# M4-NEXT:  IPC:               0.41
# M4-NEXT:  Block RThroughput: 1.5

# M5-NEXT:  uOps Per Cycle:    0.41
# M5-NEXT:  IPC:               0.41
# M5-NEXT:  Block RThroughput: 1.3

# ALL:      Instruction Info:
# ALL-NEXT: [1]: #uOps
# ALL-NEXT: [2]: Latency
# ALL-NEXT: [3]: RThroughput
# ALL-NEXT: [4]: MayLoad
# ALL-NEXT: [5]: MayStore
# ALL-NEXT: [6]: HasSideEffects (U)

# ALL:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# ALL-NEXT:  1      1     0.33                        fmov	s31, #1.00000000

# M3-NEXT:   1      7     2.00                        fdiv	s30, s31, s30
# M3-NEXT:   1      4     0.50                        frecpe	s1, s0

# M4-NEXT:   1      7     1.50                        fdiv	s30, s31, s30
# M4-NEXT:   1      3     0.50                        frecpe	s1, s0

# M5-NEXT:   1      7     1.00                        fdiv	s30, s31, s30
# M5-NEXT:   1      3     0.50                        frecpe	s1, s0

# ALL-NEXT:  1      4     0.33                        frecps	s2, s0, s1
# ALL-NEXT:  1      3     0.33                        fmul	s1, s1, s2
# ALL-NEXT:  1      4     0.33                        frecps	s0, s0, s1
# ALL-NEXT:  1      3     0.33                        fmul	s0, s1, s0
