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

## Tablet-Adaptive batch (R1-R9, 5+ lần lặp lại)

- Nếu phone page có state switch LỒNG bên trong provider (vd
  `snapshot.screenState` enum riêng bên trong `FutureProvider<Snapshot>`,
  ngoài `AsyncValue.when` chuẩn), tablet page cần switch lồng tương tự —
  đừng chỉ port outer `.when()`. Nếu 1 nhánh lồng (vd `offline`) vừa show
  banner VỪA render dashboard bên dưới (không phải "thay vì" dashboard),
  đặt banner làm item ĐẦU của `primaryChildren` (giống
  `WalletUnavailableBanner` trong `WalletTabletPage`) — đừng bịa thêm một
  outer-layout branch thứ 3 cho riêng case đó.
- `if (context.mounted) context.go(...)` sau `await`, khi nằm trong closure
  async của một METHOD PHỤ của State (không phải trực tiếp `build()`), có
  thể vẫn bị `use_build_context_synchronously` bắt — dù cùng cú pháp guard
  chạy sạch khi viết trực tiếp trong `build()` hoặc dạng early-return
  `if (!mounted) return;`. Fix đã verify: capture
  `final navContext = context;` đầu closure TRƯỚC await, dùng biến local
  đó thay vì gọi lại getter `context` — theo đúng tiền lệ
  `WalletTabletPage._showMoreActions`'s `final rootContext = context;`.

## Copy tiếng Việt — encoding lệch trong cùng 1 file

- Cùng 1 file Dart (vd `profile_page.dart`) có thể trộn chuỗi tiếng Việt
  literal UTF-8 VÀ chuỗi escape `\uXXXX` cho các string KHÁC NHAU. So chuỗi
  thô sẽ báo lệch giả dù nội dung giống hệt — decode `\uXXXX` → ký tự thật
  bằng script (Python `re.sub(r'\\u([0-9A-Fa-f]{4})', ...)` + `chr`) rồi
  mới so khớp, đừng so chuỗi thô hoặc eyeball dấu tiếng Việt.
