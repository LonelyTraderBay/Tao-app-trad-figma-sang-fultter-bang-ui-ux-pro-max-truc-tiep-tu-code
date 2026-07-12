// Logic test for the MockMarketRepository methods that contain real
// sort/filter logic: screener, calendar, derivatives, social sentiment,
// portfolio, news, advanced charts, token unlocks, social signals, and
// correlations. These assert the actual comparator direction and filtered
// subset against known fixture values (as opposed to the thin pass-through
// getters, which only get compact isA<...>() / non-empty checks).
//
// Split from mock_market_repository_test.dart (Wave 6 behavior-group split,
// zero test-behavior changes) — see mock_market_repository_getters_test.dart
// for the overview/list/movers/sectors, pair & token detail, and market
// depth getters.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';

void main() {
  const repo = MockMarketRepository();

  group('MockMarketRepository smoke test', () {
    group('screener sort & filter logic', () {
      test('default query sorts by marketCap desc', () {
        final snapshot = repo.getMarketScreener();
        expect(snapshot, isA<MarketScreenerSnapshot>());
        expect(snapshot.appliedQuery.sortBy, MarketScreenerSort.marketCap);
        expect(snapshot.appliedQuery.sortDirection, MarketSortDirection.desc);
        expect(snapshot.marketPairs[0].id, 'btcusdt');
        expect(snapshot.marketPairs[1].id, 'ethusdt');
      });

      test('searchQuery filters by baseAsset/symbol substring', () {
        final result = repo.getMarketScreener(
          query: const MarketScreenerQuery(searchQuery: 'sol'),
        );
        expect(result.marketPairs, hasLength(1));
        expect(result.marketPairs.single.id, 'solusdt');
      });

      test('categories filter narrows to matching category', () {
        final result = repo.getMarketScreener(
          query: const MarketScreenerQuery(categories: ['DeFi']),
        );
        expect(result.marketPairs.map((p) => p.id), ['dotusdt', 'linkusdt']);
      });

      test('minPrice filters out pairs below the threshold', () {
        final result = repo.getMarketScreener(
          query: const MarketScreenerQuery(minPrice: 100),
        );
        expect(result.marketPairs, hasLength(4));
        expect(result.marketPairs.every((p) => p.price >= 100), isTrue);
      });

      test('sortDirection reverses the change24h ordering', () {
        final asc = repo.getMarketScreener(
          query: const MarketScreenerQuery(
            sortBy: MarketScreenerSort.change24h,
            sortDirection: MarketSortDirection.asc,
          ),
        );
        expect(asc.marketPairs[0].id, 'linkusdt');
        expect(asc.marketPairs[1].id, 'dotusdt');

        final desc = repo.getMarketScreener(
          query: const MarketScreenerQuery(
            sortBy: MarketScreenerSort.change24h,
            sortDirection: MarketSortDirection.desc,
          ),
        );
        expect(desc.marketPairs[0].id, 'solusdt');
        expect(desc.marketPairs[1].id, 'maticusdt');
      });
    });

    group('calendar sort & filter logic', () {
      test('default query returns all events sorted by date ascending', () {
        final snapshot = repo.getMarketCalendar();
        expect(snapshot, isA<MarketCalendarSnapshot>());
        expect(snapshot.events, hasLength(12));
        expect(snapshot.events[0].id, 'ev7');
        expect(snapshot.events[1].id, 'ev1');
      });

      test('type filter narrows and preserves date ordering', () {
        final result = repo.getMarketCalendar(
          query: const MarketCalendarQuery(
            type: MarketCalendarEventType.unlock,
          ),
        );
        expect(result.events.map((e) => e.id), ['ev1', 'ev6', 'ev9']);
      });

      test('impact filter narrows to high-impact events', () {
        final result = repo.getMarketCalendar(
          query: const MarketCalendarQuery(impact: MarketCalendarImpact.high),
        );
        expect(result.events, hasLength(6));
        expect(result.events[0].id, 'ev1');
        expect(result.events[1].id, 'ev11');
      });
    });

    group('derivatives sort logic', () {
      test('every MarketDerivativesSort criterion orders correctly', () {
        final byOi = repo.getMarketDerivatives();
        expect(byOi, isA<MarketDerivativesSnapshot>());
        expect(byOi.pairs[0].id, 'btc-perp');
        expect(byOi.pairs[1].id, 'eth-perp');

        final byVolume = repo.getMarketDerivatives(
          sortBy: MarketDerivativesSort.volume,
        );
        expect(byVolume.pairs[0].id, 'btc-perp');
        expect(byVolume.pairs[1].id, 'eth-perp');

        // Funding and change sort by absolute value and diverge from the
        // OI/volume ranking (and from each other).
        final byFunding = repo.getMarketDerivatives(
          sortBy: MarketDerivativesSort.funding,
        );
        expect(byFunding.pairs[0].id, 'doge-perp');
        expect(byFunding.pairs[1].id, 'sol-perp');

        final byChange = repo.getMarketDerivatives(
          sortBy: MarketDerivativesSort.change,
        );
        expect(byChange.pairs[0].id, 'sol-perp');
        expect(byChange.pairs[1].id, 'doge-perp');
      });
    });

    group('social sentiment sort logic', () {
      test('every MarketSentimentSort criterion orders correctly', () {
        final bySentiment = repo.getSocialSentiment();
        expect(bySentiment, isA<MarketSocialSentimentSnapshot>());
        expect(bySentiment.tokens[0].id, 'sol');
        expect(bySentiment.tokens[1].id, 'btc');

        final byMentions = repo.getSocialSentiment(
          sortBy: MarketSentimentSort.mentions,
        );
        expect(byMentions.tokens[0].id, 'btc');
        expect(byMentions.tokens[1].id, 'sol');

        final byTrending = repo.getSocialSentiment(
          sortBy: MarketSentimentSort.trending,
        );
        expect(byTrending.tokens[0].id, 'btc');
        expect(byTrending.tokens[1].id, 'sol');
        expect(byTrending.tokens[2].id, 'eth');
        expect(byTrending.tokens[3].id, 'doge');

        expect(bySentiment.trendingTokens, hasLength(4));
        expect(bySentiment.trendingTokens[0].id, 'btc');
        expect(bySentiment.trendingTokens[1].id, 'sol');
      });
    });

    group('portfolio sort logic', () {
      test('every MarketPortfolioSort criterion orders correctly', () {
        final byValue = repo.getPortfolioTracker();
        expect(byValue, isA<MarketPortfolioSnapshot>());
        expect(byValue.holdings[0].id, 'btc');
        expect(byValue.holdings[1].id, 'usdt');
        expect(byValue.holdings[2].id, 'eth');

        final byPnl = repo.getPortfolioTracker(sortBy: MarketPortfolioSort.pnl);
        expect(byPnl.holdings[0].id, 'sol');
        expect(byPnl.holdings[1].id, 'ada');

        final byChange = repo.getPortfolioTracker(
          sortBy: MarketPortfolioSort.change,
        );
        expect(byChange.holdings[0].id, 'sol');
        expect(byChange.holdings[1].id, 'bnb');
      });
    });

    group('market news filter logic', () {
      test('category=all / breaking / specific category', () {
        final all = repo.getMarketNews();
        expect(all, isA<MarketNewsSnapshot>());
        expect(all.news, hasLength(12));
        expect(all.breakingNews, hasLength(1));
        expect(all.breakingNews.single.id, 'n1');

        final breaking = repo.getMarketNews(category: 'breaking');
        expect(breaking.news, hasLength(1));
        expect(breaking.news.single.id, 'n1');

        final bitcoin = repo.getMarketNews(category: 'bitcoin');
        expect(bitcoin.news.map((n) => n.id), ['n1', 'n9']);
      });

      test('sentiment filter combines with category filter', () {
        final bearish = repo.getMarketNews(
          sentiment: MarketNewsSentiment.bearish,
        );
        expect(bearish.news.map((n) => n.id), ['n5', 'n9']);

        final altcoinBullish = repo.getMarketNews(
          category: 'altcoin',
          sentiment: MarketNewsSentiment.bullish,
        );
        expect(altcoinBullish.news, hasLength(3));
      });
    });

    group('advanced charts category filter logic', () {
      test('indicatorCategory and drawingCategory narrow independently', () {
        final all = repo.getAdvancedCharts();
        expect(all, isA<MarketAdvancedChartsSnapshot>());
        expect(all.indicators, hasLength(10));
        expect(all.drawingTools, hasLength(12));

        final trend = repo.getAdvancedCharts(indicatorCategory: 'trend');
        expect(trend.indicators.map((i) => i.id), ['sma', 'ema', 'ichimoku']);

        final line = repo.getAdvancedCharts(drawingCategory: 'line');
        expect(line.drawingTools.map((t) => t.id), [
          'trendline',
          'hline',
          'channel',
          'ray',
        ]);
      });
    });

    group('token unlocks sort & filter logic', () {
      test('every MarketUnlockSort criterion orders correctly', () {
        final byNearest = repo.getTokenUnlocks();
        expect(byNearest, isA<MarketTokenUnlocksSnapshot>());
        expect(byNearest.unlocks.map((u) => u.id), [
          'u3',
          'u1',
          'u2',
          'u5',
          'u4',
          'u6',
        ]);
        expect(byNearest.highImpactCount, 3);
        expect(byNearest.totalValueNext30d, closeTo(612445000, 1));
        expect(byNearest.avgDilution, closeTo(3.8833, .001));

        final byValue = repo.getTokenUnlocks(sortBy: MarketUnlockSort.value);
        expect(byValue.unlocks[0].id, 'u5');
        expect(byValue.unlocks[1].id, 'u1');

        final byImpact = repo.getTokenUnlocks(sortBy: MarketUnlockSort.impact);
        expect(byImpact.unlocks[0].id, 'u5');
        expect(byImpact.unlocks[1].id, 'u6');
      });

      test('impactFilter narrows and re-sorts by the active sortBy', () {
        final highImpact = repo.getTokenUnlocks(
          impactFilter: MarketUnlockImpact.high,
        );
        expect(highImpact.unlocks.map((u) => u.id), ['u3', 'u1', 'u5']);

        final mediumImpact = repo.getTokenUnlocks(
          impactFilter: MarketUnlockImpact.medium,
        );
        expect(mediumImpact.unlocks.map((u) => u.id), ['u2', 'u4', 'u6']);

        final lowImpact = repo.getTokenUnlocks(
          impactFilter: MarketUnlockImpact.low,
        );
        expect(lowImpact.unlocks, isEmpty);
      });
    });

    group('social signals filter logic', () {
      test('statusFilter and categoryFilter narrow independently', () {
        final all = repo.getSocialSignals();
        expect(all, isA<MarketSocialSignalsSnapshot>());
        expect(all.signals, hasLength(7));
        expect(all.totalSignals, 7);
        expect(all.hitSignals, 1);
        expect(all.stoppedSignals, 1);
        expect(all.overallWinRate, closeTo(50, .01));

        final active = repo.getSocialSignals(
          statusFilter: TradingSignalStatus.active,
        );
        expect(active.signals, hasLength(5));

        final swing = repo.getSocialSignals(
          categoryFilter: TradingSignalCategory.swing,
        );
        expect(swing.signals, hasLength(5));
      });

      test('combined statusFilter + categoryFilter applies AND logic', () {
        final activeSwing = repo.getSocialSignals(
          statusFilter: TradingSignalStatus.active,
          categoryFilter: TradingSignalCategory.swing,
        );
        expect(activeSwing.signals.map((s) => s.id), ['s1', 's2', 's5']);
      });
    });

    group('market correlations sort logic', () {
      test('sortOrder controls high/low ranking per timeframe', () {
        final high7d = repo.getMarketCorrelations();
        expect(high7d, isA<MarketCorrelationsSnapshot>());
        expect(high7d.pairs, hasLength(28));
        expect(high7d.pairs[0].assetA, 'BTC');
        expect(high7d.pairs[0].assetB, 'ETH');
        expect(high7d.pairs[0].correlation7d, closeTo(0.92, .001));

        final low7d = repo.getMarketCorrelations(
          sortOrder: CorrelationSortOrder.low,
        );
        expect(low7d.pairs[0].assetA, 'XRP');
        expect(low7d.pairs[0].assetB, 'LINK');

        final high30d = repo.getMarketCorrelations(
          timeframe: MarketCorrelationTimeframe.d30,
        );
        expect(high30d.pairs[0].assetA, 'BTC');
        expect(high30d.pairs[0].assetB, 'ETH');
      });
    });
  });
}
