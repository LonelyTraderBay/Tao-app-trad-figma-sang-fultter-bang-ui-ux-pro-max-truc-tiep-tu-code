import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';

void main() {
  ProviderContainer container() {
    final value = ProviderContainer();
    addTearDown(value.dispose);
    return value;
  }

  test('AdminHomeController exposes dashboard lookup', () {
    final controller = container().read(adminHomeControllerProvider);

    expect(controller.state.hasDashboards, isTrue);
    expect(controller.dashboardById('analytics')?.route, '/admin/analytics');
    expect(controller.dashboardById('missing'), isNull);
  });

  test('AdminAnalyticsController resolves active range fallback', () {
    final controller = container().read(adminAnalyticsControllerProvider);

    expect(
      controller.activeRange(AdminAnalyticsRange.sevenDays).range,
      AdminAnalyticsRange.sevenDays,
    );
    expect(controller.state.snapshot.realtimeRefresh, isTrue);
  });

  test('AdminAbTestsController resolves tests by id', () {
    final controller = container().read(adminAbTestsControllerProvider);
    final test = controller.state.snapshot.tests.first;

    expect(controller.testById(test.id), same(test));
    expect(controller.testById('missing'), isNull);
  });

  test('AdminFunnelsController resolves selected funnel fallback', () {
    final controller = container().read(adminFunnelsControllerProvider);
    final snapshot = controller.state.snapshot;

    expect(
      controller.selectedFunnel(snapshot.selectedFunnelId).id,
      snapshot.selectedFunnelId,
    );
    expect(controller.selectedFunnel('missing'), same(snapshot.funnels.first));
  });
}
