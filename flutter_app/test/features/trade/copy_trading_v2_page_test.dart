import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/copy_trading_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/copy_trading_v2_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopyTradingV2(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyTradingV2,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-064 mock repository exposes copy trading v2 BE draft', () {
    final repo = const MockTradeRepository();
    final snapshot = repo.getCopyTradingV2();
    final result = repo.submitCopyTradingAction(
      const TradeCopyActionRequest(providerId: 'ct003', action: 'follow'),
    );

    expect(snapshot.copyTrading.trade.copyProviders, isNotEmpty);
    expect(snapshot.copyTrading.traders, hasLength(5));
    expect(snapshot.heroVariants, ['clean', 'bold', 'glass']);
    expect(snapshot.defaultHeroVariant, 'clean');
    expect(snapshot.copyTrading.totalCopiers, 11013);
    expect(snapshot.copyTrading.totalAum, 19250000);
    expect(result.providerId, 'ct003');
    expect(result.action, 'follow');
    expect(result.status, 'accepted');
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

  testWidgets('SC-064 renders CopyTradingPageV2 inside the Trade shell', (
    tester,
  ) async {
    await pumpCopyTradingV2(tester);

    expect(find.byType(CopyTradingV2Page), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Copy Trading v2'), findsOneWidget);
    expect(find.text('With Variant Switcher'), findsOneWidget);
    expect(find.text('Card Style:'), findsOneWidget);
    expect(find.text('Clean'), findsOneWidget);
    expect(find.text('Bold'), findsOneWidget);
    expect(find.text('Glass'), findsOneWidget);
    expect(find.text('Copy Trading'), findsOneWidget);
    expect(find.text('Cảnh báo rủi ro'), findsOneWidget);
    expect(find.text('RiskMaster_88'), findsWidgets);
    expect(find.text('WhaleWatcher'), findsOneWidget);
    expect(find.text('AlphaHunter_VN'), findsOneWidget);
    expect(find.text('SteadyGains_Pro'), findsNothing);
    expect(find.text('Xem chi tiết'), findsNWidgets(3));
  });

  testWidgets('SC-064 first viewport reaches top ROI trader card', (
    tester,
  ) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyTradingV2,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-064 CopyTradingPageV2',
      semanticLabel: 'SC-064 CopyTradingPageV2',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(CopyTradingV2Page.traderKey('ct003')),
      targetLabel: 'the top ROI trader card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-064 switches hero variants', (tester) async {
    await pumpCopyTradingV2(tester);

    await tester.tap(find.byKey(CopyTradingV2Page.variantKey('bold')));
    await tester.pumpAndSettle();

    expect(find.text('COPY TRADING'), findsOneWidget);
    expect(find.text('Sao chép trader hàng đầu'), findsOneWidget);

    await tester.tap(find.byKey(CopyTradingV2Page.variantKey('glass')));
    await tester.pumpAndSettle();

    expect(find.text('COPY TRADING'), findsNothing);
    expect(find.text('Copy Trading'), findsOneWidget);
  });

  testWidgets('SC-064 sort chips keep only the top three traders', (
    tester,
  ) async {
    await pumpCopyTradingV2(tester);

    await tester.tap(find.byKey(CopyTradingV2Page.sortKey('AUM cao')));
    await tester.pumpAndSettle();

    expect(find.text('WhaleWatcher'), findsOneWidget);
    expect(find.text('SteadyGains_Pro'), findsOneWidget);
    expect(find.text('AlphaHunter_VN'), findsOneWidget);
    expect(find.text('RiskMaster_88'), findsNothing);
  });

  testWidgets('SC-064 provider detail uses the SC-070 route edge', (
    tester,
  ) async {
    await pumpCopyTradingV2(tester);

    await tester.tap(find.byKey(CopyTradingV2Page.detailKey('ct003')));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingV2Page), findsNothing);
    expect(find.text('RiskMaster_88'), findsWidgets);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(CopyTradingV2Page), findsOneWidget);
  });

  testWidgets('SC-064 back returns to SC-063 CopyTradingPage', (tester) async {
    await pumpCopyTradingV2(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(CopyTradingV2Page), findsNothing);
  });
}
