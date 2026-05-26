import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/bot_guide_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpBotGuide(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotGuide,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-131 mock repository exposes bot guide BE draft', () {
    final snapshot = const MockTradeRepository().getBotGuide();

    expect(snapshot.strategies, hasLength(4));
    expect(snapshot.bestPractices, hasLength(6));
    expect(snapshot.mistakes, hasLength(5));
    expect(snapshot.strategies.first.name, 'DCA Bot (Dollar Cost Averaging)');
    expect(snapshot.strategies.last.difficulty, 'Expert');
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-guide');
    expect(snapshot.actionDraft, contains('POST /trade/order-preview'));
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

  testWidgets('SC-131 renders strategy guide baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotGuide(tester);

    expect(find.byType(BotGuidePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Trading Bots Guide'), findsOneWidget);
    expect(find.text('Complete Guide to Trading Bots'), findsOneWidget);
    expect(find.text('Bot Strategies Explained'), findsOneWidget);
    expect(find.text('DCA Bot (Dollar Cost Averaging)'), findsOneWidget);
    expect(find.text('Grid Bot'), findsOneWidget);
    expect(find.text('Momentum Bot'), findsOneWidget);
    expect(find.text('Martingale Bot'), findsOneWidget);
    expect(find.text('Video Tutorials'), findsOneWidget);
  });

  testWidgets('SC-131 tab controls switch guide sections', (tester) async {
    await pumpBotGuide(tester);

    await tester.tap(find.byKey(BotGuidePage.tabKey('best-practices')));
    await tester.pumpAndSettle();
    expect(find.text('Best Practices'), findsOneWidget);
    expect(find.text('Start Small'), findsOneWidget);
    expect(find.text('Backtest First'), findsOneWidget);

    await tester.tap(find.byKey(BotGuidePage.tabKey('mistakes')));
    await tester.pumpAndSettle();
    expect(find.text('Common Mistakes to Avoid'), findsOneWidget);
    expect(find.text('Over-optimizing parameters'), findsOneWidget);
  });

  testWidgets('SC-131 strategy cards expand with mock guidance details', (
    tester,
  ) async {
    await pumpBotGuide(tester);

    await tester.tap(find.byKey(BotGuidePage.strategyKey('dca')));
    await tester.pumpAndSettle();

    expect(find.text('How It Works:'), findsOneWidget);
    expect(find.text('Pros'), findsOneWidget);
    expect(find.text('Cons'), findsOneWidget);
    expect(find.text('Buy \$100 BTC every Monday'), findsOneWidget);
  });
}
