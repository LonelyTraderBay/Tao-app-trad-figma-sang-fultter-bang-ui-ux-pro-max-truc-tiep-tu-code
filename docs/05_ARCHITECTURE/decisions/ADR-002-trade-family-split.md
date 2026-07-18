# ADR-002 — Tách module Trade thành 5 feature sibling

- **Trạng thái:** Đã chốt (refactor kiến trúc, 2026-07-14 · commit 6da5cfc3)
- **Phạm vi:** toàn bộ họ Trade — cấu trúc thư mục feature, barrel export, IA route entry point
- **Implementation tham chiếu:** `flutter_app/lib/features/trade*`, `flutter_app/lib/features/trade_core`

## Bối cảnh

Ban đầu toàn bộ chức năng giao dịch nằm trong một module `trade` khổng lồ:
spot, futures/margin, bots, copy-trading, compliance, terminal-tools trộn chung
một cây thư mục và một barrel. Hệ quả: mọi thay đổi nhỏ kéo theo rebuild diện
rộng, ranh giới sở hữu mờ, và các cycle import ngầm giữa những phần đáng lẽ độc
lập. Khi số màn hình họ trade tăng, module đơn khối trở thành god-module.

## Quyết định

1. **Tách thành các feature sibling ngang hàng**: `trade` (spot), `trade_bots`,
   `trade_copy`, `trade_compliance`, `trade_terminal` — mỗi feature một cây
   `data/domain/presentation` riêng, một sở hữu rõ ràng.
2. **`trade_core` là kernel dùng chung**: entity/contract chia sẻ (draft, snapshot,
   high-risk status, navigation contract) chảy MỘT CHIỀU ra các sibling; sibling
   KHÔNG được import ngược nhau qua barrel trade_core.
3. **Route entry point theo IA map**: mỗi feature đăng ký route group riêng
   (`route_groups/<feature>_routes.dart`); header/hero Trade chuẩn hóa dùng chung.

## Hệ quả / nợ còn lại

- Cycle import giữa các sibling bị cấm và enforce bằng
  `test/quality/module_dependency_cycle_guardrail_test.dart` (ARCH-A1 ở GĐ2 đã
  đưa allowlist về rỗng + ratchet `maxTradeCoreSiblingEdges = 0`).
- Entity dùng chung phải dồn về `trade_core/domain/entities/` — không nhân bản ở
  sibling. Bản `trade_product_navigation` từng bị nhân đôi đã được hợp nhất về
  kernel (xem lịch sử ARCH-A1).
- Đánh đổi: nhiều barrel + import trực tiếp hơn (≈212 file downstream đổi import),
  bù lại rebuild cô lập và ranh giới sở hữu sắc nét.
