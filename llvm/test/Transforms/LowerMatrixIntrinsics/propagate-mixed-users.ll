; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -lower-matrix-intrinsics -S < %s | FileCheck %s
; RUN: opt -passes='lower-matrix-intrinsics' -S < %s | FileCheck %s

; Currently we only lower stores with shape information, but need to embed the
; matrix in a flat vector for function calls and returns.
define <8 x double> @strided_load_4x4(<8 x double> %in, <8 x double>* %Ptr) {
; CHECK-LABEL: @strided_load_4x4(
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <8 x double> [[IN:%.*]], <8 x double> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <8 x double> [[IN]], <8 x double> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <4 x double> [[SPLIT]], i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x double> undef, double [[TMP1]], i64 0
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 0
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <2 x double> [[TMP2]], double [[TMP3]], i64 1
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x double> [[SPLIT]], i64 1
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x double> undef, double [[TMP5]], i64 0
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 1
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <2 x double> [[TMP6]], double [[TMP7]], i64 1
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <4 x double> [[SPLIT]], i64 2
; CHECK-NEXT:    [[TMP10:%.*]] = insertelement <2 x double> undef, double [[TMP9]], i64 0
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 2
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <2 x double> [[TMP10]], double [[TMP11]], i64 1
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <4 x double> [[SPLIT]], i64 3
; CHECK-NEXT:    [[TMP14:%.*]] = insertelement <2 x double> undef, double [[TMP13]], i64 0
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <4 x double> [[SPLIT1]], i64 3
; CHECK-NEXT:    [[TMP16:%.*]] = insertelement <2 x double> [[TMP14]], double [[TMP15]], i64 1
; CHECK-NEXT:    [[TMP17:%.*]] = shufflevector <2 x double> [[TMP4]], <2 x double> [[TMP8]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP18:%.*]] = shufflevector <2 x double> [[TMP12]], <2 x double> [[TMP16]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP19:%.*]] = shufflevector <4 x double> [[TMP17]], <4 x double> [[TMP18]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP20:%.*]] = bitcast <8 x double>* [[PTR:%.*]] to double*
; CHECK-NEXT:    [[TMP21:%.*]] = bitcast double* [[TMP20]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP4]], <2 x double>* [[TMP21]], align 8
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr double, double* [[TMP20]], i32 2
; CHECK-NEXT:    [[TMP23:%.*]] = bitcast double* [[TMP22]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP8]], <2 x double>* [[TMP23]], align 8
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr double, double* [[TMP20]], i32 4
; CHECK-NEXT:    [[TMP25:%.*]] = bitcast double* [[TMP24]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP12]], <2 x double>* [[TMP25]], align 8
; CHECK-NEXT:    [[TMP26:%.*]] = getelementptr double, double* [[TMP20]], i32 6
; CHECK-NEXT:    [[TMP27:%.*]] = bitcast double* [[TMP26]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP16]], <2 x double>* [[TMP27]], align 8
; CHECK-NEXT:    call void @foo(<8 x double> [[TMP19]])
; CHECK-NEXT:    ret <8 x double> [[TMP19]]
;
  %transposed = call <8 x double> @llvm.matrix.transpose(<8 x double> %in, i32 4, i32 2)
  store <8 x double> %transposed, <8 x double>* %Ptr
  call void @foo(<8 x double> %transposed)
  ret <8 x double> %transposed
}

declare <8 x double> @llvm.matrix.transpose(<8 x double>, i32, i32)

declare void @foo(<8 x double>)
