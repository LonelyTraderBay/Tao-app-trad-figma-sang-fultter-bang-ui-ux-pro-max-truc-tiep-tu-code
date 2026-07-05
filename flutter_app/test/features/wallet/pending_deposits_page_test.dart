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

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPendingDeposits(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

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

  Finder semanticsLabel(Pattern pattern) {
    return find.byWidgetPredicate((widget) {
      if (widget is! Semantics) return false;
      final label = widget.properties.label;
      if (label == null) return false;
      return switch (pattern) {
        String() => label == pattern,
        RegExp() => pattern.hasMatch(label),
        _ => false,
      };
    });
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
      find.text('Theo d\u00F5i x\u00E1c nh\u1EADn \u00B7 Wallet'),
      findsOneWidget,
    );
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
    expect(find.text('1/2 y\u00EAu c\u1EA7u'), findsOneWidget);
    expect(find.text('X\u00E1c nh\u1EADn y\u00EAu c\u1EA7u'), findsWidgets);
    expect(find.text('+5,000.00'), findsOneWidget);
    expect(find.text('+0.050000'), findsOneWidget);
    expect(find.text('X\u00E1c nh\u1EADn blockchain'), findsWidgets);
    expect(semanticsLabel('Refresh pending deposit statuses'), findsOneWidget);
    expect(
      semanticsLabel(RegExp(r'Copy transaction hash for .+')),
      findsWidgets,
    );
  });

  testWidgets('SC-152 first viewport reaches first pending deposit', (
    tester,
  ) async {
    await pumpPendingDeposits(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'PendingDepositsPage',
      semanticLabel: 'SC-152 PendingDepositsPage',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(PendingDepositsPage.depositKey('pd001')),
      routeName: 'PendingDepositsPage',
      actionLabel: 'the first pending deposit card',
    );
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
    await tester.ensureVisible(
      find.byKey(PendingDepositsPage.copyKey('pd001')),
    );
    await tester.tap(find.byKey(PendingDepositsPage.copyKey('pd001')));
    await tester.pumpAndSettle();
    expect(find.text('\u0110\u00E3 ch\u00E9p'), findsOneWidget);
    expect(semanticsLabel('Transaction hash copied for USDT'), findsOneWidget);
  });

  testWidgets('SC-152 refresh shows visible status feedback', (tester) async {
    await pumpPendingDeposits(tester);

    await tester.tap(find.byKey(PendingDepositsPage.refreshKey));
    await tester.pump();

    expect(find.byKey(PendingDepositsPage.refreshFeedbackKey), findsOneWidget);
    expect(
      find.text(
        'V\u1EEBa c\u1EADp nh\u1EADt tr\u1EA1ng th\u00E1i n\u1EA1p ti\u1EC1n',
      ),
      findsOneWidget,
    );
  });
}
