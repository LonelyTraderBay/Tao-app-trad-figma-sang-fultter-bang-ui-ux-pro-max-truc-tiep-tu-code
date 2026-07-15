import 'dart:io';

/// Applies `rhythm: VitPageRhythm.*` to pending files in manifest batches.
///
/// Usage:
///   dart run tool/page_rhythm_apply.dart --batch 4
///   dart run tool/page_rhythm_apply.dart --from 4 --to 48
///   dart run tool/page_rhythm_apply.dart --all-pending
void main(List<String> args) {
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final manifestCsv = File(
    '${repoRoot}docs/02_FLUTTER_MIGRATION/audits/VitTrade-Page-Rhythm-Migration-Manifest.csv',
  );
  if (!manifestCsv.existsSync()) {
    stderr.writeln('Run dart run tool/page_rhythm_manifest.dart first.');
    exit(1);
  }

  final rows = _readManifest(manifestCsv.readAsStringSync());
  final fromBatch = _intArg(args, '--from');
  final toBatch = _intArg(args, '--to');
  final singleBatch = _intArg(args, '--batch');
  final allPending = args.contains('--all-pending');

  Iterable<_ManifestRow> targets;
  if (allPending) {
    targets = rows.where((r) => r.status == 'pending');
  } else if (singleBatch != null) {
    targets = rows.where(
      (r) => r.batch == singleBatch && r.status == 'pending',
    );
  } else if (fromBatch != null && toBatch != null) {
    targets = rows.where(
      (r) =>
          r.status == 'pending' && r.batch >= fromBatch && r.batch <= toBatch,
    );
  } else {
    stderr.writeln('Usage: --batch N | --from N --to M | --all-pending');
    exit(64);
  }

  var applied = 0;
  var skipped = 0;
  for (final row in targets) {
    final file = File('${appRoot.path}/lib/${row.relative}');
    if (!file.existsSync()) {
      stderr.writeln('Missing: ${file.path}');
      continue;
    }
    final result = _applyRhythm(file, row.tier);
    if (result == _ApplyResult.applied) {
      applied++;
      stdout.writeln('OK ${row.relative} (${row.tier})');
    } else {
      skipped++;
      stdout.writeln('SKIP ${row.relative} ($result)');
    }
  }

  stdout.writeln('Applied: $applied, skipped: $skipped');
}

enum _ApplyResult { applied, alreadyDone, noVitPageContent, ambiguous }

final class _ManifestRow {
  const _ManifestRow({
    required this.batch,
    required this.relative,
    required this.tier,
    required this.status,
  });

  final int batch;
  final String relative;
  final String tier;
  final String status;
}

List<_ManifestRow> _readManifest(String csv) {
  final lines = csv.split('\n').where((l) => l.trim().isNotEmpty).toList();
  final rows = <_ManifestRow>[];
  for (var i = 1; i < lines.length; i++) {
    final parts = _parseCsvLine(lines[i]);
    if (parts.length < 5) continue;
    final file = parts[2];
    final relative = file.replaceFirst('flutter_app/lib/', '');
    rows.add(
      _ManifestRow(
        batch: int.tryParse(parts[0]) ?? 0,
        relative: relative,
        tier: parts[3],
        status: parts[4],
      ),
    );
  }
  return rows;
}

List<String> _parseCsvLine(String line) {
  final parts = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (inQuotes) {
      if (char == '"' && i + 1 < line.length && line[i + 1] == '"') {
        buffer.write('"');
        i++;
      } else if (char == '"') {
        inQuotes = false;
      } else {
        buffer.write(char);
      }
    } else if (char == '"') {
      inQuotes = true;
    } else if (char == ',') {
      parts.add(buffer.toString());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }
  parts.add(buffer.toString());
  return parts;
}

int? _intArg(List<String> args, String name) {
  final index = args.indexOf(name);
  if (index < 0 || index + 1 >= args.length) return null;
  return int.tryParse(args[index + 1]);
}

_ApplyResult _applyRhythm(File file, String tier) {
  var source = file.readAsStringSync();
  if (!source.contains('VitPageContent(')) {
    return _ApplyResult.noVitPageContent;
  }
  if (!RegExp(r'VitPageContent\(\s*\n?\s*(?!rhythm:)').hasMatch(source)) {
    return _ApplyResult.alreadyDone;
  }

  final isPart = source.trimLeft().startsWith('part of');
  if (!isPart &&
      !source.contains(
        "import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';",
      )) {
    final importAnchor = _findImportAnchor(source);
    if (importAnchor == null) return _ApplyResult.ambiguous;
    source = source.replaceFirst(
      importAnchor,
      "$importAnchor\nimport 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';",
    );
  }

  var appliedAny = false;
  for (var pass = 0; pass < 20; pass++) {
    final multiline = RegExp(
      r'VitPageContent\(\s*\n(\s+)(?!rhythm:)',
    ).firstMatch(source);
    if (multiline != null) {
      final indent = multiline.group(1)!;
      source = source.replaceRange(
        multiline.start,
        multiline.end,
        'VitPageContent(\n${indent}rhythm: VitPageRhythm.$tier,\n$indent',
      );
      appliedAny = true;
      continue;
    }

    final inline = RegExp(r'VitPageContent\(\s*(?!rhythm:)').firstMatch(source);
    if (inline == null) break;
    source = source.replaceRange(
      inline.start,
      inline.end,
      'VitPageContent(rhythm: VitPageRhythm.$tier, ',
    );
    appliedAny = true;
  }

  if (!appliedAny) return _ApplyResult.ambiguous;

  file.writeAsStringSync(source);
  return _ApplyResult.applied;
}

String? _findImportAnchor(String source) {
  final themeImport = RegExp(
    r"import 'package:vit_trade_flutter/app/theme/[^']+';",
  ).firstMatch(source);
  if (themeImport != null) return themeImport.group(0);

  final vitImport = RegExp(
    r"import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';",
  ).firstMatch(source);
  return vitImport?.group(0);
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
