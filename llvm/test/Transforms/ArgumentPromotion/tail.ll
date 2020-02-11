; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt %s -argpromotion -S -o - | FileCheck %s
; RUN: opt %s -passes=argpromotion -S -o - | FileCheck %s
; PR14710

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

%pair = type { i32, i32 }

declare i8* @foo(%pair*)

define internal void @bar(%pair* byval %Data) {
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: (i32 [[DATA_0:%.*]], i32 [[DATA_1:%.*]])
; CHECK-NEXT:    [[DATA:%.*]] = alloca [[PAIR:%.*]]
; CHECK-NEXT:    [[DOT0:%.*]] = getelementptr [[PAIR]], %pair* [[DATA]], i32 0, i32 0
; CHECK-NEXT:    store i32 [[DATA_0]], i32* [[DOT0]]
; CHECK-NEXT:    [[DOT1:%.*]] = getelementptr [[PAIR]], %pair* [[DATA]], i32 0, i32 1
; CHECK-NEXT:    store i32 [[DATA_1]], i32* [[DOT1]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @foo(%pair* [[DATA]])
; CHECK-NEXT:    ret void
;
  tail call i8* @foo(%pair* %Data)
  ret void
}

define void @zed(%pair* byval %Data) {
; CHECK-LABEL: define {{[^@]+}}@zed
; CHECK-SAME: (%pair* byval [[DATA:%.*]])
; CHECK-NEXT:    [[DATA_0:%.*]] = getelementptr [[PAIR:%.*]], %pair* [[DATA]], i32 0, i32 0
; CHECK-NEXT:    [[DATA_0_VAL:%.*]] = load i32, i32* [[DATA_0]]
; CHECK-NEXT:    [[DATA_1:%.*]] = getelementptr [[PAIR]], %pair* [[DATA]], i32 0, i32 1
; CHECK-NEXT:    [[DATA_1_VAL:%.*]] = load i32, i32* [[DATA_1]]
; CHECK-NEXT:    call void @bar(i32 [[DATA_0_VAL]], i32 [[DATA_1_VAL]])
; CHECK-NEXT:    ret void
;
  call void @bar(%pair* byval %Data)
  ret void
}
