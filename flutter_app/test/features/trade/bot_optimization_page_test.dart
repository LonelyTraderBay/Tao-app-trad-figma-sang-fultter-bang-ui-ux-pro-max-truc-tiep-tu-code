import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/bot_optimization_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotOptimization(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotOptimization,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-127 mock repository exposes optimization BE draft', () {
    final repo = const MockTradeRepository();
    final snapshot = repo.getBotOptimization();
    final result = repo.runBotOptimization(
      const TradeBotOptimizationRequest(
        targetId: 'sharpe',
        gridCount: 25,
        gridRangePct: 35,
      ),
    );

    expect(snapshot.targets, hasLength(3));
    expect(snapshot.parameterRanges, hasLength(2));
    expect(snapshot.steps, hasLength(4));
    expect(snapshot.defaultTargetId, 'sharpe');
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-optimization');
    expect(snapshot.actionDraft, contains('POST /bots/optimization/run'));
    expect(result.jobId, 'BOT-OPT-127');
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

  testWidgets('SC-127 renders optimization config baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotOptimization(tester);

    expect(find.byType(BotOptimizationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Parameter Optimization'), findsOneWidget);
    expect(find.text('Automated Parameter Tuning'), findsOneWidget);
    expect(find.text('Optimization Target'), findsOneWidget);
    expect(find.text('Parameter Ranges'), findsOneWidget);
    expect(find.text('Start Optimization'), findsOneWidget);
  });

  testWidgets('SC-127 target selection and start action use mock contract', (
    tester,
  ) async {
    await pumpBotOptimization(tester);

    await tester.tap(find.byKey(BotOptimizationPage.targetKey('drawdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(BotOptimizationPage.startKey));
    await tester.pumpAndSettle();

    expect(find.textContaining('BOT-OPT-127'), findsOneWidget);
  });

  testWidgets('SC-127 first viewport reaches optimization target', (
    tester,
  ) async {
    await pumpBotOptimization(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-127 BotOptimizationPage',
      semanticLabel: 'SC-127 BotOptimizationPage',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(BotOptimizationPage.targetKey('sharpe')),
      routeName: 'SC-127 BotOptimizationPage',
      actionLabel: 'the default optimization target',
    );
  });
}
