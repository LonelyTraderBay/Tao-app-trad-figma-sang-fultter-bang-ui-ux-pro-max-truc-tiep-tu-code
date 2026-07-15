// Shared scan logic for segment-pill audit + manifest tools.
library;

import 'dart:io';

const p0BannedClassNames = {
  '_FilterButton',
  '_FilterTabs',
  '_NetworkFilterTabs',
  '_AuditFilterTabs',
  '_SegmentedTabs',
};

const p1BannedClassNames = {
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

const localClassPattern =
    r'class (_\w*(?:Pill|FilterChip|FilterButton|FilterTabs|ChipButton|SegmentedTabs|TabPill|SegmentButton|FilterPanel|FilterRail)[^\s]*)';

class SegmentPillFileAudit {
  SegmentPillFileAudit({
    required this.module,
    required this.file,
    required this.family,
    required this.localClasses,
  });

  final String module;
  final String file;
  final SegmentPillFamilyHit family;
  final List<String> localClasses;
}

class SegmentPillFamilyHit {
  SegmentPillFamilyHit({
    required this.family,
    required this.variant,
    required this.count,
    required this.heightTier,
    required this.widthMode,
    required this.compliance,
    required this.notes,
  });

  final String family;
  final String variant;
  final int count;
  final String heightTier;
  final String widthMode;
  final String compliance;
  final String notes;
}

class SegmentPillLocalClass {
  SegmentPillLocalClass({
    required this.module,
    required this.file,
    required this.className,
    required this.isInteractive,
  });

  final String module;
  final String file;
  final String className;
  final bool isInteractive;

  String get classId => '$module.$className';
  String get kind => segmentPillClassKind(className);
  String get suggestedTarget => segmentPillSuggestedTarget(className);
  String get migrationBatch => segmentPillMigrationBatch(module);
  String get priority => segmentPillPriority(className);
  String get status => isInteractive ? 'pending' : 'done';
}

class SegmentPillScanResult {
  SegmentPillScanResult({required this.fileRows, required this.localClasses});

  final List<SegmentPillFileAudit> fileRows;
  final List<SegmentPillLocalClass> localClasses;

  Map<String, int> get summary =>
      buildSegmentPillSummary(fileRows, localClasses);

  List<SegmentPillLocalClass> get interactiveLocals =>
      localClasses.where((c) => c.isInteractive).toList();

  int get p0Count => interactiveLocals.where((c) => c.priority == 'P0').length;

  List<SegmentPillLocalClass> get p0Locals =>
      interactiveLocals.where((c) => c.priority == 'P0').toList();

  int get p1Count => interactiveLocals.where((c) => c.priority == 'P1').length;

  List<SegmentPillLocalClass> get p1Locals =>
      interactiveLocals.where((c) => c.priority == 'P1').toList();
}

Directory findSegmentPillAppRoot() {
  var dir = Directory.current;
  if (File('${dir.path}/pubspec.yaml').existsSync()) return dir;
  final nested = Directory('${dir.path}/flutter_app');
  if (File('${nested.path}/pubspec.yaml').existsSync()) return nested;
  throw StateError(
    'Run from flutter_app/ or repo root (flutter_app/pubspec.yaml not found).',
  );
}

Directory findSegmentPillRepoRoot(Directory appRoot) {
  return Directory(appRoot.uri.resolve('..').toFilePath());
}

SegmentPillScanResult scanSegmentPillFeatures(Directory featuresRoot) {
  final fileRows = <SegmentPillFileAudit>[];
  final localClasses = <SegmentPillLocalClass>[];

  for (final entity in featuresRoot.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;

    final rel = entity.path.replaceAll(r'\', '/').split('lib/features/').last;
    final module = rel.split('/').first;
    final src = entity.readAsStringSync();

    for (final match in RegExp(localClassPattern).allMatches(src)) {
      final className = match.group(1)!;
      localClasses.add(
        SegmentPillLocalClass(
          module: module,
          file: rel,
          className: className,
          isInteractive: segmentPillLooksInteractive(src, className),
        ),
      );
    }

    final families = <SegmentPillFamilyHit>[];

    if (src.contains('VitChoicePill(')) {
      final count = 'VitChoicePill('.allMatches(src).length;
      final customHeight = RegExp(
        r'VitChoicePill\([^)]*height:',
        dotAll: true,
      ).hasMatch(src);
      families.add(
        SegmentPillFamilyHit(
          family: 'VitChoicePill',
          variant: 'chip',
          count: count,
          heightTier: customHeight ? 'custom' : '44',
          widthMode: src.contains('fullWidth: true') ? 'full_or_hug' : 'hug',
          compliance: customHeight ? 'warn' : 'pass',
          notes: customHeight ? 'height override' : '',
        ),
      );
    }

    if (src.contains('VitTabBar(')) {
      final count = 'VitTabBar('.allMatches(src).length;
      var variant = 'pill_wrap';
      var height = '~28';
      if (src.contains('VitTabBarVariant.segment')) {
        variant = 'segment';
      } else if (src.contains('VitTabBarVariant.underline')) {
        variant = 'underline';
        height = '54';
      }
      families.add(
        SegmentPillFamilyHit(
          family: 'VitTabBar',
          variant: variant,
          count: count,
          heightTier: height,
          widthMode: variant == 'pill_wrap' ? 'wrap_hug' : 'equal_expanded',
          compliance: variant == 'segment' ? 'pass' : 'review',
          notes: variant == 'underline' ? 'nav underline — different tier' : '',
        ),
      );
    }

    if (src.contains('VitSegmentedTabBar(')) {
      final count = 'VitSegmentedTabBar('.allMatches(src).length;
      families.add(
        SegmentPillFamilyHit(
          family: 'VitSegmentedTabBar',
          variant: 'segment_alias',
          count: count,
          heightTier: '~28',
          widthMode: 'equal_expanded',
          compliance: 'pass',
          notes: 'alias of VitTabBar.segment',
        ),
      );
    }

    if (RegExp(r'VitSegmentedChoice[\.\(<]').hasMatch(src)) {
      final count = RegExp(r'VitSegmentedChoice').allMatches(src).length;
      final variant = src.contains('.buySell') ? 'buySell' : 'primaryAccent';
      families.add(
        SegmentPillFamilyHit(
          family: 'VitSegmentedChoice',
          variant: variant,
          count: count,
          heightTier: '44',
          widthMode: 'equal_expanded',
          compliance: 'pass',
          notes: '',
        ),
      );
    }

    if (src.contains('VitPresetChipRow')) {
      final count = 'VitPresetChipRow'.allMatches(src).length;
      families.add(
        SegmentPillFamilyHit(
          family: 'VitPresetChipRow',
          variant: 'preset_row',
          count: count,
          heightTier: '34',
          widthMode: 'equal_full',
          compliance: 'pass',
          notes: '',
        ),
      );
    }

    if (src.contains('VitFilterChip(')) {
      final count = 'VitFilterChip('.allMatches(src).length;
      final customHeight = RegExp(
        r'VitFilterChip\([^)]*height:',
        dotAll: true,
      ).hasMatch(src);
      families.add(
        SegmentPillFamilyHit(
          family: 'VitFilterChip',
          variant: 'filter_accent',
          count: count,
          heightTier: customHeight ? 'custom' : '44',
          widthMode: 'hug_scroll',
          compliance: customHeight ? 'warn' : 'review',
          notes: 'wrapper over VitChoicePill',
        ),
      );
    }

    if (families.isEmpty) continue;

    final fileLocals = localClasses
        .where((c) => c.file == rel && c.isInteractive)
        .map((c) => c.className)
        .toList();

    for (final family in families) {
      fileRows.add(
        SegmentPillFileAudit(
          module: module,
          file: rel,
          family: family,
          localClasses: fileLocals,
        ),
      );
    }
  }

  fileRows.sort((a, b) {
    final file = a.file.compareTo(b.file);
    if (file != 0) return file;
    return a.family.family.compareTo(b.family.family);
  });

  localClasses.sort((a, b) {
    final file = a.file.compareTo(b.file);
    if (file != 0) return file;
    return a.className.compareTo(b.className);
  });

  return SegmentPillScanResult(fileRows: fileRows, localClasses: localClasses);
}

String renderSegmentPillAuditCsv(SegmentPillScanResult result) {
  final lines = <String>[
    'module,file,call_site_family,variant,count,height_tier_px,width_mode,local_duplicate_classes,compliance,notes',
    for (final row in result.fileRows)
      [
        row.module,
        row.file,
        row.family.family,
        row.family.variant,
        '${row.family.count}',
        row.family.heightTier,
        row.family.widthMode,
        row.localClasses.isEmpty ? '-' : row.localClasses.join('|'),
        row.family.compliance,
        row.family.notes,
      ].map(segmentPillCsv).join(','),
  ];
  return '${lines.join('\n')}\n';
}

String renderSegmentPillManifestCsv(SegmentPillScanResult result) {
  final lines = <String>[
    'class_id,module,file,class_name,kind,suggested_target,migration_batch,priority,status',
    for (final lc in result.interactiveLocals)
      [
        lc.classId,
        lc.module,
        lc.file,
        lc.className,
        lc.kind,
        lc.suggestedTarget,
        lc.migrationBatch,
        lc.priority,
        lc.status,
      ].map(segmentPillCsv).join(','),
  ];
  return '${lines.join('\n')}\n';
}

String renderSegmentPillComplianceReport(SegmentPillScanResult result) {
  final summary = result.summary;
  final byModule = <String, List<SegmentPillFileAudit>>{};
  for (final row in result.fileRows) {
    byModule.putIfAbsent(row.module, () => []).add(row);
  }

  final buffer = StringBuffer()
    ..writeln('# Segment-Pill Compliance Report')
    ..writeln()
    ..writeln('**Tool:** `flutter_app/tool/segment_pill_audit.dart`')
    ..writeln()
    ..writeln('## Executive summary')
    ..writeln()
    ..writeln('| Metric | Count |')
    ..writeln('| --- | ---: |')
    ..writeln('| Audit rows | ${result.fileRows.length} |')
    ..writeln(
      '| Files with shared widgets | ${summary['files_with_shared'] ?? 0} |',
    )
    ..writeln('| Compliance pass | ${summary['pass'] ?? 0} |')
    ..writeln('| Compliance warn | ${summary['warn'] ?? 0} |')
    ..writeln('| Compliance review | ${summary['review'] ?? 0} |')
    ..writeln(
      '| Interactive local classes | ${summary['local_interactive_classes'] ?? 0} |',
    )
    ..writeln('| P0 local classes | ${result.p0Count} |')
    ..writeln()
    ..writeln('## Shared widget call sites')
    ..writeln()
    ..writeln('| Family | Call sites |')
    ..writeln('| --- | ---: |');
  for (final family in [
    'VitTabBar',
    'VitChoicePill',
    'VitSegmentedChoice',
    'VitSegmentedTabBar',
    'VitPresetChipRow',
    'VitFilterChip',
  ]) {
    buffer.writeln('| $family | ${summary[family] ?? 0} |');
  }

  buffer
    ..writeln()
    ..writeln('## Module heat map')
    ..writeln()
    ..writeln('| Module | Audit rows |')
    ..writeln('| --- | ---: |');
  final modules = byModule.keys.toList()..sort();
  for (final module in modules) {
    buffer.writeln('| $module | ${byModule[module]!.length} |');
  }

  buffer
    ..writeln()
    ..writeln('## Migration status')
    ..writeln()
    ..writeln(
      result.interactiveLocals.isEmpty && (summary['warn'] ?? 0) == 0
          ? '**Complete** — CI gate: `dart run tool/segment_pill_audit.dart --check --strict-full`.'
          : '**In progress** — resolve interactive locals and warn rows before `--strict-full`.',
    )
    ..writeln()
    ..writeln('## P0 migration targets')
    ..writeln();
  if (result.p0Locals.isEmpty) {
    buffer.writeln('No P0 local classes remain.');
  } else {
    buffer
      ..writeln('| Module | File | Class | Target |')
      ..writeln('| --- | --- | --- | --- |');
    for (final lc in result.p0Locals) {
      buffer.writeln(
        '| ${lc.module} | `${lc.file}` | `${lc.className}` | ${lc.suggestedTarget} |',
      );
    }
  }

  buffer
    ..writeln()
    ..writeln('## Regenerate')
    ..writeln()
    ..writeln('```bash')
    ..writeln('cd flutter_app')
    ..writeln('dart run tool/segment_pill_audit.dart')
    ..writeln('dart run tool/segment_pill_manifest.dart')
    ..writeln('dart run tool/segment_pill_audit.dart --check --strict-full')
    ..writeln('```');

  return buffer.toString();
}

bool segmentPillLooksInteractive(String src, String className) {
  if (className.contains('StatusPill') ||
      className.contains('MetaChip') ||
      className.contains('TagPill') ||
      className.contains('HeroPill') ||
      className.contains('TinyPill') ||
      className.contains('SmallPill') ||
      className.contains('VestingPill') ||
      className.contains('MaturityPill') ||
      className.contains('ProtocolPill')) {
    return false;
  }
  return src.contains('onTap') ||
      src.contains('onChanged') ||
      src.contains('onSelected') ||
      className.contains('Filter') ||
      className.contains('ChipButton') ||
      className.contains('SegmentedTabs') ||
      className.contains('TabPill') ||
      className.contains('ChoiceChip') ||
      className.contains('SortChip') ||
      p0BannedClassNames.contains(className);
}

String segmentPillClassKind(String name) {
  if (name.contains('Filter')) return 'filter';
  if (name.contains('Segment') || name.contains('Tab')) return 'segment_tab';
  if (name.contains('Chip') || name.contains('Pill')) return 'chip_pill';
  return 'other';
}

String segmentPillSuggestedTarget(String name) {
  if (name.contains('FilterTabs') ||
      name.contains('SegmentedTabs') ||
      name == '_NetworkFilterTabs' ||
      name == '_AuditFilterTabs') {
    return 'VitSegmentedTabBar or VitTabBar.segment';
  }
  if (name.contains('FilterButton') || name.contains('ChipButton')) {
    return 'VitChoicePill or VitFilterChip';
  }
  if (name.contains('FilterChip') || name.contains('SortChip')) {
    return 'VitFilterChip';
  }
  if (name.contains('PillButton')) return 'VitChoicePill';
  return 'VitChoicePill (review)';
}

String segmentPillMigrationBatch(String module) {
  const p0Modules = {'wallet', 'earn', 'trade', 'rewards', 'arena', 'p2p'};
  if (p0Modules.contains(module)) return 'batch-2-core';
  if (module == 'markets' || module == 'dca') return 'batch-3-markets-dca';
  return 'batch-4-long-tail';
}

String segmentPillPriority(String name) {
  if (p0BannedClassNames.contains(name)) return 'P0';
  if (name.contains('FilterButton') ||
      name.contains('SegmentedTabs') ||
      name.contains('FilterTabs')) {
    return 'P0';
  }
  if (name.contains('ChipButton') || name.contains('FilterChip')) return 'P1';
  return 'P2';
}

Map<String, int> buildSegmentPillSummary(
  List<SegmentPillFileAudit> rows,
  List<SegmentPillLocalClass> locals,
) {
  final totals = <String, int>{};
  for (final row in rows) {
    totals[row.family.family] =
        (totals[row.family.family] ?? 0) + row.family.count;
  }
  totals['local_interactive_classes'] = locals
      .where((c) => c.isInteractive)
      .length;
  totals['files_with_shared'] = rows.map((r) => r.file).toSet().length;
  totals['pass'] = rows.where((r) => r.family.compliance == 'pass').length;
  totals['warn'] = rows.where((r) => r.family.compliance == 'warn').length;
  totals['review'] = rows.where((r) => r.family.compliance == 'review').length;
  totals['p0_locals'] = locals
      .where((c) => c.isInteractive && c.priority == 'P0')
      .length;
  return totals;
}

String segmentPillCsv(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

bool segmentPillSourceContainsP0Ban(String source) {
  for (final className in p0BannedClassNames) {
    if (source.contains('class $className')) return true;
  }
  return false;
}

bool segmentPillSourceContainsP1Ban(String source) {
  for (final className in p1BannedClassNames) {
    if (source.contains('class $className')) return true;
  }
  if (source.contains('class _FilterChips<')) return true;
  return false;
}
