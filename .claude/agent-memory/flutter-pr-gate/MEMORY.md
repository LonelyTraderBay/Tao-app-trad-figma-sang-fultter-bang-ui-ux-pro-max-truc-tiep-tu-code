# MEMORY — flutter-pr-gate

Bài học tích lũy khi gate merge-readiness VitTrade. Đọc trước khi gate;
cập nhật khi chẩn đoán ra lớp lỗi mới. Giữ file < 200 dòng.

## CI-vs-local divergence

- CI chạy Linux, local là Windows: 10 lớp bug cross-OS đã gặp (path
  separator, case-sensitivity, CRLF, locale, timezone, glob order...).
  Khi CI đỏ mà local xanh, đọc RAW log CI qua
  `/commit/<sha>/checks/<jobid>/logs` thay vì đoán từ summary.
- Worktree Windows mới: nếu nhánh chưa có `.gitattributes eol=lf`,
  checkout CRLF làm `dart format --set-exit-if-changed` FAIL giả trên
  hàng loạt file — xác nhận nguyên nhân CRLF trước khi tuyên bố NOT READY.

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
