import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';

void main() {
  ProviderContainer container() {
    final value = ProviderContainer();
    addTearDown(value.dispose);
    return value;
  }

  test('CrossModuleAnalyticsController exposes supported tabs', () {
    final controller = container().read(crossModuleAnalyticsControllerProvider);

    expect(controller.supportsTab(CrossModuleAnalyticsTab.performance), isTrue);
    expect(controller.state.snapshot.modules, isNotEmpty);
  });

  test('SmartAlertsController exposes supported tabs', () {
    final controller = container().read(smartAlertsControllerProvider);

    expect(controller.supportsTab(SmartAlertTab.active), isTrue);
    expect(controller.state.snapshot.activeCount, greaterThanOrEqualTo(0));
  });

  test('TaxReportController exposes format policy', () {
    final controller = container().read(taxReportControllerProvider);

    expect(controller.supportsFormat(TaxExportFormat.pdf), isTrue);
    expect(controller.state.snapshot.taxableModules, greaterThanOrEqualTo(0));
  });

  test('UnifiedPortfolioController exposes supported tabs', () {
    final controller = container().read(unifiedPortfolioControllerProvider);

    expect(controller.supportsTab(UnifiedPortfolioTab.overview), isTrue);
    expect(controller.state.snapshot.activeModules, greaterThanOrEqualTo(0));
  });
}
