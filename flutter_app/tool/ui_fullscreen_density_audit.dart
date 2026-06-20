import 'dart:io';

final class BodyCsvRow {
  const BodyCsvRow(this.fields);

  final Map<String, String> fields;

  String get feature => fields['feature'] ?? '';
  String get route => fields['route'] ?? '';
  String get page => fields['page'] ?? '';
  String get pageFile => fields['page_file'] ?? '';
  String get screenLevel => fields['screen_level'] ?? '';
  String get archetype => fields['archetype'] ?? '';
  String get bodyGrade => fields['body_grade'] ?? '';
  String get sourceFilesText => fields['source_files'] ?? '';
  int get sharedComponentCount => _parseInt(fields['shared_component_count']);
  int get customBodyCount => _parseInt(fields['custom_body_count']);

  List<String> get sourceFiles => sourceFilesText
      .split(';')
      .map((file) => file.trim())
      .where((file) => file.isNotEmpty)
      .toList(growable: false);
}

final class DensityRouteEntry {
  const DensityRouteEntry({
    required this.feature,
    required this.route,
    required this.page,
    required this.pageFile,
    required this.screenLevel,
    required this.archetype,
    required this.bodyGrade,
    required this.densityScore,
    required this.densityPriority,
    required this.densityReason,
    required this.sharedComponentCount,
    required this.customBodyCount,
    required this.relaxedPaddingCount,
    required this.looseGapCount,
    required this.relaxedGapCount,
    required this.largeGapCount,
    required this.maxWidthCount,
    required this.centerCount,
    required this.sectionHeaderCount,
    required this.vitCardCount,
    required this.sourceFiles,
  });

  final String feature;
  final String route;
  final String page;
  final String pageFile;
  final String screenLevel;
  final String archetype;
  final String bodyGrade;
  final int densityScore;
  final String densityPriority;
  final String densityReason;
  final int sharedComponentCount;
  final int customBodyCount;
  final int relaxedPaddingCount;
  final int looseGapCount;
  final int relaxedGapCount;
  final int largeGapCount;
  final int maxWidthCount;
  final int centerCount;
  final int sectionHeaderCount;
  final int vitCardCount;
  final List<String> sourceFiles;
}

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final bodyCsvFile = File(
    '${docsDir.path}/VitTrade-Body-Component-Consistency-Audit.csv',
  );
  final markdownFile = File(
    '${docsDir.path}/VitTrade-UI-Fullscreen-Density-Audit.md',
  );
  final csvFile = File(
    '${docsDir.path}/VitTrade-UI-Fullscreen-Density-Audit.csv',
  );

  if (!bodyCsvFile.existsSync()) {
    stderr.writeln(
      'Missing body component CSV. Run '
      '`dart run tool/body_component_consistency_audit.dart` first.',
    );
    exitCode = 1;
    return;
  }

  final bodyRows = _readBodyRows(bodyCsvFile);
  final entries = _collectDensityEntries(bodyRows, repoRoot)
    ..sort(_compareDensityEntries);
  final markdown = _renderMarkdown(entries);
  final csv = _renderCsv(entries);
  final summary = _renderSummary(entries);

  if (checkOnly) {
    final failures = <String>[];
    if (!markdownFile.existsSync()) {
      failures.add('UI fullscreen density markdown artifact is missing.');
    } else if (markdownFile.readAsStringSync() != markdown) {
      failures.add('UI fullscreen density markdown artifact is stale.');
    }

    if (!csvFile.existsSync()) {
      failures.add('UI fullscreen density CSV artifact is missing.');
    } else if (csvFile.readAsStringSync() != csv) {
      failures.add('UI fullscreen density CSV artifact is stale.');
    }

    if (failures.isNotEmpty) {
      for (final failure in failures) {
        stderr.writeln(failure);
      }
      stderr.writeln(
        'Run `dart run tool/ui_fullscreen_density_audit.dart` '
        'from flutter_app/.',
      );
      exitCode = 1;
      return;
    }

    stdout.write(summary);
    stdout.writeln('UI fullscreen density artifacts are current.');
    return;
  }

  docsDir.createSync(recursive: true);
  markdownFile.writeAsStringSync(markdown);
  csvFile.writeAsStringSync(csv);
  stdout.writeln('Wrote ${markdownFile.path}');
  stdout.writeln('Wrote ${csvFile.path}');
  stdout.write(summary);
}

