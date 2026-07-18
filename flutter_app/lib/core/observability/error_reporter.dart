import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Single seam every uncaught-error path in the app reports through.
///
/// GĐ4-F1: app thật chạy `LocalLogErrorReporter` (ring-buffer + debugPrint,
/// xem local_log_error_reporter.dart) — bootstrap trong `main.dart` override
/// [errorReporterProvider] bằng CÙNG MỘT instance dùng cho cả ba đường lỗi
/// ngoài cây widget. Mặc định trong container vẫn là [NoopErrorReporter] để
/// 3.4k+ test giữ im lặng và hermetic. Khi chọn vendor Crashlytics/Sentry,
/// chỉ thay impl ở hai chỗ đó; không file nào khác phải đổi (ADR-008).
abstract interface class ErrorReporter {
  void report(Object error, StackTrace stack, {String? context});
}

class NoopErrorReporter implements ErrorReporter {
  const NoopErrorReporter();

  @override
  void report(Object error, StackTrace stack, {String? context}) {}
}

final errorReporterProvider = Provider<ErrorReporter>(
  (ref) => const NoopErrorReporter(),
);
