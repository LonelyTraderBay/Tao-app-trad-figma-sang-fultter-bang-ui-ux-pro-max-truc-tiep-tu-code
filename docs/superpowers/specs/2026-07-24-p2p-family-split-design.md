# Design: Tách họ P2P thành p2p_core + sibling (A2)

- **Ngày:** 2026-07-24
- **Trạng thái:** Implemented — wave-1 (PR0–PR5) + wave-1b (PR7) + wave-2 (PR8) trên `main`
- **Plan:** [docs/superpowers/plans/2026-07-24-p2p-family-split.md](../plans/2026-07-24-p2p-family-split.md)
- **ADR kèm:** [ADR-012](../../05_ARCHITECTURE/decisions/ADR-012-p2p-family-split.md)
- **Parity:** [ADR-011 Earn](../../05_ARCHITECTURE/decisions/ADR-011-earn-family-split.md), [ADR-002 Trade](../../05_ARCHITECTURE/decisions/ADR-002-trade-family-split.md)

## Mục tiêu

Tách monolith `features/p2p` (~244 `.dart`, 71 trang) thành họ feature sibling để ownership rõ, giảm blast radius rebuild/import, cho phép PR song song theo luồng sản phẩm — **không** đổi URL IA `/p2p/*`.

## Quyết định đã chốt (brainstorming)

1. Khung tổng: giống Earn (**option A** product-flow siblings, không 1-1 folder).
2. Cắt cụ thể: **A2** — `p2p_core` + product siblings (wave-1: 4; wave-2: trust → security + dispute).
3. Giữ path constants unified; tách route groups + providers theo sibling.
4. Wave-1 không redesign UI / không đổi BE contract hành vi.

## Kiến trúc package (post-PR8)

```text
p2p_core (kernel leaf)
    ▲
    ├── p2p_marketplace   hub + ads + express/guide
    ├── p2p_orders        orders + escrow + chat + p2p wallet
    ├── p2p_account       merchant/KYC + payment methods
    ├── p2p_security      security + compliance/risk (+ related)
    └── p2p_dispute       disputes + insurance + reviews/report
```

### Luật import

| Từ → Đến | Cho phép? |
| --- | --- |
| sibling → `p2p_core` | Có |
| `p2p_core` → sibling | **Không** |
| sibling → sibling | **Không** |
| `app/` / router → bất kỳ sibling | Có |

Enforce: `test/quality/module_dependency_cycle_guardrail_test.dart` với `maxP2pCoreSiblingEdges = 0`.

### Ownership trang (folder → package)

| Package | Folders `presentation/pages/` |
| --- | --- |
| `p2p_marketplace` | `hub/`, `ads/` |
| `p2p_orders` | `orders/`, `wallet/` |
| `p2p_account` | `merchant/`, `payment/` |
| `p2p_security` | `security/` (và trang security-owned) |
| `p2p_dispute` | `dispute/` (và insurance/reviews theo ownership PR8) |
| `p2p_core` | không có screen — shared widgets (vd. `VitP2PFlowScaffold`) |

### Domain / data

- Shared entities / errors / mock repo / fixtures → `p2p_core` (Earn parity; entities tập trung `p2p_entities.dart` + parts).
- Wave-1b: 4 interface `P2P*Repository` + typed providers trong `p2p_core`; composite `P2PRepository` facade.
- Wave-2: **không** tách thêm interface — `P2PTrustRepository` dùng chung bởi security + dispute.

### Providers & router

- Sibling providers tại `app/providers/p2p_*_controller_providers.dart`.
- Facade `p2p_controller_providers.dart` **giữ** (re-export năm sibling) — Earn-style.
- `p2p_route_ids.dart` unified; route groups: marketplace / orders / account / security / dispute.

## Lộ trình PR (đã merge)

| PR | Nội dung | Trạng thái |
| --- | --- | --- |
| PR0 | ADR-012 + skeleton `p2p_core` + guardrail stub | Done #63 |
| PR1 | Move `p2p_marketplace` | Done #64 |
| PR2 | Move `p2p_orders` | Done #65 |
| PR3 | Move `p2p_account` | Done #66 |
| PR4 | Move `p2p_trust` (security+dispute tạm) | Done #67 |
| PR5 | Xóa monolith `features/p2p` | Done #68 |
| PR6 | Debts: settings routes → profile; home-ref trust | Done #69 |
| PR7 | Wave-1b: 4 repo interfaces + typed providers | Done #70 |
| PR8 | Wave-2: `p2p_trust` → `p2p_security` + `p2p_dispute` | Done #71 |

## Testing

- Cycle guardrail p2p family.
- Route coverage + navigation edge current.
- Focused page/controller tests theo sibling.
- Financial surfaces: không regress preview/confirm.

## Definition of Done

- [x] Không còn monolith `features/p2p/` / `features/p2p_trust/`.
- [x] Family 6 package tồn tại; URL `/p2p/*` giữ nguyên.
- [x] Cycle core/sibling = 0.
- [x] Providers + route groups tách; ADR-012 trên `main`; artifacts audit current.

## Out of scope (đã loại / không làm thêm)

- Đổi IA path / rename URL.
- Redesign UI, copy mới (trừ i18n ratchet riêng), BE thật.
- Tách thêm interface `P2PTrustRepository` sau PR8.
- Entities per sibling (giữ Earn-parity core-centralized).

## Phê duyệt brainstorming

- §1 Kiến trúc: OK  
- §2 Data/providers/router/PR: OK  
- §3 Testing/DoD: OK  
