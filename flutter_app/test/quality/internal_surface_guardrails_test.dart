import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('admin developer and QA demo route groups are explicitly gated', () {
    final adminRoutes = _read('lib/app/router/route_groups/admin_routes.dart');
    expect(adminRoutes, contains('InternalSurfaceGate'));
    expect(adminRoutes, contains('InternalSurfaceKind.admin'));

    final utilityRoutes = _read(
      'lib/app/router/route_groups/utility_routes.dart',
    );
    expect(utilityRoutes, contains('InternalSurfaceGate'));
    expect(utilityRoutes, contains('InternalSurfaceKind.developer'));
    expect(utilityRoutes, contains('InternalSurfaceKind.qaDemo'));
  });

  test('customer IA fixtures do not expose internal route namespaces', () {
    const customerIaFiles = {
      'lib/features/home/data/home_mock_data.dart',
      'lib/features/profile/data/repositories/mock_profile_repository_core_fixtures.dart',
    };
    final internalRoutePattern = RegExp(r'''['"]/(admin|dev|demo)(/|['"])''');
    final findings = <String>[];

    for (final path in customerIaFiles) {
      final source = _read(path);
      for (final match in internalRoutePattern.allMatches(source)) {
        findings.add('$path: ${match.group(0)}');
      }
    }

    expect(
      findings,
      isEmpty,
      reason:
          'Customer IA must not link directly to admin developer or demo routes.',
    );
  });
}

String _read(String path) {
  final file = File(path);
  expect(file.existsSync(), isTrue, reason: path);
  return file.readAsStringSync();
}
