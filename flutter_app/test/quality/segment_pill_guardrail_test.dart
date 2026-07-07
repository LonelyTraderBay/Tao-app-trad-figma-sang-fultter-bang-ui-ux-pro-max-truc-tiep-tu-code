import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _p0BannedClassNames = {
  '_FilterButton',
  '_FilterTabs',
  '_NetworkFilterTabs',
  '_AuditFilterTabs',
  '_SegmentedTabs',
};

const _p1BannedClassNames = {
  '_FilterChip',
  '_FilterChips',
  '_ChipButton',
  '_ChoiceChipButton',
  '_DomainFilterChip',
  '_FilterChipButton',
  '_TimeFilterChips',
  '_CategoryFilterChips',
  '_StatusFilterChips',
};

void main() {
  final repoRoot = Directory.current.path;
  final featuresRoot = Directory('$repoRoot/lib/features');

  test('segment pill audit artifact is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/segment_pill_audit.dart',
      '--check',
      '--strict-full',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/segment_pill_audit.dart` from flutter_app/.',
    );
  });

  test('segment pill migration manifest is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/segment_pill_manifest.dart',
      '--check',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/segment_pill_manifest.dart` from flutter_app/.',
    );
  });

  test('VitTabBar segment tier implements mandatory S1 contract', () {
    final source = File(
      '$repoRoot/lib/shared/widgets/vit_tab_bar.dart',
    ).readAsStringSync();

    expect(source, contains('VitTabBarVariant.segment'));
    expect(source, contains('AppColors.primary12'));
    expect(source, contains('AppColors.portfolioBtnGhostBorder'));
    expect(source, contains('tabBarPillVertical'));
  });

  test('VitSegmentedTabBar delegates to VitTabBar.segment', () {
    final source = File(
      '$repoRoot/lib/shared/widgets/vit_segmented_tab_bar.dart',
    ).readAsStringSync();

    expect(source, contains('VitTabBarVariant.segment'));
    expect(source, contains('Do **not** wrap in [VitCard]'));
  });

  test('VitSegmentedChoice implements mandatory S2 contract', () {
    final source = File(
      '$repoRoot/lib/shared/widgets/vit_segmented_choice.dart',
    ).readAsStringSync();

    expect(source, contains('buySell'));
    expect(source, contains('borderless = true'));
    expect(source, contains('AppRadii.inputRadius'));
  });

  test('AppSpacing exposes segment pill tokens', () {
    final source = File(
      '$repoRoot/lib/app/theme/app_spacing.dart',
    ).readAsStringSync();

    for (final token in [
      'tabBarPillVertical',
      'vitChoicePillCompactPadding',
      'vitFilterChipPadding',
      'vitPresetChipRowHeight',
    ]) {
      expect(source, contains(token), reason: 'Missing $token');
    }
  });

  test('Feature modules must not define banned P0 segment-pill classes', () {
    expect(featuresRoot.existsSync(), isTrue);

    for (final entity in featuresRoot.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;

      final source = entity.readAsStringSync();
      for (final className in _p0BannedClassNames) {
        expect(
          source,
          isNot(contains('class $className')),
          reason: '${entity.path} must not define $className',
        );
      }
    }
  });

  test('Feature modules must not define banned P1 segment-pill classes', () {
    expect(featuresRoot.existsSync(), isTrue);

    for (final entity in featuresRoot.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;

      final source = entity.readAsStringSync();
      for (final className in _p1BannedClassNames) {
        expect(
          source,
          isNot(contains('class $className')),
          reason: '${entity.path} must not define $className',
        );
      }
      expect(
        source,
        isNot(contains('class _FilterChips<')),
        reason: '${entity.path} must not define _FilterChips<T>',
      );
    }
  });

  test('changed presentation files do not add local interactive pill debt', () {
    final changedFiles = _collectChangedLibFiles();
    final violations = <String>[];
    final bannedPattern = RegExp(
      r'class (_\w*(?:FilterButton|FilterTabs|SegmentedTabs|AuditFilterTabs|NetworkFilterTabs|FilterChip|FilterChips|ChipButton|ChoiceChipButton|DomainFilterChip|FilterChipButton|TimeFilterChips|CategoryFilterChips|StatusFilterChips|PillButton|SegmentButton)[^\s]*)',
    );

    for (final path in changedFiles) {
      final normalized = path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final file = File(path);
      if (!file.existsSync()) continue;

      final isUntracked = !_isTracked(path);
      final addedLines = _collectAddedLines(path, isUntracked);
      final addedText = addedLines.join('\n');
      if (addedText.contains('segment-pill: allow-local')) continue;

      for (final match in bannedPattern.allMatches(addedText)) {
        violations.add('$path: added local ${match.group(1)}');
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

List<String> _collectChangedLibFiles() {
  final changed = <String>{};
  final diffResult = Process.runSync('git', [
    'diff',
    '--name-only',
    'HEAD',
    '--',
    'lib',
  ], runInShell: Platform.isWindows);
  if (diffResult.exitCode == 0) {
    for (final line in diffResult.stdout.toString().split('\n')) {
      final path = line.trim();
      if (path.isNotEmpty && path.endsWith('.dart')) changed.add(path);
    }
  }

  final statusResult = Process.runSync('git', [
    'status',
    '--porcelain',
    '--',
    'lib',
  ], runInShell: Platform.isWindows);
  if (statusResult.exitCode == 0) {
    for (final line in statusResult.stdout.toString().split('\n')) {
      if (line.length < 3) continue;
      final status = line.substring(0, 2);
      final path = line.substring(3).trim();
      if (status.trim().isEmpty) continue;
      if (path.endsWith('.dart')) changed.add(path);
    }
  }

  return changed.toList()..sort();
}

bool _isTracked(String path) {
  final result = Process.runSync('git', [
    'ls-files',
    '--error-unmatch',
    path,
  ], runInShell: Platform.isWindows);
  return result.exitCode == 0;
}

List<String> _collectAddedLines(String path, bool isUntracked) {
  if (isUntracked) {
    return File(path).readAsLinesSync();
  }

  final result = Process.runSync('git', [
    'diff',
    'HEAD',
    '--',
    path,
  ], runInShell: Platform.isWindows);
  if (result.exitCode != 0) return [];

  final added = <String>[];
  for (final line in result.stdout.toString().split('\n')) {
    if (line.startsWith('+') && !line.startsWith('+++')) {
      added.add(line.substring(1));
    }
  }
  return added;
}
