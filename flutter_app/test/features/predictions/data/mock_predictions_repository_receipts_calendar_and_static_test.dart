// Split from mock_predictions_repository_test.dart 2026-07-27 (400-line test
// file size gate, Future-Feature-Onboarding-Checklist). Covers
// getOrderReceipt, getEventCalendar, and the remaining largely-static
// getters. See mock_predictions_repository_test.dart for the split
// rationale and the other sibling files.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';

void main() {
  const repository = MockPredictionsRepository(loadDelay: Duration.zero);

  group('MockPredictionsRepository', () {
    group('getOrderReceipt - id lookup, found and not-found', () {
      test('known receipt id returns the matching receipt', () async {
        final snapshot = await repository.getOrderReceipt('po-1');
        expect(snapshot.found, isTrue);
        expect(snapshot.receipt, isNotNull);
        expect(snapshot.receipt!.id, 'po-1');
      });

      test(
        'unknown receipt id returns a null receipt without throwing',
        () async {
          final snapshot = await repository.getOrderReceipt('does-not-exist');
          expect(snapshot.found, isFalse);
          expect(snapshot.receipt, isNull);
        },
      );
    });

    group('getEventCalendar - category filter', () {
      test(
        'no category returns all events; category scopes the list',
        () async {
          expect((await repository.getEventCalendar()).events, hasLength(6));
          final crypto = (await repository.getEventCalendar(
            category: 'Crypto',
          )).events;
          expect(crypto, hasLength(2));
          expect(crypto.every((e) => e.category == 'Crypto'), isTrue);
        },
      );
    });

    group('remaining largely-static getters', () {
      test('getRewards / getRiskCalculator / getMarketMaker / '
          'getPortfolioAnalyzer return populated snapshots', () async {
        final rewards = await repository.getRewards();
        expect(rewards, isA<PredictionRewardsSnapshot>());
        expect(rewards.rewards, isNotEmpty);
        expect(rewards.totalDailyPool, greaterThan(0));

        expect(
          await repository.getRiskCalculator(),
          isA<PredictionRiskCalculatorSnapshot>(),
        );

        final marketMaker = await repository.getMarketMaker();
        expect(marketMaker, isA<PredictionMarketMakerSnapshot>());
        expect(marketMaker.positions, isNotEmpty);
        expect(marketMaker.earningsHistory, isNotEmpty);

        final analyzer = await repository.getPortfolioAnalyzer();
        expect(analyzer, isA<PredictionPortfolioAnalyzerSnapshot>());
        expect(analyzer.positions, isNotEmpty);
      });

      test('getSocial / getAdvancedChart / getTournaments / '
          'getDataIntegration return populated snapshots', () async {
        final social = await repository.getSocial();
        expect(social, isA<PredictionSocialSnapshot>());
        expect(social.comments, isNotEmpty);
        expect(social.sentiment, isNotEmpty);

        final chart = await repository.getAdvancedChart('pred-1');
        expect(chart, isA<PredictionAdvancedChartSnapshot>());
        expect(chart.eventId, 'pred-1');
        expect(chart.priceHistory, isNotEmpty);

        final tournaments = await repository.getTournaments();
        expect(tournaments, isA<PredictionTournamentsSnapshot>());
        expect(tournaments.tournaments, isNotEmpty);
        expect(tournaments.leaderboard, isNotEmpty);

        final dataIntegration = await repository.getDataIntegration();
        expect(dataIntegration, isA<PredictionDataIntegrationSnapshot>());
        expect(dataIntegration.sources, isNotEmpty);
        expect(dataIntegration.apiKeys, isNotEmpty);
        expect(dataIntegration.webhooks, isNotEmpty);
      });
    });
  });
}
