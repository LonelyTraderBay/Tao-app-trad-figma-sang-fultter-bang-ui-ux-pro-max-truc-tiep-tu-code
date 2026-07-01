import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/advanced_chart_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/futures_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/leverage_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpFutures(
    WidgetTester tester, {
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeFutures('btcusdt'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-057 mock repository exposes futures BE draft', () {
    final repo = const MockTradeRepository();
    final snapshot = repo.getFutures(pairId: 'btcusdt');
    final preview = repo.previewFuturesOrder(
      const TradeFuturesOrderDraft(
        pairId: 'btcusdt',
        side: TradeFuturesSide.long,
        type: TradeFuturesOrderType.market,
        margin: 500,
        leverage: 10,
      ),
    );
    final receipt = repo.submitFuturesOrder(
      const TradeFuturesOrderDraft(
        pairId: 'btcusdt',
        side: TradeFuturesSide.long,
        type: TradeFuturesOrderType.market,
        margin: 500,
        leverage: 10,
      ),
    );

    expect(snapshot.pair.symbol, 'BTC/USDT');
    expect(snapshot.positions, hasLength(2));
    expect(snapshot.leverages, [1, 2, 3, 5, 10, 20, 50, 75, 100]);
    expect(snapshot.indexPrice.toStringAsFixed(2), '67529.70');
    expect(snapshot.fundingRate, .01);
    expect(preview.positionSize, 5000);
    expect(preview.canOpen, isTrue);
    expect(receipt.orderId, 'FUT-DEMO-057');
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

  testWidgets('SC-057 renders FuturesPage inside the Trade shell', (
    tester,
  ) async {
    await pumpFutures(tester);

    expect(find.byType(FuturesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC/USDT'), findsAtLeastNWidgets(2));
    expect(find.text('FUTURES'), findsAtLeastNWidgets(1));
    expect(find.text('Mark Price'), findsOneWidget);
    expect(find.text('Index'), findsOneWidget);
    expect(find.text('Funding'), findsOneWidget);
    expect(find.text('Long'), findsOneWidget);
    expect(find.text('Short'), findsOneWidget);
    expect(find.text('Thị trường'), findsWidgets);
    expect(find.text('10x'), findsWidgets);
    expect(find.text('Nhập ký quỹ'), findsOneWidget);
  });

  testWidgets('SC-320 uses full-width futures workspace at 360x800', (
    tester,
  ) async {
    await pumpFutures(tester, viewport: const Size(360, 800));

    expect(find.byType(FuturesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(FuturesPage.closeKey), findsOneWidget);
    expect(find.byKey(FuturesPage.chartKey), findsOneWidget);
    expect(find.byKey(FuturesPage.leverageKey), findsOneWidget);
    expect(find.byKey(FuturesPage.marginFieldKey), findsOneWidget);

    final scrollFinder = find.descendant(
      of: find.byType(FuturesPage),
      matching: find.byType(SingleChildScrollView),
    );
    expect(scrollFinder, findsWidgets);

    final scrollWidget = scrollFinder.first;
    final scrollRect = tester.getRect(scrollWidget);
    final closeRect = tester.getRect(find.byKey(FuturesPage.closeKey));
    final chartRect = tester.getRect(find.byKey(FuturesPage.chartKey));

    expect(scrollRect.left, closeTo(0, 0.5));
    expect(scrollRect.right, closeTo(360, 0.5));
    expect(scrollRect.height, greaterThan(450));
    expect(closeRect.top, greaterThanOrEqualTo(0));
    expect(chartRect.right, lessThanOrEqualTo(360));

    await tester.ensureVisible(find.byKey(FuturesPage.submitKey));
    await tester.pumpAndSettle();

    final submitRect = tester.getRect(find.byKey(FuturesPage.submitKey));
    expect(submitRect.bottom, lessThanOrEqualTo(800));
  });

  testWidgets('SC-057 side, percent, TP/SL, and submit are local', (
    tester,
  ) async {
    await pumpFutures(tester);

    await tester.tap(find.byKey(FuturesPage.sideKey('short')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(FuturesPage.pctKey(10)),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(FuturesPage.pctKey(10)));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Futures order preview'));
    await tester.pumpAndSettle();
    expect(find.text('Futures order preview'), findsOneWidget);
    expect(find.text('Liquidation estimate'), findsOneWidget);
    expect(find.text('Risk check'), findsOneWidget);
    await tester.tap(find.byKey(FuturesPage.takeProfitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(FuturesPage.stopLossKey));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(FuturesPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(FuturesPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byType(FuturesPage), findsOneWidget);
    expect(find.textContaining('FUT-DEMO-057'), findsOneWidget);
  });

  testWidgets('SC-057 positions and orders tabs stay local', (tester) async {
    await pumpFutures(tester);

    await tester.scrollUntilVisible(
      find.byKey(FuturesPage.portfolioExpandKey),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(FuturesPage.portfolioExpandKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(FuturesPage.tabKey('positions')));
    await tester.pumpAndSettle();
    expect(find.text('ETH/USDT'), findsOneWidget);
    expect(find.text('SOL/USDT'), findsOneWidget);
    expect(find.text('Tài khoản Futures'), findsOneWidget);

    await tester.tap(find.byKey(FuturesPage.tabKey('orders')));
    await tester.pumpAndSettle();
    expect(find.text('Chưa có lệnh Futures'), findsOneWidget);
  });

  testWidgets('SC-057 close returns to SC-049 TradePage', (tester) async {
    await pumpFutures(tester);

    await tester.tap(find.byKey(FuturesPage.closeKey));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
  });

  testWidgets('SC-057 chart action opens SC-055 advanced chart', (
    tester,
  ) async {
    await pumpFutures(tester);

    await tester.tap(find.byKey(FuturesPage.chartKey));
    await tester.pumpAndSettle();

    expect(find.byType(AdvancedChartPage), findsOneWidget);
  });

  testWidgets('SC-057 leverage action opens SC-058 LeveragePage', (
    tester,
  ) async {
    await pumpFutures(tester);

    await tester.ensureVisible(find.byKey(FuturesPage.leverageKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(FuturesPage.leverageKey));
    await tester.pumpAndSettle();

    expect(find.byType(LeveragePage), findsOneWidget);
    expect(find.text('Điều chỉnh đòn bẩy'), findsOneWidget);
    expect(find.byType(FuturesPage), findsNothing);
  });

  testWidgets('SC-048 Futures quick action opens SC-057', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.trade),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(TradePage.quickNavKey('futures')));
    await tester.tap(find.byKey(TradePage.quickNavKey('futures')));
    await tester.pumpAndSettle();

    expect(find.byType(FuturesPage), findsOneWidget);
  });
}
