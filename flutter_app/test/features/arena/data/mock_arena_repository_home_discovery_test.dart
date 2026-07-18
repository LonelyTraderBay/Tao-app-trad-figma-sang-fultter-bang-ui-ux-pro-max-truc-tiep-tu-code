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
/// [ArenaRepository] are plain synchronous getters — there are no write
/// methods to await.
///
/// Split by behavior group (mirrors the production `_MockArenaRepository*
/// Methods` mixin split): this file covers home/discovery and creation
/// flow entry points. See
/// `mock_arena_repository_points_social_test.dart` for points/social
/// surfaces and `mock_arena_repository_ecosystem_test.dart` for
/// flow-map/production-readiness/bridge/guide surfaces.
///
/// Product boundary: Open Arena is Arena-Points-only. Fixtures below
/// intentionally never surface wallet balance, payout, profit, or PnL
/// copy — the assertions here only pin what already ships.
void main() {
  const repository = MockArenaRepository();

  group('MockArenaRepository home/discovery data smoke test', () {
    test('getArenaHome pins template/mode/room counts and a known room', () {
      final snapshot = repository.getArenaHome();

      expect(snapshot.endpoint, '/api/mobile/arena/arena');
      expect(snapshot.templates, hasLength(6));
      expect(snapshot.featuredModes, hasLength(3));
      expect(snapshot.liveRooms, hasLength(5));
      expect(snapshot.liveRooms.first.id, 'ch001');
      expect(snapshot.liveRooms.first.entryPoints, 100);
      expect(snapshot.liveRooms.first.prizePool, 3800);
      expect(snapshot.creators, hasLength(3));
      expect(snapshot.pendingNotifications, 3);
    });

    test('getArenaStudio pins the platform fee and step/template counts', () {
      final snapshot = repository.getArenaStudio();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-studio');
      expect(snapshot.platformFeePct, 10);
      expect(snapshot.steps, hasLength(6));
      expect(snapshot.templates, hasLength(6));
      expect(snapshot.trustSignals, hasLength(3));
    });

    test('getArenaSmartRules pins the default end date and option counts', () {
      final snapshot = repository.getArenaSmartRules();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-studio-smart-rules');
      expect(snapshot.defaultEndDate, '2026-03-15');
      expect(snapshot.domains, hasLength(4));
      expect(snapshot.challengeTypes, hasLength(10));
      expect(snapshot.subjects, hasLength(4));
      expect(snapshot.tieRules, hasLength(3));
    });

    test('getArenaPresetLibrary pins section/domain-pack/demo-flow counts', () {
      final snapshot = repository.getArenaPresetLibrary();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-studio-presets');
      expect(snapshot.sections, hasLength(5));
      expect(snapshot.domainPacks, hasLength(10));
      expect(snapshot.domainPacks.first.id, 'sports');
      expect(snapshot.demoFlows, hasLength(3));
      expect(snapshot.titleSuggestions, hasLength(5));
    });

    test('getArenaGovernance pins the privacy options and domain count', () {
      final snapshot = repository.getArenaGovernance();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-studio-governance');
      expect(snapshot.defaultEndDate, '2026-03-15');
      expect(snapshot.privacyOptions, hasLength(3));
      expect(snapshot.privacyOptions.first.id, 'public');
      expect(snapshot.domains, hasLength(10));
      expect(snapshot.suggestionActions, hasLength(4));
    });

    test('getArenaModeDetail returns the mode001 fixture regardless of id', () {
      final snapshot = repository.getArenaModeDetail('mode001');

      expect(snapshot.endpoint, '/api/mobile/arena/arena-mode-mode001');
      expect(snapshot.mode.id, 'mode001');
      expect(snapshot.mode.title, 'BTC Weekly Predict');
      expect(snapshot.mode.cloneCount, 234);
      expect(snapshot.creator.id, 'cr001');
      expect(snapshot.ruleRows, hasLength(5));
      expect(snapshot.qualityMetrics, hasLength(4));
      expect(snapshot.relatedRooms, hasLength(1));
    });

    test('getArenaChallengeDetail pins the ch003 pool and team counts', () {
      final snapshot = repository.getArenaChallengeDetail('ch003');

      expect(snapshot.endpoint, '/api/mobile/arena/arena-challenge-ch003');
      expect(snapshot.challenge.id, 'ch003');
      expect(snapshot.challenge.entryPoints, 200);
      expect(snapshot.challenge.prizePool, 7200);
      expect(snapshot.challenge.platformFeePercent, 10);
      expect(snapshot.creator.id, 'cr002');
      expect(snapshot.teams, hasLength(2));
      expect(snapshot.teams.first.members, hasLength(4));
      expect(snapshot.rules, hasLength(5));
    });

    test('getArenaJoin pins the current balance and refund notice', () {
      final snapshot = repository.getArenaJoin('ch003');

      expect(snapshot.endpoint, '/api/mobile/arena/arena-join-ch003');
      expect(snapshot.challenge.id, 'ch003');
      expect(snapshot.currentBalance, 2220);
      expect(snapshot.rules, hasLength(5));
      expect(
        snapshot.refundNotice,
        'Entry points sẽ bị trừ ngay khi tham gia. Nếu hủy trước deadline, '
        'bạn được hoàn 50%. Arena Points không có giá trị tiền tệ.',
      );
    });

    test('getArenaResolutionCenter pins the empty-state copy', () {
      final snapshot = repository.getArenaResolutionCenter();

      expect(snapshot.endpoint, '/api/mobile/arena/arena-resolution');
      expect(snapshot.emptyTitle, 'Không tìm thấy');
      expect(snapshot.emptySubtitle, 'Challenge không tồn tại hoặc đã bị xoá');
    });
  });
}
