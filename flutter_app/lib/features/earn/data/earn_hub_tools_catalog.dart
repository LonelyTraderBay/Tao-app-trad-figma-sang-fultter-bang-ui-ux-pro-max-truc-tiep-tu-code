import 'package:vit_trade_flutter/app/router/app_router.dart';

final class EarnHubTool {
  const EarnHubTool({
    required this.id,
    required this.label,
    required this.route,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final String iconKey;
}

abstract final class EarnHubToolsCatalog {
  static const stakingTools = <EarnHubTool>[
    EarnHubTool(
      id: 'analytics',
      label: 'Phân tích',
      route: AppRoutePaths.earnAnalytics,
      iconKey: 'analytics',
    ),
    EarnHubTool(
      id: 'calendar',
      label: 'Lịch lãi',
      route: AppRoutePaths.earnCalendar,
      iconKey: 'calendar',
    ),
    EarnHubTool(
      id: 'history',
      label: 'Lịch sử',
      route: AppRoutePaths.earnHistory,
      iconKey: 'history',
    ),
    EarnHubTool(
      id: 'guide',
      label: 'Hướng dẫn',
      route: AppRoutePaths.earnGuide,
      iconKey: 'guide',
    ),
    EarnHubTool(
      id: 'faq',
      label: 'FAQ',
      route: AppRoutePaths.earnFAQ,
      iconKey: 'faq',
    ),
    EarnHubTool(
      id: 'recommendations',
      label: 'Gợi ý',
      route: AppRoutePaths.earnRecommendations,
      iconKey: 'recommendations',
    ),
    EarnHubTool(
      id: 'notifications',
      label: 'Thông báo',
      route: AppRoutePaths.earnNotifications,
      iconKey: 'notifications',
    ),
    EarnHubTool(
      id: 'staking',
      label: 'Stake',
      route: AppRoutePaths.earnStaking,
      iconKey: 'staking',
    ),
  ];
}
