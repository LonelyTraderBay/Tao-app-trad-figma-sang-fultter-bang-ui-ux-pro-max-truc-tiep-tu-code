import 'package:vit_trade_flutter/features/discovery/domain/entities/discovery_entities.dart';

/// Data source contract for the Discovery feature: unified search and
/// topic hub screens.
abstract interface class DiscoveryRepository {
  UnifiedSearchSnapshot getUnifiedSearch({String query = ''});

  TopicHubSnapshot getTopicHub({
    String topicId = 'crypto',
    bool detailEndpoint = false,
  });
}
