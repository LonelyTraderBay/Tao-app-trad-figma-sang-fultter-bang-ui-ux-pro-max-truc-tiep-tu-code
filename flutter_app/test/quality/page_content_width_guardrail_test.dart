import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('page content width audit artifacts are current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/page_content_width_audit.dart',
      '--check',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/page_content_width_audit.dart` from '
          'flutter_app/ and resolve any P0 double horizontal inset.',
    );
  });

  test('referral pilot routes are not P0 double inset offenders', () {
    final repoRoot = Directory.current.uri.resolve('../').toFilePath();
    final csvPath =
        '${repoRoot}docs/02_FLUTTER_MIGRATION/VitTrade-Page-Content-Width-Audit.csv';
    final csv = File(csvPath).readAsStringSync();
    const referralPaths = [
      'referral_history_page.dart',
      'referral_rules_page.dart',
      'referral_rewards_page_part_01.dart',
    ];

    for (final path in referralPaths) {
      final p0Row = RegExp(
        'referral,lib/features/referral/presentation/pages/$path,P0,double_horizontal_inset',
      );
      expect(p0Row.hasMatch(csv), isFalse, reason: 'P0 double inset for $path');
    }
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
    return '${cacheRoot}dart-sdk/bin/dart.exe';
  }

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null && flutterRoot.isNotEmpty) {
    return '$flutterRoot/bin/cache/dart-sdk/bin/dart.exe';
  }

  return 'dart';
}
