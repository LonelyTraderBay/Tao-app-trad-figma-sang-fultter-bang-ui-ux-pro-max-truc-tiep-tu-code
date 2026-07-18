import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/features/markets/data/providers/market_repository_provider.dart';
import 'package:vit_trade_flutter/features/markets/data/repositories/mock_market_repository.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

void main() {
  group('MarketController', () {
    test(
      'exposes core market read models through repository contract',
      () async {
        const controller = MarketController(
          MockMarketRepository(loadDelay: Duration.zero),
        );

        final list = await controller.getMarketList();
        final overview = await controller.getMarketOverview();
        final alerts = await controller.getPriceAlerts();

        expect(list.marketPairs, isNotEmpty);
        expect(list.supportedStates, contains(MarketScreenState.offline));
        expect(overview.globalStats.totalCoins, greaterThan(0));
        expect(alerts.priceAlerts, isNotEmpty);
      },
    );

    test('forwards filter parameters to advanced market read models', () async {
      const controller = MarketController(
        MockMarketRepository(loadDelay: Duration.zero),
      );

      final depth = await controller.getMarketDepth(
        pairId: 'ethusdt',
        levels: 5,
      );
      final news = await controller.getMarketNews(category: 'defi');
      final correlations = await controller.getMarketCorrelations(
        timeframe: MarketCorrelationTimeframe.d30,
      );

      expect(depth.pair.id, 'ethusdt');
      expect(news.news, isNotEmpty);
      expect(correlations.timeframe, MarketCorrelationTimeframe.d30);
    });
  });

  group('MarketListStateController watchlist persist (GĐ4-F1)', () {
    // GD4-F3 (mục 7 GD4-Async-Playbook): override marketRepositoryProvider
    // bằng loadDelay: Duration.zero rồi await snapshot provider .future
    // TRƯỚC KHI đọc state đồng bộ của Notifier.
    test(
      'không có store seed thì favoriteIds giữ hành vi cũ (= snapshot.watchlist)',
      () async {
        final container = ProviderContainer(
          overrides: [
            marketRepositoryProvider.overrideWithValue(
              const MockMarketRepository(loadDelay: Duration.zero),
            ),
          ],
        );
        addTearDown(container.dispose);

        final expected = (await const MarketController(
          MockMarketRepository(loadDelay: Duration.zero),
        ).getMarketList()).watchlist;

        await container.read(marketListSnapshotProvider.future);

        expect(
          container.read(marketListStateControllerProvider).favoriteIds,
          expected,
        );
      },
    );

    test('store seed ghi đè favoriteIds khi build()', () async {
      final container = ProviderContainer(
        overrides: [
          marketRepositoryProvider.overrideWithValue(
            const MockMarketRepository(loadDelay: Duration.zero),
          ),
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

      await container.read(marketListSnapshotProvider.future);

      expect(container.read(marketListStateControllerProvider).favoriteIds, {
        'btc-usdt',
      });
    });

    test('toggleFavorite ghi lại watchlist yêu thích vào store', () async {
      final store = InMemoryKeyValueStore();
      final container = ProviderContainer(
        overrides: [
          marketRepositoryProvider.overrideWithValue(
            const MockMarketRepository(loadDelay: Duration.zero),
          ),
          keyValueStoreProvider.overrideWithValue(store),
        ],
      );
      addTearDown(container.dispose);

      await container.read(marketListSnapshotProvider.future);

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
