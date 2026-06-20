import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/wallet_gas_optimizer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpGasOptimizer(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletGasOptimizer,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-149 mock repository exposes gas optimizer BE draft', () {
    final snapshot = const MockWalletRepository().getGasOptimizer();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-gas-optimizer');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.levels.map((level) => level.speed), [
      'slow',
      'standard',
      'fast',
    ]);
    expect(snapshot.recommendedLevel.label, 'Standard');
    expect(snapshot.recommendedLevel.gwei, 25);
    expect(snapshot.vsAveragePct, closeTo(-10.71, .01));
    expect(snapshot.comparisons.length, 4);
    expect(snapshot.history.length, 7);
    expect(snapshot.tips.first.title, 'Transact During Low Activity');
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-149 renders gas optimizer current baseline shell', (
    tester,
  ) async {
    await pumpGasOptimizer(tester);

    expect(find.byType(WalletGasOptimizerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Gas Optimizer'), findsOneWidget);
    expect(find.text('Hien tai'), findsOneWidget);
    expect(find.text('Xu huong'), findsOneWidget);
    expect(find.text('Meo tiet kiem'), findsOneWidget);
    expect(find.text('Low Gas Prices - Good Time!'), findsOneWidget);
    expect(find.textContaining('11% below'), findsOneWidget);
    expect(find.text('Chon toc do giao dich'), findsOneWidget);
    expect(find.text('Slow'), findsOneWidget);
    expect(find.text('15 Gwei'), findsOneWidget);
    expect(find.text('Standard'), findsOneWidget);
    expect(find.text('RECOMMENDED'), findsOneWidget);
    expect(find.text('25 Gwei'), findsOneWidget);
    expect(find.text('Fast'), findsOneWidget);
    expect(find.text('35 Gwei'), findsOneWidget);
    expect(find.text('Transaction Type Comparison'), findsOneWidget);
    expect(find.text('Simple Transfer'), findsOneWidget);
    expect(find.text('~\$3.50'), findsWidgets);
    expect(find.text('Refresh Prices'), findsOneWidget);
  });

  testWidgets('SC-149 first viewport reaches gas comparison fee row', (
    tester,
  ) async {
    await pumpGasOptimizer(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-149 WalletGasOptimizerPage',
      semanticLabel: 'SC-149 WalletGasOptimizerPage',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(WalletGasOptimizerPage.comparisonKey('Simple Transfer')),
      targetLabel: 'the first gas comparison fee row',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-149 speed selection and secondary tabs are local', (
    tester,
  ) async {
    await pumpGasOptimizer(tester);

    await tester.tap(find.byKey(WalletGasOptimizerPage.speedKey('slow')));
    await tester.pumpAndSettle();
    expect(find.text('Slow'), findsOneWidget);

    await tester.tap(find.byKey(WalletGasOptimizerPage.tabKey('Xu huong')));
    await tester.pumpAndSettle();
    expect(find.text('24h Gas Price Trends'), findsOneWidget);
    expect(find.text('Network Activity'), findsOneWidget);
    expect(find.text('Best Time to Transact'), findsOneWidget);

    await tester.tap(
      find.byKey(WalletGasOptimizerPage.tabKey('Meo tiet kiem')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Gas Optimization Tips'), findsOneWidget);
    expect(find.text('Transact During Low Activity'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
  });
}
