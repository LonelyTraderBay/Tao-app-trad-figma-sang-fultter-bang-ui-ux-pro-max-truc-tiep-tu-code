// ignore_for_file: avoid_print

import 'dart:io';

import 'segment_pill_scan.dart';

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final strictFull = args.contains('--strict-full');
  final strictP0 = strictFull || args.contains('--strict-p0');
  final strictP1 = strictFull || args.contains('--strict-p1');

  final appRoot = findSegmentPillAppRoot();
  final repoRoot = findSegmentPillRepoRoot(appRoot);
  final docsDir = Directory('${repoRoot.path}/docs/02_FLUTTER_MIGRATION');
  final featuresRoot = Directory('${appRoot.path}/lib/features');
  final auditCsv = File(
    '${docsDir.path}/audits/VitTrade-Segment-Pill-Audit.csv',
  );
  final reportMd = File(
    '${docsDir.path}/audits/Segment-Pill-Compliance-Report.md',
  );

  final result = scanSegmentPillFeatures(featuresRoot);
  final csv = renderSegmentPillAuditCsv(result);
  final report = renderSegmentPillComplianceReport(result);

  if (checkOnly) {
    if (!auditCsv.existsSync()) {
      stderr.writeln('Segment pill audit CSV is missing.');
      stderr.writeln(
        'Run `dart run tool/segment_pill_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    if (auditCsv.readAsStringSync() != csv) {
      stderr.writeln('Segment pill audit CSV is stale.');
      stderr.writeln(
        'Run `dart run tool/segment_pill_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    if (!reportMd.existsSync() || reportMd.readAsStringSync() != report) {
      stderr.writeln('Segment-Pill-Compliance-Report.md is stale.');
      stderr.writeln(
        'Run `dart run tool/segment_pill_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }

    stdout.writeln('Segment pill audit artifact is current.');
    stdout.writeln('Summary: ${result.summary}');

    if (strictP0) {
      if (result.p0Count > 0) {
        stderr.writeln(
          '--strict-p0: ${result.p0Count} P0 local class(es) remain:',
        );
        for (final lc in result.p0Locals) {
          stderr.writeln('  ${lc.file} → ${lc.className}');
        }
        exitCode = 1;
        return;
      }

      for (final entity in featuresRoot.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final src = entity.readAsStringSync();
        if (segmentPillSourceContainsP0Ban(src)) {
          stderr.writeln(
            '--strict-p0: banned P0 class pattern in ${entity.path}',
          );
          exitCode = 1;
          return;
        }
      }
    }

    if (strictP1) {
      if (result.p1Count > 0) {
        stderr.writeln(
          '--strict-p1: ${result.p1Count} P1 local class(es) remain:',
        );
        for (final lc in result.p1Locals) {
          stderr.writeln('  ${lc.file} → ${lc.className}');
        }
        exitCode = 1;
        return;
      }

      for (final entity in featuresRoot.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final src = entity.readAsStringSync();
        if (segmentPillSourceContainsP1Ban(src)) {
          stderr.writeln(
            '--strict-p1: banned P1 class pattern in ${entity.path}',
          );
          exitCode = 1;
          return;
        }
      }
    }

    if (strictFull) {
      final warnCount = result.summary['warn'] ?? 0;
      if (warnCount > 0) {
        stderr.writeln(
          '--strict-full: $warnCount compliance warn row(s) remain '
          '(height override on VitChoicePill / VitFilterChip).',
        );
        exitCode = 1;
        return;
      }

      if (result.interactiveLocals.isNotEmpty) {
        stderr.writeln(
          '--strict-full: ${result.interactiveLocals.length} interactive '
          'local class(es) remain.',
        );
        for (final lc in result.interactiveLocals) {
          stderr.writeln('  ${lc.file} → ${lc.className}');
        }
        exitCode = 1;
        return;
      }

      final duplicateRows = result.fileRows
          .where((row) => row.localClasses.isNotEmpty)
          .toList();
      if (duplicateRows.isNotEmpty) {
        stderr.writeln(
          '--strict-full: ${duplicateRows.length} file(s) still define '
          'interactive local pill duplicates:',
        );
        for (final row in duplicateRows) {
          stderr.writeln('  ${row.file} → ${row.localClasses.join('|')}');
        }
        exitCode = 1;
        return;
      }
    }
    return;
  }

  docsDir.createSync(recursive: true);
  auditCsv.writeAsStringSync(csv);
  reportMd.writeAsStringSync(report);

  print('Wrote ${auditCsv.path} (${result.fileRows.length} file-family rows)');
  print('Wrote ${reportMd.path}');
  print('Summary: ${result.summary}');
  if (result.p0Count > 0) {
    print('P0 locals remaining: ${result.p0Count}');
  }
}
