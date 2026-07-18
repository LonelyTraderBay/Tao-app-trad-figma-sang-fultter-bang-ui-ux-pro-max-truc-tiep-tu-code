import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/rewards/data/providers/rewards_repository_provider.dart';
import 'package:vit_trade_flutter/features/rewards/presentation/controllers/rewards_controller.dart';

export 'package:vit_trade_flutter/features/rewards/presentation/controllers/rewards_controller.dart';

final rewardsControllerProvider = Provider<RewardsController>((ref) {
  return RewardsController(ref.watch(rewardsRepositoryProvider));
});

// GD4-F5 (mục 3+4 GD4-Async-Playbook): provider trung gian cho rewards hub —
// trang `.watch()` provider này thay vì gọi `rewardsControllerProvider.getHub()`
// trực tiếp trong build() (repo giờ trả Future<T>).
final rewardsHubSnapshotProvider = FutureProvider<RewardsHubSnapshot>(
  (ref) => ref.watch(rewardsControllerProvider).getHub(),
);
