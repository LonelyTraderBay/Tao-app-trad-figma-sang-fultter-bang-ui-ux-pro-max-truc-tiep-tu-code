import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/rewards/data/rewards_repository.dart';

/// Smoke test for [MockRewardsRepository]: exercises every method on
/// [RewardsRepository] and asserts each call succeeds without throwing and
/// returns a plausible, non-empty result.
void main() {
  const repository = MockRewardsRepository();

  group('MockRewardsRepository smoke test', () {
    test('getHub returns a populated snapshot', () {
      final snapshot = repository.getHub();

      expect(snapshot, isA<RewardsHubSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.subtitle, isNotEmpty);
      expect(snapshot.backRoute, isNotEmpty);
      expect(snapshot.referralRoute, isNotEmpty);
      expect(snapshot.leaderboardRoute, isNotEmpty);
      expect(snapshot.screenState, RewardsScreenState.ready);
    });

    test('getHub returns a populated summary', () {
      final snapshot = repository.getHub();

      expect(snapshot.summary, isA<RewardSummaryDraft>());
      expect(snapshot.summary.bonusPointsClaimed, isNotEmpty);
      expect(snapshot.summary.currentPoints, 2220);
      expect(snapshot.summary.rank, 142);
      expect(snapshot.summary.tierLabel, isNotEmpty);
      expect(snapshot.summary.completionLabel, isNotEmpty);
    });

    test('getHub returns populated categories', () {
      final snapshot = repository.getHub();

      expect(snapshot.categories, isNotEmpty);
      for (final category in snapshot.categories) {
        expect(category, isA<RewardCategoryDraft>());
        expect(category.id, isNotEmpty);
        expect(category.label, isNotEmpty);
      }
    });

    test('getHub returns a 7-day check-in strip with exactly one today', () {
      final snapshot = repository.getHub();

      expect(snapshot.checkIns, hasLength(7));
      for (final checkIn in snapshot.checkIns) {
        expect(checkIn, isA<RewardCheckInDraft>());
        expect(checkIn.label, isNotEmpty);
        expect(checkIn.reward, isNotEmpty);
      }
      expect(snapshot.checkIns.where((c) => c.today), hasLength(1));
    });

    test('getHub returns populated filters', () {
      final snapshot = repository.getHub();

      expect(snapshot.filters, isNotEmpty);
      expect(snapshot.filters, contains('Tất cả'));
    });

    test('getHub returns populated tasks matching the filter list', () {
      final snapshot = repository.getHub();

      expect(snapshot.tasks, isNotEmpty);
      for (final task in snapshot.tasks) {
        expect(task, isA<RewardTaskDraft>());
        expect(task.id, isNotEmpty);
        expect(task.title, isNotEmpty);
        expect(task.rewardLabel, isNotEmpty);
        expect(snapshot.filters, contains(task.filter));
      }
    });

    test('getHub returns populated bonus rows', () {
      final snapshot = repository.getHub();

      expect(snapshot.bonusRows, isNotEmpty);
      for (final bonus in snapshot.bonusRows) {
        expect(bonus, isA<RewardBonusDraft>());
        expect(bonus.title, isNotEmpty);
        expect(bonus.rewardLabel, isNotEmpty);
      }
    });

    test('getHub returns a populated, rank-ordered leaderboard', () {
      final snapshot = repository.getHub();

      expect(snapshot.leaderboard, isNotEmpty);
      for (final entry in snapshot.leaderboard) {
        expect(entry, isA<RewardLeaderboardDraft>());
        expect(entry.name, isNotEmpty);
        expect(entry.pointsLabel, isNotEmpty);
      }
      expect(snapshot.leaderboard.first.rank, 1);
    });

    test('getHub returns disclaimer and contract notes copy', () {
      final snapshot = repository.getHub();

      expect(snapshot.disclaimer, isNotEmpty);
      expect(snapshot.contractNotes, isNotEmpty);
    });

    test('getHub reports the full set of supported screen states', () {
      final snapshot = repository.getHub();

      expect(
        snapshot.supportedStates,
        containsAll(<RewardsScreenState>[
          RewardsScreenState.loading,
          RewardsScreenState.empty,
          RewardsScreenState.error,
          RewardsScreenState.offline,
          RewardsScreenState.ready,
        ]),
      );
    });

    test('getHub does not throw across repeated calls', () {
      expect(() => repository.getHub(), returnsNormally);
      expect(() => repository.getHub(), returnsNormally);
    });
  });
}
