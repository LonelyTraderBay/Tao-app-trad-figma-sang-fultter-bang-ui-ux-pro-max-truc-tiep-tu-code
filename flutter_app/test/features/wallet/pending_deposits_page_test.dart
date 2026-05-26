import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/pending_deposits_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpPendingDeposits(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletPendingDeposits,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-152 mock repository exposes pending deposits BE draft', () {
    final snapshot = const MockWalletRepository().getPendingDeposits();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-pending-deposits');
    expect(snapshot.actionDraft, 'POST /wallet/deposit-intent');
    expect(snapshot.deposits.length, 4);
    expect(snapshot.pendingCount, 2);
    expect(snapshot.deposits.first.asset, 'USDT');
    expect(snapshot.deposits.first.status, 'credited');
    expect(snapshot.deposits[1].progress, .5);
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.submitting,
        WalletScreenState.success,
      ]),
    );
  });

  testWidgets('SC-152 renders pending deposits baseline shell', (tester) async {
    await pumpPendingDeposits(tester);

    expect(find.byType(PendingDepositsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('N\u1EA1p ti\u1EC1n \u0111ang ch\u1EDD'), findsWidgets);
    expect(
      find.text('2 giao d\u1ECBch \u0111ang ch\u1EDD x\u00E1c nh\u1EADn'),
      findsOneWidget,
    );
    expect(find.text('T\u1EA5t c\u1EA3'), findsOneWidget);
    expect(find.text('\u0110ang ch\u1EDD (2)'), findsOneWidget);
    expect(find.text('Ho\u00E0n t\u1EA5t'), findsOneWidget);
    expect(find.text('N\u1EA1p USDT'), findsWidgets);
    expect(find.text('\u0110\u00E3 ghi nh\u1EADn'), findsWidgets);
    expect(find.text('N\u1EA1p BTC'), findsOneWidget);
    expect(find.text('\u0110ang x\u00E1c nh\u1EADn'), findsWidgets);
    expect(find.text('+5,000.00'), findsOneWidget);
    expect(find.text('+0.050000'), findsOneWidget);
    expect(find.text('X\u00E1c nh\u1EADn blockchain'), findsWidgets);
  });

  testWidgets('SC-152 filters and copy action are local', (tester) async {
    await pumpPendingDeposits(tester);

    await tester.tap(find.byKey(PendingDepositsPage.filterKey('pending')));
    await tester.pumpAndSettle();
    expect(find.byKey(PendingDepositsPage.depositKey('pd002')), findsOneWidget);
    expect(find.byKey(PendingDepositsPage.depositKey('pd003')), findsOneWidget);
    expect(find.byKey(PendingDepositsPage.depositKey('pd001')), findsNothing);

    await tester.tap(find.byKey(PendingDepositsPage.filterKey('done')));
    await tester.pumpAndSettle();
    expect(find.byKey(PendingDepositsPage.depositKey('pd001')), findsOneWidget);
    expect(find.byKey(PendingDepositsPage.depositKey('pd004')), findsOneWidget);
    await tester.tap(find.byKey(PendingDepositsPage.copyKey('pd001')));
    await tester.pumpAndSettle();
    expect(find.text('\u0110\u00E3 ch\u00E9p'), findsOneWidget);
  });
}
