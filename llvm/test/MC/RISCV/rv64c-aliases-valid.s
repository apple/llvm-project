# RUN: llvm-mc -triple=riscv64 -mattr=+c -riscv-no-aliases < %s \
# RUN:     | FileCheck -check-prefixes=CHECK-EXPAND,CHECK-INST %s
# RUN: llvm-mc -filetype=obj -triple riscv64 -mattr=+c < %s \
# RUN:     | llvm-objdump -d -riscv-no-aliases - \
# RUN:     | FileCheck -check-prefixes=CHECK-EXPAND,CHECK-INST %s

# The following check prefixes are used in this test:
# CHECK-INST.....Match the canonical instr (tests alias to instr. mapping)
# CHECK-EXPAND...Match canonical instr. unconditionally (tests alias expansion)

# CHECK-EXPAND: addiw a0, zero, 0
li x10, 0
# CHECK-EXPAND: addiw a0, zero, 1
li x10, 1
# CHECK-EXPAND: addiw a0, zero, -1
li x10, -1
# CHECK-EXPAND: addiw a0, zero, 2047
li x10, 2047
# CHECK-EXPAND: addiw a0, zero, -2047
li x10, -2047
# CHECK-EXPAND: c.lui a1, 1
# CHECK-EXPAND: addiw a1, a1, -2048
li x11, 2048
# CHECK-EXPAND: addiw a1, zero, -2048
li x11, -2048
# CHECK-EXPAND: c.lui a1, 1
# CHECK-EXPAND: addiw a1, a1, -2047
li x11, 2049
# CHECK-EXPAND: c.lui a1, 1048575
# CHECK-EXPAND: addiw a1, a1, 2047
li x11, -2049
# CHECK-EXPAND: c.lui a1, 1
# CHECK-EXPAND: c.addiw a1, -1
li x11, 4095
# CHECK-EXPAND: lui a1, 1048575
# CHECK-EXPAND: c.addiw a1, 1
li x11, -4095
# CHECK-EXPAND: c.lui a2, 1
li x12, 4096
# CHECK-EXPAND: lui a2, 1048575
li x12, -4096
# CHECK-EXPAND: c.lui a2, 1
# CHECK-EXPAND: c.addiw a2, 1
li x12, 4097
# CHECK-EXPAND: lui a2, 1048575
# CHECK-EXPAND: c.addiw a2, -1
li x12, -4097
# CHECK-EXPAND: lui a2, 524288
# CHECK-EXPAND: c.addiw a2, -1
li x12, 2147483647
# CHECK-EXPAND: lui a2, 524288
# CHECK-EXPAND: c.addiw a2, 1
li x12, -2147483647
# CHECK-EXPAND: lui a2, 524288
li x12, -2147483648
# CHECK-EXPAND: lui a2, 524288
li x12, -0x80000000

# CHECK-EXPAND: addiw a2, zero, 1
# CHECK-EXPAND: c.slli a2, 31
li x12, 0x80000000
# CHECK-EXPAND: addiw a2, zero, 1
# CHECK-EXPAND: c.slli a2, 32
# CHECK-EXPAND: c.addi a2, -1
li x12, 0xFFFFFFFF

# CHECK-EXPAND: addiw t0, zero, 1
# CHECK-EXPAND: c.slli t0, 32
li t0, 0x100000000
# CHECK-EXPAND: addiw t1, zero, -1
# CHECK-EXPAND: c.slli t1, 63
li t1, 0x8000000000000000
# CHECK-EXPAND: addiw t1, zero, -1
# CHECK-EXPAND: c.slli t1, 63
li t1, -0x8000000000000000
# CHECK-EXPAND: lui t2, 9321
# CHECK-EXPAND: addiw t2, t2, -1329
# CHECK-EXPAND: c.slli t2, 35
li t2, 0x1234567800000000
# CHECK-EXPAND: addiw t3, zero, 7
# CHECK-EXPAND: c.slli t3, 36
# CHECK-EXPAND: c.addi t3, 11
# CHECK-EXPAND: c.slli t3, 24
# CHECK-EXPAND: c.addi t3, 15
li t3, 0x700000000B00000F
# CHECK-EXPAND: lui t4, 583
# CHECK-EXPAND: addiw t4, t4, -1875
# CHECK-EXPAND: c.slli t4, 14
# CHECK-EXPAND: addi t4, t4, -947
# CHECK-EXPAND: c.slli t4, 12
# CHECK-EXPAND: addi t4, t4, 1511
# CHECK-EXPAND: c.slli t4, 13
# CHECK-EXPAND: addi t4, t4, -272
li t4, 0x123456789abcdef0
# CHECK-EXPAND: addiw t5, zero, -1
li t5, 0xFFFFFFFFFFFFFFFF
