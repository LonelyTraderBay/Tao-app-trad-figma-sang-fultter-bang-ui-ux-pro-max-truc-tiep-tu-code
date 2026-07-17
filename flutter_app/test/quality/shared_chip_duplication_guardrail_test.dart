import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'presentation files do not define local Sort/Category/Filter chip widgets',
    () {
      // VitFilterChip (shared/widgets/vit_filter_chip.dart) already covers
      // the "single filter toggle with an accent color" case these classes
      // kept reinventing — see punch-list #17. Frozen at 0 after dedupe
      // 2026-07-16: 8 duplicate classes across 8 files were inlined to
      // VitFilterChip. If you hit this failure, either reuse VitFilterChip
      // (extend it with an optional param if it's genuinely missing
      // something) or, if the widget is NOT an interactive filter/sort
      // toggle (e.g. a static tag, or a sort-direction header), name it
      // something that doesn't collide with this pattern.
      final matches = _sourceMatches(
        root: 'lib/features',
        pattern: RegExp(r'^class _(Sort|Category|Filter)Chip\b'),
      );

      expect(
        matches,
        isEmpty,
        reason:
            'New local Sort/Category/Filter chip widget(s) found:\n'
            '${matches.join('\n')}\n\n'
            'Reuse VitFilterChip (shared/widgets/vit_filter_chip.dart) '
            'instead of adding another private copy.',
      );
    },
  );
}

List<String> _sourceMatches({required String root, required RegExp pattern}) {
  final directory = Directory(root);
  if (!directory.existsSync()) return const [];

  final findings = <String>[];
  for (final file
      in directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final path = _normalize(file.path);
    final lines = file.readAsLinesSync();
    for (var index = 0; index < lines.length; index += 1) {
      if (pattern.hasMatch(lines[index])) {
        findings.add('$path:${index + 1}');
      }
    }
  }
  return findings;
}

String _normalize(String path) => path.replaceAll('\\', '/');
