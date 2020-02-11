; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin -relocation-model=pic | FileCheck %s

@main_q = internal global i8* null		; <i8**> [#uses=1]

define void @func2() nounwind {
; CHECK-LABEL: func2:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    calll L0$pb
; CHECK-NEXT:  L0$pb:
; CHECK-NEXT:    popl %eax
; CHECK-NEXT:    leal _main_q-L0$pb(%eax), %eax
; CHECK-NEXT:    ## InlineAsm Start
; CHECK-NEXT:    movl %eax, %gs:152
; CHECK-NEXT:    ## InlineAsm End
; CHECK-NEXT:    retl
entry:
	tail call void asm "mov $1,%gs:$0", "=*m,ri,~{dirflag},~{fpsr},~{flags}"(i8** inttoptr (i32 152 to i8**), i8* bitcast (i8** @main_q to i8*)) nounwind
	ret void
}
