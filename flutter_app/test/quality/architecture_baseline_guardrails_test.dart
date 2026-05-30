import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('architecture baseline guardrails', () {
    test(
      'all feature modules expose domain, data, and presentation layers',
      () {
        final featureDirs = Directory(
          'lib/features',
        ).listSync().whereType<Directory>().toList();
        final missing = <String>[];

        for (final feature in featureDirs) {
          final path = _normalize(feature.path);
          for (final layer in ['domain', 'data', 'presentation']) {
            if (!Directory('$path/$layer').existsSync()) {
              missing.add('$path/$layer');
            }
          }
        }

        expect(missing, isEmpty);
      },
    );

    test('presentation page and widget files do not import data facades', () {
      final imports = _sourceMatches(
        root: 'lib/features',
        pattern: RegExp(
          r"^(import|export) 'package:vit_trade_flutter/features/.*/data",
        ),
        pathFilter: (path) =>
            path.contains('/presentation/pages/') ||
            path.contains('/presentation/widgets/'),
      );

      expect(
        imports,
        isEmpty,
        reason: 'Pages/widgets must read domain/controller facades, not data.',
      );
    });

    test('presentation controllers avoid mock and remote repositories', () {
      final imports = _sourceMatches(
        root: 'lib/features',
        pattern: RegExp(
          r"^(import|export) 'package:vit_trade_flutter/features/.*/data/repositories/(mock|remote)_",
        ),
        pathFilter: (path) => path.contains('/presentation/controllers/'),
      );

      expect(
        imports,
        isEmpty,
        reason:
            'Presentation controllers may depend on same-feature providers, '
            'but must not expose mock or remote repositories.',
      );
    });

    test('non-controller direct feature data imports do not increase', () {
      final imports = _sourceMatches(
        root: 'lib/features',
        pattern: RegExp(r"^import 'package:vit_trade_flutter/features/.*/data"),
        pathFilter: (path) => !path.contains('/presentation/controllers/'),
      );

      expect(
        imports.length,
        lessThanOrEqualTo(27),
        reason:
            'Non-controller feature data imports are a tracked architecture '
            'debt metric.',
      );
    });

    test('presentation controller data-provider exposure does not increase', () {
      final imports = _sourceMatches(
        root: 'lib/features',
        pattern: RegExp(
          r"^(import|export) 'package:vit_trade_flutter/features/.*/data/providers/",
        ),
        pathFilter: (path) => path.contains('/presentation/controllers/'),
      );

      expect(
        imports.length,
        lessThanOrEqualTo(0),
        reason:
            'Controller files may temporarily bridge same-feature providers, '
            'but this exposure must trend down to zero.',
      );
    });

    test('presentation controllers exist for migrated high-risk state', () {
      final controllers = Directory('lib/features')
          .listSync(recursive: true)
          .whereType<Directory>()
          .where((directory) {
            final path = _normalize(directory.path);
            return path.endsWith('/presentation/controllers');
          })
          .toList();

      expect(controllers, isNotEmpty);
    });

    test('presentation page part-file debt does not increase', () {
      final pagePartFiles = Directory('lib/features')
          .listSync(recursive: true)
          .whereType<File>()
          .map((file) => _normalize(file.path))
          .where(
            (path) =>
                path.contains('/presentation/pages/') &&
                RegExp(r'_part_.*\.dart$').hasMatch(path),
          )
          .toList();

      expect(
        pagePartFiles.length,
        lessThanOrEqualTo(218),
        reason:
            'Page part-files are tracked refactor debt. New reusable UI '
            'should move into presentation/widgets/ instead of adding more '
            'presentation/pages/*_part_*.dart files.',
      );
    });

    test('wallet uses presentation widgets for high-volume UI', () {
      final walletWidgetFiles =
          Directory(
            'lib/features/wallet/presentation/widgets',
          ).listSync().whereType<File>().where((file) {
            return file.path.endsWith('.dart');
          }).toList();

      expect(
        walletWidgetFiles,
        isNotEmpty,
        reason:
            'Wallet is a high-volume feature. Reusable wallet UI should live '
            'under presentation/widgets/ instead of adding more page-local '
            'or part-file widgets.',
      );
    });

    test('hardcoded color usage does not increase', () {
      final allHardcoded =
          _sourceMatches(root: 'lib', pattern: RegExp(r'Color\(0x')).length +
          _sourceMatches(root: 'test', pattern: RegExp(r'Color\(0x')).length;
      final runtimeHardcoded = _sourceMatches(
        root: 'lib',
        pattern: RegExp(r'Color\(0x'),
      );
      final runtimeHardcodedOutsideTheme = _sourceMatches(
        root: 'lib',
        pattern: RegExp(r'Color\(0x'),
        pathFilter: (path) => !path.startsWith('lib/app/theme/'),
      );
      final materialColors = _sourceMatches(
        root: 'lib',
        pattern: RegExp(r'\bColors\.'),
      );

      expect(allHardcoded, lessThanOrEqualTo(210));
      expect(runtimeHardcoded.length, lessThanOrEqualTo(186));
      expect(runtimeHardcodedOutsideTheme.length, lessThanOrEqualTo(0));
      expect(materialColors.length, lessThanOrEqualTo(0));
    });

    test('large-file architecture debt does not increase', () {
      final over600 = _dartFilesOver(root: 'lib/features', lineCount: 600);
      final over1200 = _dartFilesOver(root: 'lib/features', lineCount: 1200);

      expect(over600.length, lessThanOrEqualTo(239));
      expect(over1200.length, lessThanOrEqualTo(4));
    });
  });
}

List<String> _sourceMatches({
  required String root,
  required RegExp pattern,
  bool Function(String path)? pathFilter,
}) {
  final directory = Directory(root);
  if (!directory.existsSync()) return const [];

  final findings = <String>[];
  for (final file
      in directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final path = _normalize(file.path);
    if (pathFilter != null && !pathFilter(path)) continue;

    final lines = file.readAsLinesSync();
    for (var index = 0; index < lines.length; index += 1) {
      final line = lines[index];
      if (pattern.hasMatch(line)) {
        findings.add('$path:${index + 1}');
      }
    }
  }
  return findings;
}

String _normalize(String path) => path.replaceAll('\\', '/');

List<String> _dartFilesOver({required String root, required int lineCount}) {
  final directory = Directory(root);
  if (!directory.existsSync()) return const [];

  final findings = <String>[];
  for (final file
      in directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final lines = file.readAsLinesSync().length;
    if (lines > lineCount) {
      findings.add('${_normalize(file.path)}:$lines');
    }
  }
  return findings;
}
