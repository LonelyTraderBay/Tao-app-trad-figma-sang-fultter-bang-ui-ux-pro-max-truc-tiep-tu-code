import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn/presentation/savings_page.dart';
import 'package:vit_trade_flutter/features/earn/presentation/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpStakingEarn(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.earn),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> pumpStakingRoute(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnStaking,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-327 mock repository exposes Earn BE draft', () {
    final snapshot = const MockStakingEarnRepository().getStakingEarn();

    expect(snapshot.endpoint, '/api/mobile/earn/earn');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Staking & Earn');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.savingsRoute, '/earn/savings');
    expect(snapshot.products, hasLength(6));
    expect(snapshot.positions, hasLength(2));
    expect(snapshot.contractNotes, contains('earnProducts'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  test('SC-328 mock repository exposes staking route BE draft', () {
    final snapshot = const MockStakingEarnRepository().getStakingEarn(
      route: StakingEarnRoute.staking,
    );

    expect(snapshot.endpoint, '/api/mobile/earn/earn-staking');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.products, hasLength(6));
    expect(snapshot.supportedStates, contains(EarnScreenState.offline));
  });

  testWidgets('SC-327 renders staking earn product baseline', (tester) async {
    await pumpStakingEarn(tester);

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
    expect(find.text('San pham'), findsOneWidget);
    expect(find.text('Cua toi (2)'), findsOneWidget);
    expect(find.text('Bitcoin Fixed'), findsOneWidget);
    expect(find.text('Ethereum Flexible'), findsOneWidget);
    expect(find.text('5.8%'), findsOneWidget);
    expect(find.text('Rui ro: Thap'), findsWidgets);
  });

  testWidgets('SC-327 filters products and switches positions tab', (
    tester,
  ) async {
    await pumpStakingEarn(tester);

    await tester.tap(find.byKey(StakingEarnPage.filterKey('defi')));
    await tester.pump();
    expect(find.text('ETH-USDT LP Pool'), findsOneWidget);
    expect(find.text('Bitcoin Fixed'), findsNothing);

    await tester.tap(find.text('Cua toi (2)'));
    await tester.pump();
    expect(find.text('Tong thu nhap uoc tinh'), findsOneWidget);
    expect(find.text('0.05 BTC'), findsOneWidget);
  });

  testWidgets('SC-327 navigation edges open savings and home', (tester) async {
    await pumpStakingEarn(tester);

    await tester.tap(find.byKey(StakingEarnPage.savingsButtonKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(SavingsPage), findsOneWidget);

    await pumpStakingEarn(tester);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('SC-328 renders the staking route variant', (tester) async {
    await pumpStakingRoute(tester);

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
    expect(find.text('Bitcoin Fixed'), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
  });
}
