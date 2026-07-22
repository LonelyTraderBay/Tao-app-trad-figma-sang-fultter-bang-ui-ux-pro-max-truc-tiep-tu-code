import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_hub_tools_catalog.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_legal_catalog.dart';

void main() {
  test('STEP-P3.2 EarnLegalCatalog exposes 31 GOM items in 5 groups', () {
    expect(EarnLegalCatalog.groups.map((g) => g.id), [
      'legal-terms',
      'validator-operations',
      'transparency-reporting',
      'developer-integration',
      'community-governance',
    ]);
    expect(EarnLegalCatalog.groups[0].items, hasLength(6));
    expect(EarnLegalCatalog.groups[1].items, hasLength(8));
    expect(EarnLegalCatalog.groups[2].items, hasLength(6));
    expect(EarnLegalCatalog.groups[3].items, hasLength(4));
    expect(EarnLegalCatalog.groups[4].items, hasLength(7));
    expect(EarnLegalCatalog.itemCount, 31);
    expect(
      EarnLegalCatalog.groups
          .expand((group) => group.items)
          .map((item) => item.route)
          .every((route) => route.startsWith('/')),
      isTrue,
    );
    expect(
      EarnLegalCatalog.groups.last.items.map((item) => item.route),
      contains('/earn/voting/demo'),
    );
  });

  test('STEP-P3.1 EarnHubToolsCatalog exposes 8 staking hub tools', () {
    expect(EarnHubToolsCatalog.stakingTools.map((tool) => tool.id), [
      'analytics',
      'calendar',
      'history',
      'guide',
      'faq',
      'recommendations',
      'notifications',
      'staking',
    ]);
    expect(EarnHubToolsCatalog.stakingTools, hasLength(8));
    expect(
      EarnHubToolsCatalog.stakingTools.map((tool) => tool.route),
      containsAll([
        AppRoutePaths.earnAnalytics,
        AppRoutePaths.earnCalendar,
        AppRoutePaths.earnHistory,
        AppRoutePaths.earnGuide,
        AppRoutePaths.earnFAQ,
        AppRoutePaths.earnRecommendations,
        AppRoutePaths.earnNotifications,
        AppRoutePaths.earnStaking,
      ]),
    );
  });
}