Directory _findAppRoot() {
  final current = Directory.current;
  if (Directory('${current.path}/lib/app/router/route_groups').existsSync()) {
    return current;
  }

  final nested = Directory('${current.path}/flutter_app');
  if (Directory('${nested.path}/lib/app/router/route_groups').existsSync()) {
    return nested;
  }

  throw StateError('Run from repo root or flutter_app/.');
}

List<BodyCsvRow> _readBodyRows(File csvFile) {
  final lines = csvFile.readAsLinesSync();
  if (lines.isEmpty) return const [];

  final headers = _parseCsvLine(lines.first);
  return [
    for (final line in lines.skip(1))
      if (line.trim().isNotEmpty)
        BodyCsvRow({
          for (var i = 0; i < headers.length; i++)
            headers[i]: i < _parseCsvLine(line).length
                ? _parseCsvLine(line)[i]
                : '',
        }),
  ];
}

List<DensityRouteEntry> _collectDensityEntries(
  List<BodyCsvRow> rows,
  String repoRoot,
) {
  return [
    for (final row in rows)
      _densityEntryFor(row, _sourceBundleFor(row, repoRoot)),
  ];
}

String _sourceBundleFor(BodyCsvRow row, String repoRoot) {
  final buffer = StringBuffer();
  for (final sourceFile in row.sourceFiles) {
    final file = File(
      '$repoRoot${sourceFile.replaceAll('/', Platform.pathSeparator)}',
    );
    if (file.existsSync()) {
      buffer
        ..writeln()
        ..write(file.readAsStringSync());
    }
  }
  return buffer.toString();
}

DensityRouteEntry _densityEntryFor(BodyCsvRow row, String source) {
  final relaxedPadding = _countOccurrences(source, 'VitContentPadding.relaxed');
  final looseGap = _countOccurrences(source, 'VitContentGap.loose');
  final relaxedGap = _countOccurrences(source, 'VitContentGap.relaxed');
  final largeGaps = RegExp(
    r'SizedBox\(height:\s*AppSpacing\.(x8|x9|x10|x11|x12|pageContentGapLoose|pageContentTopRelaxed)',
  ).allMatches(source).length;
  final center = _countOccurrences(source, 'Center(');
  final mainAxisCenter = _countOccurrences(source, 'MainAxisAlignment.center');
  final maxWidth = _countOccurrences(source, 'maxWidth:');
  final constrained = _countOccurrences(source, 'ConstrainedBox');
  final sectionHeader = _countOccurrences(source, 'VitSectionHeader(');
  final cards = _countOccurrences(source, 'VitCard(');

  final gradePenalty = switch (row.bodyGrade) {
    'B' => 8,
    'Tool' => 12,
    _ => 0,
  };
  final customPenalty = row.customBodyCount > row.sharedComponentCount
      ? (row.customBodyCount - row.sharedComponentCount).clamp(0, 10)
      : 0;
  final sparsePenalty =
      sectionHeader + cards < 3 &&
          row.archetype != 'authOnboarding' &&
          row.archetype != 'fullscreenTool'
      ? 4
      : 0;

  final densityScore =
      gradePenalty +
      relaxedPadding * 5 +
      looseGap * 6 +
      relaxedGap * 4 +
      largeGaps * 2 +
      center ~/ 4 +
      mainAxisCenter ~/ 3 +
      maxWidth ~/ 3 +
      constrained +
      customPenalty +
      sparsePenalty;

  return DensityRouteEntry(
    feature: row.feature,
    route: row.route,
    page: row.page,
    pageFile: row.pageFile,
    screenLevel: row.screenLevel,
    archetype: row.archetype,
    bodyGrade: row.bodyGrade,
    densityScore: densityScore,
    densityPriority: _densityPriority(row.bodyGrade, densityScore),
    densityReason: _densityReason(
      bodyGrade: row.bodyGrade,
      sharedComponentCount: row.sharedComponentCount,
      customBodyCount: row.customBodyCount,
      relaxedPadding: relaxedPadding,
      looseGap: looseGap,
      relaxedGap: relaxedGap,
      largeGaps: largeGaps,
      sectionHeader: sectionHeader,
      cards: cards,
    ),
    sharedComponentCount: row.sharedComponentCount,
    customBodyCount: row.customBodyCount,
    relaxedPaddingCount: relaxedPadding,
    looseGapCount: looseGap,
    relaxedGapCount: relaxedGap,
    largeGapCount: largeGaps,
    maxWidthCount: maxWidth,
    centerCount: center,
    sectionHeaderCount: sectionHeader,
    vitCardCount: cards,
    sourceFiles: row.sourceFiles,
  );
}

