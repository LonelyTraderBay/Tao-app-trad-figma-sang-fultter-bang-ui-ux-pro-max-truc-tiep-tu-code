import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:vit_trade_flutter/features/rewards/data/repositories/fail_closed_rewards_repository.dart';
import 'package:vit_trade_flutter/features/rewards/data/repositories/mock_rewards_repository.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>((ref) {
  return guardedRepository(
    ref,
    featureName: 'Rewards',
    mock: () => const MockRewardsRepository(),
    failClosed: () => const FailClosedRewardsRepository(),
  );
});
