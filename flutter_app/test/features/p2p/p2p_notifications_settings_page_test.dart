import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/p2p_notifications_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/p2p_settings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpNotifications(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pSettingsNotifications,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-278 mock repository exposes notifications BE draft', () {
    final snapshot = const MockP2PRepository().getNotificationSettings();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-settings-notifications');
    expect(snapshot.actionDraft, contains('PATCH /user/settings'));
    expect(snapshot.title, 'P2P Notifications');
    expect(snapshot.subtitle, 'Thông báo · P2P');
    expect(snapshot.heroTitle, 'Notification Settings');
    expect(snapshot.settings, hasLength(5));
    expect(snapshot.settings.first.id, 'order_updates');
    expect(snapshot.settings.first.channels['push'], isTrue);
    expect(snapshot.settings.first.channels['sms'], isFalse);
    expect(snapshot.parentRoute, AppRoutePaths.p2pSettings);
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

  testWidgets('SC-278 renders notification settings baseline', (tester) async {
    await pumpNotifications(tester);

    expect(find.byType(P2PNotificationsSettingsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('P2P Notifications'), findsOneWidget);
    expect(find.text('Thông báo · P2P'), findsOneWidget);
    expect(find.byKey(P2PNotificationsSettingsPage.heroKey), findsOneWidget);
    expect(find.text('Notification Settings'), findsOneWidget);
    expect(find.text('Order Updates'), findsOneWidget);
    expect(find.text('Payment Received'), findsOneWidget);
    expect(find.text('Release Reminder'), findsOneWidget);
    expect(find.text('Security Alerts'), findsOneWidget);
    expect(find.text('KYC Updates'), findsOneWidget);
    expect(
      find.byKey(
        P2PNotificationsSettingsPage.channelKey('order_updates', 'push'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-278 toggles a notification channel', (tester) async {
    await pumpNotifications(tester);

    final smsKey = P2PNotificationsSettingsPage.channelKey(
      'order_updates',
      'sms',
    );
    final before = tester.widget<Material>(find.byKey(smsKey));
    expect(before.color, isNot(equals(AppColors.buy10)));

    await tester.tap(find.byKey(smsKey));
    await tester.pumpAndSettle();

    final after = tester.widget<Material>(find.byKey(smsKey));
    expect(after.color, AppColors.buy10);
  });

  testWidgets('SC-278 header back returns to settings parent', (tester) async {
    await pumpNotifications(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(P2PNotificationsSettingsPage), findsNothing);
    expect(find.byType(P2PSettingsPage), findsOneWidget);
  });
}
