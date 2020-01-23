; RUN: llc -mcpu=core2 -mtriple=i686-pc-win32 -O0 < %s | FileCheck --check-prefix=X86 %s

; This LL file was generated by running clang on the following code:
; D:\test.cpp:
; 1 void foo();
; 2
; 3 static void bar(int arg, ...) {
; 4   foo();
; 5 }
; 6
; 7 void spam(void) {
; 8   bar(42);
; 9 }
;
; The bar function happens to have no lexical scopes, yet it has one instruction
; with debug information available.  This used to be PR19239.

; X86:      .cv_file 1 "D:\\test.cpp"

; X86-LABEL: {{^}}"?bar@@YAXHZZ":
; X86:      .cv_loc  1 1 4 0
; X86:      jmp "?foo@@YAXXZ"
; X86:      [[END_OF_BAR:.?Lfunc_end.*]]:{{$}}
; X86-NOT:  ret

; X86-LABEL: .section        .debug$S,"dr"
; X86:       .secrel32 "?bar@@YAXHZZ"
; X86-NEXT:  .secidx   "?bar@@YAXHZZ"
; X86:       .cv_linetable 1, "?bar@@YAXHZZ", [[END_OF_BAR]]
; X86:       .cv_filechecksums
; X86:       .cv_stringtable

; ModuleID = 'test.cpp'
target datalayout = "e-m:w-p:32:32-i64:64-f80:32-n8:16:32-S32"
target triple = "i686-pc-win32"

; Function Attrs: nounwind
define void @"\01?spam@@YAXXZ"() #0 !dbg !4 {
entry:
  tail call void @"\01?bar@@YAXHZZ"(), !dbg !11
  ret void, !dbg !12
}

; Function Attrs: nounwind
define internal void @"\01?bar@@YAXHZZ"() #0 !dbg !7 {
entry:
  tail call void @"\01?foo@@YAXXZ"() #2, !dbg !13
  ret void, !dbg !14
}

declare void @"\01?foo@@YAXXZ"() #1

attributes #0 = { nounwind "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9}
!llvm.ident = !{!10}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, producer: "clang version 3.5.0 ", isOptimized: true, emissionKind: LineTablesOnly, file: !1, enums: !2, retainedTypes: !2, globals: !2, imports: !2)
!1 = !DIFile(filename: "test.cpp", directory: "D:\5C")
!2 = !{}
!4 = distinct !DISubprogram(name: "spam", line: 7, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: true, unit: !0, scopeLine: 7, file: !1, scope: !5, type: !6, retainedNodes: !2)
!5 = !DIFile(filename: "test.cpp", directory: "D:C")
!6 = !DISubroutineType(types: !2)
!7 = distinct !DISubprogram(name: "bar", line: 3, isLocal: true, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: true, unit: !0, scopeLine: 3, file: !1, scope: !5, type: !6, retainedNodes: !2)
!8 = !{i32 2, !"CodeView", i32 1}
!9 = !{i32 1, !"Debug Info Version", i32 3}
!10 = !{!"clang version 3.5.0 "}
!11 = !DILocation(line: 8, scope: !4)
!12 = !DILocation(line: 9, scope: !4)
!13 = !DILocation(line: 4, scope: !7)
!14 = !DILocation(line: 5, scope: !7)
