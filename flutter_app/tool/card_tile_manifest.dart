import 'dart:io';

/// Generates Card Tile migration manifest from audit CSV (pending/done batches).
void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final auditCsv = File('${docsDir.path}/audits/VitTrade-Card-Tile-Audit.csv');
  final manifestCsv = File(
    '${docsDir.path}/audits/VitTrade-Card-Tile-Migration-Manifest.csv',
  );

  if (!auditCsv.existsSync()) {
    stderr.writeln('Run `dart run tool/card_tile_audit.dart` first.');
    exitCode = 1;
    return;
  }

  final auditRows = _parseAuditCsv(auditCsv.readAsStringSync());
  final rows = <_ManifestRow>[];

  for (final audit in auditRows) {
    if (audit.status == 'pass') {
      rows.add(
        _ManifestRow(
          cluster: _cluster(audit.feature),
          file: audit.file,
          suggestedTier: audit.suggestedTier,
          violationType: '-',
          status: 'done',
          batch: 0,
          notes: audit.notes,
        ),
      );
      continue;
    }

    final violationType = audit.status == 'fail'
        ? 'tier_a_strip'
        : audit.notes.contains('fixed_height_baseline')
        ? 'allow_start_baseline'
        : audit.notes.contains('strip_missing_card_tile_padding')
        ? 'padding_token'
        : 'warn_other';

    rows.add(
      _ManifestRow(
        cluster: _cluster(audit.feature),
        file: audit.file,
        suggestedTier: audit.suggestedTier,
        violationType: violationType,
        status: 'pending',
        batch: 0,
        notes: audit.notes,
      ),
    );
  }

  rows.sort((a, b) {
    final cluster = _clusterOrder(
      a.cluster,
    ).compareTo(_clusterOrder(b.cluster));
    if (cluster != 0) return cluster;
    return a.file.compareTo(b.file);
  });

  _assignBatches(rows);

  final csv = _renderCsv(rows);
  if (checkOnly) {
    if (!manifestCsv.existsSync()) {
      stderr.writeln('Card tile migration manifest is missing.');
      exitCode = 1;
      return;
    }
    if (manifestCsv.readAsStringSync() != csv) {
      stderr.writeln('Card tile migration manifest is stale.');
      stderr.writeln(
        'Run `dart run tool/card_tile_manifest.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    final pending = rows.where((r) => r.status == 'pending').length;
    stdout.writeln(
      'Card tile migration manifest is current ($pending pending).',
    );
    return;
  }

  docsDir.createSync(recursive: true);
  manifestCsv.writeAsStringSync(csv);
  final pending = rows.where((r) => r.status == 'pending').length;
  final done = rows.where((r) => r.status == 'done').length;
  stdout.writeln('Wrote ${manifestCsv.path}');
  stdout.writeln('Total: ${rows.length}, done: $done, pending: $pending');
}

class _AuditEntry {
  _AuditEntry({
    required this.feature,
    required this.file,
    required this.suggestedTier,
    required this.status,
    required this.notes,
  });

  final String feature;
  final String file;
  final String suggestedTier;
  final String status;
  final String notes;
}

class _ManifestRow {
  const _ManifestRow({
    required this.cluster,
    required this.file,
    required this.suggestedTier,
    required this.violationType,
    required this.status,
    required this.batch,
    required this.notes,
  });

  final String cluster;
  final String file;
  final String suggestedTier;
  final String violationType;
  final String status;
  final int batch;
  final String notes;
}

List<_AuditEntry> _parseAuditCsv(String csv) {
  final lines = csv.split('\n');
  if (lines.isEmpty) return [];
  final rows = <_AuditEntry>[];
  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;
    final parts = line.split(',');
    if (parts.length < 11) continue;
    rows.add(
      _AuditEntry(
        feature: parts[0],
        file: parts[1],
        suggestedTier: parts[5],
        status: parts[9],
        notes: parts[10],
      ),
    );
  }
  return rows;
}

void _assignBatches(List<_ManifestRow> rows) {
  var batch = 1;
  var inBatch = 0;
  String? lastCluster;
  for (var i = 0; i < rows.length; i++) {
    final row = rows[i];
    if (row.status == 'done') continue;
    if (lastCluster != null && row.cluster != lastCluster && inBatch > 0) {
      if (inBatch < 8) batch++;
      inBatch = 0;
    }
    rows[i] = _ManifestRow(
      cluster: row.cluster,
      file: row.file,
      suggestedTier: row.suggestedTier,
      violationType: row.violationType,
      status: row.status,
      batch: batch,
      notes: row.notes,
    );
    inBatch++;
    if (inBatch >= 8) {
      batch++;
      inBatch = 0;
    }
    lastCluster = row.cluster;
  }
}

String _cluster(String feature) {
  switch (feature) {
    case 'shared':
      return '01_shared';
    case 'home':
      return '02_home';
    case 'markets':
    case 'predictions':
    case 'arena':
      return '03_tab_roots';
    case 'wallet':
    case 'trade':
    case 'p2p':
      return '04_financial';
    case 'earn':
    case 'dca':
    case 'launchpad':
    case 'referral':
      return '05_growth';
    case 'dev':
      return '07_dev';
    default:
      return '06_other';
  }
}

int _clusterOrder(String cluster) {
  const order = {
    '01_shared': 1,
    '02_home': 2,
    '03_tab_roots': 3,
    '04_financial': 4,
    '05_growth': 5,
    '06_other': 6,
    '07_dev': 7,
  };
  return order[cluster] ?? 99;
}

String _renderCsv(List<_ManifestRow> rows) {
  final buffer = StringBuffer(
    'cluster,file,suggested_tier,violation_type,status,batch,notes\n',
  );
  for (final row in rows) {
    buffer.writeln(
      [
        row.cluster,
        row.file,
        row.suggestedTier,
        row.violationType,
        row.status,
        row.batch,
        row.notes,
      ].join(','),
    );
  }
  return buffer.toString();
}

Directory findAppRoot() {
  final dir = Directory.current;
  if (File('${dir.path}/pubspec.yaml').existsSync()) return dir;
  final nested = Directory('${dir.path}/flutter_app');
  if (File('${nested.path}/pubspec.yaml').existsSync()) return nested;
  throw StateError(
    'Run from flutter_app/ or repo root (flutter_app/pubspec.yaml not found).',
  );
}
