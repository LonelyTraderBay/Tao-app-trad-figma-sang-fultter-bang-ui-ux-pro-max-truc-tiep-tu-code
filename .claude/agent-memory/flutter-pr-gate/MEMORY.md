# MEMORY — flutter-pr-gate

Bài học tích lũy khi gate merge-readiness VitTrade. Đọc trước khi gate;
cập nhật khi chẩn đoán ra lớp lỗi mới. Giữ file < 200 dòng.

## CI-vs-local divergence

- CI chạy Linux, local là Windows: 10 lớp bug cross-OS đã gặp (path
  separator, case-sensitivity, CRLF, locale, timezone, glob order...).
  Khi CI đỏ mà local xanh, đọc RAW log CI qua
  `/commit/<sha>/checks/<jobid>/logs` thay vì đoán từ summary.
- Phạm vi "FAIL giả do CRLF" HẸP hơn ta tưởng. Đo lại 2026-07-27 trên
  main @ c1ba14ba, Windows `core.autocrlf=true`: source `.dart` dưới
  `lib/`+`test/` ĐÚNG là checkout CRLF (xác minh `app_router.dart`,
  74/74 dòng), NHƯNG `dart format --output=none --set-exit-if-changed .`
  vẫn SẠCH (3015 file, 0 changed) — formatter Dart chuẩn hoá CRLF, không
  báo diff. Lý do: `.gitattributes` gốc chỉ ép `text eol=lf` cho hai
  đường dẫn hẹp (`docs/02_FLUTTER_MIGRATION/audits/**/*.{csv,md}` và
  `Flutter-Route-Coverage-Truth-Table.md`), vì test artifact-currency so
  sánh CHUỖI THÔ giữa artifact đã commit và output tool sinh lại — chỗ đó
  CRLF-vs-LF là diff byte dù nội dung y hệt. Cơ chế đó KHÔNG lan sang
  `dart format` hay guardrail thường.
  ⇒ Chỉ nghi CRLF khi thứ đang fail là test artifact-currency
  string-compare thuộc hai đường dẫn trên. Mọi FAIL khác: coi là THẬT,
  điều tra bình thường, đừng đổ cho CRLF rồi bỏ qua.
