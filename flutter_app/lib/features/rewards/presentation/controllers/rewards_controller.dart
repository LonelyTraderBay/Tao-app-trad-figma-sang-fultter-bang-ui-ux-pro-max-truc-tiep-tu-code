import 'package:vit_trade_flutter/features/rewards/domain/entities/rewards_entities.dart';
import 'package:vit_trade_flutter/features/rewards/domain/repositories/rewards_repository.dart';

export 'package:vit_trade_flutter/features/rewards/domain/entities/rewards_entities.dart';
export 'package:vit_trade_flutter/features/rewards/domain/repositories/rewards_repository.dart';

final class RewardsController implements RewardsRepository {
  const RewardsController(this._repository);

  final RewardsRepository _repository;

  @override
  RewardsHubSnapshot getHub() {
    return _repository.getHub();
  }
}
