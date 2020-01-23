; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

target datalayout = "p:64:64:64-i64:32:32"


define i64* @test1(i8* %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64**
; CHECK-NEXT:    [[B1:%.*]] = load i64*, i64** [[TMP0]], align 4
; CHECK-NEXT:    ret i64* [[B1]]
;
entry:
  %a = bitcast i8* %x to i64*
  %b = load i64, i64* %a
  %c = inttoptr i64 %b to i64*

  ret i64* %c
}

define i32* @test2(i8* %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = bitcast i8* [[X:%.*]] to i32*
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[B]] to i64
; CHECK-NEXT:    [[C:%.*]] = inttoptr i64 [[TMP0]] to i32*
; CHECK-NEXT:    ret i32* [[C]]
;
entry:
  %a = bitcast i8* %x to i32*
  %b = load i32, i32* %a
  %c = inttoptr i32 %b to i32*

  ret i32* %c
}

define i64* @test3(i8* %x) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = bitcast i8* [[X:%.*]] to i32*
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[B]] to i64
; CHECK-NEXT:    [[C:%.*]] = inttoptr i64 [[TMP0]] to i64*
; CHECK-NEXT:    ret i64* [[C]]
;
entry:
  %a = bitcast i8* %x to i32*
  %b = load i32, i32* %a
  %c = inttoptr i32 %b to i64*

  ret i64* %c
}

define i64 @test4(i8* %x) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; CHECK-NEXT:    [[B1:%.*]] = load i64, i64* [[TMP0]], align 8
; CHECK-NEXT:    ret i64 [[B1]]
;
entry:
  %a = bitcast i8* %x to i64**
  %b = load i64*, i64** %a
  %c = ptrtoint i64* %b to i64

  ret i64 %c
}

define i32 @test5(i8* %x) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; CHECK-NEXT:    [[B1:%.*]] = load i64, i64* [[TMP0]], align 8
; CHECK-NEXT:    [[C:%.*]] = trunc i64 [[B1]] to i32
; CHECK-NEXT:    ret i32 [[C]]
;
entry:
  %a = bitcast i8* %x to i32**
  %b = load i32*, i32** %a
  %c = ptrtoint i32* %b to i32

  ret i32 %c
}

define i64 @test6(i8* %x) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; CHECK-NEXT:    [[B1:%.*]] = load i64, i64* [[TMP0]], align 8
; CHECK-NEXT:    ret i64 [[B1]]
;
entry:
  %a = bitcast i8* %x to i32**
  %b = load i32*, i32** %a
  %c = ptrtoint i32* %b to i64

  ret i64 %c
}

