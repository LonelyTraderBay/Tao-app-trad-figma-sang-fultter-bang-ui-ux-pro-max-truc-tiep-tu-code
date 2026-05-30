import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/dca/data/providers/dca_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/dca/presentation/controllers/dca_controller.dart';

export 'package:vit_trade_flutter/features/dca/presentation/controllers/dca_controller.dart';

final dcaDashboardProvider = Provider<DcaDashboardSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getDashboard();
});

final dcaRebalanceConfigProvider = Provider<DcaRebalanceConfigSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getRebalanceConfig();
});

final dcaRebalanceDashboardProvider =
    Provider.family<DcaRebalanceDashboardSnapshot, String>((ref, configId) {
      return ref
          .watch(data.dcaRepositoryProvider)
          .getRebalanceDashboard(configId);
    });

final dcaScheduleConfigProvider = Provider<DcaScheduleConfigSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getScheduleConfig();
});

final dcaScheduleAnalyticsProvider =
    Provider.family<DcaScheduleAnalyticsSnapshot, String>((ref, configId) {
      return ref
          .watch(data.dcaRepositoryProvider)
          .getScheduleAnalytics(configId);
    });

final dcaPortfolioOptimizerProvider = Provider<DcaPortfolioOptimizerSnapshot>((
  ref,
) {
  return ref.watch(data.dcaRepositoryProvider).getPortfolioOptimizer();
});

final dcaDynamicAmountProvider = Provider<DcaDynamicAmountSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getDynamicAmount();
});

final dcaBacktesterProvider = Provider<DcaBacktesterSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getBacktester();
});

final dcaMultiAssetProvider = Provider<DcaMultiAssetSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getMultiAsset();
});

final dcaPerformanceCompareProvider = Provider<DcaPerformanceCompareSnapshot>((
  ref,
) {
  return ref.watch(data.dcaRepositoryProvider).getPerformanceCompare();
});

final dcaSmartRulesProvider = Provider<DcaSmartRulesSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getSmartRules();
});

final dcaOverviewDemoProvider = Provider<DcaOverviewDemoSnapshot>((ref) {
  return ref.watch(data.dcaRepositoryProvider).getOverviewDemo();
});
