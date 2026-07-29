# MEMORY — flutter-batch-builder

Bẫy tích lũy khi implement batch VitTrade. Đọc trước khi sửa file; cập
nhật sau khi batch xanh nếu có bài học mới. Giữ file < 200 dòng — chi tiết
đặc thù 1 series batch chuyển sang topic file cùng thư mục.

## MEMORY.md này nằm ở REPO ROOT, không phải flutter_app/

- Đường dẫn generic trong system prompt của agent runtime (dạng
  `flutter_app/.claude/agent-memory/flutter-batch-builder/`) từng SAI cho
  project này (Home batch 3/6, 2026-07-29): file thật, đã có nội dung tích
  luỹ nhiều batch trước, nằm ở REPO ROOT —
  `.claude/agent-memory/flutter-batch-builder/MEMORY.md` (đúng quy ước nêu
  trong root `CLAUDE.md`). Trước khi tin "MEMORY.md rỗng", `Glob
  **/agent-memory/flutter-batch-builder/*` từ repo root để xác nhận vị trí
  thật — đọc nhầm file rỗng ở path sai nghĩa là bỏ lỡ toàn bộ bài học các
  batch trước để lại.
- Tái xác nhận ở Trade (batch 4/6) và Profile (batch 5/6): đừng suy ra
  "system prompt khẳng định path flutter_app/... đã tồn tại sẵn" nghĩa là
  khỏi Glob xác minh — khẳng định đó sai cho project này 3 lần liên tiếp,
  chỉ path repo-root là đúng.

## Widget dùng chung — blast radius

- Tăng footprint (padding/size/constraint) của một `Vit*` primitive dùng
  chung phá golden + tap-theo-offset ở màn KHÁC. Trước khi sửa shared
  primitive: chạy `tokensave_impact`; sau khi sửa: chạy FULL suite, không
  chỉ test của widget đó. `FittedBox` làm `tester.getSize(find.text())`
  trả kích thước sai — đừng assert size text qua FittedBox.

## Dedup / formatter

- Dedup shared formatter từng ĐỔI NGẦM copy tiền tệ (sự cố VitFormat
  440dcb06): khi gom formatter trùng lặp, corpus-diff toàn bộ chuỗi output
  trước/sau trên tập input thật, đừng chỉ so chữ ký hàm.

## Async — bẫy đã trả giá

- FakeAsync với zero-timer treo test; shell-watch cần `Duration.zero`;
  haptic gọi `unawaited(...)`; đừng để literal fallback che stream lỗi;
  `async*` bị cancel giữa chừng nuốt cleanup. Gặp timeout/pending-timer sau
  thay đổi async → soi các bẫy này trước khi debug sâu.

## Rename & audit tool

- Sau khi rename class/function router: grep `tool/` tìm tên cũ —
  `tool/*_audit.dart` hardcode symbol name dạng chuỗi, rename xong audit vẫn
  xanh giả.
- Tên guardrail trong docs/rules có thể lệch so với file thật: checkout
  2026-07-22 dùng `test/quality/page_rhythm_audit_sync_guardrail_test.dart`,
  không có `page_rhythm_guardrail_test.dart`; Glob test trước khi kết luận
  thiếu.

## Trích shared widget khỏi nhiều page → audit tool fan-out ngoài verify list

Chi tiết đầy đủ (4 tool hay stale + case cụ thể từng batch, bất biến
financial/UI giữ nguyên qua swap, chuyện nhiều batch-builder chạy song song
1 working tree): `tablet-dashboard-extraction.md` trong cùng thư mục. Tóm
tắt: khi trích 1 block lặp lại (VitCard/VitPageContent/token) ra 1 shared
widget dùng ở NHIỀU page, full suite luôn là bước bắt buộc — ít nhất
`card_tile_manifest.dart`, `design_token_consistency_audit.dart`,
`navigation_edge_audit.dart`, `back_navigation_behavior_audit.dart` có thể
stale mà không tool nào trong số đó nằm sẵn trong checklist verify của
task; đôi khi nguyên nhân stale là 1 batch KHÁC chạy song song, không phải
edit của chính mình — vẫn phải tự regenerate cho full suite xanh, nhưng ghi
đúng nguyên nhân khi báo cáo.

## Copy file số lượng lớn

