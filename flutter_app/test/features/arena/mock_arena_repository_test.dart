import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';

/// Smoke test for [MockArenaRepository]: exercises every method on
/// [ArenaRepository] and asserts each call succeeds without throwing and
/// returns a plausible, correctly-typed result.
void main() {
  const repository = MockArenaRepository();

  group('MockArenaRepository smoke test', () {
    test('getArenaHome returns a populated snapshot', () {
      final snapshot = repository.getArenaHome();

      expect(snapshot, isA<ArenaHomeSnapshot>());
      expect(snapshot.templates, isNotEmpty);
      expect(snapshot.featuredModes, isNotEmpty);
      expect(snapshot.liveRooms, isNotEmpty);
      expect(snapshot.creators, isNotEmpty);
      expect(snapshot.trustSignals, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaStudio returns a populated snapshot', () {
      final snapshot = repository.getArenaStudio();

      expect(snapshot, isA<ArenaStudioSnapshot>());
      expect(snapshot.steps, isNotEmpty);
      expect(snapshot.templates, isNotEmpty);
      expect(snapshot.platformFeePct, 10);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaSmartRules returns a populated snapshot', () {
      final snapshot = repository.getArenaSmartRules();

      expect(snapshot, isA<ArenaSmartRulesSnapshot>());
      expect(snapshot.domains, isNotEmpty);
      expect(snapshot.challengeTypes, isNotEmpty);
      expect(snapshot.defaultEndDate, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaPresetLibrary returns a populated snapshot', () {
      final snapshot = repository.getArenaPresetLibrary();

      expect(snapshot, isA<ArenaPresetLibrarySnapshot>());
      expect(snapshot.sections, isNotEmpty);
      expect(snapshot.domainPacks, isNotEmpty);
      expect(snapshot.demoFlows, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaGovernance returns a populated snapshot', () {
      final snapshot = repository.getArenaGovernance();

      expect(snapshot, isA<ArenaGovernanceSnapshot>());
      expect(snapshot.steps, isNotEmpty);
      expect(snapshot.privacyOptions, isNotEmpty);
      expect(snapshot.domains, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaModeDetail returns a populated snapshot for a mode id', () {
      final snapshot = repository.getArenaModeDetail('mode001');

      expect(snapshot, isA<ArenaModeDetailSnapshot>());
      expect(snapshot.mode.id, 'mode001');
      expect(snapshot.ruleRows, isNotEmpty);
      expect(snapshot.relatedRooms, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaChallengeDetail returns a populated snapshot for a '
        'challenge id', () {
      final snapshot = repository.getArenaChallengeDetail('ch003');

      expect(snapshot, isA<ArenaChallengeDetailSnapshot>());
      expect(snapshot.challenge.id, 'ch003');
      expect(snapshot.teams, isNotEmpty);
      expect(snapshot.ruleRows, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaJoin returns a populated snapshot for a challenge id', () {
      final snapshot = repository.getArenaJoin('ch003');

      expect(snapshot, isA<ArenaJoinSnapshot>());
      expect(snapshot.challenge.id, 'ch003');
      expect(snapshot.currentBalance, greaterThan(0));
      expect(snapshot.rules, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaResolutionCenter returns a populated snapshot', () {
      final snapshot = repository.getArenaResolutionCenter();

      expect(snapshot, isA<ArenaResolutionCenterSnapshot>());
      expect(snapshot.emptyTitle, isNotEmpty);
      expect(snapshot.emptySubtitle, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaCreator returns a populated snapshot for a creator id', () {
      final snapshot = repository.getArenaCreator('cr001');

      expect(snapshot, isA<ArenaCreatorProfileSnapshot>());
      expect(snapshot.creator.id, 'cr001');
      expect(snapshot.trustMetrics, isNotEmpty);
      expect(snapshot.modes, isNotEmpty);
      expect(snapshot.aboutRows, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaLeaderboard returns a populated snapshot', () {
      final snapshot = repository.getArenaLeaderboard();

      expect(snapshot, isA<ArenaLeaderboardSnapshot>());
      expect(snapshot.podium, isNotEmpty);
      expect(snapshot.topCreators, isNotEmpty);
      expect(snapshot.disclaimer, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getVerifiedChallenges returns a populated snapshot', () {
      final snapshot = repository.getVerifiedChallenges();

      expect(snapshot, isA<VerifiedChallengesSnapshot>());
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.features, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaPoints returns a populated snapshot', () {
      final snapshot = repository.getArenaPoints();

      expect(snapshot, isA<ArenaPointsSnapshot>());
      expect(snapshot.summary.currentBalance, 2220);
      expect(snapshot.categories, isNotEmpty);
      expect(snapshot.tasks, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaFlowMap returns a populated snapshot', () {
      final snapshot = repository.getArenaFlowMap();

      expect(snapshot, isA<ArenaFlowMapSnapshot>());
      expect(snapshot.stats, isNotEmpty);
      expect(snapshot.routes, isNotEmpty);
      expect(snapshot.disclaimer, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaSafetyCenter returns a populated snapshot', () {
      final snapshot = repository.getArenaSafetyCenter();

      expect(snapshot, isA<ArenaSafetyCenterSnapshot>());
      expect(snapshot.communityRules, isNotEmpty);
      expect(snapshot.bannedContent, isNotEmpty);
      expect(snapshot.quickLinks, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaBlockedUsers returns a populated snapshot', () {
      final snapshot = repository.getArenaBlockedUsers();

      expect(snapshot, isA<ArenaBlockedUsersSnapshot>());
      expect(snapshot.users, hasLength(2));
      expect(snapshot.endpoint, isNotEmpty);
    });

    test(
      'getArenaTrustBreakdown returns the matching creator for a known id',
      () {
        final snapshot = repository.getArenaTrustBreakdown('cr001');

        expect(snapshot, isA<ArenaTrustBreakdownSnapshot>());
        expect(snapshot.entityId, 'cr001');
        expect(snapshot.creator, isNotNull);
        expect(snapshot.creator?.id, 'cr001');
        expect(snapshot.metrics, isNotEmpty);
        expect(snapshot.endpoint, isNotEmpty);
      },
    );

    test('getArenaTrustBreakdown does not throw for an unknown id and '
        'falls back to a null creator', () {
      late final ArenaTrustBreakdownSnapshot snapshot;

      expect(
        () => snapshot = repository.getArenaTrustBreakdown('does-not-exist'),
        returnsNormally,
      );
      expect(snapshot, isA<ArenaTrustBreakdownSnapshot>());
      expect(snapshot.creator, isNull);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaPointsLedger returns a populated snapshot', () {
      final snapshot = repository.getArenaPointsLedger();

      expect(snapshot, isA<ArenaPointsLedgerSnapshot>());
      expect(snapshot.summary.currentBalance, 2220);
      expect(snapshot.filters, isNotEmpty);
      expect(snapshot.entries, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test(
      'getArenaPointsEntryDetail returns the matching entry for a known id',
      () {
        final snapshot = repository.getArenaPointsEntryDetail('le001');

        expect(snapshot, isA<ArenaPointsEntryDetailSnapshot>());
        expect(snapshot.entryId, 'le001');
        expect(snapshot.entry, isNotNull);
        expect(snapshot.entry?.id, 'le001');
        expect(snapshot.endpoint, isNotEmpty);
      },
    );

    test('getArenaPointsEntryDetail does not throw for an unknown id and '
        'falls back to a null entry', () {
      late final ArenaPointsEntryDetailSnapshot snapshot;

      expect(
        () => snapshot = repository.getArenaPointsEntryDetail('does-not-exist'),
        returnsNormally,
      );
      expect(snapshot, isA<ArenaPointsEntryDetailSnapshot>());
      expect(snapshot.entry, isNull);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaReportCase returns the matching case for a known id', () {
      final snapshot = repository.getArenaReportCase('rpt001');

      expect(snapshot, isA<ArenaReportCaseSnapshot>());
      expect(snapshot.caseId, 'rpt001');
      expect(snapshot.reportCase, isNotNull);
      expect(snapshot.reportCase?.id, 'rpt001');
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaReportCase does not throw for an unknown id and falls '
        'back to a null case', () {
      late final ArenaReportCaseSnapshot snapshot;

      expect(
        () => snapshot = repository.getArenaReportCase('does-not-exist'),
        returnsNormally,
      );
      expect(snapshot, isA<ArenaReportCaseSnapshot>());
      expect(snapshot.reportCase, isNull);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getMyArenaReports returns a populated snapshot', () {
      final snapshot = repository.getMyArenaReports();

      expect(snapshot, isA<MyArenaReportsSnapshot>());
      expect(snapshot.summary.total, 4);
      expect(snapshot.reports, isNotEmpty);
      expect(snapshot.filters, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getMyArena returns a populated snapshot', () {
      final snapshot = repository.getMyArena();

      expect(snapshot, isA<MyArenaSnapshot>());
      expect(snapshot.stats.currentBalance, 2220);
      expect(snapshot.myRooms, isNotEmpty);
      expect(snapshot.drafts, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaMy returns the same profile data on an arena-scoped '
        'endpoint', () {
      final snapshot = repository.getArenaMy();

      expect(snapshot, isA<MyArenaSnapshot>());
      expect(snapshot.myRooms, isNotEmpty);
      expect(snapshot.endpoint, contains('arena-my'));
    });

    test('getArenaProductionReady returns a populated snapshot', () {
      final snapshot = repository.getArenaProductionReady();

      expect(snapshot, isA<ArenaProductionReadySnapshot>());
      expect(snapshot.canonicalScreens, isNotEmpty);
      expect(snapshot.flows, isNotEmpty);
      expect(snapshot.components, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaPredictionBridge returns a populated snapshot', () {
      final snapshot = repository.getArenaPredictionBridge();

      expect(snapshot, isA<ArenaPredictionBridgeSnapshot>());
      expect(snapshot.principles, isNotEmpty);
      expect(snapshot.allowedItems, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getConnectedEcosystemProduction returns a populated snapshot', () {
      final snapshot = repository.getConnectedEcosystemProduction();

      expect(snapshot, isA<ConnectedEcosystemProductionSnapshot>());
      expect(snapshot.canonicalScreens, isNotEmpty);
      expect(snapshot.bridgeStates, isNotEmpty);
      expect(snapshot.routeRegistry, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getArenaGuide returns a populated snapshot', () {
      final snapshot = repository.getArenaGuide();

      expect(snapshot, isA<ArenaGuideSnapshot>());
      expect(snapshot.heroTitle, isNotEmpty);
      expect(snapshot.createSteps, isNotEmpty);
      expect(snapshot.joinSteps, isNotEmpty);
      expect(snapshot.faqs, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });
  });
}
