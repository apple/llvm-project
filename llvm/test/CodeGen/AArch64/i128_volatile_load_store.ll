; RUN: llc -mtriple=aarch64 %s -o - | FileCheck %s

@x = common dso_local global i128 0
@y = common dso_local global i128 0

define void @test1() {
; CHECK-LABEL: test1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x
; CHECK-NEXT:    add x8, x8, :lo12:x
; CHECK-NEXT:    ldp x8, x9, [x8]
; CHECK-NEXT:    adrp x10, y
; CHECK-NEXT:    add x10, x10, :lo12:y
; CHECK-NEXT:    stp x8, x9, [x10]
; CHECK-NEXT:    ret
  %tmp = load volatile i128, i128* @x
  store volatile i128 %tmp, i128* @y
  ret void
}

define void @test2() {
; CHECK-LABEL: test2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x
; CHECK-NEXT:    add x8, x8, :lo12:x
; CHECK-NEXT:    ldp x8, x9, [x8, #504]
; CHECK-NEXT:    adrp x10, y
; CHECK-NEXT:    add x10, x10, :lo12:y
; CHECK-NEXT:    stp x8, x9, [x10, #504]
; CHECK-NEXT:    ret
  %tmp = load volatile i128, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @x to i8*), i64 504) to i128*)
  store volatile i128 %tmp, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @y to i8*), i64 504) to i128*)
  ret void
}

define void @test3() {
; CHECK-LABEL: test3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x
; CHECK-NEXT:    add x8, x8, :lo12:x
; CHECK-NEXT:    add x8, x8, #512 // =512
; CHECK-NEXT:    ldp x8, x9, [x8]
; CHECK-NEXT:    adrp x10, y
; CHECK-NEXT:    add x10, x10, :lo12:y
; CHECK-NEXT:    add x10, x10, #512 // =512
; CHECK-NEXT:    stp x8, x9, [x10]
; CHECK-NEXT:    ret
  %tmp = load volatile i128, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @x to i8*), i64 512) to i128*)
  store volatile i128 %tmp, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @y to i8*), i64 512) to i128*)
  ret void
}

define void @test4() {
; CHECK-LABEL: test4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x
; CHECK-NEXT:    add x8, x8, :lo12:x
; CHECK-NEXT:    ldp x8, x9, [x8, #-512]
; CHECK-NEXT:    adrp x10, y
; CHECK-NEXT:    add x10, x10, :lo12:y
; CHECK-NEXT:    stp x8, x9, [x10, #-512]
; CHECK-NEXT:    ret
  %tmp = load volatile i128, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @x to i8*), i64 -512) to i128*)
  store volatile i128 %tmp, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @y to i8*), i64 -512) to i128*)
  ret void
}

define void @test5() {
; CHECK-LABEL: test5:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x
; CHECK-NEXT:    add x8, x8, :lo12:x
; CHECK-NEXT:    sub x8, x8, #520 // =520
; CHECK-NEXT:    ldp x8, x9, [x8]
; CHECK-NEXT:    adrp x10, y
; CHECK-NEXT:    add x10, x10, :lo12:y
; CHECK-NEXT:    sub x10, x10, #520 // =520
; CHECK-NEXT:    stp x8, x9, [x10]
; CHECK-NEXT:    ret
  %tmp = load volatile i128, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @x to i8*), i64 -520) to i128*)
  store volatile i128 %tmp, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @y to i8*), i64 -520) to i128*)
  ret void
}

define void @test6() {
; CHECK-LABEL: test6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x
; CHECK-NEXT:    add x8, x8, :lo12:x
; CHECK-NEXT:    sub x8, x8, #520 // =520
; CHECK-NEXT:    ldp x8, x9, [x8]
; CHECK-NEXT:    adrp x10, y
; CHECK-NEXT:    add x10, x10, :lo12:y
; CHECK-NEXT:    sub x10, x10, #520 // =520
; CHECK-NEXT:    stp x8, x9, [x10]
; CHECK-NEXT:    ret
  %tmp = load volatile i128, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @x to i8*), i64 -520) to i128*)
  store volatile i128 %tmp, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @y to i8*), i64 -520) to i128*)
  ret void
}

define void @test7() {
; CHECK-LABEL: test7:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x
; CHECK-NEXT:    add x8, x8, :lo12:x
; CHECK-NEXT:    add x8, x8, #503 // =503
; CHECK-NEXT:    ldp x8, x9, [x8]
; CHECK-NEXT:    adrp x10, y
; CHECK-NEXT:    add x10, x10, :lo12:y
; CHECK-NEXT:    add x10, x10, #503 // =503
; CHECK-NEXT:    stp x8, x9, [x10]
; CHECK-NEXT:    ret
  %tmp = load volatile i128, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @x to i8*), i64 503) to i128*)
  store volatile i128 %tmp, i128* bitcast (i8* getelementptr (i8, i8* bitcast (i128* @y to i8*), i64 503) to i128*)
  ret void
}
