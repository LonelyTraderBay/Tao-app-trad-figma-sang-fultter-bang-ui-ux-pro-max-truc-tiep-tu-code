import 'dart:io';

List<String> sourceMatches({
  required String root,
  required RegExp pattern,
  bool Function(String path)? pathFilter,
}) {
  final directory = Directory(root);
  if (!directory.existsSync()) return const [];

  final findings = <String>[];
  for (final file
      in directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final path = normalizePath(file.path);
    if (pathFilter != null && !pathFilter(path)) continue;

    final lines = file.readAsLinesSync();
    for (var index = 0; index < lines.length; index += 1) {
      final line = lines[index];
      if (pattern.hasMatch(line)) {
        findings.add('$path:${index + 1}');
      }
    }
  }
  return findings;
}

String normalizePath(String path) => path.replaceAll('\\', '/');
