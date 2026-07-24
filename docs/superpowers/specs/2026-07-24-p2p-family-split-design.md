# Design: Tách họ P2P thành p2p_core + 4 sibling (A2)

- **Ngày:** 2026-07-24
- **Trạng thái:** Approved — implementation plan đã ghi  
- **Plan:** [docs/superpowers/plans/2026-07-24-p2p-family-split.md](../plans/2026-07-24-p2p-family-split.md)
- **ADR kèm:** [ADR-012](../../05_ARCHITECTURE/decisions/ADR-012-p2p-family-split.md)
- **Parity:** [ADR-011 Earn](../../05_ARCHITECTURE/decisions/ADR-011-earn-family-split.md), [ADR-002 Trade](../../05_ARCHITECTURE/decisions/ADR-002-trade-family-split.md)

## Mục tiêu

Tách monolith `features/p2p` (~244 `.dart`, 71 trang) thành họ feature sibling để ownership rõ, giảm blast radius rebuild/import, cho phép PR song song theo luồng sản phẩm — **không** đổi URL IA `/p2p/*`.

## Quyết định đã chốt (brainstorming)

1. Khung tổng: giống Earn (**option A** product-flow siblings, không 1-1 folder).
2. Cắt cụ thể: **A2** — `p2p_core` + 4 sibling.
3. Giữ path constants unified; tách route groups + providers theo sibling.
4. Wave-1 không redesign UI / không đổi BE contract hành vi.

## Kiến trúc package

```text
p2p_core (kernel leaf)
    ▲
    ├── p2p_marketplace   hub + ads + express/guide (~13 trang)
    ├── p2p_orders        orders + escrow + chat + p2p wallet (~12)
    ├── p2p_account       merchant/KYC + payment methods (~13)
    └── p2p_trust         security + dispute + insurance + compliance (~33)
```

### Luật import

| Từ → Đến | Cho phép? |
| --- | --- |
| sibling → `p2p_core` | Có |
| `p2p_core` → sibling | **Không** |
| sibling → sibling | **Không** |
| `app/` / router → bất kỳ sibling | Có |

Enforce: `test/quality/module_dependency_cycle_guardrail_test.dart` với `maxP2pCoreSiblingEdges = 0`.

### Ownership trang (folder hiện tại → package)

| Package | Folders `presentation/pages/` |
| --- | --- |
| `p2p_marketplace` | `hub/`, `ads/` |
| `p2p_orders` | `orders/`, `wallet/` |
| `p2p_account` | `merchant/`, `payment/` |
| `p2p_trust` | `security/`, `dispute/` |
| `p2p_core` | không có screen |

### Domain / data

- Shared: `p2p_shared_entities`, `p2p_errors`, types dùng chung → `p2p_core`.
- Entity theo slice (orders, ads, …) → sibling sở hữu.
- Tách `P2PRepository` monolith thành repository interface **theo sibling** (marketplace / orders / account / trust). Facade tạm chỉ nếu còn caller bắt buộc; ưu tiên migrate caller trong cùng PR.
- Fixtures mock chuyển theo ownership; cập nhật `mock_fixture_baseline` khi cần.

### Providers & router

- Tách `app/providers/p2p_controller_providers.dart` → 4 file sibling (+ core nếu có read-model shared).
- Giữ `p2p_route_ids.dart` (URL strings không đổi).
- Tách `p2p_routes.dart` → `p2p_marketplace_routes.dart`, `p2p_orders_routes.dart`, `p2p_account_routes.dart`, `p2p_trust_routes.dart`; mount trong `root_routes`.

## Lộ trình PR

| PR | Nội dung |
| --- | --- |
| PR0 | ADR-012 + skeleton `p2p_core` + guardrail stub |
| PR1 | Move `p2p_marketplace` |
| PR2 | Move `p2p_orders` (escrow high-risk — không đổi preview/confirm) |
| PR3 | Move `p2p_account` |
| PR4 | Move `p2p_trust` (có thể 4a security / 4b dispute+insurance nếu quá lớn) |
| PR5 | Xóa monolith `features/p2p`, dọn barrel, regen audits |

Mỗi PR: analyze + focused tests + route/nav audit + squash merge Enterprise.

## Testing

- Cycle guardrail p2p family.
- Route coverage + navigation edge current.
- Focused page/controller tests theo sibling đã move.
- Financial surfaces (payment ownership, escrow): không regress preview/confirm.

## Definition of Done

- Không còn monolith `features/p2p/` (xóa hẳn; không re-export dài hạn).
- 5 package tồn tại; URL `/p2p/*` giữ nguyên.
- Cycle core/sibling = 0.
- Providers + route groups tách; ADR-012 trên `main`; artifacts audit current.

## Out of scope (wave-1)

- Đổi IA path / rename URL.
- Redesign UI, copy mới, BE thật.
- Tách wave-2 `p2p_trust` → `p2p_security` / `p2p_dispute`.
- Đổi logic ProductSupport / financial ngoài move file.

## Rủi ro

- `p2p_trust` ~33 trang → PR4 lớn; fallback 4a/4b.
- Tách `P2PRepository` dễ sót method → checklist method→sibling trong plan.
- Mass import rewrite → dùng GitNexus impact + compile gate từng PR.

## Phê duyệt brainstorming

- §1 Kiến trúc: OK  
- §2 Data/providers/router/PR: OK  
- §3 Testing/DoD: OK  
