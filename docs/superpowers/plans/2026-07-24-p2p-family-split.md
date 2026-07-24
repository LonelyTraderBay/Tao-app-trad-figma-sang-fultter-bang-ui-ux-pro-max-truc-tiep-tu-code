# P2P Family Split (ADR-012 · A2) Implementation Plan

> **Status:** COMPLETE trên `main` (PR0–PR8 / #63–#71 · 2026-07-24).  
> Plan lịch sử giữ để audit; **không** execute lại Task 0–5. Follow-up polish: hygiene docs/tool, page-rhythm scaffold, i18n ratchet (kế hoạch hoàn thiện riêng).

**Goal:** Tách monolith `features/p2p` (~244 Dart / 71 trang) thành họ sibling, giữ nguyên URL `/p2p/*`.

**Architecture (shipped):** Kernel leaf `p2p_core` (1 chiều); sibling không import lẫn nhau. Family cuối:

```text
p2p_core + p2p_marketplace + p2p_orders + p2p_account + p2p_security + p2p_dispute
```

- Wave-1 (PR0–PR5): tách presentation + xóa monolith; repo composite trong core.
- Wave-1b (PR7): 4 interface `P2P*Repository` + typed providers trong `p2p_core`.
- Wave-2 (PR8): `p2p_trust` → `p2p_security` + `p2p_dispute`; `P2PTrustRepository` giữ composite.
- Facade `app/providers/p2p_controller_providers.dart` **giữ** (re-export năm sibling) — Earn-style.

**Tech Stack:** Flutter, Riverpod, GoRouter, VitTrade feature layout, guardrail `module_dependency_cycle_guardrail_test.dart`.

**Spec / ADR:**
- [docs/superpowers/specs/2026-07-24-p2p-family-split-design.md](../specs/2026-07-24-p2p-family-split-design.md)
- [docs/05_ARCHITECTURE/decisions/ADR-012-p2p-family-split.md](../../05_ARCHITECTURE/decisions/ADR-012-p2p-family-split.md)

## Global Constraints (đã tuân thủ)

- Không đổi string path trong `p2p_route_ids.dart` / `AppRoutePaths` P2P.
- Copy vi-VN; không thêm chuỗi Anh user-facing.
- Escrow / payment ownership: **không** bỏ preview/confirm.
- `p2p_core` ↛ sibling; sibling ↛ sibling (`maxP2pCoreSiblingEdges = 0`).
- Mỗi PR squash khi CI + Enterprise Flutter Gates xanh.

---

## Task checklist (đã merge)

- [x] **Task 0 / PR0** — ADR + skeleton `p2p_core` + guardrail (#63)
- [x] **Task 1 / PR1** — `p2p_marketplace` (#64)
- [x] **Task 2 / PR2** — `p2p_orders` (#65)
- [x] **Task 3 / PR3** — `p2p_account` (#66)
- [x] **Task 4 / PR4** — `p2p_trust` tạm (#67)
- [x] **Task 5 / PR5** — xóa monolith `features/p2p` (#68)
- [x] **PR6** — debts settings routes + home-ref (#69)
- [x] **Task 6 / PR7** — wave-1b repo interfaces (#70)
- [x] **PR8** — wave-2 security + dispute (#71)

## Definition of Done

- [x] Không còn `features/p2p/` / `features/p2p_trust/`
- [x] 6 package family; URL `/p2p/*` giữ nguyên
- [x] Cycle = 0; providers + routes tách; ADR-012 Đã chốt

## Không làm thêm (theo ADR)

- Rename/split thêm `P2PTrustRepository`
- Mass-migrate import facade providers
- Entities per sibling (Earn parity core-centralized)

## Handoff

Split **xong**. Làm tiếp: kế hoạch hoàn thiện polish (hygiene → page-rhythm pending=0 → i18n batch).
