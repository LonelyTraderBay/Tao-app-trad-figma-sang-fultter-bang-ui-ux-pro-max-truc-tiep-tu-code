import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/withdraw_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/wallet_token_approval_page.dart';

void main() {
  Future<void> pumpRoute(WidgetTester tester, String initialLocation) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
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

  testWidgets('SC-139 Withdraw exposes critical control semantics', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.walletWithdraw);

    expect(
      semanticsLabel(RegExp(r'Withdrawal destination address')),
      findsOneWidget,
    );
    expect(semanticsLabel(RegExp(r'Withdrawal amount')), findsOneWidget);
    expect(semanticsLabel('Use full withdrawable balance'), findsOneWidget);
    expect(semanticsLabel('Preview withdrawal'), findsOneWidget);
    expect(
      semanticsLabel(
        RegExp(r'Withdraw network selector .+, fee .+, minimum .+'),
      ),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(WithdrawPage.addressFieldKey),
      'TXYZ1234567890abcdef',
    );
    await tester.ensureVisible(find.byKey(WithdrawPage.amountFieldKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(WithdrawPage.amountFieldKey), '100');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(WithdrawPage.nextKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WithdrawPage.nextKey));
    await tester.pumpAndSettle();

    expect(semanticsLabel('Cancel withdrawal preview'), findsOneWidget);
    expect(semanticsLabel('Confirm withdrawal'), findsOneWidget);
  });

  testWidgets(
    'SC-143 Address Add exposes form, selector, and agreement semantics',
    (tester) async {
      await pumpRoute(tester, AppRoutePaths.walletAddressBookAdd);

      expect(semanticsLabel(RegExp(r'Address label')), findsOneWidget);
      expect(semanticsLabel(RegExp(r'Wallet address')), findsOneWidget);
      expect(semanticsLabel('TRC20 address network'), findsOneWidget);
      expect(semanticsLabel('USDT address asset'), findsOneWidget);
      expect(semanticsLabel('Paste wallet address'), findsOneWidget);
      expect(semanticsLabel('Scan wallet address QR code'), findsOneWidget);
      expect(
        semanticsLabel('Add address to withdrawal whitelist'),
        findsOneWidget,
      );
      expect(
        semanticsLabel('Confirm wallet address and network are correct'),
        findsOneWidget,
      );
      expect(semanticsLabel('Save wallet address'), findsOneWidget);
    },
  );

  testWidgets(
    'SC-232 P2P Payment Add exposes type, option, form, and save semantics',
    (tester) async {
      await pumpRoute(tester, AppRoutePaths.p2pPaymentMethodAdd);

      expect(semanticsLabel(RegExp(r'.+ payment type')), findsWidgets);
      expect(semanticsLabel('Vietcombank payment option'), findsOneWidget);
      expect(semanticsLabel('P2P payment account'), findsOneWidget);
      expect(semanticsLabel('P2P payment account owner'), findsOneWidget);
      expect(
        semanticsLabel('Preview and add P2P payment method'),
        findsOneWidget,
      );
    },
  );

  testWidgets('SC-150 Token approval exposes revoke semantics', (tester) async {
    await pumpRoute(tester, AppRoutePaths.walletTokenApproval);

    expect(semanticsLabel('Active approvals tab'), findsOneWidget);
    expect(
      semanticsLabel(RegExp(r'Revoke approval for .+ to .+')),
      findsWidgets,
    );
    expect(
      semanticsLabel('Revoke all high-risk token approvals'),
      findsOneWidget,
    );

    await tester.tap(WalletTokenApprovalPage.revokeKey('a3').finder);
    await tester.pumpAndSettle();

    expect(semanticsLabel('Cancel token revoke preview'), findsOneWidget);
    expect(semanticsLabel('Confirm'), findsOneWidget);
  });

  testWidgets('SC-036 Prediction risk calculator exposes tabs and scenarios', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.marketsPredictionsRiskCalculator);

    expect(semanticsLabel(RegExp(r'.+ risk calculator tab')), findsWidgets);
    expect(semanticsLabel(RegExp(r'.+ risk scenario')), findsWidgets);
  });

  testWidgets('Admin dashboards expose KPI and chart summaries', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.adminAnalytics);

    expect(semanticsLabel(RegExp(r'Admin analytics metric .+')), findsWidgets);
    expect(semanticsLabel(RegExp(r'Event volume chart .+')), findsOneWidget);

    await pumpRoute(tester, AppRoutePaths.adminFunnels);
    expect(semanticsLabel(RegExp(r'Admin funnel metric .+')), findsWidgets);
    expect(semanticsLabel(RegExp(r'.+ dropout chart')), findsOneWidget);

    await pumpRoute(tester, AppRoutePaths.adminAbtests);
    expect(semanticsLabel(RegExp(r'Admin A/B test metric .+')), findsWidgets);
    expect(
      semanticsLabel(RegExp(r'.+ variant conversion rate .+')),
      findsWidgets,
    );
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
