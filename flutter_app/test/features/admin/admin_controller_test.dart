import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/features/admin/data/providers/admin_repository_provider.dart';
import 'package:vit_trade_flutter/features/admin/data/repositories/mock_admin_repository.dart';

void main() {
  ProviderContainer container() {
    final value = ProviderContainer(
      overrides: [
        adminRepositoryProvider.overrideWithValue(
          const MockAdminRepository(loadDelay: Duration.zero),
        ),
      ],
    );
    addTearDown(value.dispose);
    return value;
  }

  test('AdminHomeController exposes home snapshot state', () async {
    final ref = container();
    await ref.read(adminHomeSnapshotProvider.future);
    final controller = ref.read(adminHomeControllerProvider).requireValue;

    expect(controller.state.snapshot.dashboards, isNotEmpty);
  });

  test('AdminAnalyticsController exposes analytics snapshot state', () async {
    final ref = container();
    await ref.read(adminAnalyticsSnapshotProvider.future);
    final controller = ref.read(adminAnalyticsControllerProvider).requireValue;

    expect(controller.state.snapshot.realtimeRefresh, isTrue);
  });

  test('AdminAbTestsController resolves tests by id', () async {
    final ref = container();
    await ref.read(adminAbTestsSnapshotProvider.future);
    final controller = ref.read(adminAbTestsControllerProvider).requireValue;
    final test = controller.state.snapshot.tests.first;

    expect(controller.testById(test.id), same(test));
    expect(controller.testById('missing'), isNull);
  });

  test('AdminFunnelsController resolves selected funnel fallback', () async {
    final ref = container();
    await ref.read(adminFunnelsSnapshotProvider.future);
    final controller = ref.read(adminFunnelsControllerProvider).requireValue;
    final snapshot = controller.state.snapshot;

    expect(
      controller.selectedFunnel(snapshot.selectedFunnelId).id,
      snapshot.selectedFunnelId,
    );
    expect(controller.selectedFunnel('missing'), same(snapshot.funnels.first));
  });
}
