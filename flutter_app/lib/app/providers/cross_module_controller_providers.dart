import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/cross_module/data/providers/cross_module_analytics_repository_provider.dart'
    as analytics_data;
import 'package:vit_trade_flutter/features/cross_module/data/providers/smart_alerts_repository_provider.dart'
    as alerts_data;
import 'package:vit_trade_flutter/features/cross_module/data/providers/tax_report_repository_provider.dart'
    as tax_data;
import 'package:vit_trade_flutter/features/cross_module/data/providers/unified_portfolio_repository_provider.dart'
    as portfolio_data;
import 'package:vit_trade_flutter/features/cross_module/presentation/controllers/cross_module_analytics_controller.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/controllers/smart_alerts_controller.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/controllers/tax_report_controller.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/controllers/unified_portfolio_controller.dart';

export 'package:vit_trade_flutter/features/cross_module/presentation/controllers/cross_module_analytics_controller.dart';
export 'package:vit_trade_flutter/features/cross_module/presentation/controllers/smart_alerts_controller.dart';
export 'package:vit_trade_flutter/features/cross_module/presentation/controllers/tax_report_controller.dart';
export 'package:vit_trade_flutter/features/cross_module/presentation/controllers/unified_portfolio_controller.dart';

final crossModuleAnalyticsControllerProvider =
    Provider<CrossModuleAnalyticsController>((ref) {
      final snapshot = ref
          .watch(analytics_data.crossModuleAnalyticsRepositoryProvider)
          .getAnalytics();
      return CrossModuleAnalyticsController(
        state: CrossModuleAnalyticsViewState(snapshot: snapshot),
      );
    });

final smartAlertsControllerProvider = Provider<SmartAlertsController>((ref) {
  final snapshot = ref
      .watch(alerts_data.smartAlertsRepositoryProvider)
      .getCenter();
  return SmartAlertsController(state: SmartAlertsViewState(snapshot: snapshot));
});

final taxReportControllerProvider = Provider<TaxReportController>((ref) {
  final snapshot = ref.watch(tax_data.taxReportRepositoryProvider).getCenter();
  return TaxReportController(state: TaxReportViewState(snapshot: snapshot));
});

final unifiedPortfolioControllerProvider = Provider<UnifiedPortfolioController>(
  (ref) {
    final snapshot = ref
        .watch(portfolio_data.unifiedPortfolioRepositoryProvider)
        .getDashboard();
    return UnifiedPortfolioController(
      state: UnifiedPortfolioViewState(snapshot: snapshot),
    );
  },
);
