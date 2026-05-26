import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/p2p_dispute_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/p2p_dispute_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

void main() {
  Future<void> pumpP2PDispute(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pDispute('p2p001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-221 mock repository exposes P2P dispute BE draft', () {
    final snapshot = const MockP2PRepository().getDisputeOpen('p2p001');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-dispute-p2p001');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
    );
    expect(snapshot.orderId, 'p2p001');
    expect(snapshot.reasons.length, 5);
    expect(snapshot.targetDisputeId, 'sample');
    expect(snapshot.contractNotes, contains('escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ]),
    );
  });

  testWidgets('SC-221 renders P2P dispute form baseline', (tester) async {
    await pumpP2PDispute(tester);

    expect(find.byType(P2PDisputePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Mở tranh chấp'), findsWidgets);
    expect(find.text('Tranh chấp · P2P'), findsOneWidget);
    expect(
      find.text('Order #. Vui lòng cung cấp bằng chứng đầy đủ.'),
      findsOneWidget,
    );
    expect(find.text('Lý do tranh chấp'), findsOneWidget);
    expect(find.text('Seller không release sau khi nhận tiền'), findsOneWidget);
    expect(find.text('Buyer không thanh toán'), findsOneWidget);
    expect(find.text('Mô tả chi tiết'), findsOneWidget);
    expect(find.text('Upload bằng chứng'), findsOneWidget);
    expect(find.text('Gửi tranh chấp'), findsOneWidget);
  });

  testWidgets('SC-221 enables submit after reason and description', (
    tester,
  ) async {
    await pumpP2PDispute(tester);

    await tester.tap(
      find.byKey(
        P2PDisputePage.reasonKey('Seller không release sau khi nhận tiền'),
      ),
    );
    await tester.enterText(
      find.byKey(P2PDisputePage.descriptionKey),
      'Đã chuyển tiền nhưng seller không xác nhận sau 30 phút.',
    );
    await tester.pumpAndSettle();

    final submit = tester.widget<VitCtaButton>(
      find.byKey(P2PDisputePage.submitKey),
    );
    expect(submit.onPressed, isNotNull);
  });

  testWidgets('SC-221 upload state marks evidence added', (tester) async {
    await pumpP2PDispute(tester);

    await tester.tap(find.byKey(P2PDisputePage.uploadKey));
    await tester.pumpAndSettle();

    expect(find.text('evidence_p2p001.png'), findsOneWidget);
    expect(find.text('Đã thêm bằng chứng'), findsOneWidget);
  });

  testWidgets('SC-221 submit opens dispute detail route', (tester) async {
    await pumpP2PDispute(tester);

    await tester.tap(
      find.byKey(
        P2PDisputePage.reasonKey('Seller không release sau khi nhận tiền'),
      ),
    );
    await tester.enterText(
      find.byKey(P2PDisputePage.descriptionKey),
      'Đã chuyển tiền nhưng seller không xác nhận sau 30 phút.',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PDisputePage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PDisputeDetailPage), findsOneWidget);
    expect(find.text('Chi tiết khiếu nại'), findsOneWidget);
  });
}
