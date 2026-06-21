import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app code uses clamping scroll physics consistently', () {
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
        final lines = entity.readAsLinesSync();
        for (var index = 0; index < lines.length; index += 1) {
          if (lines[index].contains('BouncingScrollPhysics')) {
            violations.add('$path:${index + 1}: ${lines[index].trim()}');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use ClampingScrollPhysics for project-wide scroll consistency.\n'
          '${violations.join('\n')}',
    );
  });
}
