; RUN: llc %s -filetype=obj -mtriple arm64e-apple-darwin -o - \
; RUN:   | llvm-dwarfdump - | FileCheck %s

; CHECK: DW_TAG_structure_type
; CHECK: DW_AT_LLVM_alternative_module_name ("AlternativeName")

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

@p = common global i8* null, align 8, !dbg !100

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!6, !7}

!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, emissionKind: FullDebug, globals: !5)
!3 = !DIFile(filename: "/tmp/p.c", directory: "/")
!4 = !{}
!5 = !{!100}
!6 = !{i32 2, !"Dwarf Version", i32 4}
!7 = !{i32 2, !"Debug Info Version", i32 3}

!10 = !DICompositeType(tag: DW_TAG_structure_type, name: "TypeWithAlternativeModule", file: !3, size: 32, alternative_module_name: "AlternativeName")

!100 = !DIGlobalVariableExpression(var: !101, expr: !DIExpression())
!101 = distinct !DIGlobalVariable(name: "p", scope: !2, file: !3, line: 1, type: !10, isLocal: false, isDefinition: true)
