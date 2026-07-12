// Smoke test for MockTradeRepository (bot getters slice): exercises
// TradeRepository's trading-bot getter methods against the mock
// implementation and asserts each call succeeds (doesn't throw) and returns
// a plausible result.
//
// Split from mock_trade_repository_test.dart by behavior group to keep each
// file under the repo's 400-line test-file size gate. See
// mock_trade_repository_core_test.dart, _copy_test.dart, _regulatory_test.dart
// and _actions_test.dart for the other slices of this smoke test suite.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

void main() {
  const repo = MockTradeRepository();

  group('MockTradeRepository smoke test', () {
    group('bot getters', () {
      test(
        'getBotTermsOfService / getBotRiskDisclosure / getBotSuitabilityAssessment',
        () {
          expect(repo.getBotTermsOfService(), isA<TradeBotTermsSnapshot>());
          expect(
            repo.getBotRiskDisclosure(),
            isA<TradeBotRiskDisclosureSnapshot>(),
          );
          expect(
            repo.getBotSuitabilityAssessment(),
            isA<TradeBotSuitabilityAssessmentSnapshot>(),
          );
        },
      );

      test(
        'getBotRiskDashboard / getBotEmergencyStop / getBotSecuritySettings',
        () {
          expect(
            repo.getBotRiskDashboard(),
            isA<TradeBotRiskDashboardSnapshot>(),
          );
          expect(
            repo.getBotEmergencyStop(),
            isA<TradeBotEmergencyStopSnapshot>(),
          );
          expect(
            repo.getBotSecuritySettings(),
            isA<TradeBotSecuritySettingsSnapshot>(),
          );
        },
      );

      test(
        'getBotHistory / getBotPerformanceAnalytics / getBotBacktesting',
        () {
          final history = repo.getBotHistory();
          expect(history, isA<TradeBotHistorySnapshot>());
          expect(history.trades, hasLength(7));
          expect(
            repo.getBotPerformanceAnalytics(),
            isA<TradeBotPerformanceAnalyticsSnapshot>(),
          );
          expect(repo.getBotBacktesting(), isA<TradeBotBacktestingSnapshot>());
        },
      );

      test(
        'getBotStrategyCompare / getBotOptimization / getBotPortfolioDashboard',
        () {
          expect(
            repo.getBotStrategyCompare(),
            isA<TradeBotStrategyCompareSnapshot>(),
          );
          expect(
            repo.getBotOptimization(),
            isA<TradeBotOptimizationSnapshot>(),
          );
          expect(
            repo.getBotPortfolioDashboard(),
            isA<TradeBotPortfolioDashboardSnapshot>(),
          );
        },
      );

      test(
        'getBotDrawdownAnalyzer / getBotEquityCurve / getBotGuide / getBotFaq',
        () {
          expect(
            repo.getBotDrawdownAnalyzer(),
            isA<TradeBotDrawdownAnalyzerSnapshot>(),
          );
          expect(repo.getBotEquityCurve(), isA<TradeBotEquityCurveSnapshot>());
          expect(repo.getBotGuide(), isA<TradeBotGuideSnapshot>());
          expect(repo.getBotFaq(), isA<TradeBotFaqSnapshot>());
        },
      );

      test('getBotTaxReporting / getBotApiDocumentation', () {
        expect(repo.getBotTaxReporting(), isA<TradeBotTaxReportingSnapshot>());
        expect(
          repo.getBotApiDocumentation(),
          isA<TradeBotApiDocumentationSnapshot>(),
        );
      });
    });
  });
}
