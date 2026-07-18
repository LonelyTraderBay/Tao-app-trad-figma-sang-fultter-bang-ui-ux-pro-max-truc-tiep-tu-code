// Fixture-value smoke test for MockTradeRegulatoryRepository. No
// TradeRegulatoryRepository snapshot carries a highRiskContractId (grep
// confirms `lib/features/trade_compliance` never references it — this
// domain surfaces compliance/reporting detail, not a High-Risk-State-
// Standard entry/confirmation flow), so this file focuses on pinning the
// real fixture literals (endpoint / representative list / notable
// number-or-string per method) read straight from
// lib/features/trade_compliance/data/fixtures/*_repository_methods.dart.
//
// test/features/trade_compliance/mock_trade_regulatory_repository_test.dart
// already exercises every method with `isA<...>()` smoke checks; this file
// complements that (TEST-HR4) without duplicating its per-method coverage.
//
// GD4 Cụm F3: repository methods are now Future<T> — every test() below is
// async and awaits each repo call (loadDelay: Duration.zero to skip the
// simulated network latency, xem GD4-Async-Playbook.md mục 7).
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';

void main() {
  const repo = MockTradeRegulatoryRepository(loadDelay: Duration.zero);

  group('MockTradeRegulatoryRepository smoke test', () {
    group('costs & disclosure documents', () {
      test(
        'getClientMoneyProtection / getCassReconciliation pin fixture values',
        () async {
          final money = await repo.getClientMoneyProtection();
          expect(money.balance, 45230.50);
          expect(money.trustAccount, 'Barclays UK');
          expect(money.protections, isNotEmpty);
          expect(money.endpoint, isNotEmpty);

          final cass = await repo.getCassReconciliation();
          expect(cass.reconciledCount, 3);
          expect(cass.resolvedCount, 1);
          expect(cass.outstandingCount, 0);
        },
      );

      test(
        'getInvestorCompensation / getExAnteCosts / getRiyCalculator',
        () async {
          final compensation = await repo.getInvestorCompensation();
          expect(compensation.coverageLimit, '£85,000');

          final exAnte = await repo.getExAnteCosts();
          expect(exAnte.investmentAmount, 10000);
          expect(exAnte.costs, isNotEmpty);

          final riy = await repo.getRiyCalculator();
          expect(riy.totalCostsPct, 4.5);
        },
      );

      test(
        'getExPostCostsReport / getKidGenerator / getPerformanceScenarios',
        () async {
          final report = await repo.getExPostCostsReport();
          expect(report.reports, isNotEmpty);

          final kid = await repo.getKidGenerator();
          expect(kid.document.title, 'Mirror Copy Trading - KID');

          final scenarios = await repo.getPerformanceScenarios();
          expect(scenarios.holdingPeriods, [1, 3, 5]);
        },
      );

      test('getRiskIndicatorExplainer pins the product SRI', () async {
        final indicator = await repo.getRiskIndicatorExplainer();
        expect(indicator.productSri, 6);
        expect(indicator.levels, isNotEmpty);
      });

      test(
        'createExPostCostsReportExport pins the generated download url',
        () async {
          final defaultYear = await repo.createExPostCostsReportExport();
          expect(defaultYear.status, 'ready');
          expect(
            defaultYear.downloadUrl,
            '/exports/ex-post-cost-report-2025.pdf',
          );

          final result = await repo.createExPostCostsReportExport(year: 2024);
          expect(result.year, 2024);
          expect(result.downloadUrl, '/exports/ex-post-cost-report-2024.pdf');
        },
      );
    });

    group('regulatory disclosures & governance', () {
      test(
        'getRegulatoryDisclosures / getTransactionReporting default tabs',
        () async {
          final disclosures = await repo.getRegulatoryDisclosures();
          expect(disclosures.defaultTabId, 'mifid');
          expect(disclosures.mifidArticles, isNotEmpty);

          final reporting = await repo.getTransactionReporting();
          expect(reporting.defaultTab, 'queue');
          expect(reporting.reports, isNotEmpty);
        },
      );

      test('getRegulatoryReportsDashboard / getClientCategorization', () async {
        final dashboard = await repo.getRegulatoryReportsDashboard();
        expect(dashboard.defaultRange, '7D');
        expect(dashboard.timeRanges, hasLength(4));

        final categorization = await repo.getClientCategorization();
        expect(categorization.currentCategoryId, 'retail');
        expect(categorization.categories, isNotEmpty);
      });

      test('getProductGovernance / getTargetMarketDefinition', () async {
        final governance = await repo.getProductGovernance();
        expect(governance.nextReviewLabel, 'June 2026');
        expect(governance.products, isNotEmpty);

        final target = await repo.getTargetMarketDefinition();
        expect(target.product.id, 'prod-1');

        final other = await repo.getTargetMarketDefinition(productId: 'prod-2');
        expect(other.dimensions, isNotEmpty);
      });

      test(
        'getAuditTrail / getRegulatoryInspectionReady pin fixture values',
        () async {
          final audit = await repo.getAuditTrail();
          expect(audit.exportFormats, ['CSV', 'PDF']);
          expect(audit.entries, isNotEmpty);

          final inspection = await repo.getRegulatoryInspectionReady();
          expect(inspection.complianceScore, 97);
        },
      );
    });

    group('execution quality analytics', () {
      test(
        'getMarketDataAnalytics / getLiveMarketDataAnalytics pin the mark price',
        () async {
          final market = await repo.getMarketDataAnalytics();
          expect(market.selectedPair, 'BTC/USDT');
          expect(market.markPrice, 67543.21);

          final live = await repo.getLiveMarketDataAnalytics();
          expect(live.selectedPair, 'BTC/USDT');
          expect(live.markPrice, 67543.21);
        },
      );

      test('getArmIntegrationStatus / getBestExecutionReports', () async {
        final arm = await repo.getArmIntegrationStatus();
        expect(arm.connections, isNotEmpty);

        final reports = await repo.getBestExecutionReports();
        expect(reports.defaultTab, 'current');
        expect(reports.venues, isNotEmpty);
      });

      test('getExecutionVenueAnalysis / getSlippageMonitoring', () async {
        final venues = await repo.getExecutionVenueAnalysis();
        expect(venues.defaultSort, 'volume');
        expect(venues.venues, isNotEmpty);

        final slippage = await repo.getSlippageMonitoring();
        expect(slippage.defaultTab, 'realtime');
        expect(slippage.events, isNotEmpty);
      });
    });

    group('disputes & complaints', () {
      test(
        'getComplaintsHandling pins counts and average resolution days',
        () async {
          final handling = await repo.getComplaintsHandling();
          expect(handling.activeCount, 1);
          expect(handling.resolvedCount, 1);
          expect(handling.averageResolutionDays, 12);
        },
      );

      test(
        'getComplaintSubmission pins validation bounds and confirmation id',
        () async {
          final submission = await repo.getComplaintSubmission();
          expect(submission.confirmationComplaintId, 'COMP-2026-NEW');
          expect(submission.subjectMinLength, 10);
          expect(submission.subjectMaxLength, 100);
        },
      );

      test(
        'getComplaintTracking falls back to "undefined" without an id',
        () async {
          final withoutId = await repo.getComplaintTracking();
          expect(withoutId.complaintId, 'undefined');

          final withId = await repo.getComplaintTracking(
            complaintId: 'case-003',
          );
          expect(withId.complaintId, 'case-003');
          expect(withId.daysRemaining, 34);
        },
      );

      test('getOmbudsmanReferral pins the external url', () async {
        final referral = await repo.getOmbudsmanReferral();
        expect(referral.externalUrl, 'https://www.financial-ombudsman.org.uk');
        expect(referral.eligibility, isNotEmpty);
      });
    });
  });
}
