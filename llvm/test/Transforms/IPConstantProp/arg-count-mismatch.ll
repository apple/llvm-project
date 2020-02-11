; RUN: opt < %s -ipconstprop -S -o - | FileCheck %s

; The original C source looked like this:
;
;   long long a101, b101, e101;
;   volatile long c101;
;   int d101;
;
;   static inline int bar(p1, p2)
;   {
;       return 0;
;   }
;
;   void foo(unsigned p1)
;   {
;       long long *f = &b101, *g = &e101;
;       c101 = 0;
;       (void)((*f |= a101) - (*g = bar(d101)));
;       c101 = (*f |= a101 &= p1) == d101;
;   }
;
; When compiled with Clang it gives a warning
;   warning: too few arguments in call to 'bar'
;
; This ll reproducer has been reduced to only include tha call.
;
; Note that -lint will report this as UB, but it passes -verify.

; This test is just to verify that we do not crash/assert due to mismatch in
; argument count between the caller and callee.

define dso_local void @foo(i16 %a) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[CALL:%.*]] = call i16 bitcast (i16 (i16, i16)* @bar to i16 (i16)*)(i16 [[A:%.*]])
; CHECK-NEXT:    ret void
;
  %call = call i16 bitcast (i16 (i16, i16) * @bar to i16 (i16) *)(i16 %a)
  ret void
}

define internal i16 @bar(i16 %p1, i16 %p2) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:    ret i16 0
;
  ret i16 0
}

;-------------------------------------------------------------------------------
; Additional tests to verify that we still optimize when having a mismatch
; in argument count due to varargs (as long as all non-variadic arguments have
; been provided),

define dso_local i16 @vararg_tests(i16 %a) {
  %call1 = call i16 (i16, ...) @vararg_prop(i16 7, i16 8, i16 %a)
  %call2 = call i16 bitcast (i16 (i16, i16, ...) * @vararg_no_prop to i16 (i16) *) (i16 7)
  %add = add i16 %call1, %call2
  ret i16 %add
}

define internal i16 @vararg_prop(i16 %p1, ...) {
; CHECK-LABEL: define internal i16 @vararg_prop(
; CHECK-NEXT:    ret i16 7
;
  ret i16 %p1
}

define internal i16 @vararg_no_prop(i16 %p1, i16 %p2, ...) {
; CHECK-LABEL: define internal i16 @vararg_no_prop(
; CHECK-NEXT:    ret i16 [[P1:%.*]]
;
  ret i16 %p1
}

