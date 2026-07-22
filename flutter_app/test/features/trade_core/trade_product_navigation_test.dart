import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_product_tabs.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';

void main() {
  testWidgets(
    'STEP-P2.5 product switcher uses vi-VN labels and Margin/Bot risk badges',
    (tester) async {
      late TradeProductNavigation nav;
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) {
                  nav = buildTradeProductNavigation(
                    context: context,
                    activeId: 'spot',
                  );
                  return Scaffold(
                    body: VitTradeProductTabs(
                      tabs: nav.tabs,
                      activeId: 'spot',
                      overflowItems: nav.overflow,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(nav.tabs.map((t) => t.id).toList(), [
        'spot',
        'futures',
        'margin',
        'convert',
        'bots',
      ]);
      expect(find.text('Giao ngay'), findsOneWidget);
      expect(find.text('Phái sinh'), findsOneWidget);
      expect(find.text('Ký quỹ'), findsOneWidget);
      expect(find.text('Chuyển đổi'), findsOneWidget);
      expect(find.text('Bot'), findsOneWidget);

      expect(find.text('Spot'), findsNothing);
      expect(find.text('Futures'), findsNothing);
      expect(find.text('Margin'), findsNothing);
      expect(find.text('Convert'), findsNothing);

      final margin = nav.tabs.firstWhere((t) => t.id == 'margin');
      final bots = nav.tabs.firstWhere((t) => t.id == 'bots');
      final spot = nav.tabs.firstWhere((t) => t.id == 'spot');
      expect(margin.riskBadge, 'Rủi ro cao');
      expect(bots.riskBadge, 'Rủi ro cao');
      expect(spot.riskBadge, isNull);

      expect(find.text('Rủi ro cao'), findsNWidgets(2));
      expect(find.byType(VitStatusPill), findsNWidgets(2));
    },
  );
}
