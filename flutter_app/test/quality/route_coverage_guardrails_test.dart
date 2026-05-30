import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('router does not reintroduce placeholder or skeleton routes', () {
    final routeDir = Directory('lib/app/router/route_groups');
    final findings = <String>[];

    for (final file
        in routeDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
      final lines = file.readAsLinesSync();
      for (var index = 0; index < lines.length; index += 1) {
        final line = lines[index];
        if (line.contains('_placeholderRoute(') ||
            line.contains('_BottomNavRouteSkeleton')) {
          findings.add('${file.path}:${index + 1}: ${line.trim()}');
        }
      }
    }

    expect(
      findings,
      isEmpty,
      reason:
          'Route placeholders must be real pages, redirects, or explicit '
          'product-accepted routes outside the placeholder helper path.',
    );
  });
}