String _densityPriority(String bodyGrade, int densityScore) {
  if (bodyGrade == 'Tool') return 'P1_fullscreen_tool_visual_qa';
  if (densityScore >= 30) return 'P1_density_refactor';
  if (densityScore >= 10) return 'P2_visual_density_review';
  if (densityScore >= 8) return 'P3_followup_review';
  return 'Pass_or_low_signal';
}

String _densityReason({
  required String bodyGrade,
  required int sharedComponentCount,
  required int customBodyCount,
  required int relaxedPadding,
  required int looseGap,
  required int relaxedGap,
  required int largeGaps,
  required int sectionHeader,
  required int cards,
}) {
  final reasons = <String>[];
  if (bodyGrade != 'A') reasons.add('body $bodyGrade');
  if (relaxedPadding > 0) reasons.add('relaxedPadding=$relaxedPadding');
  if (looseGap > 0) reasons.add('looseGap=$looseGap');
  if (relaxedGap > 0) reasons.add('relaxedGap=$relaxedGap');
  if (largeGaps > 0) reasons.add('largeGaps=$largeGaps');
  if (customBodyCount > sharedComponentCount) {
    reasons.add(
      'custom>$sharedComponentCount by '
      '${customBodyCount - sharedComponentCount}',
    );
  }
  if (sectionHeader + cards < 3) {
    reasons.add('few dense sections/cards=${sectionHeader + cards}');
  }
  if (reasons.isEmpty) return 'no static density signal';
  return reasons.join('; ');
}

String _renderMarkdown(List<DensityRouteEntry> entries) {
  final priorityCounts = _countsBy(
    entries.map((entry) => entry.densityPriority),
  );
  final flagged = entries
      .where((entry) => entry.densityPriority != 'Pass_or_low_signal')
      .toList(growable: false);

  final buffer = StringBuffer()
    ..writeln('# VitTrade UI Fullscreen Density Audit')
    ..writeln()
    ..writeln(
      'Generated from `flutter_app/tool/ui_fullscreen_density_audit.dart`.',
    )
    ..writeln()
    ..writeln('```text')
    ..write(_renderSummary(entries))
    ..writeln('```')
    ..writeln()
    ..writeln('## Priority Counts')
    ..writeln()
    ..writeln('| Priority | Count |')
    ..writeln('| --- | ---: |');

  for (final priority in [
    'P1_density_refactor',
    'P1_fullscreen_tool_visual_qa',
    'P2_visual_density_review',
    'P3_followup_review',
    'Pass_or_low_signal',
  ]) {
    buffer.writeln('| `$priority` | ${priorityCounts[priority] ?? 0} |');
  }

  buffer
    ..writeln()
    ..writeln('## Flagged Routes')
    ..writeln()
    ..writeln(
      '| Priority | Score | Feature | Page | Route | Reason | Page file |',
    )
    ..writeln('| --- | ---: | --- | --- | --- | --- | --- |');

  for (final entry in flagged) {
    final cells = [
      entry.densityPriority,
      '${entry.densityScore}',
      entry.feature,
      entry.page,
      '`${entry.route}`',
      entry.densityReason,
      '`${entry.pageFile}`',
    ].map(_markdownCell).join(' | ');
    buffer.writeln('| $cells |');
  }

  return buffer.toString();
}

