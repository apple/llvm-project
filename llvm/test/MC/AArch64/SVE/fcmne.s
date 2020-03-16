// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d --mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

fcmne   p0.h, p0/z, z0.h, #0.0
// CHECK-INST: fcmne	p0.h, p0/z, z0.h, #0.0
// CHECK-ENCODING: [0x00,0x20,0x53,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 20 53 65 <unknown>

fcmne   p0.s, p0/z, z0.s, #0.0
// CHECK-INST: fcmne	p0.s, p0/z, z0.s, #0.0
// CHECK-ENCODING: [0x00,0x20,0x93,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 20 93 65 <unknown>

fcmne   p0.d, p0/z, z0.d, #0.0
// CHECK-INST: fcmne	p0.d, p0/z, z0.d, #0.0
// CHECK-ENCODING: [0x00,0x20,0xd3,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 20 d3 65 <unknown>

fcmne   p0.h, p0/z, z0.h, z1.h
// CHECK-INST: fcmne	p0.h, p0/z, z0.h, z1.h
// CHECK-ENCODING: [0x10,0x60,0x41,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 10 60 41 65 <unknown>

fcmne   p0.s, p0/z, z0.s, z1.s
// CHECK-INST: fcmne	p0.s, p0/z, z0.s, z1.s
// CHECK-ENCODING: [0x10,0x60,0x81,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 10 60 81 65 <unknown>

fcmne   p0.d, p0/z, z0.d, z1.d
// CHECK-INST: fcmne	p0.d, p0/z, z0.d, z1.d
// CHECK-ENCODING: [0x10,0x60,0xc1,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 10 60 c1 65 <unknown>
