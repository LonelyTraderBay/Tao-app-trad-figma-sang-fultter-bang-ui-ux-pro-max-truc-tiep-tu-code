import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/transaction_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletTransaction('tx001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-141 mock repository exposes transaction detail BE draft', () {
    final snapshot = const MockWalletRepository().getTransactionDetail('tx001');

    expect(snapshot.transaction?.id, 'tx001');
    expect(snapshot.transaction?.asset, 'USDT');
    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-transaction-tx001');
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

  testWidgets('SC-141 renders transaction detail baseline in Wallet shell', (
    tester,
  ) async {
    await pumpDetail(tester);

    expect(find.byType(TransactionDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Chi tiết giao dịch'), findsOneWidget);
    expect(find.text('Lịch sử · Wallet'), findsOneWidget);
    expect(find.text('Nạp tiền'), findsOneWidget);
    expect(find.text('+5,000.00 USDT'), findsOneWidget);
    expect(find.text('Hoàn thành'), findsWidgets);
    expect(find.text('Tiến trình'), findsOneWidget);
    expect(find.text('Mã giao dịch (TxID)'), findsOneWidget);
    expect(find.text('TRC20'), findsOneWidget);
    expect(find.text('Xem trên Explorer'), findsOneWidget);
  });

  testWidgets('SC-141 support action navigates to placeholder safely', (
    tester,
  ) async {
    await pumpDetail(tester);

    await tester.ensureVisible(find.byKey(TransactionDetailPage.supportKey));
    await tester.tap(find.byKey(TransactionDetailPage.supportKey));
    await tester.pumpAndSettle();

    expect(find.text('Support'), findsOneWidget);
  });
}
