// ignore_for_file: avoid_print

import 'dart:io';

import 'segment_pill_scan.dart';

void main(List<String> args) {
  final checkOnly = args.contains('--check');

  final appRoot = findSegmentPillAppRoot();
  final repoRoot = findSegmentPillRepoRoot(appRoot);
  final docsDir = Directory('${repoRoot.path}/docs/02_FLUTTER_MIGRATION');
  final featuresRoot = Directory('${appRoot.path}/lib/features');
  final manifestCsv = File(
    '${docsDir.path}/VitTrade-Segment-Pill-Migration-Manifest.csv',
  );

  final result = scanSegmentPillFeatures(featuresRoot);
  final csv = renderSegmentPillManifestCsv(result);

  if (checkOnly) {
    if (!manifestCsv.existsSync()) {
      stderr.writeln('Segment pill migration manifest is missing.');
      stderr.writeln(
        'Run `dart run tool/segment_pill_manifest.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    if (manifestCsv.readAsStringSync() != csv) {
      stderr.writeln('Segment pill migration manifest is stale.');
      stderr.writeln(
        'Run `dart run tool/segment_pill_manifest.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    stdout.writeln(
      'Segment pill migration manifest is current '
      '(${result.interactiveLocals.length} interactive locals, '
      '${result.p0Count} P0).',
    );
    return;
  }

  docsDir.createSync(recursive: true);
  manifestCsv.writeAsStringSync(csv);
  print(
    'Wrote ${manifestCsv.path} '
    '(${result.interactiveLocals.length} interactive locals, '
    '${result.p0Count} P0)',
  );
}
