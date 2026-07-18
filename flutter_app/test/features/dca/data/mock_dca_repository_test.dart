import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';

/// Repository-layer smoke test for [MockDcaRepository] under the
/// `test/features/<feature>/data/` convention (see
/// `test/features/p2p/data/mock_p2p_repository_orders_test.dart`).
///
/// Every method on [DcaRepository] already gets an isA<>/isNotEmpty smoke
/// pass in the sibling `test/features/dca/mock_dca_repository_test.dart`.
/// This file complements that coverage by pinning concrete, hand-verified
/// values from the fixtures in
/// `lib/features/dca/data/fixtures/mock_dca_repository_methods_*.dart` so a
/// silent fixture edit shows up as a failing assertion, not just a
/// type/emptiness check. DcaRepository has no write/action methods — every
/// call below is a plain async getter.
void main() {
  const repository = MockDcaRepository(loadDelay: Duration.zero);

  group('MockDcaRepository data smoke test', () {
    test(
      'getDashboard pins the overview headline and plan/tool counts',
      () async {
        final snapshot = await repository.getDashboard();

        expect(snapshot.endpoint, '/api/mobile/dca/dca');
        expect(snapshot.screenState, DcaScreenState.success);
        expect(snapshot.overview.currentValueVnd, 3027250000);
        expect(snapshot.overview.totalInvestedVnd, 22200000);
        expect(snapshot.overview.activePlans, 3);
        expect(snapshot.tools, hasLength(4));
        expect(snapshot.plans, hasLength(3));
        expect(snapshot.plans.first.id, 'plan-1');
        expect(snapshot.plans.first.coinSymbol, 'BTC');
        expect(snapshot.history, hasLength(7));
      },
    );

    test(
      'getRebalanceConfig pins portfolio totals and target allocations',
      () async {
        final snapshot = await repository.getRebalanceConfig();

        expect(snapshot.endpoint, '/api/mobile/dca/dca-rebalance-config');
        expect(snapshot.totalPortfolioUsd, 45000);
        expect(snapshot.driftThreshold, 10);
        expect(snapshot.strategy, DcaRebalanceStrategy.threshold);
        expect(snapshot.targets, hasLength(3));
        expect(snapshot.targets.first.symbol, 'BTC');
        expect(snapshot.targets.first.currentPercent, 50);
        expect(snapshot.targets.first.targetPercent, 40);
        expect(snapshot.strategyOptions, hasLength(3));
        expect(snapshot.frequencyOptions, hasLength(4));
      },
    );

    test(
      'getRebalanceDashboard echoes configId and reports not-found',
      () async {
        final snapshot = await repository.getRebalanceDashboard('config-123');

        expect(snapshot.configId, 'config-123');
        expect(snapshot.configFound, isFalse);
        expect(snapshot.message, 'Configuration not found');
        expect(snapshot.dcaPlans, isEmpty);
      },
    );

    test('getScheduleConfig pins the hybrid strategy defaults', () async {
      final snapshot = await repository.getScheduleConfig();

      expect(snapshot.endpoint, '/api/mobile/dca/dca-schedule-config');
      expect(snapshot.strategy, DcaScheduleStrategy.hybrid);
      expect(snapshot.timePreference, DcaScheduleTimePreference.any);
      expect(snapshot.maxDelayHours, 6);
      expect(snapshot.enabled, isTrue);
      expect(snapshot.strategies, hasLength(5));
      expect(snapshot.timePreferences, hasLength(5));
    });

    test(
      'getScheduleAnalytics echoes configId and reports not-found',
      () async {
        final snapshot = await repository.getScheduleAnalytics('config-456');

        expect(snapshot.configId, 'config-456');
        expect(snapshot.configFound, isFalse);
        expect(snapshot.message, 'Configuration not found');
      },
    );

    test(
      'getPortfolioOptimizer pins the score, drift, and suggestion count',
      () async {
        final snapshot = await repository.getPortfolioOptimizer();

        expect(snapshot.endpoint, '/api/mobile/dca/dca-portfolio-optimizer');
        expect(snapshot.score, 73);
        expect(snapshot.driftPercent, 25);
        expect(snapshot.optimalSharpe, 1.40);
        expect(snapshot.currentAllocations, hasLength(5));
        expect(snapshot.frontier, hasLength(5));
        expect(snapshot.suggestions, hasLength(4));
        expect(snapshot.suggestions.first.symbol, 'BTC');
        expect(
          snapshot.suggestions.first.type,
          DcaPortfolioSuggestionType.decrease,
        );
      },
    );

    test('getDynamicAmount pins the active strategy and adjustment', () async {
      final snapshot = await repository.getDynamicAmount();

      expect(snapshot.endpoint, '/api/mobile/dca/dca-dynamic-amount');
      expect(snapshot.activeStrategy, DcaDynamicStrategy.volatility);
      expect(snapshot.adjustment.originalAmountVnd, 500000);
      expect(snapshot.adjustment.multiplier, 1);
      expect(snapshot.strategies, hasLength(5));
      expect(snapshot.volatilityHistory, hasLength(10));
      expect(snapshot.amountHistory, hasLength(6));
      expect(snapshot.configItems, hasLength(6));
    });

    test('getBacktester pins the asset list and backtest result', () async {
      final snapshot = await repository.getBacktester();

      expect(snapshot.endpoint, '/api/mobile/dca/dca-backtester');
      expect(snapshot.assets, ['BTC', 'ETH', 'BNB', 'SOL']);
      expect(snapshot.investmentAmountUsd, 1000);
      expect(snapshot.activeFrequency, DcaBacktestFrequency.monthly);
      expect(snapshot.result.totalInvestedUsd, 12000);
      expect(snapshot.result.finalValueUsd, 145000);
      expect(snapshot.result.totalReturnUsd, 133000);
      expect(snapshot.result.numberOfBuys, 12);
      expect(snapshot.historicalData, hasLength(12));
      expect(snapshot.drawdowns, hasLength(12));
    });

    test('getMultiAsset pins the budget and BTC allocation slice', () async {
      final snapshot = await repository.getMultiAsset();

      expect(snapshot.endpoint, '/api/mobile/dca/dca-multi-asset');
      expect(snapshot.totalBudgetUsd, 1000);
      expect(snapshot.rebalanceEnabled, isTrue);
      expect(snapshot.allocations, hasLength(4));
      expect(snapshot.allocations.first.symbol, 'BTC');
      expect(snapshot.allocations.first.targetPercent, 40);
      expect(snapshot.allocations.first.currentPercent, 42);
      expect(snapshot.performance, hasLength(6));
    });

    test(
      'getPerformanceCompare pins the invested total and metric count',
      () async {
        final snapshot = await repository.getPerformanceCompare();

        expect(snapshot.endpoint, '/api/mobile/dca/dca-performance-compare');
        expect(snapshot.investedUsd, 12000);
        expect(snapshot.comparison, hasLength(12));
        expect(snapshot.metrics, hasLength(5));
        expect(snapshot.metrics.first.label, 'Average Entry Price');
        expect(snapshot.scenarios, hasLength(4));
        expect(snapshot.radar, hasLength(5));
      },
    );

    test(
      'getSmartRules pins the success rate and rule/template counts',
      () async {
        final snapshot = await repository.getSmartRules();

        expect(snapshot.endpoint, '/api/mobile/dca/dca-smart-rules');
        expect(snapshot.successPercent, 95);
        expect(snapshot.smartRules, hasLength(4));
        expect(snapshot.smartRules.first.id, 'rule-buy-dip');
        expect(snapshot.smartRules.first.status, DcaSmartRuleStatus.active);
        expect(snapshot.templates, hasLength(6));
        expect(snapshot.history, hasLength(3));
      },
    );

    test('getOverviewDemo pins the title and demo scenario set', () async {
      final snapshot = await repository.getOverviewDemo();

      expect(snapshot.endpoint, '/api/mobile/dev/dev-dca-overview');
      expect(snapshot.title, 'DCA Overview Card Demo');
      expect(snapshot.componentName, 'DCAOverviewCard');
      expect(snapshot.scenarios, hasLength(5));
      expect(snapshot.scenarios.first.id, 'profitable');
      expect(snapshot.scenarios.first.data.profitLossPercent, 19.3);
      expect(snapshot.mobilePreview.id, 'mobile-preview');
    });
  });
}
