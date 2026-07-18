import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';

/// Repository-layer smoke test for [MockArenaRepository] under the
/// `test/features/<feature>/data/` convention (see
/// `test/features/p2p/data/mock_p2p_repository_orders_test.dart`).
///
/// Every method on [ArenaRepository] already gets an isA<>/isNotEmpty smoke
/// pass in the sibling `test/features/arena/mock_arena_repository_test.dart`.
/// This file complements that coverage by pinning concrete, hand-verified
/// values from `lib/features/arena/data/fixtures/arena_*_repository_methods.dart`
/// so a silent fixture edit shows up as a failing assertion. All methods on
/// [ArenaRepository] are plain synchronous getters.
///
/// Split by behavior group (mirrors the production `_MockArenaRepository*
/// Methods` mixin split): this file covers points, creator trust, safety,
/// and "my Arena" management surfaces. See
/// `mock_arena_repository_home_discovery_test.dart` for
/// discovery/creation-flow surfaces and
/// `mock_arena_repository_ecosystem_test.dart` for flow-map/production/
/// bridge/guide surfaces.
///
/// Product boundary: Open Arena is Arena-Points-only. The fixtures'
/// disclaimers explicitly say Arena Points are not a trading account, PnL,
/// or wallet value — the assertions below pin that copy rather than
/// introducing new copy assumptions that would blur the boundary.
void main() {
  const repository = MockArenaRepository();

  group('MockArenaRepository points/social data smoke test', () {
    test(
      'getArenaPoints pins the summary balance and 7-day check-in strip',
      () {
        final snapshot = repository.getArenaPoints();

        expect(snapshot.endpoint, '/api/mobile/arena/arena-points');
        expect(snapshot.summary.currentBalance, 2220);
        expect(snapshot.summary.rank, 142);
        expect(snapshot.summary.tierLabel, 'Bạc');
        expect(snapshot.categories, hasLength(6));
        expect(snapshot.checkIns, hasLength(7));
        expect(snapshot.checkIns[4].today, isTrue);
        expect(snapshot.tasks, hasLength(24));
        expect(snapshot.leaderboard.first.name, 'CryptoWhale');
      },
    );

    test('getArenaPointsLedger pins the running balance and entry count', () {
      final snapshot = repository.getArenaPointsLedger();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-ledger');
      expect(snapshot.summary.currentBalance, 2220);
      expect(snapshot.summary.pointsEarned, 4520);
      expect(snapshot.summary.pointsSpent, 2300);
      expect(snapshot.filters, hasLength(7));
      expect(snapshot.entries, hasLength(15));
      expect(snapshot.entries.first.id, 'le001');
      expect(snapshot.entries.first.amount, 30);
    });

    test(
      'getArenaPointsEntryDetail returns le001 with its amount and balance',
      () {
        final snapshot = repository.getArenaPointsEntryDetail('le001');

        expect(snapshot.entryId, 'le001');
        expect(snapshot.entry, isNotNull);
        expect(snapshot.entry?.amount, 30);
        expect(snapshot.entry?.balanceAfter, 2220);
        expect(snapshot.entry?.reasonCode, 'DAILY_CHECKIN');
      },
    );

    test('getArenaCreator pins the cr001 trust score and metric count', () {
      final snapshot = repository.getArenaCreator('cr001');

      expect(snapshot.endpoint, '/api/mobile/arena/arena-creator-cr001');
      expect(snapshot.creator.id, 'cr001');
      expect(snapshot.creator.name, 'CryptoMaster_VN');
      expect(snapshot.creator.trustScore, 95);
      expect(snapshot.creator.badge, 'Gold');
      expect(snapshot.trustMetrics, hasLength(4));
      expect(snapshot.aboutRows, hasLength(4));
    });

    test(
      'getArenaTrustBreakdown pins the matched creator and metric count',
      () {
        final snapshot = repository.getArenaTrustBreakdown('cr001');

        expect(snapshot.entityId, 'cr001');
        expect(snapshot.creator?.id, 'cr001');
        expect(snapshot.creator?.trustScore, 95);
        expect(snapshot.metrics, hasLength(4));
        expect(
          snapshot.disclaimer,
          'Trust Score chỉ là chỉ báo cộng đồng trong Open Arena, không phải '
          'PnL hoặc giá trị ví.',
        );
      },
    );

    test('getArenaLeaderboard pins the podium and myRank', () {
      final snapshot = repository.getArenaLeaderboard();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-leaderboard');
      expect(snapshot.myRank.rank, 142);
      expect(snapshot.podium, hasLength(3));
      expect(snapshot.podium.first.name, 'CryptoMaster_VN');
      expect(snapshot.topCreators, hasLength(2));
      expect(snapshot.risingCreators, hasLength(2));
    });

    test('getVerifiedChallenges pins the release-gated preview copy', () {
      final snapshot = repository.getVerifiedChallenges();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-verified');
      expect(snapshot.title, 'Verified Challenges');
      expect(snapshot.statusLabel, 'Release-gated Preview');
      expect(snapshot.features, hasLength(4));
    });

    test('getArenaSafetyCenter pins the community rules and quick links', () {
      final snapshot = repository.getArenaSafetyCenter();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-safety');
      expect(snapshot.communityRules, hasLength(4));
      expect(snapshot.bannedContent, hasLength(6));
      expect(snapshot.violationProcess, hasLength(4));
      expect(snapshot.quickLinks, hasLength(2));
      expect(snapshot.quickLinks.first.route, '/arena/blocked');
    });

    test('getArenaBlockedUsers pins the blocked-user count', () {
      final snapshot = repository.getArenaBlockedUsers();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-blocked');
      expect(snapshot.users, hasLength(2));
      expect(snapshot.users.first.id, 'blk001');
      expect(snapshot.users.first.name, 'SpamBot_X');
    });

    test('getArenaReportCase returns rpt001 with its resolution', () {
      final snapshot = repository.getArenaReportCase('rpt001');

      expect(snapshot.endpoint, '/api/mobile/arena/arena-report-rpt001');
      expect(snapshot.caseId, 'rpt001');
      expect(snapshot.reportCase?.id, 'rpt001');
      expect(snapshot.reportCase?.status, ArenaReportCaseStatus.actionTaken);
      expect(snapshot.reportCase?.targetName, 'GameMaker_HN');
      expect(snapshot.relatedReports, hasLength(2));
    });

    test('getMyArenaReports pins the 4-case totals and filter counts', () {
      final snapshot = repository.getMyArenaReports();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-my-reports');
      expect(snapshot.summary.total, 4);
      expect(snapshot.reports, hasLength(4));
      expect(snapshot.filters, hasLength(6));
      expect(snapshot.filters.first.id, 'all');
      expect(snapshot.filters.first.count, 4);
    });

    test('getMyArena pins the balance stat and room/draft counts', () {
      final snapshot = repository.getMyArena();

      expect(snapshot.endpoint, '/api/mobile/profile/profile-arena');
      expect(snapshot.stats.currentBalance, 2220);
      expect(snapshot.stats.rank, 142);
      expect(snapshot.myRooms, hasLength(3));
      expect(snapshot.joinedChallenges, hasLength(3));
      expect(snapshot.savedModes, hasLength(3));
      expect(snapshot.drafts, hasLength(2));
      expect(snapshot.history, hasLength(2));
      expect(snapshot.rewardHistory.totalReceipts, 12);
    });

    test('getArenaMy mirrors getMyArena data on the arena-scoped endpoint', () {
      final snapshot = repository.getArenaMy();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-my');
      expect(snapshot.stats.currentBalance, 2220);
      expect(snapshot.myRooms, hasLength(3));
    });
  });
}
