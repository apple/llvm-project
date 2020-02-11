; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -passes=attributor -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=1 < %s | FileCheck %s

; ArgumentPromotion should preserve the default function address space
; from the data layout.

target datalayout = "e-P1-p:16:8-i8:8-i16:8-i32:8-i64:8-f32:8-f64:8-n8-a:8"

@g = common global i32 0, align 4

define i32 @bar() {
; CHECK-LABEL: define {{[^@]+}}@bar() addrspace(1)
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call addrspace(1) i32 @foo()
; CHECK-NEXT:    unreachable
; CHECK:       entry.split:
; CHECK-NEXT:    unreachable
;

entry:
  %call = call i32 @foo(i32* @g)
  ret i32 %call
}

define internal i32 @foo(i32*) {
; CHECK-LABEL: define {{[^@]+}}@foo() addrspace(1)
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RETVAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call addrspace(0) void asm sideeffect "ldr r0, [r0] \0Abx lr \0A", ""()
; CHECK-NEXT:    unreachable
;
entry:
  %retval = alloca i32, align 4
  call void asm sideeffect "ldr r0, [r0] \0Abx lr        \0A", ""()
  unreachable
}

