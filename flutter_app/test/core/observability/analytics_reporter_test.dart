import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/core/observability/analytics_reporter.dart';

void main() {
  test('NoopAnalyticsReporter nuốt sự kiện không ném lỗi', () {
    const reporter = NoopAnalyticsReporter();
    reporter.track('su_kien_thu');
    reporter.track('su_kien_thu', properties: {'khoa': 1});
  });

  test('analyticsReporterProvider mặc định là Noop', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(
      container.read(analyticsReporterProvider),
      isA<NoopAnalyticsReporter>(),
    );
  });
}
