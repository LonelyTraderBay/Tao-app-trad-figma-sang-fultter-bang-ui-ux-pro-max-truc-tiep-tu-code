import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/buy_crypto_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpBuyCrypto(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletBuyCrypto,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-145 mock repository exposes buy crypto BE draft', () {
    final snapshot = const MockWalletRepository().getBuyCrypto();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-buy-crypto');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.cryptoOptions.first.symbol, 'USDT');
    expect(snapshot.cryptoOptions.first.priceVnd, 25350);
    expect(snapshot.paymentMethods, hasLength(6));
    expect(snapshot.paymentMethods.first.name, 'Vietcombank');
    expect(snapshot.presetAmounts, [
      100000,
      500000,
      1000000,
      5000000,
      10000000,
    ]);
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

  testWidgets('SC-145 renders buy crypto baseline in Wallet shell', (
    tester,
  ) async {
    await pumpBuyCrypto(tester);

    expect(find.byType(BuyCryptoPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Mua Crypto'), findsOneWidget);
    expect(find.text('Giao dịch · Wallet'), findsOneWidget);
    expect(find.textContaining('Mua trực tiếp bằng VND'), findsOneWidget);
    expect(find.text('Số tiền (VND)'), findsOneWidget);
    expect(find.text('Số dư: 0 VND'), findsOneWidget);
    expect(find.text('Bạn sẽ nhận được'), findsOneWidget);
    expect(find.text('0 USDT'), findsOneWidget);
    expect(find.text('Phương thức thanh toán'), findsOneWidget);
    expect(find.text('Vietcombank'), findsOneWidget);
    expect(find.text('Ví MoMo'), findsOneWidget);
    expect(find.text('Nhập số tiền mua'), findsOneWidget);

    await tester.ensureVisible(find.text('Tỷ giá hiện tại'));
    await tester.pumpAndSettle();
    expect(find.text('1 USDT = 25.350 VND'), findsOneWidget);
    expect(find.text('Miễn phí'), findsOneWidget);
    expect(find.text('100,000,000 VND'), findsOneWidget);
  });

  testWidgets('SC-145 preset amount enables confirmation flow', (tester) async {
    await pumpBuyCrypto(tester);

    await tester.tap(find.byKey(BuyCryptoPage.presetKey(100000)));
    await tester.pumpAndSettle();

    expect(find.text('100K'), findsOneWidget);
    expect(find.text('Mua USDT'), findsOneWidget);

    await tester.ensureVisible(find.byKey(BuyCryptoPage.buyButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(BuyCryptoPage.buyButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận mua'), findsOneWidget);
    expect(find.text('Xác nhận thanh toán'), findsOneWidget);
  });
}
