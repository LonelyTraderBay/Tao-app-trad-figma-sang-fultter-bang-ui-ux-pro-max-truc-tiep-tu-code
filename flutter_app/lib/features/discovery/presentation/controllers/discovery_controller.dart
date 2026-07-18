import 'package:vit_trade_flutter/features/discovery/domain/entities/discovery_entities.dart';
import 'package:vit_trade_flutter/features/discovery/domain/repositories/discovery_repository.dart';

export 'package:vit_trade_flutter/features/discovery/domain/entities/discovery_entities.dart';
export 'package:vit_trade_flutter/features/discovery/domain/repositories/discovery_repository.dart';

final class DiscoveryController {
  const DiscoveryController(this._repository);

  final DiscoveryRepository _repository;

  Future<UnifiedSearchSnapshot> unifiedSearch({String query = ''}) {
    return _repository.getUnifiedSearch(query: query);
  }

  Future<TopicHubSnapshot> topicHub({
    String topicId = 'crypto',
    bool detailEndpoint = false,
  }) {
    return _repository.getTopicHub(
      topicId: topicId,
      detailEndpoint: detailEndpoint,
    );
  }
}
