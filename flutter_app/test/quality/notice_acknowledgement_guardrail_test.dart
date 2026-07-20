import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Scans lib/features/**/presentation/ for:
//   1. showSnackBar (SnackBar ack) — banned for user-facing acknowledgements.
//   2. _SuccessToast / TransferSuccessBanner / ExecutionQualitySuccessToast
//      class definitions — banned overlay-style toasts.
//   3. Positioned( collocated with VitBannerVariant.success within the same
//      file — banned overlay success banners.
//
// Hard allow: vit_offline_banner.dart, test files, data fixtures.
// Opt-out per line: // notice-ack: allow-<reason>
//
// Baseline ratchet: seed full debt after Batch 1; shrink as batches land.
// Source: docs/02_FLUTTER_MIGRATION/standards/Notice-Acknowledgement-Standard.md

void main() {
  test(
    'no new showSnackBar ack or Positioned success overlays in presentation',
    () {
      final baselineFile = File(
        'test/quality/notice_acknowledgement_baseline.txt',
      );
      final baseline = baselineFile.existsSync()
          ? baselineFile.readAsLinesSync().where((l) => l.isNotEmpty).toSet()
          : <String>{};

      final presentationRoots = [Directory('lib/features')];
      final violations = <String>[];

      for (final root in presentationRoots) {
        if (!root.existsSync()) continue;

        for (final entity in root.listSync(recursive: true)) {
          if (entity is! File || !entity.path.endsWith('.dart')) continue;

          final path = entity.path.replaceAll('\\', '/');

          // Hard allow: the banner implementation itself, tests, fixtures.
          if (path.contains('vit_offline_banner.dart')) continue;
          if (path.contains('/test/')) continue;
          if (path.contains('/data/fixtures/')) continue;
          if (path.contains('/data/mock')) continue;

          // Only scan presentation layer.
          if (!path.contains('/presentation/')) continue;

          final lines = entity.readAsLinesSync();

          // Pattern A: showSnackBar usage.
          // Pattern B: banned toast class names.
          // Pattern C: Positioned collocated with VitBannerVariant.success
          //            in the same file (file-level heuristic).
          final hasPositioned = lines.any(
            (l) => l.contains('Positioned(') && !_isOptOut(l),
          );
          final hasSuccessBanner = lines.any(
            (l) => l.contains('VitBannerVariant.success') && !_isOptOut(l),
          );

          for (var i = 0; i < lines.length; i++) {
            final line = lines[i];
            final lineRef = '$path:${i + 1}';

            if (_isOptOut(line)) continue;

            if (line.contains('showSnackBar')) {
              _addIfNew(violations, baseline, '$lineRef: ${line.trim()}');
            }

            if (_isBannedToastClass(line)) {
              _addIfNew(violations, baseline, '$lineRef: ${line.trim()}');
            }

            // Positioned + success banner in the same file.
            if (hasPositioned &&
                hasSuccessBanner &&
                line.contains('Positioned(')) {
              _addIfNew(violations, baseline, '$lineRef: ${line.trim()}');
            }
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'New notice-acknowledgement violations found.\n'
            'Fix: replace with showVitNoticeSheet (see Notice-Acknowledgement-Standard.md).\n'
            'To defer: add // notice-ack: allow-<reason> to the offending line '
            'and add the path:line to notice_acknowledgement_baseline.txt.\n\n'
            '${violations.join('\n')}',
      );
    },
  );

  test('notice_acknowledgement_baseline has no regressions (ratchet)', () {
    final baselineFile = File(
      'test/quality/notice_acknowledgement_baseline.txt',
    );
    if (!baselineFile.existsSync()) return;

    final baseline = baselineFile
        .readAsLinesSync()
        .where((l) => l.isNotEmpty)
        .toList();

    // Each baseline entry format: "path/to/file.dart:lineNum: trimmedContent"
    // Verify the source file still exists (detects moved/deleted files).
    final missing = <String>[];
    final linePattern = RegExp(r'^(.+):(\d+): ');

    for (final entry in baseline) {
      final match = linePattern.firstMatch(entry);
      if (match == null) continue;
      final filePath = match.group(1)!;
      final lineNum = int.parse(match.group(2)!);

      final file = File(filePath);
      if (!file.existsSync()) {
        missing.add('$entry  (file deleted — remove from baseline)');
        continue;
      }
      final lines = file.readAsLinesSync();
      if (lineNum > lines.length) {
        missing.add('$entry  (line beyond EOF — remove from baseline)');
      }
    }

    expect(
      missing,
      isEmpty,
      reason:
          'Baseline entries point to deleted/moved lines. '
          'Remove them from notice_acknowledgement_baseline.txt.\n\n'
          '${missing.join('\n')}',
    );
  });
}

bool _isOptOut(String line) => line.contains('// notice-ack: allow-');

bool _isBannedToastClass(String line) {
  return line.contains('class _SuccessToast') ||
      line.contains('class TransferSuccessBanner') ||
      line.contains('class ExecutionQualitySuccessToast');
}

void _addIfNew(List<String> violations, Set<String> baseline, String entry) {
  if (!baseline.contains(entry)) {
    violations.add(entry);
  }
}
