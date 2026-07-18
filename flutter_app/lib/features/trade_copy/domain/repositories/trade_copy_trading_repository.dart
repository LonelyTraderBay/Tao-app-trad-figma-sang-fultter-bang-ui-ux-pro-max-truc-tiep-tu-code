import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

/// Data contract for the Copy Trading feature: provider discovery,
/// configuration & performance, and lifecycle & safety screens.
///
/// GD4-F3: every method is `Future<T>` (ADR-001's read idiom — see
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md). Mock
/// implementations simulate network latency via `loadDelay`; production
/// implementations will be real network calls with the same signature.
abstract interface class TradeCopyTradingRepository {
  // Provider discovery
  Future<TradeProviderComparisonSnapshot> getProviderComparison();
  Future<TradeProviderLeaderboardSnapshot> getProviderLeaderboard();
  Future<TradeProviderGovernanceSnapshot> getProviderGovernance();
  Future<TradeTraderProfileSnapshot> getTraderProfile({
    String traderId = 'trader001',
  });
  Future<TradeProviderApplicationSnapshot> getProviderApplication();
  Future<TradeCopyProviderDetailSnapshot> getCopyProviderDetail({
    String providerId = 'provider001',
  });
  Future<TradePreCopyAssessmentSnapshot> getPreCopyAssessment({
    String providerId = 'provider001',
  });
  Future<TradeProviderApplicationResult> submitProviderApplication(
    TradeProviderApplicationDraft draft,
  );

  // Configuration & performance
  Future<TradeCopyConfigurationSnapshot> getCopyConfiguration({
    String providerId = 'provider001',
  });
  Future<TradeCopyConfirmationSnapshot> getCopyConfirmation({
    String providerId = 'provider001',
  });
  Future<TradeCopyPerformanceSnapshot> getCopyPerformance({
    String copyId = 'copy001',
  });
  Future<TradePerformanceAttributionSnapshot> getPerformanceAttribution({
    String copyId = 'copy001',
  });
  Future<TradeCopyAuditLogSnapshot> getCopyAuditLog({
    String copyId = 'copy001',
  });
  Future<TradePortfolioRiskAnalysisSnapshot> getPortfolioRiskAnalysis();
  Future<TradeCopyConfigurationPreview> previewCopyConfiguration(
    TradeCopyConfigurationDraft draft,
  );
  Future<TradeCopyConfirmationResult> submitCopyConfirmation(
    TradeCopyConfirmationRequest request,
  );
  Future<TradeCopyAuditExportResult> createCopyAuditExport(
    TradeCopyAuditExportRequest request,
  );

  // Lifecycle & safety
  Future<TradeCopyTradingSnapshot> getCopyTrading();
  Future<TradeCopyCardDemoSnapshot> getCopyCardDemo();
  Future<TradeCopyEducationSnapshot> getCopyEducation();
  Future<TradeActiveCopiesSnapshot> getActiveCopies();
  Future<TradeCopySettingsSnapshot> getCopySettings();
  Future<TradeCopyNotificationsSnapshot> getCopyNotifications();
  Future<TradeSafetyEducationSnapshot> getSafetyEducation();
  Future<TradeDisputeResolutionSnapshot> getDisputeResolution();
  Future<TradeCopySafetyCenterSnapshot> getCopySafetyCenter();
  Future<TradeCopySettingsSaveResult> patchCopySettings(
    TradeCopySettings settings,
  );
  Future<TradeDisputeSubmissionResult> submitDisputeComplaint(
    TradeDisputeComplaintDraft draft,
  );
  Future<TradeCopyActionResult> submitCopyTradingAction(
    TradeCopyActionRequest request,
  );
}
