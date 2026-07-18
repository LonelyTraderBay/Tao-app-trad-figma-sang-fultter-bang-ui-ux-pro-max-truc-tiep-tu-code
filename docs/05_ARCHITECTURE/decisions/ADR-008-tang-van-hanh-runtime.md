# ADR-008 — Tầng vận hành runtime: seam-trước-vendor-sau, persistence hai tầng, kill-switch

- **Trạng thái:** Đã chốt (GĐ4 Cụm F1, 2026-07-18 — theo quyết định user: crash reporting "chỉ dựng seam, chọn vendor sau"; persistence "shared_preferences + flutter_secure_storage")
- **Phạm vi:** lưu trữ cục bộ, báo lỗi/analytics, phiên đăng nhập, cổng bảo trì/ép cập nhật
- **Implementation tham chiếu:** `lib/core/storage/` (KeyValueStore/SecureStore), `lib/core/observability/` (LocalLogErrorReporter/AnalyticsReporter), `lib/main.dart` (bootstrap hợp nhất), `runtime_seams_guardrail_test.dart`

## Bối cảnh

Đánh giá Enterprise (2026-07-18) chỉ ra: 0 persistence (AuthSession bốc hơi sau
login, watchlist/settings mất khi restart), ops runtime toàn Noop, và HAI
instance ErrorReporter song song trong main.dart. Backend chưa ký contract
(DEC-backend chưa chạy) và vendor crash-reporting chưa chọn — nhưng để mọi
tầng trên viết đúng NGAY BÂY GIỜ, chỗ cắm phải tồn tại trước.

## Quyết định

1. **Persistence hai tầng, đi qua seam — không bao giờ import package thô**:
   `KeyValueStore` (shared_preferences — dữ liệu thường: watchlist, cờ
   onboarding, settings) và `SecureStore` (flutter_secure_storage —
   token/phiên). Chỉ `lib/core/storage/` (+ `main.dart` bootstrap) được import
   hai package này; guardrail `runtime_seams` cấm phần còn lại. Khóa lưu trữ
   khai tập trung tại `KeyValueStoreKeys`/`SecureStoreKeys` — một chỗ thấy
   toàn bộ bề mặt lưu trữ.
2. **Mặc định-trong-container = in-memory; mặc định-trong-app = impl thật**:
   provider mặc định trả `InMemory*` để 3.4k+ test hermetic không chạm
   đĩa/plugin; `main.dart` override bằng impl thật qua `ProviderScope
   overrides` (SharedPreferences được `await` TRƯỚC `runApp` nên mọi phép đọc
   trong app là đồng bộ). Test muốn dữ liệu có sẵn thì seed `InMemory*(seed:)`.
3. **Crash reporting: seam trước, vendor sau** (quyết định user):
   `LocalLogErrorReporter` (ring-buffer + debugPrint có cấu trúc) là impl
   chạy thật hiện tại; `main.dart` dùng MỘT instance duy nhất cho cả ba
   đường lỗi ngoài cây widget VÀ override `errorReporterProvider` — hợp nhất
   hai đường report song song trước đây. Khi chọn Crashlytics/Sentry: thay
   đúng một chỗ khởi tạo trong `main.dart`. `AnalyticsReporter` cùng khuôn
   (Noop cho tới khi chọn vendor).
4. **Kill-switch/ép cập nhật compile-time trước, remote sau**: `AppConfig`
   thêm `maintenanceMode`/`minSupportedBuild`/`buildNumber` (dart-define);
   redirect toàn cục của router đẩy về `MaintenanceGatePage`/
   `ForceUpdateGatePage` khi cờ bật. `RuntimeConfigSource` là chỗ cắm remote
   config sau DEC-backend — impl hiện tại trả nguyên dart-define.
5. **Phiên đăng nhập sống trong `authSessionControllerProvider`** (Notifier
   không autoDispose): login ghi SecureStore, khởi động restore lại, logout
   xóa; `AuthTokenProvider` của ApiClient đọc token từ SecureStore (SEC-S46
   bật một nửa — token demo, backend thật chỉ đổi giá trị token).

## Hệ quả / nợ còn lại

- Vendor crash-reporting/analytics chưa chọn — ring-buffer chỉ sống trong
  RAM phiên chạy; chấp nhận cho giai đoạn mock, LƯU Ý không tuyên bố "đã có
  crash reporting" trong tài liệu sản phẩm.
- Remote kill-switch cần backend — hiện cờ chỉ đổi được theo bản build.
- Settings/watchlist persist theo thiết bị, chưa theo tài khoản — đồng bộ
  server là việc của DEC-backend.
- Token demo không phải JWT thật; mọi flow bảo mật thật (refresh, hết hạn)
  chờ contract ký.
