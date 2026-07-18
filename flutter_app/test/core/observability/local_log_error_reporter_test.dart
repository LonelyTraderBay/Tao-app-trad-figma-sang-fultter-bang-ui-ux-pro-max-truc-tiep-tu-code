import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/core/observability/local_log_error_reporter.dart';

void main() {
  test('ghi nhận lỗi kèm ngữ cảnh vào ring-buffer', () {
    final reporter = LocalLogErrorReporter();

    reporter.report(
      StateError('loi-thu-nhat'),
      StackTrace.current,
      context: 'unit-test',
    );

    expect(reporter.reports, hasLength(1));
    final report = reporter.reports.single;
    expect(report.error, isA<StateError>());
    expect(report.context, 'unit-test');
  });

  test('ring-buffer đẩy bản ghi cũ nhất khi vượt capacity', () {
    final reporter = LocalLogErrorReporter(capacity: 3);

    for (var i = 0; i < 5; i += 1) {
      reporter.report(StateError('loi-$i'), StackTrace.empty);
    }

    expect(reporter.reports, hasLength(3));
    expect(reporter.reports.map((r) => r.error.toString()).toList(), [
      'Bad state: loi-2',
      'Bad state: loi-3',
      'Bad state: loi-4',
    ]);
  });

  test('danh sách reports là ảnh chụp bất biến', () {
    final reporter = LocalLogErrorReporter();
    reporter.report(StateError('x'), StackTrace.empty);

    expect(() => reporter.reports.clear(), throwsUnsupportedError);
  });
}
