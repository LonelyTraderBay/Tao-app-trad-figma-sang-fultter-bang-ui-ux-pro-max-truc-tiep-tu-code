import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';

/// Repository-layer smoke test for [MockTradeCopyTradingRepository] under
/// the `test/features/<feature>/data/` convention (see
/// `test/features/p2p/data/mock_p2p_repository_orders_test.dart`).
///
/// Every method on `TradeCopyTradingRepository` already gets an isA<>
/// smoke pass in the sibling
/// `test/features/trade_copy/mock_trade_copy_repository_test.dart`. This
/// file complements that coverage by pinning concrete, hand-verified
/// values from
/// `lib/features/trade_copy/data/fixtures/trade_copy_provider_discovery_repository_*.dart`
/// so a silent fixture edit shows up as a failing assertion. Every method
/// here is a plain synchronous getter/action — there is no `loadDelay`/
/// `Future` on this mock (unlike some other feature mocks under ADR-001).
///
/// Split by behavior group (mirrors the production repository's own
/// provider-discovery / configuration / lifecycle mixin split): this file
/// covers provider discovery and the provider-application flow. See
/// `mock_trade_copy_repository_configuration_test.dart` for copy
/// configuration/performance surfaces and
/// `mock_trade_copy_repository_lifecycle_test.dart` for lifecycle/safety
/// surfaces (including the `tradeCopy` high-risk contract id).
void main() {
  const repository = MockTradeCopyTradingRepository();

  group(
    'MockTradeCopyTradingRepository provider discovery data smoke test',
    () {
      test('getProviderComparison pins the slot counts and metric count', () {
        final snapshot = repository.getProviderComparison();

        expect(snapshot.selectedCount, 3);
        expect(snapshot.maxProviders, 5);
        expect(snapshot.metrics, hasLength(13));
        expect(snapshot.metrics.first.label, 'Total ROI');
        expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
      });

      test('getProviderLeaderboard pins the sort/risk-filter defaults', () {
        final snapshot = repository.getProviderLeaderboard();

        expect(snapshot.providers, hasLength(5));
        expect(snapshot.providers.first.id, 'ct001');
        expect(snapshot.sortOptions, hasLength(4));
        expect(snapshot.riskFilters, hasLength(4));
        expect(snapshot.defaultSortId, 'roi');
        expect(snapshot.defaultRiskFilterId, 'all');
        expect(snapshot.defaultVerifiedOnly, isFalse);
        expect(snapshot.warningTitle, 'Survivorship Bias Warning');
      });

      test('getProviderGovernance pins the stats and tab/list counts', () {
        final snapshot = repository.getProviderGovernance();

        expect(snapshot.tabs, hasLength(4));
        expect(snapshot.defaultTabId, 'modifications');
        expect(snapshot.stats.followers, 245);
        expect(snapshot.stats.aum, 125000);
        expect(snapshot.stats.complianceScore, 95);
        expect(snapshot.modifications, hasLength(3));
        expect(snapshot.messages, hasLength(2));
        expect(snapshot.feeContributors, hasLength(5));
        expect(snapshot.complianceItems, hasLength(6));
      });

      test('getTraderProfile falls back to the first trader for an unknown '
          'default traderId', () {
        final snapshot = repository.getTraderProfile();

        expect(snapshot.traderId, 'trader001');
        expect(snapshot.trader.id, 'ct001');
        expect(snapshot.trader.name, 'AlphaHunter_VN');
        expect(snapshot.pnlHistory, hasLength(31));
        expect(snapshot.recentTrades, hasLength(5));
        expect(snapshot.defaultTab, 'overview');
      });

      test('getTraderProfile matches an explicit known ct002 trader id', () {
        final snapshot = repository.getTraderProfile(traderId: 'ct002');

        expect(snapshot.traderId, 'ct002');
        expect(snapshot.trader.id, 'ct002');
        expect(snapshot.trader.name, 'SteadyGains_Pro');
        expect(snapshot.trader.winRate, 82.3);
      });

      test(
        'getProviderApplication pins the step/benefit/requirement counts',
        () {
          final snapshot = repository.getProviderApplication();

          expect(snapshot.steps, hasLength(5));
          expect(snapshot.defaultStep, TradeProviderApplicationStep.intro);
          expect(snapshot.benefits, hasLength(3));
          expect(snapshot.requirements, hasLength(4));
          expect(snapshot.responsibilities, hasLength(4));
          expect(snapshot.defaultDraft.hasKyc, isFalse);
          expect(snapshot.defaultDraft.minCapital, 10000);
          expect(snapshot.defaultDraft.performanceFee, 10);
        },
      );

      test('getCopyProviderDetail returns null for the unmatched default '
          'provider001 id', () {
        final snapshot = repository.getCopyProviderDetail();

        expect(snapshot.providerId, 'provider001');
        expect(snapshot.provider, isNull);
        expect(snapshot.isNotFound, isTrue);
      });

      test(
        'getCopyProviderDetail matches an explicit known ct001 provider id',
        () {
          final snapshot = repository.getCopyProviderDetail(
            providerId: 'ct001',
          );

          expect(snapshot.providerId, 'ct001');
          expect(snapshot.provider?.id, 'ct001');
          expect(snapshot.provider?.name, 'AlphaHunter_VN');
          expect(snapshot.isNotFound, isFalse);
        },
      );

      test('getPreCopyAssessment pins the question/education-doc counts', () {
        final snapshot = repository.getPreCopyAssessment(providerId: 'ct001');

        expect(snapshot.providerId, 'ct001');
        expect(snapshot.provider?.id, 'ct001');
        expect(snapshot.questions, hasLength(2));
        expect(snapshot.questions.first.id, 'experience');
        expect(snapshot.questions.first.options, hasLength(4));
        expect(snapshot.educationDocs, hasLength(3));
      });

      test(
        'submitProviderApplication returns the fixed demo application id',
        () {
          final draft = repository.getProviderApplication().defaultDraft;
          final result = repository.submitProviderApplication(draft);

          expect(result.applicationId, 'CPA-069-DEMO');
          expect(result.status, 'submitted');
          expect(result.reviewWindow, '2-3 ngày làm việc');
        },
      );
    },
  );
}
