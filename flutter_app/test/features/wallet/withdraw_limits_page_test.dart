import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/kyc_page.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/withdraw_limits_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpWithdrawLimits(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletLimits,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-153 mock repository exposes withdraw limits BE draft', () {
    final snapshot = const MockWalletRepository().getWithdrawLimits();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-limits');
    expect(
      snapshot.actionDraft,
      'read-only + local navigation to /profile/kyc',
    );
    expect(snapshot.currentLevel, 2);
    expect(snapshot.currentTier.name, 'N\u00E2ng cao');
    expect(snapshot.tiers.length, 4);
    expect(snapshot.faqs.length, 3);
    expect(snapshot.dailyRemaining, 97550);
    expect(snapshot.monthlyRemaining, 481250);
    expect(snapshot.dailyPercent.toStringAsFixed(1), '2.5');
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

  testWidgets('SC-153 renders withdraw limits baseline shell', (tester) async {
    await pumpWithdrawLimits(tester);

    expect(find.byType(WithdrawLimitsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('H\u1EA1n m\u1EE9c r\u00FAt ti\u1EC1n'), findsWidgets);
    expect(find.text('KYC Level 2'), findsWidgets);
    expect(find.text('N\u00E2ng cao'), findsWidgets);
    expect(find.text('\u0110\u00E3 x\u00E1c minh'), findsOneWidget);
    expect(find.text('\$2,450.00 / \$100,000.00'), findsOneWidget);
    expect(find.text('C\u00F2n l\u1EA1i: \$97,550.00'), findsOneWidget);
    expect(find.text('\$100,000.00'), findsWidgets);
    expect(find.text('\$50,000.00'), findsOneWidget);
    expect(find.text('\$500,000.00'), findsWidgets);
    expect(find.text('Level 0'), findsOneWidget);
    expect(find.text('Level 3'), findsOneWidget);
    expect(find.text('HI\u1EC6N T\u1EA0I'), findsOneWidget);
  });

  testWidgets('SC-153 wires locked tier to KYC edge', (tester) async {
    await pumpWithdrawLimits(tester);

    await tester.tap(find.byKey(WithdrawLimitsPage.tierKey(3)));
    await tester.pumpAndSettle();

    expect(find.byType(KYCPage), findsOneWidget);
    expect(find.text('X\u00E1c minh danh t\u00EDnh'), findsOneWidget);
  });
}
