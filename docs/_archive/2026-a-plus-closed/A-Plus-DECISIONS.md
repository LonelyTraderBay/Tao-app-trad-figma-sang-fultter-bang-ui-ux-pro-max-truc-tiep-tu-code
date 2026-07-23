# A+ Roadmap — Quyết định cần người chốt (DECISION GATES)

> **Nguồn:** mục 13 của [VitTrade-Enterprise-Grade-Assessment-A-Plus-Roadmap.md](../VitTrade-Enterprise-Grade-Assessment-A-Plus-Roadmap.md).
> **Luật cho AI:** task trong `A-Plus-Task-Manifest.csv` có cột `decision_gate` trỏ vào một `DEC-*` dưới đây **không được thực thi** khi trạng thái còn `pending`. AI không được tự điền cột "Lựa chọn đã chốt". Khi người chốt xong: sửa Trạng thái → `decided`, điền Lựa chọn + ngày, rồi đổi `status` các task bị chặn từ `blocked` → `pending`.

| ID | Quyết định | Các phương án | Lựa chọn đã chốt | Trạng thái | Ngày chốt | Task bị chặn |
|---|---|---|---|---|---|---|
| **DEC-i18n** | Đường đi i18n — quyết định sản phẩm, ảnh hưởng lớn nhất tới điểm A+ (chiều 6 đang điểm D) | **A**: vi-VN-only có văn bản (ghi AGENTS.md + ratchet; effort S–M; chấp nhận trần điểm chiều 6 "có chủ đích") · **B**: đầu tư gen-l10n/.arb (nâng lên A; dự án Effort L; phải viết lại guardrail copy) | **Nhánh A — vi-VN-only có văn bản.** FMT-1 theo phương án (a): USD hiển thị en-US, số đếm/VND theo vi-VN, ép qua facade `VitFormat`. I18N-2 (Material delegates + locale `vi`) vẫn làm vì độc lập quyết định. Có thể nâng cấp lên gen-l10n sau khi backend ổn định — khi đó mở lại gate này. | `decided` | 2026-07-16 | Đã mở khoá: I18N-1, FMT-1, A11Y-4 |
| **DEC-backend** | Mốc thời gian backend thật về | Ngày cụ thể — dùng để khoá deadline Giai đoạn 2 (mọi task "Viết lại" GĐ2 phải xong **trước** mốc này) | **Chưa có lịch — GĐ2 làm ngay, không deadline cứng.** User chốt trong phiên re-plan GĐ2; cập nhật lại mốc khi có lịch backend (không đổi nội dung 19 task). | `decided` | 2026-07-17 | Đã mở khoá: lập lịch GĐ2 |
| **DEC-coverage** | Ngưỡng coverage khởi điểm | Đề xuất của báo cáo: floor **40%** + ratchet chỉ-cho-tăng (chọn thấp hơn số đo thực để không đỏ ngay) | **Theo đúng công thức của báo cáo:** floor khởi điểm = `min(40%, số đo thực lần đầu − 2 điểm đệm)`, ratchet chỉ-cho-tăng; loại `**/*.g.dart` + fixture mock khỏi mẫu số. CI-D3 điền số cụ thể sau lần đo đầu tiên. | `decided` | 2026-07-16 | Đã mở khoá: CI-D3 |
| **DEC-ios** | iOS có trong scope release không | **Có** (thêm job `flutter build ipa` trên macos-latest — cần runner macOS) · **Không/để sau** (chỉ Android) | **Để sau — chỉ Android.** CI-D6 làm trọn flavors dev/staging/prod + release workflow Android; job iOS ghi chú deferred trong workflow, mở lại khi có Apple developer account. Runner macOS tốn phút Actions ×10 Linux — không chi khi chưa xác nhận nhu cầu phát hành iOS. | `decided` | 2026-07-17 | Đã mở khoá: CI-D6 (trọn phần Android) |
| **DEC-codeowners** | Owner thật cho các file blast-radius cao | Ai gác `app_router.dart` + route constants · `trade_core` kernel · `earn/data` · `p2p/data`? (team/username GitHub thật). Nếu chưa có team thật → **xoá** CODEOWNERS để khỏi fail-open giả tạo | **Điền `@LonelyTraderBay` (chủ repo, contributor duy nhất — 43/43 commit) cho cả 4 vùng.** CODEOWNERS đóng vai bản đồ vùng nhạy cảm + tự request review khi có thành viên mới. **KHÔNG bật "Require review from Code Owners"** khi repo còn solo (GitHub không cho tự approve PR của mình → sẽ tự khoá merge); branch protection chỉ require status checks. Mở lại quyết định khi có maintainer thứ 2. | `decided` | 2026-07-16 | Đã mở khoá: CI-D5 |

## Căn cứ các quyết định đã chốt (2026-07-16, user uỷ quyền cho AI chốt trong phiên làm việc)

- **DEC-i18n → Nhánh A** vì: (1) 100% copy hiện tại là tiếng Việt inline (~10.4k dòng / 1.074 file) và sản phẩm nhắm thị trường Việt; (2) nhánh B đòi viết lại toàn bộ hệ guardrail copy (đang khoá literal vào source) đúng giữa giai đoạn cần dồn lực đóng "vách đá nợ mock-phase" trước backend — sai thứ tự ưu tiên; (3) nhánh A vẫn đạt chuẩn A+ "có chủ đích" của báo cáo (quyết định thành văn bản + ratchet), và không đóng cửa nâng cấp gen-l10n sau này.
- **DEC-codeowners → @LonelyTraderBay** vì bằng chứng git: remote là repo cá nhân `github.com/LonelyTraderBay/...`, toàn bộ 43 commit của đúng 1 tác giả — không tồn tại team để gán. Giữ file làm bản đồ vùng blast-radius (giá trị tài liệu + tự động hoá tương lai) thay vì xoá; enforcement thật nằm ở required status checks.
- **DEC-coverage → công thức của chính báo cáo** (floor 40% có đệm theo số đo thực, ratchet chỉ-cho-tăng) — đây là đề xuất đã ghi trong §13.3, không có lý do làm khác.

## Còn chờ user (không chặn việc bắt đầu)

1. **DEC-backend** — mốc lịch backend thật: chỉ user biết; dùng để khoá deadline GĐ2.
2. **DEC-ios** — cần xác nhận có Apple developer account / nhu cầu phát hành iOS; phần Android của CI-D6 làm được trước.
3. Toàn bộ GĐ0 + GĐ1 thực thi được ngay hôm nay, không chờ 2 mục trên.
