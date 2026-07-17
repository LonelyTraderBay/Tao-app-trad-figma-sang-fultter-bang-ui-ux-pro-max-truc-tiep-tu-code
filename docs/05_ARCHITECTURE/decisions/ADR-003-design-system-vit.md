# ADR-003 — Design system VitTrade + audit/guardrail

- **Trạng thái:** Đã chốt (chuẩn hóa design system, 2026-07-12 · commit 0e92fe00)
- **Phạm vi:** toàn bộ UI — component library, theme token, page rhythm, và cơ chế enforce
- **Implementation tham chiếu:** `flutter_app/lib/shared/widgets/vit_*`, `flutter_app/lib/app/theme/`, `flutter_app/tool/*_audit.dart`

## Bối cảnh

Sau khi port từ Figma, UI có nguy cơ trôi dạt: mỗi màn hình tự dựng scaffold,
tự chọn spacing bằng magic number, tự vẽ card/pill/header. Không có cơ chế nào
chặn sự phân kỳ này ngoài review thủ công — không bền ở quy mô ~420 màn hình.

## Quyết định

1. **Component library `Vit*` là nguồn sự thật**: `VitAppShell`, `VitPageLayout`,
   `VitPageContent`, `VitHeader`, `VitBottomNav`, `VitCard`, `VitCtaButton`,
   `VitInput`, `VitTabBar`... — dùng trước khi dựng scaffold cục bộ.
2. **Theme token thay magic number**: màu/spacing/radii/text-style lấy từ
   `lib/app/theme/`; dark theme là baseline.
3. **Enforce bằng audit tool + guardrail test, không dựa review người**: mỗi domain
   nhất quán (card tile, page rhythm, segment pill, top header, back navigation,
   design token, spacing duplication, page content width...) có một tool sinh
   artifact CSV + một guardrail test `--check` so byte trên CI. Vi phạm mới =
   CI đỏ.
4. **Ratchet, không big-bang**: baseline đóng băng hiện trạng, chỉ cho phép giảm —
   migrate dần theo đợt.

## Hệ quả / nợ còn lại

- ~24 domain audit + guardrail (xem `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md`).
- Artifact so byte ⇒ mọi nondeterminism cross-OS là CI đỏ vĩnh viễn — tool phải
  ghi path repo-relative forward-slash + sort toàn phần (10 bài học ghi trong
  `feedback_cross_os_ci_nondeterminism`).
- Chi phí: mỗi tính năng mới phải qua khối verify + audit; bù lại UI đồng nhất
  không cần review pixel thủ công.
