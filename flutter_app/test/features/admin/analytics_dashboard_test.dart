import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';
import 'package:vit_trade_flutter/features/admin/presentation/pages/admin_home.dart';
import 'package:vit_trade_flutter/features/admin/presentation/pages/analytics_dashboard.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpAnalytics(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.adminAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-181 mock repository exposes analytics BE draft', () {
    final snapshot = const MockAdminRepository().getAnalytics();

    expect(snapshot.endpoint, '/api/mobile/admin/admin-analytics');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.realtimeRefresh, isTrue);
    expect(snapshot.totalEvents, 0);
    expect(snapshot.uniqueUsers, 0);
    expect(snapshot.ranges.length, 3);
    expect(snapshot.dailyStats.length, 4);
    expect(snapshot.topEvents, isEmpty);
    expect(snapshot.recentEvents, isEmpty);
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

  testWidgets('SC-181 renders analytics dashboard baseline', (tester) async {
    await pumpAnalytics(tester);

    expect(find.byType(AnalyticsDashboard), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Analytics Dashboard'), findsOneWidget);
    expect(find.text('DCA Event Analytics'), findsOneWidget);
    expect(find.text('7 ngày'), findsOneWidget);
    expect(find.text('30 ngày'), findsOneWidget);
    expect(find.text('90 ngày'), findsOneWidget);
    expect(find.text('Tổng sự kiện'), findsOneWidget);
    expect(find.text('Người dùng'), findsOneWidget);
    expect(find.text('Khối lượng sự kiện'), findsOneWidget);
    expect(find.text('Top sự kiện'), findsOneWidget);
    expect(find.text('Phân bổ sự kiện'), findsOneWidget);
    expect(find.text('Sự kiện gần đây'), findsOneWidget);
    expect(find.text('No recent events'), findsOneWidget);
  });

  testWidgets('SC-181 supports range selection and back route', (tester) async {
    await pumpAnalytics(tester);

    await tester.tap(
      find.byKey(AnalyticsDashboard.rangeKey(AdminAnalyticsRange.thirtyDays)),
    );
    await tester.pumpAndSettle();
    expect(find.text('30 ngày'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHome), findsOneWidget);
  });
}
