import 'dart:io';

final class RouteEntry {
  const RouteEntry({
    required this.file,
    required this.line,
    required this.path,
    required this.name,
    required this.classification,
    required this.evidence,
  });

  final String file;
  final int line;
  final String path;
  final String name;
  final String classification;
  final String evidence;
}

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final outputFile = File(
    '${repoRoot}docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md',
  );

  final entries = _collectRouteEntries(appRoot);
  final content = _renderMarkdown(
    entries,
    generatedDate: _formatGeneratedDate(DateTime.now()),
  );

  if (checkOnly) {
    if (!outputFile.existsSync()) {
      stderr.writeln('Route coverage artifact is missing: ${outputFile.path}');
      exitCode = 1;
      return;
    }
    final current = outputFile.readAsStringSync();
    if (_withoutGeneratedDate(current) != _withoutGeneratedDate(content)) {
      stderr.writeln(
        'Route coverage artifact is stale. Run '
        '`dart run tool/route_coverage_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }
    stdout.writeln('Route coverage artifact is current.');
    return;
  }

  outputFile.writeAsStringSync(content);
  stdout.writeln('Wrote ${outputFile.path}');
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

List<RouteEntry> _collectRouteEntries(Directory appRoot) {
  final routeGroups = Directory('${appRoot.path}/lib/app/router/route_groups');
  final entries = <RouteEntry>[];

  for (final file
      in routeGroups.listSync().whereType<File>().where((file) {
        return file.path.endsWith('.dart');
      }).toList()..sort(
        (a, b) => a.path
            .replaceAll(r'\', '/')
            .compareTo(b.path.replaceAll(r'\', '/')),
      )) {
    final text = file.readAsStringSync();
    final relativeFile = file.path
        .replaceAll('\\', '/')
        .split('/flutter_app/')
        .last;

    entries.addAll(_parseDirectRoutes(text, relativeFile));
    entries.addAll(_parsePlaceholderCalls(text, relativeFile));
  }

  entries.sort((a, b) {
    final fileCompare = a.file.compareTo(b.file);
    if (fileCompare != 0) return fileCompare;
    return a.line.compareTo(b.line);
  });
  return entries;
}

List<RouteEntry> _parseDirectRoutes(String text, String file) {
  final entries = <RouteEntry>[];
  var index = 0;

  while (true) {
    final start = text.indexOf('GoRoute(', index);
    if (start == -1) break;

    final blockEnd = _findBalancedEnd(text, start + 'GoRoute'.length);
    if (blockEnd == -1) break;

    final block = text.substring(start, blockEnd + 1);
    index = blockEnd + 1;

    if (RegExp(r'path:\s*path\b').hasMatch(block)) {
      continue;
    }

    final path = _extractNamedArgument(block, 'path') ?? '-';
    final name = _extractNamedArgument(block, 'name') ?? '-';
    final classification = _classifyDirectRoute(block);
    final evidence = _directRouteEvidence(block, classification);

    entries.add(
      RouteEntry(
        file: file,
        line: _lineNumber(text, start),
        path: path,
        name: name,
        classification: classification,
        evidence: evidence,
      ),
    );
  }

  return entries;
}

List<RouteEntry> _parsePlaceholderCalls(String text, String file) {
  final entries = <RouteEntry>[];
  var index = 0;

  while (true) {
    final start = text.indexOf('_placeholderRoute(', index);
    if (start == -1) break;

    final prefixStart = start - 12 < 0 ? 0 : start - 12;
    final prefix = text.substring(prefixStart, start);
    final blockEnd = _findBalancedEnd(text, start + '_placeholderRoute'.length);
    if (blockEnd == -1) break;

    final block = text.substring(start, blockEnd + 1);
    index = blockEnd + 1;

    if (prefix.contains('GoRoute ')) {
      continue;
    }

    final args = _splitTopLevel(
      block.substring('_placeholderRoute('.length, block.length - 1),
    );
    final path = args.isNotEmpty ? args.first.trim() : '-';
    final title = args.length > 1 ? args[1].trim() : '-';

    entries.add(
      RouteEntry(
        file: file,
        line: _lineNumber(text, start),
        path: path,
        name: '-',
        classification: 'placeholder',
        evidence: 'title: $title',
      ),
    );
  }

  return entries;
}

String _classifyDirectRoute(String block) {
  if (block.contains('redirect:')) return 'redirect_alias';
  if (block.contains('_BottomNavRouteSkeleton')) return 'skeleton';
  if (block.contains('_UnportedRoutePlaceholder')) return 'placeholder_helper';
  return 'real_page';
}

String _directRouteEvidence(String block, String classification) {
  if (classification == 'redirect_alias') {
    return _extractRedirectTarget(block) ?? 'redirect';
  }

  final widget = RegExp(
    r'=>\s*(?:const\s+)?([A-Za-z_]\w*)\s*\(',
  ).firstMatch(block);
  if (widget != null) return widget.group(1)!;

  final constructor = RegExp(r'return\s+([A-Za-z_]\w*)\s*\(').firstMatch(block);
  if (constructor != null) return constructor.group(1)!;

  return classification;
}

String? _extractRedirectTarget(String block) {
  final match = RegExp(
    r'redirect:\s*\([^)]*\)\s*=>\s*([^,\n]+)',
  ).firstMatch(block);
  return match?.group(1)?.trim().replaceFirst(RegExp(r'\)+$'), '');
}

String? _extractNamedArgument(String block, String name) {
  final match = RegExp('$name:\\s*([^,\\n]+)').firstMatch(block);
  return match?.group(1)?.trim();
}

int _findBalancedEnd(String text, int openParenIndex) {
  var depth = 0;
  var inSingleQuote = false;
  var inDoubleQuote = false;
  var escaping = false;

  for (var i = openParenIndex; i < text.length; i++) {
    final char = text[i];

    if (escaping) {
      escaping = false;
      continue;
    }

    if ((inSingleQuote || inDoubleQuote) && char == r'\') {
      escaping = true;
      continue;
    }

    if (!inDoubleQuote && char == "'") {
      inSingleQuote = !inSingleQuote;
      continue;
    }

    if (!inSingleQuote && char == '"') {
      inDoubleQuote = !inDoubleQuote;
      continue;
    }

    if (inSingleQuote || inDoubleQuote) {
      continue;
    }

    if (char == '(') {
      depth++;
    } else if (char == ')') {
      depth--;
      if (depth == 0) return i;
    }
  }

  return -1;
}

List<String> _splitTopLevel(String input) {
  final parts = <String>[];
  final buffer = StringBuffer();
  var depth = 0;
  var inSingleQuote = false;
  var inDoubleQuote = false;
  var escaping = false;

  for (var i = 0; i < input.length; i++) {
    final char = input[i];

    if (escaping) {
      buffer.write(char);
      escaping = false;
      continue;
    }

    if ((inSingleQuote || inDoubleQuote) && char == r'\') {
      buffer.write(char);
      escaping = true;
      continue;
    }

    if (!inDoubleQuote && char == "'") {
      inSingleQuote = !inSingleQuote;
      buffer.write(char);
      continue;
    }

    if (!inSingleQuote && char == '"') {
      inDoubleQuote = !inDoubleQuote;
      buffer.write(char);
      continue;
    }

    if (!inSingleQuote && !inDoubleQuote) {
      if (char == '(' || char == '[' || char == '{') depth++;
      if (char == ')' || char == ']' || char == '}') depth--;
      if (char == ',' && depth == 0) {
        parts.add(buffer.toString());
        buffer.clear();
        continue;
      }
    }

    buffer.write(char);
  }

  final tail = buffer.toString();
  if (tail.trim().isNotEmpty) parts.add(tail);
  return parts;
}

int _lineNumber(String text, int index) {
  return '\n'.allMatches(text.substring(0, index)).length + 1;
}

String _formatGeneratedDate(DateTime dateTime) {
  final year = dateTime.year.toString().padLeft(4, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

String _withoutGeneratedDate(String markdown) {
  return markdown.replaceFirst(
    RegExp(r'^Generated: .+$', multiLine: true),
    'Generated: <ignored>',
  );
}

String _renderMarkdown(
  List<RouteEntry> entries, {
  required String generatedDate,
}) {
  final byClassification = <String, int>{};
  for (final entry in entries) {
    byClassification.update(
      entry.classification,
      (count) => count + 1,
      ifAbsent: () => 1,
    );
  }

  final buffer = StringBuffer()
    ..writeln('# Flutter Route Coverage Truth Table')
    ..writeln()
    ..writeln('Generated: $generatedDate')
    ..writeln()
    ..writeln(
      'This artifact is generated by '
      '`flutter_app/tool/route_coverage_audit.dart`. It classifies static '
      'router declarations so route count cannot be mistaken for completed '
      'screen count.',
    )
    ..writeln()
    ..writeln('## Summary')
    ..writeln()
    ..writeln('| Classification | Count |')
    ..writeln('| --- | ---: |');

  for (final classification in byClassification.keys.toList()..sort()) {
    buffer.writeln(
      '| `${_escape(classification)}` | ${byClassification[classification]} |',
    );
  }

  buffer
    ..writeln('| `total` | ${entries.length} |')
    ..writeln()
    ..writeln('## Classification Rules')
    ..writeln()
    ..writeln('| Classification | Meaning |')
    ..writeln('| --- | --- |')
    ..writeln(
      '| `real_page` | Route has a real builder target and is not a static redirect or placeholder helper. |',
    )
    ..writeln(
      '| `redirect_alias` | Route redirects to another canonical route. |',
    )
    ..writeln(
      '| `placeholder` | Route is created through `_placeholderRoute(...)`. |',
    )
    ..writeln(
      '| `placeholder_helper` | Internal helper constructor for placeholder routes; not counted when the helper uses dynamic `path`. |',
    )
    ..writeln(
      '| `skeleton` | Shell or bottom-nav skeleton route without feature content. |',
    )
    ..writeln()
    ..writeln('## Route Table')
    ..writeln()
    ..writeln('| File | Line | Path | Name | Classification | Evidence |')
    ..writeln('| --- | ---: | --- | --- | --- | --- |');

  for (final entry in entries) {
    buffer.writeln(
      '| `${_escape(entry.file)}` | ${entry.line} | '
      '`${_escape(entry.path)}` | `${_escape(entry.name)}` | '
      '`${_escape(entry.classification)}` | `${_escape(entry.evidence)}` |',
    );
  }

  return buffer.toString();
}

String _escape(String value) {
  return value.replaceAll('|', r'\|').replaceAll('\n', ' ');
}
