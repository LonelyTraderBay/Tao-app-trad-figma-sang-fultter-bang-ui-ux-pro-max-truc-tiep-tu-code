import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';

/// Smoke test for [MockAdminRepository]: exercises every method on
/// [AdminRepository] and asserts each call succeeds without throwing and
/// returns a plausible, correctly-typed result.
void main() {
  const repository = MockAdminRepository(loadDelay: Duration.zero);

  group('MockAdminRepository smoke test', () {
    test('getHome returns a populated snapshot', () async {
      final snapshot = await repository.getHome();

      expect(snapshot, isA<AdminHomeSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
      expect(snapshot.quickStats, hasLength(3));
      expect(snapshot.liveStats, hasLength(3));
      expect(snapshot.dashboards, hasLength(3));
      expect(snapshot.dashboards.first.id, 'analytics');
      expect(snapshot.adminMetrics, isA<AdminMetrics>());
      expect(snapshot.adminMetrics.totalTests, 5);
      expect(snapshot.adminMetrics.totalFunnels, 5);
    });

    test('getAnalytics returns a populated snapshot', () async {
      final snapshot = await repository.getAnalytics();

      expect(snapshot, isA<AdminAnalyticsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
      expect(snapshot.realtimeRefresh, isTrue);
      expect(snapshot.activeRange, AdminAnalyticsRange.sevenDays);
      expect(snapshot.ranges, hasLength(3));
      expect(snapshot.dailyStats, hasLength(4));
      expect(snapshot.queueSummary, isNotEmpty);
      expect(snapshot.adminMetrics, isA<AdminMetrics>());
    });

    test('getAbTests returns a populated snapshot', () async {
      final snapshot = await repository.getAbTests();

      expect(snapshot, isA<AdminAbTestsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
      expect(snapshot.activeTests, 5);
      expect(snapshot.completedTests, 0);
      expect(snapshot.tests, hasLength(5));

      final firstTest = snapshot.tests.first;
      expect(firstTest.id, 'dca_wallet_shortcut_v1');
      expect(firstTest.status, AdminAbTestStatus.active);
      expect(firstTest.variants, isNotEmpty);
      expect(firstTest.variants.first.isControl, isTrue);
    });

    test('getFunnels returns a populated snapshot', () async {
      final snapshot = await repository.getFunnels();

      expect(snapshot, isA<AdminFunnelsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
      expect(snapshot.selectedFunnelId, 'wallet_to_creation');
      expect(snapshot.funnels, hasLength(5));

      final firstFunnel = snapshot.funnels.first;
      expect(firstFunnel.id, 'wallet_to_creation');
      expect(firstFunnel.steps, isNotEmpty);
      expect(snapshot.adminMetrics, isA<AdminMetrics>());
    });

    test('MockAdminRepository satisfies AdminRepository for every method '
        'without throwing', () async {
      const AdminRepository asInterface = MockAdminRepository();

      await asInterface.getHome();
      await asInterface.getAnalytics();
      await asInterface.getAbTests();
      await asInterface.getFunnels();
    });
  });
}
