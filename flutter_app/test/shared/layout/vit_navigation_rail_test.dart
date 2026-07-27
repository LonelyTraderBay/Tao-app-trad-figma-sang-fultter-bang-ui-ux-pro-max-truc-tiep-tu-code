import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';

void main() {
  testWidgets('VitNavigationRail renders all five destination labels', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: VitNavigationRail()));

    for (final destination in VitBottomNavDestination.values) {
      expect(find.text(destination.navLabel), findsOneWidget);
    }
  });

  testWidgets('VitNavigationRail renders notification badge states', (
    tester,
  ) async {
    // Side by side (Row), not stacked (Column) — VitNavigationRail fills
    // available height, so three stacked vertically would overflow.
    await tester.pumpWidget(
      const MaterialApp(
        home: Row(
          children: [
            VitNavigationRail(homeNotificationBadgeCount: 7),
            VitNavigationRail(homeNotificationBadgeCount: 0),
            VitNavigationRail(homeNotificationBadgeCount: 125),
          ],
        ),
      ),
    );

    expect(find.text('7'), findsOneWidget);
    expect(find.text('99+'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('VitNavigationRail tap invokes onDestinationSelected', (
    tester,
  ) async {
    VitBottomNavDestination? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: VitNavigationRail(onDestinationSelected: (d) => selected = d),
      ),
    );

    await tester.tap(find.byKey(const Key('vit_navigation_rail_markets')));
    await tester.pump();

    expect(selected, VitBottomNavDestination.markets);
  });

  testWidgets('VitNavigationRail marks the active destination', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VitNavigationRail(
          activeDestination: VitBottomNavDestination.wallet,
        ),
      ),
    );

    expect(
      find.byKey(const Key('vit_navigation_rail_active_wallet')),
      findsOneWidget,
    );
  });
}
