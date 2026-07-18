import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/features/markets/data/repositories/mock_market_repository.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

void main() {
  group('MarketController', () {
    test('exposes core market read models through repository contract', () {
      final controller = const MarketController(MockMarketRepository());

      final list = controller.getMarketList();
      final overview = controller.getMarketOverview();
      final alerts = controller.getPriceAlerts();

      expect(list.marketPairs, isNotEmpty);
      expect(list.supportedStates, contains(MarketScreenState.offline));
      expect(overview.globalStats.totalCoins, greaterThan(0));
      expect(alerts.priceAlerts, isNotEmpty);
    });

    test('forwards filter parameters to advanced market read models', () {
      final controller = const MarketController(MockMarketRepository());

      final depth = controller.getMarketDepth(pairId: 'ethusdt', levels: 5);
      final news = controller.getMarketNews(category: 'defi');
      final correlations = controller.getMarketCorrelations(
        timeframe: MarketCorrelationTimeframe.d30,
      );

      expect(depth.pair.id, 'ethusdt');
      expect(news.news, isNotEmpty);
      expect(correlations.timeframe, MarketCorrelationTimeframe.d30);
    });
  });

  group('MarketListStateController watchlist persist (GĐ4-F1)', () {
    test(
      'không có store seed thì favoriteIds giữ hành vi cũ (= snapshot.watchlist)',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final expected = const MarketController(
          MockMarketRepository(),
        ).getMarketList().watchlist;

        expect(
          container.read(marketListStateControllerProvider).favoriteIds,
          expected,
        );
      },
    );

    test('store seed ghi đè favoriteIds khi build()', () {
      final container = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(
            InMemoryKeyValueStore(
              seed: {
                KeyValueStoreKeys.marketWatchlistFavorites: <String>[
                  'btc-usdt',
                ],
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(marketListStateControllerProvider).favoriteIds, {
        'btc-usdt',
      });
    });

    test('toggleFavorite ghi lại watchlist yêu thích vào store', () {
      final store = InMemoryKeyValueStore();
      final container = ProviderContainer(
        overrides: [keyValueStoreProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);

      // btcusdt là favorite mặc định trong fixture — toggle sẽ bỏ yêu thích.
      container
          .read(marketListStateControllerProvider.notifier)
          .toggleFavorite('btcusdt');

      final stored = store.getStringList(
        KeyValueStoreKeys.marketWatchlistFavorites,
      );
      expect(stored, isNotNull);
      expect(stored!.contains('btcusdt'), isFalse);
      expect(
        container.read(marketListStateControllerProvider).favoriteIds,
        isNot(contains('btcusdt')),
      );
    });
  });
}
