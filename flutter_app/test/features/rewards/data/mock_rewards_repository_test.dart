import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/rewards/data/rewards_repository.dart';

/// Repository-layer smoke test for [MockRewardsRepository] under the
/// `test/features/<feature>/data/` convention (see
/// `test/features/p2p/data/mock_p2p_repository_orders_test.dart`).
///
/// [RewardsRepository] exposes a single method, [RewardsRepository.getHub],
/// already exercised (isA<>/isNotEmpty) by the sibling
/// `test/features/rewards/mock_rewards_repository_test.dart`. This file
/// complements that coverage by pinning concrete, hand-verified values from
/// `lib/features/rewards/data/repositories/mock_rewards_repository.dart` so
/// a silent fixture edit shows up as a failing assertion. getHub is now
/// async (GD4) — no write/action methods exist on this repository.
///
/// Product boundary: Rewards Hub is Arena-Points-only, never wallet
/// balance/payout/PnL — the mock's own disclaimer says as much, so this
/// file pins that disclaimer text rather than re-deriving a forbidden-word
/// scan (that scan lives in widget tests via
/// `expectNoArenaFinancialBoundaryCopyRegression`, which needs a pumped
/// widget tree this plain repository test does not have).
void main() {
  const repository = MockRewardsRepository(loadDelay: Duration.zero);

  group('MockRewardsRepository data smoke test', () {
    test('getHub pins the endpoint, routes, and screen state', () async {
      final snapshot = await repository.getHub();

      expect(snapshot.endpoint, '/api/mobile/rewards/rewards');
      expect(snapshot.title, 'Trung tâm Phần thưởng');
      expect(snapshot.subtitle, 'Phần thưởng · Rewards');
      expect(snapshot.backRoute, '/home');
      expect(snapshot.referralRoute, '/referral');
      expect(snapshot.leaderboardRoute, '/arena/leaderboard');
      expect(snapshot.screenState, RewardsScreenState.ready);
    });

    test('getHub pins the summary headline figures', () async {
      final snapshot = await repository.getHub();

      expect(snapshot.summary.bonusPointsClaimed, '3,500');
      expect(snapshot.summary.currentPoints, 2220);
      expect(snapshot.summary.lockedPoints, 450);
      expect(snapshot.summary.rank, 142);
      expect(snapshot.summary.topPercent, 5);
      expect(snapshot.summary.claimedCount, 5);
      expect(snapshot.summary.pendingCount, 3);
      expect(snapshot.summary.completionLabel, '5/24 · 21%');
      expect(snapshot.summary.tierLabel, 'Bạc');
    });

    test('getHub pins the 6 category cards with done/total counts', () async {
      final snapshot = await repository.getHub();

      expect(snapshot.categories, hasLength(6));
      expect(snapshot.categories.first.id, 'daily');
      expect(snapshot.categories.first.done, 2);
      expect(snapshot.categories.first.total, 5);
      expect(snapshot.categories.last.id, 'arena');
      expect(snapshot.categories.last.done, 1);
      expect(snapshot.categories.last.total, 3);
    });

    test('getHub pins the 7-day check-in strip with day 5 as today', () async {
      final snapshot = await repository.getHub();

      expect(snapshot.checkIns, hasLength(7));
      expect(snapshot.checkIns[4].day, 5);
      expect(snapshot.checkIns[4].label, 'Hôm nay');
      expect(snapshot.checkIns[4].reward, '+30');
      expect(snapshot.checkIns[4].today, isTrue);
      expect(snapshot.checkIns.where((c) => c.today), hasLength(1));
    });

    test('getHub pins the filter chip list', () async {
      final snapshot = await repository.getHub();

      expect(snapshot.filters, [
        'Tất cả',
        'Flash',
        'Học',
        'Hằng ngày',
        'P2P',
        'Arena',
      ]);
    });

    test('getHub pins the task list count and a known task by id', () async {
      final snapshot = await repository.getHub();

      expect(snapshot.tasks, hasLength(24));
      final volumeTask = snapshot.tasks.firstWhere(
        (task) => task.id == 'task-volume',
      );
      expect(volumeTask.title, 'Volume tuần \$10K');
      expect(volumeTask.status, RewardTaskStatus.active);
      expect(volumeTask.rewardLabel, '+120 Arena Points');
    });

    test('getHub pins the 3 bonus rows', () async {
      final snapshot = await repository.getHub();

      expect(snapshot.bonusRows, hasLength(3));
      expect(snapshot.bonusRows.first.title, 'Vòng quay may mắn');
      expect(snapshot.bonusRows.first.rewardLabel, '1 lượt');
    });

    test('getHub pins the rank-ordered leaderboard', () async {
      final snapshot = await repository.getHub();

      expect(snapshot.leaderboard, hasLength(3));
      expect(snapshot.leaderboard.first.rank, 1);
      expect(snapshot.leaderboard.first.name, 'CryptoWhale');
      expect(snapshot.leaderboard.first.pointsLabel, '15.9K');
    });

    test(
      'getHub pins the Arena-Points-only disclaimer and contract notes',
      () async {
        final snapshot = await repository.getHub();

        expect(
          snapshot.disclaimer,
          'Arena Points duoc tinh dua tren hoat dong thuc te va khong phai tai '
          'san tai chinh, vi giao dich hoac PnL.',
        );
        expect(
          snapshot.contractNotes,
          'Rewards Hub is read-only for reference data. Claim, referral, '
          'leaderboard, and redeem buttons remain local navigation or local '
          'state until backend confirms action APIs.',
        );
      },
    );
  });
}
