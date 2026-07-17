import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/convert/convert_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/hub/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/hub/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTrade(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.trade,
    Size viewport = const Size(440, 956),
    TradeRepository? repository,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (repository != null)
            tradeRepositoryProvider.overrideWithValue(repository),
        ],
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
    expect(find.text('BTC/USDT'), findsAtLeastNWidgets(1));
    expect(find.text('67,543.21'), findsAtLeastNWidgets(1));
    expect(find.byKey(TradePage.buySideKey), findsOneWidget);
    expect(find.text('BÁN'), findsOneWidget);
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
    expect(find.text('BTC/USDT'), findsAtLeastNWidgets(1));
    expect(find.byKey(TradePage.quickNavKey('spot')), findsOneWidget);
    expect(find.byKey(TradePage.quickNavKey('convert')), findsOneWidget);
    expect(find.byKey(TradePage.quickNavKey('futures')), findsOneWidget);
    expect(find.text('67,543.21'), findsAtLeastNWidgets(1));
    expect(find.text('Chế độ Pro'), findsNothing);
    expect(find.text('Giao dịch Spot'), findsOneWidget);
    expect(find.text('Charts'), findsNothing);
    expect(find.byKey(TradePage.buySideKey), findsOneWidget);
    expect(find.text('BÁN'), findsOneWidget);
    expect(find.text('Tiếp theo'), findsOneWidget);
    expect(find.textContaining('Số dư khả dụng'), findsOneWidget);
    expect(find.text('Giá thị trường có thể thay đổi'), findsOneWidget);
  });

  testWidgets('SC-048 first viewport reaches order side switch', (
    tester,
  ) async {
    await pumpTrade(tester);

    expectActionableInFirstViewport(
      tester,
      find.byKey(TradePage.buySideKey),
      routeName: 'TradePage',
      actionLabel: 'buy side switch',
    );
  });

  testWidgets('SC-048 amount shortcuts update the order draft', (tester) async {
    await pumpTrade(tester);

    await tester.scrollUntilVisible(
      find.byKey(TradePage.pctKey(25)),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(TradePage.pctKey(25)));
    await tester.pumpAndSettle();

    expect(find.textContaining('0.037'), findsWidgets);
    expect(find.text('Xác nhận MUA'), findsOneWidget);
  });

  testWidgets('SC-048 confirm sheet gates order submission', (tester) async {
    await pumpTrade(tester);

    await tester.scrollUntilVisible(
      find.byKey(TradePage.pctKey(25)),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(TradePage.pctKey(25)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(TradePage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byKey(TradePage.confirmSheetKey), findsOneWidget);
    expect(find.text('Xác nhận gửi'), findsOneWidget);

    await tester.tap(find.byKey(VitTradeConfirmKeys.confirmSubmit));
    await tester.pumpAndSettle();

    expect(find.textContaining('ORD-'), findsWidgets);
  });

  testWidgets(
    'SC-048 nhánh lỗi ADR-001: repo ném thì ở lại trang, hiện error, không điều hướng receipt',
    (tester) async {
      await pumpTrade(
        tester,
        repository: const MockTradeRepository(
          loadDelay: Duration.zero,
          simulateError: true,
        ),
      );

      await tester.scrollUntilVisible(
        find.byKey(TradePage.pctKey(25)),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byKey(TradePage.pctKey(25)));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(TradePage.submitKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(VitTradeConfirmKeys.confirmSubmit));
      await tester.pumpAndSettle();

      expect(find.byType(TradePage), findsOneWidget);
      expect(find.textContaining('ORD-'), findsNothing);
      expect(find.text('Gửi lệnh thất bại'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('SC-048 quick nav opens SC-056 ConvertPage', (tester) async {
    await pumpTrade(tester);

    final convertNav = find.byKey(TradePage.quickNavKey('convert'));
    await tester.ensureVisible(convertNav);
    await tester.tap(convertNav);
    await tester.pumpAndSettle();

    expect(find.byType(ConvertPage), findsOneWidget);
    expect(find.text('Convert / Swap'), findsOneWidget);
  });

  testWidgets('SC-048 360px simple layout stays usable', (tester) async {
    configureFirstViewport(tester, VitFirstViewport.minimumPhone);
    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.trade),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expectActionableInFirstViewport(
      tester,
      find.byKey(TradePage.buySideKey),
      routeName: 'TradePage',
      actionLabel: 'buy side switch',
    );
    expect(find.text('Charts'), findsNothing);
  });

  testWidgets('SC-048 product hub follows enterprise product order', (
    tester,
  ) async {
    await pumpTrade(tester);

    const primaryIds = ['spot', 'convert', 'futures', 'margin'];
    for (final id in primaryIds) {
      expect(find.byKey(TradePage.quickNavKey(id)), findsOneWidget);
    }

    expect(find.text('Thêm'), findsNothing);
  });
}
