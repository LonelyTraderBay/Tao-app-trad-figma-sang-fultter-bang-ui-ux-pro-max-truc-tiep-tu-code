import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/hub/market_list_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/hub/wallet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/hub/wallet_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/hub/wallet_page_sections.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpTabletWallet(
    WidgetTester tester, {
    Size size = const Size(820, 1180),
  }) async {
    // Default: iPad Air portrait — above AppBreakpoints.tablet (600) but
    // below the dashboard's own two-column threshold, so this exercises the
    // single-column tablet fallback.
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.wallet),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'SC-135 renders WalletTabletPage, not WalletPage, at tablet width',
    (tester) async {
      await pumpTabletWallet(tester);

      expect(find.byType(WalletTabletPage), findsOneWidget);
      expect(find.byType(WalletPage), findsNothing);
    },
  );

  testWidgets(
    'SC-135 tablet shell shows the navigation rail, not the bottom nav',
    (tester) async {
      await pumpTabletWallet(tester);

      expect(find.byType(VitNavigationRail), findsOneWidget);
      expect(find.byType(VitBottomNav), findsNothing);
    },
  );

  testWidgets('SC-135 tablet dashboard renders both dashboard columns', (
    tester,
  ) async {
    await pumpTabletWallet(tester);

    // Primary column's asset section header. "Ví" also labels the
    // persistent nav rail's Wallet destination, so this scopes to the
    // section-header text style rather than a bare text match.
    expect(
      find.descendant(
        of: find.byType(VitSectionHeader),
        matching: find.text('Tài sản'),
      ),
      findsOneWidget,
    );
    // Secondary column.
    expect(find.text('Công cụ ví'), findsOneWidget);
    expect(find.text('Mua định kỳ'), findsOneWidget);
  });

  testWidgets('SC-135 tablet rail navigates to Markets', (tester) async {
    await pumpTabletWallet(tester);

    await tester.tap(find.byKey(const Key('vit_navigation_rail_markets')));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });

  testWidgets(
    'SC-135 wide tablet renders the true two-column dashboard without '
    'overflow, secondary column framed as a distinct panel',
    (tester) async {
      // Landscape tablet, above WalletTabletPage's own two-column threshold
      // (900) — the width-capped Align+ConstrainedBox+VitCard layout only
      // engages at/above this width.
      await pumpTabletWallet(tester, size: const Size(1180, 820));

      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(VitSectionHeader),
          matching: find.text('Tài sản'),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.text('Công cụ ví'),
          matching: find.byType(VitCard),
        ),
        findsWidgets,
      );
    },
  );

  testWidgets(
    'SC-135 wide tablet switches to the Phân bổ allocation tab without '
    'overflow',
    (tester) async {
      // WalletAllocationCard (fixed-size donut + Expanded legend row) is
      // the layout-riskiest widget in the primary column at this width —
      // verify it actually renders clean, not just by code inspection.
      await pumpTabletWallet(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(WalletPage.tabKey('chart')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(WalletAllocationCard), findsOneWidget);
    },
  );
}
