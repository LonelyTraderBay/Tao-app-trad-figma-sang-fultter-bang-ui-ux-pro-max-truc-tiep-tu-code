// Origin: 3b6ecd0c (2026-07-07) - feat(flutter): bổ sung Home Reference Consistency Audit và tách spacing token theo từng module
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
// Tách từ home_reference_consistency_guardrail_test.dart 2026-07-20 (giới hạn 400 dòng/file test).
import 'dart:io';

String dartExecutable() {
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

List<String> collectChangedLibFiles() {
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

bool isTracked(String path) {
  final result = Process.runSync('git', ['ls-files', '--error-unmatch', path]);
  return result.exitCode == 0;
}

List<String> collectAddedLines(String path, bool isUntracked) {
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

String? lineDivergenceReason(String line) {
  final trimmed = line.trim();
  if (trimmed.isEmpty || trimmed.startsWith('//')) return null;

  if (containerPattern.hasMatch(trimmed)) {
    return 'raw Container( instead of VitCard';
  }
  if (boxDecorationPattern.hasMatch(trimmed)) {
    return 'raw BoxDecoration( instead of VitCard';
  }
  if (borderRadiusPattern.hasMatch(trimmed)) {
    return 'BorderRadius.circular( instead of AppRadii.*';
  }
  if (radiusPattern.hasMatch(trimmed)) {
    return 'Radius.circular( instead of AppRadii.*';
  }
  return null;
}

bool isPathException(String path) {
  return _exceptionPathPatterns.any((exception) => path.contains(exception));
}

final RegExp containerPattern = RegExp(r'Container\(');
final RegExp boxDecorationPattern = RegExp(r'BoxDecoration\(');
final RegExp borderRadiusPattern = RegExp(r'BorderRadius\.circular\(');
final RegExp radiusPattern = RegExp(r'Radius\.circular\(');
final RegExp cardTileInnerGapWidthPattern = RegExp(
  r'width:\s*AppSpacing\.cardTileInnerGap',
);

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
