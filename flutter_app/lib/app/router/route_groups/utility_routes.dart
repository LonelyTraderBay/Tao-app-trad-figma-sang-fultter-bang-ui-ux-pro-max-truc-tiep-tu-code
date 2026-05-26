part of '../app_router.dart';

List<RouteBase> _utilityRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.rewards,
      name: AppRouteNames.sc319RewardsHub,
      builder: (_, _) => RewardsHubPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.enterpriseStates,
      name: AppRouteNames.sc320EnterpriseStates,
      builder: (_, _) => EnterpriseStatesPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.unifiedPortfolio,
      name: AppRouteNames.sc321UnifiedPortfolio,
      builder: (_, _) =>
          UnifiedPortfolioDashboard(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.crossModuleAnalytics,
      name: AppRouteNames.sc322CrossModuleAnalytics,
      builder: (_, _) => CrossModuleAnalytics(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.smartAlerts,
      name: AppRouteNames.sc323SmartAlertCenter,
      builder: (_, _) => SmartAlertCenter(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.taxReports,
      name: AppRouteNames.sc324TaxReportCenter,
      builder: (_, _) => TaxReportCenter(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.routeChecker,
      name: AppRouteNames.sc325RouteChecker,
      builder: (_, _) => RouteChecker(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.performanceMonitor,
      name: AppRouteNames.sc326PerformanceMonitor,
      builder: (_, _) => PerformanceMonitor(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.devShowcase,
      name: AppRouteNames.sc398MissingScreensShowcase,
      builder: (_, _) =>
          MissingScreensShowcasePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.devDesignSystem,
      name: AppRouteNames.sc399DesignSystem,
      builder: (_, _) => DesignSystemPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.devDcaOverview,
      name: AppRouteNames.sc400DcaOverviewDemo,
      builder: (_, _) => DCAOverviewDemo(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.demoCopyCard,
      name: AppRouteNames.sc401CopyTradingCardDemo,
      builder: (_, _) => CopyTradingCardDemo(shellRenderMode: shellRenderMode),
    ),
  ];
}

List<RouteBase> _discoveryAndReferralRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.search,
      name: AppRouteNames.sc283UnifiedSearch,
      builder: (_, _) => UnifiedSearchPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.notifications,
      name: AppRouteNames.sc291Notifications,
      builder: (_, _) => NotificationsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.topics,
      name: AppRouteNames.sc284TopicHub,
      builder: (_, _) => TopicHubPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.topicCrypto,
      name: AppRouteNames.sc285TopicCrypto,
      builder: (_, _) => TopicHubPage(
        initialTopicId: 'crypto',
        useDetailEndpoint: true,
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.referral,
      name: AppRouteNames.sc290ReferralHome,
      builder: (_, _) => ReferralHomePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.referralHistory,
      name: AppRouteNames.sc286ReferralHistory,
      builder: (_, _) => ReferralHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.referralRewards,
      name: AppRouteNames.sc287ReferralRewards,
      builder: (_, _) => ReferralRewardsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.referralRules,
      name: AppRouteNames.sc288ReferralRules,
      builder: (_, _) => ReferralRulesPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/referral/friend/:friendId',
      name: AppRouteNames.sc289ReferralFriendDetail,
      builder: (_, state) => ReferralFriendDetailPage(
        friendId: state.pathParameters['friendId'] ?? 'friend001',
      ),
    ),
  ];
}

List<RouteBase> get _navigationPlaceholderRoutes {
  return [..._homeOutgoingPlaceholders, ..._marketOutgoingPlaceholders];
}
