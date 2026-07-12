import 'dart:io';

/// Audits horizontal content inset on presentation pages: flags double
/// application of `AppSpacing.contentPad` on ScrollView → VitPageContent.
///
/// See docs/02_FLUTTER_MIGRATION/standards/Page-Content-Width-Standard.md
///
/// Usage (from flutter_app/):
///   dart run tool/page_content_width_audit.dart          # regenerate
///   dart run tool/page_content_width_audit.dart --check  # CI gate
final class PageContentWidthFinding {
  const PageContentWidthFinding({
    required this.module,
    required this.path,
    required this.priority,
    required this.issue,
    required this.recommendedAction,
  });

  final String module;
  final String path;
  final String priority;
  final String issue;
  final String recommendedAction;
}

const String _generatedDate = '2026-07-10';

// Frozen after pilot referral fix — `--check` fails when P0 count exceeds this.
const int _p0Baseline = 0;

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final markdownFile = File(
    '${docsDir.path}/audits/VitTrade-Page-Content-Width-Audit.md',
  );
  final csvFile = File('${docsDir.path}/audits/VitTrade-Page-Content-Width-Audit.csv');

  final horizontalScrollTokens = _loadHorizontalScrollPaddingTokens(appRoot);
  final findings = _scanPresentationPages(appRoot, horizontalScrollTokens);

  final markdown = _buildMarkdown(findings);
  final csv = _buildCsv(findings);

  if (checkOnly) {
    _assertArtifactsCurrent(markdownFile, csvFile, markdown, csv);
    final p0Count = findings.where((f) => f.priority == 'P0').length;
    if (p0Count > _p0Baseline) {
      stderr.writeln(
        'page_content_width_audit: P0 count $p0Count exceeds baseline '
        '$_p0Baseline. Fix double horizontal inset or update baseline with '
        'justification.',
      );
      for (final finding in findings.where((f) => f.priority == 'P0')) {
        stderr.writeln('  ${finding.path}: ${finding.issue}');
      }
      exit(1);
    }
    stdout.writeln(
      'page_content_width_audit: OK (P0=$p0Count baseline=$_p0Baseline, '
      'total_findings=${findings.length})',
    );
    exit(0);
  }

  docsDir.createSync(recursive: true);
  markdownFile.writeAsStringSync(markdown);
  csvFile.writeAsStringSync(csv);
  stdout.writeln(
    'Wrote ${markdownFile.path} and ${csvFile.path} '
    '(${findings.length} findings, P0=${findings.where((f) => f.priority == 'P0').length})',
  );
}

Set<String> _loadHorizontalScrollPaddingTokens(Directory appRoot) {
  final tokens = <String>{};
  final spacingDir = Directory('${appRoot.path}/lib/app/theme/spacing');
  if (!spacingDir.existsSync()) return tokens;

  final fnPattern = RegExp(r'static\s+(?:const\s+)?EdgeInsets\s+(\w+)\s*=');
  final fnPattern2 = RegExp(r'static\s+EdgeInsets\s+(\w+)\(');

  for (final entity in spacingDir.listSync(recursive: false)) {
    if (entity is! File || !entity.path.endsWith('_spacing_tokens.dart')) {
      continue;
    }
    final source = entity.readAsStringSync();
    for (final match in fnPattern.allMatches(source)) {
      final name = match.group(1)!;
      if (_tokenBodyHasHorizontalContentPad(source, name)) {
        tokens.add(name);
      }
    }
    for (final match in fnPattern2.allMatches(source)) {
      final name = match.group(1)!;
      if (_tokenBodyHasHorizontalContentPad(source, name)) {
        tokens.add(name);
      }
    }
  }
  return tokens;
}

