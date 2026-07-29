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

Chi tiết + lệnh: [branch-drift-risk.md](branch-drift-risk.md). Chỉ áp
dụng khi gate một feature branch; bỏ qua khi diff đang gate là
uncommitted changes trực tiếp trên `main`.

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

## "Stale artifact" có thể che một ratchet THẬT — đừng rubber-stamp

- Ít nhất 3 tool (`page_rhythm_audit.dart`, `card_tile_audit.dart`,
  `duplicate_private_widget_audit.dart`) cùng một shape: nhánh `--check`
  phát hiện CSV stale thì `return`/`exit(1)` NGAY — các điều kiện
  `--strict-full`/ratchet phía dưới (`_strictFullBlocks`,
  `duplicated.length > duplicateNameBaseline`) không bao giờ chạy tới.
  "Artifact is stale" (vô hại) và "vi phạm ratchet thật" (chặn merge)
  in ra GIỐNG HỆT nhau (exit 1, cùng gợi ý "chạy lại tool"). Đừng suy ra
  an toàn chỉ từ chữ "stale" trong message.
- Xác minh thật: copy file tool sang scratchpad (an toàn vì
  `_findAppRoot()` = `Directory.current`, không phải `Platform.script`
  — chạy `dart run <scratch-path>/x.dart --check ...` với CWD vẫn ở
  `flutter_app/` vẫn đọc đúng `lib/` thật), xoá riêng các `return;` sau
  `exitCode = 1;` trong nhánh stale (giữ `--check` trong args để không
  bao giờ chạm nhánh `else` ghi đè file thật), đọc xem message
  strict-full/ratchet có xuất hiện không. `git status` cuối cùng xác
  nhận repo thật không bị đụng.
- Bắt được thật bằng kỹ thuật này (SC-156 Profile tablet gate,
  2026-07-29): `duplicate_private_widget_audit.dart` báo "stale" y hệt
  8 tool khác cùng lượt gate, nhưng dry-run lộ
  `196 ten trung >= 3 file (baseline 195)` — FAIL THẬT (DEBT-86).
  `_duplicateMin=3`, baseline 195 đã ở đúng mức trần (0 headroom); PR
  thêm 1 file khai lại private class đã trùng 2 file từ trước, đẩy nó
  qua ngưỡng 3. Domain này KHÔNG có trong bảng §2 của
  Flutter-Design-System-Reference.md (doc gap thật, không phải lỗi PR).
- Shape khác an toàn hơn, khỏi cần dry-run: `top_header_visual_
  archetype_audit.dart` và `home_reference_consistency_audit.dart` gom
  hết failure vào 1 list rồi mới in — strict/module-gate check VẪN chạy
  dù đã stale, nên đọc TOÀN BỘ stderr (không chỉ dòng đầu): nếu message
  riêng của check đó vắng mặt, đã đủ chứng minh sạch. Đọc source quanh
  `if (checkOnly) {...}` để biết đang gặp shape nào trước khi kết luận.
- `top_header_behavior_audit.dart` không hề định nghĩa biến `strict` —
  cờ `--strict` CI/checklist truyền vào bị lờ hoàn toàn (no-op); tool
  này vốn đã là pure diff, khỏi cần dry-run.

## Checklist hand-typed từ agent gọi — luôn đối chiếu, đừng tin tay

- Một agent gọi tự nhận một "N-command block" là "checklist chuẩn đã
  dùng N batch trước" — đối chiếu với checklist doc +
  `.github/workflows/flutter-ci.yml` job `static` thật thì THIẾU
  `flutter pub get`, THIẾU HẲN bước codegen (`build_runner build
  --delete-conflicting-outputs` + `git diff --exit-code`), THIẾU HẲN
  `duplicate_private_widget_audit.dart --check`, và SAI cờ 2 lệnh
  (`back_navigation_behavior_audit`/`top_header_behavior_audit` cần
  `--check --strict`, list chỉ có `--check`). Message nào từ agent gọi
  cũng không phải bằng chứng đủ — luôn đọc checklist doc + CI YAML
  sống, kể cả khi message tự nhận "đã dùng nhiều lần trước".
