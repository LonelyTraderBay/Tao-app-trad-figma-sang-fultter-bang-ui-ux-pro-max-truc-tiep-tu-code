import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';
import 'package:vit_trade_flutter/features/admin/presentation/ab_test_dashboard.dart';
import 'package:vit_trade_flutter/features/admin/presentation/admin_home.dart';
import 'package:vit_trade_flutter/features/admin/presentation/funnel_dashboard.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpAdminHome(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.admin),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-180 mock repository exposes admin BE draft', () {
    final snapshot = const AdminRepository().getHome();

    expect(snapshot.endpoint, '/api/mobile/admin/admin');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.adminMetrics.totalEvents, 0);
    expect(snapshot.adminMetrics.totalTests, 5);
    expect(snapshot.adminMetrics.totalFunnels, 5);
    expect(snapshot.quickStats.length, 3);
    expect(snapshot.liveStats.length, 3);
    expect(snapshot.dashboards.length, 3);
    expect(snapshot.analyticsEvents, isEmpty);
    expect(snapshot.funnels, isEmpty);
    expect(snapshot.experiments, isEmpty);
    expect(
      snapshot.supportedStates,
      containsAll([
        AdminScreenState.loading,
        AdminScreenState.empty,
        AdminScreenState.error,
        AdminScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-180 renders admin dashboard baseline', (tester) async {
    await pumpAdminHome(tester);

    expect(find.byType(AdminHome), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Admin Dashboard'), findsOneWidget);
    expect(find.text('DCA Analytics & Monitoring'), findsOneWidget);
    expect(find.text('Real-Time Metrics'), findsOneWidget);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('Tạm dừng'), findsOneWidget);
    expect(find.text('Live Event Stream'), findsOneWidget);
    expect(find.text('Không có sự kiện mới'), findsOneWidget);
    await tester.ensureVisible(find.text('Dashboards'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboards'), findsOneWidget);
    expect(find.text('Analytics Dashboard'), findsOneWidget);
    expect(find.text('A/B Test Dashboard'), findsOneWidget);
    expect(find.text('Funnel Dashboard'), findsOneWidget);
  });

  testWidgets('SC-180 supports live pause state', (tester) async {
    await pumpAdminHome(tester);

    await tester.tap(find.byKey(AdminHome.pauseKey));
    await tester.pumpAndSettle();

    expect(find.text('PAUSED'), findsOneWidget);
    expect(find.text('Tiếp tục'), findsOneWidget);
  });

  testWidgets('SC-180 navigation edges open safe placeholders', (tester) async {
    await pumpAdminHome(tester);

    await tester.tap(find.byKey(AdminHome.settingsKey));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHome), findsNothing);
    expect(find.text('Admin Settings'), findsOneWidget);

    await pumpAdminHome(tester);
    await tester.ensureVisible(find.byKey(AdminHome.dashboardKey('analytics')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdminHome.dashboardKey('analytics')));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHome), findsNothing);
    expect(find.text('Analytics Dashboard'), findsOneWidget);

    await pumpAdminHome(tester);
    await tester.ensureVisible(find.byKey(AdminHome.dashboardKey('abtests')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdminHome.dashboardKey('abtests')));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHome), findsNothing);
    expect(find.byType(ABTestDashboard), findsOneWidget);
    expect(find.text('A/B Test Dashboard'), findsOneWidget);

    await pumpAdminHome(tester);
    await tester.ensureVisible(find.byKey(AdminHome.dashboardKey('funnels')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdminHome.dashboardKey('funnels')));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHome), findsNothing);
    expect(find.byType(FunnelDashboard), findsOneWidget);
    expect(find.text('Funnel Analytics'), findsOneWidget);
  });
}
