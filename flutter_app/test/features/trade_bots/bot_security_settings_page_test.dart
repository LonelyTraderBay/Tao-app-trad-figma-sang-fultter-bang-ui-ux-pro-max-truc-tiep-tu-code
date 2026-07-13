import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_core/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/bot_security_settings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSecuritySettings(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotSecuritySettings,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-122 mock repository exposes bot security settings BE draft', () {
    final repo = const MockTradeRepository();
    final snapshot = repo.getBotSecuritySettings();
    final result = repo.patchBotSecuritySettings(
      const TradeBotSecuritySettingsDraft(twoFaEnabled: false),
    );

    expect(snapshot.twoFaEnabled, isTrue);
    expect(snapshot.apiKeys, hasLength(2));
    expect(snapshot.ipWhitelist, hasLength(2));
    expect(snapshot.recentActivity, hasLength(4));
    expect(snapshot.securityTips, hasLength(5));
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-security-settings');
    expect(snapshot.actionDraft, contains('PATCH /user/settings'));
    expect(result.status, 'saved');
    expect(result.twoFaEnabled, isFalse);
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-122 renders security settings baseline in Trade shell', (
    tester,
  ) async {
    await pumpSecuritySettings(tester);

    expect(find.byType(BotSecuritySettingsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Security Settings'), findsOneWidget);
    expect(find.text('Two-Factor Authentication'), findsOneWidget);
    expect(find.text('2FA for Bot Actions'), findsOneWidget);
    expect(find.text('API Keys'), findsOneWidget);
    expect(find.text('Trading Bot Key #1'), findsOneWidget);
    expect(find.text('Create New API Key'), findsOneWidget);
    expect(find.text('IP Whitelist'), findsOneWidget);
  });

  testWidgets('SC-122 first viewport reaches API key controls', (tester) async {
    await pumpSecuritySettings(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'BotSecuritySettingsPage',
      semanticLabel: 'SC-122 BotSecuritySettingsPage',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Create New API Key'),
      minVisibleHeight: 18,
      targetLabel: 'API key create action',
      reason:
          'Bot security settings must expose the API key controls above bottom '
          'navigation after the 2FA review block.',
    );
  });

  testWidgets('SC-122 opens API key creation sheet', (tester) async {
    await pumpSecuritySettings(tester);

    await tester.tap(find.byKey(BotSecuritySettingsPage.createApiKeyKey));
    await tester.pumpAndSettle();

    expect(find.text('Create API Key'), findsOneWidget);
    expect(find.text('Generate API Key'), findsOneWidget);
  });

  testWidgets('SC-122 opens IP whitelist sheet', (tester) async {
    await pumpSecuritySettings(tester);

    await tester.ensureVisible(find.byKey(BotSecuritySettingsPage.addIpKey));
    await tester.tap(find.byKey(BotSecuritySettingsPage.addIpKey));
    await tester.pumpAndSettle();

    expect(find.text('Add IP to Whitelist'), findsOneWidget);
    expect(find.text('IP Address'), findsOneWidget);
  });
}
