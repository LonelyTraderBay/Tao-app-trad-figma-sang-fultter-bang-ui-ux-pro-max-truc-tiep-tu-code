import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/activity_log_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/api_management_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/kyc_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/settings_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/pages/my_arena_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpProfile(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.profile),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-156 mock repository exposes profile BE draft', () {
    final snapshot = const MockProfileRepository().getProfile();

    expect(snapshot.endpoint, '/api/mobile/profile/profile');
    expect(snapshot.actionDraft, 'read-only + local navigation actions');
    expect(snapshot.user.id, 'USR001');
    expect(snapshot.user.referralCode, 'VITTA-A2B3C');
    expect(snapshot.user.vipLevel, 'VIP 1');
    expect(snapshot.vip.progress, .35);
    expect(snapshot.prediction.positions, 5);
    expect(snapshot.arena.pointsLabel, '2,220');
    expect(snapshot.productShortcuts.map((shortcut) => shortcut.id), [
      'wallet',
      'p2p',
      'earn',
      'launchpad',
      'bots',
      'copy',
      'support',
      'referral',
    ]);
    expect(
      snapshot.productShortcuts
          .map((shortcut) => shortcut.route)
          .any(
            (route) => route.startsWith('/admin') || route.startsWith('/dev'),
          ),
      isFalse,
    );
    expect(snapshot.sections.map((section) => section.id), [
      'account',
      'settings',
      'explore',
    ]);
    expect(
      snapshot.supportedStates,
      containsAll([
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-156 renders profile baseline shell', (tester) async {
    await pumpProfile(tester);

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_profile')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(find.text('T\u00E0i kho\u1EA3n'), findsOneWidget);
    expect(find.text('Nguy\u1EC5n V\u0103n A'), findsOneWidget);
    expect(find.text('nguyenvana@email.com'), findsOneWidget);
    expect(find.text('USR001'), findsOneWidget);
    expect(find.text('VITTA-A2B3C'), findsOneWidget);
    expect(find.text('VIP Progress'), findsOneWidget);
    expect(find.text('Prediction Portfolio'), findsOneWidget);
    expect(find.text('Open Arena'), findsOneWidget);
    expect(find.byKey(ProfilePage.productHubKey), findsOneWidget);
    expect(
      find.byKey(ProfilePage.productShortcutKey('wallet')),
      findsOneWidget,
    );
    expect(
      find.byKey(ProfilePage.productShortcutKey('support')),
      findsOneWidget,
    );
    expect(find.text('T\u00C0I KHO\u1EA2N'), findsOneWidget);
    expect(find.text('X\u00E1c minh danh t\u00EDnh (KYC)'), findsOneWidget);
  });

  testWidgets('SC-156 first viewport previews product hub above bottom nav', (
    tester,
  ) async {
    await pumpProfile(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ProfilePage',
      semanticLabel: 'SC-156 ProfilePage',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ProfilePage.productHubKey),
      minVisibleHeight: 24,
      targetLabel: 'Profile product hub',
      reason:
          'ProfilePage should preview product/support shortcuts above the '
          'bottom navigation on the 440x956 QA phone viewport.',
    );
  });

  testWidgets('SC-156 profile action edges route to safe placeholders', (
    tester,
  ) async {
    await pumpProfile(tester);

    await tester.tap(find.byKey(ProfilePage.copyReferralKey));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);

    await tester.tap(find.byKey(ProfilePage.editProfileKey));
    await tester.pumpAndSettle();
    expect(find.byType(EditProfilePage), findsOneWidget);
    expect(find.text('Ch\u1EC9nh s\u1EEDa h\u1ED3 s\u01A1'), findsOneWidget);

    await pumpProfile(tester);
    await tester.tap(find.byKey(ProfilePage.predictionCardKey));
    await tester.pumpAndSettle();
    expect(find.text('Prediction Portfolio'), findsOneWidget);

    await pumpProfile(tester);
    await tester.tap(find.byKey(ProfilePage.arenaCardKey));
    await tester.pumpAndSettle();
    expect(find.byType(MyArenaPage), findsOneWidget);
    expect(find.text('S\u00E2n ch\u01A1i c\u1EE7a t\u00F4i'), findsOneWidget);

    await pumpProfile(tester);
    await tester.ensureVisible(find.byKey(ProfilePage.menuKey('kyc')));
    await tester.tap(find.byKey(ProfilePage.menuKey('kyc')));
    await tester.pumpAndSettle();
    expect(find.byType(KYCPage), findsOneWidget);
    expect(find.text('X\u00E1c minh danh t\u00EDnh'), findsOneWidget);

    await pumpProfile(tester);
    await tester.ensureVisible(find.byKey(ProfilePage.menuKey('settings')));
    await tester.tap(find.byKey(ProfilePage.menuKey('settings')));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.text('C\u00E0i \u0111\u1EB7t'), findsOneWidget);

    await pumpProfile(tester);
    await tester.ensureVisible(find.byKey(ProfilePage.menuKey('api')));
    await tester.tap(find.byKey(ProfilePage.menuKey('api')));
    await tester.pumpAndSettle();
    expect(find.byType(ApiManagementPage), findsOneWidget);
    expect(find.text('Qu\u1EA3n l\u00FD API'), findsOneWidget);

    await pumpProfile(tester);
    await tester.ensureVisible(
      find.text('Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng'),
    );
    await tester.tap(find.text('Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng'));
    await tester.pumpAndSettle();
    expect(find.byType(ActivityLogPage), findsOneWidget);
  });
}
