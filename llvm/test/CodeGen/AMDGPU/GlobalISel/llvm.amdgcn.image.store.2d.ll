; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tahiti -o - %s | FileCheck -check-prefix=GFX6 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -o - %s | FileCheck -check-prefix=GFX8 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -o - %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_ps void @image_store_f32(<8 x i32> inreg %rsrc, i32 %s, i32 %t, float %data) {
; GFX6-LABEL: image_store_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_store v2, v[0:1], s[0:7] dmask:0x1 unorm
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: image_store_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_store v2, v[0:1], s[0:7] dmask:0x1 unorm
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: image_store_f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v2, v[0:1], s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
  call void @llvm.amdgcn.image.store.2d.f32.i32(float %data, i32 1, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v2f32(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <2 x float> %in) {
; GFX6-LABEL: image_store_v2f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_store v[2:3], v[0:1], s[0:7] dmask:0x3 unorm
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: image_store_v2f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_store v[2:3], v[0:1], s[0:7] dmask:0x3 unorm
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: image_store_v2f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:3], v[0:1], s[0:7] dmask:0x3 dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
  call void @llvm.amdgcn.image.store.2d.v2f32.i32(<2 x float> %in, i32 3, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v3f32(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <3 x float> %in) {
; GFX6-LABEL: image_store_v3f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_store v[2:4], v[0:1], s[0:7] dmask:0x7 unorm
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: image_store_v3f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_store v[2:4], v[0:1], s[0:7] dmask:0x7 unorm
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: image_store_v3f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:4], v[0:1], s[0:7] dmask:0x7 dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
  call void @llvm.amdgcn.image.store.2d.v3f32.i32(<3 x float> %in, i32 7, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v4f32(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <4 x float> %in) {
; GFX6-LABEL: image_store_v4f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0xf unorm
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: image_store_v4f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0xf unorm
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: image_store_v4f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
  call void @llvm.amdgcn.image.store.2d.v4f32.i32(<4 x float> %in, i32 15, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v4f32_dmask_0001(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <4 x float> %in) {
; GFX6-LABEL: image_store_v4f32_dmask_0001:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x1 unorm
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: image_store_v4f32_dmask_0001:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x1 unorm
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: image_store_v4f32_dmask_0001:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
  call void @llvm.amdgcn.image.store.2d.v4f32.i32(<4 x float> %in, i32 1, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v4f32_dmask_0010(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <4 x float> %in) {
; GFX6-LABEL: image_store_v4f32_dmask_0010:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x2 unorm
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: image_store_v4f32_dmask_0010:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x2 unorm
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: image_store_v4f32_dmask_0010:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x2 dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
  call void @llvm.amdgcn.image.store.2d.v4f32.i32(<4 x float> %in, i32 2, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v4f32_dmask_0100(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <4 x float> %in) {
; GFX6-LABEL: image_store_v4f32_dmask_0100:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x4 unorm
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: image_store_v4f32_dmask_0100:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x4 unorm
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: image_store_v4f32_dmask_0100:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x4 dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
  call void @llvm.amdgcn.image.store.2d.v4f32.i32(<4 x float> %in, i32 4, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v4f32_dmask_1000(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <4 x float> %in) {
; GFX6-LABEL: image_store_v4f32_dmask_1000:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x8 unorm
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: image_store_v4f32_dmask_1000:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x8 unorm
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: image_store_v4f32_dmask_1000:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x8 dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
  call void @llvm.amdgcn.image.store.2d.v4f32.i32(<4 x float> %in, i32 8, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v4f32_dmask_0011(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <4 x float> %in) {
; GFX6-LABEL: image_store_v4f32_dmask_0011:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x3 unorm
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: image_store_v4f32_dmask_0011:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x3 unorm
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: image_store_v4f32_dmask_0011:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x3 dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
  call void @llvm.amdgcn.image.store.2d.v4f32.i32(<4 x float> %in, i32 3, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v4f32_dmask_0110(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <4 x float> %in) {
; GFX6-LABEL: image_store_v4f32_dmask_0110:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x6 unorm
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: image_store_v4f32_dmask_0110:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x6 unorm
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: image_store_v4f32_dmask_0110:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x6 dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
  call void @llvm.amdgcn.image.store.2d.v4f32.i32(<4 x float> %in, i32 6, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

declare void @llvm.amdgcn.image.store.2d.f32.i32(float, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare void @llvm.amdgcn.image.store.2d.v2f32.i32(<2 x float>, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare void @llvm.amdgcn.image.store.2d.v3f32.i32(<3 x float>, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare void @llvm.amdgcn.image.store.2d.v4f32.i32(<4 x float>, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind writeonly }
