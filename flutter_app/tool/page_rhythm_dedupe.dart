import 'dart:io';

/// Removes duplicate `rhythm:` lines accidentally injected by batch apply.
void main() {
  final appRoot = _findAppRoot();
  var fixed = 0;

  for (final entity in Directory(
    '${appRoot.path}/lib',
  ).listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final source = entity.readAsStringSync();
    if (!source.contains('rhythm: VitPageRhythm')) continue;

    var deduped = source.replaceAllMapped(
      RegExp(
        r'(\s*rhythm: VitPageRhythm\.\w+,\s*\n)(\s*rhythm: VitPageRhythm\.\w+,\s*\n)+',
      ),
      (match) => match.group(1)!,
    );
    deduped = deduped.replaceAllMapped(
      RegExp(r'(rhythm: VitPageRhythm\.\w+,)\s*rhythm: VitPageRhythm\.\w+,'),
      (match) => match.group(1)!,
    );

    if (deduped != source) {
      entity.writeAsStringSync(deduped);
      fixed++;
      stdout.writeln('Deduped ${entity.path}');
    }
  }

  stdout.writeln('Deduped $fixed files.');
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
