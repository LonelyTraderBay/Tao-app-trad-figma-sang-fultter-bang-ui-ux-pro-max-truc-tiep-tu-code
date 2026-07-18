import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/dev/data/repositories/mock_dev_tools_repository.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';

/// Fixture-pinning test for the dev feature's Mock*Repository classes:
/// every method is already exercised for shape (non-empty lists, populated
/// strings) in `test/features/dev/mock_dev_tools_repository_test.dart`.
/// This file pins the exact literal values that make each reference fixture
/// meaningful — the route-checker's claimed "43 routes" total, the design
/// system's token/swatch values, the performance monitor's headline metrics,
/// and the showcase's screen/tab ids — so a silent content regression fails
/// a test instead of only a visual diff. There is no fail-closed variant for
/// this feature: dev tools are always backed by mock reference data (see
/// `lib/features/dev/data/providers/dev_tools_repository_provider.dart`).
void main() {
  group('MockRouteCheckerRepository fixture pins', () {
    const repository = MockRouteCheckerRepository(loadDelay: Duration.zero);

    test('routes total matches the subtitle claim of 43 routes', () async {
      final snapshot = await repository.getRouteChecker();

      expect(snapshot.subtitle, contains('43 routes'));
      expect(snapshot.routes, hasLength(43));
      expect(snapshot.totalRoutes, 43);
    });

    test('first and last route pin path, name, and phase', () async {
      final routes = (await repository.getRouteChecker()).routes;

      expect(routes.first.path, '/earn/staking/terms');
      expect(routes.first.name, 'Terms of Service');
      expect(routes.first.phase, 1);
      expect(routes.last.path, '/earn/developer-console');
      expect(routes.last.name, 'Developer Console');
      expect(routes.last.phase, 8);
    });
  });

  group('MockPerformanceMonitorRepository fixture pins', () {
    const repository = MockPerformanceMonitorRepository(
      loadDelay: Duration.zero,
    );

    test(
      'summaryMetrics pin FCP, LCP, and Load Time headline values',
      () async {
        final metrics =
            (await repository.getPerformanceMonitor()).summaryMetrics;

        expect(metrics[0].label, 'FCP');
        expect(metrics[0].value, '6244ms');
        expect(metrics[0].tone, PerformanceScoreTone.poor);
        expect(metrics[1].label, 'LCP');
        expect(metrics[1].value, '0ms');
        expect(metrics[2].label, 'Load Time');
        expect(metrics[2].value, '0.00s');
      },
    );

    test('memory usage pins the used/limit/percent labels', () async {
      final memory = (await repository.getPerformanceMonitor()).memory;

      expect(memory.usedLabel, '87.5 MB');
      expect(memory.limitLabel, 'of 3586 MB limit');
      expect(memory.percentLabel, '2.4%');
    });

    test('lazyChunks and resources pin the reference counts', () async {
      final snapshot = await repository.getPerformanceMonitor();

      expect(snapshot.lazyChunks, hasLength(3));
      expect(snapshot.resources, hasLength(10));
      expect(snapshot.resources.first.name, 'ArenaPointsLedgerPage.tsx');
      expect(snapshot.targets, [
        'FCP < 1.8s (Good)',
        'LCP < 2.5s (Good)',
        'Total Load < 3s (Good)',
        'Memory < 50MB (Mobile-friendly)',
      ]);
    });
  });

  group('MockMissingScreensShowcaseRepository fixture pins', () {
    const repository = MockMissingScreensShowcaseRepository(
      loadDelay: Duration.zero,
    );

    test('tabs and newScreens pin ids and label counts', () async {
      final snapshot = await repository.getShowcase();

      expect(snapshot.tabs, hasLength(2));
      expect(snapshot.tabs[0].id, 'new');
      expect(snapshot.tabs[0].label, 'New Screens (3)');
      expect(snapshot.tabs[1].id, 'v2');

      expect(snapshot.newScreens, hasLength(3));
      expect(
        snapshot.newScreens.map((screen) => screen.id),
        containsAllInOrder(<String>[
          'reset_password',
          'p2p_orders',
          'wallet_tx',
        ]),
      );
      expect(snapshot.newScreens.first.route, '/auth/reset-password');
    });

    test('v2Pages and flowConnections pin the reference counts', () async {
      final snapshot = await repository.getShowcase();

      expect(snapshot.v2Pages, hasLength(4));
      expect(snapshot.flowConnections, hasLength(7));
      expect(snapshot.flowConnections.first.id, 'otp_reset');
    });
  });

  group('MockDesignSystemRepository fixture pins', () {
    const repository = MockDesignSystemRepository(loadDelay: Duration.zero);

    test('tokens and swatches pin design-token values', () async {
      final snapshot = await repository.getDesignSystem();

      expect(snapshot.tokens, hasLength(9));
      expect(snapshot.tokens.first.label, '--input-height');
      expect(snapshot.tokens.first.value, '52px');

      expect(snapshot.swatches, hasLength(15));
      final primarySwatch = snapshot.swatches.firstWhere(
        (swatch) => swatch.id == 'primary',
      );
      expect(primarySwatch.value, '#E58A00');
    });

    test(
      'ctaDemos and footer copy pin the reference counts and text',
      () async {
        final snapshot = await repository.getDesignSystem();

        expect(snapshot.ctaDemos, hasLength(6));
        expect(snapshot.inputDemos, hasLength(4));
        expect(
          snapshot.footerTitle,
          'VitTrade Design System v2.4 — iPhone 16 Pro Max (440×956pt)',
        );
      },
    );
  });
}
