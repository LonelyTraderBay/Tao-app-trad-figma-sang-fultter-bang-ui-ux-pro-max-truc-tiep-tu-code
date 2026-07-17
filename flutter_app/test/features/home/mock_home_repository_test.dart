import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';

/// Smoke test for [MockHomeRepository]: exercises every method on
/// [HomeRepository] and asserts each call succeeds without throwing and
/// returns a plausible, non-empty result.
void main() {
  const repository = MockHomeRepository(loadDelay: Duration.zero);

  group('MockHomeRepository smoke test', () {
    test('fetchHome returns a populated snapshot', () async {
      final snapshot = await repository.fetchHome();

      expect(snapshot, isA<HomeSnapshot>());
      expect(snapshot.totalBalance, greaterThan(0));
      expect(snapshot.totalBtc, greaterThan(0));
      expect(snapshot.spotBalance, greaterThan(0));
      expect(snapshot.earnBalance, greaterThan(0));
      expect(snapshot.fundingBalance, greaterThan(0));
      expect(snapshot.portfolioTrend7d, isNotEmpty);
      expect(snapshot.notifications, greaterThanOrEqualTo(0));
      expect(snapshot.announcements, isNotEmpty);
      expect(snapshot.quickActions, isNotEmpty);
      expect(snapshot.nextAction, isNotNull);
      expect(snapshot.recentProducts, isNotEmpty);
      expect(snapshot.pairs, isNotEmpty);
    });

    test('fetchHome announcements carry a display-ready type and route', () {
      return repository.fetchHome().then((snapshot) {
        final announcement = snapshot.announcements.first;

        expect(announcement, isA<HomeAnnouncement>());
        expect(announcement.id, isNotEmpty);
        expect(announcement.text, isNotEmpty);
        expect(announcement.type, isA<HomeAnnouncementType>());
      });
    });

    test('fetchHome quick actions and recent products resolve routes', () {
      return repository.fetchHome().then((snapshot) {
        final quickAction = snapshot.quickActions.first;
        expect(quickAction, isA<HomeQuickAction>());
        expect(quickAction.routePath, startsWith('/'));

        final recentProduct = snapshot.recentProducts.first;
        expect(recentProduct, isA<HomeRecentProduct>());
        expect(recentProduct.routePath, startsWith('/'));

        final pair = snapshot.pairs.first;
        expect(pair, isA<HomeCryptoPair>());
        expect(pair.symbol, isNotEmpty);
        expect(pair.sparkline, isNotEmpty);
      });
    });

    test('fetchHome throws when simulateError is set', () {
      const errorRepository = MockHomeRepository(
        simulateError: true,
        loadDelay: Duration.zero,
      );

      expect(errorRepository.fetchHome(), throwsA(isA<StateError>()));
    });
  });
}
