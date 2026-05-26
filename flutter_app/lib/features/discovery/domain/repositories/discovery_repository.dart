import 'package:vit_trade_flutter/features/discovery/domain/entities/discovery_entities.dart';

abstract interface class DiscoveryRepository {
  UnifiedSearchSnapshot getUnifiedSearch({String query = ''});

  TopicHubSnapshot getTopicHub({
    String topicId = 'crypto',
    bool detailEndpoint = false,
  });
}
