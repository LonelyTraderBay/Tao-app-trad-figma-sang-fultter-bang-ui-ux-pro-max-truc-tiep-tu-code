import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_cross_module_analytics_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/cross_module_analytics_entities.dart';

/// Direct smoke test for [MockCrossModuleAnalyticsRepository]: exercises the
/// single method on [CrossModuleAnalyticsRepository] (getAnalytics) and pins
/// the fixture and derived-aggregate literals from
/// lib/features/cross_module/data/repositories/mock_cross_module_analytics_repository.dart,
/// which
/// test/features/cross_module/mock_cross_module_analytics_repository_test.dart
/// only asserts the shape of (greaterThan(0)/hasLength).
void main() {
  const repository = MockCrossModuleAnalyticsRepository(
    loadDelay: Duration.zero,
  );

  group('MockCrossModuleAnalyticsRepository smoke test', () {
    test('getAnalytics pins the endpoint, tabs and module fixture', () async {
      final snapshot = await repository.getAnalytics();

      expect(snapshot, isA<CrossModuleAnalyticsSnapshot>());
      expect(
        snapshot.endpoint,
        '/api/mobile/cross-module/cross-module-analytics',
      );
      expect(snapshot.backRoute, '/home');
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.modules, hasLength(4));

      final trading = snapshot.modules.first;
      expect(trading.id, AnalyticsModuleId.trading);
      expect(trading.roi, 12.5);
      expect(trading.totalTrades, 245);

      expect(snapshot.monthlyPerformance, hasLength(6));
      expect(snapshot.monthlyPerformance.first.month, 'Jan');
    });

    test('getAnalytics pins the derived aggregate stats', () async {
      final snapshot = await repository.getAnalytics();

      expect(snapshot.averageRoi, 10.45);
      expect(snapshot.totalTrades, 372);
      expect(snapshot.totalVolume, 281690);
      expect(snapshot.averageWinRate, 79);
      expect(snapshot.bestRoiModule.id, AnalyticsModuleId.predictions);
      expect(snapshot.mostActiveModule.id, AnalyticsModuleId.trading);
    });
  });
}
