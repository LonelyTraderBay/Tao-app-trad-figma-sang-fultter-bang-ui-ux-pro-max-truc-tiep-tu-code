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
    expect(find.text('Chuyển nội bộ'), findsOneWidget);
    expect(find.text('Chuyển tiền · Wallet'), findsOneWidget);
    expect(find.text('Ví Spot'), findsOneWidget);
    expect(find.text('Số dư: \$54,276.79'), findsOneWidget);
    expect(find.text('Ví Funding'), findsOneWidget);
    expect(find.text('Số dư: \$8,450.20'), findsOneWidget);
    expect(find.text('USDT'), findsWidgets);
    expect(find.text('Khả dụng: 10,200.00 USDT'), findsOneWidget);
    expect(find.text('0.00'), findsOneWidget);
    expect(find.text('Tối đa'), findsOneWidget);
    expect(find.text('Xác nhận chuyển'), findsOneWidget);
    expect(find.text('Lịch sử chuyển gần đây'), findsOneWidget);
    expect(find.text('Spot → Funding'), findsOneWidget);
  });

  testWidgets('SC-146 transfer controls support preview confirmation', (
    tester,
  ) async {
    await pumpTransfer(tester);

    await tester.tap(find.byKey(TransferPage.swapKey));
    await tester.pumpAndSettle();
    expect(find.text('Ví Funding'), findsWidgets);
    expect(find.text('Số dư: \$8,450.20'), findsWidgets);

    await tester.tap(find.byKey(TransferPage.maxKey));
    await tester.pumpAndSettle();
    expect(find.text('10,200.00'), findsOneWidget);

    await tester.tap(find.byKey(TransferPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận chuyển nội bộ'), findsOneWidget);
    expect(find.text('Miễn phí'), findsOneWidget);

    await tester.tap(find.byKey(TransferPage.confirmKey));
    await tester.pumpAndSettle();
    expect(find.text('Chuyển thành công!'), findsOneWidget);
  });
}
