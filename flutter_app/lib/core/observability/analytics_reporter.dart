import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seam analytics duy nhất của app — GĐ4-F1, khuôn y hệt `ErrorReporter`.
///
/// [NoopAnalyticsReporter] là impl duy nhất trong giai đoạn mock — chưa emit
/// sự kiện nào. Khi chọn vendor analytics, thay impl sau
/// [analyticsReporterProvider]; không file nào khác phải đổi.
abstract interface class AnalyticsReporter {
  /// Ghi một sự kiện [event] kèm thuộc tính tùy chọn [properties].
  void track(String event, {Map<String, Object?> properties});
}

/// Impl rỗng mặc định trong giai đoạn chưa chọn vendor.
class NoopAnalyticsReporter implements AnalyticsReporter {
  /// Const để dùng được ở mọi ngữ cảnh (kể cả ngoài ProviderScope).
  const NoopAnalyticsReporter();

  @override
  void track(String event, {Map<String, Object?> properties = const {}}) {}
}

/// Seam DI cho code in-tree; vendor thật cắm vào đúng một chỗ này.
final analyticsReporterProvider = Provider<AnalyticsReporter>(
  (ref) => const NoopAnalyticsReporter(),
);
