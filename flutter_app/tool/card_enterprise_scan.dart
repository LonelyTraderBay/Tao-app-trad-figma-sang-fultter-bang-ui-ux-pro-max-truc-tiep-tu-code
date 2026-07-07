import 'dart:io';

/// One-off deep scan for enterprise card compliance gaps (stdout report).
void main() {
  final root = Directory('lib');
  final taskPattern = <String>[];
  final legacyMin = <String>[];
  final fixedNoAllow = <String>[];
  var vitCardFiles = 0;
  var allowStartFiles = 0;

  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final rel = entity.path.replaceAll('\\', '/');
    if (rel.endsWith('vit_card.dart')) continue;

    final source = entity.readAsStringSync();
    if (!source.contains('VitCard(')) continue;
    vitCardFiles++;

    if (source.contains('card-tile: allow-start')) {
      allowStartFiles++;
    }

    if ((source.contains('Nhiệm vụ') || source.contains('task.progress')) &&
        source.contains('_ProgressBar') &&
        source.contains('VitCard(') &&
        !source.contains('VitTaskCard(') &&
        !rel.contains('vit_task_card')) {
      taskPattern.add(rel);
    }

    if (source.contains('buttonHero + AppSpacing.x7 + AppSpacing.x5')) {
      legacyMin.add(rel);
    }

    for (final block in _extractVitCardBlocks(source)) {
      final start = source.indexOf(block);
      final params = _vitCardParams(block);
      final fixed = _hasFixedHeightParams(params);
      if (!fixed) continue;

      final allow = block.contains('card-tile: allow-start') ||
          _hasAllowStartComment(source, start);
      final centered =
          params.contains('contentAlign: VitCardContentAlign.center');
      if (!allow && !centered) {
        fixedNoAllow.add(rel);
        break;
      }
    }
  }

  stdout.writeln('=== ENTERPRISE CARD DEEP SCAN ===');
  stdout.writeln('VitCard files: $vitCardFiles');
  stdout.writeln('allow-start documented: $allowStartFiles');
  stdout.writeln(
    'fixed-height without allow-start AND without center: '
    '${fixedNoAllow.toSet().length}',
  );
  for (final path in fixedNoAllow.toSet()) {
    stdout.writeln('  FIXED_NO_CENTER: $path');
  }
  stdout.writeln('legacy task minHeight (buttonHero+x7+x5): ${legacyMin.length}');
  for (final path in legacyMin) {
    stdout.writeln('  LEGACY_MIN: $path');
  }
  stdout.writeln('task-row pattern without VitTaskCard: ${taskPattern.length}');
  for (final path in taskPattern) {
    stdout.writeln('  TASK_PATTERN: $path');
  }
}

bool _hasAllowStartComment(String source, int vitCardStart) {
  final scanStart = vitCardStart > 400 ? vitCardStart - 400 : 0;
  return source.substring(scanStart, vitCardStart).contains(
        'card-tile: allow-start',
      );
}

bool _hasFixedHeightParams(String params) {
  if (RegExp(r'\bheight:\s*').hasMatch(params)) return true;
  if (RegExp(r'minHeight:\s*[^0\s,)]').hasMatch(params)) return true;
  return false;
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