- Golden test trên máy Windows này CHẠY THẬT, không skip. CI tách
  pixel-compare ra job riêng `golden-windows` (`runs-on: windows-latest`)
  vì baseline PNG rasterize font Be Vietnam Pro khác trên Linux; cùng file
  test đó chạy trong job `guardrails` trên `ubuntu-latest` thì tự skip qua
  guard `!Platform.isWindows`. Máy dev/gate này là win32 ⇒ khi chạy sweep
  `flutter test test/quality test/app/router
  test/features/{home,trade,wallet,p2p_core,earn_core}/golden` thì golden
  thực sự so pixel (xác nhận 2026-07-27: "golden: Home/Trade/Wallet/P2P/
  Earn data state" đều chạy & pass trong 281/281).
  ⇒ Đừng báo golden là "chưa verify local" hay đề nghị chờ CI golden
  riêng khi gate từ máy này. Ngược lại, trên sandbox Linux chúng skip im
  lặng (exit 0, 0 executed) — lúc đó PHẢI nói rõ khác biệt.

## Lớp fail thường gặp sau async migration

- Zero-timer với FakeAsync; shell-watch cần `Duration.zero`; haptic phải
  `unawaited(...)`; literal fallback trong stream; `async*` bị cancel giữa
  chừng. Test đỏ dạng timeout/pending-timer sau thay đổi async → soi các
  bẫy này trước.

## Blast radius widget dùng chung

- Thay đổi footprint/kích thước của một `Vit*` primitive dùng chung phá
  golden + offset-tap toàn app. Nếu diff đụng shared primitive, yêu cầu
  bằng chứng chạy FULL suite — pass test riêng của widget đó chưa đủ.
  `FittedBox` làm `tester.getSize(find.text())` vô nghĩa.

## Kỷ luật kiểm chứng

- Không tin 0-match từ lệnh shell (hook RTK rewrite có thể tạo kết quả
  giả) — xác minh bằng tool Grep/Read trước khi tick một mục checklist.
- Không tin subagent tự nhận "copy byte-for-byte" — diff corpus chuỗi dài
  trước khi tick mục fidelity.
- KHÔNG tin `$?` sau lệnh có pipe (`dart run tool/x.dart | tail -N; echo
  $?`) — đó là exit code của `tail`, không phải của `dart`. Luôn redirect
  ra file/`> out.txt 2>&1` rồi `echo $?` riêng, hoặc đọc chuỗi
  success/fail tường minh mà tool tự in ra (vd "...artifact is current."
  vs "...artifact is stale. Run `dart run tool/X.dart`...").

## "Full test suite xanh" KHÔNG đủ để suy ra CI static-job xanh

- `flutter test` (kể cả `test/quality/`) KHÔNG chạy các audit tool đứng
  độc lập trong CI job "static" (`dart run tool/*_audit.dart --check`).
  Ít nhất 2 audit — `navigation_edge_audit` (artifact
  `VitTrade-Screen-Navigation-Edges.csv`) và `page_rhythm_screen_rollup`
  (artifact `VitTrade-Page-Rhythm-Screen-Compliance.csv` +
  `Page-Rhythm-Compliance-Report.md`) — hiện KHÔNG có guardrail test nào
  trong `test/quality/` bọc lại (đã verify bằng Grep, 0 file match tên
  artifact/tool). Vậy "full suite 3499/3499 xanh" của user KHÔNG chứng
  minh 2 audit này xanh — phải tự chạy `--check` cho toàn bộ danh sách
  static-job trong `.github/workflows/flutter-ci.yml`, không suy luận từ
  kết quả `flutter test`.
- Trigger thực tế đã gặp: xoá một file widget con (vd
  `launchpad_rebalance_confirm_sheet.dart`, thay bằng
  `showVitConfirmDialog`/`VitPreviewConfirmSheet` dùng chung) làm lệch
  danh sách "widget files" mà rollup CSV chốt cứng theo route — audit
  FAIL dù `flutter analyze`/`flutter test` đều xanh. Luôn chạy trọn bộ
  audit `--check` list (đọc trực tiếp từ `.github/workflows/flutter-ci.yml`
  job `static`, KHÔNG chỉ list rút gọn trong
  `Enterprise-PR-Review-Checklist.md`) sau bất kỳ lần xoá/đổi tên file
  presentation/widget nào.
- CON SỐ cụ thể (2026-07-27, c1ba14ba): job `static` chạy **23** lệnh
  `dart run tool/*_audit.dart --check`. Mục "Required Commands" của
  `Enterprise-PR-Review-Checklist.md` chỉ liệt kê **2** (`route_coverage_audit`,
  `navigation_edge_audit`) + vài block có điều kiện (design-token,
  home-reference, page-rhythm, card-tile, segment-pill) gate theo file đã
  đổi. Checklist viết cho scope PR-diff (chỉ chạy block khớp file chạm
  vào) — hợp lý cho PR, SAI cho gate toàn repo.
- ⇒ Khi task là "gate cả repo / main HEAD" (KHÔNG có PR diff để scope),
  mọi audit đều trong scope: lấy trọn danh sách `--check` thẳng từ các
  step của job `static` trong YAML, đừng lấy từ checklist doc. Bỏ sót
  ~15 lệnh còn lại (top-header-behavior/action/global-access-policy/
  visual-archetype, back-navigation-behavior, home-entry-back-navigation,
  duplicate-private-widget, spacing-token-duplication, page-content-width,
  page-rhythm-coverage-matrix, segment-pill-manifest, card-tile-manifest)
  là âm thầm bỏ qua cổng CI thật.
- Hai job KHÔNG tái lập được từ gate read-only trên máy này:
  `build-android` (cần Android SDK build) và `secret-scan` (cần binary
  gitleaks). Báo rõ "not-checked-here" thay vì lặng lẽ bỏ qua.

## Branch lệch main = rủi ro merge-conflict không thấy qua CI riêng nhánh

- Trước khi kết luận READY, chạy `git log HEAD..main --oneline` để biết
  main đã tiến xa hơn merge-base bao nhiêu commit, rồi
  `git show --stat <commit>` từng commit đó để lấy danh sách file. Nếu
  file trùng với file nhánh đang sửa → rủi ro conflict thật khi mở PR/
  rebase, dù CI trên HEAD hiện tại của nhánh đang xanh (CI nhánh không
  biết main đã đổi). Báo cáo rủi ro này tường minh, đừng chỉ dựa
  `git diff main...HEAD` (three-dot, đúng cho scope PR) mà quên check
  `HEAD..main` (số commit main đã vượt lên).
- Lưu ý phụ: `git diff main` (two-dot, so thẳng working tree với main
  TIP) sẽ lẫn cả những gì main đã đổi mà nhánh chưa có — trông như nhánh
  "xoá code" nhưng thực ra là nhánh thiếu commit mới của main. Luôn dùng
  `git diff <merge-base>` hoặc `git diff main...HEAD` (three-dot) để lấy
  đúng scope diff của PR, không dùng two-dot khi main đã tiến xa hơn.

## Doc–code drift đã gặp

- `Enterprise-PR-Review-Checklist.md` liệt kê
  `test/quality/architecture_baseline_guardrails_test.dart` nhưng file này
  đã tách thành 3 file (`architecture_import_debt_guardrails_test.dart`,
  `architecture_layer_boundary_guardrails_test.dart`,
  `architecture_size_style_debt_guardrails_test.dart`) + 1 file dùng chung
  `_test_utils.dart`. Code/test thắng theo DOCUMENT_PRECEDENCE — chạy cả 3
  file thay tên cũ, ghi chú doc cần cập nhật, đừng block merge vì tên cũ.
  Xác nhận lại 2026-07-27 @ c1ba14ba: tên cũ vẫn còn trong checklist, file
  vẫn không tồn tại; chỉ còn
  `architecture_baseline_guardrails_test_utils.dart` (helper dùng chung,
  KHÔNG có test riêng — gõ tên nó sẽ chạy 0 test và "xanh" giả).
- BÀI HỌC TỔNG QUÁT: đừng gõ tay từng tên file test lấy từ doc. Chạy quét
  cả thư mục `flutter test test/quality` (đúng pattern job `guardrails`
  của CI) — nó tự bao phủ mọi lần đổi tên/tách file như ca trên, và không
  bao giờ "xanh" vì chạy nhầm 0 test.

## Baseline xanh đã biết — main @ c1ba14ba (2026-07-27)

Một lượt gate TOÀN BỘ main HEAD đã chạy trọn và xanh hết:

| Cổng | Kết quả |
| --- | --- |
| `dart format --set-exit-if-changed .` | sạch (3015 file, 0 changed) |
| 23 audit job `static` (`--check`) | 23/23 PASS |
| `flutter analyze` | 0 issue |
| `build_runner` codegen | zero diff |
| Sweep job `guardrails` (test/quality + test/app/router + 5 thư mục golden) | 281/281 pass |
| `flutter test --reporter=compact` (full, unsharded) | 3574/3574 pass, ~2.5 phút |
| `build-android`, `secret-scan` | KHÔNG kiểm được từ máy này |

Dùng mấy con số này làm **tín hiệu drift** cho lần gate sau: nếu tổng số
test tụt mạnh mà không giải thích được, nhiều khả năng là một suite
KHÔNG LOAD ĐƯỢC (lỗi import/compile làm cả file bị bỏ qua), chứ không
phải ai đó xoá bớt test. Đếm test tụt = nghi ngờ trước, đừng mừng vì
"vẫn xanh".
