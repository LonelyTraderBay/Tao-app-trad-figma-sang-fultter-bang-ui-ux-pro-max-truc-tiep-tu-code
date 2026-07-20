# MEMORY — flutter-domain-auditor

Gotchas tích lũy khi audit design-consistency VitTrade. Đọc kỹ trước khi
chạy audit; cập nhật khi phát hiện gotcha bền vững mới. Giữ file < 200 dòng.

## Audit tools — text matcher

- `tool/*_audit.dart` hardcode tên symbol dưới dạng chuỗi literal. Sau bất
  kỳ rename router class/function nào, grep `tool/` tìm tên CŨ — matcher
  cũ tạo PASS/FAIL giả mà không báo lỗi. (Nguồn: sự cố rename router 2026-07.)
- Ratchet đếm `Color(0x` tính cả `test/`, không chỉ `lib/` — đừng kết luận
  vi phạm chỉ nằm trong lib khi số đếm lệch.

## False positive đã biết

- Tiếng Việt không dấu ("mua nhanh", "vi tien"...) bị matcher ngôn ngữ
  nhận nhầm là tiếng Anh. Khi gặp FAIL i18n/copy trên chuỗi ASCII-only,
  kiểm tra thủ công trước khi báo vi phạm; đề xuất rephrase copy thay vì
  special-case matcher.

## Môi trường chạy lệnh

- Hook RTK rewrite lệnh shell: `grep -E` qua Bash có thể trả 0-match GIẢ.
  Không bao giờ kết luận "không có vi phạm" chỉ từ 0-match shell — xác
  minh lại bằng tool Grep/Read trước khi ghi PASS.
- Worktree Windows mới có thể checkout CRLF (khi nhánh chưa có
  `.gitattributes eol=lf`) → `dart format --set-exit-if-changed` FAIL giả
  toàn cục. Nếu format-FAIL nổ trên hàng loạt file không ai sửa, nghi CRLF
  trước khi nghi code.
