# ADR-009 — Chiến lược realtime: Stream 3 surface lõi, mock-phát-trước, WebSocket-sau

- **Trạng thái:** Đã chốt (GĐ4 Cụm F7, 2026-07-18 — theo quyết định user: "Stream 3 surface lõi với mock giả lập, Future phần còn lại")
- **Phạm vi:** nguồn dữ liệu đẩy (ticker/orderbook/nến), nơi thay nguồn phát khi backend về
- **Implementation tham chiếu:** `watchTicker`/`watchDepth`/`watchCandles` trong domain repositories, StreamProvider tương ứng ở `app/providers/`, `no_polling_guardrail_test.dart`

## Bối cảnh

App trading nhưng 0 Stream trong lib (đánh giá Enterprise 2026-07-18) — mọi
surface là snapshot tĩnh. Backend/WebSocket chưa có (DEC-backend chưa chạy),
nhưng tầng UI phải viết đúng khuôn đẩy NGAY để khi WS về chỉ thay nguồn phát.
Trong 5 surface ứng viên (ticker, orderbook, nến, badge thông báo, chat P2P),
user chốt 3 surface lõi giao dịch.

## Quyết định

1. **Contract THÊM `Stream<T>` cho đúng 3 surface**: `watchTicker` (markets),
   `watchDepth(pairId)`, `watchCandles(pairId, timeframe)` — các method
   `Future<T>` hiện có GIỮ NGUYÊN (stream là lớp cập-nhật-đè, Future là ảnh
   khởi tạo). Badge thông báo + chat P2P vẫn Future cho tới khi có WS thật.
2. **Mock phát giả lập DETERMINISTIC**: `Stream.periodic` + công thức biến
   đổi theo tick index trên bảng delta hằng — CẤM `Random`/`DateTime.now()`
   trong mock stream (test emitsInOrder tính tay được giá trị kỳ vọng;
   workflow resume/golden đều cần xác định).
3. **UI chỉ rebuild phần đổi**: StreamProvider + `.select()` theo từng
   pair/lát; painter nến giữ RepaintBoundary HN-5. Benchmark tick-rebuild
   ghim ngưỡng đếm update (proxy cấu trúc — ADR-007 vẫn áp).
4. **Cấm polling UI**: guardrail `no_polling` chặn `Timer.periodic` trong
   presentation/shared (allowlist đúng 2 Timer UI thuần: OTP countdown,
   carousel autoplay). Dữ liệu đẩy CHỈ đi qua Stream repo.
5. **Nơi thay nguồn phát duy nhất**: khi WS thật về, chỉ thay impl trong
   `data/repositories/remote_*` cho 3 method watch* — provider/UI không đổi.

## Hệ quả / nợ còn lại

- Mock phát 800ms/tick là nhịp demo — tần suất thật do backend quyết.
- Reconnect/backoff/subscription lifecycle của WS thật chưa mô hình hóa —
  việc của DEC-backend (impl remote sẽ cần thêm trạng thái kết nối, có thể
  cần ADR bổ sung khi ký contract WS).
- 2 surface còn lại (badge, chat) chuyển Stream khi WS về — không làm trước
  để tránh đoán khuôn subscription sai.
