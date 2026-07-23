import 'dart:io';

final class NavigationEdge {
  const NavigationEdge({
    required this.module,
    required this.sourceFile,
    required this.line,
    required this.sourceUnit,
    required this.triggerHint,
    required this.kind,
    required this.targetExpression,
    required this.normalizedTarget,
    required this.targetScreen,
    required this.notes,
  });

  final String module;
  final String sourceFile;
  final int line;
  final String sourceUnit;
  final String triggerHint;
  final String kind;
  final String targetExpression;
  final String normalizedTarget;
  final String targetScreen;
  final String notes;

  List<String> toCsvRow() {
    return [
      module,
      sourceFile,
      '$line',
      sourceUnit,
      triggerHint,
      kind,
      targetExpression,
      normalizedTarget,
      targetScreen,
      notes,
    ];
  }
}

final class RouteRecord {
  const RouteRecord({required this.path, required this.page});

  final String path;
  final String page;
}

final class _RoutePattern {
  const _RoutePattern(this.pattern, this.record);

  final RegExp pattern;
  final RouteRecord record;
}

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final outputFile = File(
    '${repoRoot}docs/02_FLUTTER_MIGRATION/audits/VitTrade-Screen-Navigation-Edges.csv',
  );

  final edges = _collectNavigationEdges(appRoot);
  final content = _renderCsv(edges);

  if (checkOnly) {
    if (!outputFile.existsSync()) {
      stderr.writeln('Navigation edge artifact is missing: ${outputFile.path}');
      exitCode = 1;
      return;
    }

    final current = _stripBom(outputFile.readAsStringSync());
    if (current != content) {
      stderr.writeln(
        'Navigation edge artifact is stale. Run '
        '`dart run tool/navigation_edge_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }

    stdout.writeln('Navigation edge artifact is current.');
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

List<NavigationEdge> _collectNavigationEdges(Directory appRoot) {
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final routeResolver = _RouteResolver(appRoot, repoRoot);
  final libDir = Directory('${appRoot.path}/lib');
  final files =
      libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList()
        ..sort(
          (a, b) => _relativePath(a, repoRoot)
              .replaceAll(r'\', '/')
              .compareTo(_relativePath(b, repoRoot).replaceAll(r'\', '/')),
        );

  final edges = <NavigationEdge>[];
  for (final file in files) {
    final text = file.readAsStringSync();
    final relativeFile = _relativePath(file, repoRoot);
    final lines = text.split('\n');

    for (final token in _navigationCallTokens) {
      var index = 0;
      while (true) {
        final start = text.indexOf(token, index);
        if (start == -1) break;

        final openParenIndex = start + token.length - 1;
        final end = _findBalancedEnd(text, openParenIndex);
        if (end == -1) {
          index = start + token.length;
          continue;
        }

        final args = text.substring(openParenIndex + 1, end);
        final parts = _splitTopLevel(args);
        final firstArg = parts.isEmpty ? '' : parts.first.trim();
        final kind = token.substring(0, token.length - 1);
        if (_isDeclarationLikeOnNavigate(kind, firstArg)) {
          index = end + 1;
          continue;
        }
        final target = routeResolver.resolveRouteExpression(firstArg);
        final notes = _edgeNotes(kind, firstArg, target);

        edges.add(
          NavigationEdge(
            module: _sourceModule(relativeFile),
            sourceFile: relativeFile,
            line: _lineNumber(text, start),
            sourceUnit: _sourceUnit(relativeFile),
            triggerHint: _nearestHints(lines, _lineNumber(text, start)),
            kind: kind,
            targetExpression: _cleanExpression(firstArg),
            normalizedTarget: target,
            targetScreen: routeResolver.matchRoute(target),
            notes: notes,
          ),
        );

        index = end + 1;
      }
    }
  }

  final seen = <String>{};
  final deduped = <NavigationEdge>[];
  for (final edge in edges) {
    final key = [
      edge.sourceFile,
      edge.line,
      edge.kind,
      edge.targetExpression,
    ].join('\u0001');
    if (seen.add(key)) deduped.add(edge);
  }
  return deduped;
}

String _edgeNotes(String kind, String firstArg, String target) {
  if (kind.contains('pop') && target.isEmpty) return 'back_or_close_modal';
  if (target.isEmpty && firstArg.trim().isNotEmpty) {
    return 'dynamic_route_expression';
  }
  return '';
}

/// Skip method/parameter declarations like `void onNavigate(String route)`.
bool _isDeclarationLikeOnNavigate(String kind, String firstArg) {
  if (kind != 'onNavigate') {
    return false;
  }
  final trimmed = firstArg.trim();
  if (trimmed.isEmpty) return true;
  if (trimmed.contains("'") ||
      trimmed.contains('"') ||
      trimmed.contains('AppRoutePaths') ||
      trimmed.contains(r'${')) {
    return false;
  }
  // Type + name (optional generics): `String route`, `ValueChanged<String> cb`
  return RegExp(r'^[A-Za-z_][\w.<>,\s?]+\s+[A-Za-z_]\w*$').hasMatch(trimmed);
}

const _navigationCallTokens = [
  'context.goNamed(',
  'context.pushNamed(',
  'context.replaceNamed(',
  'context.goHaptic(',
  'context.go(',
  'context.push(',
  'context.replace(',
  'context.pop(',
  'GoRouter.of(context).go(',
  'GoRouter.of(context).push(',
  'GoRouter.of(context).replace(',
  'Navigator.of(context).pop(',
  'Navigator.pop(',
  'Navigator.of(context).push(',
  'Navigator.push(',
  'onNavigate(',
];

final class _RouteResolver {
  _RouteResolver(Directory appRoot, String repoRoot)
    : _pathsText = _readRoutePathSources(appRoot),
      _truthTable = File(
        '${repoRoot}docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md',
      ).readAsStringSync() {
    _parseRoutePathConstants();
    _parseRoutePathBuilders();
    _parseRouteTruthTable();
  }

  // ARCH-A3: literal path giờ sống trong route_groups/<feature>_route_ids.dart
  // (facade AppRoutePaths chỉ còn alias unquoted — regex bên dưới bỏ qua
  // alias theo thiết kế). Đọc concat facade + mọi id file, sort theo path
  // repo-relative forward-slash để artifact ổn định cross-OS.
  static String _readRoutePathSources(Directory appRoot) {
    final sources = <String>[
      File(
        '${appRoot.path}/lib/app/router/app_route_paths.dart',
      ).readAsStringSync(),
    ];
    final groupsDir = Directory('${appRoot.path}/lib/app/router/route_groups');
    final idFiles =
        groupsDir
            .listSync()
            .whereType<File>()
            .where(
              (f) => f.path.replaceAll(r'\', '/').endsWith('_route_ids.dart'),
            )
            .toList()
          ..sort(
            (a, b) => a.path
                .replaceAll(r'\', '/')
                .compareTo(b.path.replaceAll(r'\', '/')),
          );
    sources.addAll(idFiles.map((f) => f.readAsStringSync()));
    return sources.join('\n');
  }

  final String _pathsText;
  final String _truthTable;
  final Map<String, String> _pathConstants = {};
  final Map<String, String> _pathBuilders = {};
  final List<_RoutePattern> _routePatterns = [];

  void _parseRoutePathConstants() {
    final matches = RegExp(
      r'static\s+const\s+String\s+(\w+)\s*=\s*(.*?);',
      dotAll: true,
    ).allMatches(_pathsText);

    for (final match in matches) {
      final name = match.group(1)!;
      final expression = _cleanExpression(match.group(2)!);
      if (_isQuoted(expression)) {
        _pathConstants[name] = _unquote(expression);
      }
    }
  }

  void _parseRoutePathBuilders() {
    final matches = RegExp(
      r'static\s+String\s+(\w+)\s*\((.*?)\)\s*=>\s*(.*?);',
      dotAll: true,
    ).allMatches(_pathsText);

    for (final match in matches) {
      final name = match.group(1)!;
      final params = _extractParameterNames(match.group(2)!);
      var pattern = _unquote(_cleanExpression(match.group(3)!));
      if (!pattern.startsWith('/')) continue;

      for (final param in params) {
        pattern = pattern
            .replaceAll('\${$param}', ':$param')
            .replaceAll('\$$param', ':$param');
      }
      _pathBuilders[name] = pattern;
    }

    _pathBuilders.addAll({
      'tradeCopyProvider': '/trade/copy-provider/:providerId',
      'tradeCopyProviderConfiguration':
          '/trade/copy-provider/:providerId/configuration',
    });
  }

  List<String> _extractParameterNames(String source) {
    final names = <String>[];
    for (final part in source.split(',')) {
      final trimmed = part.trim();
      if (trimmed.isEmpty || trimmed.startsWith('{')) continue;
      final tokens = trimmed.replaceAll('required ', '').split(RegExp(r'\s+'));
      if (tokens.isNotEmpty) {
        names.add(tokens.last.replaceAll('{', '').replaceAll('}', ''));
      }
    }
    return names;
  }

  void _parseRouteTruthTable() {
    final rowPattern = RegExp(
      r'^\| `([^`]+)` \| (\d+) \| `([^`]+)` \| `([^`]+)` \| `([^`]+)` \| `([^`]+)` \|',
      multiLine: true,
    );

    for (final match in rowPattern.allMatches(_truthTable)) {
      final pathExpression = match.group(3)!;
      final evidence = match.group(6)!;
      final path = resolveRouteExpression(pathExpression).isNotEmpty
          ? resolveRouteExpression(pathExpression)
          : _resolveTruthTablePath(pathExpression);
      if (!path.startsWith('/')) continue;

      final pattern = _routeRegExp(path);
      if (pattern != null) {
        _routePatterns.add(
          _RoutePattern(pattern, RouteRecord(path: path, page: evidence)),
        );
      }
    }
  }

  String _resolveTruthTablePath(String expression) {
    final trimmed = _cleanExpression(expression);
    if (_isQuoted(trimmed)) return _unquote(trimmed);
    final match = RegExp(r'^AppRoutePaths\.(\w+)$').firstMatch(trimmed);
    if (match != null) return _pathConstants[match.group(1)!] ?? '';
    return trimmed
        .replaceAllMapped(
          RegExp(r'AppRoutePaths\.(\w+)'),
          (match) => _pathConstants[match.group(1)!] ?? match.group(0)!,
        )
        .replaceAll("'", '');
  }

  RegExp? _routeRegExp(String path) {
    final basePath = path.split('?').first;
    final segments = basePath
        .split('/')
        .skip(1)
        .map((segment) {
          if (segment.startsWith(':')) return r'[^/]+';
          return RegExp.escape(segment);
        })
        .join('/');
    try {
      return RegExp('^/$segments\$');
    } on FormatException {
      return null;
    }
  }

  String resolveRouteExpression(String expression) {
    var trimmed = _cleanExpression(expression);
    if (trimmed.endsWith(',')) {
      trimmed = trimmed.substring(0, trimmed.length - 1).trim();
    }
    if (trimmed.startsWith('const ')) {
      trimmed = trimmed.substring('const '.length).trim();
    }
    if (trimmed.isEmpty) return '';

    if (_isQuoted(trimmed)) {
      return _resolveInterpolatedLiteral(_unquote(trimmed));
    }

    final constantMatch = RegExp(r'^AppRoutePaths\.(\w+)$').firstMatch(trimmed);
    if (constantMatch != null) {
      return _pathConstants[constantMatch.group(1)!] ?? '';
    }

    final builderMatch = RegExp(
      r'^AppRoutePaths\.(\w+)\((.*)\)$',
    ).firstMatch(trimmed);
    if (builderMatch != null) {
      final builderName = builderMatch.group(1)!;
      final pattern = _pathBuilders[builderName];
      if (pattern == null) return 'AppRoutePaths.$builderName(...)';
      return _fillBuilderPattern(pattern, builderMatch.group(2)!);
    }

    return '';
  }

  String _resolveInterpolatedLiteral(String value) {
    return value.replaceAllMapped(
      RegExp(r'\$\{AppRoutePaths\.(\w+)\}'),
      (match) => _pathConstants[match.group(1)!] ?? match.group(0)!,
    );
  }

  String _fillBuilderPattern(String pattern, String argumentSource) {
    final args = _splitTopLevel(argumentSource).toList();
    var result = pattern;
    for (final match in RegExp(r':(\w+)').allMatches(pattern).toList()) {
      if (args.isEmpty) break;
      final rawArg = args.removeAt(0).trim();
      final replacement = _isQuoted(rawArg) ? _unquote(rawArg) : '<$rawArg>';
      result = result.replaceFirst(':${match.group(1)!}', replacement);
    }
    return result;
  }

  String matchRoute(String target) {
    if (target.isEmpty) return '';
    var sample = target.split('?').first;
    sample = sample.replaceAll(RegExp(r'<[^>]+>'), 'sample');
    sample = sample.replaceAll(RegExp(r'\$\{[^}]+\}'), 'sample');
    for (final routePattern in _routePatterns) {
      if (routePattern.pattern.hasMatch(sample)) {
        return '${routePattern.record.page} (${routePattern.record.path})';
      }
    }
    return '';
  }
}

String _renderCsv(List<NavigationEdge> edges) {
  final buffer = StringBuffer()
    ..writeln(
      [
        'module',
        'source_file',
        'line',
        'source_unit',
        'trigger_hint',
        'kind',
        'target_expression',
        'normalized_target',
        'target_screen',
        'notes',
      ].join(','),
    );

  for (final edge in edges) {
    buffer.writeln(edge.toCsvRow().map(_csvCell).join(','));
  }

  return buffer.toString();
}

String _csvCell(String value) {
  if (value.contains(',') ||
      value.contains('"') ||
      value.contains('\n') ||
      value.contains('\r')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

String _cleanExpression(String expression) {
  return expression.trim().split(RegExp(r'\s+')).join(' ');
}

String _stripBom(String value) {
  if (value.startsWith('\uFEFF')) return value.substring(1);
  return value;
}

bool _isQuoted(String value) {
  return (value.startsWith("'") && value.endsWith("'")) ||
      (value.startsWith('"') && value.endsWith('"'));
}

String _unquote(String value) {
  final trimmed = value.trim();
  if (_isQuoted(trimmed)) {
    return trimmed.substring(1, trimmed.length - 1);
  }
  return trimmed;
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

    if (inSingleQuote || inDoubleQuote) continue;

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

String _nearestHints(List<String> lines, int lineNumber) {
  final start = lineNumber - 18 < 0 ? 0 : lineNumber - 18;
  final end = lineNumber + 10 > lines.length ? lines.length : lineNumber + 10;
  final window = lines.sublist(start, end).join('\n');
  final patterns = [
    RegExp(r"tooltip:\s*'([^']+)'", dotAll: true),
    RegExp(r"label:\s*'([^']+)'", dotAll: true),
    RegExp(r"actionLabel:\s*'([^']+)'", dotAll: true),
    RegExp(r"title:\s*'([^']+)'", dotAll: true),
    RegExp(r"child:\s*const\s+Text\('([^']+)'", dotAll: true),
    RegExp(r"Text\('([^']{2,80})'", dotAll: true),
    RegExp(r"semanticLabel:\s*'([^']+)'", dotAll: true),
    RegExp(r"header:\s*VitHeader\([^)]*title:\s*'([^']+)'", dotAll: true),
  ];

  final hits = <String>[];
  for (final pattern in patterns) {
    for (final match in pattern.allMatches(window)) {
      final value = _cleanExpression(match.group(1)!);
      if (!hits.contains(value) && value.length <= 90) hits.add(value);
      if (hits.length == 4) break;
    }
    if (hits.length == 4) break;
  }
  return hits.join(' | ');
}

String _relativePath(File file, String repoRoot) {
  final normalizedRoot = repoRoot.replaceAll('\\', '/');
  final normalizedPath = file.path.replaceAll('\\', '/');
  if (normalizedPath.startsWith(normalizedRoot)) {
    return normalizedPath.substring(normalizedRoot.length);
  }
  return normalizedPath;
}

String _sourceModule(String relativeFile) {
  final parts = relativeFile.split('/');
  if (parts.length >= 4 && parts[0] == 'flutter_app' && parts[1] == 'lib') {
    if (parts[2] == 'features') return parts[3];
    return parts[2];
  }
  return '';
}

String _sourceUnit(String relativeFile) {
  final name = relativeFile.split('/').last;
  return name.replaceFirst(RegExp(r'_part_\d+\.dart$'), '.dart');
}
