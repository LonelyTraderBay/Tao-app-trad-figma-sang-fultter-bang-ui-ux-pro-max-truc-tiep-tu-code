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
        'lib/features/trade_core/data/repositories/mock_trade_repository.dart',
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
