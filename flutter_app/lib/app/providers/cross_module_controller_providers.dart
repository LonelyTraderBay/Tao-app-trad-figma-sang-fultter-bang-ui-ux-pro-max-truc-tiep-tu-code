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

final crossModuleAnalyticsSnapshotProvider =
    FutureProvider<CrossModuleAnalyticsSnapshot>(
      (ref) => ref
          .watch(analytics_data.crossModuleAnalyticsRepositoryProvider)
          .getAnalytics(),
    );

final smartAlertsSnapshotProvider = FutureProvider<SmartAlertsSnapshot>(
  (ref) => ref.watch(alerts_data.smartAlertsRepositoryProvider).getCenter(),
);

final taxReportSnapshotProvider = FutureProvider<TaxReportSnapshot>(
  (ref) => ref.watch(tax_data.taxReportRepositoryProvider).getCenter(),
);

final unifiedPortfolioSnapshotProvider =
    FutureProvider<UnifiedPortfolioSnapshot>(
      (ref) => ref
          .watch(portfolio_data.unifiedPortfolioRepositoryProvider)
          .getDashboard(),
    );

// STATE-S25 khuôn (xem GD4-Async-Playbook.md mục 4 "Controller wrapper
// thuần đọc"): 4 controller dưới đây không có mutation nội bộ — chỉ bọc
// AsyncValue quanh phần SEED từ snapshot đọc; consumer widget tự `.when()`
// loading/error/data.

final crossModuleAnalyticsControllerProvider =
    Provider<AsyncValue<CrossModuleAnalyticsController>>((ref) {
      return ref
          .watch(crossModuleAnalyticsSnapshotProvider)
          .whenData(
            (snapshot) => CrossModuleAnalyticsController(
              state: CrossModuleAnalyticsViewState(snapshot: snapshot),
            ),
          );
    });

final smartAlertsControllerProvider =
    Provider<AsyncValue<SmartAlertsController>>((ref) {
      return ref
          .watch(smartAlertsSnapshotProvider)
          .whenData(
            (snapshot) => SmartAlertsController(
              state: SmartAlertsViewState(snapshot: snapshot),
            ),
          );
    });

final taxReportControllerProvider = Provider<AsyncValue<TaxReportController>>((
  ref,
) {
  return ref
      .watch(taxReportSnapshotProvider)
      .whenData(
        (snapshot) =>
            TaxReportController(state: TaxReportViewState(snapshot: snapshot)),
      );
});

final unifiedPortfolioControllerProvider =
    Provider<AsyncValue<UnifiedPortfolioController>>((ref) {
      return ref
          .watch(unifiedPortfolioSnapshotProvider)
          .whenData(
            (snapshot) => UnifiedPortfolioController(
              state: UnifiedPortfolioViewState(snapshot: snapshot),
            ),
          );
    });
