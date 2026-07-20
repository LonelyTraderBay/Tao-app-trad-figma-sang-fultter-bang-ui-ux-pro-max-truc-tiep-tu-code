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
