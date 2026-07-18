import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/referral/data/providers/referral_repository_provider.dart';
import 'package:vit_trade_flutter/features/referral/presentation/controllers/referral_controller.dart';

export 'package:vit_trade_flutter/features/referral/presentation/controllers/referral_controller.dart';

final referralControllerProvider = Provider<ReferralController>((ref) {
  return ReferralController(ref.watch(referralRepositoryProvider));
});

// GD4-F5 (mục 3+4 GD4-Async-Playbook): provider trung gian cho mọi snapshot
// referral — trang `.watch()` một trong các provider dưới đây thay vì gọi
// `referralControllerProvider.getX()` trực tiếp trong build() (repo giờ trả
// Future<T>). Đọc thuần → FutureProvider forward thẳng (mục 4); filter/sort/
// search có tham số → FutureProvider.family với record key (scalar-of-scalar,
// tự có value equality — không cần autoDispose theo STATE-S24).

final referralHomeSnapshotProvider = FutureProvider<ReferralHomeSnapshot>(
  (ref) => ref.watch(referralControllerProvider).getHome(),
);

typedef ReferralHistoryQuery = ({
  ReferralFriendFilter filter,
  ReferralHistorySort sort,
  String query,
});

final referralHistorySnapshotProvider =
    FutureProvider.family<ReferralHistorySnapshot, ReferralHistoryQuery>((
      ref,
      query,
    ) {
      return ref
          .watch(referralControllerProvider)
          .getHistory(
            filter: query.filter,
            sort: query.sort,
            query: query.query,
          );
    });

typedef ReferralRewardsQuery = ({
  ReferralRewardFilter filter,
  ReferralRewardSort sort,
});

final referralRewardsSnapshotProvider =
    FutureProvider.family<ReferralRewardsSnapshot, ReferralRewardsQuery>((
      ref,
      query,
    ) {
      return ref
          .watch(referralControllerProvider)
          .getRewards(filter: query.filter, sort: query.sort);
    });

final referralRulesSnapshotProvider = FutureProvider<ReferralRulesSnapshot>(
  (ref) => ref.watch(referralControllerProvider).getRules(),
);

final referralFriendDetailSnapshotProvider =
    FutureProvider.family<ReferralFriendDetailSnapshot, String>(
      (ref, friendId) =>
          ref.watch(referralControllerProvider).getFriendDetail(friendId),
    );
