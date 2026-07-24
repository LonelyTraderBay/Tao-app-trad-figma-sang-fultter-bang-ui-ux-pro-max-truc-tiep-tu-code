# ADR-012 — Tách module P2P thành họ feature sibling (p2p_core / marketplace / orders / account / trust)

- **Trạng thái:** Đã chốt (PR5 · 2026-07-24)
- **Phạm vi:** toàn bộ họ P2P — cấu trúc thư mục feature, barrel export, IA route entry point
- **Design:** [docs/superpowers/specs/2026-07-24-p2p-family-split-design.md](../../superpowers/specs/2026-07-24-p2p-family-split-design.md)
- **Parity:** [ADR-002](ADR-002-trade-family-split.md) (Trade), [ADR-011](ADR-011-earn-family-split.md) (Earn)

## Bối cảnh

Module `p2p` là monolith ~244 file Dart / 71 trang presentation, gộp marketplace
(hub+ads), orders/escrow, account (merchant+payment), và trust
(security+dispute+insurance) trong một cây `domain`/`data`/`providers`/`router`.
Hệ quả giống pre–ADR-002 `trade` và pre–ADR-011 `earn`: rebuild diện rộng,
ranh giới sở hữu mờ, khó sửa song song.

## Quyết định

1. **Tách thành sibling ngang hàng (phương án A2):**
   - `p2p_marketplace` — hub, ads, express/guide
   - `p2p_orders` — orders, escrow, chat, p2p wallet
   - `p2p_account` — merchant/KYC, payment methods
   - `p2p_trust` — security, dispute, insurance, compliance/risk
2. **`p2p_core` là kernel leaf:** entity/shared UI/errors/contracts chảy **một chiều**
   ra sibling; sibling **không** import lẫn nhau; `p2p_core` **không** import sibling.
3. **Giữ nguyên path IA:** `AppRoutePaths` / URL (`/p2p`, `/p2p/orders/*`, …)
   không đổi — chỉ đổi package path + ownership.
4. **Route groups:** bốn file `p2p_*_routes.dart`; `p2p_route_ids.dart` giữ unified
   (tránh mass-rename path constants). Monolith `p2p_routes.dart` đã xóa ở PR5.
5. **Repository:** wave-1 giữ **một** mock / fixtures / `p2pRepositoryProvider`
   trong `p2p_core` (Earn parity). **Wave-1b (Task 6 / PR7 — done):** bốn
   interface sibling-owned sống **trong** `p2p_core` —
   `P2PMarketplaceRepository` / `P2POrdersRepository` / `P2PAccountRepository` /
   `P2PTrustRepository` — plus typed providers (`p2p*RepositoryProvider`)
   delegate về cùng instance; `P2PRepository` vẫn là composite facade
   `implements` cả bốn (tránh core→sibling edge nếu interface nằm ở sibling).
6. **Providers:** tách `p2p_*_controller_providers.dart` theo sibling tại
   `app/providers/`; facade `p2p_controller_providers.dart` chỉ re-export bốn
   sibling (Earn-style).

## Hệ quả / nợ còn lại

- Cycle bị cấm: guardrail `maxP2pCoreSiblingEdges = 0` trong
  `test/quality/module_dependency_cycle_guardrail_test.dart`. Sibling list
  hiện tại: marketplace / orders / account / **security** / **dispute**.
- **Wave-2 done (PR8):** `p2p_trust` đã tách thành `p2p_security` +
  `p2p_dispute` (presentation + routes + controller providers).
  `P2PTrustRepository` + `p2pTrustRepositoryProvider` **vẫn** ở `p2p_core`
  — cả hai sibling watch cùng typed provider (không tách interface repo thêm).
- Baseline mock fixture / audit CSV regen theo từng PR move; PR5 xóa residual
  module `p2p` khỏi home-ref.
- Wave-1b **done (PR7):** 4 sibling interfaces + typed providers trong
  `p2p_core`; composite `P2PRepository` facade giữ nguyên cho mock/fail-closed.
- Đánh đổi: nhiều import package hơn; bù lại blast radius và ownership rõ.

## Lộ trình thực thi (tóm tắt)

PR0 ADR+skeleton core → PR1 marketplace → PR2 orders → PR3 account →
PR4 trust → **PR5 xóa monolith `features/p2p` + chốt ADR** (hoàn tất wave-1).
Optional wave-1b: Task 6 / PR7 tách repository interfaces (**done** —
interfaces + typed providers trong `p2p_core`; composite facade giữ nguyên).
Optional wave-2: PR8 tách `p2p_trust` → `p2p_security` + `p2p_dispute`
(**done** — repo interface trust vẫn composite trong core).
