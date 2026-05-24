import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/p2p_2fa_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/p2p_login_history_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/p2p_security_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpSecurityCenter(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pSecurityCenter,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-253 mock repository exposes security center BE draft', () {
    final snapshot = const MockP2PRepository().getSecurityCenter();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-security-center');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
    );
    expect(snapshot.score, 90);
    expect(snapshot.maxScore, 100);
    expect(snapshot.features, hasLength(5));
    expect(snapshot.quickActions, hasLength(4));
    expect(snapshot.recentEvents, hasLength(3));
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.settingsRoute, AppRoutePaths.p2pSettings);
    expect(snapshot.loginHistoryRoute, AppRoutePaths.p2pSecurityLoginHistory);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-253 renders security center baseline', (tester) async {
    await pumpSecurityCenter(tester);

    expect(find.byType(P2PSecurityCenterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Security Center'), findsOneWidget);
    expect(find.text('Bảo mật · P2P'), findsOneWidget);
    expect(find.byKey(P2PSecurityCenterPage.scoreKey), findsOneWidget);
    expect(find.text('Security Score'), findsOneWidget);
    expect(find.text('90'), findsOneWidget);
    expect(find.text('Xuất sắc'), findsOneWidget);
    expect(find.byKey(P2PSecurityCenterPage.featuresKey), findsOneWidget);
    expect(find.text('2FA cho P2P'), findsOneWidget);
    expect(find.text('Anti-Phishing Code'), findsOneWidget);
    expect(find.text('Trusted Devices'), findsOneWidget);
    expect(find.text('Whitelist Mode'), findsOneWidget);
    expect(find.text('Biometric Lock'), findsOneWidget);
    expect(find.byKey(P2PSecurityCenterPage.quickActionsKey), findsOneWidget);
    expect(find.text('Đổi mật khẩu'), findsOneWidget);
    expect(find.text('Hoạt động đáng ngờ'), findsOneWidget);
    expect(find.byKey(P2PSecurityCenterPage.eventsKey), findsOneWidget);
    expect(find.text('Đăng nhập thành công'), findsOneWidget);
    expect(find.text('Thiết bị mới'), findsOneWidget);
    expect(find.text('Đăng nhập thất bại'), findsOneWidget);
  });

  testWidgets('SC-253 feature row opens a security placeholder edge', (
    tester,
  ) async {
    await pumpSecurityCenter(tester);

    await tester.tap(find.byKey(P2PSecurityCenterPage.featureKey('2fa')));
    await tester.pumpAndSettle();

    expect(find.byType(P2P2FASettingsPage), findsOneWidget);
  });

  testWidgets('SC-253 view all opens login history edge', (tester) async {
    await pumpSecurityCenter(tester);

    await tester.ensureVisible(find.byKey(P2PSecurityCenterPage.viewAllKey));
    await tester.tap(find.byKey(P2PSecurityCenterPage.viewAllKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PLoginHistoryPage), findsOneWidget);
  });

  testWidgets('SC-253 back returns to P2P hub', (tester) async {
    await pumpSecurityCenter(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('P2P'), findsWidgets);
  });
}
