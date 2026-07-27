// Split from mock_predictions_repository_test.dart 2026-07-27 (400-line test
// file size gate, Future-Feature-Onboarding-Checklist). Covers getBreaking,
// getEventDetail, and getPortfolio. See mock_predictions_repository_test.dart
// for the split rationale and the other sibling files.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';

void main() {
  const repository = MockPredictionsRepository(loadDelay: Duration.zero);

  group('MockPredictionsRepository', () {
    group('getBreaking - active movers, up/down counts, category scope', () {
      test(
        'default returns all 12 active movers sorted by |change24h|',
        () async {
          final snapshot = await repository.getBreaking();
          expect(snapshot.movers, hasLength(12));
          expect(snapshot.movers.first.id, 'pred-5');
          expect(snapshot.upCount, 9);
          expect(snapshot.downCount, 3);
        },
      );

      test(
        'category filter scopes movers and recomputes up/down counts',
        () async {
          final snapshot = await repository.getBreaking(
            category: 'Live Crypto',
          );
          expect(snapshot.movers, hasLength(4));
          expect(snapshot.movers.first.id, 'pred-1');
          expect(snapshot.upCount, 3);
          expect(snapshot.downCount, 1);
        },
      );
    });

    group('getEventDetail - lookup, position enrichment, related events', () {
      test(
        'known id returns event, open position, and related events',
        () async {
          final snapshot = await repository.getEventDetail('pred-1');
          expect(snapshot.event.id, 'pred-1');
          expect(snapshot.position, isNotNull);
          expect(snapshot.position!.outcome, 'Yes');
          expect(snapshot.position!.shares, 500);
          expect(snapshot.position!.avgPrice, .28);
          expect(snapshot.relatedEvents.map((e) => e.id).toList(), [
            'pred-2',
            'pred-9',
          ]);
        },
      );

      test('unknown id falls back to the first fixture event', () async {
        final snapshot = await repository.getEventDetail('does-not-exist');
        expect(snapshot.event.id, 'pred-1');
      });
    });

    group('getPortfolio - aggregate totals summed from positions', () {
      test('totals match the sum/percent of the fixture positions', () async {
        final snapshot = await repository.getPortfolio();
        const invested = 140 + 195 + 76 + 168 + 550 + 112.5 + 105;
        const current = 170 + 216 + 64 + 220 + 1000 + 0 + 117;
        const pnl = 30 + 21 - 12 + 52 + 450 - 112.5 + 12;
        expect(snapshot.totalInvested, closeTo(invested, .001));
        expect(snapshot.totalCurrentValue, closeTo(current, .001));
        expect(snapshot.totalPnl, closeTo(pnl, .001));
        expect(snapshot.totalPnlPct, closeTo(pnl / invested * 100, .001));
      });
    });
  });
}
