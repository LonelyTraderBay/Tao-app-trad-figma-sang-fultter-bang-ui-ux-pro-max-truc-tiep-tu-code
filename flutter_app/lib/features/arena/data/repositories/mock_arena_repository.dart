import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
import 'package:vit_trade_flutter/features/arena/domain/repositories/arena_repository.dart';

part '../fixtures/arena_connected_guide_repository_methods.dart';
part '../fixtures/arena_creator_trust_repository_methods.dart';
part '../fixtures/arena_flow_map_repository_methods.dart';
part '../fixtures/arena_home_studio_repository_methods.dart';
part '../fixtures/arena_mode_challenge_detail_repository_methods.dart';
part '../fixtures/arena_my_arena_repository_methods.dart';
part '../fixtures/arena_points_repository_methods.dart';
part '../fixtures/arena_production_ecosystem_repository_methods.dart';
part '../fixtures/arena_rule_builder_repository_methods.dart';
part '../fixtures/arena_safety_reports_repository_methods.dart';

// Product boundary sentinels used by copy guardrails:
// Open Arena = Points only. Prediction Markets = Real positions.
// Disallowed bridge shortcut: no_wallet_link. Never merge Points + PnL.
abstract class _MockArenaRepositoryBase implements ArenaRepository {
  const _MockArenaRepositoryBase();
}

final class MockArenaRepository extends _MockArenaRepositoryBase
    with
        _MockArenaRepositoryConnectedGuideMethods,
        _MockArenaRepositoryCreatorTrustMethods,
        _MockArenaRepositoryFlowMapMethods,
        _MockArenaRepositoryHomeStudioMethods,
        _MockArenaRepositoryModeChallengeDetailMethods,
        _MockArenaRepositoryMyArenaMethods,
        _MockArenaRepositoryPointsMethods,
        _MockArenaRepositoryProductionEcosystemMethods,
        _MockArenaRepositoryRuleBuilderMethods,
        _MockArenaRepositorySafetyReportsMethods {
  const MockArenaRepository();
}

String formatArenaPoints(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toString();
}
