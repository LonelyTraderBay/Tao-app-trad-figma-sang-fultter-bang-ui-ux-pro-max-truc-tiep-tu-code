# Chính sách bảo mật

## Báo cáo lỗ hổng

Nếu bạn phát hiện lỗ hổng bảo mật trong VitTrade Flutter, vui lòng báo cáo
**riêng tư** qua [GitHub Security Advisories](https://docs.github.com/en/code-security/security-advisories)
của repository (tab **Security → Report a vulnerability**). Đừng mở issue công
khai cho lỗ hổng chưa được vá.

Vui lòng nêu: bước tái hiện, phạm vi ảnh hưởng, và phiên bản/commit liên quan.

## Trạng thái hiện tại

- App đang chạy trên **mock repository** — chưa kết nối backend thật, **không
  chứa khóa/bí mật sản phẩm thật**. Các chuỗi dạng khóa trong fixture là ví dụ
  tự khai (mẫu `*_VI_DU_KHONG_THAT_*`), được quét bởi guardrail
  `test/quality/secret_material_guardrail_test.dart` + job gitleaks trên CI.
- Khi tích hợp backend: đường ghi qua `lib/core/network/api_client.dart` (có
  điểm cắm auth-token + certificate pinning theo môi trường); token/khóa thật
  KHÔNG bao giờ commit vào repo.

## Phạm vi

Chính sách này áp dụng cho mã trong `flutter_app/` và hạ tầng CI trong
`.github/`.
