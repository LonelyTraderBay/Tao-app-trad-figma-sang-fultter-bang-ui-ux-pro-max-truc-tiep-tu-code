import 'package:vit_trade_flutter/features/rewards/domain/entities/rewards_entities.dart';

/// Repository contract for fetching the rewards hub's [RewardsHubSnapshot].
abstract interface class RewardsRepository {
  RewardsHubSnapshot getHub();
}
