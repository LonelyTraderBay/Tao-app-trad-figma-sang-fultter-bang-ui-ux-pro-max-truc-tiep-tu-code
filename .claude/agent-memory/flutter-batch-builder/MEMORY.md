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

## Trích shared widget → audit tool fan-out ngoài danh sách verify

- Khi trích 1 block `VitCard`/`VitPageContent`/token khỏi 1 page ra shared
  widget (vd `VitTwoColumnTabletDashboard`, batch 2026-07-29), full suite có
  thể lộ ≥2 guardrail KHÔNG nằm trong danh sách lệnh verify của task, dù
  cause là chính file mới đó:
  - `tool/card_tile_manifest.dart` ghi `VitTrade-Card-Tile-Migration-
    Manifest.csv` — KHÁC `card_tile_audit.dart`'s "legacy manifest"
    (`VitTrade-Card-Tile-Manifest.csv`, tên gần giống nhưng là 2 tool/2 file
    riêng). Chạy `card_tile_audit.dart --check` xanh KHÔNG có nghĩa
    manifest này cũng current.
  - `tool/design_token_consistency_audit.dart` stale ngay khi có file
    `lib/` mới (kể cả 0 debt) — nó cần 1 dòng cho file đó.
  - Cả hai có guardrail test riêng trong `test/quality/` → full suite
    (`flutter test`, bắt buộc khi đụng `shared/layout|widgets`) sẽ bắt được;
    đây chính là lý do "full suite" không phải tuỳ chọn dù task chỉ liệt kê
    3 audit tool cụ thể.
  - `tool/navigation_edge_audit.dart` stale ngay cả khi CHỈ xoá import
    (dịch số dòng của lệnh `context.go`/`push`, không đổi logic điều
    hướng) — tool này KHÔNG wire vào bất kỳ `flutter test` guardrail nào
    (artifact-check only, xem Flutter-Design-System-Reference.md §2), nên
    full suite xanh KHÔNG đảm bảo nó current — phải tự chạy
    `dart run tool/navigation_edge_audit.dart --check` riêng.
  - Xử lý đúng: regenerate (không `--check`) tool bị stale, diff xem đúng
    là do file mình thêm (không lẫn nội dung của batch khác đang dở trong
    cùng worktree), rồi `--check` lại + rerun guardrail test — coi đây là
    hệ quả trong-scope của chính edit, không phải "phát hiện ngoài scope".

## Copy file số lượng lớn

- Glob `cp` rộng có thể ĐÈ file đã sửa; worktree thấy git HEAD cũ. Khi
  task yêu cầu "copy nguyên trạng", diff lại chuỗi dài sau copy — đừng
  tự nhận byte-for-byte khi chưa diff.

## Windows shell verify

- PowerShell trong Cursor Cloud win32 có thể không hỗ trợ `&&`; khi chain
  verify, dùng `; if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }` để tránh
  fail giả trước khi Dart/Flutter chạy.
- `flutter test ... | tail -n N` (chạy nền) che exit code thật — `$?` phản
  ánh `tail`, không phải `flutter test`; exit code 0 dù có test fail. Luôn
  grep NỘI DUNG log ("Some tests failed" / `[E]`) chứ đừng tin exit code khi
  có pipe. Compact reporter dùng `\r` dày đặc (ghi đè dòng), `\n` thưa —
  `tr '\r' '\n' < log > converted` trước khi Grep/Read log nền lớn (Read tool
  tự chặn file > 256KB kể cả có offset/limit).
- 2 lệnh `flutter test` (vd 1 targeted + 1 full-suite nền) chạy chồng nhau
  trên Windows từng để lại `dart.exe` treo, khiến lần chạy SAU đơ vô thời
  hạn ở đúng 1 test dù code không liên quan (lặp `tasklist //FI "IMAGENAME eq
  dart.exe"` — RAM giống hệt qua 2 lần đọc = treo thật, không phải chậm).
  Nếu diff giữa 2 lần chạy chỉ là artifact `docs/` (không đụng `lib/`/`test/`)
  mà lần chạy trước từng qua được đúng chỗ đó, gần như chắc là treo do
  resource, không phải bug: `taskkill //F //IM dart.exe` rồi chạy lại sạch
  trước khi nghi ngờ code.

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
