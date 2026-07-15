import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('page rhythm audit artifact is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/page_rhythm_audit.dart',
      '--check',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/page_rhythm_audit.dart` from flutter_app/.',
    );
  });

  test('changed presentation files do not introduce new page rhythm debt', () {
    final changedFiles = _collectChangedLibFiles();
    final baseline = _loadStructuralBaseline();
    final violations = <String>[];

    for (final path in changedFiles) {
      final normalized = path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final file = File(path);
      if (!file.existsSync()) continue;
      final content = file.readAsStringSync();
      if (!content.contains('VitPageContent') &&
          !content.contains('VitTradeHubScaffold') &&
          !content.contains('VitTradeDetailScaffold') &&
          !content.contains('VitTradeSimpleShell')) {
        continue;
      }

      final isUntracked = !_isTracked(path);
      final addedLines = _collectAddedLines(path, isUntracked);

      for (final line in addedLines) {
        if (_orphanGapPattern.hasMatch(line.trim())) {
          violations.add(
            '$path: orphan rhythm-owner SizedBox in direct children -> $line',
          );
        }
        if (_orphanMajorGapPattern.hasMatch(line.trim()) &&
            (normalized.contains('/presentation/widgets/') ||
                normalized.contains('_part_'))) {
          violations.add(
            '$path: orphan major SizedBox in tab/widget Column -> $line',
          );
        }
        if (line.contains('VitPageContent(') &&
            !line.contains('rhythm:') &&
            !line.contains('customGap:')) {
          // Multi-line widget — check nearby added block
          if (addedLines.any(
            (l) => l.contains('rhythm:') || l.contains('customGap:'),
          )) {
            continue;
          }
        }
        if (RegExp(r'AppSpacing\.sectionGap\b').hasMatch(line) &&
            !line.contains('pageRhythm') &&
            !line.contains('// legacy')) {
          violations.add('$path: legacy sectionGap for page rhythm -> $line');
        }
        if (RegExp(r'class _SectionTitle\b').hasMatch(line)) {
          violations.add(
            '$path: legacy _SectionTitle -> use VitSectionHeader -> $line',
          );
        }
      }

      if (addedLines.any((l) => l.contains('VitPageContent(')) &&
          !content.contains('rhythm:') &&
          !content.contains('customGap:')) {
        violations.add('$path: VitPageContent without rhythm or customGap');
      }

      if (addedLines.any((l) => l.contains('children: [')) &&
          _addedNestedVitPageContent(addedLines)) {
        violations.add('$path: nested VitPageContent as direct child (added)');
      }

      final flutterPath = 'flutter_app/lib/$normalized'.replaceFirst(
        'flutter_app/lib/lib/',
        'flutter_app/lib/',
      );
      final baselineKey = flutterPath.startsWith('flutter_app/')
          ? flutterPath
          : 'flutter_app/lib/$normalized';

      if (_isTabRootPage(normalized) &&
          addedLines.any((l) => l.contains('rhythm: VitPageRhythm.')) &&
          !addedLines.any((l) => l.contains('VitPageRhythm.compact')) &&
          content.contains('rhythm: VitPageRhythm.') &&
          !content.contains('VitPageRhythm.compact')) {
        violations.add('$path: tab root must use VitPageRhythm.compact');
      }

      final priorStructural = baseline[baselineKey] ?? '';
      final currentStructural = _structuralViolationsForFile(
        content,
        normalized,
      );
      if (_isNewStructuralDebt(priorStructural, currentStructural) &&
          !content.contains('page-rhythm: allow-single-child')) {
        violations.add(
          '$path: new structural debt ($currentStructural; was "$priorStructural")',
        );
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('presentation files do not use legacy x5-x7 vertical spacing', () {
    final violations = <String>[];
    final libDir = Directory('lib/features');
    if (!libDir.existsSync()) {
      fail('lib/features not found — run from flutter_app/');
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final content = entity.readAsStringSync();
      final lines = content.split('\n');
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (_legacyVerticalScaleHeight.hasMatch(line) &&
            !line.contains('pageRhythm')) {
          violations.add('${entity.path}:${i + 1}: $line');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Replace legacy x5–x7 SizedBox heights with pageRhythm tokens:\n'
          '${violations.join('\n')}',
    );
  });

  test('presentation files do not use raw x3/x4 vertical spacing', () {
    final violations = <String>[];
    final libDir = Directory('lib/features');
    if (!libDir.existsSync()) {
      fail('lib/features not found — run from flutter_app/');
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final lines = entity.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (_legacyX34PlainHeight.hasMatch(line) &&
            !line.contains('+') &&
            !line.contains('-')) {
          violations.add('${entity.path}:${i + 1}: $line');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use pageRhythm*InnerGap, pageRhythm*SectionGap, or rowGap '
          'instead of raw x3/x4:\n${violations.join('\n')}',
    );
  });

  test('presentation files do not use raw customGap Fibonacci scale', () {
    final violations = <String>[];
    final libDir = Directory('lib/features');
    if (!libDir.existsSync()) {
      fail('lib/features not found — run from flutter_app/');
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final lines = entity.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (_legacyCustomGapRawScale.hasMatch(lines[i])) {
          violations.add('${entity.path}:${i + 1}: ${lines[i].trim()}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use VitPageRhythm tiers or pageRhythm*SectionGap instead of '
          'customGap: AppSpacing.x*:\n${violations.join('\n')}',
    );
  });

  test(
    'presentation files do not use compound x3/x4 rhythm SizedBox heights',
    () {
      final violations = <String>[];
      final libDir = Directory('lib/features');
      if (!libDir.existsSync()) {
        fail('lib/features not found — run from flutter_app/');
      }

      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final normalized = entity.path.replaceAll('\\', '/');
        if (!normalized.contains('/presentation/')) continue;
        if (normalized.contains('/dev/')) continue;

        final lines = entity.readAsStringSync().split('\n');
        for (var i = 0; i < lines.length; i++) {
          if (_legacyCompoundX34Height.hasMatch(lines[i]) &&
              !lines[i].contains('pageRhythm')) {
            violations.add('${entity.path}:${i + 1}: ${lines[i].trim()}');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Replace compound x3/x4 SizedBox heights with pageRhythm* tokens:\n'
            '${violations.join('\n')}',
      );
    },
  );

  test('presentation files do not use magic literal rhythm spacing', () {
    final violations = <String>[];
    final libDir = Directory('lib/features');
    if (!libDir.existsSync()) {
      fail('lib/features not found — run from flutter_app/');
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final lines = entity.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (_magicNumberRhythmSizedBox.hasMatch(lines[i])) {
          violations.add('${entity.path}:${i + 1}: ${lines[i].trim()}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Replace AppSpacing.x* + digit rhythm spacing with semantic tokens:\n'
          '${violations.join('\n')}',
    );
  });

  test('presentation files do not use raw x2 vertical spacing in columns', () {
    final violations = <String>[];
    final libDir = Directory('lib/features');
    if (!libDir.existsSync()) {
      fail('lib/features not found — run from flutter_app/');
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final lines = entity.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (_legacyX2PlainHeight.hasMatch(lines[i]) &&
            !lines[i].contains('pageRhythm')) {
          violations.add('${entity.path}:${i + 1}: ${lines[i].trim()}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use pageRhythmCompactInnerGap instead of raw x2 vertical spacing:\n'
          '${violations.join('\n')}',
    );
  });
}

const _tabRootPages = {
  'features/home/presentation/pages/home_page.dart',
  'features/profile/presentation/pages/profile_page.dart',
  'features/wallet/presentation/pages/wallet_page.dart',
  'features/trade/presentation/pages/hub/trade_page.dart',
  'features/predictions/presentation/pages/predictions_home_page.dart',
};

bool _isTabRootPage(String path) {
  for (final tab in _tabRootPages) {
    if (path.endsWith(tab)) return true;
  }
  return false;
}

final _orphanGapPattern = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.(?:x[3-7]|sectionGap|sectionGapCompact|pageContentGap|pageRhythm(?:Compact|Standard|Form|Relaxed)(?:Inner|Section)Gap)',
);

final _orphanMajorGapPattern = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.(?:x[5-7])',
);

final _legacyVerticalScaleHeight = RegExp(
  r'SizedBox\s*\(\s*height:\s*[^)]*AppSpacing\.(?:x[5-7])',
);

final _legacyX34PlainHeight = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.(?:x3|x4)\b',
);

final _legacyCustomGapRawScale = RegExp(r'customGap:\s*AppSpacing\.(x[1-7])\b');

final _legacyCompoundX34Height = RegExp(
  r'SizedBox\s*\(\s*height:\s*[^)]*AppSpacing\.(?:x3|x4)[^)]*[+\-][^)]*\)',
);

final _magicNumberRhythmSizedBox = RegExp(
  r'SizedBox\s*\(\s*(?:height|width):\s*[^)]*AppSpacing\.x[0-7]\s*\+\s*[0-9]',
);

final _legacyX2PlainHeight = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.x2\b',
);

bool _addedNestedVitPageContent(List<String> addedLines) {
  var sawChildren = false;
  for (final line in addedLines) {
    if (line.contains('children: [')) sawChildren = true;
    if (sawChildren && line.trimLeft().startsWith('VitPageContent(')) {
      return true;
    }
  }
  return false;
}

String _structuralViolationsForFile(String content, String relative) {
  final parts = <String>[];
  if (_isPageFile(relative) &&
      !content.contains('page-rhythm: allow-single-child') &&
      _hasSingleChildSectionColumn(content)) {
    parts.add('single_child_section_column');
  }
  if (_isTabRootPage(relative)) {
    final declared = RegExp(
      r'rhythm:\s*VitPageRhythm\.(\w+)',
    ).firstMatch(content);
    if (declared != null && declared.group(1) != 'compact') {
      parts.add('tab_root_wrong_tier:${declared.group(1)}');
    }
  }
  return parts.join(';');
}

bool _isPageFile(String relative) {
  return relative.contains('/presentation/pages/');
}

bool _hasSingleChildSectionColumn(String source) {
  var index = 0;
  while (true) {
    final start = source.indexOf('VitPageContent', index);
    if (start < 0) return false;

    final childrenIndex = source.indexOf('children:', start);
    if (childrenIndex < 0 || childrenIndex > start + 800) {
      index = start + 1;
      continue;
    }

    final listStart = source.indexOf('[', childrenIndex);
    if (listStart < 0) {
      index = childrenIndex + 1;
      continue;
    }

    final listEnd = _findMatchingBracket(source, listStart);
    if (listEnd < 0) {
      index = listStart + 1;
      continue;
    }

    final listBody = source.substring(listStart + 1, listEnd);
    final items = _splitTopLevelListItems(
      listBody,
    ).map((item) => item.trim()).where((item) => item.isNotEmpty).toList();

    if (items.length == 1 && _looksLikeSectionAggregator(items.first)) {
      return true;
    }
    index = listEnd + 1;
  }
}

bool _looksLikeSectionAggregator(String item) {
  var trimmed = item.trimLeft();
  if (trimmed.startsWith('if (')) return false;
  if (trimmed.startsWith('const ')) {
    trimmed = trimmed.substring('const '.length).trimLeft();
  }
  if (trimmed.startsWith('Column(') || trimmed.startsWith('switch (')) {
    return true;
  }
  if (RegExp(r'^_\w+Body\b').hasMatch(trimmed)) return true;
  if (RegExp(r'^_\w+(Content|Sections|ScrollBody)\b').hasMatch(trimmed)) {
    return true;
  }
  return false;
}

bool _isNewStructuralDebt(String prior, String current) {
  if (current.isEmpty) return false;
  if (prior.isEmpty) return true;
  final priorSet = prior.split(';').toSet();
  final currentSet = current.split(';').toSet();
  return currentSet.difference(priorSet).isNotEmpty;
}

Map<String, String> _loadStructuralBaseline() {
  final csv = File(
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Page-Rhythm-Audit.csv',
  );
  if (!csv.existsSync()) return {};
  final lines = csv.readAsLinesSync();
  if (lines.isEmpty) return {};
  final map = <String, String>{};
  for (var i = 1; i < lines.length; i++) {
    final parts = _parseCsvLine(lines[i]);
    if (parts.length < 8) continue;
    map[parts[1]] = parts[7];
  }
  return map;
}

List<String> _parseCsvLine(String line) {
  final result = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        buffer.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
      continue;
    }
    if (char == ',' && !inQuotes) {
      result.add(buffer.toString());
      buffer.clear();
      continue;
    }
    buffer.write(char);
  }
  result.add(buffer.toString());
  return result;
}

List<String> _splitTopLevelListItems(String listBody) {
  final items = <String>[];
  final buffer = StringBuffer();
  var depth = 0;
  var parenDepth = 0;

  for (var i = 0; i < listBody.length; i++) {
    final char = listBody[i];
    if (char == '[') depth++;
    if (char == ']') depth--;
    if (char == '(') parenDepth++;
    if (char == ')') parenDepth--;

    if (char == ',' && depth == 0 && parenDepth == 0) {
      items.add(buffer.toString());
      buffer.clear();
      continue;
    }
    buffer.write(char);
  }

  if (buffer.isNotEmpty) items.add(buffer.toString());
  return items;
}

int _findMatchingBracket(String source, int openIndex) {
  var depth = 0;
  for (var i = openIndex; i < source.length; i++) {
    final char = source[i];
    if (char == '[') depth++;
    if (char == ']') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
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
  ]);
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
  ]);
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
  final result = Process.runSync('git', ['ls-files', '--error-unmatch', path]);
  return result.exitCode == 0;
}

List<String> _collectAddedLines(String path, bool isUntracked) {
  if (isUntracked) {
    return File(path).readAsLinesSync();
  }

  final result = Process.runSync('git', ['diff', 'HEAD', '--', path]);
  if (result.exitCode != 0) return [];

  final added = <String>[];
  for (final line in result.stdout.toString().split('\n')) {
    if (line.startsWith('+') && !line.startsWith('+++')) {
      added.add(line.substring(1));
    }
  }
  return added;
}
