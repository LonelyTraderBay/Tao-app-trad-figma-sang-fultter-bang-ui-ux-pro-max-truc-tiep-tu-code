import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/bot_terms_of_service_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTerms(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotTermsOfService,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-117 mock repository exposes bot terms BE draft', () {
    final snapshot = const MockTradeRepository().getBotTermsOfService();

    expect(snapshot.infoTitle, 'Legal Agreement Required');
    expect(snapshot.title, 'Trading Bots Terms of Service');
    expect(snapshot.sections.first.title, '1. Acceptance of Terms');
    expect(snapshot.sections[1].warningTitle, 'CRITICAL WARNING:');
    expect(snapshot.disabledCta, 'Read Terms to Continue');
    expect(snapshot.enabledCta, 'Accept & Continue');
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-terms-of-service');
    expect(snapshot.actionDraft, contains('POST /bots/create'));
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-117 renders bot terms baseline in Trade shell', (
    tester,
  ) async {
    await pumpTerms(tester);

    expect(find.byType(BotTermsOfServicePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Trading Bots Terms'), findsOneWidget);
    expect(find.text('Legal Agreement Required'), findsOneWidget);
    expect(find.text('Trading Bots Terms of Service'), findsOneWidget);
    expect(find.text('1. Acceptance of Terms'), findsOneWidget);
    expect(find.text('2. No Profit Guarantee'), findsOneWidget);
    expect(find.text('Accept Terms'), findsOneWidget);
    expect(find.text('Read Terms to Continue'), findsOneWidget);
  });

  testWidgets('SC-117 first viewport previews agreement card', (tester) async {
    await pumpTerms(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'BotTermsOfServicePage',
      semanticLabel: 'SC-117 BotTermsOfServicePage',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(BotTermsOfServicePage.agreementKey),
      minVisibleHeight: 24,
      targetLabel: 'terms agreement card',
      reason:
          'Bot terms must preview the agreement step above bottom navigation '
          'while still requiring the inner terms scroll to be read before '
          'enabling the CTA.',
    );
  });

  testWidgets('SC-117 agreement stays disabled until terms are read', (
    tester,
  ) async {
    await pumpTerms(tester);

    await tester.ensureVisible(find.byKey(BotTermsOfServicePage.agreementKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(BotTermsOfServicePage.agreementKey));
    await tester.pumpAndSettle();

    expect(find.text('Read Terms to Continue'), findsOneWidget);
    expect(find.text('Accept & Continue'), findsNothing);
  });
}
