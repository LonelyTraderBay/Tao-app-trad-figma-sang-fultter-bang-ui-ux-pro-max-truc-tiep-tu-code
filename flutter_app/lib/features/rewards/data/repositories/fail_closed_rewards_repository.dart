import 'package:vit_trade_flutter/features/rewards/domain/entities/rewards_errors.dart';
import 'package:vit_trade_flutter/features/rewards/domain/repositories/rewards_repository.dart';

final class FailClosedRewardsRepository implements RewardsRepository {
  const FailClosedRewardsRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const RewardsBackendContractMissingException();
  }
}
