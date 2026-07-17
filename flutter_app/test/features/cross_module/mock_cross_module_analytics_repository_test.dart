import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_cross_module_analytics_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/cross_module_analytics_entities.dart';

/// Smoke test for [MockCrossModuleAnalyticsRepository]: exercises
/// [MockCrossModuleAnalyticsRepository.getAnalytics] and asserts the call
/// succeeds without throwing and returns a plausible, non-empty result.
void main() {
  const repository = MockCrossModuleAnalyticsRepository();

  group('MockCrossModuleAnalyticsRepository smoke test', () {
    test('getAnalytics returns a populated snapshot', () {
      final snapshot = repository.getAnalytics();

      expect(snapshot, isA<CrossModuleAnalyticsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.modules, hasLength(4));
      expect(snapshot.modules.first.id, AnalyticsModuleId.trading);
      expect(snapshot.monthlyPerformance, hasLength(6));
      expect(snapshot.contractNotes, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getAnalytics derived stats can be computed without throwing', () {
      final snapshot = repository.getAnalytics();

      expect(snapshot.averageRoi, greaterThan(0));
      expect(snapshot.totalTrades, greaterThan(0));
      expect(snapshot.totalVolume, greaterThan(0));
      expect(snapshot.averageWinRate, greaterThan(0));
      expect(snapshot.bestRoiModule.name, isNotEmpty);
      expect(snapshot.mostActiveModule.name, isNotEmpty);
    });
  });
}
