import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';

/// Smoke test for [MockDcaRepository]: exercises every method on
/// [DcaRepository] and asserts each call succeeds without throwing and
/// returns a plausible, non-empty result.
void main() {
  const repository = MockDcaRepository();

  group('MockDcaRepository smoke test', () {
    test('getDashboard returns a populated snapshot', () {
      final snapshot = repository.getDashboard();

      expect(snapshot, isA<DcaDashboardSnapshot>());
      expect(snapshot.screenState, DcaScreenState.success);
      expect(snapshot.tools, isNotEmpty);
      expect(snapshot.plans, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.sparkline, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getRebalanceConfig returns a populated snapshot', () {
      final snapshot = repository.getRebalanceConfig();

      expect(snapshot, isA<DcaRebalanceConfigSnapshot>());
      expect(snapshot.targets, isNotEmpty);
      expect(snapshot.strategyOptions, isNotEmpty);
      expect(snapshot.frequencyOptions, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test(
      'getRebalanceDashboard echoes the requested configId without throwing',
      () {
        late final DcaRebalanceDashboardSnapshot snapshot;

        expect(
          () => snapshot = repository.getRebalanceDashboard('config-123'),
          returnsNormally,
        );
        expect(snapshot, isA<DcaRebalanceDashboardSnapshot>());
        expect(snapshot.configId, 'config-123');
        expect(snapshot.endpoint, isNotEmpty);
      },
    );

    test('getScheduleConfig returns a populated snapshot', () {
      final snapshot = repository.getScheduleConfig();

      expect(snapshot, isA<DcaScheduleConfigSnapshot>());
      expect(snapshot.strategies, isNotEmpty);
      expect(snapshot.timePreferences, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test(
      'getScheduleAnalytics echoes the requested configId without throwing',
      () {
        late final DcaScheduleAnalyticsSnapshot snapshot;

        expect(
          () => snapshot = repository.getScheduleAnalytics('config-456'),
          returnsNormally,
        );
        expect(snapshot, isA<DcaScheduleAnalyticsSnapshot>());
        expect(snapshot.configId, 'config-456');
        expect(snapshot.endpoint, isNotEmpty);
      },
    );

    test('getPortfolioOptimizer returns a populated snapshot', () {
      final snapshot = repository.getPortfolioOptimizer();

      expect(snapshot, isA<DcaPortfolioOptimizerSnapshot>());
      expect(snapshot.currentAllocations, isNotEmpty);
      expect(snapshot.frontier, isNotEmpty);
      expect(snapshot.suggestions, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getDynamicAmount returns a populated snapshot', () {
      final snapshot = repository.getDynamicAmount();

      expect(snapshot, isA<DcaDynamicAmountSnapshot>());
      expect(snapshot.strategies, isNotEmpty);
      expect(snapshot.volatilityHistory, isNotEmpty);
      expect(snapshot.amountHistory, isNotEmpty);
      expect(snapshot.configItems, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getBacktester returns a populated snapshot', () {
      final snapshot = repository.getBacktester();

      expect(snapshot, isA<DcaBacktesterSnapshot>());
      expect(snapshot.assets, isNotEmpty);
      expect(snapshot.frequencies, isNotEmpty);
      expect(snapshot.strategies, isNotEmpty);
      expect(snapshot.historicalData, isNotEmpty);
      expect(snapshot.drawdowns, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getMultiAsset returns a populated snapshot', () {
      final snapshot = repository.getMultiAsset();

      expect(snapshot, isA<DcaMultiAssetSnapshot>());
      expect(snapshot.allocations, isNotEmpty);
      expect(snapshot.performance, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getPerformanceCompare returns a populated snapshot', () {
      final snapshot = repository.getPerformanceCompare();

      expect(snapshot, isA<DcaPerformanceCompareSnapshot>());
      expect(snapshot.comparison, isNotEmpty);
      expect(snapshot.metrics, isNotEmpty);
      expect(snapshot.scenarios, isNotEmpty);
      expect(snapshot.radar, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getSmartRules returns a populated snapshot', () {
      final snapshot = repository.getSmartRules();

      expect(snapshot, isA<DcaSmartRulesSnapshot>());
      expect(snapshot.smartRules, isNotEmpty);
      expect(snapshot.templates, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getOverviewDemo returns a populated snapshot', () {
      final snapshot = repository.getOverviewDemo();

      expect(snapshot, isA<DcaOverviewDemoSnapshot>());
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.scenarios, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });
  });
}
