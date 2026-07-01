import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/market_depth_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/price_alerts_page.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/advanced_chart_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/convert_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/trade_settings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpConvert(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeConvert,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapConvertTool(
    WidgetTester tester,
    String toolId, {
    bool settle = true,
  }) async {
    final toolFinder = find.byKey(ConvertPage.toolKey(toolId));
    await tester.ensureVisible(toolFinder);
    await tester.tap(toolFinder);
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  test('SC-056 mock repository exposes convert BE draft', () {
    final repo = const MockTradeRepository();
    final snapshot = repo.getConvert();
    final quote = repo.previewConvert(
      const TradeConvertRequest(
        fromSymbol: 'USDT',
        toSymbol: 'BTC',
        amount: 500,
        slippagePct: .5,
        mode: 'market',
      ),
    );
    final receipt = repo.submitConvert(
      const TradeConvertRequest(
        fromSymbol: 'USDT',
        toSymbol: 'BTC',
        amount: 500,
        slippagePct: .5,
        mode: 'market',
      ),
    );

    expect(snapshot.trade.pairs, hasLength(3));
    expect(snapshot.assets.map((asset) => asset.symbol), [
      'USDT',
      'BTC',
      'ETH',
      'SOL',
      'BNB',
      'ADA',
      'MATIC',
      'AVAX',
    ]);
    expect(snapshot.favoritePairs.map((pair) => pair.label), [
      'USDT/BTC',
      'USDT/ETH',
      'BTC/ETH',
      'USDT/SOL',
    ]);
    expect(snapshot.history, hasLength(3));
    expect(snapshot.rateLabel, '1 USDT = 0.000015 BTC');
    expect(quote.quoteLabel, '1 USDT = 0.000015 BTC');
    expect(quote.canSubmit, isTrue);
    expect(receipt.convertId, 'CVT-DEMO-056');
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

  testWidgets('SC-056 renders ConvertPage inside the Trade shell', (
    tester,
  ) async {
    await pumpConvert(tester);

    expect(find.byType(ConvertPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Convert / Swap'), findsOneWidget);
    expect(find.text('Market'), findsOneWidget);
    expect(find.text('USDT/BTC'), findsWidgets);
    expect(find.text('1 USDT = 0.000015 BTC'), findsWidgets);
    expect(find.text('Độ trượt giá'), findsOneWidget);
    expect(find.text('Xem lại báo giá'), findsOneWidget);
    expect(find.text('Dự kiến nhận'), findsOneWidget);
    expect(find.text('Kiểm tra rủi ro'), findsOneWidget);
    expect(find.text('Giao dịch gần đây'), findsOneWidget);
  });

  testWidgets('SC-056 first viewport reaches amount field', (tester) async {
    await pumpConvert(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-056 ConvertPage',
      semanticLabel: 'SC-056 ConvertPage',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ConvertPage.amountFieldKey),
      targetLabel: 'the convert amount field',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-056 favorite pair and swap actions stay local', (
    tester,
  ) async {
    await pumpConvert(tester);

    await tester.tap(find.byKey(ConvertPage.favoriteKey('USDT/ETH')));
    await tester.pumpAndSettle();
    expect(find.text('1 USDT = 0.000284 ETH'), findsWidgets);

    await tester.tap(find.byKey(ConvertPage.swapKey));
    await tester.pumpAndSettle();
    expect(find.text('ETH/USDT'), findsNothing);
    expect(find.byType(ConvertPage), findsOneWidget);
  });

  testWidgets('SC-056 asset picker resolves toAsset edge locally', (
    tester,
  ) async {
    await pumpConvert(tester);

    await tester.tap(find.byKey(ConvertPage.toAssetKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ConvertPage.assetOptionKey('to', 'ETH')));
    await tester.pumpAndSettle();

    expect(find.text('1 USDT = 0.000284 ETH'), findsWidgets);
    expect(find.byType(ConvertPage), findsOneWidget);
  });

  testWidgets('SC-056 percent, slippage, and submit use mock convert draft', (
    tester,
  ) async {
    await pumpConvert(tester);

    await tester.tap(find.byKey(ConvertPage.pctKey(25)));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(ConvertPage.slippageKey('1.0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ConvertPage.slippageKey('1.0')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(ConvertPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ConvertPage.submitKey));
    await tester.pump();

    expect(find.byType(ConvertPage), findsOneWidget);
    expect(find.textContaining('CVT-DEMO-056'), findsWidgets);
  });

  testWidgets('SC-056 back returns to SC-048 TradePage', (tester) async {
    await pumpConvert(tester);

    await tester.tap(find.byKey(ConvertPage.backKey));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
  });

  testWidgets('SC-056 tool row exposes navigation keys and targets', (
    tester,
  ) async {
    await pumpConvert(tester);

    expect(find.byKey(ConvertPage.toolKey('chart')), findsOneWidget);
    expect(find.byKey(ConvertPage.toolKey('depth')), findsOneWidget);
    expect(find.byKey(ConvertPage.toolKey('info')), findsOneWidget);
    expect(find.byKey(ConvertPage.toolKey('alert')), findsOneWidget);
    expect(find.byKey(ConvertPage.toolKey('settings')), findsNothing);

    await tapConvertTool(tester, 'chart');
    expect(find.byType(AdvancedChartPage), findsOneWidget);
  });

  testWidgets('SC-056 depth tool opens market depth page', (tester) async {
    await pumpConvert(tester);

    await tapConvertTool(tester, 'depth');
    expect(find.byType(MarketDepthPage), findsOneWidget);
  });

  testWidgets('SC-056 info tool opens convert pair sheet', (tester) async {
    await pumpConvert(tester);

    await tapConvertTool(tester, 'info');
    expect(find.text('Thông tin cặp'), findsOneWidget);
    expect(find.text('1 USDT = 0.000015 BTC'), findsWidgets);
  });

  testWidgets('SC-056 alert tool opens price alerts page', (tester) async {
    await pumpConvert(tester);

    await tapConvertTool(tester, 'alert');
    expect(find.byType(PriceAlertsPage), findsOneWidget);
  });

  testWidgets('SC-056 settings header action opens trade settings page', (
    tester,
  ) async {
    await pumpConvert(tester);

    await tester.tap(find.byTooltip('Cài đặt giao dịch'));
    await tester.pumpAndSettle();
    expect(find.byType(TradeSettingsPage), findsOneWidget);
  });

  testWidgets(
    'SC-056 chart on unsupported pair shows snackbar and stays local',
    (tester) async {
      await pumpConvert(tester);

      await tester.tap(find.byKey(ConvertPage.favoriteKey('BTC/ETH')));
      await tester.pumpAndSettle();

      await tapConvertTool(tester, 'chart', settle: false);
      expect(find.text('Chưa có biểu đồ spot cho cặp này'), findsOneWidget);
      expect(find.byType(ConvertPage), findsOneWidget);
      expect(find.byType(AdvancedChartPage), findsNothing);
    },
  );

  testWidgets('SC-048 Convert quick action opens SC-056', (tester) async {
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

    await tester.ensureVisible(find.byKey(TradePage.quickNavKey('convert')));
    await tester.tap(find.byKey(TradePage.quickNavKey('convert')));
    await tester.pumpAndSettle();

    expect(find.byType(ConvertPage), findsOneWidget);
  });
}
