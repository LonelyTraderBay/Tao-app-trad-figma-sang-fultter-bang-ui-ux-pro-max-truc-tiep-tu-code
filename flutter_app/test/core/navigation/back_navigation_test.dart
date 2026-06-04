import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';

void main() {
  group('resolveSafeBackPath', () {
    test('returns internal candidate when no prefix is required', () {
      expect(
        resolveSafeBackPath(
          candidate: '/trade/copy-trading',
          fallbackPath: '/trade',
        ),
        '/trade/copy-trading',
      );
    });

    test('decodes encoded app path', () {
      expect(
        resolveSafeBackPath(
          candidate: Uri.encodeComponent('/trade/copy-trading'),
          fallbackPath: '/trade',
        ),
        '/trade/copy-trading',
      );
    });

    test('rejects empty, relative, external, and protocol-relative paths', () {
      for (final candidate in [
        '',
        'trade/copy',
        'https://example.com',
        'javascript:alert(1)',
        '//example.com/path',
        r'/trade\copy',
        '/trade/../wallet',
      ]) {
        expect(
          resolveSafeBackPath(candidate: candidate, fallbackPath: '/trade'),
          '/trade',
          reason: 'candidate=$candidate',
        );
      }
    });

    test('enforces allowed prefixes', () {
      expect(
        resolveSafeBackPath(
          candidate: '/trade/copy-trading/providers',
          fallbackPath: '/trade',
          allowedPrefixes: const ['/trade'],
        ),
        '/trade/copy-trading/providers',
      );
      expect(
        resolveSafeBackPath(
          candidate: '/wallet',
          fallbackPath: '/trade',
          allowedPrefixes: const ['/trade'],
        ),
        '/trade',
      );
    });
  });

  group('goBackOrFallback', () {
    testWidgets('parentRouteOnly always goes to the fallback route', (
      tester,
    ) async {
      final router = _buildRouter(
        sourceMode: BackNavigationMode.parentRouteOnly,
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      router.go('/source');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_backKey));
      await tester.pumpAndSettle();

      expect(find.text('Fallback'), findsOneWidget);
    });

    testWidgets('historyThenFallback uses fallback for direct entry', (
      tester,
    ) async {
      final router = _buildRouter(
        sourceMode: BackNavigationMode.historyThenFallback,
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      router.go('/source');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_backKey));
      await tester.pumpAndSettle();

      expect(find.text('Fallback'), findsOneWidget);
    });

    testWidgets('historyThenFallback pops when route history exists', (
      tester,
    ) async {
      final router = _buildRouter(
        sourceMode: BackNavigationMode.historyThenFallback,
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.tap(find.byKey(_pushSourceKey));
      await tester.pumpAndSettle();

      expect(find.text('Source'), findsOneWidget);

      await tester.tap(find.byKey(_backKey));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });
  });
}

const _pushSourceKey = Key('push_source');
const _backKey = Key('back_button');

GoRouter _buildRouter({required BackNavigationMode sourceMode}) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => Scaffold(
          body: Center(
            child: FilledButton(
              key: _pushSourceKey,
              onPressed: () => context.push('/source'),
              child: const Text('Home'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/source',
        builder: (context, state) => Scaffold(
          body: Center(
            child: FilledButton(
              key: _backKey,
              onPressed: () => goBackOrFallback(
                context,
                fallbackPath: '/fallback',
                mode: sourceMode,
              ),
              child: const Text('Source'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/fallback',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Fallback'))),
      ),
    ],
  );
}
