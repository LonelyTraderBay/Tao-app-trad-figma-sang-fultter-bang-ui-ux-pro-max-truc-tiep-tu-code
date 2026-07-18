import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/referral/data/referral_repository.dart';

/// Behavior test for [MockReferralRepository]: exercises the filter, search,
/// sort, and aggregate logic in [ReferralRepository] and asserts the
/// computed results against the known fixture data in
/// mock_referral_repository_*_fixtures.dart.
void main() {
  const repository = MockReferralRepository(loadDelay: Duration.zero);

  group('MockReferralRepository.getHome', () {
    test('returns a populated snapshot', () async {
      final snapshot = await repository.getHome();

      expect(snapshot, isA<ReferralHomeSnapshot>());
      expect(snapshot.referralCode, isNotEmpty);
      expect(snapshot.referralLink, isNotEmpty);
      expect(snapshot.socialProof, isNotEmpty);
      expect(snapshot.milestones, isNotEmpty);
      expect(snapshot.pendingCommissions, isNotEmpty);
      expect(snapshot.leaderboard, isNotEmpty);
      expect(snapshot.detailLinks, isNotEmpty);
      expect(snapshot.howItWorks, isNotEmpty);
      expect(snapshot.campaignHistory, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('stats.totalFriends matches the friend fixture count', () async {
      final stats = (await repository.getHome()).stats;

      expect(stats.totalFriends, 8);
    });

    test(
      'stats.kycCompleted counts friends whose status is not pendingKyc',
      () async {
        final stats = (await repository.getHome()).stats;

        // Fixture: friend007 and friend008 are pendingKyc; the other 6
        // friends (kycDone or activeTrader) count as KYC-completed.
        expect(stats.kycCompleted, 6);
      },
    );

    test('stats.activeFriends counts only activeTrader friends', () async {
      final stats = (await repository.getHome()).stats;

      // Fixture: friend001, 002, 003, 005, 006 are activeTrader.
      expect(stats.activeFriends, 5);
    });

    test('stats.totalVolume sums totalVolume across every friend', () async {
      final stats = (await repository.getHome()).stats;

      // 23450 + 12380 + 8920 + 0 + 18760 + 5640 + 0 + 0
      expect(stats.totalVolume, 69150.0);
    });

    test('stats.totalCommission/pendingCommission match the completed and '
        'pending reward totals', () async {
      final stats = (await repository.getHome()).stats;

      expect(stats.totalCommission, 128.90);
      expect(stats.pendingCommission, 10.0);
    });

    test('stats.activeFriends never exceeds stats.totalFriends', () async {
      final stats = (await repository.getHome()).stats;

      expect(stats.activeFriends, lessThanOrEqualTo(stats.totalFriends));
      expect(stats.kycCompleted, lessThanOrEqualTo(stats.totalFriends));
    });
  });

  group('MockReferralRepository.getHistory filters', () {
    test('filter=all returns every friend in the fixture', () async {
      final snapshot = await repository.getHistory(
        filter: ReferralFriendFilter.all,
      );

      expect(snapshot.friends, hasLength(8));
      expect(snapshot.friends.map((friend) => friend.id).toSet(), {
        'friend001',
        'friend002',
        'friend003',
        'friend004',
        'friend005',
        'friend006',
        'friend007',
        'friend008',
      });
    });

    test('filter=activeTrader returns only activeTrader friends', () async {
      final snapshot = await repository.getHistory(
        filter: ReferralFriendFilter.activeTrader,
      );

      expect(snapshot.friends, isNotEmpty);
      expect(
        snapshot.friends.every(
          (friend) => friend.status == ReferralFriendStatus.activeTrader,
        ),
        isTrue,
      );
      expect(snapshot.friends.map((friend) => friend.id).toSet(), {
        'friend001',
        'friend002',
        'friend003',
        'friend005',
        'friend006',
      });
    });

    test('filter=kycDone returns only kycDone friends', () async {
      final snapshot = await repository.getHistory(
        filter: ReferralFriendFilter.kycDone,
      );

      expect(snapshot.friends, hasLength(1));
      expect(
        snapshot.friends.every(
          (friend) => friend.status == ReferralFriendStatus.kycDone,
        ),
        isTrue,
      );
      expect(snapshot.friends.single.id, 'friend004');
    });

    test('filter=pendingKyc returns only pendingKyc friends', () async {
      final snapshot = await repository.getHistory(
        filter: ReferralFriendFilter.pendingKyc,
      );

      expect(snapshot.friends, hasLength(2));
      expect(
        snapshot.friends.every(
          (friend) => friend.status == ReferralFriendStatus.pendingKyc,
        ),
        isTrue,
      );
      expect(snapshot.friends.map((friend) => friend.id).toSet(), {
        'friend007',
        'friend008',
      });
    });
  });

  group('MockReferralRepository.getHistory search', () {
    test('query matches case-insensitively against the friend name', () async {
      final lower = await repository.getHistory(query: 'thanh');
      final upper = await repository.getHistory(query: 'THANH');

      expect(lower.friends, hasLength(1));
      expect(lower.friends.single.id, 'friend001');
      expect(upper.friends, hasLength(1));
      expect(upper.friends.single.id, 'friend001');
    });

    test('query with no matches returns an empty friend list', () async {
      final snapshot = await repository.getHistory(query: 'zzz-not-a-friend');

      expect(snapshot.friends, isEmpty);
    });
  });

  group('MockReferralRepository.getHistory sort', () {
    test(
      'sort=commission orders friends by totalCommission descending',
      () async {
        final friends = (await repository.getHistory(
          sort: ReferralHistorySort.commission,
        )).friends;

        // Highest two commissions in the fixture are unambiguous.
        expect(friends.first.id, 'friend001');
        expect(friends.first.totalCommission, 46.90);
        expect(friends[1].id, 'friend005');
        expect(friends[1].totalCommission, 37.50);

        for (var i = 0; i < friends.length - 1; i++) {
          expect(
            friends[i].totalCommission,
            greaterThanOrEqualTo(friends[i + 1].totalCommission),
          );
        }
      },
    );

    test('sort=volume orders friends by totalVolume descending', () async {
      final friends = (await repository.getHistory(
        sort: ReferralHistorySort.volume,
      )).friends;

      expect(friends.first.id, 'friend001');
      expect(friends.first.totalVolume, 23450);
      expect(friends[1].id, 'friend005');
      expect(friends[1].totalVolume, 18760);

      for (var i = 0; i < friends.length - 1; i++) {
        expect(
          friends[i].totalVolume,
          greaterThanOrEqualTo(friends[i + 1].totalVolume),
        );
      }
    });

    test(
      'sort=date is a no-op comparator and preserves the fixture order',
      () async {
        final friends = (await repository.getHistory(
          sort: ReferralHistorySort.date,
        )).friends;

        expect(friends.map((friend) => friend.id).toList(), [
          'friend001',
          'friend002',
          'friend003',
          'friend004',
          'friend005',
          'friend006',
          'friend007',
          'friend008',
        ]);
      },
    );
  });

  group('MockReferralRepository.getRewards filters', () {
    test('filter=all returns every reward record', () async {
      final snapshot = await repository.getRewards(
        filter: ReferralRewardFilter.all,
      );

      expect(snapshot.records, hasLength(14));
      expect(snapshot.completedCount, 12);
      expect(snapshot.pendingCount, 2);
    });

    test('filter=kycBonus returns only kycBonus records', () async {
      final snapshot = await repository.getRewards(
        filter: ReferralRewardFilter.kycBonus,
      );

      expect(snapshot.records, hasLength(6));
      expect(
        snapshot.records.every(
          (record) => record.type == ReferralRewardType.kycBonus,
        ),
        isTrue,
      );
      expect(snapshot.records.map((record) => record.id).toSet(), {
        'cr-03',
        'cr-06',
        'cr-09',
        'cr-10',
        'cr-13',
        'cr-14',
      });
      expect(snapshot.completedCount, 4);
      expect(snapshot.pendingCount, 2);
    });

    test(
      'filter=tradeCommission returns only tradeCommission records',
      () async {
        final snapshot = await repository.getRewards(
          filter: ReferralRewardFilter.tradeCommission,
        );

        expect(snapshot.records, hasLength(8));
        expect(
          snapshot.records.every(
            (record) => record.type == ReferralRewardType.tradeCommission,
          ),
          isTrue,
        );
        expect(snapshot.completedCount, 8);
        expect(snapshot.pendingCount, 0);
      },
    );
  });

  group('MockReferralRepository.getRewards sort', () {
    test('sort=amount orders records by amount descending', () async {
      final records = (await repository.getRewards(
        sort: ReferralRewardSort.amount,
      )).records;

      // Highest two amounts in the fixture are unambiguous.
      expect(records.first.id, 'cr-01');
      expect(records.first.amount, 22.30);
      expect(records[1].id, 'cr-11');
      expect(records[1].amount, 18.90);

      for (var i = 0; i < records.length - 1; i++) {
        expect(records[i].amount, greaterThanOrEqualTo(records[i + 1].amount));
      }
    });

    test(
      'sort=date is a no-op comparator and preserves the fixture order',
      () async {
        final records = (await repository.getRewards(
          sort: ReferralRewardSort.date,
        )).records;

        expect(records.map((record) => record.id).toList(), [
          'cr-01',
          'cr-02',
          'cr-03',
          'cr-04',
          'cr-05',
          'cr-06',
          'cr-07',
          'cr-08',
          'cr-09',
          'cr-10',
          'cr-11',
          'cr-12',
          'cr-13',
          'cr-14',
        ]);
      },
    );
  });

  group('MockReferralRepository.getRewards aggregates', () {
    test('kycBonusTotal and tradeCommissionTotal are computed from '
        'completed records only, independent of the filter argument', () async {
      final snapshot = await repository.getRewards();

      // cr-03 + cr-06 + cr-09 + cr-10 (completed kycBonus records, 5 each)
      expect(snapshot.kycBonusTotal, 20.0);
      // cr-01 + cr-02 + cr-04 + cr-05 + cr-07 + cr-08 + cr-11 + cr-12
      expect(snapshot.tradeCommissionTotal, 108.90);
    });

    test('totalCommission and pendingCommission match the completed and '
        'pending reward totals', () async {
      final snapshot = await repository.getRewards();

      expect(snapshot.totalCommission, 128.90);
      expect(snapshot.pendingCommission, 10.0);
    });
  });

  group('MockReferralRepository.getRules', () {
    test('returns a populated snapshot with all program tiers', () async {
      final snapshot = await repository.getRules();

      expect(snapshot, isA<ReferralRulesSnapshot>());
      expect(snapshot.tiers, hasLength(5));
      expect(snapshot.tiers.first.id, 'bronze');
      expect(snapshot.tiers.last.id, 'elite');
      expect(snapshot.rewardTypes, isNotEmpty);
      expect(snapshot.terms, isNotEmpty);
      expect(snapshot.faqs, isNotEmpty);
      expect(snapshot.disclaimer, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('currentTierIndex points at the Silver tier', () async {
      final snapshot = await repository.getRules();

      expect(snapshot.currentTierIndex, 1);
      expect(snapshot.tiers[snapshot.currentTierIndex].id, 'silver');
    });
  });

  group('MockReferralRepository.getFriendDetail', () {
    test('echoes the requested friendId back on the snapshot', () async {
      final snapshot = await repository.getFriendDetail('friend001');

      expect(snapshot, isA<ReferralFriendDetailSnapshot>());
      expect(snapshot.friendId, 'friend001');
      expect(snapshot.endpoint, contains('friend001'));
    });

    test('always resolves to the not-found state regardless of friendId '
        '(SC-289: no friend detail data source is wired up yet)', () async {
      final snapshot = await repository.getFriendDetail('friend001');

      expect(snapshot.found, isFalse);
      expect(snapshot.emptyTitle, isNotEmpty);
      expect(snapshot.emptyMessage, isNotEmpty);
      expect(snapshot.listRoute, isNotEmpty);
    });

    test('does not throw for an unrecognized friendId and falls back to '
        'the same not-found state', () async {
      final snapshot = await repository.getFriendDetail('does-not-exist');

      expect(snapshot.found, isFalse);
      expect(snapshot.friendId, 'does-not-exist');
      expect(snapshot.endpoint, contains('does-not-exist'));
    });
  });
}
