# ADR-004 — Đường dẫn canonical (Flutter-only)

- **Trạng thái:** Đã chốt (DOC-D3 · dọn Flutter-only, 2026-05-26 trở đi)
- **Phạm vi:** vị trí mã nguồn, artifact sinh ra, và tài liệu tham chiếu đường dẫn
- **Implementation tham chiếu:** `docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md`, `flutter_app/`

## Bối cảnh

Repo từng chứa cả app React/Vite tham chiếu + web baseline sinh ra bên cạnh app
Flutter. Hai cây song song gây nhập nhằng: tài liệu trỏ nhầm, artifact sinh vào
sai chỗ, và người mới không biết đâu là nguồn sự thật đang chạy.

## Quyết định

1. **`flutter_app/` là app duy nhất đang hoạt động.** App React/Vite và web
   baseline đã xóa (2026-05-26); cấm tái lập tooling npm/Vite ở root.
2. **Đường dẫn canonical, forward-slash, repo-relative** trong mọi artifact và
   tài liệu — không hardcode đường dẫn tuyệt đối máy dev (là một trong các lớp
   bug cross-OS đã gặp).
3. **Artifact sinh ra đi vào `flutter_app/run-artifacts/`**; audit report vào
   `docs/02_FLUTTER_MIGRATION/audits/`.

## Hệ quả / nợ còn lại

- Mọi tool audit chuẩn hóa `\` → `/` trước khi ghi/sort artifact (xem
  `feedback_cross_os_ci_nondeterminism`).
- Tài liệu tham chiếu file phải dùng đường dẫn dưới `flutter_app/` — quy ước này
  là nền cho các guardrail so-byte cross-OS ở ADR-003.
