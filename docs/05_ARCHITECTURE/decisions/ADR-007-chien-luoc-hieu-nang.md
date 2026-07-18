# ADR-007 — Chiến lược hiệu năng: bounded-build + repaint isolation, đo bằng proxy cấu trúc

- **Trạng thái:** Đã chốt (GĐ4 Cụm S, 2026-07-18 — văn bản hóa các quyết định PERF-HN1..HN7 đã thi hành ở GĐ2/GĐ3)
- **Phạm vi:** khuôn render danh sách, painter, rebuild control, và cách ĐO hiệu năng
- **Implementation tham chiếu:** `market_controller_providers.dart` (memoize visiblePairs), `advanced_chart_painter.dart` (hoist + shouldRepaint), `test/quality/market_predictions_scroll_benchmark_test.dart`, `heavy_painter_repaint_boundary_guardrail_test.dart`

## Bối cảnh

App có ~420 màn hình dựng trên khuôn `VitPageContent` (Column trong
SingleChildScrollView) — trục xương sống của cả hệ guardrail page-rhythm.
Chuyển các trang sang Sliver/virtualization phá khuôn đó với blast radius
lớn, trong khi data mock hữu hạn. Đồng thời chưa có hạ tầng đo thời gian
(frame time/jank trên thiết bị thật). Cần một chiến lược nhất quán, có
enforce, và trung thực về giới hạn của chính nó.

## Quyết định

1. **Bounded-build thay vì virtualization** (HN-3): danh sách trên hub bị CAP
   qua lát cắt memoize tính MỘT lần khi dựng state/snapshot
   (`visiblePairs`/`visibleEvents`, cap 8) + đường thoát "Xem tất cả" sang
   trang tìm kiếm. Số widget dựng phải ĐỘC LẬP độ dài data — benchmark ghim
   bounded-count và ghim card Xem-tất-cả hiện diện (chống gỡ cap lặng lẽ).
   Virtualization thật (Sliver/ListView.builder) chỉ mở lại khi backend thật
   đưa danh sách không cap được về mặt sản phẩm (vd lịch sử lệnh vô hạn) —
   khi đó làm per-surface, không đổi khuôn toàn app.
2. **Painter nặng: hoist + isolate** (HN-5): tính toán đắt hoist ra khỏi
   `paint()` (memo theo identity ở page-state), `shouldRepaint` identity
   fast-path + listEquals, `RepaintBoundary` tại mount site — guardrail pin
   danh sách file đã bọc, mở rộng dần khi thêm painter mới.
3. **Rebuild control**: watch qua `.select()` từng lát; rebuild harness
   (ProviderObserver) ghim ngưỡng đếm-build với baseline đo thực; 3 lint
   const bật để widget bất biến không rebuild.
4. **Đo bằng proxy cấu trúc, khai rõ giới hạn**: các bằng chứng hiện tại là
   ĐẾM (widget count, paint count, build count) — không phải thời gian.
   Điều kiện nâng cấp: khi có thiết bị test/backend thật, bổ sung
   integration-test timeline (frame budget) và đo trên thiết bị yếu; tới lúc
   đó KHÔNG tuyên bố con số ms nào trong tài liệu.

## Hệ quả / nợ còn lại

- Mẫu nền Column-trong-SingleChildScrollView vẫn phủ đa số trang — chấp nhận
  cho nội dung theo-trang hữu hạn; các surface data-tăng-trưởng đã bounded.
- Trang tìm kiếm predictions (đường thoát của cap) hiện dựng-toàn-bộ kết quả
  — ứng viên virtualization per-surface đầu tiên khi backend về.
- RepaintBoundary mới phủ các mount site painter nặng đã biết (6 file) —
  painter mới phải tự thêm (guardrail nhắc).
- Chưa có phép đo thời gian nào — mọi kết luận "nhanh" đều là suy diễn từ
  cấu trúc; giữ thái độ này trong mọi báo cáo cho tới khi có đo thật.
