import 'package:vit_trade_flutter/features/discovery/domain/entities/discovery_entities.dart';
import 'package:vit_trade_flutter/features/discovery/domain/repositories/discovery_repository.dart';

part 'mock_discovery_repository_fixtures.dart';

final class MockDiscoveryRepository implements DiscoveryRepository {
  const MockDiscoveryRepository();

  @override
  UnifiedSearchSnapshot getUnifiedSearch({String query = ''}) {
    final normalizedQuery = query.trim();
    return UnifiedSearchSnapshot(
      endpoint: '/api/mobile/discovery/search',
      actionDraft: 'GET with query filters',
      title: 'Tìm kiếm',
      searchHint: 'Tìm sự kiện, mode, room, creator, coin...',
      staleMessage: 'Mất kết nối. Đang hiển thị dữ liệu gần nhất.',
      staleDetail: 'Cập nhật lần cuối: 2 phút trước',
      trendingQueries: _trendingQueries,
      modules: _modules,
      results: _performSearch(normalizedQuery),
      query: normalizedQuery,
      contractNotes:
          'Discovery-only bridge: Prediction Markets stay wallet/USDT; Open Arena stays Arena Points only.',
      supportedStates: const {
        DiscoveryScreenState.loading,
        DiscoveryScreenState.empty,
        DiscoveryScreenState.error,
        DiscoveryScreenState.offline,
      },
    );
  }

  @override
  TopicHubSnapshot getTopicHub({
    String topicId = 'crypto',
    bool detailEndpoint = false,
  }) {
    final matches = _topics.where((item) => item.id == topicId);
    final topic = matches.isEmpty ? _topics.first : matches.first;
    final content = _topicContent[topic.id] ?? _topicContent['crypto']!;

    return TopicHubSnapshot(
      endpoint: detailEndpoint
          ? '/api/mobile/discovery/topic-${topic.id}'
          : '/api/mobile/discovery/topics',
      actionDraft: 'read-only or local navigation action',
      title: 'Topic Hub',
      searchRoute: '/search',
      predictionsRoute: '/markets/predictions',
      arenaRoute: '/arena',
      createArenaRoute: '/arena/studio',
      staleMessage: 'Mất kết nối. Đang hiển thị dữ liệu gần nhất.',
      staleDetail: 'Cập nhật lần cuối: 2 phút trước',
      topics: _topics,
      selectedTopic: topic,
      predictions: content.predictions,
      arenaRooms: content.arenaRooms,
      arenaModes: content.arenaModes,
      creators: content.creators,
      contractNotes:
          'Topic is discovery context only; Prediction positions and Arena Points remain separate module contracts.',
      supportedStates: const {
        DiscoveryScreenState.loading,
        DiscoveryScreenState.empty,
        DiscoveryScreenState.error,
        DiscoveryScreenState.offline,
      },
    );
  }

  DiscoverySearchResults _performSearch(String query) {
    final q = query.toLowerCase();
    if (q.isEmpty) {
      return const DiscoverySearchResults(
        predictions: [],
        arenaModes: [],
        arenaRooms: [],
        creators: [],
        tradingPairs: [],
      );
    }

    return DiscoverySearchResults(
      predictions: _predictionEvents.where((item) => item.matches(q)).toList(),
      arenaModes: _arenaModes.where((item) => item.matches(q)).toList(),
      arenaRooms: _arenaRooms.where((item) => item.matches(q)).toList(),
      creators: _creators.where((item) => item.matches(q)).toList(),
      tradingPairs: _tradingPairs.where((item) => item.matches(q)).toList(),
    );
  }
}

final class _TopicContentDraft {
  const _TopicContentDraft({
    required this.predictions,
    required this.arenaRooms,
    required this.arenaModes,
    required this.creators,
  });

  final List<DiscoveryPredictionEventDraft> predictions;
  final List<DiscoveryArenaRoomDraft> arenaRooms;
  final List<DiscoveryArenaModeDraft> arenaModes;
  final List<DiscoveryCreatorDraft> creators;
}

extension on DiscoveryPredictionEventDraft {
  bool matches(String query) => _termsMatch(searchTerms, query);
}

extension on DiscoveryArenaModeDraft {
  bool matches(String query) => _termsMatch(searchTerms, query);
}

extension on DiscoveryArenaRoomDraft {
  bool matches(String query) => _termsMatch(searchTerms, query);
}

extension on DiscoveryCreatorDraft {
  bool matches(String query) => _termsMatch(searchTerms, query);
}

extension on DiscoveryTradingPairDraft {
  bool matches(String query) => _termsMatch(searchTerms, query);
}

bool _termsMatch(List<String> terms, String query) {
  return terms.any((term) => term.toLowerCase().contains(query));
}
