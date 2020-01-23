; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn--amdhsa -mcpu=hawaii -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

define amdgpu_kernel void @test_wave64(i32 %arg0, [8 x i32], i64 %saved) {
; GCN-LABEL: test_wave64:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dword s2, s[4:5], 0x0
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0xa
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cmp_eq_u32 s2, 0
; GCN-NEXT:    s_cselect_b32 s2, 1, 0
; GCN-NEXT:    s_and_b32 s2, 1, s2
; GCN-NEXT:    v_cmp_ne_u32_e64 s[2:3], 0, s2
; GCN-NEXT:    s_or_b64 s[0:1], s[2:3], s[0:1]
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    v_mov_b32_e32 v1, s1
; GCN-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; GCN-NEXT:    s_endpgm
entry:
  %cond = icmp eq i32 %arg0, 0
  %break = call i64 @llvm.amdgcn.if.break.i64(i1 %cond, i64 %saved)
  store volatile i64 %break, i64 addrspace(1)* undef
  ret void
}

declare i64 @llvm.amdgcn.if.break.i64(i1, i64)
