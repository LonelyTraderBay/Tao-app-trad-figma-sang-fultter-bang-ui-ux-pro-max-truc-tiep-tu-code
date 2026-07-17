import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'every route_groups/*_route_ids.dart member name is globally unique',
    () {
      final idFiles = _routeIdFiles();
      final nameToFiles = <String, Set<String>>{};

      for (final file in idFiles) {
        final text = file.readAsStringSync();
        final memberNames = [
          ...RegExp(r'static const String (\w+)').allMatches(text),
          ...RegExp(r'static String (\w+)\(').allMatches(text),
        ].map((match) => match.group(1)!);

        for (final name in memberNames) {
          nameToFiles.putIfAbsent(name, () => {}).add(_normalize(file.path));
        }
      }

      final collisions = <String, Set<String>>{
        for (final entry in nameToFiles.entries)
          if (entry.value.length > 1) entry.key: entry.value,
      };

      expect(
        collisions,
        isEmpty,
        reason:
            'A route id member must be declared in exactly one '
            'route_groups/*_route_ids.dart file. Two files defining the '
            'same member name silently breaks the tool/*_audit.dart '
            'literal-name mapping (ARCH-A3). Collisions: $collisions',
      );
    },
  );

  test(
    'AppRoutePaths and AppRouteNames facades carry no new quoted literal '
    '(ARCH-A3 ratchet — all literals live in route_groups/*_route_ids.dart)',
    () {
      final facades = [
        File('lib/app/router/app_route_paths.dart'),
        File('lib/app/router/app_route_names.dart'),
      ];
      final quotedAssignment = RegExp(r"""=\s*['"]""");
      final findings = <String>[];

      for (final file in facades) {
        final lines = file.readAsLinesSync();
        for (var index = 0; index < lines.length; index += 1) {
          final line = lines[index];
          if (line.trim().startsWith('//')) continue;
          if (quotedAssignment.hasMatch(line)) {
            findings.add(
              '${_normalize(file.path)}:${index + 1}: ${line.trim()}',
            );
          }
        }
      }

      expect(
        findings,
        isEmpty,
        reason:
            'ARCH-A3 moved every route literal into '
            'route_groups/<feature>_route_ids.dart; AppRoutePaths and '
            'AppRouteNames must only contain alias/forward declarations. '
            'Findings: $findings',
      );
    },
  );
}

List<File> _routeIdFiles() {
  final dir = Directory('lib/app/router/route_groups');
  return dir
      .listSync()
      .whereType<File>()
      .where(
        (file) => file.path.replaceAll('\\', '/').endsWith('_route_ids.dart'),
      )
      .toList();
}

String _normalize(String path) => path.replaceAll('\\', '/');
