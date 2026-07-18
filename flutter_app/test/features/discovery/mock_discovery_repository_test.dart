import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/discovery/data/discovery_repository.dart';

/// Smoke test for [MockDiscoveryRepository]: exercises every method on
/// [DiscoveryRepository] and asserts each call succeeds without throwing and
/// returns a plausible, correctly-typed result.
void main() {
  const repository = MockDiscoveryRepository(loadDelay: Duration.zero);

  group('MockDiscoveryRepository smoke test', () {
    test('getUnifiedSearch with an empty query returns a populated snapshot '
        'with no search results', () async {
      final snapshot = await repository.getUnifiedSearch();

      expect(snapshot, isA<UnifiedSearchSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/discovery/search');
      expect(snapshot.trendingQueries, hasLength(6));
      expect(snapshot.modules, hasLength(3));
      expect(snapshot.results, isA<DiscoverySearchResults>());
      expect(snapshot.results.totalCount, 0);
      expect(snapshot.hasQuery, isFalse);
      expect(
        snapshot.supportedStates,
        contains(DiscoveryScreenState.onlineLive),
      );
    });

    test('getUnifiedSearch with a matching query returns results across '
        'modules', () async {
      final snapshot = await repository.getUnifiedSearch(query: 'bitcoin');

      expect(snapshot.query, 'bitcoin');
      expect(snapshot.hasQuery, isTrue);
      expect(snapshot.results.predictions, hasLength(1));
      expect(snapshot.results.predictions.first.id, 'pred-1');
      expect(snapshot.results.arenaRooms, hasLength(1));
      expect(snapshot.results.arenaRooms.first.id, 'ch003');
      expect(snapshot.results.tradingPairs, hasLength(1));
      expect(snapshot.results.tradingPairs.first.symbol, 'BTC/USDT');
      expect(snapshot.results.totalCount, 3);
    });

    test('getUnifiedSearch does not throw for an unmatched query and falls '
        'back to empty results', () async {
      final snapshot = await repository.getUnifiedSearch(query: 'zzz-no-match');

      expect(snapshot, isA<UnifiedSearchSnapshot>());
      expect(snapshot.results.isEmpty, isTrue);
    });

    test(
      'getTopicHub with defaults returns the crypto topic snapshot',
      () async {
        final snapshot = await repository.getTopicHub();

        expect(snapshot, isA<TopicHubSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/discovery/topics');
        expect(snapshot.topics, hasLength(8));
        expect(snapshot.selectedTopic.id, 'crypto');
        expect(snapshot.predictions, hasLength(5));
        expect(snapshot.arenaRooms, hasLength(2));
        expect(snapshot.arenaModes, hasLength(2));
        expect(snapshot.creators, hasLength(2));
        expect(snapshot.hasContent, isTrue);
      },
    );

    test(
      'getTopicHub with detailEndpoint true uses a topic-scoped endpoint',
      () async {
        final snapshot = await repository.getTopicHub(detailEndpoint: true);

        expect(snapshot.endpoint, '/api/mobile/discovery/topic-crypto');
      },
    );

    test(
      'getTopicHub for a known non-default topic returns its scoped content',
      () async {
        final snapshot = await repository.getTopicHub(topicId: 'macro');

        expect(snapshot.selectedTopic.id, 'macro');
        expect(snapshot.predictions, hasLength(1));
        expect(snapshot.arenaRooms, isEmpty);
        expect(snapshot.arenaModes, isEmpty);
        expect(snapshot.creators, isEmpty);
      },
    );

    test('getTopicHub does not throw for an unrecognized topic id and falls '
        'back to the crypto topic', () async {
      final snapshot = await repository.getTopicHub(topicId: 'does-not-exist');

      expect(snapshot, isA<TopicHubSnapshot>());
      expect(snapshot.selectedTopic.id, 'crypto');
      expect(snapshot.predictions, isNotEmpty);
    });
  });
}
