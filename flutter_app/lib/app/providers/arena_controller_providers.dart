import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/arena/data/providers/arena_repository_provider.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

final arenaReadModelControllerProvider = Provider<ArenaReadModelController>((
  ref,
) {
  return ref.watch(arenaRepositoryProvider);
});

final arenaGovernanceControllerProvider = Provider<ArenaGovernanceController>((
  ref,
) {
  final repository = ref.watch(arenaRepositoryProvider);
  return ArenaGovernanceController(
    state: ArenaGovernanceViewState(snapshot: repository.getArenaGovernance()),
  );
});

final arenaJoinControllerProvider =
    Provider.family<ArenaJoinController, String>((ref, challengeId) {
      final repository = ref.watch(arenaRepositoryProvider);
      return ArenaJoinController(
        state: ArenaJoinViewState(
          snapshot: repository.getArenaJoin(challengeId),
        ),
      );
    });

final arenaReportCaseControllerProvider =
    Provider.family<ArenaReportCaseController, String>((ref, caseId) {
      final repository = ref.watch(arenaRepositoryProvider);
      return ArenaReportCaseController(
        state: ArenaReportCaseViewState(
          snapshot: repository.getArenaReportCase(caseId),
        ),
      );
    });

final arenaChallengeDetailControllerProvider =
    Provider.family<ArenaChallengeDetailController, String>((ref, challengeId) {
      final repository = ref.watch(arenaRepositoryProvider);
      return ArenaChallengeDetailController(
        state: ArenaChallengeDetailViewState(
          snapshot: repository.getArenaChallengeDetail(challengeId),
        ),
      );
    });
