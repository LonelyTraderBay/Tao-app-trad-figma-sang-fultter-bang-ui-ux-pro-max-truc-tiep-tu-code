import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/wallet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpWallet(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.wallet),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-135 mock repository exposes wallet BE draft', () {
    final snapshot = const MockWalletRepository().getWallet();

    expect(snapshot.totalUsd, 57664);
    expect(snapshot.totalBtc, 0.85373496);
    expect(snapshot.actions.map((item) => item.id), [
      'deposit',
      'withdraw',
      'buy',
      'transfer',
      'history',
    ]);
    expect(snapshot.assets, hasLength(13));
    expect(snapshot.assets.first.symbol, 'USDT');
    expect(snapshot.dca.activePlans, 3);
    expect(snapshot.endpoint, '/api/mobile/wallet/wallet');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
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

  testWidgets('SC-135 renders wallet baseline in Wallet shell', (tester) async {
    await pumpWallet(tester);

    expect(find.byType(WalletPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Ví tài sản'), findsOneWidget);
    expect(find.text('\$57,664.00'), findsOneWidget);
    expect(find.text('Nạp'), findsOneWidget);
    expect(find.text('Mua định kỳ (DCA)'), findsOneWidget);
    expect(find.text('Danh sách'), findsOneWidget);
    expect(find.text('Tìm tài sản...'), findsOneWidget);
    expect(find.text('13 tài sản'), findsOneWidget);
    expect(find.text('USDT'), findsOneWidget);
  });

  testWidgets('SC-135 balance toggle, search, and filter update asset view', (
    tester,
  ) async {
    await pumpWallet(tester);

    await tester.tap(find.byKey(WalletPage.balanceToggleKey));
    await tester.pumpAndSettle();
    expect(find.text('••••••'), findsOneWidget);

    await tester.enterText(find.byKey(WalletPage.searchKey), 'btc');
    await tester.pumpAndSettle();
    expect(find.text('1 tài sản'), findsOneWidget);
    expect(find.text('BTC'), findsWidgets);

    await tester.enterText(find.byKey(WalletPage.searchKey), '');
    await tester.tap(find.byKey(WalletPage.filterKey));
    await tester.pumpAndSettle();
    expect(find.text('12 tài sản'), findsOneWidget);
  });

  testWidgets('SC-135 chart tab and wallet child placeholder navigation work', (
    tester,
  ) async {
    await pumpWallet(tester);

    await tester.tap(find.byKey(WalletPage.tabKey('chart')));
    await tester.pumpAndSettle();
    expect(find.text('Phân bổ'), findsOneWidget);
    expect(find.text('BTC'), findsWidgets);

    await tester.tap(find.byKey(WalletPage.actionKey('history')));
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử giao dịch'), findsOneWidget);
  });
}
