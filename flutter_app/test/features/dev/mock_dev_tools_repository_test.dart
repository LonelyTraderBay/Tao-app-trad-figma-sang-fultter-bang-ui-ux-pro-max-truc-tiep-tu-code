import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/dev/data/repositories/mock_dev_tools_repository.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';

/// Smoke test for the dev feature's Mock*Repository classes: exercises every
/// method on [RouteCheckerRepository], [PerformanceMonitorRepository],
/// [MissingScreensShowcaseRepository], and [DesignSystemRepository] and
/// asserts each call succeeds without throwing and returns a plausible,
/// correctly-typed result.
void main() {
  group('MockRouteCheckerRepository smoke test', () {
    const repository = MockRouteCheckerRepository(loadDelay: Duration.zero);

    test('getRouteChecker returns a populated snapshot', () async {
      final snapshot = await repository.getRouteChecker();

      expect(snapshot, isA<RouteCheckerSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/dev/dev-route-checker');
      expect(snapshot.title, 'Staking Route Checker');
      expect(snapshot.backRoute, '/home');
      expect(snapshot.routes, isNotEmpty);
      expect(snapshot.totalRoutes, snapshot.routes.length);
      expect(snapshot.phases, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, contains(DevScreenState.offline));
    });
  });

  group('MockPerformanceMonitorRepository smoke test', () {
    const repository = MockPerformanceMonitorRepository(
      loadDelay: Duration.zero,
    );

    test('getPerformanceMonitor returns a populated snapshot', () async {
      final snapshot = await repository.getPerformanceMonitor();

      expect(snapshot, isA<PerformanceMonitorSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/dev/dev-performance-monitor');
      expect(snapshot.title, 'Performance Monitor');
      expect(snapshot.summaryMetrics, hasLength(3));
      expect(snapshot.vitals, isNotEmpty);
      expect(snapshot.memory, isA<PerformanceMemoryUsage>());
      expect(snapshot.lazyChunks, isNotEmpty);
      expect(snapshot.resources, isNotEmpty);
      expect(snapshot.tips, isNotEmpty);
      expect(snapshot.targets, contains('FCP < 1.8s (Good)'));
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, contains(DevScreenState.offline));
    });
  });

  group('MockMissingScreensShowcaseRepository smoke test', () {
    const repository = MockMissingScreensShowcaseRepository(
      loadDelay: Duration.zero,
    );

    test('getShowcase returns a populated snapshot', () async {
      final snapshot = await repository.getShowcase();

      expect(snapshot, isA<MissingScreensShowcaseSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/dev/dev-showcase');
      expect(snapshot.tabs, hasLength(2));
      expect(snapshot.newScreens, hasLength(3));
      expect(snapshot.newScreensIntro, isNotEmpty);
      expect(snapshot.v2Pages, isNotEmpty);
      expect(snapshot.v2Intro, isNotEmpty);
      expect(snapshot.flowConnections, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, contains(DevScreenState.offline));
    });
  });

  group('MockDesignSystemRepository smoke test', () {
    const repository = MockDesignSystemRepository(loadDelay: Duration.zero);

    test('getDesignSystem returns a populated snapshot', () async {
      final snapshot = await repository.getDesignSystem();

      expect(snapshot, isA<DesignSystemSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/dev/dev-design-system');
      expect(snapshot.title, 'Design System');
      expect(snapshot.tokens, isNotEmpty);
      expect(snapshot.swatches, isNotEmpty);
      expect(snapshot.ctaDemos, isNotEmpty);
      expect(snapshot.inputDemos, isNotEmpty);
      expect(snapshot.sectionDemos, isNotEmpty);
      expect(snapshot.playgroundControls, contains('variant'));
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, contains(DevScreenState.offline));
    });
  });
}
