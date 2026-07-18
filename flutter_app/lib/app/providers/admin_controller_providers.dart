import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/admin/data/providers/admin_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/admin/presentation/controllers/admin_controller.dart';

export 'package:vit_trade_flutter/features/admin/presentation/controllers/admin_controller.dart';

final adminHomeSnapshotProvider = FutureProvider<AdminHomeSnapshot>(
  (ref) => ref.watch(data.adminRepositoryProvider).getHome(),
);

final adminAnalyticsSnapshotProvider = FutureProvider<AdminAnalyticsSnapshot>(
  (ref) => ref.watch(data.adminRepositoryProvider).getAnalytics(),
);

final adminAbTestsSnapshotProvider = FutureProvider<AdminAbTestsSnapshot>(
  (ref) => ref.watch(data.adminRepositoryProvider).getAbTests(),
);

final adminFunnelsSnapshotProvider = FutureProvider<AdminFunnelsSnapshot>(
  (ref) => ref.watch(data.adminRepositoryProvider).getFunnels(),
);

// STATE-S25 khuôn (xem GD4-Async-Playbook.md mục 4 "Controller wrapper
// thuần đọc"): 4 controller dưới đây không có mutation nội bộ — chỉ bọc
// AsyncValue quanh phần SEED từ snapshot đọc; consumer widget tự `.when()`
// loading/error/data.

final adminHomeControllerProvider = Provider<AsyncValue<AdminHomeController>>((
  ref,
) {
  return ref
      .watch(adminHomeSnapshotProvider)
      .whenData(
        (snapshot) =>
            AdminHomeController(state: AdminHomeViewState(snapshot: snapshot)),
      );
});

final adminAnalyticsControllerProvider =
    Provider<AsyncValue<AdminAnalyticsController>>((ref) {
      return ref
          .watch(adminAnalyticsSnapshotProvider)
          .whenData(
            (snapshot) => AdminAnalyticsController(
              state: AdminAnalyticsViewState(snapshot: snapshot),
            ),
          );
    });

final adminAbTestsControllerProvider =
    Provider<AsyncValue<AdminAbTestsController>>((ref) {
      return ref
          .watch(adminAbTestsSnapshotProvider)
          .whenData(
            (snapshot) => AdminAbTestsController(
              state: AdminAbTestsViewState(snapshot: snapshot),
            ),
          );
    });

final adminFunnelsControllerProvider =
    Provider<AsyncValue<AdminFunnelsController>>((ref) {
      return ref
          .watch(adminFunnelsSnapshotProvider)
          .whenData(
            (snapshot) => AdminFunnelsController(
              state: AdminFunnelsViewState(snapshot: snapshot),
            ),
          );
    });
