part of '../app_router.dart';

List<RouteBase> _arenaCoreRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.arena,
      name: AppRouteNames.sc184ArenaHome,
      builder: (_, _) => ArenaHomePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaGuide,
      name: AppRouteNames.sc209ArenaGuide,
      builder: (_, _) => ArenaGuidePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaStudio,
      name: AppRouteNames.sc185ArenaStudio,
      builder: (_, _) => ArenaStudioPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaStudioSmartRules,
      name: AppRouteNames.sc186ArenaSmartRules,
      builder: (_, _) =>
          ArenaSmartRuleBuilderPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaStudioPresets,
      name: AppRouteNames.sc187ArenaPresetLibrary,
      builder: (_, _) =>
          ArenaUniversalPresetLibraryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaStudioGovernance,
      name: AppRouteNames.sc188ArenaGovernanceGate,
      builder: (_, _) =>
          ArenaGovernanceGatePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/arena/mode/:modeId',
      name: AppRouteNames.sc189ArenaModeDetail,
      builder: (_, state) => ArenaModeDetailPage(
        modeId: state.pathParameters['modeId'] ?? 'mode001',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/arena/challenge/:challengeId',
      name: AppRouteNames.sc190ArenaChallengeDetail,
      builder: (_, state) => ArenaChallengeDetailPage(
        challengeId: state.pathParameters['challengeId'] ?? 'ch003',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/arena/join/:challengeId',
      name: AppRouteNames.sc191ArenaJoin,
      builder: (_, state) => ArenaJoinPage(
        challengeId: state.pathParameters['challengeId'] ?? 'ch003',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaResolution,
      name: AppRouteNames.sc192ArenaResolutionCenter,
      builder: (_, _) =>
          ArenaResolutionCenterPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/arena/creator/:creatorId',
      name: AppRouteNames.sc193ArenaCreator,
      builder: (_, state) => ArenaCreatorPage(
        creatorId: state.pathParameters['creatorId'] ?? 'cr001',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaLeaderboard,
      name: AppRouteNames.sc194ArenaLeaderboard,
      builder: (_, _) => ArenaLeaderboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaVerified,
      name: AppRouteNames.sc195VerifiedChallenges,
      builder: (_, _) =>
          VerifiedChallengesPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaPoints,
      redirect: (_, _) => '${AppRoutePaths.rewards}?tab=arena',
    ),
  ];
}

List<RouteBase> _arenaExtendedRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.arenaFlowMap,
      name: AppRouteNames.sc197ArenaFlowMap,
      builder: (_, _) => ArenaFlowMapPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaSafety,
      name: AppRouteNames.sc198ArenaSafetyCenter,
      builder: (_, _) =>
          ArenaSafetyCenterPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaBlocked,
      name: AppRouteNames.sc203ArenaBlockedUsers,
      builder: (_, _) =>
          ArenaBlockedUsersPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaMyReports,
      name: AppRouteNames.sc204MyArenaReports,
      builder: (_, _) => MyArenaReportsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaMy,
      name: AppRouteNames.sc205MyArena,
      builder: (_, _) => MyArenaPage(
        contractScope: MyArenaContractScope.arena,
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaProduction,
      name: AppRouteNames.sc206ArenaProductionReady,
      builder: (_, _) =>
          ArenaProductionReadyPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaBridge,
      name: AppRouteNames.sc207ArenaPredictionBridgeFoundation,
      builder: (_, _) =>
          ArenaPredictionBridgeFoundationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.arenaEcosystem,
      name: AppRouteNames.sc208ConnectedEcosystemProduction,
      builder: (_, _) =>
          ConnectedEcosystemProductionPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/arena/trust/:userId',
      name: AppRouteNames.sc199ArenaTrustBreakdown,
      builder: (_, state) => ArenaTrustBreakdownPage(
        entityId: state.pathParameters['userId'] ?? 'user001',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/arena/ledger/entry/:entryId',
      name: AppRouteNames.sc200ArenaPointsEntryDetail,
      builder: (_, state) => ArenaPointsEntryDetailPage(
        entryId: state.pathParameters['entryId'] ?? 'entry001',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaLedger,
      name: AppRouteNames.sc201ArenaPointsLedger,
      builder: (_, _) =>
          ArenaPointsLedgerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/arena/report/:caseId',
      name: AppRouteNames.sc202ArenaReportCase,
      builder: (_, state) => ArenaReportCasePage(
        caseId: state.pathParameters['caseId'] ?? 'case001',
        shellRenderMode: shellRenderMode,
      ),
    ),
  ];
}
