// Origin: SDD Task B1 (2026-07-25) — density audit allowlist ratchet
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// P0 routes for Wave B density polish (home reference + trust surfaces).
/// Keep in sync with `ui_density_p0_allowlist_baseline.txt`.
const _p0Routes = <String>[
  'AppRoutePaths.home',
  'AppRoutePaths.trade',
  'AppRoutePaths.markets',
  'AppRoutePaths.marketsOverview',
  'AppRoutePaths.wallet',
  'AppRoutePaths.walletWithdraw',
  'AppRoutePaths.p2p',
  'AppRoutePaths.profileSecurity',
];

void main() {
  test('P0 density allowlist does not regress past baseline max scores', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/ui_fullscreen_density_audit.dart',
      '--check-allowlist',
      '--baseline=test/quality/ui_density_p0_allowlist_baseline.txt',
      '--routes=${_p0Routes.join(',')}',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Fix P0 page density or update '
          'test/quality/ui_density_p0_allowlist_baseline.txt only when '
          'intentionally accepting a higher score.',
    );
  });

  test('P0 density allowlist baseline lists every required route', () {
    final baselineFile = File(
      'test/quality/ui_density_p0_allowlist_baseline.txt',
    );
    expect(baselineFile.existsSync(), isTrue);

    final listed = <String>{};
    for (final raw in baselineFile.readAsLinesSync()) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      listed.add(line.split(',').first.trim());
    }

    final missing = _p0Routes
        .where((route) => !listed.contains(route))
        .toList();
    expect(
      missing,
      isEmpty,
      reason:
          'Add missing P0 routes to '
          'ui_density_p0_allowlist_baseline.txt:\n${missing.join('\n')}',
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
