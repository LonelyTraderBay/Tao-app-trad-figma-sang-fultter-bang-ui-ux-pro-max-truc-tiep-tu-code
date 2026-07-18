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

// GD4 Cụm F5: 27 method đọc của ArenaRepository giờ trả Future<T> (mục 1 —
// GD4-Async-Playbook.md). Mọi trang trước đây gọi
// `ref.watch(arenaReadModelControllerProvider).getX(...)` trực tiếp trong
// `build()` giờ watch 1 trong các FutureProvider dưới đây (mục 3 — provider
// trung gian) rồi bọc `.when()` (mục 5). Không thêm `async`/`await` thừa
// trong callback vì `getX()` đã trả `Future<T>` trực tiếp (mục 4).

final arenaHomeSnapshotProvider = FutureProvider<ArenaHomeSnapshot>((ref) {
  return ref.watch(arenaReadModelControllerProvider).getArenaHome();
});

final arenaStudioSnapshotProvider = FutureProvider<ArenaStudioSnapshot>((ref) {
  return ref.watch(arenaReadModelControllerProvider).getArenaStudio();
});

final arenaSmartRulesSnapshotProvider = FutureProvider<ArenaSmartRulesSnapshot>(
  (ref) {
    return ref.watch(arenaReadModelControllerProvider).getArenaSmartRules();
  },
);

final arenaPresetLibrarySnapshotProvider =
    FutureProvider<ArenaPresetLibrarySnapshot>((ref) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaPresetLibrary();
    });

final arenaGovernanceSnapshotProvider = FutureProvider<ArenaGovernanceSnapshot>(
  (ref) {
    return ref.watch(arenaReadModelControllerProvider).getArenaGovernance();
  },
);

final arenaModeDetailSnapshotProvider =
    FutureProvider.family<ArenaModeDetailSnapshot, String>((ref, modeId) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaModeDetail(modeId);
    });

final arenaChallengeDetailSnapshotProvider =
    FutureProvider.family<ArenaChallengeDetailSnapshot, String>((
      ref,
      challengeId,
    ) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaChallengeDetail(challengeId);
    });

final arenaJoinSnapshotProvider =
    FutureProvider.family<ArenaJoinSnapshot, String>((ref, challengeId) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaJoin(challengeId);
    });

final arenaResolutionCenterSnapshotProvider =
    FutureProvider<ArenaResolutionCenterSnapshot>((ref) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaResolutionCenter();
    });

final arenaCreatorSnapshotProvider =
    FutureProvider.family<ArenaCreatorProfileSnapshot, String>((
      ref,
      creatorId,
    ) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaCreator(creatorId);
    });

final arenaLeaderboardSnapshotProvider =
    FutureProvider<ArenaLeaderboardSnapshot>((ref) {
      return ref.watch(arenaReadModelControllerProvider).getArenaLeaderboard();
    });

final verifiedChallengesSnapshotProvider =
    FutureProvider<VerifiedChallengesSnapshot>((ref) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getVerifiedChallenges();
    });

final arenaPointsSnapshotProvider = FutureProvider<ArenaPointsSnapshot>((ref) {
  return ref.watch(arenaReadModelControllerProvider).getArenaPoints();
});

final arenaFlowMapSnapshotProvider = FutureProvider<ArenaFlowMapSnapshot>((
  ref,
) {
  return ref.watch(arenaReadModelControllerProvider).getArenaFlowMap();
});

final arenaSafetyCenterSnapshotProvider =
    FutureProvider<ArenaSafetyCenterSnapshot>((ref) {
      return ref.watch(arenaReadModelControllerProvider).getArenaSafetyCenter();
    });

final arenaBlockedUsersSnapshotProvider =
    FutureProvider<ArenaBlockedUsersSnapshot>((ref) {
      return ref.watch(arenaReadModelControllerProvider).getArenaBlockedUsers();
    });

final arenaTrustBreakdownSnapshotProvider =
    FutureProvider.family<ArenaTrustBreakdownSnapshot, String>((ref, entityId) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaTrustBreakdown(entityId);
    });

final arenaPointsLedgerSnapshotProvider =
    FutureProvider<ArenaPointsLedgerSnapshot>((ref) {
      return ref.watch(arenaReadModelControllerProvider).getArenaPointsLedger();
    });

final arenaPointsEntryDetailSnapshotProvider =
    FutureProvider.family<ArenaPointsEntryDetailSnapshot, String>((
      ref,
      entryId,
    ) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaPointsEntryDetail(entryId);
    });

final arenaReportCaseSnapshotProvider =
    FutureProvider.family<ArenaReportCaseSnapshot, String>((ref, caseId) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaReportCase(caseId);
    });

final myArenaReportsSnapshotProvider = FutureProvider<MyArenaReportsSnapshot>((
  ref,
) {
  return ref.watch(arenaReadModelControllerProvider).getMyArenaReports();
});

