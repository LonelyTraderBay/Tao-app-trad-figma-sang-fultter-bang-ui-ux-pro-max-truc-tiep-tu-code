// Direct test for MockPredictionsRepository.
//
// Unlike most mock repositories in this app, predictions has genuine
// business logic worth testing directly: `getHome` and `getSearch` each
// sort their event list by one of 6 different criteria via a switch
// statement (see `_applyFilter` / `_sortSearchEvents` in
// mock_predictions_repository_fixtures_part_01.dart), and several methods
// filter/aggregate over the fixture data (category & status filters, up/down
// counts, portfolio totals, leaderboard re-ranking, activity feed counts).
// This file exercises every method on the PredictionsRepository interface,
// with focused assertions on the real sort/filter/aggregate behavior where
// it exists, and compact isA<>/non-empty checks for the remaining
// largely-static getters.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';

/// Asserts [values] is sorted descending (each value >= the next).
void _expectNonIncreasing(List<num> values) {
  for (var i = 0; i < values.length - 1; i++) {
    expect(
      values[i] >= values[i + 1],
      isTrue,
      reason: 'expected ${values[i]} >= ${values[i + 1]} at index $i',
    );
  }
}

/// Asserts [values] is sorted ascending (each value <= the next).
void _expectNonDecreasing(List<num> values) {
  for (var i = 0; i < values.length - 1; i++) {
    expect(
      values[i] <= values[i + 1],
      isTrue,
      reason: 'expected ${values[i]} <= ${values[i + 1]} at index $i',
    );
  }
}

/// Asserts [dates] is sorted descending (most recent first).
void _expectDatesDescending(List<DateTime> dates) {
  for (var i = 0; i < dates.length - 1; i++) {
    expect(
      dates[i].isBefore(dates[i + 1]),
      isFalse,
      reason: '${dates[i]} should not be before ${dates[i + 1]}',
    );
  }
}

/// Asserts [dates] is sorted ascending (earliest first).
void _expectDatesAscending(List<DateTime> dates) {
  for (var i = 0; i < dates.length - 1; i++) {
    expect(
      dates[i].isAfter(dates[i + 1]),
      isFalse,
      reason: '${dates[i]} should not be after ${dates[i + 1]}',
    );
  }
}

