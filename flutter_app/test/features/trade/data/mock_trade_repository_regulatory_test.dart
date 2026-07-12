// Smoke test for MockTradeRepository (regulatory / compliance getters
// slice): exercises TradeRepository's regulatory and compliance getter
// methods against the mock implementation and asserts each call succeeds
// (doesn't throw) and returns a plausible result.
//
// Split from mock_trade_repository_test.dart by behavior group to keep each
// file under the repo's 400-line test-file size gate. See
// mock_trade_repository_core_test.dart, _copy_test.dart, _bots_test.dart and
// _actions_test.dart for the other slices of this smoke test suite.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

void main() {
  const repo = MockTradeRepository();

  group('MockTradeRepository smoke test', () {
    group('regulatory / compliance getters', () {
      test(
        'getRegulatoryDisclosures / getMarketDataAnalytics / getMarginTradingHub',
        () {
          expect(
            repo.getRegulatoryDisclosures(),
            isA<TradeRegulatoryDisclosuresSnapshot>(),
          );
          expect(
            repo.getMarketDataAnalytics(),
            isA<TradeMarketDataAnalyticsSnapshot>(),
          );
          expect(
            repo.getMarginTradingHub(),
            isA<TradeMarginTradingHubSnapshot>(),
          );
          expect(
            repo.getLiveMarketDataAnalytics(),
            isA<TradeMarketDataAnalyticsSnapshot>(),
          );
          expect(
            repo.getAdvancedAnalytics(),
            isA<TradeAdvancedAnalyticsSnapshot>(),
          );
        },
      );

      test(
        'getTransactionReporting / getRegulatoryReportsDashboard / getArmIntegrationStatus',
        () {
          expect(
            repo.getTransactionReporting(),
            isA<TradeTransactionReportingSnapshot>(),
          );
          expect(
            repo.getRegulatoryReportsDashboard(),
            isA<TradeRegulatoryReportsDashboardSnapshot>(),
          );
          expect(
            repo.getArmIntegrationStatus(),
            isA<TradeArmIntegrationStatusSnapshot>(),
          );
        },
      );

      test(
        'getBestExecutionReports / getExecutionVenueAnalysis / getSlippageMonitoring',
        () {
          expect(
            repo.getBestExecutionReports(),
            isA<TradeBestExecutionReportsSnapshot>(),
          );
          expect(
            repo.getExecutionVenueAnalysis(),
            isA<TradeExecutionVenueAnalysisSnapshot>(),
          );
          expect(
            repo.getSlippageMonitoring(),
            isA<TradeSlippageMonitoringSnapshot>(),
          );
        },
      );

      test(
        'getClientCategorization / getProductGovernance / getTargetMarketDefinition',
        () {
          expect(
            repo.getClientCategorization(),
            isA<TradeClientCategorizationSnapshot>(),
          );
          expect(
            repo.getProductGovernance(),
            isA<TradeProductGovernanceSnapshot>(),
          );
          expect(
            repo.getTargetMarketDefinition(),
            isA<TradeTargetMarketDefinitionSnapshot>(),
          );
          expect(
            repo.getTargetMarketDefinition(productId: 'prod-2'),
            isA<TradeTargetMarketDefinitionSnapshot>(),
          );
        },
      );

      test(
        'getClientMoneyProtection / getCassReconciliation / getInvestorCompensation',
        () {
          expect(
            repo.getClientMoneyProtection(),
            isA<TradeClientMoneyProtectionSnapshot>(),
          );
          expect(
            repo.getCassReconciliation(),
            isA<TradeCassReconciliationSnapshot>(),
          );
          expect(
            repo.getInvestorCompensation(),
            isA<TradeInvestorCompensationSnapshot>(),
          );
        },
      );

      test(
        'getExAnteCosts / getRiyCalculator / getExPostCostsReport / getKidGenerator',
        () {
          expect(repo.getExAnteCosts(), isA<TradeExAnteCostsSnapshot>());
          expect(repo.getRiyCalculator(), isA<TradeRiyCalculatorSnapshot>());
          expect(
            repo.getExPostCostsReport(),
            isA<TradeExPostCostsReportSnapshot>(),
          );
          expect(repo.getKidGenerator(), isA<TradeKidGeneratorSnapshot>());
        },
      );

      test(
        'getPerformanceScenarios / getRiskIndicatorExplainer / getComplaintsHandling',
        () {
          expect(
            repo.getPerformanceScenarios(),
            isA<TradePerformanceScenariosSnapshot>(),
          );
          expect(
            repo.getRiskIndicatorExplainer(),
            isA<TradeRiskIndicatorSnapshot>(),
          );
          expect(
            repo.getComplaintsHandling(),
            isA<TradeComplaintsHandlingSnapshot>(),
          );
        },
      );

      test(
        'getComplaintSubmission / getComplaintTracking / getOmbudsmanReferral',
        () {
          expect(
            repo.getComplaintSubmission(),
            isA<TradeComplaintSubmissionSnapshot>(),
          );
          expect(
            repo.getComplaintTracking(),
            isA<TradeComplaintTrackingSnapshot>(),
          );
          expect(
            repo.getComplaintTracking(complaintId: 'case-003'),
            isA<TradeComplaintTrackingSnapshot>(),
          );
          expect(
            repo.getOmbudsmanReferral(),
            isA<TradeOmbudsmanReferralSnapshot>(),
          );
        },
      );

      test('getAuditTrail / getRegulatoryInspectionReady', () {
        expect(repo.getAuditTrail(), isA<TradeAuditTrailSnapshot>());
        expect(
          repo.getRegulatoryInspectionReady(),
          isA<TradeRegulatoryInspectionSnapshot>(),
        );
      });
    });
  });
}
