import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_tablet_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/hub/markets_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpTabletHome(
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
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const MockHomeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-007 renders HomeTabletPage, not HomePage, at tablet width', (
    tester,
  ) async {
    await pumpTabletHome(tester);

    expect(find.byType(HomeTabletPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets(
    'SC-007 tablet shell shows the navigation rail, not the bottom nav',
    (tester) async {
      await pumpTabletHome(tester);

      expect(find.byType(VitNavigationRail), findsOneWidget);
      expect(find.byType(VitBottomNav), findsNothing);
    },
  );

  testWidgets('SC-007 tablet dashboard renders both dashboard columns', (
    tester,
  ) async {
    await pumpTabletHome(tester);

    // Primary column's watchlist panel header. "Thị trường" also labels the
    // persistent nav rail's Markets destination, so this scopes to the
    // section-header text style rather than a bare text match.
    expect(
      find.descendant(
        of: find.byType(VitSectionHeader),
        matching: find.text('Thị trường'),
      ),
      findsOneWidget,
    );
    // Secondary column.
    expect(find.text('Dự đoán & Thách đấu'), findsOneWidget);
  });

  testWidgets('SC-007 tablet rail navigates to Markets', (tester) async {
    await pumpTabletHome(tester);

    await tester.tap(find.byKey(const Key('vit_navigation_rail_markets')));
    await tester.pumpAndSettle();

    // Markets is also tablet-adaptive as of this batch — at this width it
    // resolves to its own single-column tablet fallback, not the raw phone
    // page (see markets_tablet_page_test.dart for its own dispatch tests).
    expect(find.byType(MarketsTabletPage), findsOneWidget);
  });

  testWidgets(
    'SC-007 wide tablet renders the true two-column dashboard without '
    'overflow, secondary column framed as a distinct panel',
    (tester) async {
      // Landscape tablet, above HomeTabletPage's own two-column threshold
      // (900) — the width-capped Align+ConstrainedBox+VitCard layout added
      // for the redesign only engages at/above this width.
      await pumpTabletHome(tester, size: const Size(1180, 820));

      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(VitSectionHeader),
          matching: find.text('Thị trường'),
        ),
        findsOneWidget,
      );
      expect(find.text('Dự đoán & Thách đấu'), findsOneWidget);
      // Secondary column's distinct panel surface.
      expect(
        find.ancestor(
          of: find.text('Dự đoán & Thách đấu'),
          matching: find.byType(VitCard),
        ),
        findsOneWidget,
      );
    },
  );
}
