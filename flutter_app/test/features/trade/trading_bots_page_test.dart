import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/trading_bots_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpTradingBots(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.tradeBots,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-059 mock repository exposes trading bot BE draft', () {
    final repo = const MockTradeRepository();
    final snapshot = repo.getTradingBots();
    final action = repo.submitBotAction(
      const TradeBotActionRequest(botId: 'bot1', action: 'pause'),
    );
    final created = repo.createTradingBot(
      const TradeBotCreateRequest(
        strategyId: 'dca',
        params: {'pair': 'BTC/USDT'},
      ),
    );

    expect(snapshot.activeBots, hasLength(3));
    expect(snapshot.strategies, hasLength(4));
    expect(snapshot.runningCount, 2);
    expect(snapshot.totalInvestment, 2000);
    expect(snapshot.totalProfit.toStringAsFixed(2), '199.30');
    expect(snapshot.strategies.first.name, 'DCA Bot');
    expect(snapshot.activeBots.first.pair, 'BTC/USDT');
    expect(action.status, 'accepted');
    expect(created.botId, 'BOT-DEMO-059');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-059 renders TradingBotsPage inside the Trade shell', (
    tester,
  ) async {
    await pumpTradingBots(tester);

    expect(find.byType(TradingBotsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Trading Bots'), findsOneWidget);
    expect(find.text('Bot giao dịch · Trade'), findsOneWidget);
    expect(find.text('Giao dịch tự động 24/7'), findsOneWidget);
    expect(find.text('Bot hoạt động ngay cả khi bạn ngủ'), findsOneWidget);
    expect(find.text('Bot đang chạy'), findsOneWidget);
    expect(find.text('\$2,000'), findsOneWidget);
    expect(find.text('+\$199.30'), findsOneWidget);
    expect(find.text('Bot của tôi (3)'), findsOneWidget);
    expect(find.text('DCA Bot'), findsOneWidget);
    expect(find.text('Grid Bot'), findsOneWidget);
    expect(find.text('Momentum Bot'), findsOneWidget);
  });

  testWidgets('SC-059 bot actions stay local', (tester) async {
    await pumpTradingBots(tester);

    await tester.tap(find.byKey(TradingBotsPage.botToggleKey('bot1')));
    await tester.pumpAndSettle();
    expect(find.text('Tiếp tục'), findsNWidgets(2));

    await tester.tap(find.byKey(TradingBotsPage.botDeleteKey('bot2')));
    await tester.pumpAndSettle();
    expect(find.text('Grid Bot'), findsNothing);
    expect(find.text('Bot của tôi (2)'), findsOneWidget);
  });

  testWidgets('SC-059 strategy tab opens create bot sheet', (tester) async {
    await pumpTradingBots(tester);

    await tester.tap(find.byKey(TradingBotsPage.tabKey('strategies')));
    await tester.pumpAndSettle();

    expect(find.text('Hiệu suất chiến lược (30 ngày gần đây)'), findsOneWidget);
    expect(find.text('Tạo Bot DCA Bot'), findsOneWidget);

    await tester.tap(find.byKey(TradingBotsPage.strategyCreateKey('dca')));
    await tester.pumpAndSettle();
    expect(find.text('Nhập thông số Bot'), findsOneWidget);

    await tester.tap(find.byKey(TradingBotsPage.sheetAgreeKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradingBotsPage.sheetCreateKey));
    await tester.pumpAndSettle();

    expect(find.text('Bot đã được khởi chạy!'), findsOneWidget);
  });

  testWidgets('SC-059 back returns to SC-048 TradePage', (tester) async {
    await pumpTradingBots(tester);

    await tester.tap(find.byKey(TradingBotsPage.backKey));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(TradingBotsPage), findsNothing);
  });

  testWidgets('SC-059 scoped bot child routes return to TradingBotsPage', (
    tester,
  ) async {
    await pumpTradingBots(tester, initialLocation: '/trade/bots/history');

    expect(find.text('Trade History'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(TradingBotsPage), findsOneWidget);
  });
}
