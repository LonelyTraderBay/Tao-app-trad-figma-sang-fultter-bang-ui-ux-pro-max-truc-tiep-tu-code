final class DcaRoutePaths {
  const DcaRoutePaths._();

  static const String dca = '/dca';
  static const String dcaPortfolioOptimizer = '/dca/portfolio-optimizer';
  static const String dcaDynamicAmount = '/dca/dynamic-amount';
  static const String dcaRebalanceConfig = '/dca/rebalance/config';
  static const String dcaRebalanceDashboard = '/dca/rebalance/config001';
  static String dcaRebalanceEdit(String configId) =>
      '/dca/rebalance/$configId/edit';
  static String dcaRebalanceHistory(String configId) =>
      '/dca/rebalance/$configId/history';
  static const String dcaScheduleConfig = '/dca/schedule/config';
  static const String dcaScheduleAnalytics = '/dca/schedule/config001';
  static const String dcaBacktester = '/dca/backtester';
  static const String dcaMultiAsset = '/dca/multi-asset';
  static const String dcaPerformanceCompare = '/dca/performance-compare';
  static const String dcaSmartRules = '/dca/smart-rules';
}

final class DcaRouteNames {
  const DcaRouteNames._();

  static const String sc169Dca = 'sc169Dca';
  static const String sc170DcaRebalanceConfig = 'sc170DcaRebalanceConfig';
  static const String sc171DcaRebalanceDashboard = 'sc171DcaRebalanceDashboard';
  static const String sc172DcaScheduleConfig = 'sc172DcaScheduleConfig';
  static const String sc173DcaScheduleAnalytics = 'sc173DcaScheduleAnalytics';
  static const String sc174DcaPortfolioOptimizer = 'sc174DcaPortfolioOptimizer';
  static const String sc175DcaDynamicAmount = 'sc175DcaDynamicAmount';
  static const String sc176DcaBacktester = 'sc176DcaBacktester';
  static const String sc177DcaMultiAsset = 'sc177DcaMultiAsset';
  static const String sc178DcaPerformanceCompare = 'sc178DcaPerformanceCompare';
  static const String sc179DcaSmartRules = 'sc179DcaSmartRules';
  static const String sc408DcaRebalanceEdit = 'sc408DcaRebalanceEdit';
  static const String sc409DcaRebalanceHistory = 'sc409DcaRebalanceHistory';
}
