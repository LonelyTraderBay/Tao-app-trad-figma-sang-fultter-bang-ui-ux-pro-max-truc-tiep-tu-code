import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_risk_disclosure_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_suitability_assessment_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskDisclosure(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotRiskDisclosure,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-118 mock repository exposes bot risk BE draft', () async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotRiskDisclosure();

    expect(snapshot.highRiskTitle, 'HIGH RISK WARNING');
    expect(snapshot.categories, hasLength(6));
    expect(snapshot.categories.first.title, 'Market Volatility Risk');
    expect(snapshot.additionalWarnings, hasLength(5));
    expect(snapshot.regulatoryTitle, 'MiFID II / ESMA / SEC Compliance');
    expect(snapshot.disabledCta, 'Acknowledge Risks to Continue');
    expect(snapshot.enabledCta, 'I Understand the Risks - Continue');
    expect(snapshot.nextPath, AppRoutePaths.tradeBotSuitabilityAssessment);
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-risk-disclosure');
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

  testWidgets('SC-118 renders risk disclosure baseline in Trade shell', (
    tester,
  ) async {
    await pumpRiskDisclosure(tester);

    expect(find.byType(BotRiskDisclosurePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Risk Disclosure'), findsOneWidget);
    expect(find.text('HIGH RISK WARNING'), findsOneWidget);
    expect(find.text('Past Performance Disclaimer'), findsOneWidget);
    expect(find.text('Risk Categories'), findsOneWidget);
    expect(find.text('Market Volatility Risk'), findsOneWidget);
    expect(find.text('Acknowledge Risks to Continue'), findsOneWidget);
  });

  testWidgets('SC-118 first viewport reaches first risk category', (
    tester,
  ) async {
    await pumpRiskDisclosure(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-118 BotRiskDisclosurePage',
      semanticLabel: 'Công bố rủi ro khi sử dụng bot giao dịch',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(BotRiskDisclosurePage.categoryKey('market')),
      targetLabel: 'the first bot risk category card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-118 acknowledgment enables canonical suitability route', (
    tester,
  ) async {
    await pumpRiskDisclosure(tester);

    await tester.ensureVisible(
      find.byKey(BotRiskDisclosurePage.acknowledgmentKey),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(BotRiskDisclosurePage.ctaKey));
    await tester.pumpAndSettle();
    expect(find.byType(BotRiskDisclosurePage), findsOneWidget);

    await tester.tap(find.byKey(BotRiskDisclosurePage.acknowledgmentKey));
    await tester.pumpAndSettle();
    expect(find.text('I Understand the Risks - Continue'), findsOneWidget);

    await tester.tap(find.byKey(BotRiskDisclosurePage.ctaKey));
    await tester.pumpAndSettle();
    expect(find.byType(BotSuitabilityAssessmentPage), findsOneWidget);
    expect(find.text('Suitability Assessment'), findsOneWidget);
  });
}
