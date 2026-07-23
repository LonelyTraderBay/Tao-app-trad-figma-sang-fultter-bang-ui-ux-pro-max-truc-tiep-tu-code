import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';

/// Smoke test for the staking risk/safety mocks: exercises
/// [MockStakingInsuranceRepository],
/// [MockStakingInsuranceFundTransparencyRepository],
/// [MockStakingTransactionReportingRepository],
/// [MockStakingApiDocumentationRepository],
/// [MockStakingProofOfReservesRepository],
/// [MockStakingRiskDashboardRepository],
/// [MockStakingSlashingHistoryRepository],
/// [MockStakingValidatorHealthMonitorRepository],
/// [MockStakingRiskScoreCalculatorRepository],
/// [MockStakingEmergencyActionsRepository], and
/// [MockStakingContingencyPlanRepository], asserting each call succeeds
/// without throwing and returns a plausible, non-empty result.
void main() {
  const insuranceRepo = MockStakingInsuranceRepository();
  const transparencyRepo = MockStakingInsuranceFundTransparencyRepository();
  const reportingRepo = MockStakingTransactionReportingRepository();
  const documentationRepo = MockStakingApiDocumentationRepository();
  const proofOfReservesRepo = MockStakingProofOfReservesRepository();
  const riskDashboardRepo = MockStakingRiskDashboardRepository();
  const slashingHistoryRepo = MockStakingSlashingHistoryRepository();
  const validatorHealthRepo = MockStakingValidatorHealthMonitorRepository();
  const calculatorRepo = MockStakingRiskScoreCalculatorRepository();
  const emergencyActionsRepo = MockStakingEmergencyActionsRepository();
  const contingencyPlanRepo = MockStakingContingencyPlanRepository();

  group('Earn staking risk & safety mocks smoke test', () {
    test('getInsurance returns a populated insurance snapshot', () async {
      final snapshot = await insuranceRepo.getInsurance();

      expect(snapshot, isA<StakingInsuranceSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/earn/earn-insurance');
      expect(snapshot.title, 'Slashing Insurance');
      expect(snapshot.plans, hasLength(3));
      expect(snapshot.positions, hasLength(4));
      expect(snapshot.claims, hasLength(2));
      expect(snapshot.benefits, hasLength(4));
      expect(snapshot.warningBullets, isNotEmpty);
      expect(snapshot.claimReasons, isNotEmpty);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getTransparency returns a populated insurance fund transparency '
        'snapshot', () async {
      final snapshot = await transparencyRepo.getTransparency();

      expect(snapshot, isA<StakingInsuranceFundTransparencySnapshot>());
      expect(
        snapshot.endpoint,
        '/api/mobile/earn/earn-insurance-fund-transparency',
      );
      expect(snapshot.title, 'Insurance Fund');
      expect(snapshot.totalBalance, 50000000);
      expect(snapshot.targetRatio, 150);
      expect(snapshot.currentRatio, 165);
      expect(snapshot.assets, hasLength(3));
      expect(snapshot.claims, hasLength(4));
      expect(snapshot.history, hasLength(12));
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test(
      'getReporting returns a populated transaction reporting snapshot',
      () async {
        final snapshot = await reportingRepo.getReporting();

        expect(snapshot, isA<StakingTransactionReportingSnapshot>());
        expect(
          snapshot.endpoint,
          '/api/mobile/earn/earn-transaction-reporting',
        );
        expect(snapshot.title, 'Tax Reporting');
        expect(snapshot.years, hasLength(3));
        expect(snapshot.defaultYear, '2025');
        expect(snapshot.defaultCostBasis, 'FIFO');
        expect(snapshot.summary, isA<StakingTaxSummaryDraft>());
        expect(snapshot.transactions, isNotEmpty);
        expect(snapshot.costBasisMethods, isNotEmpty);
        expect(snapshot.taxForms, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getDocumentation returns a populated API documentation snapshot',
      () async {
        final snapshot = await documentationRepo.getDocumentation();

        expect(snapshot, isA<StakingApiDocumentationSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/earn/earn-api-documentation');
        expect(snapshot.title, 'API Documentation');
        expect(snapshot.stats, hasLength(3));
        expect(snapshot.defaultTab, 'endpoints');
        expect(snapshot.defaultLanguage, 'javascript');
        expect(snapshot.endpoints, isNotEmpty);
        expect(snapshot.codeExamples, isNotEmpty);
        expect(snapshot.rateLimits, isNotEmpty);
        expect(snapshot.errorCodes, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getProofOfReserves returns a populated proof of reserves snapshot',
      () async {
        final snapshot = await proofOfReservesRepo.getProofOfReserves();

        expect(snapshot, isA<StakingProofOfReservesSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/earn/earn-proof-of-reserves');
        expect(snapshot.title, 'Proof of Reserves');
        expect(snapshot.overall, isA<StakingReserveOverallDraft>());
        expect(snapshot.overall.reserveRatio, greaterThan(100));
        expect(snapshot.assets, hasLength(3));
        expect(snapshot.auditReports, hasLength(3));
        expect(snapshot.history, isNotEmpty);
        expect(snapshot.verifySteps, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getRiskDashboard returns a populated risk dashboard snapshot',
      () async {
        final snapshot = await riskDashboardRepo.getRiskDashboard();

        expect(snapshot, isA<StakingRiskDashboardSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/earn/earn-risk-dashboard');
        expect(snapshot.title, 'Risk Dashboard');
        expect(snapshot.overallScore, 28);
        expect(snapshot.totalStakedUsd, 100000);
        expect(snapshot.atRiskUsd, 5000);
        expect(snapshot.protectedPercent, 95);
        expect(snapshot.riskMetrics, hasLength(6));
        expect(snapshot.exposures, hasLength(4));
        expect(snapshot.events, hasLength(3));
        expect(snapshot.actions, hasLength(4));
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getSlashingHistory returns a populated slashing history snapshot',
      () async {
        final snapshot = await slashingHistoryRepo.getSlashingHistory();

        expect(snapshot, isA<StakingSlashingHistorySnapshot>());
        expect(snapshot.endpoint, '/api/mobile/earn/earn-slashing-history');
        expect(snapshot.title, 'Slashing History');
        expect(snapshot.stats, isA<StakingSlashingStatsDraft>());
        expect(snapshot.stats.totalEvents, 3);
        expect(snapshot.events, hasLength(3));
        expect(snapshot.trend, hasLength(12));
        expect(snapshot.networkBreakdown, hasLength(2));
        expect(snapshot.reasonBreakdown, hasLength(3));
        expect(snapshot.preventionMeasures, hasLength(4));
        expect(snapshot.exportLabel, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getValidatorHealth returns a populated validator health snapshot',
      () async {
        final snapshot = await validatorHealthRepo.getValidatorHealth();

        expect(snapshot, isA<StakingValidatorHealthMonitorSnapshot>());
        expect(
          snapshot.endpoint,
          '/api/mobile/earn/earn-validator-health-monitor',
        );
        expect(snapshot.title, 'Validator Health');
        expect(snapshot.validators, hasLength(3));
        expect(snapshot.uptimeHistory, hasLength(7));
        expect(snapshot.healthyCount, 2);
        expect(snapshot.warningCount, 1);
        expect(snapshot.averageUptime, greaterThan(0));
        expect(snapshot.actionLabel, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getCalculator returns a populated risk score calculator snapshot',
      () async {
        final snapshot = await calculatorRepo.getCalculator();

        expect(snapshot, isA<StakingRiskScoreCalculatorSnapshot>());
        expect(
          snapshot.endpoint,
          '/api/mobile/earn/earn-risk-score-calculator',
        );
        expect(snapshot.title, 'Risk Calculator');
        expect(snapshot.defaultAmountUsd, 10000);
        expect(snapshot.defaultAsset, 'ETH');
        expect(snapshot.defaultDuration, 'flexible');
        expect(snapshot.defaultValidators, 3);
        expect(snapshot.assetOptions, hasLength(4));
        expect(snapshot.durationOptions, hasLength(5));
        expect(snapshot.recommendations, hasLength(3));
        expect(snapshot.proceedLabel, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getEmergencyActions returns a populated emergency actions snapshot',
      () async {
        final snapshot = await emergencyActionsRepo.getEmergencyActions();

        expect(snapshot, isA<StakingEmergencyActionsSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/earn/earn-emergency-actions');
        expect(snapshot.title, 'Emergency Actions');
        expect(snapshot.actions, hasLength(3));
        expect(snapshot.useCases, hasLength(4));
        expect(snapshot.statusCards, hasLength(2));
        expect(snapshot.pauseSheet, isA<StakingEmergencySheetDraft>());
        expect(snapshot.withdrawSheet, isA<StakingEmergencySheetDraft>());
        expect(snapshot.withdrawSheet.bullets, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );

    test(
      'getContingencyPlan returns a populated contingency plan snapshot',
      () async {
        final snapshot = await contingencyPlanRepo.getContingencyPlan();

        expect(snapshot, isA<StakingContingencyPlanSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/earn/earn-contingency-plan');
        expect(snapshot.title, 'Contingency Plan');
        expect(snapshot.metrics, hasLength(4));
        expect(snapshot.scenarios, hasLength(4));
        expect(snapshot.validationItems, hasLength(2));
        expect(snapshot.documents, hasLength(3));
        expect(snapshot.validationBody, isNotEmpty);
        expect(snapshot.supportedStates, isNotEmpty);
      },
    );
  });
}
