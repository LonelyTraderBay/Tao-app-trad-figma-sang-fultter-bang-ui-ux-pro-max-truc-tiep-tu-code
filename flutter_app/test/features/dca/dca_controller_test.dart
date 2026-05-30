import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

void main() {
  ProviderContainer container() {
    final value = ProviderContainer();
    addTearDown(value.dispose);
    return value;
  }

  test('DCA read-model providers expose dashboard and smart rules', () {
    final value = container();

    expect(value.read(dcaDashboardProvider).plans, isNotEmpty);
    expect(value.read(dcaSmartRulesProvider).smartRules, isNotEmpty);
    expect(value.read(dcaOverviewDemoProvider).scenarios, isNotEmpty);
  });

  test('DCA family providers preserve config identifiers', () {
    final value = container();

    expect(
      value.read(dcaRebalanceDashboardProvider('config-123')).configId,
      'config-123',
    );
    expect(
      value.read(dcaScheduleAnalyticsProvider('config-456')).configId,
      'config-456',
    );
  });

  test('DCA advanced read models are reachable outside presentation', () {
    final value = container();

    expect(value.read(dcaRebalanceConfigProvider).targets, isNotEmpty);
    expect(value.read(dcaScheduleConfigProvider).strategies, isNotEmpty);
    expect(value.read(dcaPortfolioOptimizerProvider).suggestions, isNotEmpty);
    expect(value.read(dcaDynamicAmountProvider).strategies, isNotEmpty);
    expect(value.read(dcaBacktesterProvider).historicalData, isNotEmpty);
    expect(value.read(dcaMultiAssetProvider).allocations, isNotEmpty);
    expect(value.read(dcaPerformanceCompareProvider).comparison, isNotEmpty);
  });
}
