import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// GĐ4 Cụm S (2026-07-18): nối tool DEBT-86 vào suite quality — trước đây
/// audit chỉ chạy ở CI job static, dev local chạy `flutter test` không được
/// canh (hai cổng có thể drift). Khuôn Process.runSync giống
/// back_navigation_behavior_guardrail_test.dart.
void main() {
  test('duplicate private widget audit artifact is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/duplicate_private_widget_audit.dart',
      '--check',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/duplicate_private_widget_audit.dart` from '
          'flutter_app/ — dedup private widget về lớp shared thay vì nhân '
          'bản (baseline chỉ được giảm, DEBT-86).',
    );
  });
}

String _dartExecutable() {
  final executable = Platform.resolvedExecutable;
  final normalized = executable.replaceAll('\\', '/');
  if (normalized.endsWith('/dart.exe') || normalized.endsWith('/dart')) {
    return executable;
  }

  const cacheMarker = '/flutter/bin/cache/';
  final cacheIndex = normalized.indexOf(cacheMarker);
  if (cacheIndex >= 0) {
    final cacheRoot = normalized.substring(0, cacheIndex + cacheMarker.length);
    return '${cacheRoot}dart-sdk/bin/'
        '${Platform.isWindows ? 'dart.exe' : 'dart'}';
  }

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null && flutterRoot.isNotEmpty) {
    return '$flutterRoot/bin/cache/dart-sdk/bin/'
        '${Platform.isWindows ? 'dart.exe' : 'dart'}';
  }

  return 'dart';
}
