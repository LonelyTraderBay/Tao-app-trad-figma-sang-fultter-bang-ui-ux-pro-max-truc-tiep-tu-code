import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('home reference consistency artifacts are current for all modules', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/home_reference_consistency_audit.dart',
      '--check',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/home_reference_consistency_audit.dart` from flutter_app/.',
    );
  });

  test('Home still consumes the shared widgets extracted from it', () {
    const expectations = <String, String>{
      'lib/features/home/presentation/widgets/home_products_section.dart':
          'VitServiceTile.fromAction(',
      'lib/features/home/presentation/widgets/home_more_products_sheet.dart':
          'VitServiceTile.fromAction(',
      'lib/features/home/presentation/widgets/home_portfolio_card.dart':
          'VitBalanceBreakdownRow(',
      'lib/features/home/presentation/pages/home_page_part_02.dart':
          'VitRiskDisclaimerNote(',
    };

    final violations = <String>[];
    expectations.forEach((path, needle) {
      final file = File(path);
      if (!file.existsSync()) {
        violations.add('$path: file missing');
        return;
      }
      final content = file.readAsStringSync();
      if (!content.contains(needle)) {
        violations.add(
          '$path: no longer references $needle — home silently re-forked '
          'a local copy instead of using the shared widget.',
        );
      }
    });

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test(
    'the three home-extracted shared widgets still exist and are exported',
    () {
      const widgetFiles = <String>[
        'lib/shared/widgets/vit_balance_breakdown_row.dart',
        'lib/shared/widgets/vit_risk_disclaimer_note.dart',
      ];
      for (final path in widgetFiles) {
        expect(File(path).existsSync(), isTrue, reason: 'Missing $path');
      }

      final serviceTileContent = File(
        'lib/shared/widgets/vit_module_components.dart',
      ).readAsStringSync();
      expect(
        serviceTileContent,
        contains('factory VitServiceTile.fromAction('),
        reason: 'VitServiceTile.fromAction factory was removed or renamed',
      );

      final barrelContent = File(
        'lib/shared/widgets/widgets.dart',
      ).readAsStringSync();
      expect(barrelContent, contains('vit_balance_breakdown_row.dart'));
      expect(barrelContent, contains('vit_risk_disclaimer_note.dart'));
    },
  );

  test('changed app files do not introduce new home-reference divergence', () {
    final changedFiles = _collectChangedLibFiles();
    final violations = <String>[];

    for (final path in changedFiles) {
      final lower = path.toLowerCase();
      if (_isPathException(lower)) continue;

      final isUntracked = !_isTracked(path);
      final lines = _collectAddedLines(path, isUntracked);
      for (final line in lines) {
        final reason = _lineDivergenceReason(line);
        if (reason != null) {
          violations.add('$path: $reason -> $line');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
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
    return '$flutterRoot/bin/cache/dart-sdk/bin/dart';
  }
  return 'dart';
}

// `git status`/`git diff` sometimes print paths relative to the repo root
// (e.g. `flutter_app/lib/...`) even when both invoked with, and expecting,
// cwd-relative pathspecs — a local git-version/config quirk observed on this
// machine (tests always run with cwd == flutter_app/). Re-feeding such a
// root-relative path back into git as a pathspec, or into File(), silently
// resolves to nothing. Normalize once at collection time so every downstream
// consumer works consistently regardless of which convention this git build
// prints.
String _toCwdRelative(String gitPath) {
  const prefix = 'flutter_app/';
  return gitPath.startsWith(prefix)
      ? gitPath.substring(prefix.length)
      : gitPath;
}

List<String> _collectChangedLibFiles() {
  final changed = <String>{};
  final diffResult = Process.runSync('git', [
    'diff',
    '--name-only',
    'HEAD',
    '--',
    'lib',
  ]);
  if (diffResult.exitCode == 0) {
    for (final line in diffResult.stdout.toString().split('\n')) {
      final path = _toCwdRelative(line.trim());
      if (path.isNotEmpty && path.endsWith('.dart')) changed.add(path);
    }
  }

  final statusResult = Process.runSync('git', [
    'status',
    '--porcelain',
    '--',
    'lib',
  ]);
  if (statusResult.exitCode == 0) {
    for (final line in statusResult.stdout.toString().split('\n')) {
      if (line.length < 3) continue;
      final status = line.substring(0, 2);
      final path = _toCwdRelative(line.substring(3).trim());
      if (status.trim().isEmpty) continue;
      if (path.endsWith('.dart')) changed.add(path);
    }
  }

  return changed.toList()..sort();
}

bool _isTracked(String path) {
  final result = Process.runSync('git', ['ls-files', '--error-unmatch', path]);
  return result.exitCode == 0;
}

List<String> _collectAddedLines(String path, bool isUntracked) {
  if (isUntracked) {
    final file = File(path);
    if (!file.existsSync()) return const [];
    return file.readAsLinesSync();
  }

  final result = Process.runSync('git', ['diff', 'HEAD', '--', path]);
  if (result.exitCode != 0) return const [];

  final added = <String>[];
  for (final line in result.stdout.toString().split('\n')) {
    if (!line.startsWith('+')) continue;
    if (line.startsWith('+++')) continue;
    added.add(line.substring(1));
  }
  return added;
}

String? _lineDivergenceReason(String line) {
  final trimmed = line.trim();
  if (trimmed.isEmpty || trimmed.startsWith('//')) return null;

  if (_containerPattern.hasMatch(trimmed)) {
    return 'raw Container( instead of VitCard';
  }
  if (_boxDecorationPattern.hasMatch(trimmed)) {
    return 'raw BoxDecoration( instead of VitCard';
  }
  if (_borderRadiusPattern.hasMatch(trimmed)) {
    return 'BorderRadius.circular( instead of AppRadii.*';
  }
  if (_radiusPattern.hasMatch(trimmed)) {
    return 'Radius.circular( instead of AppRadii.*';
  }
  return null;
}

bool _isPathException(String path) {
  return _exceptionPathPatterns.any((exception) => path.contains(exception));
}

final RegExp _containerPattern = RegExp(r'Container\(');
final RegExp _boxDecorationPattern = RegExp(r'BoxDecoration\(');
final RegExp _borderRadiusPattern = RegExp(r'BorderRadius\.circular\(');
final RegExp _radiusPattern = RegExp(r'Radius\.circular\(');

const List<String> _exceptionPathPatterns = <String>[
  '/dev/',
  '/internal/',
  '/visual',
  '/chart',
  '/charts',
  '/canvas',
  'custom_painter',
  'custompainter',
  '/order_book',
  '/orderbook',
];