bool _tokenBodyHasHorizontalContentPad(
  String source,
  String tokenName, [
  Set<String>? visiting,
]) {
  visiting ??= <String>{};
  if (visiting.contains(tokenName)) return false;
  visiting.add(tokenName);

  final start = source.indexOf(tokenName);
  if (start < 0) return false;
  final nextStatic = source.indexOf('\n  static ', start + tokenName.length);
  final end = nextStatic >= 0
      ? nextStatic
      : (start + 400).clamp(0, source.length);
  final slice = source.substring(start, end);
  if (slice.contains('EdgeInsets.only(bottom:') ||
      slice.contains('EdgeInsetsDirectional.only(bottom:')) {
    return false;
  }
  if (slice.contains('AppSpacing.contentPad') &&
      (slice.contains('fromLTRB(') ||
          slice.contains('fromSTEB(') ||
          slice.contains('symmetric(horizontal:') ||
          slice.contains('contentInsets.copyWith') ||
          slice.contains('AppSpacing.contentInsets'))) {
    return true;
  }

  final delegateMatch = RegExp(
    r'=>[\s\n]*(\w+)\s*\(',
  ).firstMatch(slice.substring(tokenName.length));
  if (delegateMatch != null) {
    final delegate = delegateMatch.group(1)!;
    if (delegate != 'EdgeInsets' && delegate != 'EdgeInsetsDirectional') {
      return _tokenBodyHasHorizontalContentPad(source, delegate, visiting);
    }
  }
  return false;
}

List<PageContentWidthFinding> _scanPresentationPages(
  Directory appRoot,
  Set<String> horizontalScrollTokens,
) {
  final findings = <PageContentWidthFinding>[];
  final featuresDir = Directory('${appRoot.path}/lib/features');
  if (!featuresDir.existsSync()) return findings;

  for (final entity in featuresDir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (!entity.path.contains(
      '${Platform.pathSeparator}presentation${Platform.pathSeparator}pages${Platform.pathSeparator}',
    )) {
      continue;
    }
    final source = entity.readAsStringSync();
    if (!source.contains('VitPageContent')) continue;
    if (source.contains('page-content-width: allow-flush')) continue;

    final relative = _relativePath(entity.path, appRoot.path);
    final module = _moduleFromPath(relative);
    findings.addAll(
      _analyzeFile(
        module: module,
        path: relative,
        source: source,
        horizontalScrollTokens: horizontalScrollTokens,
      ),
    );
  }
  findings.sort((a, b) {
    final p = a.priority.compareTo(b.priority);
    if (p != 0) return p;
    return a.path.compareTo(b.path);
  });
  return findings;
}

List<PageContentWidthFinding> _analyzeFile({
  required String module,
  required String path,
  required String source,
  required Set<String> horizontalScrollTokens,
}) {
  final findings = <PageContentWidthFinding>[];

  if (_scrollContextHasDoubleHorizontalInset(source, horizontalScrollTokens)) {
    findings.add(
      PageContentWidthFinding(
        module: module,
        path: path,
        priority: 'P0',
        issue: 'double_horizontal_inset',
        recommendedAction:
            'Use Recipe A (bottom-only scroll + VitPageContent padding) or '
            'Recipe B (scroll horizontal pad + VitPageContent fullBleed: true, '
            'padding: none).',
      ),
    );
  }

  if (_scrollContextHasFullBleedWithoutHorizontalInset(
    source,
    horizontalScrollTokens,
  )) {
    findings.add(
      PageContentWidthFinding(
        module: module,
        path: path,
        priority: 'P1',
        issue: 'fullBleed_without_scroll_inset',
        recommendedAction:
            'fullBleed: true without horizontal scroll padding may render '
            'edge-to-edge; confirm intent or use Recipe A.',
      ),
    );
  }

  return findings;
}

