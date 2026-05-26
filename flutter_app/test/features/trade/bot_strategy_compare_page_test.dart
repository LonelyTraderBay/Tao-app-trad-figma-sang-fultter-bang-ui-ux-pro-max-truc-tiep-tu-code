import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/bot_strategy_compare_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpBotStrategyCompare(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotStrategyCompare,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-126 mock repository exposes strategy compare BE draft', () {
    final snapshot = const MockTradeRepository().getBotStrategyCompare();

    expect(snapshot.strategies, hasLength(4));
    expect(snapshot.equityPoints, hasLength(7));
    expect(snapshot.recommendations, hasLength(4));
    expect(snapshot.defaultSelectedIds, ['grid', 'momentum']);
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-strategy-compare');
    expect(snapshot.actionDraft, contains('GET /bots/strategy-compare'));
    expect(snapshot.actionDraft, contains('POST /trade/order-preview'));
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-126 renders strategy compare baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotStrategyCompare(tester);

    expect(find.byType(BotStrategyComparePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Strategy Compare'), findsOneWidget);
    expect(find.text('Select Strategies (2-4)'), findsOneWidget);
    expect(find.text('Best Risk-Adjusted Returns'), findsOneWidget);
    expect(find.text('Equity Curves Comparison'), findsOneWidget);
    expect(find.text('Performance Radar'), findsOneWidget);
  });

  testWidgets('SC-126 lets users toggle strategy selection', (tester) async {
    await pumpBotStrategyCompare(tester);

    await tester.tap(find.byKey(BotStrategyComparePage.strategyKey('dca')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(BotStrategyComparePage.strategyKey('grid')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('DCA Bot'), findsWidgets);
    expect(find.text('Momentum Bot'), findsWidgets);
  });
}