- Glob `cp` rộng có thể ĐÈ file đã sửa; worktree thấy git HEAD cũ. Khi task
  yêu cầu "copy nguyên trạng", diff lại chuỗi dài sau copy — đừng tự nhận
  byte-for-byte khi chưa diff.

## Windows shell verify

- PowerShell trong Cursor Cloud win32 có thể không hỗ trợ `&&`; khi chain
  verify, dùng `; if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }` để tránh
  fail giả trước khi Dart/Flutter chạy.
- `flutter test ... | tee log` / `| tail -n N` (chạy nền) che exit code
  thật — `$?` phản ánh lệnh CUỐI của pipe (`tee`/`tail`/`echo`), không phải
  `flutter test`; exit code 0 dù có test fail (tái xác nhận Profile
  batch 5/6: đúng 1 fail thật giữa 3613 test, `$?` sau pipe vẫn báo 0). Ưu
  tiên `>` redirect thẳng (không pipe) khi chạy nền để exit code còn ý
  nghĩa; dù vậy vẫn LUÔN grep NỘI DUNG log ("Some tests failed" / `[E]`)
  chứ đừng chỉ tin exit code. Compact reporter dùng `\r` dày đặc (ghi đè
  dòng), `\n` thưa — `tr '\r' '\n' < log > converted` trước khi Grep/Read
  log nền lớn (Read tool tự chặn file > 256KB kể cả có offset/limit).
- 2 lệnh `flutter test` chạy chồng nhau trên Windows từng để lại `dart.exe`
  treo, khiến lần chạy SAU đơ vô thời hạn ở đúng 1 test dù code không liên
  quan. Đừng khởi 1 `flutter test`/`dart run` MỚI khi 1 lệnh nền
  (`run_in_background`) vẫn đang chạy — đợi nó xong (grep log định kỳ,
  không sleep-loop) rồi mới chạy lệnh tiếp theo.

## gitStatus snapshot đầu phiên có thể đã cũ

- Snapshot git ở đầu conversation là ảnh chụp CỐ ĐỊNH, không tự cập nhật.
  Nếu thấy file NGOÀI scope batch hiện "M" trong snapshot đó nhưng task
  không nhắc tới, đừng vội nghi ngờ contamination hoặc cố "dọn" nó — chạy
  lại `git status`/`git diff --stat` NGAY khi bắt đầu sửa; nhiều khả năng
  batch khác (kể cả đang chạy SONG SONG trong cùng tree, xem
  `tablet-dashboard-extraction.md`) đã/đang commit hoặc sửa file đó.
- Bẫy KHÁC: `git diff`/`git log -- <path>` có thể trả về RỖNG SAI khi cwd
  thực tế là `flutter_app/` mà pathspec lại viết kiểu repo-root (hoặc
  ngược lại) — nghi do RTK proxy cộng cwd subdirectory. Muốn kết quả tin
  được: `cd` (hoặc `git -C`) tới repo root TUYỆT ĐỐI rồi dùng path tương
  đối repo-root nhất quán cho MỌI lệnh git trong phiên — đã có lúc 3 file
  khác nhau đều báo rỗng sai kiểu này liền trong 1 phiên. Bẫy tương tự với
  `Glob`/`Read`: không truyền path tuyệt đối thì ngầm dùng cwd hiện tại làm
  root — gọi `docs/...` (repo-root-relative) từ session có cwd
  `flutter_app/` báo "No files found" sai; luôn tự prefix path tuyệt đối
  khi không chắc cwd nào đang active (tái xác nhận Profile batch 5/6).

## Tablet-Adaptive batch (R1-R9)

Chi tiết implementation (nested state switch trong provider,
`use_build_context_synchronously` sau `await` trong method phụ của State)
và bất biến financial/UI giữ nguyên qua swap sang shared widget:
`tablet-dashboard-extraction.md`.

## Copy tiếng Việt — encoding lệch trong cùng 1 file

- Cùng 1 file Dart (vd `profile_page.dart`) có thể trộn chuỗi tiếng Việt
  literal UTF-8 VÀ chuỗi escape `\uXXXX` cho các string KHÁC NHAU. So chuỗi
  thô sẽ báo lệch giả dù nội dung giống hệt — decode `\uXXXX` → ký tự thật
  bằng script rồi mới so khớp, đừng so chuỗi thô hoặc eyeball dấu tiếng
  Việt.
