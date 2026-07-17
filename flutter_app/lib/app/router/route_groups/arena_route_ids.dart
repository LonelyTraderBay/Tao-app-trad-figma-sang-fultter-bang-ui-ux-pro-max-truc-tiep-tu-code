final class ArenaRoutePaths {
  const ArenaRoutePaths._();

  static const String arena = '/arena';
  static const String arenaGuide = '/arena/guide';
  static const String arenaStudio = '/arena/studio';
  static const String arenaStudioSmartRules = '/arena/studio/smart-rules';
  static const String arenaStudioPresets = '/arena/studio/presets';
  static const String arenaStudioGovernance = '/arena/studio/governance';
  static const String arenaLeaderboard = '/arena/leaderboard';
  static const String arenaVerified = '/arena/verified';
  static const String arenaPoints = '/arena/points';
  static const String arenaFlowMap = '/arena/flow-map';
  static const String arenaSafety = '/arena/safety';
  static const String arenaBlocked = '/arena/blocked';
  static const String arenaMyReports = '/arena/my-reports';
  static const String arenaMy = '/arena/my';
  static const String arenaProduction = '/arena/production';
  static const String arenaBridge = '/arena/bridge';
  static const String arenaEcosystem = '/arena/ecosystem';
  static String arenaReportCase(String caseId) => '/arena/report/$caseId';
  static String arenaChallenge(String challengeId) =>
      '/arena/challenge/$challengeId';
  static String arenaJoin(String challengeId) => '/arena/join/$challengeId';
  static const String arenaResolution = '/arena/resolution';
  static const String arenaLedger = '/arena/ledger';
  static String arenaLedgerEntry(String entryId) =>
      '/arena/ledger/entry/$entryId';
  static String arenaMode(String modeId) => '/arena/mode/$modeId';
  static String arenaCreator(String creatorId) => '/arena/creator/$creatorId';
  static String arenaTrust(String userId) => '/arena/trust/$userId';
}

final class ArenaRouteNames {
  const ArenaRouteNames._();

  static const String sc184ArenaHome = 'sc184ArenaHome';
  static const String sc185ArenaStudio = 'sc185ArenaStudio';
  static const String sc186ArenaSmartRules = 'sc186ArenaSmartRules';
  static const String sc187ArenaPresetLibrary = 'sc187ArenaPresetLibrary';
  static const String sc188ArenaGovernanceGate = 'sc188ArenaGovernanceGate';
  static const String sc189ArenaModeDetail = 'sc189ArenaModeDetail';
  static const String sc190ArenaChallengeDetail = 'sc190ArenaChallengeDetail';
  static const String sc191ArenaJoin = 'sc191ArenaJoin';
  static const String sc192ArenaResolutionCenter = 'sc192ArenaResolutionCenter';
  static const String sc193ArenaCreator = 'sc193ArenaCreator';
  static const String sc194ArenaLeaderboard = 'sc194ArenaLeaderboard';
  static const String sc195VerifiedChallenges = 'sc195VerifiedChallenges';
  static const String sc196ArenaPoints = 'sc196ArenaPoints';
  static const String sc197ArenaFlowMap = 'sc197ArenaFlowMap';
  static const String sc198ArenaSafetyCenter = 'sc198ArenaSafetyCenter';
  static const String sc199ArenaTrustBreakdown = 'sc199ArenaTrustBreakdown';
  static const String sc200ArenaPointsEntryDetail =
      'sc200ArenaPointsEntryDetail';
  static const String sc201ArenaPointsLedger = 'sc201ArenaPointsLedger';
  static const String sc202ArenaReportCase = 'sc202ArenaReportCase';
  static const String sc203ArenaBlockedUsers = 'sc203ArenaBlockedUsers';
  static const String sc204MyArenaReports = 'sc204MyArenaReports';
  static const String sc205MyArena = 'sc205MyArena';
  static const String sc206ArenaProductionReady = 'sc206ArenaProductionReady';
  static const String sc207ArenaPredictionBridgeFoundation =
      'sc207ArenaPredictionBridgeFoundation';
  static const String sc208ConnectedEcosystemProduction =
      'sc208ConnectedEcosystemProduction';
  static const String sc209ArenaGuide = 'sc209ArenaGuide';
}