bool _scrollContextHasFullBleedWithoutHorizontalInset(
  String source,
  Set<String> horizontalScrollTokens,
) {
  final lines = source.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final isInsetScroll = lines[i].contains('VitInsetScrollView(');
    final isScroll =
        lines[i].contains('SingleChildScrollView(') || isInsetScroll;
    if (!isScroll) continue;

    var scrollHasHorizontalPad = false;
    if (!isInsetScroll) {
      final scanEnd = (i + 12).clamp(0, lines.length);
      for (var j = i; j < scanEnd; j++) {
        final trimmed = lines[j].trim();
        if (!trimmed.startsWith('padding:')) continue;
        final padBlockEnd = (j + 8).clamp(0, lines.length);
        final block = lines.sublist(j, padBlockEnd).join('\n');
        if (_blockIsHorizontalScrollPad(block, horizontalScrollTokens)) {
          scrollHasHorizontalPad = true;
        }
        break;
      }
    }

    var betweenHasHorizontalPadding = false;
    var vpcFullBleed = false;
    var vpcFound = false;

    final bodyEnd = (i + 80).clamp(0, lines.length);
    for (var j = i + 1; j < bodyEnd; j++) {
      if (lines[j].contains('VitPageContent(')) {
        vpcFound = true;
        final vpcBlockEnd = (j + 8).clamp(0, lines.length);
        final vpcBlock = lines.sublist(j, vpcBlockEnd).join('\n');
        vpcFullBleed = vpcBlock.contains('fullBleed: true');
        break;
      }
      if (_betweenScrollAndVpcHasHorizontalPadding(lines, j)) {
        betweenHasHorizontalPadding = true;
      }
    }

    if (vpcFound &&
        vpcFullBleed &&
        !scrollHasHorizontalPad &&
        !betweenHasHorizontalPadding) {
      return true;
    }
  }
  return false;
}

bool _betweenScrollAndVpcHasHorizontalPadding(List<String> lines, int index) {
  final blockEnd = (index + 6).clamp(0, lines.length);
  final block = lines.sublist(index, blockEnd).join('\n');
  if (!block.contains('padding:') && !block.contains('Padding(')) {
    return false;
  }
  if (block.contains('EdgeInsets.only(bottom:') ||
      block.contains('EdgeInsetsDirectional.only(bottom:') ||
      block.contains('VitContentPadding.')) {
    return false;
  }
  if (block.contains('AppSpacing.contentPad') &&
      (block.contains('symmetric') ||
          block.contains('fromLTRB') ||
          block.contains('fromSTEB') ||
          block.contains('horizontal:'))) {
    return true;
  }
  if (block.contains('ContentPadding') ||
      block.contains('StandaloneContentPadding') ||
      block.contains('enterpriseStatesContentPadding')) {
    return true;
  }
  return false;
}

bool _scrollContextHasDoubleHorizontalInset(
  String source,
  Set<String> horizontalScrollTokens,
) {
  final lines = source.split('\n');
  for (var i = 0; i < lines.length; i++) {
    if (!lines[i].contains('SingleChildScrollView(') &&
        !lines[i].contains('VitInsetScrollView(')) {
      continue;
    }

    var horizontalPad = false;
    final scanEnd = (i + 12).clamp(0, lines.length);
    for (var j = i; j < scanEnd; j++) {
      final trimmed = lines[j].trim();
      if (!trimmed.startsWith('padding:')) continue;
      final padBlockEnd = (j + 8).clamp(0, lines.length);
      final block = lines.sublist(j, padBlockEnd).join('\n');
      if (_blockIsHorizontalScrollPad(block, horizontalScrollTokens)) {
        horizontalPad = true;
      }
      break;
    }
    if (!horizontalPad) continue;

    final bodyEnd = (i + 80).clamp(0, lines.length);
    for (var j = i; j < bodyEnd; j++) {
      if (!lines[j].contains('VitPageContent(')) continue;
      final vpcBlockEnd = (j + 8).clamp(0, lines.length);
      final vpcBlock = lines.sublist(j, vpcBlockEnd).join('\n');
      if (!vpcBlock.contains('fullBleed: true')) return true;
    }
  }
  return false;
}

