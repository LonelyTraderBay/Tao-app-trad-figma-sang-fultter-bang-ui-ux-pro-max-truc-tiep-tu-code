import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/presentation/home_page.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/market_depth_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/token_info_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpPairDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.pairDetail('btcusdt'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-044 mock repository exposes the pair detail BE draft', () {
    final repo = const MockMarketRepository();
    final snapshot = repo.getPairDetail('btcusdt');

    expect(snapshot.pair.symbol, 'BTC/USDT');
    expect(snapshot.marketPairs, isNotEmpty);
    expect(snapshot.watchlist, contains('btcusdt'));
    expect(snapshot.alerts, isNotEmpty);
    expect(snapshot.screenFilters.categories, isNotEmpty);
    expect(snapshot.chartSeries['btcusdt'], isNotEmpty);
    expect(snapshot.depth.bids, isNotEmpty);
    expect(snapshot.recentTrades, hasLength(5));
    expect(snapshot.lastUpdatedLabel, 'read-only');
    expect(
      snapshot.supportedStates,
      containsAll([
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-044 renders pair detail inside the Trade shell', (
    tester,
  ) async {
    await pumpPairDetail(tester);

    expect(find.byType(PairDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('67,543.21'), findsOneWidget);
    expect(find.text('Bieu do'), findsOneWidget);
    expect(find.text('So lenh'), findsOneWidget);
    expect(find.text('Giao dich'), findsOneWidget);
    expect(find.text('Mua dinh ky BTC'), findsOneWidget);
    expect(find.text('Thong tin BTC'), findsOneWidget);
    expect(find.text('Do sau thi truong'), findsOneWidget);
  });

  testWidgets('SC-044 switches order book and trades tabs', (tester) async {
    await pumpPairDetail(tester);

    await tester.tap(find.byKey(PairDetailPage.orderBookTabKey));
    await tester.pumpAndSettle();
    expect(find.text('So lenh BTC/USDT'), findsOneWidget);
    expect(find.textContaining('Mid'), findsOneWidget);

    await tester.tap(find.byKey(PairDetailPage.tradesTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Gia'), findsOneWidget);
    expect(find.text('Khoi luong'), findsOneWidget);
    expect(find.text('23:29:14'), findsOneWidget);
  });

  testWidgets('SC-044 detail cards navigate to token info and depth target', (
    tester,
  ) async {
    await pumpPairDetail(tester);

    await tester.ensureVisible(find.byKey(PairDetailPage.infoButtonKey));
    await tester.tap(find.byKey(PairDetailPage.infoButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(TokenInfoPage), findsOneWidget);

    await pumpPairDetail(tester);
    await tester.ensureVisible(find.byKey(PairDetailPage.depthButtonKey));
    await tester.tap(find.byKey(PairDetailPage.depthButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(MarketDepthPage), findsOneWidget);
  });

  testWidgets('SC-044 back button returns to Home', (tester) async {
    await pumpPairDetail(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });
}
