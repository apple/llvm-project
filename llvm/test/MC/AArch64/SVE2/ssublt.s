// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve2 < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:        | llvm-objdump -d --mattr=+sve2 - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN


ssublt z0.h, z1.b, z2.b
// CHECK-INST: ssublt z0.h, z1.b, z2.b
// CHECK-ENCODING: [0x20,0x14,0x42,0x45]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: 20 14 42 45 <unknown>

ssublt z29.s, z30.h, z31.h
// CHECK-INST: ssublt z29.s, z30.h, z31.h
// CHECK-ENCODING: [0xdd,0x17,0x9f,0x45]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: dd 17 9f 45 <unknown>

ssublt z31.d, z31.s, z31.s
// CHECK-INST: ssublt z31.d, z31.s, z31.s
// CHECK-ENCODING: [0xff,0x17,0xdf,0x45]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: ff 17 df 45 <unknown>
