import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';

abstract interface class ArenaRepository {
  ArenaHomeSnapshot getArenaHome();

  ArenaStudioSnapshot getArenaStudio();

  ArenaSmartRulesSnapshot getArenaSmartRules();

  ArenaPresetLibrarySnapshot getArenaPresetLibrary();

  ArenaGovernanceSnapshot getArenaGovernance();

  ArenaModeDetailSnapshot getArenaModeDetail(String modeId);

  ArenaChallengeDetailSnapshot getArenaChallengeDetail(String challengeId);

  ArenaJoinSnapshot getArenaJoin(String challengeId);

  ArenaResolutionCenterSnapshot getArenaResolutionCenter();

  ArenaCreatorProfileSnapshot getArenaCreator(String creatorId);

  ArenaLeaderboardSnapshot getArenaLeaderboard();

  VerifiedChallengesSnapshot getVerifiedChallenges();

  ArenaPointsSnapshot getArenaPoints();

  ArenaFlowMapSnapshot getArenaFlowMap();

  ArenaSafetyCenterSnapshot getArenaSafetyCenter();

  ArenaBlockedUsersSnapshot getArenaBlockedUsers();

  ArenaTrustBreakdownSnapshot getArenaTrustBreakdown(String entityId);

  ArenaPointsLedgerSnapshot getArenaPointsLedger();

  ArenaPointsEntryDetailSnapshot getArenaPointsEntryDetail(String entryId);

  ArenaReportCaseSnapshot getArenaReportCase(String caseId);

  MyArenaReportsSnapshot getMyArenaReports();

  MyArenaSnapshot getMyArena();

  MyArenaSnapshot getArenaMy();

  ArenaProductionReadySnapshot getArenaProductionReady();

  ArenaPredictionBridgeSnapshot getArenaPredictionBridge();

  ConnectedEcosystemProductionSnapshot getConnectedEcosystemProduction();

  ArenaGuideSnapshot getArenaGuide();
}
