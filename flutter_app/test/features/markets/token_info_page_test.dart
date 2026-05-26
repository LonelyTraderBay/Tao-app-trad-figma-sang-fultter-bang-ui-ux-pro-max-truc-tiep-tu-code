import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/token_info_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpTokenInfo(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.pairInfo('btcusdt'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-045 mock repository exposes the BE draft read model', () {
    final snapshot = const MockMarketRepository().getTokenInfo('btcusdt');

    expect(snapshot.pair.id, 'btcusdt');
    expect(snapshot.fundamentals.symbol, 'BTC');
    expect(snapshot.fundamentals.name, 'Bitcoin');
    expect(snapshot.fundamentals.supplyDistribution, hasLength(2));
    expect(snapshot.fundamentals.contractAddresses, isEmpty);
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, [
      'Tong quan',
      'On-chain',
      'Du an',
    ]);
    expect(snapshot.chartSeries['btcusdt'], isNotEmpty);
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

  testWidgets('SC-045 renders overview inside the trade shell', (tester) async {
    await pumpTokenInfo(tester);

    expect(find.byType(TokenInfoPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC - Thong tin'), findsOneWidget);
    expect(find.text('Tong quan'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('Thong ke thi truong'), findsOneWidget);
    expect(find.text('Cung token'), findsOneWidget);
  });

  testWidgets('SC-045 switches on-chain and project tabs locally', (
    tester,
  ) async {
    await pumpTokenInfo(tester);

    await tester.tap(find.byKey(TokenInfoPage.onchainTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Hoat dong mang luoi (24h)'), findsOneWidget);
    expect(find.text('Thong tin mang luoi'), findsOneWidget);

    await tester.tap(find.byKey(TokenInfoPage.projectTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Gioi thieu'), findsOneWidget);
    expect(find.text('Lien ket'), findsOneWidget);
  });

  testWidgets('SC-045 back button returns to SC-044 PairDetailPage', (
    tester,
  ) async {
    await pumpTokenInfo(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets('SC-045 chart CTA returns to SC-044 PairDetailPage', (
    tester,
  ) async {
    await pumpTokenInfo(tester);

    await tester.ensureVisible(find.byKey(TokenInfoPage.chartButtonKey));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(TokenInfoPage.chartButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });
}
