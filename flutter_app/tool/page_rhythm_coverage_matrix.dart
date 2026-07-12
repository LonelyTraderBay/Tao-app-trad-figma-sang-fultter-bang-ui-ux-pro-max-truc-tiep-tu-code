import 'dart:io';

import 'page_rhythm_layout_registry.dart';

/// Master coverage matrix: audit + screen rollup + layout pattern per route.
void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');

  final auditCsv = File('${docsDir.path}/audits/VitTrade-Page-Rhythm-Audit.csv');
  final screenCsv = File('${docsDir.path}/audits/VitTrade-Page-Rhythm-Screen-Compliance.csv');
  final outCsv = File('${docsDir.path}/audits/VitTrade-Page-Rhythm-Coverage-Matrix.csv');

  if (!auditCsv.existsSync() || !screenCsv.existsSync()) {
    stderr.writeln(
      'Missing audit or screen CSV. Run page_rhythm_audit.dart and '
      'page_rhythm_screen_rollup.dart first.',
    );
    exitCode = 1;
    return;
  }

  final auditByFile = _loadAuditInnerGap(auditCsv);
  final screenRows = _loadScreenCsv(screenCsv);
  final rows = <_MatrixRow>[];

  for (final screen in screenRows) {
    final vpcList = screen.vpcFiles
        .split(';')
        .where((f) => f.isNotEmpty)
        .toList();
    var innerGapViolations = 0;
    for (final vpc in vpcList) {
      innerGapViolations += auditByFile[auditLibKey(vpc)] ?? 0;
    }

    final rules = rulesStatus(
      l1: screen.l1Status,
      l2: screen.l2Status,
      innerGapViolations: innerGapViolations,
      tierStatusValue: screen.tierStatus,
    );

    var exceptionReason = '';
    if (screen.notes.startsWith('exception:')) {
      exceptionReason = screen.notes.split(';').first;
    } else if (screen.notes.contains('debt:inner_gap')) {
      exceptionReason = 'debt:inner_gap';
    } else if (screen.notes.contains('debt:tier_mismatch')) {
      exceptionReason = 'debt:tier_mismatch';
    } else if (screen.l1Status == 'unknown') {
      exceptionReason = 'unmapped';
    }

    rows.add(
      _MatrixRow(
        screenId: screen.screenId,
        route: screen.routePath,
        pageWidget: screen.pageWidget,
        layoutPattern: screen.layoutPattern,
        vpcOwnerFile: screen.vpcOwnerFile.isNotEmpty
            ? screen.vpcOwnerFile
            : vpcList.isNotEmpty
            ? vpcList.first
            : '',
        rulesStatus: rules,
        l1: screen.l1Status,
        l2: screen.l2Status,
        l5: innerGapViolations == 0 ? 'pass' : 'warn',
        l3: screen.l3Status,
        exceptionReason: exceptionReason,
      ),
    );
  }

  rows.sort((a, b) => a.route.compareTo(b.route));
  final csv = _renderCsv(rows);

  if (checkOnly) {
    if (!outCsv.existsSync() || outCsv.readAsStringSync() != csv) {
      stderr.writeln('Coverage matrix CSV is stale.');
      stderr.writeln(
        'Run `dart run tool/page_rhythm_coverage_matrix.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    stdout.writeln('Coverage matrix artifact is current.');
    stdout.write(_summary(rows));
    return;
  }

  docsDir.createSync(recursive: true);
  outCsv.writeAsStringSync(csv);
  stdout.writeln('Wrote ${outCsv.path}');
  stdout.write(_summary(rows));
}

final class _ScreenCsvRow {
  const _ScreenCsvRow({
    required this.screenId,
    required this.routePath,
    required this.pageWidget,
    required this.layoutPattern,
    required this.vpcFiles,
    required this.vpcOwnerFile,
    required this.tierStatus,
    required this.l1Status,
    required this.l2Status,
    required this.l3Status,
    required this.notes,
  });

  final String screenId;
  final String routePath;
  final String pageWidget;
  final String layoutPattern;
  final String vpcFiles;
  final String vpcOwnerFile;
  final String tierStatus;
  final String l1Status;
  final String l2Status;
  final String l3Status;
  final String notes;
}

final class _MatrixRow {
  const _MatrixRow({
    required this.screenId,
    required this.route,
    required this.pageWidget,
    required this.layoutPattern,
    required this.vpcOwnerFile,
    required this.rulesStatus,
    required this.l1,
    required this.l2,
    required this.l5,
    required this.l3,
    required this.exceptionReason,
  });

  final String screenId;
  final String route;
  final String pageWidget;
  final String layoutPattern;
  final String vpcOwnerFile;
  final String rulesStatus;
  final String l1;
  final String l2;
  final String l5;
  final String l3;
  final String exceptionReason;
}

Map<String, int> _loadAuditInnerGap(File file) {
  final map = <String, int>{};
  final lines = file.readAsLinesSync();
  for (var i = 1; i < lines.length; i++) {
    final parts = _parseCsvLine(lines[i]);
    if (parts.length < 10) continue;
    map[parts[1]] = int.tryParse(parts[9]) ?? 0;
  }
  return map;
}

List<_ScreenCsvRow> _loadScreenCsv(File file) {
  final lines = file.readAsLinesSync();
  if (lines.length < 2) return [];
  final rows = <_ScreenCsvRow>[];
  for (var i = 1; i < lines.length; i++) {
    final parts = _parseCsvLine(lines[i]);
    if (parts.length < 12) continue;
    rows.add(
      _ScreenCsvRow(
        screenId: parts[0],
        routePath: parts[1],
        pageWidget: parts[3],
        layoutPattern: parts.length > 5 ? parts[5] : '',
        vpcFiles: parts.length > 6 ? parts[6] : '',
        vpcOwnerFile: parts.length > 7 ? parts[7] : '',
        tierStatus: parts.length > 10 ? parts[10] : '',
        l1Status: parts.length > 11 ? parts[11] : parts[8],
        l2Status: parts.length > 12 ? parts[12] : parts[9],
        l3Status: parts.length > 13 ? parts[13] : parts[10],
        notes: parts.length > 14 ? parts[14] : parts[11],
      ),
    );
  }
  return rows;
}

String _renderCsv(List<_MatrixRow> rows) {
  final buffer = StringBuffer(
    'screen_id,route,page_widget,layout_pattern,vpc_owner_file,'
    'rules_1_6_status,l1,l2,l5,l3,exception_reason\n',
  );
  for (final row in rows) {
    buffer.writeln(
      '${_csv(row.screenId)},${_csv(row.route)},${_csv(row.pageWidget)},'
      '${row.layoutPattern},${_csv(row.vpcOwnerFile)},${row.rulesStatus},'
      '${row.l1},${row.l2},${row.l5},${row.l3},${_csv(row.exceptionReason)}',
    );
  }
  return buffer.toString();
}

String _summary(List<_MatrixRow> rows) {
  final compliant = rows.where((r) => r.exceptionReason.isEmpty && r.l5 == 'pass').length;
  final unknown = rows.where((r) => r.l1 == 'unknown').length;
  final innerGap = rows.where((r) => r.l5 == 'warn').length;
  final l3Manual = rows.where((r) => r.l3 == 'manual').length;
  return 'Coverage matrix: ${rows.length} routes, compliant $compliant, '
      'unknown $unknown, inner gap debt $innerGap, L3 manual $l3Manual.\n';
}

String _csv(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
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
