import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';

/// GĐ4-F1 kill-switch: redirect toàn cục sang trang bảo trì / bắt buộc cập
/// nhật (root_routes.dart `createAppRouter(appConfig: ...)`), và thoát khỏi
/// gate khi cờ tắt.
void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    required AppConfig appConfig,
    String? initialLocation,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: initialLocation,
            appConfig: appConfig,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  final baseConfig = AppConfig(
    environment: AppEnvironment.development,
    apiBaseUrl: Uri.parse('https://api.vittrade.local'),
  );

  testWidgets('maintenanceMode redirects every route to the maintenance gate', (
    tester,
  ) async {
    await pumpApp(
      tester,
      appConfig: AppConfig(
        environment: baseConfig.environment,
        apiBaseUrl: baseConfig.apiBaseUrl,
        maintenanceMode: true,
      ),
      initialLocation: AppRoutePaths.home,
    );

    expect(find.text('Hệ thống đang bảo trì'), findsWidgets);
  });

  testWidgets(
    'forceUpdateRequired redirects every route to the force-update gate',
    (tester) async {
      await pumpApp(
        tester,
        appConfig: AppConfig(
          environment: baseConfig.environment,
          apiBaseUrl: baseConfig.apiBaseUrl,
          minSupportedBuild: 10,
          buildNumber: 1,
        ),
        initialLocation: AppRoutePaths.home,
      );

      expect(find.text('Cần cập nhật phiên bản mới'), findsWidgets);
    },
  );

  testWidgets(
    'no active flag sends a direct visit to the maintenance gate back home',
    (tester) async {
      await pumpApp(
        tester,
        appConfig: baseConfig,
        initialLocation: AppRoutePaths.maintenanceGate,
      );

      expect(find.text('Hệ thống đang bảo trì'), findsNothing);
      expect(find.byKey(const Key('vit_bottom_nav_home')), findsOneWidget);
    },
  );

  testWidgets(
    'no active flag sends a direct visit to the force-update gate back home',
    (tester) async {
      await pumpApp(
        tester,
        appConfig: baseConfig,
        initialLocation: AppRoutePaths.forceUpdateGate,
      );

      expect(find.text('Cần cập nhật phiên bản mới'), findsNothing);
      expect(find.byKey(const Key('vit_bottom_nav_home')), findsOneWidget);
    },
  );

  testWidgets('maintenanceMode does not redirect when already on the gate', (
    tester,
  ) async {
    await pumpApp(
      tester,
      appConfig: AppConfig(
        environment: baseConfig.environment,
        apiBaseUrl: baseConfig.apiBaseUrl,
        maintenanceMode: true,
      ),
      initialLocation: AppRoutePaths.maintenanceGate,
    );

    expect(find.text('Hệ thống đang bảo trì'), findsWidgets);
  });
}
