import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  testWidgets('VitTradeApp defaults to the native device shell', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(VitTradeApp(routerConfig: createAppRouter()));
    await tester.pumpAndSettle();

    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.text('VitTrade'), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_active_home')), findsOneWidget);
  });

  testWidgets('VitTradeApp can render the visual QA phone shell', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      VitTradeApp(
        routerConfig: createAppRouter(
          shellRenderMode: ShellRenderMode.visualQa,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VitPhoneFrame), findsOneWidget);
    expect(find.byKey(VitPhoneFrame.frameKey), findsOneWidget);
    expect(find.byKey(VitPhoneFrame.dynamicIslandKey), findsOneWidget);
    expect(find.byKey(VitPhoneFrame.homeIndicatorKey), findsOneWidget);
    expect(find.byType(VitStatusBar), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.text('VitTrade'), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_active_home')), findsOneWidget);
    expect(
      tester.getSize(find.byKey(VitPhoneFrame.frameKey)),
      const Size(440, 956),
    );
  });

  testWidgets('VitTradeApp clamps scroll physics globally', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(VitTradeApp(routerConfig: createAppRouter()));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final scrollBehavior = materialApp.scrollBehavior;

    expect(scrollBehavior, isNotNull);
    expect(
      scrollBehavior!.getScrollPhysics(
        tester.element(find.byType(MaterialApp)),
      ),
      isA<ClampingScrollPhysics>(),
    );
  });
}
