// Split from mock_predictions_repository_test.dart 2026-07-27 (400-line test
// file size gate, Future-Feature-Onboarding-Checklist). Covers
// getLeaderboard and getGlobalActivity. See
// mock_predictions_repository_test.dart for the split rationale and the
// other sibling files.
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

void main() {
  const repository = MockPredictionsRepository(loadDelay: Duration.zero);

  group('MockPredictionsRepository', () {
    group('getLeaderboard - metric-driven sort and rank reassignment', () {
      test(
        'pnl metric (default) keeps the weekly data in its base order',
        () async {
          final snapshot = await repository.getLeaderboard();
          expect(snapshot.traders.first.user, 'WhaleAlpha');
          expect(snapshot.traders.first.rank, 1);
          expect(snapshot.traders[1].user, 'CryptoKing');
          expect(snapshot.biggestWins, hasLength(4));
        },
      );

      test(
        'volume metric re-sorts traders by volume and reassigns rank',
        () async {
          final snapshot = await repository.getLeaderboard(
            metric: PredictionLeaderboardMetric.volume,
          );
          _expectNonIncreasing(snapshot.traders.map((t) => t.volume).toList());
          expect(snapshot.traders.first.user, 'AlgoTrader');
          expect(snapshot.traders.first.rank, 1);
          expect(snapshot.traders.first.volume, 320000);
        },
      );
    });

    group('getGlobalActivity - generated feed counts and minAmount filter', () {
      test(
        'default returns 30 activities with a fixed 20/10 buy/sell split',
        () async {
          final snapshot = await repository.getGlobalActivity();
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

      test('minAmount filters the feed but not the buy/sell counts', () async {
        final snapshot = await repository.getGlobalActivity(minAmount: 100);
        expect(snapshot.activities, isNotEmpty);
        expect(snapshot.activities.length, lessThan(30));
        expect(snapshot.activities.every((a) => a.amount >= 100), isTrue);
        // buyCount/sellCount are computed from the unfiltered feed.
        expect(snapshot.buyCount, 20);
        expect(snapshot.sellCount, 10);
      });
    });
  });
}
