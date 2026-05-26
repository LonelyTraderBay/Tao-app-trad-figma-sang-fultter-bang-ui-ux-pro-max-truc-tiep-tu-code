import 'package:vit_trade_flutter/features/rewards/domain/entities/rewards_entities.dart';

abstract interface class RewardsRepository {
  RewardsHubSnapshot getHub();
}
