import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

/// Data contract for the Copy Trading feature: provider discovery,
/// configuration & performance, and lifecycle & safety screens.
abstract interface class TradeCopyTradingRepository {
  // Provider discovery
  TradeProviderComparisonSnapshot getProviderComparison();
  TradeProviderLeaderboardSnapshot getProviderLeaderboard();
  TradeProviderGovernanceSnapshot getProviderGovernance();
  TradeTraderProfileSnapshot getTraderProfile({String traderId = 'trader001'});
  TradeProviderApplicationSnapshot getProviderApplication();
  TradeCopyProviderDetailSnapshot getCopyProviderDetail({
    String providerId = 'provider001',
  });
  TradePreCopyAssessmentSnapshot getPreCopyAssessment({
    String providerId = 'provider001',
  });
  TradeProviderApplicationResult submitProviderApplication(
    TradeProviderApplicationDraft draft,
  );

  // Configuration & performance
  TradeCopyConfigurationSnapshot getCopyConfiguration({
    String providerId = 'provider001',
  });
  TradeCopyConfirmationSnapshot getCopyConfirmation({
    String providerId = 'provider001',
  });
  TradeCopyPerformanceSnapshot getCopyPerformance({String copyId = 'copy001'});
  TradePerformanceAttributionSnapshot getPerformanceAttribution({
    String copyId = 'copy001',
  });
  TradeCopyAuditLogSnapshot getCopyAuditLog({String copyId = 'copy001'});
  TradePortfolioRiskAnalysisSnapshot getPortfolioRiskAnalysis();
  TradeCopyConfigurationPreview previewCopyConfiguration(
    TradeCopyConfigurationDraft draft,
  );
  TradeCopyConfirmationResult submitCopyConfirmation(
    TradeCopyConfirmationRequest request,
  );
  TradeCopyAuditExportResult createCopyAuditExport(
    TradeCopyAuditExportRequest request,
  );

  // Lifecycle & safety
  TradeCopyTradingSnapshot getCopyTrading();
  TradeCopyCardDemoSnapshot getCopyCardDemo();
  TradeCopyEducationSnapshot getCopyEducation();
  TradeActiveCopiesSnapshot getActiveCopies();
  TradeCopySettingsSnapshot getCopySettings();
  TradeCopyNotificationsSnapshot getCopyNotifications();
  TradeSafetyEducationSnapshot getSafetyEducation();
  TradeDisputeResolutionSnapshot getDisputeResolution();
  TradeCopySafetyCenterSnapshot getCopySafetyCenter();
  TradeCopySettingsSaveResult patchCopySettings(TradeCopySettings settings);
  TradeDisputeSubmissionResult submitDisputeComplaint(
    TradeDisputeComplaintDraft draft,
  );
  TradeCopyActionResult submitCopyTradingAction(TradeCopyActionRequest request);
}
