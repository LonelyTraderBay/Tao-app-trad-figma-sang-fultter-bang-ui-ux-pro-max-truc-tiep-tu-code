// Smoke test for MockTradeRegulatoryRepository: exercises
// TradeRegulatoryRepository's getters/actions against the mock
// implementation and asserts each call succeeds (doesn't throw) and returns
// a plausible result.
//
// Phase 6 (2026-07-15): redistributed here from the deleted
// `trade_core`/`MockTradeRepository` union's
// mock_trade_repository_regulatory_test.dart, minus `getMarginTradingHub`
// and `getAdvancedAnalytics` (those two are actually owned by
// `trade_terminal`'s `TradeFuturesMarginRepository`/`SpotTradeRepository`,
// not this domain — moved to mock_trade_terminal_repository_test.dart),
// plus this domain's slice of mock_trade_repository_actions_test.dart
// (createExPostCostsReportExport).
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';

void main() {
  const repo = MockTradeRegulatoryRepository();

  group('MockTradeRegulatoryRepository smoke test', () {
    group('getters', () {
      test(
        'getRegulatoryDisclosures / getMarketDataAnalytics / getLiveMarketDataAnalytics',
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
            repo.getLiveMarketDataAnalytics(),
            isA<TradeMarketDataAnalyticsSnapshot>(),
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

    group('write / action methods', () {
      test('createExPostCostsReportExport', () {
        final result = repo.createExPostCostsReportExport();
        expect(result, isA<TradeExPostCostsReportExportResult>());
        expect(
          repo.createExPostCostsReportExport(year: 2024),
          isA<TradeExPostCostsReportExportResult>(),
        );
      });
    });
  });
}