final myArenaSnapshotProvider = FutureProvider<MyArenaSnapshot>((ref) {
  return ref.watch(arenaReadModelControllerProvider).getMyArena();
});

final arenaMySnapshotProvider = FutureProvider<MyArenaSnapshot>((ref) {
  return ref.watch(arenaReadModelControllerProvider).getArenaMy();
});

final arenaProductionReadySnapshotProvider =
    FutureProvider<ArenaProductionReadySnapshot>((ref) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaProductionReady();
    });

final arenaPredictionBridgeSnapshotProvider =
    FutureProvider<ArenaPredictionBridgeSnapshot>((ref) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getArenaPredictionBridge();
    });

final connectedEcosystemProductionSnapshotProvider =
    FutureProvider<ConnectedEcosystemProductionSnapshot>((ref) {
      return ref
          .watch(arenaReadModelControllerProvider)
          .getConnectedEcosystemProduction();
    });

final arenaGuideSnapshotProvider = FutureProvider<ArenaGuideSnapshot>((ref) {
  return ref.watch(arenaReadModelControllerProvider).getArenaGuide();
});

// STATE-S25 (khuôn `home_controller_providers.dart` / wallet's
// `withdrawControllerProvider` — GD4-Async-Playbook.md mục 4): controller
// wrapper thuần đọc dựng lại mỗi lần watch từ 1 snapshot async, không có
// mutation nội bộ. `Provider<AsyncValue<XController>>` + `.whenData()` tránh
// thêm 1 tầng Future/microtask so với `FutureProvider<XController>`, và
// trang vẫn `.when()` giống hệt các snapshot provider khác.

final arenaGovernanceControllerProvider =
    Provider<AsyncValue<ArenaGovernanceController>>((ref) {
      return ref
          .watch(arenaGovernanceSnapshotProvider)
          .whenData(
            (snapshot) => ArenaGovernanceController(
              state: ArenaGovernanceViewState(snapshot: snapshot),
            ),
          );
    });

final arenaJoinControllerProvider =
    Provider.family<AsyncValue<ArenaJoinController>, String>((
      ref,
      challengeId,
    ) {
      return ref
          .watch(arenaJoinSnapshotProvider(challengeId))
          .whenData(
            (snapshot) => ArenaJoinController(
              state: ArenaJoinViewState(snapshot: snapshot),
            ),
          );
    });

final arenaReportCaseControllerProvider =
    Provider.family<AsyncValue<ArenaReportCaseController>, String>((
      ref,
      caseId,
    ) {
      return ref
          .watch(arenaReportCaseSnapshotProvider(caseId))
          .whenData(
            (snapshot) => ArenaReportCaseController(
              state: ArenaReportCaseViewState(snapshot: snapshot),
            ),
          );
    });

final arenaChallengeDetailControllerProvider =
    Provider.family<AsyncValue<ArenaChallengeDetailController>, String>((
      ref,
      challengeId,
    ) {
      return ref
          .watch(arenaChallengeDetailSnapshotProvider(challengeId))
          .whenData(
            (snapshot) => ArenaChallengeDetailController(
              state: ArenaChallengeDetailViewState(snapshot: snapshot),
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

/// GD4 Cụm F5 (khuôn NotificationsStateController / AddressBookStateController
/// — GD4-Async-Playbook.md mục 6, biến thể A): Notifier vẫn SYNC (không đổi
/// sang AsyncNotifier — `unblockUser` chỉ sửa state cục bộ, không gọi lại
/// repo). `build()` lấy snapshot qua `.value` (nullable ở Riverpod 3.x) với
/// fallback rỗng tường minh. Trang PHẢI gate qua
/// `arenaBlockedUsersSnapshotProvider.when()` trước khi đọc Notifier này
/// (bẫy 21) — nên trong luồng UI thật, `.value` không bao giờ null; fallback
/// chỉ chạm tới khi test đọc Notifier trực tiếp trước khi provider async
/// resolve.
final class ArenaBlockedUsersStateController
    extends Notifier<ArenaBlockedUsersViewState> {
  @override
  ArenaBlockedUsersViewState build() {
    final snapshot =
        ref.watch(arenaBlockedUsersSnapshotProvider).value ??
        _emptyArenaBlockedUsersSnapshot;
    return ArenaBlockedUsersViewState.fromSnapshot(snapshot);
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

const _emptyArenaBlockedUsersSnapshot = ArenaBlockedUsersSnapshot(
  endpoint: '/api/mobile/arena/arena-blocked',
  actionDraft: 'POST /arena/challenges|join|resolve|report where applicable',
  bannerTitle: '',
  bannerDescription: '',
  users: [],
  emptyTitle: '',
  emptySubtitle: '',
  disclaimer: '',
  supportedStates: {ArenaScreenState.loading},
);
