import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  testWidgets('/home opens inside the native shell with Home active', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('VitTrade'), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_home')), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_active_home')), findsOneWidget);
  });

  testWidgets('bottom nav route taps update the active destination', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('vit_bottom_nav_markets')));
    await tester.pumpAndSettle();

    expect(find.text('Th\u1ECB tr\u01B0\u1EDDng'), findsWidgets);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
  });

  testWidgets('shell shows notification badge on non-Home routes', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.trade),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('vit_bottom_nav_active_trade')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('vit_bottom_nav_home')),
        matching: find.text('7'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('representative route namespaces keep intentional active tabs', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final cases = <String, VitBottomNavDestination>{
      AppRoutePaths.home: VitBottomNavDestination.home,
      AppRoutePaths.markets: VitBottomNavDestination.markets,
      AppRoutePaths.pairDetail('btcusdt'): VitBottomNavDestination.markets,
      AppRoutePaths.tradePair('btcusdt'): VitBottomNavDestination.trade,
      AppRoutePaths.wallet: VitBottomNavDestination.wallet,
      AppRoutePaths.profile: VitBottomNavDestination.profile,
      AppRoutePaths.settingsSecurity: VitBottomNavDestination.profile,
      AppRoutePaths.p2p: VitBottomNavDestination.trade,
      AppRoutePaths.earnStaking: VitBottomNavDestination.trade,
      AppRoutePaths.arena: VitBottomNavDestination.trade,
      AppRoutePaths.launchpad: VitBottomNavDestination.trade,
      AppRoutePaths.support: VitBottomNavDestination.home,
      AppRoutePaths.search: VitBottomNavDestination.home,
      AppRoutePaths.notifications: VitBottomNavDestination.home,
      AppRoutePaths.news: VitBottomNavDestination.home,
    };

    for (final entry in cases.entries) {
      await tester.pumpWidget(
        ProviderScope(
          child: VitTradeApp(
            routerConfig: createAppRouter(initialLocation: entry.key),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(Key('vit_bottom_nav_active_${entry.value.name}')),
        findsOneWidget,
        reason: entry.key,
      );
    }
  });
}
