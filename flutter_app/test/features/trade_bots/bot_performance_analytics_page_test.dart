import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/dashboard/bot_performance_analytics_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotPerformanceAnalytics(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotPerformanceAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-124 mock repository exposes performance analytics BE draft', () {
    final snapshot = const MockTradeBotsRepository()
        .getBotPerformanceAnalytics();

    expect(snapshot.pnlPoints, hasLength(8));
    expect(snapshot.winLossPoints, hasLength(4));
    expect(snapshot.strategyPerformance, hasLength(3));
    expect(snapshot.durationDistribution, hasLength(4));
    expect(snapshot.metrics.totalPnl, 199.30);
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-bots-performance-analytics',
    );
    expect(snapshot.actionDraft, contains('POST /bots/create'));
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

  testWidgets('SC-124 renders performance analytics baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotPerformanceAnalytics(tester);

    expect(find.byType(BotPerformanceAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Performance Analytics'), findsOneWidget);
    expect(find.text('+\$199.30'), findsOneWidget);
    expect(find.text('Cumulative PnL'), findsOneWidget);
    expect(find.text('Win/Loss Distribution'), findsOneWidget);
    expect(find.text('Performance by Strategy'), findsOneWidget);
  });

  testWidgets('SC-124 first viewport reaches cumulative PnL chart', (
    tester,
  ) async {
    await pumpBotPerformanceAnalytics(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'BotPerformanceAnalyticsPage',
      semanticLabel: 'SC-124 BotPerformanceAnalyticsPage',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(BotPerformanceAnalyticsPage.pnlChartKey),
      minVisibleHeight: 24,
      targetLabel: 'cumulative PnL chart',
      reason:
          'Bot performance analytics must expose the first analytical chart '
          'above bottom navigation after key metrics, review, and timeframe '
          'tabs.',
    );
  });

  testWidgets('SC-124 timeframe tabs are selectable', (tester) async {
    await pumpBotPerformanceAnalytics(tester);

    await tester.tap(
      find.byKey(BotPerformanceAnalyticsPage.timeframeKey('30d')),
    );
    await tester.pumpAndSettle();

    expect(find.text('30 Days'), findsOneWidget);
    expect(find.text('All Time'), findsOneWidget);
  });
}
