import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:vit_trade_flutter/core/observability/error_reporter.dart';

/// Một bản ghi lỗi đã đi qua [LocalLogErrorReporter].
class ErrorReport {
  /// Ghi lại một lỗi kèm ngữ cảnh và thời điểm.
  const ErrorReport({
    required this.error,
    required this.stack,
    required this.at,
    this.context,
  });

  /// Lỗi gốc.
  final Object error;

  /// Stack trace tại thời điểm lỗi.
  final StackTrace stack;

  /// Thời điểm báo lỗi.
  final DateTime at;

  /// Ngữ cảnh do đường báo lỗi cung cấp (vd `FlutterError.onError`).
  final String? context;
}

/// Impl mặc định GĐ4-F1 của [ErrorReporter]: ring-buffer cục bộ +
/// `debugPrint` có cấu trúc — theo quyết định "dựng seam trước, chọn vendor
/// crash-reporting sau". Khi vendor được chọn, chỉ cần thay thế tại
/// [errorReporterProvider] và chỗ khởi tạo bootstrap trong `main.dart`;
/// không file nào khác phải đổi.
class LocalLogErrorReporter implements ErrorReporter {
  /// [capacity] chặn trần bộ nhớ của ring-buffer.
  LocalLogErrorReporter({this.capacity = 100});

  /// Số bản ghi tối đa được giữ; bản ghi cũ nhất bị đẩy ra khi đầy.
  final int capacity;

  final ListQueue<ErrorReport> _reports = ListQueue<ErrorReport>();

  /// Ảnh chụp bất biến của các bản ghi hiện có (cũ nhất trước).
  List<ErrorReport> get reports => List.unmodifiable(_reports);

  @override
  void report(Object error, StackTrace stack, {String? context}) {
    while (_reports.length >= capacity) {
      _reports.removeFirst();
    }
    _reports.addLast(
      ErrorReport(
        error: error,
        stack: stack,
        at: DateTime.now(),
        context: context,
      ),
    );
    debugPrint('[VitTradeError] ${context ?? '-'} | $error');
  }
}
