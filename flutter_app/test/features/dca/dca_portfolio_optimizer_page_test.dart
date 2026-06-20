import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/pages/dca_portfolio_optimizer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPortfolioOptimizer(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaPortfolioOptimizer,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-174 mock repository exposes portfolio optimizer BE draft', () {
    final snapshot = const DcaRepository().getPortfolioOptimizer();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-portfolio-optimizer');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.score, 73);
    expect(snapshot.driftPercent, 25);
    expect(snapshot.currentAllocations.map((item) => item.symbol), [
      'BTC',
      'ETH',
      'USDT',
      'SOL',
      'BNB',
    ]);
    expect(snapshot.frontier.length, 5);
    expect(snapshot.suggestions.length, 4);
    expect(snapshot.dcaPlans, isEmpty);
    expect(snapshot.schedules, isEmpty);
    expect(snapshot.rules, isEmpty);
    expect(snapshot.portfolioTargets, isEmpty);
    expect(snapshot.backtests, isEmpty);
    expect(
      snapshot.supportedStates,
      containsAll([
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-174 renders portfolio optimizer overview', (tester) async {
    await pumpPortfolioOptimizer(tester);

    expect(find.byType(DCAPortfolioOptimizer), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Portfolio Optimizer'), findsOneWidget);
    expect(find.text('Portfolio Drift Cao'), findsOneWidget);
    expect(find.text('Hiện tại vs Tối ưu'), findsOneWidget);
    expect(find.text('Efficient Frontier'), findsOneWidget);
    expect(find.text('Optimal (Max Sharpe)'), findsWidgets);
    expect(find.byKey(DCAPortfolioOptimizer.applyKey), findsOneWidget);
  });

  testWidgets('SC-174 first viewport reaches optimizer tabs', (tester) async {
    await pumpPortfolioOptimizer(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-174 DCAPortfolioOptimizer',
      semanticLabel: 'SC-174 DCAPortfolioOptimizer',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DCAPortfolioOptimizer.tabKey('frontier')),
      routeName: 'SC-174 DCAPortfolioOptimizer',
      actionLabel: 'the optimizer tab strip',
    );
  });

  testWidgets('SC-174 tabs and apply allocation route are wired', (
    tester,
  ) async {
    await pumpPortfolioOptimizer(tester);

    await tester.ensureVisible(
      find.byKey(DCAPortfolioOptimizer.tabKey('correlation')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCAPortfolioOptimizer.tabKey('correlation')));
    await tester.pumpAndSettle();
    expect(find.text('Ma trận tương quan'), findsOneWidget);

    await tester.ensureVisible(find.byKey(DCAPortfolioOptimizer.applyKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCAPortfolioOptimizer.applyKey));
    await tester.pumpAndSettle();

    expect(find.text('Auto-Rebalance'), findsOneWidget);
  });
}
