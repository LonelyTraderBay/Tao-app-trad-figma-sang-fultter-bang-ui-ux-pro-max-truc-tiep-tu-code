import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/advanced_analytics_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpAdvancedAnalytics(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeMarginAdvancedAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-092 mock repository exposes advanced analytics BE draft', () {
    final snapshot = const MockTradeRepository().getAdvancedAnalytics();

    expect(snapshot.defaultTab, 'ai');
    expect(snapshot.stats.map((item) => item.value), [
      '3',
      '58',
      '66.7%',
      '1.82',
    ]);
    expect(snapshot.signals.map((item) => item.pair), [
      'BTC/USDT',
      'ETH/USDT',
      'SOL/USDT',
    ]);
    expect(snapshot.risk.riskScore, 58);
    expect(snapshot.journal.winRate, 66.7);
    expect(snapshot.sizing.positionSize, 1.43);
    expect(snapshot.features, contains('AI Trading Signals'));
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

  testWidgets('SC-092 renders advanced analytics inside the Trade shell', (
    tester,
  ) async {
    await pumpAdvancedAnalytics(tester);

    expect(find.byType(AdvancedAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Advanced Analytics'), findsOneWidget);
    expect(find.text('AI & Professional Tools'), findsOneWidget);
    expect(find.text('P3: Advanced Analytics'), findsOneWidget);
    expect(find.text('AI Trading Signals'), findsWidgets);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('AI Prediction Disclaimer'), findsOneWidget);
    expect(find.text('P3 Features Included'), findsOneWidget);
  });

  testWidgets('SC-092 filters AI signals and switches local tabs', (
    tester,
  ) async {
    await pumpAdvancedAnalytics(tester);

    await tester.tap(AdvancedAnalyticsPage.filterKey('short').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('ETH/USDT'), findsOneWidget);
    expect(find.text('BTC/USDT'), findsNothing);

    await tester.tap(AdvancedAnalyticsPage.tabKey('risk').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Portfolio Risk Analyzer'), findsOneWidget);
    expect(find.text('Enterprise Risk Management'), findsOneWidget);

    await tester.tap(AdvancedAnalyticsPage.tabKey('journal').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Trade Journal'), findsWidgets);
    expect(find.text('Performance Attribution'), findsWidgets);

    await tester.tap(AdvancedAnalyticsPage.tabKey('sizing').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Position Sizing Calculator'), findsOneWidget);
    expect(find.text('Kelly Criterion Optimization'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
