final class TradeTerminalRoutePaths {
  const TradeTerminalRoutePaths._();

  static String tradeAdvancedChart(String pairId) =>
      '/trade/advanced-chart/$pairId';
  static const String tradeRiskManagement = '/trade/risk-management';
  static const String tradeExecutionQuality = '/trade/execution-quality';
  static const String tradeAdvancedTools = '/trade/advanced-tools';
  static const String tradeMarginAdvancedDemo = '/trade/margin/advanced-demo';
  static const String tradeMarginAdvancedAnalytics =
      '/trade/margin/advanced-analytics';
}

final class TradeTerminalRouteNames {
  const TradeTerminalRouteNames._();

  static const String sc055AdvancedChart = 'sc055AdvancedChart';
  static const String sc060RiskManagement = 'sc060RiskManagement';
  static const String sc061ExecutionQuality = 'sc061ExecutionQuality';
  static const String sc062AdvancedTools = 'sc062AdvancedTools';
  static const String sc088AdvancedTradingDemo = 'sc088AdvancedTradingDemo';
  static const String sc092AdvancedAnalytics = 'sc092AdvancedAnalytics';
}
