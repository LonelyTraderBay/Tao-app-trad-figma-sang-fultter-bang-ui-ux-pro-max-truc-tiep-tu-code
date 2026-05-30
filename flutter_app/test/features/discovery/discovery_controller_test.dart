import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/discovery/data/repositories/mock_discovery_repository.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/controllers/discovery_controller.dart';

void main() {
  group('DiscoveryController', () {
    test('returns unified search snapshots through repository contract', () {
      final controller = DiscoveryController(const MockDiscoveryRepository());

      final empty = controller.unifiedSearch();
      final bitcoin = controller.unifiedSearch(query: ' bitcoin ');

      expect(empty.hasQuery, isFalse);
      expect(bitcoin.query, 'bitcoin');
      expect(bitcoin.results.predictions.map((event) => event.id), ['pred-1']);
      expect(bitcoin.results.tradingPairs.map((pair) => pair.id), ['btcusdt']);
      expect(bitcoin.supportedStates, contains(DiscoveryScreenState.offline));
    });

    test('returns topic snapshots without mixing product boundaries', () {
      final controller = DiscoveryController(const MockDiscoveryRepository());

      final snapshot = controller.topicHub(
        topicId: 'crypto',
        detailEndpoint: true,
      );

      expect(snapshot.endpoint, '/api/mobile/discovery/topic-crypto');
      expect(snapshot.selectedTopic.id, 'crypto');
      expect(snapshot.predictions, isNotEmpty);
      expect(snapshot.arenaRooms, isNotEmpty);
      expect(snapshot.contractNotes, contains('Prediction positions'));
    });
  });
}
