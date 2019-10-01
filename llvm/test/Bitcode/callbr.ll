; RUN:  llvm-dis < %s.bc | FileCheck %s

; callbr.ll.bc was generated by passing this file to llvm-as.

define i32 @test_asm_goto(i32 %x){
entry:
; CHECK:      callbr void asm "", "r,X"(i32 %x, i8* blockaddress(@test_asm_goto, %fail))
; CHECK-NEXT: to label %normal [label %fail]
  callbr void asm "", "r,X"(i32 %x, i8* blockaddress(@test_asm_goto, %fail)) to label %normal [label %fail]
normal:
  ret i32 1
fail:
  ret i32 0
}
