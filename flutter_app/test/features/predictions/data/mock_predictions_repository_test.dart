// Direct test for MockPredictionsRepository.
//
// Unlike most mock repositories in this app, predictions has genuine
// business logic worth testing directly: `getHome` and `getSearch` each
// sort their event list by one of 6 different criteria via a switch
// statement (see `_applyFilter` / `_sortSearchEvents` in
// mock_predictions_repository_fixtures_events_and_positions.dart). This
// file covers those two methods (the sort/filter-heavy surface) with
// focused assertions on the real sort/filter behavior.
//
// Split 2026-07-27 (400-line test file size gate,
// Future-Feature-Onboarding-Checklist), by repository-method section —
// mirroring the section naming already used to split the mock repository's
// own fixtures under lib/features/predictions/data/fixtures/. Remaining
// methods moved to:
// - mock_predictions_repository_breaking_and_portfolio_test.dart
//   (getBreaking, getEventDetail, getPortfolio)
// - mock_predictions_repository_leaderboard_and_activity_test.dart
//   (getLeaderboard, getGlobalActivity)
// - mock_predictions_repository_receipts_calendar_and_static_test.dart
//   (getOrderReceipt, getEventCalendar, remaining largely-static getters)
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
  const repository = MockPredictionsRepository(loadDelay: Duration.zero);

  group('MockPredictionsRepository', () {
    group('getHome - 6-criteria filter tab sort', () {
      test(
        'each PredictionFilterTab sorts the 12 active events correctly',
        () async {
          // trending -> descending |change24h|, most volatile first.
          final trending = (await repository.getHome(
            filter: PredictionFilterTab.trending,
          )).events;
          expect(trending, hasLength(12));
          _expectNonIncreasing(trending.map((e) => e.change24h.abs()).toList());
          expect(trending.first.id, 'pred-5');

          // newEvents -> descending createdAt, most recently created first.
          final newEvents = (await repository.getHome(
            filter: PredictionFilterTab.newEvents,
          )).events;
          _expectDatesDescending(newEvents.map((e) => e.createdAt).toList());
          expect(newEvents.first.id, 'pred-10');

          // popular -> descending participants.
          final popular = (await repository.getHome(
            filter: PredictionFilterTab.popular,
          )).events;
          _expectNonIncreasing(popular.map((e) => e.participants).toList());
          expect(popular.first.id, 'pred-4');

          // liquid -> descending liquidity.
          final liquid = (await repository.getHome(
            filter: PredictionFilterTab.liquid,
          )).events;
          _expectNonIncreasing(liquid.map((e) => e.liquidity).toList());
          expect(liquid.first.id, 'pred-1');

          // ending -> ascending endDate, soonest resolution first.
          final ending = (await repository.getHome(
            filter: PredictionFilterTab.ending,
          )).events;
          _expectDatesAscending(ending.map((e) => e.endDate).toList());
          expect(ending.first.endDate, DateTime.utc(2026, 3, 31));
          expect(ending.last.endDate, DateTime.utc(2027, 3, 1));

          // competitive -> ascending |firstOutcomeChance - 50|, closest to a
          // coin-flip first.
          final competitive = (await repository.getHome(
            filter: PredictionFilterTab.competitive,
          )).events;
          _expectNonDecreasing(
            competitive
                .map((e) => (e.outcomes.first.chance - 50).abs())
                .toList(),
          );
          expect(competitive.first.id, 'pred-7');
        },
      );

      test(
        'category filter scopes events; breakingMovers stay unaffected',
        () async {
          final sports = await repository.getHome(category: 'Sports');
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
        },
      );

      test('searchQuery filters by title/category/tag substring', () async {
        final byTitle = await repository.getHome(searchQuery: 'bitcoin');
        expect(byTitle.events, hasLength(1));
        expect(byTitle.events.single.id, 'pred-1');
      });
    });

    group('getSearch - 6-criteria sort, status & category filters', () {
      test(
        'each PredictionSearchSort sorts the active results correctly',
        () async {
          // trending -> descending |change24h|.
          final trending = (await repository.getSearch(
            sort: PredictionSearchSort.trending,
          )).results;
          expect(trending, hasLength(12));
          _expectNonIncreasing(trending.map((e) => e.change24h.abs()).toList());
          expect(trending.first.id, 'pred-5');

          // liquidity -> descending liquidity.
          final liquidity = (await repository.getSearch(
            sort: PredictionSearchSort.liquidity,
          )).results;
          _expectNonIncreasing(liquidity.map((e) => e.liquidity).toList());
          expect(liquidity.first.id, 'pred-1');

          // volume -> descending volume24h.
          final volume = (await repository.getSearch(
            sort: PredictionSearchSort.volume,
          )).results;
          _expectNonIncreasing(volume.map((e) => e.volume24h).toList());
          expect(volume.first.id, 'pred-1');

          // newest -> descending createdAt.
          final newest = (await repository.getSearch(
            sort: PredictionSearchSort.newest,
          )).results;
          _expectDatesDescending(newest.map((e) => e.createdAt).toList());
          expect(newest.first.id, 'pred-10');

          // ending -> ascending endDate.
          final ending = (await repository.getSearch(
            sort: PredictionSearchSort.ending,
          )).results;
          _expectDatesAscending(ending.map((e) => e.endDate).toList());
          expect(ending.first.endDate, DateTime.utc(2026, 3, 31));
          expect(ending.last.endDate, DateTime.utc(2027, 3, 1));

          // competitive -> ascending |firstOutcomeChance - 50|.
          final competitive = (await repository.getSearch(
            sort: PredictionSearchSort.competitive,
          )).results;
          _expectNonDecreasing(
            competitive
                .map((e) => (e.outcomes.first.chance - 50).abs())
                .toList(),
          );
          expect(competitive.first.id, 'pred-7');
        },
      );

      test('status filter scopes to active/resolved/all events', () async {
        expect(
          (await repository.getSearch(
            status: PredictionStatusFilter.active,
          )).results,
          hasLength(12),
        );
        final resolved = (await repository.getSearch(
          status: PredictionStatusFilter.resolved,
        )).results;
        expect(resolved, hasLength(2));
        expect(resolved.map((e) => e.id), containsAll(['pred-r1', 'pred-r2']));
        expect(
          (await repository.getSearch(
            status: PredictionStatusFilter.all,
          )).results,
          hasLength(14),
        );
      });

      test(
        'category filter scopes to matching category (default active)',
        () async {
          final liveCrypto = (await repository.getSearch(
            category: 'Live Crypto',
          )).results;
          expect(liveCrypto, hasLength(4));
          expect(liveCrypto.every((e) => e.category == 'Live Crypto'), isTrue);
          expect(
            liveCrypto.map((e) => e.id),
            containsAll(['pred-1', 'pred-2', 'pred-9', 'pred-12']),
          );
        },
      );

      test('searchQuery matches a tag even when the title does not', () async {
        final results = (await repository.getSearch(
          searchQuery: 'BTC',
        )).results;
        expect(results, hasLength(1));
        expect(results.single.id, 'pred-1');
      });
    });
  });
}
