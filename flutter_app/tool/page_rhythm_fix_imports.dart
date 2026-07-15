import 'dart:io';

/// Ensures `app_page_rhythm.dart` is imported in libraries that need VitPageRhythm.
void main() {
  final appRoot = _findAppRoot();
  final libRoot = Directory('${appRoot.path}/lib');
  const importLine =
      "import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';";

  var fixed = 0;
  for (final entity in libRoot.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final source = entity.readAsStringSync();
    if (!source.contains('VitPageRhythm.')) continue;

    final libraryFile = _libraryFor(entity, source);
    if (libraryFile == null) continue;

    var librarySource = libraryFile.readAsStringSync();
    if (librarySource.contains(importLine)) continue;

    final anchor = _findImportAnchor(librarySource);
    if (anchor == null) {
      stderr.writeln('No anchor: ${libraryFile.path}');
      continue;
    }

    librarySource = librarySource.replaceFirst(anchor, '$anchor\n$importLine');
    libraryFile.writeAsStringSync(librarySource);
    fixed++;
    stdout.writeln('Fixed ${libraryFile.path}');
  }

  stdout.writeln('Fixed $fixed library imports.');
}

File? _libraryFor(File file, String source) {
  final partOf = RegExp(r"part of '([^']+)';").firstMatch(source);
  if (partOf == null) return file;

  final ref = partOf.group(1)!;
  final candidate = File.fromUri(file.parent.uri.resolve(ref));
  if (!candidate.existsSync()) {
    stderr.writeln('Missing library for ${file.path}: $ref');
    return null;
  }
  return candidate;
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
