# MEMORY — flutter-batch-builder

Bẫy tích lũy khi implement batch VitTrade. Đọc trước khi sửa file; cập
nhật sau khi batch xanh nếu có bài học mới. Giữ file < 200 dòng.

## Widget dùng chung — blast radius

- Tăng footprint (padding/size/constraint) của một `Vit*` primitive dùng
  chung phá golden + tap-theo-offset ở màn KHÁC. Trước khi sửa shared
  primitive: chạy `tokensave_impact`; sau khi sửa: chạy FULL suite, không
  chỉ test của widget đó. `FittedBox` làm `tester.getSize(find.text())`
  trả kích thước sai — đừng assert size text qua FittedBox.

## Dedup / formatter

- Dedup shared formatter từng ĐỔI NGẦM copy tiền tệ (sự cố VitFormat
  440dcb06): khi gom formatter trùng lặp, corpus-diff toàn bộ chuỗi
  output trước/sau trên tập input thật, đừng chỉ so chữ ký hàm.

## Async — bẫy đã trả giá

- FakeAsync với zero-timer treo test; shell-watch cần `Duration.zero`;
  haptic gọi `unawaited(...)`; đừng để literal fallback che stream lỗi;
  `async*` bị cancel giữa chừng nuốt cleanup. Gặp timeout/pending-timer
  sau thay đổi async → soi các bẫy này trước khi debug sâu.

## Rename & audit tool

- Sau khi rename class/function router: grep `tool/` tìm tên cũ —
  `tool/*_audit.dart` hardcode symbol name dạng chuỗi, rename xong audit
  vẫn xanh giả.
- Page rhythm guardrail tên trong docs/rules có thể lệch: checkout 2026-07-22
  dùng `test/quality/page_rhythm_audit_sync_guardrail_test.dart`, không có
  `page_rhythm_guardrail_test.dart`; Glob test trước khi kết luận thiếu.

## Copy file số lượng lớn

- Glob `cp` rộng có thể ĐÈ file đã sửa; worktree thấy git HEAD cũ. Khi
  task yêu cầu "copy nguyên trạng", diff lại chuỗi dài sau copy — đừng
  tự nhận byte-for-byte khi chưa diff.

## Windows shell verify

- PowerShell trong Cursor Cloud win32 có thể không hỗ trợ `&&`; khi chain
  verify, dùng `; if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }` để tránh
  fail giả trước khi Dart/Flutter chạy.
