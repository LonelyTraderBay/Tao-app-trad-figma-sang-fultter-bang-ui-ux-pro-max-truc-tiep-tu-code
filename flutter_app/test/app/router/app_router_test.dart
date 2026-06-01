import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
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
}
