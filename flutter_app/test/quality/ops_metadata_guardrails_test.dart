import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ops metadata guardrails', () {
    test(
      'app metadata uses VitTrade branding instead of Flutter template text',
      () {
        final readme = _read('README.md');
        expect(readme, contains('VitTrade Flutter'));
        expect(readme, isNot(contains('A new Flutter project')));

        final manifest = jsonDecode(_read('web/manifest.json')) as Map;
        expect(manifest['name'], 'VitTrade');
        expect(manifest['short_name'], 'VitTrade');
        expect(manifest['description'], contains('Enterprise crypto trading'));
        expect(manifest['theme_color'], '#E58A00');
        expect(manifest['background_color'], '#07090D');

        final index = _read('web/index.html');
        expect(index, contains('<title>VitTrade</title>'));
        expect(
          index,
          contains('apple-mobile-web-app-title" content="VitTrade"'),
        );
        expect(index, contains('theme-color" content="#E58A00"'));
        expect(index, isNot(contains('A new Flutter project')));

        final androidManifest = _read(
          'android/app/src/main/AndroidManifest.xml',
        );
        expect(androidManifest, contains('android:label="VitTrade"'));
        expect(
          androidManifest,
          isNot(contains('android:label="vit_trade_flutter"')),
        );
      },
    );

    test('developer-facing sample snippets avoid direct print logging', () {
      final sampleFiles = [
        'lib/features/trade_terminal/data/repositories/mock_trade_terminal_repository.dart',
        'lib/features/earn/data/repositories/mock_earn_repository.dart',
      ];

      for (final path in sampleFiles) {
        final source = _read(path);
        expect(RegExp(r'\bprint\(').allMatches(source), isEmpty, reason: path);
        expect(
          RegExp(r'\bconsole\.log\(').allMatches(source),
          isEmpty,
          reason: path,
        );
      }
    });

    test('docs/INDEX.md "Removed docs" notes match the disk', () {
      // Mirrors docs/INDEX.md's "Removed docs (2026-07-10, corrected
      // 2026-07-16)" section — when a new file is added there under
      // "Actually removed", add its path here too (DOC-D1,
      // docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv).
      // This guardrail exists because that note was previously wrong: it
      // claimed several files were removed that were still tracked.
      const claimedRemoved = {
        '../docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Redesign-Checklist.csv',
        '../docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Redesign-Checklist.md',
        '../docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv',
      };

      final stillPresent = claimedRemoved
          .where((path) => File(path).existsSync())
          .toList();

      expect(
        stillPresent,
        isEmpty,
        reason:
            'docs/INDEX.md "Removed docs" claims these were deleted, but '
            'they still exist on disk: $stillPresent',
      );

      // The flip side: files this codebase explicitly documents as KEPT
      // (despite the historical "removed" note being wrong about them)
      // must stay tracked, so a future cleanup pass does not re-delete them
      // without updating the doc that links to them.
      const explicitlyKept = {
        '../docs/02_FLUTTER_MIGRATION/Card-Tile-Migration-Checklist.md',
        '../docs/02_FLUTTER_MIGRATION/Card-Tile-Migration-Execution-Plan.md',
      };
      final missingButExpected = explicitlyKept
          .where((path) => !File(path).existsSync())
          .toList();
      expect(
        missingButExpected,
        isEmpty,
        reason:
            'These files are linked from Card-Tile-Standard.md as historical '
            'reference and must not be deleted without updating that link: '
            '$missingButExpected',
      );
    });

    test('Android release signing fails closed without signing material', () {
      final buildGradle = _read('android/app/build.gradle.kts');

      expect(buildGradle, contains('VITTRADE_KEYSTORE_PATH'));
      expect(buildGradle, contains('VITTRADE_KEYSTORE_PASSWORD'));
      expect(buildGradle, contains('VITTRADE_KEY_ALIAS'));
      expect(buildGradle, contains('VITTRADE_KEY_PASSWORD'));
      expect(buildGradle, contains('hasReleaseSigning'));
      expect(buildGradle, contains('throw GradleException'));
      expect(buildGradle, contains('Release signing is required'));
    });
  });
}

String _read(String path) {
  final file = File(path);
  expect(file.existsSync(), isTrue, reason: path);
  return file.readAsStringSync();
}
