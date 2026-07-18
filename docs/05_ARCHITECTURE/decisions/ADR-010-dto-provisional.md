# ADR-010 — Serialization: DTO tách entity, pilot auth, PROVISIONAL chờ contract ký

- **Trạng thái:** Đã chốt (GĐ4 Cụm F8, 2026-07-18)
- **Phạm vi:** tầng serialize JSON (DTO), quan hệ DTO ↔ entity, phạm vi codegen
- **Implementation tham chiếu:** `lib/features/auth/data/dto/` (AuthSessionDto + mapper + *.g.dart), bước CI codegen-diff trong job static

## Bối cảnh

Đánh giá Enterprise chỉ gap "0 serialization", nhưng 7 file
Backend-Contract-Skeleton chỉ có endpoint + tên method — KHÔNG có JSON shape
("skeleton only, pending signed backend contract"). Codegen đại trà 28
feature bây giờ là đoán shape sẽ đổi — chi phí sửa gấp bội khi contract ký.
Đồng thời entity domain đang mang metadata phục vụ UI/mock
(endpoint, supportedStates, contractNotes) không được phép rò sang JSON.

## Quyết định

1. **DTO tách hẳn khỏi entity**: DTO sống ở `data/dto/` với
   `@JsonSerializable()` + codegen; entity domain KHÔNG annotation, KHÔNG
   serialize. Mapper hai chiều nằm cạnh DTO. UI-metadata của entity không
   bao giờ vào JSON.
2. **Pilot duy nhất: auth** (contract async sẵn, skeleton rõ nhất, có điểm
   nối thật — AuthSessionController persist SecureStore qua DTO). Các
   feature còn lại KHÔNG codegen cho tới khi DEC-backend ký JSON schema —
   đây là drift CÓ CHỦ ĐÍCH so với gap "0 serialization" của đánh giá.
3. **Mọi DTO hiện tại là PROVISIONAL** — dartdoc từng DTO ghi rõ; khi
   contract ký, shape đổi chỉ chạm `data/dto/` + mapper, entity/UI đứng yên.
4. **Codegen phải được commit + CI canh**: job static chạy
   `build_runner build --delete-conflicting-outputs` rồi `git diff
   --exit-code` — file `*.g.dart` lệch với source là fail. Coverage đã loại
   `*.g.dart` khỏi mẫu số (có sẵn từ GĐ2).

## Hệ quả / nợ còn lại

- 27 feature chưa có DTO — việc CHỈ làm khi có JSON schema thật (fan-out
  theo khuôn pilot auth, ước tính rẻ vì mapper khuôn sẵn).
- build_runner thêm ~10-20s vào job static.
- DTO auth có thể sai so contract ký — chấp nhận, phạm vi sửa đã được cô
  lập trong `data/dto/`.
