// Origin: 70c67af6 (2026-07-17) - refactor: nâng cấp nền tảng VitTrade Flutter theo lộ trình enterprise A+
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every feature repository provider goes through guardedRepository', () {
    // dev/ and enterprise_states/ are developer/demo scaffolding, not
    // user-facing product features — see ERR-33 in
    // docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
    // Add a new entry here (with a reason) rather than letting a real
    // feature provider skip the guard silently.
    const allowlist = {
      'lib/features/dev/data/providers/dev_tools_repository_provider.dart',
      'lib/features/enterprise_states/data/providers/enterprise_states_repository_provider.dart',
    };

    final providerFiles = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) => file.path
              .replaceAll('\\', '/')
              .endsWith('_repository_provider.dart'),
        );

    final unguarded = <String>[];
    for (final file in providerFiles) {
      final path = file.path.replaceAll('\\', '/');
      if (allowlist.contains(path)) continue;
      if (!file.readAsStringSync().contains('guardedRepository')) {
        unguarded.add(path);
      }
    }

    expect(
      unguarded,
      isEmpty,
      reason:
          'These repository providers bypass guardedRepository, so a '
          'production build (enableMockData=false) would silently keep '
          'serving mock data instead of failing closed: $unguarded',
    );
  });

  test(
    'P0 repository providers fail closed without invented remote backends',
    () {
      // Production-critical domains — must not silent-fallback to mock when
      // enableMockData=false and no real remote: backend is wired yet.
      const p0Providers = [
        'lib/features/auth/data/providers/auth_repository_provider.dart',
        'lib/features/wallet/data/providers/wallet_repository_provider.dart',
        'lib/features/trade/data/providers/trade_repository_provider.dart',
        'lib/features/p2p_core/data/providers/p2p_repository_provider.dart',
        'lib/features/markets/data/providers/market_repository_provider.dart',
        'lib/features/profile/data/providers/profile_repository_provider.dart',
      ];

      final violations = <String>[];
      for (final path in p0Providers) {
        final file = File(path);
        if (!file.existsSync()) {
          violations.add('$path: file missing');
          continue;
        }
        final source = file.readAsStringSync();
        if (!source.contains('guardedRepository')) {
          violations.add('$path: missing guardedRepository');
        }
        if (!source.contains('failClosed:')) {
          violations.add('$path: missing failClosed:');
        }
        if (source.contains('remote:')) {
          violations.add(
            '$path: must not pass remote: until a real backend exists',
          );
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'P0 providers must use guardedRepository + failClosed and must '
            'not wire an invented remote: backend:\n${violations.join('\n')}',
      );
    },
  );
}
