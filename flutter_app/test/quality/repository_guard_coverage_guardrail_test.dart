import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'every feature repository provider goes through guardedRepository',
    () {
      // dev/ and enterprise_states/ are developer/demo scaffolding, not
      // user-facing product features — see ERR-33 in
      // docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
      // Add a new entry here (with a reason) rather than letting a real
      // feature provider skip the guard silently.
      const allowlist = {
        'lib/features/dev/data/providers/dev_tools_repository_provider.dart',
        'lib/features/enterprise_states/data/providers/enterprise_states_repository_provider.dart',
      };

      final providerFiles = Directory('lib/features')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.replaceAll('\\', '/').endsWith(
                '_repository_provider.dart',
              ));

      final unguarded = <String>[];
      for (final file in providerFiles) {
        final path = file.path.replaceAll('\\', '/');
        if (allowlist.contains(path)) continue;
        if (!file.readAsStringSync().contains('guardedRepository')) {
          unguarded.add(path);
        }
      }

      expect(
        unguarded,
        isEmpty,
        reason:
            'These repository providers bypass guardedRepository, so a '
            'production build (enableMockData=false) would silently keep '
            'serving mock data instead of failing closed: $unguarded',
      );
    },
  );
}
