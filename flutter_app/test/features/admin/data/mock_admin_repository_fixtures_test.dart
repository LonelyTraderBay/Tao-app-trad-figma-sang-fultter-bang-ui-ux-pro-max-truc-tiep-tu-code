import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';

/// Fixture-pinning test for [MockAdminRepository]: every method on
/// [AdminRepository] is already exercised for shape (non-empty lists,
/// populated strings, correct `hasLength`) in
/// `test/features/admin/mock_admin_repository_test.dart`. This file pins the
/// exact literal values in the reference fixture — dashboard link ids/
/// routes, A/B test ids and variant counts, funnel ids and step counts, and
/// the shared `adminMetrics` block — so a silent content regression in the
/// mock data fails a test instead of only a visual diff.
void main() {
  const repository = MockAdminRepository(loadDelay: Duration.zero);

  group('MockAdminRepository fixture pins', () {
    test('getHome dashboards pin ids, routes, and stat labels', () async {
      final dashboards = (await repository.getHome()).dashboards;

      expect(dashboards, hasLength(3));
      expect(dashboards[0].id, 'analytics');
      expect(dashboards[0].route, '/admin/analytics');
      expect(dashboards[0].stat, '0 events');
      expect(dashboards[1].id, 'abtests');
      expect(dashboards[1].route, '/admin/abtests');
      expect(dashboards[1].stat, '5 active');
      expect(dashboards[2].id, 'funnels');
      expect(dashboards[2].route, '/admin/funnels');
      expect(dashboards[2].stat, '0 completed');
    });

    test('getHome adminMetrics pins the shared health snapshot', () async {
      final metrics = (await repository.getHome()).adminMetrics;

      expect(metrics.totalTests, 5);
      expect(metrics.totalFunnels, 5);
      expect(metrics.healthLabel, 'Tốt');
      expect(metrics.liveEventWindowLabel, '0 sự kiện (5 phút)');
    });

    test('getAnalytics ranges pin the selectable date-range options', () async {
      final snapshot = await repository.getAnalytics();

      expect(snapshot.activeRange, AdminAnalyticsRange.sevenDays);
      expect(snapshot.ranges, hasLength(3));
      expect(snapshot.ranges[0].range, AdminAnalyticsRange.sevenDays);
      expect(snapshot.ranges[0].label, '7 ngày');
      expect(snapshot.ranges[1].range, AdminAnalyticsRange.thirtyDays);
      expect(snapshot.ranges[1].label, '30 ngày');
      expect(snapshot.ranges[2].range, AdminAnalyticsRange.ninetyDays);
      expect(snapshot.ranges[2].label, '90 ngày');
    });

    test('getAbTests pins every test id, status, and variant count', () async {
      final tests = (await repository.getAbTests()).tests;

      expect(tests, hasLength(5));
      expect(
        tests.map((test) => test.id),
        containsAllInOrder(<String>[
          'dca_wallet_shortcut_v1',
          'dca_onboarding_v1',
          'dca_frequency_v1',
          'dca_form_layout_v1',
          'dca_pair_detail_placement_v1',
        ]),
      );
      expect(
        tests.every((test) => test.status == AdminAbTestStatus.active),
        isTrue,
      );

      final variantCounts = tests.map((test) => test.variants.length).toList();
      expect(variantCounts, [2, 3, 2, 2, 2]);
      expect(tests.every((test) => test.variants.first.isControl), isTrue);
    });

    test('getFunnels pins every funnel id and step count', () async {
      final funnels = (await repository.getFunnels()).funnels;

      expect(funnels, hasLength(5));
      expect(
        funnels.map((funnel) => funnel.id),
        containsAllInOrder(<String>[
          'wallet_to_creation',
          'asset_to_creation',
          'first_time_user',
          'plan_activation',
          'pair_detail_to_creation',
        ]),
      );

      final firstFunnel = funnels.first;
      expect(firstFunnel.stepCountLabel, '6 bước');
      expect(firstFunnel.steps, hasLength(6));
      expect(firstFunnel.steps.first.label, 'Wallet Page View');
      expect(firstFunnel.steps.last.label, 'Plan Created');

      final activationFunnel = funnels.firstWhere(
        (funnel) => funnel.id == 'plan_activation',
      );
      expect(activationFunnel.stepCountLabel, '3 bước');
      expect(activationFunnel.steps, hasLength(3));
    });
  });
}