String _renderCsv(List<DensityRouteEntry> entries) {
  final buffer = StringBuffer()
    ..writeln(
      [
        'feature',
        'route',
        'page',
        'page_file',
        'screen_level',
        'archetype',
        'body_grade',
        'density_score',
        'density_priority',
        'density_reason',
        'shared_component_count',
        'custom_body_count',
        'relaxed_padding_count',
        'loose_gap_count',
        'relaxed_gap_count',
        'large_gap_count',
        'max_width_count',
        'center_count',
        'section_header_count',
        'vit_card_count',
        'source_files',
      ].join(','),
    );

  for (final entry in entries) {
    buffer.writeln(
      [
        entry.feature,
        entry.route,
        entry.page,
        entry.pageFile,
        entry.screenLevel,
        entry.archetype,
        entry.bodyGrade,
        '${entry.densityScore}',
        entry.densityPriority,
        entry.densityReason,
        '${entry.sharedComponentCount}',
        '${entry.customBodyCount}',
        '${entry.relaxedPaddingCount}',
        '${entry.looseGapCount}',
        '${entry.relaxedGapCount}',
        '${entry.largeGapCount}',
        '${entry.maxWidthCount}',
        '${entry.centerCount}',
        '${entry.sectionHeaderCount}',
        '${entry.vitCardCount}',
        entry.sourceFiles.join(';'),
      ].map(_csvEscape).join(','),
    );
  }

  return buffer.toString();
}

String _renderSummary(List<DensityRouteEntry> entries) {
  final priorityCounts = _countsBy(
    entries.map((entry) => entry.densityPriority),
  );
  return (StringBuffer()
        ..writeln('total_routed_screens=${entries.length}')
        ..writeln(
          'P1_density_refactor=${priorityCounts['P1_density_refactor'] ?? 0}',
        )
        ..writeln(
          'P1_fullscreen_tool_visual_qa='
          '${priorityCounts['P1_fullscreen_tool_visual_qa'] ?? 0}',
        )
        ..writeln(
          'P2_visual_density_review='
          '${priorityCounts['P2_visual_density_review'] ?? 0}',
        )
        ..writeln(
          'P3_followup_review=${priorityCounts['P3_followup_review'] ?? 0}',
        )
        ..writeln(
          'Pass_or_low_signal=${priorityCounts['Pass_or_low_signal'] ?? 0}',
        ))
      .toString();
}

Map<String, int> _countsBy(Iterable<String> values) {
  final counts = <String, int>{};
  for (final value in values) {
    counts.update(value, (count) => count + 1, ifAbsent: () => 1);
  }
  return counts;
}

int _compareDensityEntries(DensityRouteEntry a, DensityRouteEntry b) {
  final score = b.densityScore.compareTo(a.densityScore);
  if (score != 0) return score;
  final feature = a.feature.compareTo(b.feature);
  if (feature != 0) return feature;
  return a.page.compareTo(b.page);
}

List<String> _parseCsvLine(String line) {
  final values = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  var index = 0;

  while (index < line.length) {
    final char = line[index];
    if (char == '"') {
      final isEscapedQuote =
          inQuotes && index + 1 < line.length && line[index + 1] == '"';
      if (isEscapedQuote) {
        buffer.write('"');
        index += 2;
        continue;
      }
      inQuotes = !inQuotes;
      index += 1;
      continue;
    }

    if (char == ',' && !inQuotes) {
      values.add(buffer.toString());
      buffer.clear();
      index += 1;
      continue;
    }

    buffer.write(char);
    index += 1;
  }

  values.add(buffer.toString());
  return values;
}

String _csvEscape(String value) {
  final escaped = value.replaceAll('"', '""');
  if (escaped.contains(',') ||
      escaped.contains('"') ||
      escaped.contains('\n')) {
    return '"$escaped"';
  }
  return escaped;
}

String _markdownCell(String value) {
  return value.replaceAll('|', r'\|').replaceAll('\n', ' ');
}

int _countOccurrences(String source, String needle) {
  if (needle.isEmpty) return 0;
  var count = 0;
  var index = 0;
  while (true) {
    index = source.indexOf(needle, index);
    if (index == -1) return count;
    count += 1;
    index += needle.length;
  }
}

int _parseInt(String? value) => int.tryParse(value ?? '') ?? 0;
