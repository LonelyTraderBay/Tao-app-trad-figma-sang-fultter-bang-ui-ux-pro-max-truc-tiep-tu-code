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
//
// GD4 Cụm F5: base class owns [simulateError] / [loadDelay] + the shared
// [_simulateNetwork] helper — khuôn `_MockTradeRegulatoryRepositoryBase`
// (10 mixin thật sự, không phải 1 mixin duy nhất như wallet's Part01) nên
// helper phải nằm trên kiểu constraint chung để mọi mixin đều thấy được
// (GD4-Async-Playbook.md mục 9, bẫy 12).
abstract class _MockArenaRepositoryBase implements ArenaRepository {
  const _MockArenaRepositoryBase({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  /// When `true`, every method throws a [StateError] after [loadDelay] —
  /// used to exercise error/retry UI states in tests.
  final bool simulateError;

  /// Simulated network latency before a method resolves. Tests should pass
  /// [Duration.zero] to avoid slowing down the suite.
  final Duration loadDelay;

  /// Shared network simulation for every method: awaits [loadDelay], then
  /// throws when [simulateError] is set.
  ///
  /// Delay 0 thì KHÔNG tạo timer — `Future.delayed(Duration.zero)` vẫn là
  /// timer và `tester.pump()` không-duration không đẩy fake clock (GD4
  /// Async Playbook mục 9, bẫy 9.10).
  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) {
      throw StateError('arena_mock_fetch_failed');
    }
  }
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
  const MockArenaRepository({super.simulateError, super.loadDelay});
}

String formatArenaPoints(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toString();
}
