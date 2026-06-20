import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/transfer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTransfer(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletTransfer,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-146 mock repository exposes transfer BE draft', () {
    final snapshot = const MockWalletRepository().getTransfer();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-transfer');
    expect(
      snapshot.actionDraft,
      'POST /wallet/transfer-preview + POST /wallet/transfer-confirm',
    );
    expect(snapshot.wallets.map((wallet) => wallet.id), [
      'spot',
      'funding',
      'futures',
    ]);
    expect(snapshot.assets.first.symbol, 'USDT');
    expect(snapshot.assets.first.available, 10200);
    expect(snapshot.recentTransfers, hasLength(3));
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

  testWidgets('SC-146 renders transfer baseline in Wallet shell', (
    tester,
  ) async {
    await pumpTransfer(tester);

    expect(find.byType(TransferPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Chuy\u1ec3n n\u1ed9i b\u1ed9'), findsOneWidget);
    expect(find.text('Chuy\u1ec3n ti\u1ec1n \u00b7 Wallet'), findsOneWidget);
    expect(find.text('V\u00ed Spot'), findsOneWidget);
    expect(find.text('S\u1ed1 d\u01b0: \$54,276.79'), findsOneWidget);
    expect(find.text('V\u00ed Funding'), findsOneWidget);
    expect(find.text('S\u1ed1 d\u01b0: \$8,450.20'), findsOneWidget);
    expect(find.text('USDT'), findsWidgets);
    expect(find.text('Kh\u1ea3 d\u1ee5ng: 10,200.00 USDT'), findsOneWidget);
    expect(find.text('0.00'), findsOneWidget);
    expect(find.text('T\u1edbi \u0111a'), findsOneWidget);
    expect(find.text('X\u00e1c nh\u1eadn chuy\u1ec3n'), findsOneWidget);
    expect(
      find.text('L\u1ecbch s\u1eed chuy\u1ec3n g\u1ea7n \u0111\u00e2y'),
      findsOneWidget,
    );
    expect(find.text('Spot \u2192 Funding'), findsOneWidget);
  });

  testWidgets('SC-146 first viewport reaches transfer amount field', (
    tester,
  ) async {
    await pumpTransfer(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'TransferPage',
      semanticLabel: 'SC-146 TransferPage',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(TransferPage.amountFieldKey),
      routeName: 'TransferPage',
      actionLabel: 'the transfer amount field',
    );
  });

  testWidgets('SC-146 transfer controls support preview confirmation', (
    tester,
  ) async {
    await pumpTransfer(tester);

    await tester.tap(find.byKey(TransferPage.swapKey));
    await tester.pumpAndSettle();
    expect(find.text('V\u00ed Funding'), findsWidgets);
    expect(find.text('S\u1ed1 d\u01b0: \$8,450.20'), findsWidgets);

    await tester.tap(find.byKey(TransferPage.maxKey));
    await tester.pumpAndSettle();
    expect(find.text('10,200.00'), findsOneWidget);

    await tester.tap(find.byKey(TransferPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('X\u00e1c nh\u1eadn'), findsOneWidget);
    expect(find.text('Mi\u1ec5n ph\u00ed'), findsOneWidget);

    await tester.tap(find.byKey(TransferPage.confirmKey));
    await tester.pumpAndSettle();
    expect(find.text('Chuy\u1ec3n th\u00e0nh c\u00f4ng!'), findsOneWidget);
  });
}
