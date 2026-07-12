import 'dart:io';

/// Extracts trade-related rows from VitTrade-Screen-Navigation-Edges.csv
/// and writes VitTrade-Trade-Navigation-Edges.csv with a direction column.
void main() {
  final appRoot = Directory.current;
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final source = File(
    '${repoRoot}docs/02_FLUTTER_MIGRATION/audits/VitTrade-Screen-Navigation-Edges.csv',
  );
  final output = File(
    '${repoRoot}docs/02_FLUTTER_MIGRATION/audits/VitTrade-Trade-Navigation-Edges.csv',
  );

  if (!source.existsSync()) {
    stderr.writeln('Missing source: ${source.path}');
    exitCode = 1;
    return;
  }

  final lines = source.readAsLinesSync();
  final header = 'direction,${lines.first}';
  final rows = <String>[];

  for (final line in lines.skip(1)) {
    if (!line.contains('/trade') && !line.startsWith('trade,')) {
      continue;
    }
    final direction = line.startsWith('trade,') ? 'internal' : 'inbound';
    rows.add('$direction,$line');
  }

  rows.sort();
  output.writeAsStringSync('$header\n${rows.join('\n')}\n');
  stdout.writeln('Wrote ${rows.length} edges to ${output.path}');
}
