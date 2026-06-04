import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  testWidgets('VitBottomNav renders notification badge states', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(
          children: [
            VitBottomNav(homeNotificationBadgeCount: 7),
            VitBottomNav(homeNotificationBadgeCount: 0),
            VitBottomNav(homeNotificationBadgeCount: 125),
          ],
        ),
      ),
    );

    expect(find.text('7'), findsOneWidget);
    expect(find.text('99+'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('center trade button does not cover its label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(
          children: [
            VitBottomNav(activeDestination: VitBottomNavDestination.trade),
            VitBottomNav(
              activeDestination: VitBottomNavDestination.trade,
              renderMode: ShellRenderMode.visualQa,
            ),
          ],
        ),
      ),
    );

    final centerButtons = find.byKey(const Key('vit_bottom_nav_active_trade'));
    final labels = find.byKey(const Key('vit_bottom_nav_trade_label'));

    expect(centerButtons, findsNWidgets(2));
    expect(labels, findsNWidgets(2));

    for (var index = 0; index < 2; index += 1) {
      final buttonBottom = tester.getBottomLeft(centerButtons.at(index)).dy;
      final labelTop = tester.getTopLeft(labels.at(index)).dy;

      expect(
        buttonBottom,
        lessThanOrEqualTo(labelTop - 2),
        reason: 'Center trade button must not overlap the Giao dịch label.',
      );
    }
  });
}
