import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';

/// Smoke test for the core staking mocks: exercises
/// [MockStakingEarnRepository], [MockStakingTermsRepository],
/// [MockStakingRiskDisclosureRepository],
/// [MockStakingWithdrawalPolicyRepository], [MockStakingTaxGuideRepository],
/// [MockStakingRiskAssessmentRepository], [MockStakingDashboardRepository],
/// [MockStakingAnalyticsRepository], [MockStakingHistoryRepository],
/// [MockStakingEarningsCalendarRepository],
/// [MockStakingValidatorSelectionRepository],
/// [MockStakingAutoCompoundRepository], and
/// [MockStakingLiquidStakingRepository], asserting each call succeeds
/// without throwing and returns a plausible, non-empty result.
void main() {
  const stakingEarnRepo = MockStakingEarnRepository();
  const termsRepo = MockStakingTermsRepository();
  const riskDisclosureRepo = MockStakingRiskDisclosureRepository();
  const withdrawalPolicyRepo = MockStakingWithdrawalPolicyRepository();
  const taxGuideRepo = MockStakingTaxGuideRepository();
  const riskAssessmentRepo = MockStakingRiskAssessmentRepository();
  const dashboardRepo = MockStakingDashboardRepository();
  const analyticsRepo = MockStakingAnalyticsRepository();
  const historyRepo = MockStakingHistoryRepository();
  const calendarRepo = MockStakingEarningsCalendarRepository();
  const validatorSelectionRepo = MockStakingValidatorSelectionRepository();
  const autoCompoundRepo = MockStakingAutoCompoundRepository();
  const liquidStakingRepo = MockStakingLiquidStakingRepository();

  group('MockEarnRepository staking core smoke test', () {
    test(
      'getStakingEarn returns a populated snapshot for the default route',
      () async {
        final snapshot = await stakingEarnRepo.getStakingEarn();

        expect(snapshot, isA<StakingEarnSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/earn/earn');
        expect(snapshot.title, isNotEmpty);
        expect(snapshot.products, hasLength(6));
        expect(snapshot.products.first.id, 'btc-fixed-90');
        expect(snapshot.positions, hasLength(2));
        expect(snapshot.positions.first.id, 'p1');
        expect(snapshot.estimatedIncome, isNotEmpty);
        expect(snapshot.highRiskContractId, 'earn_savings_staking');
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test('getStakingEarn scopes the endpoint to the staking route', () async {
      final snapshot = await stakingEarnRepo.getStakingEarn(
        route: StakingEarnRoute.staking,
      );

      expect(snapshot.endpoint, '/api/mobile/earn/earn-staking');
    });

    test('getTerms returns a populated staking terms snapshot', () async {
      final snapshot = await termsRepo.getTerms();

      expect(snapshot, isA<StakingTermsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.title, isNotEmpty);
      expect(snapshot.version, '2.1');
      expect(snapshot.sections, hasLength(15));
      expect(snapshot.acceptanceText, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test(
      'getDisclosure returns a populated risk disclosure snapshot',
      () async {
        final snapshot = await riskDisclosureRepo.getDisclosure();

        expect(snapshot, isA<StakingRiskDisclosureSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.defaultTab, 'overview');
        expect(snapshot.tabs, hasLength(3));
        expect(snapshot.riskCounts, hasLength(3));
        expect(snapshot.products, hasLength(3));
        expect(snapshot.categories, hasLength(7));
        expect(snapshot.faqs, hasLength(4));
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test('getPolicy returns a populated withdrawal policy snapshot', () async {
      final snapshot = await withdrawalPolicyRepo.getPolicy();

      expect(snapshot, isA<StakingWithdrawalPolicySnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.defaultTab, 'timeline');
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.processSteps, hasLength(4));
      expect(snapshot.timelines, hasLength(6));
      expect(snapshot.penaltyRules, hasLength(3));
      expect(snapshot.penaltyExamples, hasLength(2));
      expect(snapshot.emergencySteps, hasLength(5));
      expect(snapshot.emergencyFees, hasLength(4));
      expect(snapshot.supportContacts, hasLength(3));
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getGuide (tax) returns a populated tax guide snapshot', () async {
      final snapshot = await taxGuideRepo.getGuide();

      expect(snapshot, isA<StakingTaxGuideSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.defaultTab, 'overview');
      expect(snapshot.tabs, hasLength(3));
      expect(snapshot.incomeEvents, hasLength(2));
      expect(snapshot.countrySummaries, hasLength(5));
      expect(snapshot.jurisdictions, hasLength(6));
      expect(snapshot.faqs, hasLength(4));
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test(
      'getRiskAssessment returns a populated risk assessment snapshot',
      () async {
        final snapshot = await riskAssessmentRepo.getRiskAssessment();

        expect(snapshot, isA<StakingRiskAssessmentSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.questions, hasLength(7));
        expect(snapshot.results, hasLength(3));
        expect(
          snapshot.results.first.level,
          StakingRiskProfileLevel.conservative,
        );
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getDashboard returns a populated staking dashboard snapshot',
      () async {
        final snapshot = await dashboardRepo.getDashboard();

        expect(snapshot, isA<StakingDashboardSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.totalStakedUsd, 17577);
        expect(snapshot.activePositions, 3);
        expect(snapshot.maturingSoon, 2);
        expect(snapshot.performance, hasLength(6));
        expect(snapshot.allocations, hasLength(5));
        expect(snapshot.positions, hasLength(5));
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getAnalytics returns a populated staking analytics snapshot',
      () async {
        final snapshot = await analyticsRepo.getAnalytics();

        expect(snapshot, isA<StakingAnalyticsSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.defaultTab, 'earnings');
        expect(snapshot.tabs, hasLength(4));
        expect(snapshot.summary.totalEarned, 315.82);
        expect(snapshot.earningsBreakdown, hasLength(6));
        expect(snapshot.apyTrends, hasLength(6));
        expect(snapshot.roiComparison, hasLength(6));
        expect(snapshot.productPerformance, hasLength(5));
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test('getHistory returns a populated staking history snapshot', () async {
      final snapshot = await historyRepo.getHistory();

      expect(snapshot, isA<StakingHistorySnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.totalStakedUsd, 17577);
      expect(snapshot.transactions, hasLength(12));
      expect(snapshot.transactions.first.id, 'tx1');
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test(
      'getCalendar returns a populated earnings calendar snapshot',
      () async {
        final snapshot = await calendarRepo.getCalendar();

        expect(snapshot, isA<StakingEarningsCalendarSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.currentYear, 2026);
        expect(snapshot.currentMonth, 3);
        expect(snapshot.tabs, hasLength(2));
        expect(snapshot.events, hasLength(10));
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getSelection returns a populated validator selection snapshot',
      () async {
        final snapshot = await validatorSelectionRepo.getSelection();

        expect(snapshot, isA<StakingValidatorSelectionSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.validators, hasLength(7));
        expect(snapshot.validators.first.tier, StakingValidatorTier.top);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getAutoCompound returns a populated auto-compound snapshot',
      () async {
        final snapshot = await autoCompoundRepo.getAutoCompound();

        expect(snapshot, isA<StakingAutoCompoundSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.frequencies, hasLength(3));
        expect(snapshot.positions, hasLength(4));
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getLiquidStaking returns a populated liquid staking snapshot',
      () async {
        final snapshot = await liquidStakingRepo.getLiquidStaking();

        expect(snapshot, isA<StakingLiquidStakingSnapshot>());
        expect(snapshot.endpoint, isNotEmpty);
        expect(snapshot.tokens, hasLength(3));
        expect(snapshot.swapFromOptions, hasLength(3));
        expect(snapshot.swapToOptions, hasLength(4));
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );
  });
}
