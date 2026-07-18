import 'package:vit_trade_flutter/features/dca/domain/entities/dca_entities.dart';

/// Data source contract for the DCA (Dollar Cost Averaging) feature: read
/// snapshots for every DCA tool/screen.
abstract interface class DcaRepository {
  Future<DcaDashboardSnapshot> getDashboard();

  Future<DcaRebalanceConfigSnapshot> getRebalanceConfig();

  Future<DcaRebalanceDashboardSnapshot> getRebalanceDashboard(String configId);

  Future<DcaScheduleConfigSnapshot> getScheduleConfig();

  Future<DcaScheduleAnalyticsSnapshot> getScheduleAnalytics(String configId);

  Future<DcaPortfolioOptimizerSnapshot> getPortfolioOptimizer();

  Future<DcaDynamicAmountSnapshot> getDynamicAmount();

  Future<DcaBacktesterSnapshot> getBacktester();

  Future<DcaMultiAssetSnapshot> getMultiAsset();

  Future<DcaPerformanceCompareSnapshot> getPerformanceCompare();

  Future<DcaSmartRulesSnapshot> getSmartRules();

  Future<DcaOverviewDemoSnapshot> getOverviewDemo();
}
