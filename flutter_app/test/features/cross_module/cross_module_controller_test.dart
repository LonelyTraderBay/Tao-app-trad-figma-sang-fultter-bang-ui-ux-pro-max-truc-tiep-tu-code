import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';
import 'package:vit_trade_flutter/features/cross_module/data/providers/cross_module_analytics_repository_provider.dart';
import 'package:vit_trade_flutter/features/cross_module/data/providers/smart_alerts_repository_provider.dart';
import 'package:vit_trade_flutter/features/cross_module/data/providers/tax_report_repository_provider.dart';
import 'package:vit_trade_flutter/features/cross_module/data/providers/unified_portfolio_repository_provider.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_cross_module_analytics_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_smart_alerts_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_tax_report_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_unified_portfolio_repository.dart';

void main() {
  ProviderContainer container() {
    final value = ProviderContainer(
      overrides: [
        crossModuleAnalyticsRepositoryProvider.overrideWithValue(
          const MockCrossModuleAnalyticsRepository(loadDelay: Duration.zero),
        ),
        smartAlertsRepositoryProvider.overrideWithValue(
          const MockSmartAlertsRepository(loadDelay: Duration.zero),
        ),
        taxReportRepositoryProvider.overrideWithValue(
          const MockTaxReportRepository(loadDelay: Duration.zero),
        ),
        unifiedPortfolioRepositoryProvider.overrideWithValue(
          const MockUnifiedPortfolioRepository(loadDelay: Duration.zero),
        ),
      ],
    );
    addTearDown(value.dispose);
    return value;
  }

  test('CrossModuleAnalyticsController exposes supported tabs', () async {
    final ref = container();
    await ref.read(crossModuleAnalyticsSnapshotProvider.future);
    final controller = ref
        .read(crossModuleAnalyticsControllerProvider)
        .requireValue;

    expect(controller.supportsTab(CrossModuleAnalyticsTab.performance), isTrue);
    expect(controller.state.snapshot.modules, isNotEmpty);
  });

  test('SmartAlertsController exposes supported tabs', () async {
    final ref = container();
    await ref.read(smartAlertsSnapshotProvider.future);
    final controller = ref.read(smartAlertsControllerProvider).requireValue;

    expect(controller.supportsTab(SmartAlertTab.active), isTrue);
    expect(controller.state.snapshot.activeCount, greaterThanOrEqualTo(0));
  });

  test('TaxReportController exposes format policy', () async {
    final ref = container();
    await ref.read(taxReportSnapshotProvider.future);
    final controller = ref.read(taxReportControllerProvider).requireValue;

    expect(controller.supportsFormat(TaxExportFormat.pdf), isTrue);
    expect(controller.state.snapshot.taxableModules, greaterThanOrEqualTo(0));
  });

  test('UnifiedPortfolioController exposes supported tabs', () async {
    final ref = container();
    await ref.read(unifiedPortfolioSnapshotProvider.future);
    final controller = ref
        .read(unifiedPortfolioControllerProvider)
        .requireValue;

    expect(controller.supportsTab(UnifiedPortfolioTab.overview), isTrue);
    expect(controller.state.snapshot.activeModules, greaterThanOrEqualTo(0));
  });
}
