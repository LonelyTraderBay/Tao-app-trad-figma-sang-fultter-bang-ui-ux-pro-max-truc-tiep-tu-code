import 'package:vit_trade_flutter/features/discovery/domain/entities/discovery_entities.dart';

/// Data source contract for the Discovery feature: unified search and
/// topic hub screens.
abstract interface class DiscoveryRepository {
  Future<UnifiedSearchSnapshot> getUnifiedSearch({String query = ''});

  Future<TopicHubSnapshot> getTopicHub({
    String topicId = 'crypto',
    bool detailEndpoint = false,
  });
}
