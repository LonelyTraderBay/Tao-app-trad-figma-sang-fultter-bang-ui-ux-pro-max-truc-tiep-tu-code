import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/launchpad_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/launchpad_swap_aggregator_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpSwapAggregator(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadSwapAggregator,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-314 mock repository exposes launchpad swap aggregator BE draft', () {
    final snapshot = const MockLaunchpadRepository().getSwapAggregator();

    expect(
      snapshot.endpoint,
      '/api/mobile/launchpad/launchpad-swap-aggregator',
    );
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Swap Aggregator');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.tabs, ['So sanh', 'Lich su', 'Cai dat']);
    expect(snapshot.fromToken, 'USDT');
    expect(snapshot.toToken, 'ARB');
    expect(snapshot.dexQuotes, hasLength(5));
    expect(snapshot.dexQuotes.first.recommended, isTrue);
    expect(snapshot.history, hasLength(3));
    expect(snapshot.contractNotes, contains('DEX quotes'));
    expect(
      snapshot.supportedStates,
      containsAll([
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      ]),
    );
  });

  testWidgets('SC-314 renders swap aggregator compare baseline', (
    tester,
  ) async {
    await pumpSwapAggregator(tester);

    expect(find.byType(LaunchpadSwapAggregatorPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(LaunchpadSwapAggregatorPage.tabsKey), findsOneWidget);
    expect(find.byKey(LaunchpadSwapAggregatorPage.inputKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadSwapAggregatorPage.bestRouteKey),
      findsOneWidget,
    );
    expect(find.byKey(LaunchpadSwapAggregatorPage.dexListKey), findsOneWidget);
    expect(find.byKey(LaunchpadSwapAggregatorPage.ctaKey), findsOneWidget);
    expect(find.text('Swap Aggregator'), findsOneWidget);
    expect(find.text('Swap from'), findsOneWidget);
    expect(find.text('USDT'), findsWidgets);
    expect(find.text('ARB'), findsWidgets);
    expect(find.text('Best rate: Uniswap V3'), findsOneWidget);
    expect(find.text('Uniswap V3'), findsWidgets);
    expect(find.text('PancakeSwap'), findsOneWidget);
  });

  testWidgets('SC-314 expands route details and flips token direction', (
    tester,
  ) async {
    await pumpSwapAggregator(tester);

    await tester.tap(
      find.byKey(LaunchpadSwapAggregatorPage.dexToggleKey('uniswap')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Route'), findsOneWidget);
    expect(find.text('WETH'), findsOneWidget);
    expect(find.text('Security: High'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadSwapAggregatorPage.flipKey));
    await tester.pumpAndSettle();
    expect(find.text('@2456.32 ARB'), findsOneWidget);
  });

  testWidgets('SC-314 switches history and settings tabs', (tester) async {
    await pumpSwapAggregator(tester);

    await tester.tap(find.text('Lich su'));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadSwapAggregatorPage.historyKey), findsOneWidget);
    expect(find.text('Giao dich gan day'), findsOneWidget);
    expect(find.text('USDT -> ARB'), findsOneWidget);

    await tester.tap(find.text('Cai dat'));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadSwapAggregatorPage.settingsKey), findsOneWidget);
    expect(find.text('Slippage Tolerance (%)'), findsOneWidget);

    await tester.tap(
      find.byKey(LaunchpadSwapAggregatorPage.slippageKey('1.0')),
    );
    await tester.pumpAndSettle();
    expect(find.text('1.0%'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadSwapAggregatorPage.autoRefreshKey));
    await tester.pumpAndSettle();
    final switchWidget = tester.widget<Switch>(
      find.byKey(LaunchpadSwapAggregatorPage.autoRefreshKey),
    );
    expect(switchWidget.value, isFalse);
  });

  testWidgets('SC-314 floating CTA records swap preview', (tester) async {
    await pumpSwapAggregator(tester);

    await tester.tap(find.byKey(LaunchpadSwapAggregatorPage.ctaKey));
    await tester.pumpAndSettle();

    expect(find.text('Swap 1000 USDT qua Uniswap V3'), findsOneWidget);
  });

  testWidgets('SC-314 header back returns to launchpad', (tester) async {
    await pumpSwapAggregator(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
