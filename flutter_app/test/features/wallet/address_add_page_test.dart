import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/address_add_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpAddressAdd(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletAddressBookAdd,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-143 mock repository exposes add address BE draft', () {
    final snapshot = const MockWalletRepository().getAddressAdd();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-address-book-add');
    expect(
      snapshot.actionDraft,
      'POST /wallet/addresses; POST /kyc/submission-step',
    );
    expect(
      snapshot.auditTrailNote,
      'High-risk action: preview + confirm + audit trail required.',
    );
    expect(snapshot.networks, hasLength(6));
    expect(snapshot.networks[1].label, 'ETH (ERC20)');
    expect(snapshot.assets, ['BTC', 'ETH', 'USDT', 'BNB', 'SOL', 'MATIC']);
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

  testWidgets('SC-143 renders address add form in Wallet shell', (
    tester,
  ) async {
    await pumpAddressAdd(tester);

    expect(find.byType(AddressAddPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Thêm địa chỉ mới'), findsOneWidget);
    expect(find.text('Sổ địa chỉ · Wallet'), findsOneWidget);
    expect(
      find.textContaining('Tên địa chỉ', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Mạng lưới', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('ETH (ERC20)'), findsOneWidget);
    expect(find.text('Tài sản', findRichText: true), findsOneWidget);
    expect(
      find.textContaining('Địa chỉ ví', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Memo / Tag', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Thêm vào Whitelist'), findsOneWidget);
    expect(find.text('Lưu địa chỉ'), findsOneWidget);
    expect(find.byKey(AddressAddPage.saveKey).hitTestable(), findsNothing);
  });

  testWidgets('SC-143 form controls enable safe preview confirmation', (
    tester,
  ) async {
    await pumpAddressAdd(tester);

    await tester.tap(find.byKey(AddressAddPage.networkKey('trc20')));
    await tester.tap(find.byKey(AddressAddPage.assetKey('USDT')));
    await tester.enterText(
      find.byKey(AddressAddPage.labelFieldKey),
      'Ví lạnh cá nhân',
    );
    await tester.enterText(
      find.byKey(AddressAddPage.addressFieldKey),
      'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
    );
    await tester.ensureVisible(find.byKey(AddressAddPage.whitelistKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddressAddPage.whitelistKey));
    await tester.ensureVisible(find.byKey(AddressAddPage.agreementKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddressAddPage.agreementKey));
    await tester.pumpAndSettle();

    expect(find.byKey(AddressAddPage.networkKey('trc20')), findsOneWidget);
    expect(find.byKey(AddressAddPage.assetKey('USDT')), findsOneWidget);
    expect(find.text('Xem trước'), findsOneWidget);

    await tester.ensureVisible(find.byKey(AddressAddPage.saveKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddressAddPage.saveKey));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận lưu địa chỉ'), findsOneWidget);
    expect(
      find.text('High-risk action: preview + confirm + audit trail required.'),
      findsOneWidget,
    );
    expect(find.text('Xác nhận lưu'), findsOneWidget);
  });
}
