import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app code uses showVitBottomSheet instead of direct modal sheets', () {
    final scanRoots = [
      Directory('lib/app'),
      Directory('lib/features'),
      Directory('lib/shared'),
    ];
    final violations = <String>[];

    for (final root in scanRoots) {
      if (!root.existsSync()) {
        continue;
      }

      for (final entity in root.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) {
          continue;
        }

        final path = entity.path.replaceAll('\\', '/');
        if (path.endsWith('lib/shared/widgets/vit_bottom_sheet.dart')) {
          continue;
        }

        final lines = entity.readAsLinesSync();
        for (var index = 0; index < lines.length; index += 1) {
          if (lines[index].contains('showModalBottomSheet')) {
            violations.add('$path:${index + 1}: ${lines[index].trim()}');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use showVitBottomSheet so sheets attach to the root navigator.\n'
          '${violations.join('\n')}',
    );
  });
}
