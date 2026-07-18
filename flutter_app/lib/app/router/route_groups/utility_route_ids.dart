final class UtilityRoutePaths {
  const UtilityRoutePaths._();

  static const String search = '/search';
  static const String topics = '/topics';
  static const String topicCrypto = '/topic/crypto';
  static const String referral = '/referral';
  static const String referralHistory = '/referral/history';
  static const String referralRewards = '/referral/rewards';
  static const String referralRules = '/referral/rules';
  static String referralFriend(String friendId) => '/referral/friend/$friendId';
  static const String enterpriseStates = '/enterprise-states';
  static const String unifiedPortfolio = '/unified-portfolio';
  static const String crossModuleAnalytics = '/cross-module-analytics';
  static const String smartAlerts = '/smart-alerts';
  static const String taxReports = '/tax-reports';
  static const String routeChecker = '/dev/route-checker';
  static const String performanceMonitor = '/dev/performance-monitor';
  static const String devShowcase = '/dev/showcase';
  static const String devDesignSystem = '/dev/design-system';
  static const String devDcaOverview = '/dev/dca-overview';
  static const String notifications = '/notifications';
  static const String rewards = '/rewards';

  // GĐ4-F1 kill-switch: 2 trang gate toàn cục (bảo trì / bắt buộc cập
  // nhật), redirect từ root_routes.dart.
  static const String maintenanceGate = '/maintenance';
  static const String forceUpdateGate = '/force-update';
}

final class UtilityRouteNames {
  const UtilityRouteNames._();

  static const String sc283UnifiedSearch = 'sc283UnifiedSearch';
  static const String sc284TopicHub = 'sc284TopicHub';
  static const String sc285TopicCrypto = 'sc285TopicCrypto';
  static const String sc286ReferralHistory = 'sc286ReferralHistory';
  static const String sc287ReferralRewards = 'sc287ReferralRewards';
  static const String sc288ReferralRules = 'sc288ReferralRules';
  static const String sc289ReferralFriendDetail = 'sc289ReferralFriendDetail';
  static const String sc290ReferralHome = 'sc290ReferralHome';
  static const String sc291Notifications = 'sc291Notifications';
  static const String sc319RewardsHub = 'sc319RewardsHub';
  static const String sc320EnterpriseStates = 'sc320EnterpriseStates';
  static const String sc321UnifiedPortfolio = 'sc321UnifiedPortfolio';
  static const String sc322CrossModuleAnalytics = 'sc322CrossModuleAnalytics';
  static const String sc323SmartAlertCenter = 'sc323SmartAlertCenter';
  static const String sc324TaxReportCenter = 'sc324TaxReportCenter';
  static const String sc325RouteChecker = 'sc325RouteChecker';
  static const String sc326PerformanceMonitor = 'sc326PerformanceMonitor';
  static const String sc398MissingScreensShowcase =
      'sc398MissingScreensShowcase';
  static const String sc399DesignSystem = 'sc399DesignSystem';
  static const String sc400DcaOverviewDemo = 'sc400DcaOverviewDemo';

  // GĐ4-F1 kill-switch: 2 trang gate toàn cục (bảo trì / bắt buộc cập
  // nhật), redirect từ root_routes.dart.
  static const String sc417MaintenanceGate = 'sc417MaintenanceGate';
  static const String sc418ForceUpdateGate = 'sc418ForceUpdateGate';
}
