import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/core/observability/error_reporter.dart';

void main() {
  test('NoopErrorReporter.report does not throw', () {
    expect(
      () => const NoopErrorReporter().report(
        StateError('sample'),
        StackTrace.current,
        context: 'unit test',
      ),
      returnsNormally,
    );
  });

  test('errorReporterProvider resolves to a NoopErrorReporter by default', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(errorReporterProvider), isA<NoopErrorReporter>());
  });
}
