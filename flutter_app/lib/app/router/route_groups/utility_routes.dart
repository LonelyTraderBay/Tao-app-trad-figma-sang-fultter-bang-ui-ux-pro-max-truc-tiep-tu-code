import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/features/rewards/presentation/pages/rewards_hub_page.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/pages/enterprise_states_page.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/pages/unified_portfolio_dashboard.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/pages/cross_module_analytics.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/pages/smart_alert_center.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/pages/tax_report_center.dart';
import 'package:vit_trade_flutter/features/dev/presentation/pages/route_checker_page.dart';
import 'package:vit_trade_flutter/features/dev/presentation/pages/performance_monitor.dart';
import 'package:vit_trade_flutter/features/dev/presentation/pages/missing_screens_showcase_page.dart';
import 'package:vit_trade_flutter/features/dev/presentation/pages/design_system_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/pages/hub/dca_overview_demo.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/pages/unified_search_page.dart';
import 'package:vit_trade_flutter/features/notifications/presentation/pages/notifications_page.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/pages/topic_hub_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/pages/referral_home_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/pages/referral_history_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/pages/referral_rewards_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/pages/referral_rules_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/pages/referral_friend_detail_page.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';

List<RouteBase> utilityRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.rewards,
      name: AppRouteNames.sc319RewardsHub,
      builder: (_, state) => RewardsHubPage(
        shellRenderMode: shellRenderMode,
        initialFilter: rewardsFilterFromTab(state.uri.queryParameters['tab']),
      ),
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
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.developer,
        routePath: AppRoutePaths.routeChecker,
        child: RouteChecker(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.performanceMonitor,
      name: AppRouteNames.sc326PerformanceMonitor,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.developer,
        routePath: AppRoutePaths.performanceMonitor,
        child: PerformanceMonitor(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.devShowcase,
      name: AppRouteNames.sc398MissingScreensShowcase,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.developer,
        routePath: AppRoutePaths.devShowcase,
        child: MissingScreensShowcasePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.devDesignSystem,
      name: AppRouteNames.sc399DesignSystem,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.developer,
        routePath: AppRoutePaths.devDesignSystem,
        child: DesignSystemPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.devDcaOverview,
      name: AppRouteNames.sc400DcaOverviewDemo,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.developer,
        routePath: AppRoutePaths.devDcaOverview,
        child: DCAOverviewDemo(shellRenderMode: shellRenderMode),
      ),
    ),
  ];
}

String? rewardsFilterFromTab(String? tab) {
  return tab == 'arena' ? 'Arena' : null;
}

List<RouteBase> discoveryAndReferralRoutes(ShellRenderMode shellRenderMode) {
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
        friendId: requireRouteParam(state, 'friendId'),
      ),
    ),
  ];
}

List<RouteBase> get navigationPlaceholderRoutes {
  return [...homeOutgoingPlaceholders, ...marketOutgoingPlaceholders];
}