void main() {
  const repository = MockPredictionsRepository();

  group('MockPredictionsRepository', () {
    group('getHome - 6-criteria filter tab sort', () {
      test('each PredictionFilterTab sorts the 12 active events correctly', () {
        // trending -> descending |change24h|, most volatile first.
        final trending = repository
            .getHome(filter: PredictionFilterTab.trending)
            .events;
        expect(trending, hasLength(12));
        _expectNonIncreasing(trending.map((e) => e.change24h.abs()).toList());
        expect(trending.first.id, 'pred-5');

        // newEvents -> descending createdAt, most recently created first.
        final newEvents = repository
            .getHome(filter: PredictionFilterTab.newEvents)
            .events;
        _expectDatesDescending(newEvents.map((e) => e.createdAt).toList());
        expect(newEvents.first.id, 'pred-10');

        // popular -> descending participants.
        final popular = repository
            .getHome(filter: PredictionFilterTab.popular)
            .events;
        _expectNonIncreasing(popular.map((e) => e.participants).toList());
        expect(popular.first.id, 'pred-4');

        // liquid -> descending liquidity.
        final liquid = repository
            .getHome(filter: PredictionFilterTab.liquid)
            .events;
        _expectNonIncreasing(liquid.map((e) => e.liquidity).toList());
        expect(liquid.first.id, 'pred-1');

        // ending -> ascending endDate, soonest resolution first.
        final ending = repository
            .getHome(filter: PredictionFilterTab.ending)
            .events;
        _expectDatesAscending(ending.map((e) => e.endDate).toList());
        expect(ending.first.endDate, DateTime.utc(2026, 3, 31));
        expect(ending.last.endDate, DateTime.utc(2027, 3, 1));

        // competitive -> ascending |firstOutcomeChance - 50|, closest to a
        // coin-flip first.
        final competitive = repository
            .getHome(filter: PredictionFilterTab.competitive)
            .events;
        _expectNonDecreasing(
          competitive.map((e) => (e.outcomes.first.chance - 50).abs()).toList(),
        );
        expect(competitive.first.id, 'pred-7');
      });

      test('category filter scopes events; breakingMovers stay unaffected', () {
        final sports = repository.getHome(category: 'Sports');
        expect(sports.events, hasLength(1));
        expect(sports.events.single.id, 'pred-4');
        // breakingMovers/openPositionCount are computed from the full
        // active dataset, independent of the category/searchQuery filters.
        expect(sports.breakingMovers.map((e) => e.id).toList(), [
          'pred-5',
          'pred-10',
          'pred-1',
        ]);
        expect(sports.openPositionCount, 5);
      });

      test('searchQuery filters by title/category/tag substring', () {
        final byTitle = repository.getHome(searchQuery: 'bitcoin');
        expect(byTitle.events, hasLength(1));
        expect(byTitle.events.single.id, 'pred-1');
      });
    });

    group('getSearch - 6-criteria sort, status & category filters', () {
      test('each PredictionSearchSort sorts the active results correctly', () {
        // trending -> descending |change24h|.
        final trending = repository
            .getSearch(sort: PredictionSearchSort.trending)
            .results;
        expect(trending, hasLength(12));
        _expectNonIncreasing(trending.map((e) => e.change24h.abs()).toList());
        expect(trending.first.id, 'pred-5');

        // liquidity -> descending liquidity.
        final liquidity = repository
            .getSearch(sort: PredictionSearchSort.liquidity)
            .results;
        _expectNonIncreasing(liquidity.map((e) => e.liquidity).toList());
        expect(liquidity.first.id, 'pred-1');

        // volume -> descending volume24h.
        final volume = repository
            .getSearch(sort: PredictionSearchSort.volume)
            .results;
        _expectNonIncreasing(volume.map((e) => e.volume24h).toList());
        expect(volume.first.id, 'pred-1');

        // newest -> descending createdAt.
        final newest = repository
            .getSearch(sort: PredictionSearchSort.newest)
            .results;
        _expectDatesDescending(newest.map((e) => e.createdAt).toList());
        expect(newest.first.id, 'pred-10');

        // ending -> ascending endDate.
        final ending = repository
            .getSearch(sort: PredictionSearchSort.ending)
            .results;
        _expectDatesAscending(ending.map((e) => e.endDate).toList());
        expect(ending.first.endDate, DateTime.utc(2026, 3, 31));
        expect(ending.last.endDate, DateTime.utc(2027, 3, 1));

        // competitive -> ascending |firstOutcomeChance - 50|.
        final competitive = repository
            .getSearch(sort: PredictionSearchSort.competitive)
            .results;
        _expectNonDecreasing(
          competitive.map((e) => (e.outcomes.first.chance - 50).abs()).toList(),
        );
        expect(competitive.first.id, 'pred-7');
      });

      test('status filter scopes to active/resolved/all events', () {
        expect(
          repository.getSearch(status: PredictionStatusFilter.active).results,
          hasLength(12),
        );
        final resolved = repository
            .getSearch(status: PredictionStatusFilter.resolved)
            .results;
        expect(resolved, hasLength(2));
        expect(resolved.map((e) => e.id), containsAll(['pred-r1', 'pred-r2']));
        expect(
          repository.getSearch(status: PredictionStatusFilter.all).results,
          hasLength(14),
        );
      });

      test('category filter scopes to matching category (default active)', () {
        final liveCrypto = repository
            .getSearch(category: 'Live Crypto')
            .results;
        expect(liveCrypto, hasLength(4));
        expect(liveCrypto.every((e) => e.category == 'Live Crypto'), isTrue);
        expect(
          liveCrypto.map((e) => e.id),
          containsAll(['pred-1', 'pred-2', 'pred-9', 'pred-12']),
        );
      });

      test('searchQuery matches a tag even when the title does not', () {
        final results = repository.getSearch(searchQuery: 'BTC').results;
        expect(results, hasLength(1));
        expect(results.single.id, 'pred-1');
      });
    });

    group('getBreaking - active movers, up/down counts, category scope', () {
      test('default returns all 12 active movers sorted by |change24h|', () {
        final snapshot = repository.getBreaking();
        expect(snapshot.movers, hasLength(12));
        expect(snapshot.movers.first.id, 'pred-5');
        expect(snapshot.upCount, 9);
        expect(snapshot.downCount, 3);
      });

      test('category filter scopes movers and recomputes up/down counts', () {
        final snapshot = repository.getBreaking(category: 'Live Crypto');
        expect(snapshot.movers, hasLength(4));
        expect(snapshot.movers.first.id, 'pred-1');
        expect(snapshot.upCount, 3);
        expect(snapshot.downCount, 1);
      });
    });

    group('getEventDetail - lookup, position enrichment, related events', () {
      test('known id returns event, open position, and related events', () {
        final snapshot = repository.getEventDetail('pred-1');
        expect(snapshot.event.id, 'pred-1');
        expect(snapshot.position, isNotNull);
        expect(snapshot.position!.outcome, 'Yes');
        expect(snapshot.position!.shares, 500);
        expect(snapshot.position!.avgPrice, .28);
        expect(snapshot.relatedEvents.map((e) => e.id).toList(), [
          'pred-2',
          'pred-9',
        ]);
      });

      test('unknown id falls back to the first fixture event', () {
        final snapshot = repository.getEventDetail('does-not-exist');
        expect(snapshot.event.id, 'pred-1');
      });
    });

    group('getPortfolio - aggregate totals summed from positions', () {
      test('totals match the sum/percent of the fixture positions', () {
        final snapshot = repository.getPortfolio();
        const invested = 140 + 195 + 76 + 168 + 550 + 112.5 + 105;
        const current = 170 + 216 + 64 + 220 + 1000 + 0 + 117;
        const pnl = 30 + 21 - 12 + 52 + 450 - 112.5 + 12;
        expect(snapshot.totalInvested, closeTo(invested, .001));
        expect(snapshot.totalCurrentValue, closeTo(current, .001));
        expect(snapshot.totalPnl, closeTo(pnl, .001));
        expect(snapshot.totalPnlPct, closeTo(pnl / invested * 100, .001));
      });
    });

    group('getLeaderboard - metric-driven sort and rank reassignment', () {
      test('pnl metric (default) keeps the weekly data in its base order', () {
        final snapshot = repository.getLeaderboard();
        expect(snapshot.traders.first.user, 'WhaleAlpha');
        expect(snapshot.traders.first.rank, 1);
        expect(snapshot.traders[1].user, 'CryptoKing');
        expect(snapshot.biggestWins, hasLength(4));
      });

      test('volume metric re-sorts traders by volume and reassigns rank', () {
        final snapshot = repository.getLeaderboard(
          metric: PredictionLeaderboardMetric.volume,
        );
        _expectNonIncreasing(snapshot.traders.map((t) => t.volume).toList());
        expect(snapshot.traders.first.user, 'AlgoTrader');
        expect(snapshot.traders.first.rank, 1);
        expect(snapshot.traders.first.volume, 320000);
      });
    });

    group('getGlobalActivity - generated feed counts and minAmount filter', () {
      test(
        'default returns 30 activities with a fixed 20/10 buy/sell split',
        () {
          final snapshot = repository.getGlobalActivity();
          expect(snapshot.activities, hasLength(30));
          expect(snapshot.buyCount, 20);
          expect(snapshot.sellCount, 10);
          final recomputedTotal = snapshot.activities.fold<double>(
            0,
            (sum, activity) => sum + activity.amount,
          );
          expect(snapshot.totalVolume, closeTo(recomputedTotal, .01));
        },
      );

      test('minAmount filters the feed but not the buy/sell counts', () {
        final snapshot = repository.getGlobalActivity(minAmount: 100);
        expect(snapshot.activities, isNotEmpty);
        expect(snapshot.activities.length, lessThan(30));
        expect(snapshot.activities.every((a) => a.amount >= 100), isTrue);
        // buyCount/sellCount are computed from the unfiltered feed.
        expect(snapshot.buyCount, 20);
        expect(snapshot.sellCount, 10);
      });
    });

    group('getOrderReceipt - id lookup, found and not-found', () {
      test('known receipt id returns the matching receipt', () {
        final snapshot = repository.getOrderReceipt('po-1');
        expect(snapshot.found, isTrue);
        expect(snapshot.receipt, isNotNull);
        expect(snapshot.receipt!.id, 'po-1');
      });

      test('unknown receipt id returns a null receipt without throwing', () {
        final snapshot = repository.getOrderReceipt('does-not-exist');
        expect(snapshot.found, isFalse);
        expect(snapshot.receipt, isNull);
      });
    });

    group('getEventCalendar - category filter', () {
      test('no category returns all events; category scopes the list', () {
        expect(repository.getEventCalendar().events, hasLength(6));
        final crypto = repository.getEventCalendar(category: 'Crypto').events;
        expect(crypto, hasLength(2));
        expect(crypto.every((e) => e.category == 'Crypto'), isTrue);
      });
    });

    group('remaining largely-static getters', () {
      test('getRewards / getRiskCalculator / getMarketMaker / '
          'getPortfolioAnalyzer return populated snapshots', () {
        final rewards = repository.getRewards();
        expect(rewards, isA<PredictionRewardsSnapshot>());
        expect(rewards.rewards, isNotEmpty);
        expect(rewards.totalDailyPool, greaterThan(0));

        expect(
          repository.getRiskCalculator(),
          isA<PredictionRiskCalculatorSnapshot>(),
        );

        final marketMaker = repository.getMarketMaker();
        expect(marketMaker, isA<PredictionMarketMakerSnapshot>());
        expect(marketMaker.positions, isNotEmpty);
        expect(marketMaker.earningsHistory, isNotEmpty);

        final analyzer = repository.getPortfolioAnalyzer();
        expect(analyzer, isA<PredictionPortfolioAnalyzerSnapshot>());
        expect(analyzer.positions, isNotEmpty);
      });

      test('getSocial / getAdvancedChart / getTournaments / '
          'getDataIntegration return populated snapshots', () {
        final social = repository.getSocial();
        expect(social, isA<PredictionSocialSnapshot>());
        expect(social.comments, isNotEmpty);
        expect(social.sentiment, isNotEmpty);

        final chart = repository.getAdvancedChart('pred-1');
        expect(chart, isA<PredictionAdvancedChartSnapshot>());
        expect(chart.eventId, 'pred-1');
        expect(chart.priceHistory, isNotEmpty);

        final tournaments = repository.getTournaments();
        expect(tournaments, isA<PredictionTournamentsSnapshot>());
        expect(tournaments.tournaments, isNotEmpty);
        expect(tournaments.leaderboard, isNotEmpty);

        final dataIntegration = repository.getDataIntegration();
        expect(dataIntegration, isA<PredictionDataIntegrationSnapshot>());
        expect(dataIntegration.sources, isNotEmpty);
        expect(dataIntegration.apiKeys, isNotEmpty);
        expect(dataIntegration.webhooks, isNotEmpty);
      });
    });
  });
}
