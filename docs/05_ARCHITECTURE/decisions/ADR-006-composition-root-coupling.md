# ADR-006 — Composition root tập trung: chấp nhận coupling app ↔ features

- **Trạng thái:** Đã chốt (GĐ4 Cụm S, 2026-07-18 — văn bản hóa quyết định đã thi hành từ STATE-S26)
- **Phạm vi:** nơi khai báo controller provider của mọi feature; hệ quả lên khả năng tách package
- **Implementation tham chiếu:** `flutter_app/lib/app/providers/*_controller_providers.dart` (27 file), AGENTS.md mục "State management / controller pattern"

## Bối cảnh

Mỗi feature cần controller provider wiring repository + presentation models. Hai
khuôn phổ biến: (a) provider khai trong chính feature, `app/` chỉ override/wire
(kiểu very_good/Andrea — feature compile độc lập được); (b) **composition root
tập trung** — mọi controller provider sống ở `app/providers/`. Đánh giá
enterprise (2026-07-18) đo hệ quả của (b): feature presentation import ngược
`app/providers` ~400 lần + `app/router` ~244 lần ⇒ không feature nào compile
độc lập khỏi `lib/app`; đây từng là gap "ẩn" vì không ADR nào ghi lý do.

## Quyết định

1. **Giữ composition root tập trung** (`app/providers/<feature>_controller_providers.dart`)
   cho giai đoạn single-package: một chỗ duy nhất thấy toàn bộ wiring, guardrail
   `state_management`/`architecture_layer_boundary` quét một thư mục phẳng,
   và tránh 28 khuôn wiring lệch nhau (S2.6 của báo cáo gốc từng chỉ ra ba
   idiom controller song song che khuất composition root).
2. **Trade-off được chấp nhận có thời hạn:** coupling app↔features chặn tách
   package vật lý. Điều kiện mở lại quyết định: khi (a) DEC-backend hoàn tất
   tích hợp và khuôn data layer ổn định, VÀ (b) team ≥ ~6 người cần ranh giới
   compile-time — khi đó viết ADR mới cho lộ trình melos/pub-workspace, di
   provider về feature theo từng đợt.
3. Feature ĐƯỢC import từ `app/`: `app/providers` (controller của chính nó),
   `app/router` (AppRoutePaths/Names facade), `app/theme`. KHÔNG import
   provider của feature khác từ composition root (ranh giới ngang vẫn do
   guardrail cycle/import-debt canh).

## Hệ quả / nợ còn lại

- Chưa thể tách package per-feature; CODEOWNERS theo thư mục vẫn dùng được.
- Với team lớn, `app/providers/` là hub conflict tiềm năng — mỗi feature một
  file riêng đã giảm phần lớn; ratchet dùng chung (baseline literal) mới là
  điểm nghẽn thật (ghi nhận ở đánh giá, xử lý riêng).
- Khi backend về, wiring remote_ repository cũng đi qua đúng các file này —
  một chỗ đổi duy nhất mỗi feature.
