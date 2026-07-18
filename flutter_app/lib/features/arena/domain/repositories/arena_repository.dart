import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';

/// Abstract data-access contract every Open Arena screen depends on; implemented by mock and remote repositories.
abstract interface class ArenaRepository {
  Future<ArenaHomeSnapshot> getArenaHome();

  Future<ArenaStudioSnapshot> getArenaStudio();

  Future<ArenaSmartRulesSnapshot> getArenaSmartRules();

  Future<ArenaPresetLibrarySnapshot> getArenaPresetLibrary();

  Future<ArenaGovernanceSnapshot> getArenaGovernance();

  Future<ArenaModeDetailSnapshot> getArenaModeDetail(String modeId);

  Future<ArenaChallengeDetailSnapshot> getArenaChallengeDetail(
    String challengeId,
  );

  Future<ArenaJoinSnapshot> getArenaJoin(String challengeId);

  Future<ArenaResolutionCenterSnapshot> getArenaResolutionCenter();

  Future<ArenaCreatorProfileSnapshot> getArenaCreator(String creatorId);

  Future<ArenaLeaderboardSnapshot> getArenaLeaderboard();

  Future<VerifiedChallengesSnapshot> getVerifiedChallenges();

  Future<ArenaPointsSnapshot> getArenaPoints();

  Future<ArenaFlowMapSnapshot> getArenaFlowMap();

  Future<ArenaSafetyCenterSnapshot> getArenaSafetyCenter();

  Future<ArenaBlockedUsersSnapshot> getArenaBlockedUsers();

  Future<ArenaTrustBreakdownSnapshot> getArenaTrustBreakdown(String entityId);

  Future<ArenaPointsLedgerSnapshot> getArenaPointsLedger();

  Future<ArenaPointsEntryDetailSnapshot> getArenaPointsEntryDetail(
    String entryId,
  );

  Future<ArenaReportCaseSnapshot> getArenaReportCase(String caseId);

  Future<MyArenaReportsSnapshot> getMyArenaReports();

  Future<MyArenaSnapshot> getMyArena();

  Future<MyArenaSnapshot> getArenaMy();

  Future<ArenaProductionReadySnapshot> getArenaProductionReady();

  Future<ArenaPredictionBridgeSnapshot> getArenaPredictionBridge();

  Future<ConnectedEcosystemProductionSnapshot>
  getConnectedEcosystemProduction();

  Future<ArenaGuideSnapshot> getArenaGuide();
}
