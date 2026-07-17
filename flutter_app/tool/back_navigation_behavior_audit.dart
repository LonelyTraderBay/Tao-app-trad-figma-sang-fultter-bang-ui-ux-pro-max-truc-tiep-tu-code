import 'dart:io';

final class BackNavigationEntry {
  const BackNavigationEntry({
    required this.file,
    required this.line,
    required this.owner,
    required this.sourceWidget,
    required this.classification,
    required this.mode,
    required this.fallback,
    required this.highRisk,
    required this.issue,
    required this.notes,
  });

  final String file;
  final int line;
  final String owner;
  final String sourceWidget;
  final String classification;
  final String mode;
  final String fallback;
  final bool highRisk;
  final String issue;
  final String notes;

  bool get hasStrictIssue => issue != '-';
}

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final strict = args.contains('--strict');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final markdownFile = File(
    '${docsDir.path}/audits/VitTrade-Header-Back-Navigation-Behavior-Audit.md',
  );
  final csvFile = File(
    '${docsDir.path}/audits/VitTrade-Header-Back-Navigation-Behavior-Audit.csv',
  );

  final entries = _collectBackNavigationEntries(appRoot, repoRoot);
  final markdown = _renderMarkdown(entries);
  final csv = _renderCsv(entries);
  final summary = _renderSummary(entries);

  if (checkOnly) {
    final failures = <String>[];
    if (!markdownFile.existsSync()) {
      failures.add('Back navigation behavior markdown artifact is missing.');
    } else if (markdownFile.readAsStringSync() != markdown) {
      failures.add('Back navigation behavior markdown artifact is stale.');
    }

    if (!csvFile.existsSync()) {
      failures.add('Back navigation behavior CSV artifact is missing.');
    } else if (csvFile.readAsStringSync() != csv) {
      failures.add('Back navigation behavior CSV artifact is stale.');
    }

    if (strict) {
      final strictIssues = entries.where((entry) => entry.hasStrictIssue);
      if (strictIssues.isNotEmpty) {
        failures.add(
          'Strict back navigation behavior guardrail found '
          '${strictIssues.length} violation(s).',
        );
      }
    }

    if (failures.isNotEmpty) {
      for (final failure in failures) {
        stderr.writeln(failure);
      }
      stderr.writeln(
        'Run `dart run tool/back_navigation_behavior_audit.dart` '
        'from flutter_app/.',
      );
      exitCode = 1;
      return;
    }

    stdout.write(summary);
    stdout.writeln('Back navigation behavior artifacts are current.');
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

List<BackNavigationEntry> _collectBackNavigationEntries(
  Directory appRoot,
  String repoRoot,
) {
  final entries = <BackNavigationEntry>[];
  final files =
      Directory('${appRoot.path}/lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList()
        ..sort(
          (a, b) => a.path
              .replaceAll(r'\', '/')
              .compareTo(b.path.replaceAll(r'\', '/')),
        );

  for (final file in files) {
    final relativeFile = _relativePath(file, repoRoot);
    final source = file.readAsStringSync();

    entries.addAll(
      _collectWidgetBackEntries(
        source: source,
        relativeFile: relativeFile,
        widgetName: 'VitHeader',
      ),
    );
    entries.addAll(
      _collectWidgetBackEntries(
        source: source,
        relativeFile: relativeFile,
        widgetName: 'VitTopChrome',
      ),
    );

    if (relativeFile.endsWith('pair_detail_header_widgets.dart')) {
      entries.addAll(_collectPairHeaderBackEntries(source, relativeFile));
    }
  }

  entries.sort((a, b) {
    final fileCompare = a.file.compareTo(b.file);
    if (fileCompare != 0) return fileCompare;
    return a.line.compareTo(b.line);
  });
  return entries;
}

List<BackNavigationEntry> _collectWidgetBackEntries({
  required String source,
  required String relativeFile,
  required String widgetName,
}) {
  final entries = <BackNavigationEntry>[];
  var searchIndex = 0;
  while (true) {
    final start = source.indexOf('$widgetName(', searchIndex);
    if (start == -1) break;

    final openParen = source.indexOf('(', start);
    final end = _findBalancedEnd(source, openParen);
    if (end == -1) break;
    searchIndex = end + 1;

    final block = source.substring(start, end + 1);
    final showBack = _extractTopLevelArgument(block, 'showBack');
    // A bare-identifier/expression argument (e.g. `showBack: showBack`
    // forwarding a constructor parameter) is not a literal `false`, so it
    // must still be audited rather than silently skipped — only a literal
    // `false` means no back button is ever shown at this call site.
    if (showBack == null || showBack == 'false') continue;

    final onBack = _extractTopLevelArgument(block, 'onBack');
    entries.add(
      _buildEntry(
        source: source,
        block: block,
        relativeFile: relativeFile,
        line: _lineNumber(source, start),
        owner: _nearestClassName(source, start),
        sourceWidget: widgetName,
        callback: onBack,
      ),
    );
  }
  return entries;
}

List<BackNavigationEntry> _collectPairHeaderBackEntries(
  String source,
  String relativeFile,
) {
  final pairHeader = _extractClassBlock(source, '_PairHeader');
  if (pairHeader == null) return const [];
  final callback = RegExp(
    r'onPressed:\s*([^,\n\)]+)',
  ).firstMatch(pairHeader.block)?.group(1);
  return [
    _buildEntry(
      source: source,
      block: pairHeader.block,
      relativeFile: relativeFile,
      line: pairHeader.line,
      owner: '_PairHeader',
      sourceWidget: 'VitHeaderActionButton',
      callback: callback,
    ),
  ];
}

BackNavigationEntry _buildEntry({
  required String source,
  required String block,
  required String relativeFile,
  required int line,
  required String owner,
  required String sourceWidget,
  required String? callback,
}) {
  if (callback == null || callback.trim().isEmpty) {
    return BackNavigationEntry(
      file: relativeFile,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      classification: 'missing_on_back',
      mode: 'none',
      fallback: '-',
      highRisk: _isHighRisk(relativeFile, source),
      issue: 'visible_back_without_onBack',
      notes: 'Visible header back has no callback.',
    );
  }

  final callbackSource = _resolveCallbackSource(source, callback);
  final combined = '$block\n$callback\n$callbackSource';
  final highRisk = _isHighRisk(relativeFile, combined);
  final usesBackPath = RegExp(r'\b(?:widget\.)?backPath\b').hasMatch(combined);
  final usesSafeBackPath = combined.contains('resolveSafeBackPath(');
  final usesHelper = combined.contains('goBackOrFallback(');
  final usesHistoryMode = combined.contains('BackNavigationMode.historyThen');
  final usesCanPop = combined.contains('context.canPop()');
  final usesPop = combined.contains('context.pop()');
  final usesGo = combined.contains('context.go(');
  final delegated = _isDelegatedCallback(callback);
  final fallback = _extractFallback(combined);

  if (usesBackPath && !usesSafeBackPath) {
    return BackNavigationEntry(
      file: relativeFile,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      classification: 'unsafe_back_path',
      mode: 'dynamic_unvalidated',
      fallback: fallback,
      highRisk: highRisk,
      issue: 'backPath_used_without_resolveSafeBackPath',
      notes:
          'Dynamic backPath must be decoded and validated before navigation.',
    );
  }

  if (usesBackPath && usesSafeBackPath) {
    return BackNavigationEntry(
      file: relativeFile,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      classification: 'dynamic_back_path',
      mode: usesHistoryMode ? 'history_then_fallback' : 'parent_route_only',
      fallback: fallback,
      highRisk: highRisk,
      issue: '-',
      notes: 'Dynamic backPath is resolved through shared validation.',
    );
  }

  if (usesHelper) {
    return BackNavigationEntry(
      file: relativeFile,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      classification: usesHistoryMode
          ? 'history_then_fallback'
          : 'parent_route_only',
      mode: usesHistoryMode ? 'history_then_fallback' : 'parent_route_only',
      fallback: fallback,
      highRisk: highRisk,
      issue: '-',
      notes: 'Uses shared back-navigation helper.',
    );
  }

  if (usesCanPop && usesPop && usesGo) {
    return BackNavigationEntry(
      file: relativeFile,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      classification: 'history_then_fallback',
      mode: 'history_then_fallback',
      fallback: fallback,
      highRisk: highRisk,
      issue: '-',
      notes: 'History pop is paired with an explicit fallback route.',
    );
  }

  if (usesPop && !usesGo) {
    return BackNavigationEntry(
      file: relativeFile,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      classification: 'unknown',
      mode: 'history_only',
      fallback: '-',
      highRisk: highRisk,
      issue: highRisk
          ? 'high_risk_history_pop_without_fallback'
          : 'history_pop_without_fallback',
      notes: 'Routed screen uses pop without a fallback route.',
    );
  }

  if (usesGo) {
    return BackNavigationEntry(
      file: relativeFile,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      classification: 'parent_route_only',
      mode: 'parent_route_only',
      fallback: fallback,
      highRisk: highRisk,
      issue: '-',
      notes: 'Back goes to an explicit parent route.',
    );
  }

  if (delegated) {
    return BackNavigationEntry(
      file: relativeFile,
      line: line,
      owner: owner,
      sourceWidget: sourceWidget,
      classification: 'parent_route_only',
      mode: 'delegated_by_owner',
      fallback: 'delegated_callback',
      highRisk: highRisk,
      issue: '-',
      notes: 'Reusable widget receives an owner-provided back callback.',
    );
  }

  return BackNavigationEntry(
    file: relativeFile,
    line: line,
    owner: owner,
    sourceWidget: sourceWidget,
    classification: 'unknown',
    mode: 'unknown',
    fallback: fallback,
    highRisk: highRisk,
    issue: 'unable_to_classify_back_behavior',
    notes: 'Back callback does not match a known safe pattern.',
  );
}

bool _isDelegatedCallback(String callback) {
  final trimmed = callback.trim();
  return trimmed == 'onBack' ||
      trimmed == 'widget.onBack' ||
      trimmed.startsWith('onBack,') ||
      RegExp(r'^\(\)\s*=>\s*onBack\(').hasMatch(trimmed);
}

String _resolveCallbackSource(String source, String callback) {
  final names = <String>{};
  for (final match in RegExp(r'\b_[A-Za-z]\w*\b').allMatches(callback)) {
    names.add(match.group(0)!);
  }
  if (names.isEmpty) return '';

  final buffer = StringBuffer();
  for (final name in names) {
    final method = _extractMethodBlock(source, name);
    if (method != null) buffer.writeln(method);
  }
  return buffer.toString();
}

String? _extractMethodBlock(String source, String name) {
  final pattern = RegExp(
    r'(?:static\s+)?(?:Future<[^>]+>|void|String|bool|int|double)\s+' +
        RegExp.escape(name) +
        r'\s*\([^)]*\)\s*(?:async\s*)?\{',
  );
  final match = pattern.firstMatch(source);
  if (match == null) return null;
  final openBrace = source.indexOf('{', match.start);
  final end = _findBalancedBraceEnd(source, openBrace);
  if (end == -1) return null;
  return source.substring(match.start, end + 1);
}

String _extractFallback(String source) {
  for (final pattern in [
    RegExp(r'fallbackPath:\s*([^,\n\)]+)'),
    RegExp(r'context\.go\(([^;\n]+)\)'),
  ]) {
    final match = pattern.firstMatch(source);
    if (match != null) {
      return match.group(1)!.trim().replaceAll('\n', ' ');
    }
  }
  if (source.contains('delegated_callback')) return 'delegated_callback';
  return '-';
}

bool _isHighRisk(String file, String source) {
  final value = '$file\n$source'.toLowerCase();
  return const [
    'withdraw',
    'address_add',
    'address-book/add',
    'token_approval',
    'p2p_order',
    'proof',
    'cancel',
    'dispute',
    'escrow',
    'leverage',
    'order_receipt',
    'copy_configuration',
    'confirmation',
    'claim',
    'security',
    'api_key',
    'kyc',
  ].any(value.contains);
}

String _renderMarkdown(List<BackNavigationEntry> entries) {
  final classificationCounts = _countsBy(
    entries.map((entry) => entry.classification),
  );
  final issueCounts = _countsBy(
    entries.expand(
      (entry) => entry.issue == '-' ? const <String>[] : [entry.issue],
    ),
  );
  final modalCounts = _readModalBaselineCounts();
  final strictIssues = entries.where((entry) => entry.hasStrictIssue).length;

  final buffer = StringBuffer()
    ..writeln('# VitTrade Header Back Navigation Behavior Audit')
    ..writeln()
    ..writeln(
      'Generated from `flutter_app/tool/back_navigation_behavior_audit.dart`.',
    )
    ..writeln()
    ..writeln('```text')
    ..writeln('visible_header_back_entries=${entries.length}')
    ..writeln('strict_back_issues=$strictIssues')
    ..writeln(
      'high_risk_entries=${entries.where((entry) => entry.highRisk).length}',
    )
    ..writeln('modal_close_baseline=${modalCounts['modal_close'] ?? 0}')
    ..writeln(
      'sheet_result_baseline=${modalCounts['sheet_result_return'] ?? 0}',
    )
    ..writeln('```')
    ..writeln()
    ..writeln('## Classification Counts')
    ..writeln()
    ..writeln('| Classification | Count |')
    ..writeln('| --- | ---: |');

  for (final entry in _sortedCounts(classificationCounts)) {
    buffer.writeln('| ${entry.key} | ${entry.value} |');
  }

  buffer
    ..writeln()
    ..writeln('## Strict Issue Counts')
    ..writeln()
    ..writeln('| Issue | Count |')
    ..writeln('| --- | ---: |');
  if (issueCounts.isEmpty) {
    buffer.writeln('| none | 0 |');
  } else {
    for (final entry in _sortedCounts(issueCounts)) {
      buffer.writeln('| ${entry.key} | ${entry.value} |');
    }
  }

  buffer
    ..writeln()
    ..writeln('## Modal And Sheet Baseline')
    ..writeln()
    ..writeln('| Classification | Count |')
    ..writeln('| --- | ---: |');
  for (final entry in _sortedCounts(modalCounts)) {
    buffer.writeln('| ${entry.key} | ${entry.value} |');
  }

  buffer
    ..writeln()
    ..writeln('## Back Inventory')
    ..writeln()
    ..writeln(
      '| File | Line | Owner | Widget | Classification | Mode | Fallback | High risk | Issue | Notes |',
    )
    ..writeln('| --- | ---: | --- | --- | --- | --- | --- | --- | --- | --- |');

  for (final entry in entries) {
    buffer.writeln(
      '| `${_escape(entry.file)}` | ${entry.line} | `${_escape(entry.owner)}` | '
      '`${entry.sourceWidget}` | ${entry.classification} | ${entry.mode} | '
      '`${_escape(entry.fallback)}` | ${entry.highRisk ? 'yes' : 'no'} | '
      '${_escape(entry.issue)} | ${_escape(entry.notes)} |',
    );
  }

  return buffer.toString();
}

String _renderCsv(List<BackNavigationEntry> entries) {
  final buffer = StringBuffer()
    ..writeln(
      [
        'file',
        'line',
        'owner',
        'sourceWidget',
        'classification',
        'mode',
        'fallback',
        'highRisk',
        'issue',
        'notes',
      ].join(','),
    );

  for (final entry in entries) {
    buffer.writeln(
      [
        entry.file,
        entry.line.toString(),
        entry.owner,
        entry.sourceWidget,
        entry.classification,
        entry.mode,
        entry.fallback,
        entry.highRisk ? 'yes' : 'no',
        entry.issue,
        entry.notes,
      ].map(_csvCell).join(','),
    );
  }

  return buffer.toString();
}

String _renderSummary(List<BackNavigationEntry> entries) {
  final counts = _countsBy(entries.map((entry) => entry.classification));
  final buffer = StringBuffer()
    ..writeln('visible_header_back_entries=${entries.length}')
    ..writeln(
      'strict_back_issues=${entries.where((entry) => entry.hasStrictIssue).length}',
    )
    ..writeln(
      'high_risk_entries=${entries.where((entry) => entry.highRisk).length}',
    );
  for (final entry in _sortedCounts(counts)) {
    buffer.writeln('${entry.key}=${entry.value}');
  }
  return buffer.toString();
}

Map<String, int> _readModalBaselineCounts() {
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final csv = File(
    '${repoRoot}docs/02_FLUTTER_MIGRATION/audits/'
    'VitTrade-Back-Modal-Behavior-Audit.csv',
  );
  if (!csv.existsSync()) return const {};

  final counts = <String, int>{};
  final lines = csv.readAsLinesSync();
  if (lines.length <= 1) return counts;
  final headers = _parseCsvLine(lines.first);
  final classificationIndex = headers.indexOf('classification');
  if (classificationIndex == -1) return counts;
  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) continue;
    final values = _parseCsvLine(line);
    if (classificationIndex >= values.length) continue;
    final classification = values[classificationIndex];
    counts.update(classification, (count) => count + 1, ifAbsent: () => 1);
  }
  return counts;
}

String? _extractTopLevelArgument(String block, String name) {
  final pattern = RegExp('(^|[,(])\\s*$name\\s*:', multiLine: true);
  final match = pattern.firstMatch(block);
  if (match == null) return null;

  final valueStart = match.end;
  var depthParen = 0;
  var depthBrace = 0;
  var depthBracket = 0;
  var inSingleQuote = false;
  var inDoubleQuote = false;
  var escaping = false;

  for (var i = valueStart; i < block.length; i++) {
    final char = block[i];

    if (escaping) {
      escaping = false;
      continue;
    }
    if (char == r'\') {
      escaping = true;
      continue;
    }
    if (char == "'" && !inDoubleQuote) {
      inSingleQuote = !inSingleQuote;
      continue;
    }
    if (char == '"' && !inSingleQuote) {
      inDoubleQuote = !inDoubleQuote;
      continue;
    }
    if (inSingleQuote || inDoubleQuote) continue;

    switch (char) {
      case '(':
        depthParen += 1;
      case ')':
        if (depthParen == 0 && depthBrace == 0 && depthBracket == 0) {
          return block.substring(valueStart, i).trim();
        }
        depthParen -= 1;
      case '{':
        depthBrace += 1;
      case '}':
        depthBrace -= 1;
      case '[':
        depthBracket += 1;
      case ']':
        depthBracket -= 1;
      case ',':
        if (depthParen == 0 && depthBrace == 0 && depthBracket == 0) {
          return block.substring(valueStart, i).trim();
        }
    }
  }

  return block.substring(valueStart).trim();
}

({String block, int line})? _extractClassBlock(
  String source,
  String className,
) {
  final classMatch = RegExp(
    '\\bclass\\s+${RegExp.escape(className)}\\b',
  ).firstMatch(source);
  if (classMatch == null) return null;

  final openBrace = source.indexOf('{', classMatch.end);
  if (openBrace == -1) return null;
  final closeBrace = _findBalancedBraceEnd(source, openBrace);
  if (closeBrace == -1) return null;

  return (
    block: source.substring(classMatch.start, closeBrace + 1),
    line: _lineNumber(source, classMatch.start),
  );
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
    if (char == r'\') {
      escaping = true;
      continue;
    }
    if (char == "'" && !inDoubleQuote) {
      inSingleQuote = !inSingleQuote;
      continue;
    }
    if (char == '"' && !inSingleQuote) {
      inDoubleQuote = !inDoubleQuote;
      continue;
    }
    if (inSingleQuote || inDoubleQuote) continue;

    if (char == '(') {
      depth += 1;
    } else if (char == ')') {
      depth -= 1;
      if (depth == 0) return i;
    }
  }

  return -1;
}

int _findBalancedBraceEnd(String text, int openBraceIndex) {
  var depth = 0;
  var inSingleQuote = false;
  var inDoubleQuote = false;
  var escaping = false;

  for (var i = openBraceIndex; i < text.length; i++) {
    final char = text[i];

    if (escaping) {
      escaping = false;
      continue;
    }
    if (char == r'\') {
      escaping = true;
      continue;
    }
    if (char == "'" && !inDoubleQuote) {
      inSingleQuote = !inSingleQuote;
      continue;
    }
    if (char == '"' && !inSingleQuote) {
      inDoubleQuote = !inDoubleQuote;
      continue;
    }
    if (inSingleQuote || inDoubleQuote) continue;

    if (char == '{') {
      depth += 1;
    } else if (char == '}') {
      depth -= 1;
      if (depth == 0) return i;
    }
  }

  return -1;
}

String _nearestClassName(String source, int beforeIndex) {
  final before = source.substring(0, beforeIndex);
  final matches = RegExp(r'\bclass\s+([A-Za-z_]\w*)\b').allMatches(before);
  if (matches.isEmpty) return '-';
  return matches.last.group(1)!;
}

int _lineNumber(String source, int index) {
  var line = 1;
  for (var i = 0; i < index && i < source.length; i++) {
    if (source.codeUnitAt(i) == 10) line += 1;
  }
  return line;
}

Map<String, int> _countsBy(Iterable<String> values) {
  final counts = <String, int>{};
  for (final value in values) {
    counts.update(value, (count) => count + 1, ifAbsent: () => 1);
  }
  return counts;
}

List<MapEntry<String, int>> _sortedCounts(Map<String, int> counts) {
  return counts.entries.toList()..sort((a, b) {
    final valueCompare = b.value.compareTo(a.value);
    if (valueCompare != 0) return valueCompare;
    return a.key.compareTo(b.key);
  });
}

List<String> _parseCsvLine(String line) {
  final values = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        buffer.write('"');
        i += 1;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (char == ',' && !inQuotes) {
      values.add(buffer.toString());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }
  values.add(buffer.toString());
  return values;
}

String _csvCell(String value) {
  final escaped = value.replaceAll('"', '""');
  return '"$escaped"';
}

String _escape(String value) {
  return value.replaceAll('|', r'\|').replaceAll('\n', ' ');
}

String _relativePath(File file, String repoRoot) {
  return file.path
      .replaceAll('\\', '/')
      .replaceFirst(repoRoot.replaceAll('\\', '/'), '');
}
