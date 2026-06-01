import 'package:vit_trade_flutter/app/router/app_router.dart';

import 'app_route_paths_contract_test_utils.dart';

void main() {
  routePathContractTest('defines stable Arena and support route paths', [
    c(AppRoutePaths.supportHelp, '/support/help'),
    c(AppRoutePaths.arena, '/arena'),
    c(AppRoutePaths.arenaGuide, '/arena/guide'),
    c(AppRoutePaths.arenaStudio, '/arena/studio'),
    c(AppRoutePaths.arenaStudioSmartRules, '/arena/studio/smart-rules'),
    c(AppRoutePaths.arenaStudioPresets, '/arena/studio/presets'),
    c(AppRoutePaths.arenaStudioGovernance, '/arena/studio/governance'),
    c(AppRoutePaths.arenaLeaderboard, '/arena/leaderboard'),
    c(AppRoutePaths.arenaPoints, '/arena/points'),
    c(AppRoutePaths.arenaSafety, '/arena/safety'),
    c(AppRoutePaths.arenaBlocked, '/arena/blocked'),
    c(AppRoutePaths.arenaMyReports, '/arena/my-reports'),
    c(AppRoutePaths.arenaMy, '/arena/my'),
    c(AppRoutePaths.arenaProduction, '/arena/production'),
    c(AppRoutePaths.arenaBridge, '/arena/bridge'),
    c(AppRoutePaths.arenaEcosystem, '/arena/ecosystem'),
    c(AppRoutePaths.arenaReportCase('rpt001'), '/arena/report/rpt001'),
    c(AppRoutePaths.arenaLedger, '/arena/ledger'),
    c(AppRoutePaths.arenaLedgerEntry('le001'), '/arena/ledger/entry/le001'),
    c(AppRoutePaths.arenaChallenge('ch003'), '/arena/challenge/ch003'),
    c(AppRoutePaths.arenaMode('mode001'), '/arena/mode/mode001'),
    c(AppRoutePaths.arenaCreator('cr001'), '/arena/creator/cr001'),
  ]);
}
