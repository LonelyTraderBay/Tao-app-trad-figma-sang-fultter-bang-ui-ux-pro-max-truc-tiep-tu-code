import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/arena/data/providers/arena_repository_provider.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_creation_controller.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

export 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_creation_controller.dart';

final arenaReadModelControllerProvider = Provider<ArenaReadModelController>((
  ref,
) {
  return ref.watch(arenaRepositoryProvider);
});

final arenaCreationProvider =
    NotifierProvider<ArenaCreationController, ArenaCreationViewState>(
      ArenaCreationController.new,
    );

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

/// STATE-S23: view-state bất biến của Người đã chặn Open Arena — users sống
/// ở Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class ArenaBlockedUsersViewState {
  const ArenaBlockedUsersViewState({
    required this.snapshot,
    required this.users,
  });

  factory ArenaBlockedUsersViewState.fromSnapshot(
    ArenaBlockedUsersSnapshot snapshot,
  ) {
    return ArenaBlockedUsersViewState(
      snapshot: snapshot,
      users: List.unmodifiable(snapshot.users),
    );
  }

  final ArenaBlockedUsersSnapshot snapshot;
  final List<ArenaBlockedUserDraft> users;

  ArenaBlockedUsersViewState copyWith({List<ArenaBlockedUserDraft>? users}) {
    return ArenaBlockedUsersViewState(
      snapshot: snapshot,
      users: users == null ? this.users : List.unmodifiable(users),
    );
  }
}

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — danh sách
/// chặn giữ nguyên khi điều hướng đi/về trong phiên.
final class ArenaBlockedUsersStateController
    extends Notifier<ArenaBlockedUsersViewState> {
  @override
  ArenaBlockedUsersViewState build() {
    return ArenaBlockedUsersViewState.fromSnapshot(
      ref.watch(arenaReadModelControllerProvider).getArenaBlockedUsers(),
    );
  }

  void unblockUser(String id) {
    state = state.copyWith(
      users: state.users.where((user) => user.id != id).toList(growable: false),
    );
  }
}

final arenaBlockedUsersStateControllerProvider =
    NotifierProvider<
      ArenaBlockedUsersStateController,
      ArenaBlockedUsersViewState
    >(ArenaBlockedUsersStateController.new);
