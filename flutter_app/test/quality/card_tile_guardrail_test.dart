// Origin: 905aebcd (2026-07-07) - feat(flutter): chuẩn hóa UI toàn app theo 6 tiêu chuẩn thiết kế
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('card tile audit artifact is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/card_tile_audit.dart',
      '--check',
      '--strict-full',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/card_tile_audit.dart` from flutter_app/.',
    );
  });

  test('card tile migration manifest is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/card_tile_manifest.dart',
      '--check',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/card_tile_manifest.dart` from flutter_app/.',
    );
  });

  test('changed presentation files do not add raw fixed-height VitCard debt', () {
    final changedFiles = _collectChangedLibFiles();
    final violations = <String>[];

    for (final path in changedFiles) {
      final normalized = path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final file = File(path);
      if (!file.existsSync()) continue;
      final content = file.readAsStringSync();
      if (!content.contains('VitCard(')) continue;

      final isUntracked = !_isTracked(path);
      final addedLines = _collectAddedLines(path, isUntracked);

      for (final block in _addedVitCardBlocks(addedLines)) {
        if (block.contains('card-tile: allow-start')) continue;
        final params = _vitCardParams(block);
        final fixed =
            params.contains('height:') ||
            RegExp(r'minHeight:\s*[^0\s,)]').hasMatch(params);
        if (!fixed) continue;
        if (!params.contains('contentAlign: VitCardContentAlign.center')) {
          violations.add(
            '$path: fixed-height VitCard without contentAlign.center',
          );
        }
        if (fixed &&
            params.contains('height:') &&
            !params.contains('cardTilePadding') &&
            !block.contains('card-tile: allow-start')) {
          // Tier A strip tiles must use shared padding token when added inline.
          if (normalized.contains('/features/') &&
              !normalized.contains('/shared/')) {
            violations.add(
              '$path: page-local fixed-height VitCard — use shared Tier A widget',
            );
          }
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
    return '${cacheRoot}dart-sdk/bin/'
        '${Platform.isWindows ? 'dart.exe' : 'dart'}';
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

List<String> _addedVitCardBlocks(List<String> addedLines) {
  final text = addedLines.join('\n');
  if (!text.contains('VitCard(')) return [];

  final blocks = <String>[];
  final pattern = RegExp(r'VitCard\s*\(', multiLine: true);
  for (final match in pattern.allMatches(text)) {
    final start = match.start;
    var depth = 0;
    var end = start;
    for (var i = start; i < text.length; i++) {
      final char = text[i];
      if (char == '(') depth++;
      if (char == ')') {
        depth--;
        if (depth == 0) {
          end = i + 1;
          break;
        }
      }
    }
    if (end > start) {
      blocks.add(text.substring(start, end));
    }
  }
  return blocks;
}

String _vitCardParams(String block) {
  final childIndex = block.indexOf('child:');
  if (childIndex <= 0) return block;
  return block.substring(0, childIndex);
}
