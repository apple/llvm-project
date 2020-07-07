; RUN: llc < %s -asm-verbose=false -verify-machineinstrs -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -wasm-keep-registers -mattr=+simd128 | FileCheck %s

; Test that SIMD shifts can be lowered correctly even with shift
; values that are more complex than plain splats.

target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

;; TODO: Optimize this further by scalarizing the add

; CHECK-LABEL: shl_add:
; CHECK-NEXT: .functype shl_add (v128, i32, i32) -> (v128)
; CHECK-NEXT: i8x16.splat $push1=, $1
; CHECK-NEXT: i8x16.splat $push0=, $2
; CHECK-NEXT: i8x16.add $push2=, $pop1, $pop0
; CHECK-NEXT: i8x16.extract_lane_u $push3=, $pop2, 0
; CHECK-NEXT: i8x16.shl $push4=, $0, $pop3
; CHECK-NEXT: return $pop4
define <16 x i8> @shl_add(<16 x i8> %v, i8 %a, i8 %b) {
  %t1 = insertelement <16 x i8> undef, i8 %a, i32 0
  %va = shufflevector <16 x i8> %t1, <16 x i8> undef, <16 x i32> zeroinitializer
  %t2 = insertelement <16 x i8> undef, i8 %b, i32 0
  %vb = shufflevector <16 x i8> %t2, <16 x i8> undef, <16 x i32> zeroinitializer
  %shift = add <16 x i8> %va, %vb
  %r = shl <16 x i8> %v, %shift
  ret <16 x i8> %r
}
