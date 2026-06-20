import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/bot_emergency_stop_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/bot_risk_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskDashboard(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotRiskDashboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-120 mock repository exposes bot risk dashboard BE draft', () {
    final snapshot = const MockTradeRepository().getBotRiskDashboard();

    expect(snapshot.riskScore, 68);
    expect(snapshot.riskLabel, 'Medium Risk');
    expect(snapshot.drawdownPoints, hasLength(7));
    expect(snapshot.exposures, hasLength(3));
    expect(snapshot.varHistory, hasLength(7));
    expect(snapshot.safetyControls, hasLength(4));
    expect(snapshot.emergencyPath, '/trade/bots/emergency-stop');
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-risk-dashboard');
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

  testWidgets('SC-120 renders risk dashboard baseline in Trade shell', (
    tester,
  ) async {
    await pumpRiskDashboard(tester);

    expect(find.byType(BotRiskDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Risk Dashboard'), findsOneWidget);
    expect(find.text('Portfolio Risk Score'), findsOneWidget);
    expect(find.text('68/100'), findsOneWidget);
    expect(find.text('Medium Risk'), findsOneWidget);
    expect(find.text('Critical Metrics'), findsOneWidget);
    expect(find.text('Drawdown Trend (24h)'), findsOneWidget);
  });

  testWidgets('SC-120 first viewport reaches critical metrics', (tester) async {
    await pumpRiskDashboard(tester);

    expectFirstViewportVisible(
      tester,
      find.text('Drawdown'),
      targetLabel: 'the first critical risk metric',
    );
  });

  testWidgets('SC-120 emergency actions navigate to SC-121 edge', (
    tester,
  ) async {
    await pumpRiskDashboard(tester);

    await tester.tap(find.byKey(BotRiskDashboardPage.emergencyHeaderKey));
    await tester.pumpAndSettle();

    expect(find.byType(BotEmergencyStopPage), findsOneWidget);
    expect(find.text('Emergency Stop'), findsOneWidget);
  });
}
