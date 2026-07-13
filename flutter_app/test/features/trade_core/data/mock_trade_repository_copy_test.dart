// Smoke test for MockTradeRepository (copy trading getters slice): exercises
// TradeRepository's copy-trading getter methods against the mock
// implementation and asserts each call succeeds (doesn't throw) and returns
// a plausible result.
//
// Split from mock_trade_repository_test.dart by behavior group to keep each
// file under the repo's 400-line test-file size gate. See
// mock_trade_repository_core_test.dart, _regulatory_test.dart, _bots_test.dart
// and _actions_test.dart for the other slices of this smoke test suite.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_core/data/trade_repository.dart';

void main() {
  const repo = MockTradeRepository();

  group('MockTradeRepository smoke test', () {
    group('copy trading getters', () {
      test('getCopyTrading / getCopyCardDemo / getCopyEducation', () {
        expect(repo.getCopyTrading(), isA<TradeCopyTradingSnapshot>());
        expect(repo.getCopyCardDemo(), isA<TradeCopyCardDemoSnapshot>());
        expect(repo.getCopyEducation(), isA<TradeCopyEducationSnapshot>());
      });

      test('getActiveCopies / getCopySettings / getCopyNotifications', () {
        expect(repo.getActiveCopies(), isA<TradeActiveCopiesSnapshot>());
        expect(repo.getCopySettings(), isA<TradeCopySettingsSnapshot>());
        expect(
          repo.getCopyNotifications(),
          isA<TradeCopyNotificationsSnapshot>(),
        );
      });

      test(
        'getProviderApplication / getCopyProviderDetail / getPreCopyAssessment',
        () {
          expect(
            repo.getProviderApplication(),
            isA<TradeProviderApplicationSnapshot>(),
          );
          expect(
            repo.getCopyProviderDetail(),
            isA<TradeCopyProviderDetailSnapshot>(),
          );
          expect(
            repo.getCopyProviderDetail(providerId: 'provider002'),
            isA<TradeCopyProviderDetailSnapshot>(),
          );
          expect(
            repo.getPreCopyAssessment(),
            isA<TradePreCopyAssessmentSnapshot>(),
          );
          expect(
            repo.getPreCopyAssessment(providerId: 'provider002'),
            isA<TradePreCopyAssessmentSnapshot>(),
          );
        },
      );

      test(
        'getCopyConfiguration / getCopyConfirmation / getCopyPerformance',
        () {
          expect(
            repo.getCopyConfiguration(),
            isA<TradeCopyConfigurationSnapshot>(),
          );
          expect(
            repo.getCopyConfiguration(providerId: 'provider002'),
            isA<TradeCopyConfigurationSnapshot>(),
          );
          expect(
            repo.getCopyConfirmation(),
            isA<TradeCopyConfirmationSnapshot>(),
          );
          expect(
            repo.getCopyConfirmation(providerId: 'provider002'),
            isA<TradeCopyConfirmationSnapshot>(),
          );
          expect(
            repo.getCopyPerformance(),
            isA<TradeCopyPerformanceSnapshot>(),
          );
          expect(
            repo.getCopyPerformance(copyId: 'copy002'),
            isA<TradeCopyPerformanceSnapshot>(),
          );
        },
      );

      test(
        'getPerformanceAttribution / getProviderComparison / getCopyAuditLog',
        () {
          expect(
            repo.getPerformanceAttribution(),
            isA<TradePerformanceAttributionSnapshot>(),
          );
          expect(
            repo.getPerformanceAttribution(copyId: 'copy002'),
            isA<TradePerformanceAttributionSnapshot>(),
          );
          expect(
            repo.getProviderComparison(),
            isA<TradeProviderComparisonSnapshot>(),
          );
          expect(repo.getCopyAuditLog(), isA<TradeCopyAuditLogSnapshot>());
          expect(
            repo.getCopyAuditLog(copyId: 'copy002'),
            isA<TradeCopyAuditLogSnapshot>(),
          );
        },
      );

      test(
        'getPortfolioRiskAnalysis / getProviderLeaderboard / getSafetyEducation',
        () {
          expect(
            repo.getPortfolioRiskAnalysis(),
            isA<TradePortfolioRiskAnalysisSnapshot>(),
          );
          expect(
            repo.getProviderLeaderboard(),
            isA<TradeProviderLeaderboardSnapshot>(),
          );
          expect(
            repo.getSafetyEducation(),
            isA<TradeSafetyEducationSnapshot>(),
          );
        },
      );

      test(
        'getProviderGovernance / getDisputeResolution / getCopySafetyCenter',
        () {
          expect(
            repo.getProviderGovernance(),
            isA<TradeProviderGovernanceSnapshot>(),
          );
          expect(
            repo.getDisputeResolution(),
            isA<TradeDisputeResolutionSnapshot>(),
          );
          expect(
            repo.getCopySafetyCenter(),
            isA<TradeCopySafetyCenterSnapshot>(),
          );
        },
      );
    });
  });
}
