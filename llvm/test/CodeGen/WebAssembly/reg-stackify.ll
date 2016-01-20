; RUN: llc < %s -asm-verbose=false -verify-machineinstrs | FileCheck %s

; Test the register stackifier pass.

target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

; No because of pointer aliasing.

; CHECK-LABEL: no0:
; CHECK: return $1{{$}}
define i32 @no0(i32* %p, i32* %q) {
  %t = load i32, i32* %q
  store i32 0, i32* %p
  ret i32 %t
}

; No because of side effects.

; CHECK-LABEL: no1:
; CHECK: return $1{{$}}
define i32 @no1(i32* %p, i32* dereferenceable(4) %q) {
  %t = load volatile i32, i32* %q, !invariant.load !0
  store volatile i32 0, i32* %p
  ret i32 %t
}

; Yes because of invariant load and no side effects.

; CHECK-LABEL: yes0:
; CHECK: return $pop0{{$}}
define i32 @yes0(i32* %p, i32* dereferenceable(4) %q) {
  %t = load i32, i32* %q, !invariant.load !0
  store i32 0, i32* %p
  ret i32 %t
}

; Yes because of no intervening side effects.

; CHECK-LABEL: yes1:
; CHECK: return $pop0{{$}}
define i32 @yes1(i32* %q) {
  %t = load volatile i32, i32* %q
  ret i32 %t
}

; Don't schedule stack uses into the stack. To reduce register pressure, the
; scheduler might be tempted to move the definition of $2 down. However, this
; would risk getting incorrect liveness if the instructions are later
; rearranged to make the stack contiguous.

; CHECK-LABEL: stack_uses:
; CHECK-NEXT: .param i32, i32, i32, i32{{$}}
; CHECK-NEXT: .result i32{{$}}
; CHECK-NEXT: block{{$}}
; CHECK-NEXT: i32.const   $push13=, 1{{$}}
; CHECK-NEXT: i32.lt_s    $push0=, $0, $pop13{{$}}
; CHECK-NEXT: i32.const   $push1=, 2{{$}}
; CHECK-NEXT: i32.lt_s    $push2=, $1, $pop1{{$}}
; CHECK-NEXT: i32.xor     $push5=, $pop0, $pop2{{$}}
; CHECK-NEXT: i32.const   $push12=, 1{{$}}
; CHECK-NEXT: i32.lt_s    $push3=, $2, $pop12{{$}}
; CHECK-NEXT: i32.const   $push11=, 2{{$}}
; CHECK-NEXT: i32.lt_s    $push4=, $3, $pop11{{$}}
; CHECK-NEXT: i32.xor     $push6=, $pop3, $pop4{{$}}
; CHECK-NEXT: i32.xor     $push7=, $pop5, $pop6{{$}}
; CHECK-NEXT: i32.const   $push10=, 1{{$}}
; CHECK-NEXT: i32.ne      $push8=, $pop7, $pop10{{$}}
; CHECK-NEXT: br_if       $pop8, 0{{$}}
; CHECK-NEXT: i32.const   $push9=, 0{{$}}
; CHECK-NEXT: return      $pop9{{$}}
; CHECK-NEXT: .LBB4_2:
; CHECK-NEXT: end_block{{$}}
; CHECK-NEXT: i32.const   $push14=, 1{{$}}
; CHECK-NEXT: return      $pop14{{$}}
define i32 @stack_uses(i32 %x, i32 %y, i32 %z, i32 %w) {
entry:
  %c = icmp sle i32 %x, 0
  %d = icmp sle i32 %y, 1
  %e = icmp sle i32 %z, 0
  %f = icmp sle i32 %w, 1
  %g = xor i1 %c, %d
  %h = xor i1 %e, %f
  %i = xor i1 %g, %h
  br i1 %i, label %true, label %false
true:
  ret i32 0
false:
  ret i32 1
}

; Test an interesting case where the load has multiple uses and cannot
; be trivially stackified.

; CHECK-LABEL: multiple_uses:
; CHECK-NEXT: .param       i32, i32, i32{{$}}
; CHECK-NEXT: .local       i32{{$}}
; CHECK-NEXT: i32.load    $3=, 0($2){{$}}
; CHECK-NEXT: block{{$}}
; CHECK-NEXT: i32.ge_u    $push0=, $3, $1{{$}}
; CHECK-NEXT: br_if       $pop0, 0{{$}}
; CHECK-NEXT: i32.lt_u    $push1=, $3, $0{{$}}
; CHECK-NEXT: br_if       $pop1, 0{{$}}
; CHECK-NEXT: i32.store   $discard=, 0($2), $3{{$}}
; CHECK-NEXT: .LBB5_3:
; CHECK-NEXT: end_block{{$}}
; CHECK-NEXT: return{{$}}
define void @multiple_uses(i32* %arg0, i32* %arg1, i32* %arg2) nounwind {
bb:
  br label %loop

loop:
  %tmp7 = load i32, i32* %arg2
  %tmp8 = inttoptr i32 %tmp7 to i32*
  %tmp9 = icmp uge i32* %tmp8, %arg1
  %tmp10 = icmp ult i32* %tmp8, %arg0
  %tmp11 = or i1 %tmp9, %tmp10
  br i1 %tmp11, label %back, label %then

then:
  store i32 %tmp7, i32* %arg2
  br label %back

back:
  br i1 undef, label %return, label %loop

return:
  ret void
}

; Don't stackify stores effects across other instructions with side effects.

; CHECK:      side_effects:
; CHECK:      store
; CHECK-NEXT: call
; CHECK-NEXT: store
; CHECK-NEXT: call
declare void @evoke_side_effects()
define hidden void @stackify_store_across_side_effects(double* nocapture %d) {
entry:
  store double 2.0, double* %d
  call void @evoke_side_effects()
  store double 2.0, double* %d
  call void @evoke_side_effects()
  ret void
}

!0 = !{}
