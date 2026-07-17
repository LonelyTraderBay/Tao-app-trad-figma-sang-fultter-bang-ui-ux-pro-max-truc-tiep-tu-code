// Smoke test for MockTradeCopyTradingRepository: exercises
// TradeCopyTradingRepository's getters/actions against the mock
// implementation and asserts each call succeeds (doesn't throw) and returns
// a plausible result.
//
// Phase 6 (2026-07-15): redistributed here from the deleted
// `trade_core`/`MockTradeRepository` union's mock_trade_repository_copy_test.dart
// (getters, unchanged) plus this domain's slice of
// mock_trade_repository_core_test.dart (getTraderProfile) and
// mock_trade_repository_actions_test.dart (copy action methods).
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';

void main() {
  const repo = MockTradeCopyTradingRepository();

  group('MockTradeCopyTradingRepository smoke test', () {
    group('getters', () {
      test('getTraderProfile', () {
        expect(repo.getTraderProfile(), isA<TradeTraderProfileSnapshot>());
        expect(
          repo.getTraderProfile(traderId: 'trader002'),
          isA<TradeTraderProfileSnapshot>(),
        );
      });

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

    group('write / action methods', () {
      test('patchCopySettings', () {
        final snapshot = repo.getCopySettings();
        final updated = snapshot.settings.copyWith(defaultCopyRatio: 60);
        final result = repo.patchCopySettings(updated);
        expect(result, isA<TradeCopySettingsSaveResult>());
        expect(result.status, 'saved');
      });

      test('previewCopyConfiguration', () {
        final found = repo.getCopyConfiguration(providerId: 'provider001');
        final preview = repo.previewCopyConfiguration(found.defaultDraft);
        expect(preview, isA<TradeCopyConfigurationPreview>());
        expect(preview.status, 'ready');
      });

      test('submitCopyConfirmation', () {
        final found = repo.getCopyConfirmation(providerId: 'ct001');
        final accepted = repo.submitCopyConfirmation(
          TradeCopyConfirmationRequest(
            providerId: 'ct001',
            configuration: found.configuration,
            acceptedConsentIds: found.consentItems
                .map((item) => item.id)
                .toList(),
          ),
        );
        expect(accepted, isA<TradeCopyConfirmationResult>());
      });

      test('submitProviderApplication', () {
        final snapshot = repo.getProviderApplication();
        final result = repo.submitProviderApplication(snapshot.defaultDraft);
        expect(result, isA<TradeProviderApplicationResult>());
        expect(result.status, 'submitted');
      });

      test('createCopyAuditExport', () {
        final result = repo.createCopyAuditExport(
          const TradeCopyAuditExportRequest(
            copyId: 'copy001',
            format: 'csv',
            filterId: 'all',
            searchQuery: '',
          ),
        );
        expect(result, isA<TradeCopyAuditExportResult>());
      });

      test('submitDisputeComplaint', () {
        final result = repo.submitDisputeComplaint(
          const TradeDisputeComplaintDraft(
            complaintType: 'execution_issue',
            providerId: 'trader-2',
            subject: 'Excessive slippage',
            description: 'Provider executed at a materially different price.',
          ),
        );
        expect(result, isA<TradeDisputeSubmissionResult>());
        expect(result.status, 'submitted');
      });

      test('submitCopyTradingAction', () {
        final result = repo.submitCopyTradingAction(
          const TradeCopyActionRequest(providerId: 'ct001', action: 'follow'),
        );
        expect(result, isA<TradeCopyActionResult>());
      });
    });
  });
}
