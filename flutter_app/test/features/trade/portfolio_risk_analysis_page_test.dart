import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/portfolio_risk_analysis_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpPortfolioRisk(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyRiskAnalysis,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-078 mock repository exposes portfolio risk BE draft', () {
    final snapshot = const MockTradeRepository().getPortfolioRiskAnalysis();

    expect(snapshot.totalExposure, 8000);
    expect(snapshot.var95, -273);
    expect(snapshot.diversificationScore, 93);
    expect(snapshot.assetExposures, hasLength(6));
    expect(snapshot.riskAlerts, hasLength(3));
    expect(snapshot.tabs.map((tab) => tab.id), [
      'exposure',
      'correlation',
      'var',
      'scenarios',
    ]);
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

  testWidgets('SC-078 renders exposure risk analysis inside the Trade shell', (
    tester,
  ) async {
    await pumpPortfolioRisk(tester);

    expect(find.byType(PortfolioRiskAnalysisPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích rủi ro'), findsOneWidget);
    expect(find.text('Total Exposure'), findsOneWidget);
    expect(find.text(r'$8,000'), findsOneWidget);
    expect(find.text('Cảnh báo rủi ro'), findsOneWidget);
    expect(find.text('Asset Allocation'), findsOneWidget);
    expect(find.text('BTC'), findsOneWidget);
  });

  testWidgets('SC-078 tabs switch to stress scenarios locally', (tester) async {
    await pumpPortfolioRisk(tester);

    await tester.tap(find.byKey(PortfolioRiskAnalysisPage.tabKey('scenarios')));
    await tester.pumpAndSettle();

    expect(find.text('Market Crash (-30%)'), findsOneWidget);
    expect(find.text('BTC Halving Rally'), findsOneWidget);
  });
}
