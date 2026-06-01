import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/convert_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpTrade(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.trade,
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

  test('SC-048 mock repository exposes the trade BE draft read model', () {
    final repo = const MockTradeRepository();
    final snapshot = repo.getTrade();
    final pairSnapshot = repo.getTrade(pairId: 'btcusdt');

    expect(snapshot.pair.symbol, 'BTC/USDT');
    expect(pairSnapshot.pair.id, 'btcusdt');
    expect(snapshot.pairs, hasLength(3));
    expect(snapshot.orderBook.bids, isNotEmpty);
    expect(snapshot.trades, isNotEmpty);
    expect(snapshot.orders, isNotEmpty);
    expect(snapshot.positions, isNotEmpty);
    expect(snapshot.copyProviders, isNotEmpty);
    expect(snapshot.botStrategies, isNotEmpty);
    expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
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

    final preview = repo.previewOrder(
      const TradeOrderDraft(
        pairId: 'btcusdt',
        side: TradeOrderSide.buy,
        type: TradeOrderType.limit,
        price: 67543.21,
        amount: .1,
      ),
    );
    expect(preview.total, closeTo(6754.321, .001));
    expect(preview.feeRate, .00085);
  });

  testWidgets('SC-049 renders the BTC pair route variant', (tester) async {
    await pumpTrade(
      tester,
      initialLocation: AppRoutePaths.tradePair('btcusdt'),
    );

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('24H'), findsOneWidget);
    expect(find.text('70821.46'), findsWidgets);
    expect(find.text('10,200.00 USDT'), findsOneWidget);
  });

  testWidgets('SC-049 side query preselects sell and invalid side falls back', (
    tester,
  ) async {
    await pumpTrade(
      tester,
      initialLocation: '${AppRoutePaths.tradePair('btcusdt')}?side=sell',
    );

    expect(
      find.byKey(const Key('sc048_trade_active_sell_side')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('sc048_trade_active_buy_side')), findsNothing);

    await pumpTrade(
      tester,
      initialLocation: '${AppRoutePaths.tradePair('btcusdt')}?side=short',
    );

    expect(
      find.byKey(const Key('sc048_trade_active_buy_side')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('sc048_trade_active_sell_side')), findsNothing);
  });

  testWidgets('SC-048 renders trade form inside the Trade shell', (
    tester,
  ) async {
    await pumpTrade(tester);

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('67,543.21'), findsOneWidget);
    expect(find.text('Chart'), findsOneWidget);
    expect(find.text('Đặt lệnh'), findsOneWidget);
    expect(find.text('MUA'), findsOneWidget);
    expect(find.text('BÁN'), findsOneWidget);
    expect(find.text('Giới hạn'), findsOneWidget);
    expect(find.text('TP/SL'), findsOneWidget);
  });

  testWidgets('SC-048 switches market data tabs and order side', (
    tester,
  ) async {
    await pumpTrade(tester);

    await tester.tap(find.byKey(TradePage.orderBookTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Giá'), findsOneWidget);
    expect(find.text('67545.13'), findsOneWidget);

    await tester.tap(find.byKey(TradePage.tradesTabKey));
    await tester.pumpAndSettle();
    expect(find.text('23:29:14'), findsOneWidget);

    await tester.tap(find.byKey(TradePage.sellSideKey));
    await tester.pumpAndSettle();
    expect(find.text('Bán BTC'), findsNothing);
  });

  testWidgets('SC-048 amount shortcuts update the order draft', (tester) async {
    await pumpTrade(tester);

    await tester.tap(find.byKey(TradePage.pctKey(25)));
    await tester.pumpAndSettle();

    expect(find.textContaining('0.037'), findsWidgets);
    expect(find.text('Mua BTC'), findsOneWidget);
  });

  testWidgets('SC-048 quick nav opens SC-056 ConvertPage', (tester) async {
    await pumpTrade(tester);

    await tester.tap(find.byKey(TradePage.quickNavKey('convert')));
    await tester.pumpAndSettle();

    expect(find.byType(ConvertPage), findsOneWidget);
    expect(find.text('Convert / Swap'), findsOneWidget);
  });
}
