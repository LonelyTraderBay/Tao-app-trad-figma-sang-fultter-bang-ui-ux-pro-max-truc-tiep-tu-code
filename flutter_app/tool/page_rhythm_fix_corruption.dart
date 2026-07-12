import 'dart:io';

void main() {
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final tiers = _loadTiers(
    File('${repoRoot}docs/02_FLUTTER_MIGRATION/audits/VitTrade-Page-Rhythm-Migration-Manifest.csv'),
  );

  var fixed = 0;
  for (final entity in Directory('${appRoot.path}/lib').listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    var source = entity.readAsStringSync();
    if (!source.contains('VitPageContent(\$1')) continue;

    final rel = entity.path.replaceAll('\\', '/').split('/lib/').last;
    final tier = tiers[rel] ?? 'standard';
    source = source.replaceAll(
      'VitPageContent(\$1',
      'VitPageContent(rhythm: VitPageRhythm.$tier, ',
    );
    entity.writeAsStringSync(source);
    fixed++;
    stdout.writeln('Fixed $rel -> $tier');
  }
  stdout.writeln('Fixed $fixed corrupted files.');
}

Map<String, String> _loadTiers(File csv) {
  final map = <String, String>{};
  final lines = csv.readAsStringSync().split('\n');
  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;
    final parts = line.split(',');
    if (parts.length < 5) continue;
    final file = parts[2].replaceAll('flutter_app/lib/', '');
    map[file] = parts[3];
  }
  return map;
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
  throw StateError('Run from flutter_app/.');
}
