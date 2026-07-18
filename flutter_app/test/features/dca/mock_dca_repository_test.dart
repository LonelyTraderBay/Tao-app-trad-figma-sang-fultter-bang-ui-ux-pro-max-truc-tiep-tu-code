import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';

/// Smoke test for [MockDcaRepository]: exercises every method on
/// [DcaRepository] and asserts each call succeeds without throwing and
/// returns a plausible, non-empty result.
void main() {
  const repository = MockDcaRepository(loadDelay: Duration.zero);

  group('MockDcaRepository smoke test', () {
    test('getDashboard returns a populated snapshot', () async {
      final snapshot = await repository.getDashboard();

      expect(snapshot, isA<DcaDashboardSnapshot>());
      expect(snapshot.screenState, DcaScreenState.success);
      expect(snapshot.tools, isNotEmpty);
      expect(snapshot.plans, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.sparkline, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getRebalanceConfig returns a populated snapshot', () async {
      final snapshot = await repository.getRebalanceConfig();

      expect(snapshot, isA<DcaRebalanceConfigSnapshot>());
      expect(snapshot.targets, isNotEmpty);
      expect(snapshot.strategyOptions, isNotEmpty);
      expect(snapshot.frequencyOptions, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test(
      'getRebalanceDashboard echoes the requested configId without throwing',
      () async {
        final snapshot = await repository.getRebalanceDashboard('config-123');

        expect(snapshot, isA<DcaRebalanceDashboardSnapshot>());
        expect(snapshot.configId, 'config-123');
        expect(snapshot.endpoint, isNotEmpty);
      },
    );

    test('getScheduleConfig returns a populated snapshot', () async {
      final snapshot = await repository.getScheduleConfig();

      expect(snapshot, isA<DcaScheduleConfigSnapshot>());
      expect(snapshot.strategies, isNotEmpty);
      expect(snapshot.timePreferences, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test(
      'getScheduleAnalytics echoes the requested configId without throwing',
      () async {
        final snapshot = await repository.getScheduleAnalytics('config-456');

        expect(snapshot, isA<DcaScheduleAnalyticsSnapshot>());
        expect(snapshot.configId, 'config-456');
        expect(snapshot.endpoint, isNotEmpty);
      },
    );

    test('getPortfolioOptimizer returns a populated snapshot', () async {
      final snapshot = await repository.getPortfolioOptimizer();

      expect(snapshot, isA<DcaPortfolioOptimizerSnapshot>());
      expect(snapshot.currentAllocations, isNotEmpty);
      expect(snapshot.frontier, isNotEmpty);
      expect(snapshot.suggestions, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getDynamicAmount returns a populated snapshot', () async {
      final snapshot = await repository.getDynamicAmount();

      expect(snapshot, isA<DcaDynamicAmountSnapshot>());
      expect(snapshot.strategies, isNotEmpty);
      expect(snapshot.volatilityHistory, isNotEmpty);
      expect(snapshot.amountHistory, isNotEmpty);
      expect(snapshot.configItems, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getBacktester returns a populated snapshot', () async {
      final snapshot = await repository.getBacktester();

      expect(snapshot, isA<DcaBacktesterSnapshot>());
      expect(snapshot.assets, isNotEmpty);
      expect(snapshot.frequencies, isNotEmpty);
      expect(snapshot.strategies, isNotEmpty);
      expect(snapshot.historicalData, isNotEmpty);
      expect(snapshot.drawdowns, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getMultiAsset returns a populated snapshot', () async {
      final snapshot = await repository.getMultiAsset();

      expect(snapshot, isA<DcaMultiAssetSnapshot>());
      expect(snapshot.allocations, isNotEmpty);
      expect(snapshot.performance, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getPerformanceCompare returns a populated snapshot', () async {
      final snapshot = await repository.getPerformanceCompare();

      expect(snapshot, isA<DcaPerformanceCompareSnapshot>());
      expect(snapshot.comparison, isNotEmpty);
      expect(snapshot.metrics, isNotEmpty);
      expect(snapshot.scenarios, isNotEmpty);
      expect(snapshot.radar, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getSmartRules returns a populated snapshot', () async {
      final snapshot = await repository.getSmartRules();

      expect(snapshot, isA<DcaSmartRulesSnapshot>());
      expect(snapshot.smartRules, isNotEmpty);
      expect(snapshot.templates, isNotEmpty);
      expect(snapshot.history, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getOverviewDemo returns a populated snapshot', () async {
      final snapshot = await repository.getOverviewDemo();

      expect(snapshot, isA<DcaOverviewDemoSnapshot>());
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.scenarios, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });
  });
}
