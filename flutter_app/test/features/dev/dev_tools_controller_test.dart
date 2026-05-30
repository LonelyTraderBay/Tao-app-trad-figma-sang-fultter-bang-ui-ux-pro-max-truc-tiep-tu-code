import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/dev/data/repositories/mock_dev_tools_repository.dart';
import 'package:vit_trade_flutter/features/dev/presentation/controllers/dev_tools_controller.dart';

void main() {
  group('dev tools controllers', () {
    test('route checker exposes a route snapshot from repository contract', () {
      final controller = RouteCheckerController(
        const MockRouteCheckerRepository(),
      );

      final snapshot = controller.snapshot();

      expect(snapshot.endpoint, '/api/mobile/dev/dev-route-checker');
      expect(snapshot.totalRoutes, 43);
      expect(snapshot.supportedStates, contains(DevScreenState.offline));
    });

    test('performance monitor exposes mock read model', () {
      final controller = PerformanceMonitorController(
        const MockPerformanceMonitorRepository(),
      );

      final snapshot = controller.snapshot();

      expect(snapshot.endpoint, '/api/mobile/dev/dev-performance-monitor');
      expect(snapshot.summaryMetrics, hasLength(3));
      expect(snapshot.targets, contains('FCP < 1.8s (Good)'));
    });

    test('showcase and design system controllers expose static drafts', () {
      final showcase = MissingScreensShowcaseController(
        const MockMissingScreensShowcaseRepository(),
      ).snapshot();
      final designSystem = DesignSystemController(
        const MockDesignSystemRepository(),
      ).snapshot();

      expect(showcase.newScreens, hasLength(3));
      expect(showcase.flowConnections, isNotEmpty);
      expect(designSystem.swatches, isNotEmpty);
      expect(designSystem.playgroundControls, contains('variant'));
    });
  });
}
