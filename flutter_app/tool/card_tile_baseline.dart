import 'dart:io';

/// Applies `card-tile: allow-start` baseline comments to warn audit rows.
void main(List<String> args) {
  final dryRun = args.contains('--dry-run');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final auditCsv = File(
    '${repoRoot}docs/02_FLUTTER_MIGRATION/VitTrade-Card-Tile-Audit.csv',
  );
  if (!auditCsv.existsSync()) {
    stderr.writeln('Run `dart run tool/card_tile_audit.dart` first.');
    exitCode = 1;
    return;
  }

  const comment =
      '// card-tile: allow-start — fixed surface, not horizontal strip tile';
  var touchedFiles = 0;
  var inserted = 0;

  for (final entry in _parseAuditCsv(auditCsv.readAsStringSync())) {
    if (entry.status != 'warn') continue;
    final path = entry.file.replaceFirst('flutter_app/', '');
    final file = File('${appRoot.path}/$path');
    if (!file.existsSync()) continue;

    var source = file.readAsStringSync();
    var fileChanged = false;
    final blocks = _extractVitCardBlocks(source);

    for (final block in blocks.reversed) {
      final start = source.indexOf(block);
      if (start < 0) continue;
      if (block.contains('card-tile: allow-start') ||
          _hasAllowStartComment(source, start)) {
        continue;
      }
      final params = _vitCardParams(block);
      if (!_hasFixedHeightParams(params)) continue;
      if (_isInHorizontalStripContext(source, start)) continue;

      final lineStart = source.lastIndexOf('\n', start);
      final insertAt = lineStart < 0 ? 0 : lineStart + 1;
      final indent = _lineIndent(source, insertAt);
      final line = '$indent$comment\n';
      source = source.substring(0, insertAt) + line + source.substring(insertAt);
      fileChanged = true;
      inserted++;
    }

    if (fileChanged) {
      touchedFiles++;
      if (!dryRun) {
        file.writeAsStringSync(source);
      }
    }
  }

  stdout.writeln(
    dryRun
        ? 'Dry run: would touch $touchedFiles files ($inserted comments)'
        : 'Applied baseline to $touchedFiles files ($inserted comments)',
  );
}

class _AuditEntry {
  _AuditEntry({required this.file, required this.status});
  final String file;
  final String status;
}

List<_AuditEntry> _parseAuditCsv(String csv) {
  final rows = <_AuditEntry>[];
  final lines = csv.split('\n');
  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;
    final parts = line.split(',');
    if (parts.length < 10) continue;
    rows.add(_AuditEntry(file: parts[1], status: parts[9]));
  }
  return rows;
}

bool _hasAllowStartComment(String source, int vitCardStart) {
  final prefix = source.substring(
    vitCardStart > 400 ? vitCardStart - 400 : 0,
    vitCardStart,
  );
  return prefix.contains('card-tile: allow-start');
}

bool _hasFixedHeightParams(String params) {
  if (RegExp(r'\bheight:\s*').hasMatch(params)) return true;
  if (RegExp(r'minHeight:\s*[^0\s,)]').hasMatch(params)) return true;
  return false;
}

bool _isInHorizontalStripContext(String source, int vitCardStart) {
  final lineStart = source.lastIndexOf('\n', vitCardStart);
  final prefix = source.substring(0, lineStart < 0 ? vitCardStart : lineStart);
  final lines = prefix.split('\n');
  final start = lines.length > 80 ? lines.length - 80 : 0;
  for (var i = lines.length - 1; i >= start; i--) {
    if (lines[i].contains('scrollDirection: Axis.horizontal')) {
      return true;
    }
  }
  return false;
}

String _lineIndent(String source, int offset) {
  final nextNewline = source.indexOf('\n', offset);
  final lineEnd = nextNewline < 0 ? source.length : nextNewline;
  final line = source.substring(offset, lineEnd);
  final match = RegExp(r'^(\s*)').firstMatch(line);
  return match?.group(1) ?? '';
}

List<String> _extractVitCardBlocks(String source) {
  final blocks = <String>[];
  final pattern = RegExp(r'VitCard\s*\(', multiLine: true);
  for (final match in pattern.allMatches(source)) {
    final start = match.start;
    var depth = 0;
    var end = start;
    for (var i = start; i < source.length; i++) {
      final char = source[i];
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
      blocks.add(source.substring(start, end));
    }
  }
  return blocks;
}

String _vitCardParams(String block) {
  final childIndex = block.indexOf('child:');
  if (childIndex <= 0) return block;
  return block.substring(0, childIndex);
}

Directory _findAppRoot() {
  var dir = Directory.current;
  if (File('${dir.path}/pubspec.yaml').existsSync()) return dir;
  final nested = Directory('${dir.path}/flutter_app');
  if (File('${nested.path}/pubspec.yaml').existsSync()) return nested;
  throw StateError(
    'Run from flutter_app/ or repo root (flutter_app/pubspec.yaml not found).',
  );
}
