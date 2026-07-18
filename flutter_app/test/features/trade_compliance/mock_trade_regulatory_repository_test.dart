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
//
// GD4 Cụm F3: repository methods are now Future<T> — every test() below is
// async and awaits each repo call (loadDelay: Duration.zero to skip the
// simulated network latency, xem GD4-Async-Playbook.md mục 7).
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';

void main() {
  const repo = MockTradeRegulatoryRepository(loadDelay: Duration.zero);

  group('MockTradeRegulatoryRepository smoke test', () {
    group('getters', () {
      test(
        'getRegulatoryDisclosures / getMarketDataAnalytics / getLiveMarketDataAnalytics',
        () async {
          expect(
            await repo.getRegulatoryDisclosures(),
            isA<TradeRegulatoryDisclosuresSnapshot>(),
          );
          expect(
            await repo.getMarketDataAnalytics(),
            isA<TradeMarketDataAnalyticsSnapshot>(),
          );
          expect(
            await repo.getLiveMarketDataAnalytics(),
            isA<TradeMarketDataAnalyticsSnapshot>(),
          );
        },
      );

      test(
        'getTransactionReporting / getRegulatoryReportsDashboard / getArmIntegrationStatus',
        () async {
          expect(
            await repo.getTransactionReporting(),
            isA<TradeTransactionReportingSnapshot>(),
          );
          expect(
            await repo.getRegulatoryReportsDashboard(),
            isA<TradeRegulatoryReportsDashboardSnapshot>(),
          );
          expect(
            await repo.getArmIntegrationStatus(),
            isA<TradeArmIntegrationStatusSnapshot>(),
          );
        },
      );

      test(
        'getBestExecutionReports / getExecutionVenueAnalysis / getSlippageMonitoring',
        () async {
          expect(
            await repo.getBestExecutionReports(),
            isA<TradeBestExecutionReportsSnapshot>(),
          );
          expect(
            await repo.getExecutionVenueAnalysis(),
            isA<TradeExecutionVenueAnalysisSnapshot>(),
          );
          expect(
            await repo.getSlippageMonitoring(),
            isA<TradeSlippageMonitoringSnapshot>(),
          );
        },
      );

      test(
        'getClientCategorization / getProductGovernance / getTargetMarketDefinition',
        () async {
          expect(
            await repo.getClientCategorization(),
            isA<TradeClientCategorizationSnapshot>(),
          );
          expect(
            await repo.getProductGovernance(),
            isA<TradeProductGovernanceSnapshot>(),
          );
          expect(
            await repo.getTargetMarketDefinition(),
            isA<TradeTargetMarketDefinitionSnapshot>(),
          );
          expect(
            await repo.getTargetMarketDefinition(productId: 'prod-2'),
            isA<TradeTargetMarketDefinitionSnapshot>(),
          );
        },
      );

      test(
        'getClientMoneyProtection / getCassReconciliation / getInvestorCompensation',
        () async {
          expect(
            await repo.getClientMoneyProtection(),
            isA<TradeClientMoneyProtectionSnapshot>(),
          );
          expect(
            await repo.getCassReconciliation(),
            isA<TradeCassReconciliationSnapshot>(),
          );
          expect(
            await repo.getInvestorCompensation(),
            isA<TradeInvestorCompensationSnapshot>(),
          );
        },
      );

      test(
        'getExAnteCosts / getRiyCalculator / getExPostCostsReport / getKidGenerator',
        () async {
          expect(await repo.getExAnteCosts(), isA<TradeExAnteCostsSnapshot>());
          expect(
            await repo.getRiyCalculator(),
            isA<TradeRiyCalculatorSnapshot>(),
          );
          expect(
            await repo.getExPostCostsReport(),
            isA<TradeExPostCostsReportSnapshot>(),
          );
          expect(
            await repo.getKidGenerator(),
            isA<TradeKidGeneratorSnapshot>(),
          );
        },
      );

      test(
        'getPerformanceScenarios / getRiskIndicatorExplainer / getComplaintsHandling',
        () async {
          expect(
            await repo.getPerformanceScenarios(),
            isA<TradePerformanceScenariosSnapshot>(),
          );
          expect(
            await repo.getRiskIndicatorExplainer(),
            isA<TradeRiskIndicatorSnapshot>(),
          );
          expect(
            await repo.getComplaintsHandling(),
            isA<TradeComplaintsHandlingSnapshot>(),
          );
        },
      );

      test(
        'getComplaintSubmission / getComplaintTracking / getOmbudsmanReferral',
        () async {
          expect(
            await repo.getComplaintSubmission(),
            isA<TradeComplaintSubmissionSnapshot>(),
          );
          expect(
            await repo.getComplaintTracking(),
            isA<TradeComplaintTrackingSnapshot>(),
          );
          expect(
            await repo.getComplaintTracking(complaintId: 'case-003'),
            isA<TradeComplaintTrackingSnapshot>(),
          );
          expect(
            await repo.getOmbudsmanReferral(),
            isA<TradeOmbudsmanReferralSnapshot>(),
          );
        },
      );

      test('getAuditTrail / getRegulatoryInspectionReady', () async {
        expect(await repo.getAuditTrail(), isA<TradeAuditTrailSnapshot>());
        expect(
          await repo.getRegulatoryInspectionReady(),
          isA<TradeRegulatoryInspectionSnapshot>(),
        );
      });
    });

    group('write / action methods', () {
      test('createExPostCostsReportExport', () async {
        final result = await repo.createExPostCostsReportExport();
        expect(result, isA<TradeExPostCostsReportExportResult>());
        expect(
          await repo.createExPostCostsReportExport(year: 2024),
          isA<TradeExPostCostsReportExportResult>(),
        );
      });
    });
  });
}
