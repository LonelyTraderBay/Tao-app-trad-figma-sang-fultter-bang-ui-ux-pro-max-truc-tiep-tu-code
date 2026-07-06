import 'package:vit_trade_flutter/features/dca/domain/entities/dca_entities.dart';

abstract interface class DcaRepository {
  DcaDashboardSnapshot getDashboard();

  DcaRebalanceConfigSnapshot getRebalanceConfig();

  DcaRebalanceDashboardSnapshot getRebalanceDashboard(String configId);

  DcaScheduleConfigSnapshot getScheduleConfig();

  DcaScheduleAnalyticsSnapshot getScheduleAnalytics(String configId);

  DcaPortfolioOptimizerSnapshot getPortfolioOptimizer();

  DcaDynamicAmountSnapshot getDynamicAmount();

  DcaBacktesterSnapshot getBacktester();

  DcaMultiAssetSnapshot getMultiAsset();

  DcaPerformanceCompareSnapshot getPerformanceCompare();

  DcaSmartRulesSnapshot getSmartRules();

  DcaOverviewDemoSnapshot getOverviewDemo();
}
