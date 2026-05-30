import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/rewards/data/providers/rewards_repository_provider.dart';
import 'package:vit_trade_flutter/features/rewards/presentation/controllers/rewards_controller.dart';

export 'package:vit_trade_flutter/features/rewards/presentation/controllers/rewards_controller.dart';

final rewardsControllerProvider = Provider<RewardsController>((ref) {
  return RewardsController(ref.watch(rewardsRepositoryProvider));
});