bool _blockIsHorizontalScrollPad(
  String block,
  Set<String> horizontalScrollTokens,
) {
  if (block.contains('EdgeInsets.only(bottom:') ||
      block.contains('EdgeInsetsDirectional.only(bottom:')) {
    return false;
  }

  if (block.contains('AppSpacing.contentPad') &&
      (block.contains('fromLTRB') ||
          block.contains('fromSTEB') ||
          block.contains('symmetric(horizontal:'))) {
    return true;
  }

  if (block.contains('AppSpacing.contentInsets')) {
    return true;
  }

  for (final token in horizontalScrollTokens) {
    if (block.contains('$token(')) return true;
  }
  return false;
}

String _buildMarkdown(List<PageContentWidthFinding> findings) {
  final p0 = findings.where((f) => f.priority == 'P0').length;
  final p1 = findings.where((f) => f.priority == 'P1').length;
  final buffer = StringBuffer()
    ..writeln('# VitTrade Page Content Width Audit')
    ..writeln()
    ..writeln('Generated: $_generatedDate')
    ..writeln()
    ..writeln(
      'Authority: [Page-Content-Width-Standard.md](../standards/Page-Content-Width-Standard.md)',
    )
    ..writeln()
    ..writeln('```text')
    ..writeln('total_findings=${findings.length}')
    ..writeln('priority_P0=$p0')
    ..writeln('priority_P1=$p1')
    ..writeln('p0_baseline=$_p0Baseline')
    ..writeln('```')
    ..writeln()
    ..writeln('| module | path | priority | issue | recommended_action |')
    ..writeln('| --- | --- | --- | --- | --- |');

  if (findings.isEmpty) {
    buffer.writeln('| — | — | — | none | — |');
  } else {
    for (final finding in findings) {
      buffer.writeln(
        '| ${finding.module} | `${finding.path}` | ${finding.priority} | '
        '${finding.issue} | ${finding.recommendedAction} |',
      );
    }
  }
  return buffer.toString();
}

String _buildCsv(List<PageContentWidthFinding> findings) {
  final buffer = StringBuffer()
    ..writeln(
      [
        'module',
        'path',
        'priority',
        'issue',
        'recommended_action',
      ].map(_csvEscape).join(','),
    );
  for (final finding in findings) {
    buffer.writeln(
      [
        finding.module,
        finding.path,
        finding.priority,
        finding.issue,
        finding.recommendedAction,
      ].map(_csvEscape).join(','),
    );
  }
  return buffer.toString();
}

void _assertArtifactsCurrent(
  File markdownFile,
  File csvFile,
  String markdown,
  String csv,
) {
  if (!markdownFile.existsSync() || !csvFile.existsSync()) {
    stderr.writeln(
      'page_content_width_audit: missing artifacts. Run '
      '`dart run tool/page_content_width_audit.dart` from flutter_app/.',
    );
    exit(1);
  }
  if (markdownFile.readAsStringSync() != markdown) {
    stderr.writeln(
      'page_content_width_audit: VitTrade-Page-Content-Width-Audit.md is stale.',
    );
    exit(1);
  }
  if (csvFile.readAsStringSync() != csv) {
    stderr.writeln(
      'page_content_width_audit: VitTrade-Page-Content-Width-Audit.csv is stale.',
    );
    exit(1);
  }
}

String _moduleFromPath(String relativePath) {
  final parts = relativePath.split('/');
  if (parts.length >= 3 && parts[0] == 'lib' && parts[1] == 'features') {
    return parts[2];
  }
  return 'unknown';
}

String _relativePath(String filePath, String appRootPath) {
  final root = appRootPath.replaceAll('\\', '/');
  final path = filePath.replaceAll('\\', '/');
  if (path.startsWith(root)) {
    return path.substring(root.length + 1);
  }
  final marker = '/flutter_app/';
  final idx = path.indexOf(marker);
  if (idx >= 0) return path.substring(idx + marker.length);
  return path;
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

Directory _findAppRoot() {
  var current = Directory.current;
  if (File('${current.path}/pubspec.yaml').existsSync()) return current;
  final nested = Directory('${current.path}/flutter_app');
  if (File('${nested.path}/pubspec.yaml').existsSync()) return nested;
  throw StateError(
    'Run from flutter_app/ or repo root containing flutter_app/pubspec.yaml',
  );
}
