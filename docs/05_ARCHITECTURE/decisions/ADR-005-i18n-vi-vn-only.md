# ADR-005 — Chính sách ngôn ngữ vi-VN-only

- **Trạng thái:** Đã chốt (GĐ2 · I18N-1/I18N-2 · DEC-i18n Nhánh A, 2026-07-16/17)
- **Phạm vi:** mọi copy user-facing + widget hệ thống Material/Cupertino
- **Implementation tham chiếu:** `AGENTS.md` mục "Chính sách ngôn ngữ (vi-VN-only)", `flutter_app/lib/app/vit_trade_app.dart`

## Bối cảnh

Sản phẩm hướng thị trường Việt Nam, một ngôn ngữ. Bọc mọi chuỗi qua
ARB/`gen-l10n` ngay ở giai đoạn mock-UI (backend chưa chốt, chưa có ngôn ngữ
thứ hai) chỉ thêm một tầng gián tiếp mà không ai hưởng lợi. Nhưng để copy tiếng
Anh lọt vào lại phá trải nghiệm và khó dọn về sau. Quyết định gate: **DEC-i18n**.

## Quyết định

1. **Copy sản phẩm là tiếng Việt có dấu, viết inline** — hợp lệ, không cần
   ARB/gen-l10n ở giai đoạn này (DEC-i18n Nhánh A).
2. **Cấm thêm chuỗi tiếng Anh user-facing MỚI** trong presentation layer.
   Enforce bằng ratchet baseline-diff `test/quality/i18n_vi_only_guardrail_test.dart`
   (không language-detect — chỉ chặn literal mới so baseline; né bẫy tiếng Việt
   không dấu bằng cách đòi ≥2 từ marker tiếng Anh).
3. **Widget hệ thống nói tiếng Việt**: `flutter_localizations` + `locale: vi` +
   Global delegates (I18N-2) — date picker, menu dán... không rơi về tiếng Anh
   mặc định. Trang lỗi route cũng dùng copy tiếng Việt (SEC-S45, thay ErrorScreen
   mặc định của go_router).
4. **Số hiển thị theo facade `VitFormat`** (FMT-1): USD theo quy ước en-US, số
   đếm/VND cùng kiểu nhóm nghìn — đổi format ở MỘT nơi.

## Hệ quả / nợ còn lại

- Đường nâng cấp đã định: khi có backend/đa ngôn ngữ thật, migrate sang
  `flutter gen-l10n` (ARB) theo từng module — locale runtime đã sẵn.
- Baseline nợ tiếng Anh hiện trạng (~439 chuỗi) trả dần khi chạm file; sửa một
  chuỗi baseline nghĩa là dịch nó luôn.
