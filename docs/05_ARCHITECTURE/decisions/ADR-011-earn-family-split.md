# ADR-011 — Tách module Earn thành họ feature sibling (earn_core / earn_staking / earn_savings)

- **Trạng thái:** Đã chốt (P0 maintainability · 2026-07-23)
- **Phạm vi:** toàn bộ họ Earn — cấu trúc thư mục feature, barrel export, IA route entry point
- **Implementation tham chiếu:** `flutter_app/lib/features/earn_core`, `earn_staking`, `earn_savings`
- **Parity:** cùng pattern với [ADR-002](ADR-002-trade-family-split.md) (Trade family)

> Số ADR-003 trong plan P0 trùng mã đã cấp cho design system ([ADR-003](ADR-003-design-system-vit.md)); quyết định Earn family được ghi nhận tại **ADR-011**.

## Bối cảnh

Module `earn` là monolith ~346 file / ~86k LOC, gộp Staking và Savings trong một
cây `domain`/`data`/`providers`/`router` dù presentation đã tách thư mục
`staking/` vs `savings/`. Hệ quả giống pre–ADR-002 `trade`: rebuild diện rộng,
ranh giới sở hữu mờ, khó sửa song song.

## Quyết định

1. **Tách thành sibling ngang hàng:** `earn_staking`, `earn_savings` — mỗi feature
   một cây `data/domain/presentation` riêng.
2. **`earn_core` là kernel leaf:** entity/shared UI/catalog/legal/navigation contract
   chảy **một chiều** ra sibling; sibling **không** import lẫn nhau; `earn_core`
   **không** import sibling.
3. **Giữ nguyên path IA:** `AppRoutePaths` / URL (`/earn`, `/earn/savings/*`, …)
   không đổi — chỉ đổi package path + ownership. Active-tab D1 (Trade highlight)
   không đổi.
4. **Route groups:** `earn_staking_routes.dart` + `earn_savings_routes.dart`;
   `earn_route_ids.dart` giữ unified (tránh mass-rename path constants).
5. **Ownership đặc biệt:** `auto_compound_settings*` và comparison hub widgets thuộc
   **earn_savings** (route `/earn/savings/auto-compound`), dù file từng nằm dưới
   `staking/` / `hub/`.

## Hệ quả / nợ còn lại

- Cycle bị cấm: guardrail `maxEarnCoreSiblingEdges = 0` trong
  `test/quality/module_dependency_cycle_guardrail_test.dart`.
- Tách `mock_earn_repository` (DEBT-87) phải cập nhật baseline
  `mock_fixture_baseline_guardrail_test.dart` theo family.
- Đánh đổi: nhiều import package hơn; bù lại blast radius và ownership rõ.
