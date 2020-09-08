; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -newgvn -S | FileCheck %s
; PR4189
@G = external constant [4 x i32]

define i32 @test(i8* %p, i32 %i) nounwind {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P:%.*]] = getelementptr [4 x i32], [4 x i32]* @G, i32 0, i32 [[I:%.*]]
; CHECK-NEXT:    store i8 4, i8* [[P:%.*]]
; CHECK-NEXT:    ret i32 0
;
entry:
  %P = getelementptr [4 x i32], [4 x i32]* @G, i32 0, i32 %i
  %A = load i32, i32* %P
  store i8 4, i8* %p
  %B = load i32, i32* %P
  %C = sub i32 %A, %B
  ret i32 %C
}

