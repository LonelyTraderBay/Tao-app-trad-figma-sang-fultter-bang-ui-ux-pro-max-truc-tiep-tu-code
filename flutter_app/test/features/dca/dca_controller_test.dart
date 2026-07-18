import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

void main() {
  ProviderContainer container() {
    final value = ProviderContainer();
    addTearDown(value.dispose);
    return value;
  }

  test('DCA read-model providers expose dashboard and smart rules', () async {
    final value = container();

    expect((await value.read(dcaDashboardProvider.future)).plans, isNotEmpty);
    expect(
      (await value.read(dcaSmartRulesProvider.future)).smartRules,
      isNotEmpty,
    );
    expect(
      (await value.read(dcaOverviewDemoProvider.future)).scenarios,
      isNotEmpty,
    );
  });

  test('DCA family providers preserve config identifiers', () async {
    final value = container();

    expect(
      (await value.read(
        dcaRebalanceDashboardProvider('config-123').future,
      )).configId,
      'config-123',
    );
    expect(
      (await value.read(
        dcaScheduleAnalyticsProvider('config-456').future,
      )).configId,
      'config-456',
    );
  });

  test('DCA advanced read models are reachable outside presentation', () async {
    final value = container();

    expect(
      (await value.read(dcaRebalanceConfigProvider.future)).targets,
      isNotEmpty,
    );
    expect(
      (await value.read(dcaScheduleConfigProvider.future)).strategies,
      isNotEmpty,
    );
    expect(
      (await value.read(dcaPortfolioOptimizerProvider.future)).suggestions,
      isNotEmpty,
    );
    expect(
      (await value.read(dcaDynamicAmountProvider.future)).strategies,
      isNotEmpty,
    );
    expect(
      (await value.read(dcaBacktesterProvider.future)).historicalData,
      isNotEmpty,
    );
    expect(
      (await value.read(dcaMultiAssetProvider.future)).allocations,
      isNotEmpty,
    );
    expect(
      (await value.read(dcaPerformanceCompareProvider.future)).comparison,
      isNotEmpty,
    );
  });
}
