final class TradeCopyRoutePaths {
  const TradeCopyRoutePaths._();

  static const String demoCopyCard = '/demo/copy-card';
  static const String tradeCopyTrading = '/trade/copy-trading';
  static const String tradeCopyEducation = '/trade/copy-trading/education';
  static const String tradeCopyActive = '/trade/copy-trading/active';
  static const String tradeCopySettings = '/trade/copy-trading/settings';
  static const String tradeCopyNotifications =
      '/trade/copy-trading/notifications';
  static const String tradeCopyComparison = '/trade/copy-trading/comparison';
  static const String tradeCopyProviderApply = '/trade/copy-provider-apply';
  static String tradeCopyProvider(String providerId, {String? backPath}) {
    final path = '/trade/copy-provider/$providerId';
    if (backPath == null || backPath.isEmpty) return path;
    return '$path?back=${Uri.encodeComponent(backPath)}';
  }

  static String tradeCopyProviderAssessment(String providerId) =>
      '/trade/copy-provider/$providerId/assessment';
  static String tradeCopyProviderConfiguration(
    String providerId, {
    String? backPath,
  }) {
    final path = '/trade/copy-provider/$providerId/configuration';
    if (backPath == null || backPath.isEmpty) return path;
    return '$path?back=${Uri.encodeComponent(backPath)}';
  }

  static String tradeCopyProviderConfirmation(String providerId) =>
      '/trade/copy-provider/$providerId/confirmation';
  static String tradeCopyPerformance(String copyId) =>
      '/trade/copy-performance/$copyId';
  static String tradeCopyPerformanceAttribution(String copyId) =>
      '/trade/copy-performance/$copyId/attribution';
  static String tradeCopyAuditLog(String copyId) =>
      '/trade/copy-audit-log/$copyId';
  static const String tradeCopyRiskAnalysis =
      '/trade/copy-trading/risk-analysis';
  static const String tradeCopyLeaderboard = '/trade/copy-trading/leaderboard';
  static const String tradeCopySafety = '/trade/copy-trading/safety';
  static const String tradeCopyProviderGovernance =
      '/trade/copy-provider-governance';
  static const String tradeCopyDisputeResolution =
      '/trade/copy-dispute-resolution';
  static const String tradeCopySafetyCenter = '/trade/copy-safety-center';
  static String tradeTrader(String traderId) => '/trade/trader/$traderId';
}

final class TradeCopyRouteNames {
  const TradeCopyRouteNames._();

  static const String sc063CopyTrading = 'sc063CopyTrading';
  static const String sc065CopyEducation = 'sc065CopyEducation';
  static const String sc066ActiveCopies = 'sc066ActiveCopies';
  static const String sc067CopySettings = 'sc067CopySettings';
  static const String sc068CopyNotifications = 'sc068CopyNotifications';
  static const String sc069ProviderApplication = 'sc069ProviderApplication';
  static const String sc070CopyProviderDetail = 'sc070CopyProviderDetail';
  static const String sc071PreCopyAssessment = 'sc071PreCopyAssessment';
  static const String sc072CopyConfiguration = 'sc072CopyConfiguration';
  static const String sc073CopyConfirmation = 'sc073CopyConfirmation';
  static const String sc074CopyPerformance = 'sc074CopyPerformance';
  static const String sc075PerformanceAttribution =
      'sc075PerformanceAttribution';
  static const String sc076ProviderComparison = 'sc076ProviderComparison';
  static const String sc077CopyAuditLog = 'sc077CopyAuditLog';
  static const String sc078PortfolioRiskAnalysis = 'sc078PortfolioRiskAnalysis';
  static const String sc079ProviderLeaderboard = 'sc079ProviderLeaderboard';
  static const String sc080SafetyEducation = 'sc080SafetyEducation';
  static const String sc081ProviderGovernance = 'sc081ProviderGovernance';
  static const String sc082DisputeResolution = 'sc082DisputeResolution';
  static const String sc083CopySafetyCenter = 'sc083CopySafetyCenter';
  static const String sc087TraderProfile = 'sc087TraderProfile';
  static const String sc401CopyTradingCardDemo = 'sc401CopyTradingCardDemo';
}
