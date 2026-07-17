# Đóng góp cho VitTrade Flutter

Cảm ơn bạn quan tâm. Đây là dự án **proprietary** (xem [LICENSE](LICENSE)) —
đóng góp chỉ nhận từ thành viên được cấp quyền.

## Nền tảng

- App sống trong `flutter_app/` (Flutter + Riverpod 3 + go_router). Xem
  [docs/INDEX.md](docs/INDEX.md) để định vị tài liệu, và
  [docs/05_ARCHITECTURE/decisions/](docs/05_ARCHITECTURE/decisions/) (ADR) để
  hiểu vì sao các quyết định kiến trúc được chốt.
- Quy tắc bắt buộc cho mọi thay đổi: [AGENTS.md](AGENTS.md) và
  [docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md](docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md).

## Quy trình

1. Tạo nhánh feature từ `main` (`main` có branch protection — không push thẳng).
2. Copy sản phẩm là **tiếng Việt có dấu** (chính sách vi-VN-only, ADR-005).
3. Trước khi mở PR, chạy khối verify chuẩn từ `flutter_app/`:

   ```bash
   flutter pub get
   dart format --output=none --set-exit-if-changed .
   flutter analyze
   dart run tool/route_coverage_audit.dart --check
   dart run tool/navigation_edge_audit.dart --check
   # ...và các tool audit khác đang bật (xem .github/workflows/flutter-ci.yml)
   flutter test
   ```

   Nếu tool audit báo artifact stale, chạy lại không có `--check` để tái sinh
   rồi commit artifact cùng thay đổi.
4. Mở PR — required check **"Enterprise Flutter Gates"** phải xanh trước khi
   merge. Dùng "Create a merge commit".

## Nguyên tắc

- Tối thiểu diff: dùng primitive `Vit*` + theme token trước khi dựng cục bộ
  (ADR-003). Vi phạm design-consistency bị guardrail chặn.
- Giữ ranh giới Prediction Markets ⟷ Open Arena tách bạch (AGENTS.md).
- Đường ghi tài chính theo idiom async ADR-001 (Notifier + Future + máy trạng
  thái, không AsyncValue cho high-risk).
