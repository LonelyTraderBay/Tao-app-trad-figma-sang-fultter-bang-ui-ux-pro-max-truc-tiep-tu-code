import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/provider/provider_comparison_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpProviderComparison(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyComparison,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-076 mock repository exposes provider comparison BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getProviderComparison();

    expect(snapshot.selectedCount, 3);
    expect(snapshot.maxProviders, 5);
    expect(snapshot.providers, isEmpty);
    expect(snapshot.metrics, hasLength(13));
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

  testWidgets('SC-076 renders comparison baseline in the Trade shell', (
    tester,
  ) async {
    await pumpProviderComparison(tester);

    expect(find.byType(ProviderComparisonPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('So sánh Providers'), findsOneWidget);
    expect(find.text('Đang so sánh 3/5 providers'), findsOneWidget);
    expect(find.text('+ Thêm provider'), findsOneWidget);
    expect(find.text('Metric'), findsOneWidget);
    expect(find.text('Performance'), findsOneWidget);
    expect(find.text('Total ROI'), findsOneWidget);
    expect(find.text('Risk'), findsOneWidget);
    expect(find.text('Execution'), findsOneWidget);
  });

  testWidgets('SC-076 add provider navigates back to copy trading', (
    tester,
  ) async {
    await pumpProviderComparison(tester);

    await tester.tap(find.byKey(ProviderComparisonPage.addProviderLinkKey));
    await tester.pumpAndSettle();

    expect(find.text('Copy Trading'), findsOneWidget);
  });
}
