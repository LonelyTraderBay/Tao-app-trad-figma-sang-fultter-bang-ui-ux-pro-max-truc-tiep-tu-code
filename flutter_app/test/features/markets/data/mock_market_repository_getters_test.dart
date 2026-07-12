// Smoke test for the pass-through / parameter-normalization getters on
// MockMarketRepository: overview/list/movers/sectors, pair & token detail,
// and market depth. Most of these are thin builders around static fixture
// data and are covered with compact isA<...>() / non-empty checks.
//
// Split from mock_market_repository_test.dart (Wave 6 behavior-group split,
// zero test-behavior changes) — see mock_market_repository_logic_test.dart
// for the sort/filter-logic-heavy getters (screener, calendar, derivatives,
// social sentiment, portfolio, news, advanced charts, token unlocks, social
// signals, correlations).
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';

void main() {
  const repo = MockMarketRepository();

  group('MockMarketRepository smoke test', () {
    group('overview / list / movers / sectors getters', () {
      test('getMarketList / getMarketOverview', () {
        final list = repo.getMarketList();
        expect(list, isA<MarketListSnapshot>());
        expect(list.marketPairs, hasLength(10));

        final overview = repo.getMarketOverview();
        expect(overview, isA<MarketOverviewSnapshot>());
        expect(overview.sectors, isNotEmpty);
        expect(overview.movers, isNotEmpty);
      });

      test('getMarketMovers / getMarketSectors', () {
        final movers = repo.getMarketMovers();
        expect(movers, isA<MarketMoversSnapshot>());
        expect(movers.movers, isNotEmpty);
        expect(movers.tabs, isNotEmpty);

        final sectors = repo.getMarketSectors();
        expect(sectors, isA<MarketSectorsSnapshot>());
        expect(sectors.sectors, isNotEmpty);
      });

      test(
        'getMarketWatchlist / getMarketHeatmap / getPriceAlerts / getMarketComparison',
        () {
          final watchlist = repo.getMarketWatchlist();
          expect(watchlist, isA<MarketWatchlistSnapshot>());
          expect(watchlist.entries, isNotEmpty);

          final heatmap = repo.getMarketHeatmap();
          expect(heatmap, isA<MarketHeatmapSnapshot>());
          expect(heatmap.coins, isNotEmpty);

          final alerts = repo.getPriceAlerts();
          expect(alerts, isA<MarketAlertsSnapshot>());
          expect(alerts.priceAlerts, isNotEmpty);

          final comparison = repo.getMarketComparison();
          expect(comparison, isA<MarketComparisonSnapshot>());
          expect(comparison.selectedPairIds, ['btcusdt', 'ethusdt']);
        },
      );
    });

    group('pair & token detail getters', () {
      test('getPairDetail returns the matching pair and falls back', () {
        final known = repo.getPairDetail('ethusdt');
        expect(known, isA<MarketPairDetailSnapshot>());
        expect(known.pair.id, 'ethusdt');
        expect(known.depth.bids, hasLength(25));

        final fallback = repo.getPairDetail('does-not-exist');
        expect(fallback.pair.id, 'btcusdt');
      });

      test('getTokenInfo returns fundamentals and falls back to BTC data', () {
        final btc = repo.getTokenInfo('btcusdt');
        expect(btc, isA<MarketTokenInfoSnapshot>());
        expect(btc.fundamentals.symbol, 'BTC');

        // Only 'btcusdt' has fundamentals mapped; every other pair falls
        // back to the BTC fundamentals draft.
        final eth = repo.getTokenInfo('ethusdt');
        expect(eth.pair.id, 'ethusdt');
        expect(eth.fundamentals.symbol, 'BTC');
      });
    });

    group('market depth level normalization', () {
      test('accepts allowed levels and falls back to 25 otherwise', () {
        final defaultDepth = repo.getMarketDepth();
        expect(defaultDepth, isA<MarketDepthSnapshot>());
        expect(defaultDepth.pair.id, 'btcusdt');
        expect(defaultDepth.depth.bids, hasLength(25));

        final level15 = repo.getMarketDepth(levels: 15);
        expect(level15.depth.bids, hasLength(15));
        expect(level15.depth.asks, hasLength(15));

        final level50 = repo.getMarketDepth(pairId: 'ethusdt', levels: 50);
        expect(level50.pair.id, 'ethusdt');
        expect(level50.depth.asks, hasLength(50));

        final invalidLevel = repo.getMarketDepth(levels: 999);
        expect(invalidLevel.depth.bids, hasLength(25));
      });
    });
  });
}
