; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

;
; ST1B, ST1W, ST1H, ST1D: vector base + scalar offset
;   e.g. st1h { z0.s }, p0, [x0, z1.d]
;

; ST1B
define void @sst1b_s_scalar_offset(<vscale x 4 x i32> %data, <vscale x 4 x i1> %pg, <vscale x 4 x i32> %base, i64 %offset) {
; CHECK-LABEL: sst1b_s_scalar_offset:
; CHECK: st1b { z0.s }, p0, [x0, z1.s, uxtw]
; CHECK-NEXT: ret
  %data_trunc = trunc <vscale x 4 x i32> %data to <vscale x 4 x i8>
  call void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv4i8.nxv4i32(<vscale x 4 x i8> %data_trunc,
                                                                       <vscale x 4 x i1> %pg,
                                                                       <vscale x 4 x i32> %base,
                                                                       i64 %offset)
  ret void
}

define void @sst1b_d_scalar_offset(<vscale x 2 x i64> %data, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %base, i64 %offset) {
; CHECK-LABEL: sst1b_d_scalar_offset:
; CHECK: st1b { z0.d }, p0, [x0, z1.d]
; CHECK-NEXT: ret
  %data_trunc = trunc <vscale x 2 x i64> %data to <vscale x 2 x i8>
  call void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv2i8.nxv2i64(<vscale x 2 x i8> %data_trunc,
                                                                       <vscale x 2 x i1> %pg,
                                                                       <vscale x 2 x i64> %base,
                                                                       i64 %offset)
  ret void
}

; ST1H
define void @sst1h_s_scalar_offset(<vscale x 4 x i32> %data, <vscale x 4 x i1> %pg, <vscale x 4 x i32> %base, i64 %offset) {
; CHECK-LABEL: sst1h_s_scalar_offset:
; CHECK: st1h { z0.s }, p0, [x0, z1.s, uxtw]
; CHECK-NEXT: ret
  %data_trunc = trunc <vscale x 4 x i32> %data to <vscale x 4 x i16>
  call void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv4i16.nxv4i32(<vscale x 4 x i16> %data_trunc,
                                                                        <vscale x 4 x i1> %pg,
                                                                        <vscale x 4 x i32> %base,
                                                                        i64 %offset)
  ret void
}

define void @sst1h_d_scalar_offset(<vscale x 2 x i64> %data, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %base, i64 %offset) {
; CHECK-LABEL: sst1h_d_scalar_offset:
; CHECK: st1h { z0.d }, p0, [x0, z1.d]
; CHECK-NEXT: ret
  %data_trunc = trunc <vscale x 2 x i64> %data to <vscale x 2 x i16>
  call void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv2i16.nxv2i64(<vscale x 2 x i16> %data_trunc,
                                                                        <vscale x 2 x i1> %pg,
                                                                        <vscale x 2 x i64> %base,
                                                                        i64 %offset)
  ret void
}

; ST1W
define void @sst1w_s_scalar_offset(<vscale x 4 x i32> %data, <vscale x 4 x i1> %pg, <vscale x 4 x i32> %base, i64 %offset) {
; CHECK-LABEL: sst1w_s_scalar_offset:
; CHECK: st1w { z0.s }, p0, [x0, z1.s, uxtw]
; CHECK-NEXT: ret
  call void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv4i32.nxv4i32(<vscale x 4 x i32> %data,
                                                                        <vscale x 4 x i1> %pg,
                                                                        <vscale x 4 x i32> %base,
                                                                        i64 %offset)
  ret void
}

define void @sst1w_d_scalar_offset(<vscale x 2 x i64> %data, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %base, i64 %offset) {
; CHECK-LABEL: sst1w_d_scalar_offset:
; CHECK: st1w { z0.d }, p0, [x0, z1.d]
; CHECK-NEXT: ret
  %data_trunc = trunc <vscale x 2 x i64> %data to <vscale x 2 x i32>
  call void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv2i32.nxv2i64(<vscale x 2 x i32> %data_trunc,
                                                                        <vscale x 2 x i1> %pg,
                                                                        <vscale x 2 x i64> %base,
                                                                        i64 %offset)
  ret void
}

define void @sst1w_s_scalar_offset_float(<vscale x 4 x float> %data, <vscale x 4 x i1> %pg, <vscale x 4 x i32> %base, i64 %offset) {
; CHECK-LABEL: sst1w_s_scalar_offset_float:
; CHECK: st1w { z0.s }, p0, [x0, z1.s, uxtw]
; CHECK-NEXT: ret
  call void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv4f32.nxv4i32(<vscale x 4 x float> %data,
                                                                        <vscale x 4 x i1> %pg,
                                                                        <vscale x 4 x i32> %base,
                                                                        i64 %offset)
  ret void
}

; ST1D
define void @sst1d_d_scalar_offset(<vscale x 2 x i64> %data, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %base, i64 %offset) {
; CHECK-LABEL: sst1d_d_scalar_offset:
; CHECK: st1d { z0.d }, p0, [x0, z1.d]
; CHECK-NEXT: ret
  call void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv2i64.nxv2i64(<vscale x 2 x i64> %data,
                                                                        <vscale x 2 x i1> %pg,
                                                                        <vscale x 2 x i64> %base,
                                                                        i64 %offset)
  ret void
}

define void @sst1d_d_scalar_offset_double(<vscale x 2 x double> %data, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %base, i64 %offset) {
; CHECK-LABEL: sst1d_d_scalar_offset_double:
; CHECK: st1d { z0.d }, p0, [x0, z1.d]
; CHECK-NEXT: ret
  call void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv2f64.nxv2i64(<vscale x 2 x double> %data,
                                                                        <vscale x 2 x i1> %pg,
                                                                        <vscale x 2 x i64> %base,
                                                                        i64 %offset)
  ret void
}

; ST1B
declare void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv4i8.nxv4i32(<vscale x 4 x i8>, <vscale x 4 x i1>, <vscale x 4 x i32>, i64)
declare void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv2i8.nxv2i64(<vscale x 2 x i8>, <vscale x 2 x i1>, <vscale x 2 x i64>, i64)

; ST1H
declare void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv4i16.nxv4i32(<vscale x 4 x i16>, <vscale x 4 x i1>, <vscale x 4 x i32>, i64)
declare void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv2i16.nxv2i64(<vscale x 2 x i16>, <vscale x 2 x i1>, <vscale x 2 x i64>, i64)

; ST1W
declare void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv4i32.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i1>, <vscale x 4 x i32>, i64)
declare void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv2i32.nxv2i64(<vscale x 2 x i32>, <vscale x 2 x i1>, <vscale x 2 x i64>, i64)

declare void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv4f32.nxv4i32(<vscale x 4 x float>, <vscale x 4 x i1>, <vscale x 4 x i32>, i64)

; ST1D
declare void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv2i64.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i1>, <vscale x 2 x i64>, i64)

declare void @llvm.aarch64.sve.st1.scatter.scalar.offset.nxv2f64.nxv2i64(<vscale x 2 x double>, <vscale x 2 x i1>, <vscale x 2 x i64>, i64)
