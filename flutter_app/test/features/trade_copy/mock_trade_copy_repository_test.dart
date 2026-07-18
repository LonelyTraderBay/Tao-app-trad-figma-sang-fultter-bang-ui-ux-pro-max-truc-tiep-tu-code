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
//
// GD4-F3: every method is `Future<T>` — mock simulates network latency via
// `loadDelay`; tests pass `Duration.zero` (see
// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md).
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';

void main() {
  const repo = MockTradeCopyTradingRepository(loadDelay: Duration.zero);

  group('MockTradeCopyTradingRepository smoke test', () {
    group('getters', () {
      test('getTraderProfile', () async {
        expect(
          await repo.getTraderProfile(),
          isA<TradeTraderProfileSnapshot>(),
        );
        expect(
          await repo.getTraderProfile(traderId: 'trader002'),
          isA<TradeTraderProfileSnapshot>(),
        );
      });

      test('getCopyTrading / getCopyCardDemo / getCopyEducation', () async {
        expect(await repo.getCopyTrading(), isA<TradeCopyTradingSnapshot>());
        expect(await repo.getCopyCardDemo(), isA<TradeCopyCardDemoSnapshot>());
        expect(
          await repo.getCopyEducation(),
          isA<TradeCopyEducationSnapshot>(),
        );
      });

      test(
        'getActiveCopies / getCopySettings / getCopyNotifications',
        () async {
          expect(
            await repo.getActiveCopies(),
            isA<TradeActiveCopiesSnapshot>(),
          );
          expect(
            await repo.getCopySettings(),
            isA<TradeCopySettingsSnapshot>(),
          );
          expect(
            await repo.getCopyNotifications(),
            isA<TradeCopyNotificationsSnapshot>(),
          );
        },
      );

      test(
        'getProviderApplication / getCopyProviderDetail / getPreCopyAssessment',
        () async {
          expect(
            await repo.getProviderApplication(),
            isA<TradeProviderApplicationSnapshot>(),
          );
          expect(
            await repo.getCopyProviderDetail(),
            isA<TradeCopyProviderDetailSnapshot>(),
          );
          expect(
            await repo.getCopyProviderDetail(providerId: 'provider002'),
            isA<TradeCopyProviderDetailSnapshot>(),
          );
          expect(
            await repo.getPreCopyAssessment(),
            isA<TradePreCopyAssessmentSnapshot>(),
          );
          expect(
            await repo.getPreCopyAssessment(providerId: 'provider002'),
            isA<TradePreCopyAssessmentSnapshot>(),
          );
        },
      );

      test(
        'getCopyConfiguration / getCopyConfirmation / getCopyPerformance',
        () async {
          expect(
            await repo.getCopyConfiguration(),
            isA<TradeCopyConfigurationSnapshot>(),
          );
          expect(
            await repo.getCopyConfiguration(providerId: 'provider002'),
            isA<TradeCopyConfigurationSnapshot>(),
          );
          expect(
            await repo.getCopyConfirmation(),
            isA<TradeCopyConfirmationSnapshot>(),
          );
          expect(
            await repo.getCopyConfirmation(providerId: 'provider002'),
            isA<TradeCopyConfirmationSnapshot>(),
          );
          expect(
            await repo.getCopyPerformance(),
            isA<TradeCopyPerformanceSnapshot>(),
          );
          expect(
            await repo.getCopyPerformance(copyId: 'copy002'),
            isA<TradeCopyPerformanceSnapshot>(),
          );
        },
      );

      test(
        'getPerformanceAttribution / getProviderComparison / getCopyAuditLog',
        () async {
          expect(
            await repo.getPerformanceAttribution(),
            isA<TradePerformanceAttributionSnapshot>(),
          );
          expect(
            await repo.getPerformanceAttribution(copyId: 'copy002'),
            isA<TradePerformanceAttributionSnapshot>(),
          );
          expect(
            await repo.getProviderComparison(),
            isA<TradeProviderComparisonSnapshot>(),
          );
          expect(
            await repo.getCopyAuditLog(),
            isA<TradeCopyAuditLogSnapshot>(),
          );
          expect(
            await repo.getCopyAuditLog(copyId: 'copy002'),
            isA<TradeCopyAuditLogSnapshot>(),
          );
        },
      );

      test(
        'getPortfolioRiskAnalysis / getProviderLeaderboard / getSafetyEducation',
        () async {
          expect(
            await repo.getPortfolioRiskAnalysis(),
            isA<TradePortfolioRiskAnalysisSnapshot>(),
          );
          expect(
            await repo.getProviderLeaderboard(),
            isA<TradeProviderLeaderboardSnapshot>(),
          );
          expect(
            await repo.getSafetyEducation(),
            isA<TradeSafetyEducationSnapshot>(),
          );
        },
      );

      test(
        'getProviderGovernance / getDisputeResolution / getCopySafetyCenter',
        () async {
          expect(
            await repo.getProviderGovernance(),
            isA<TradeProviderGovernanceSnapshot>(),
          );
          expect(
            await repo.getDisputeResolution(),
            isA<TradeDisputeResolutionSnapshot>(),
          );
          expect(
            await repo.getCopySafetyCenter(),
            isA<TradeCopySafetyCenterSnapshot>(),
          );
        },
      );
    });

    group('write / action methods', () {
      test('patchCopySettings', () async {
        final snapshot = await repo.getCopySettings();
        final updated = snapshot.settings.copyWith(defaultCopyRatio: 60);
        final result = await repo.patchCopySettings(updated);
        expect(result, isA<TradeCopySettingsSaveResult>());
        expect(result.status, 'saved');
      });

      test('previewCopyConfiguration', () async {
        final found = await repo.getCopyConfiguration(
          providerId: 'provider001',
        );
        final preview = await repo.previewCopyConfiguration(found.defaultDraft);
        expect(preview, isA<TradeCopyConfigurationPreview>());
        expect(preview.status, 'ready');
      });

      test('submitCopyConfirmation', () async {
        final found = await repo.getCopyConfirmation(providerId: 'ct001');
        final accepted = await repo.submitCopyConfirmation(
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

      test('submitProviderApplication', () async {
        final snapshot = await repo.getProviderApplication();
        final result = await repo.submitProviderApplication(
          snapshot.defaultDraft,
        );
        expect(result, isA<TradeProviderApplicationResult>());
        expect(result.status, 'submitted');
      });

      test('createCopyAuditExport', () async {
        final result = await repo.createCopyAuditExport(
          const TradeCopyAuditExportRequest(
            copyId: 'copy001',
            format: 'csv',
            filterId: 'all',
            searchQuery: '',
          ),
        );
        expect(result, isA<TradeCopyAuditExportResult>());
      });

      test('submitDisputeComplaint', () async {
        final result = await repo.submitDisputeComplaint(
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

      test('submitCopyTradingAction', () async {
        final result = await repo.submitCopyTradingAction(
          const TradeCopyActionRequest(providerId: 'ct001', action: 'follow'),
        );
        expect(result, isA<TradeCopyActionResult>());
      });
    });
  });
}
