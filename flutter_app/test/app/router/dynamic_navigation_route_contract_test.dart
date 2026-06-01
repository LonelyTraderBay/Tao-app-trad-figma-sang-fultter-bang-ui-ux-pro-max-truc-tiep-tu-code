import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';

void main() {
  group('data-driven navigation route contracts', () {
    const modules = [
      'p2p',
      'earn',
      'launchpad',
      'arena',
      'discovery',
      'cross_module',
    ];

    for (final module in modules) {
      test('$module route-bearing data resolves to a router path', () {
        final router = createAppRouter();
        addTearDown(router.dispose);
        final routes = _routeLiteralsForModule(module);
        final missing = <String>[];

        for (final route in routes) {
          final sampledRoute = _sampleRoute(route.value);
          final match = router.configuration.findMatch(Uri.parse(sampledRoute));
          if (match.isError) {
            missing.add(
              '${route.source}: ${route.value} sampled as $sampledRoute',
            );
          }
        }

        expect(
          missing,
          isEmpty,
          reason:
              'Route-bearing mock/domain data must point to a declared router '
              'path. Use AppRoutePaths or a typed NavigationIntent when the '
              'route requires parameters or query values.',
        );
      });
    }

    test('route-bearing data only uses reviewed query keys', () {
      final routes = <_RouteLiteral>[
        for (final module in modules) ..._routeLiteralsForModule(module),
      ];
      final unsupported = <String>[];

      for (final route in routes) {
        final uri = Uri.parse(_sampleRoute(route.value));
        for (final key in uri.queryParameters.keys) {
          if (!_allowedRouteDataQueryKeys.contains(key)) {
            unsupported.add('${route.source}: ${route.value} uses "$key"');
          }
        }
      }

      expect(
        unsupported,
        isEmpty,
        reason:
            'Data-driven route query keys are part of the navigation contract '
            'and must be reviewed before use.',
      );
    });
  });
}

const _allowedRouteDataQueryKeys = {'type'};

List<_RouteLiteral> _routeLiteralsForModule(String module) {
  final root = Directory('lib/features/$module');
  if (!root.existsSync()) return const [];

  final routeField = RegExp(
    r"""\b[A-Za-z0-9_]*[Rr]oute[A-Za-z0-9_]*\s*:\s*(["'])(/[^"']*)\1""",
  );
  final mapRouteKey = RegExp(
    r"""(["'])[A-Za-z0-9_]*[Rr]oute[A-Za-z0-9_]*\1\s*:\s*(["'])(/[^"']*)\2""",
  );
  final routes = <_RouteLiteral>[];

  for (final file
      in root
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final path = _normalize(file.path);
    final lines = file.readAsLinesSync();
    for (var index = 0; index < lines.length; index += 1) {
      final line = lines[index];
      final namedMatch = routeField.firstMatch(line);
      final mapMatch = mapRouteKey.firstMatch(line);
      final value = namedMatch?.group(2) ?? mapMatch?.group(3);
      if (value == null || value.startsWith('//')) continue;
      routes.add(_RouteLiteral('$path:${index + 1}', value));
    }
  }

  return routes;
}

String _sampleRoute(String route) {
  final uri = Uri.parse(route);
  final sampledPathSegments = uri.pathSegments.map((segment) {
    if (segment.startsWith(':')) return 'sample';
    return segment
        .replaceAll(RegExp(r'\$\{[^}]+\}'), 'sample')
        .replaceAll(RegExp(r'\$[A-Za-z_][A-Za-z0-9_]*'), 'sample');
  }).toList();

  final sampledPath = uri.path.startsWith('/')
      ? '/${sampledPathSegments.join('/')}'
      : sampledPathSegments.join('/');
  return uri.replace(path: sampledPath).toString();
}

String _normalize(String path) => path.replaceAll('\\', '/');

final class _RouteLiteral {
  const _RouteLiteral(this.source, this.value);

  final String source;
  final String value;
}
