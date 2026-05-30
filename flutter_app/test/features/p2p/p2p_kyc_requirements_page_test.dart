import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/p2p_identity_verification_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/p2p_kyc_requirements_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PKycRequirements(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pKycRequirements,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-247 mock repository exposes P2P KYC requirements BE draft', () {
    final snapshot = const MockP2PRepository().getKycRequirements();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-kyc-requirements');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
    );
    expect(snapshot.currentTier, 1);
    expect(snapshot.pendingTier, isNull);
    expect(snapshot.tiers, hasLength(3));
    expect(snapshot.tiers.first.status, P2PKycTierStatus.current);
    expect(snapshot.tiers[1].status, P2PKycTierStatus.available);
    expect(snapshot.verifyRouteFor(2), '/p2p/kyc/verify?tier=2');
    expect(snapshot.supportRoute, '/support');
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
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

  testWidgets('SC-247 renders P2P KYC requirements baseline in P2P shell', (
    tester,
  ) async {
    await pumpP2PKycRequirements(tester);

    expect(find.byType(P2PKycRequirementsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('P2P KYC Requirements'), findsOneWidget);
    expect(find.text('KYC · P2P'), findsOneWidget);
    expect(find.byKey(P2PKycRequirementsPage.heroKey), findsOneWidget);
    expect(find.text('P2P KYC Verification'), findsOneWidget);
    expect(find.byKey(P2PKycRequirementsPage.noticeKey), findsOneWidget);
    expect(find.text('Lưu ý quan trọng'), findsOneWidget);

    expect(find.byKey(P2PKycRequirementsPage.tierKey(1)), findsOneWidget);
    expect(find.text('Tier 1'), findsOneWidget);
    expect(find.text('Cơ bản'), findsOneWidget);
    expect(find.text('Đang dùng'), findsOneWidget);
    expect(find.text('CMND/CCCD/Passport'), findsOneWidget);
    expect(find.text('50,000,000 VND'), findsNWidgets(2));

    await tester.ensureVisible(find.byKey(P2PKycRequirementsPage.tierKey(2)));
    expect(find.text('Tier 2'), findsOneWidget);
    expect(find.text('Trung cấp'), findsOneWidget);
    expect(find.text('Proof of Address'), findsOneWidget);
    expect(find.byKey(P2PKycRequirementsPage.upgradeKey(2)), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PKycRequirementsPage.supportKey));
    expect(find.text('Tier 3'), findsOneWidget);
    expect(find.text('Nâng cao'), findsOneWidget);
    expect(find.text('Cần hỗ trợ?'), findsOneWidget);
    expect(find.text('Liên hệ Support'), findsOneWidget);
  });

  testWidgets('SC-247 wires upgrade and support navigation edges', (
    tester,
  ) async {
    await pumpP2PKycRequirements(tester);

    await tester.ensureVisible(
      find.byKey(P2PKycRequirementsPage.upgradeKey(2)),
    );
    await tester.tap(find.byKey(P2PKycRequirementsPage.upgradeKey(2)));
    await tester.pumpAndSettle();
    expect(find.byType(P2PIdentityVerificationPage), findsOneWidget);
    expect(find.text('Identity Verification'), findsOneWidget);

    await pumpP2PKycRequirements(tester);

    await tester.ensureVisible(find.byKey(P2PKycRequirementsPage.supportKey));
    await tester.tap(find.text('Liên hệ Support'));
    await tester.pumpAndSettle();
    expect(find.text('Liên hệ · Hỗ trợ'), findsOneWidget);
  });
}
