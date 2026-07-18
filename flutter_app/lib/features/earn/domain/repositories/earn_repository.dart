import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';

/// Repository contract for fetching a [StakingEarnSnapshot].
abstract interface class StakingEarnRepository {
  Future<StakingEarnSnapshot> getStakingEarn({
    StakingEarnRoute route = StakingEarnRoute.earn,
  });
}

/// Repository contract for fetching a [SavingsSnapshot].
abstract interface class SavingsRepository {
  Future<SavingsSnapshot> getSavings();
}

/// Repository contract for fetching a [SavingsProductDetailSnapshot].
abstract interface class SavingsProductDetailRepository {
  Future<SavingsProductDetailSnapshot> getProductDetail({
    required String productId,
  });
}

/// Repository contract for fetching a [SavingsRedeemSnapshot].
abstract interface class SavingsRedeemRepository {
  Future<SavingsRedeemSnapshot> getRedeem({required String positionId});
}

/// Repository contract for fetching a [SavingsReceiptSnapshot].
abstract interface class SavingsReceiptRepository {
  Future<SavingsReceiptSnapshot> getReceipt();
}

/// Repository contract for fetching a [SavingsPortfolioSnapshot].
abstract interface class SavingsPortfolioRepository {
  Future<SavingsPortfolioSnapshot> getPortfolio();
}

/// Repository contract for fetching a [SavingsHistorySnapshot].
abstract interface class SavingsHistoryRepository {
  Future<SavingsHistorySnapshot> getHistory();
}

/// Repository contract for fetching a [SavingsGuideSnapshot].
abstract interface class SavingsGuideRepository {
  Future<SavingsGuideSnapshot> getGuide();
}

/// Repository contract for fetching a [SavingsFAQSnapshot].
abstract interface class SavingsFAQRepository {
  Future<SavingsFAQSnapshot> getFAQ();
}

/// Repository contract for fetching a [SavingsNotificationsSnapshot].
abstract interface class SavingsNotificationsRepository {
  Future<SavingsNotificationsSnapshot> getNotifications();
}

/// Repository contract for fetching a [SavingsRecommendationsSnapshot].
abstract interface class SavingsRecommendationsRepository {
  Future<SavingsRecommendationsSnapshot> getRecommendations();
}

/// Repository contract for fetching a [SavingsRiskAssessmentSnapshot].
abstract interface class SavingsRiskAssessmentRepository {
  Future<SavingsRiskAssessmentSnapshot> getRiskAssessment();
}

/// Repository contract for fetching a [SavingsComparisonSnapshot].
abstract interface class SavingsComparisonRepository {
  Future<SavingsComparisonSnapshot> getComparison();
}

/// Repository contract for fetching a [AutoCompoundSettingsSnapshot].
abstract interface class AutoCompoundSettingsRepository {
  Future<AutoCompoundSettingsSnapshot> getSettings();
}

/// Repository contract for fetching a [SavingsGoalsSnapshot].
abstract interface class SavingsGoalsRepository {
  Future<SavingsGoalsSnapshot> getGoals();
}

/// Repository contract for fetching a [SavingsAnalyticsSnapshot].
abstract interface class SavingsAnalyticsRepository {
  Future<SavingsAnalyticsSnapshot> getAnalytics();
}

/// Repository contract for fetching a [SavingsAutoRebalanceSnapshot].
abstract interface class SavingsAutoRebalanceRepository {
  Future<SavingsAutoRebalanceSnapshot> getRebalance();
}

/// Repository contract for fetching a [SavingsNotificationPreferencesSnapshot].
abstract interface class SavingsNotificationPreferencesRepository {
  Future<SavingsNotificationPreferencesSnapshot> getPreferences();
}

/// Repository contract for fetching a [SavingsDcaSnapshot].
abstract interface class SavingsDcaRepository {
  Future<SavingsDcaSnapshot> getDca();
}

/// Repository contract for fetching a [SavingsSmartSuggestionsSnapshot].
abstract interface class SavingsSmartSuggestionsRepository {
  Future<SavingsSmartSuggestionsSnapshot> getSuggestions();
}

/// Repository contract for fetching a [SavingsExportSnapshot].
abstract interface class SavingsExportRepository {
  Future<SavingsExportSnapshot> getExport();
}

/// Repository contract for fetching a [SavingsBacktestSnapshot].
abstract interface class SavingsBacktestRepository {
  Future<SavingsBacktestSnapshot> getBacktest();
}

/// Repository contract for fetching a [SavingsAutoPilotSnapshot].
abstract interface class SavingsAutoPilotRepository {
  Future<SavingsAutoPilotSnapshot> getAutoPilot();
}

/// Repository contract for fetching a [SavingsLadderSnapshot].
abstract interface class SavingsLadderRepository {
  Future<SavingsLadderSnapshot> getLadder();
}

/// Repository contract for fetching a [SavingsWhatIfSnapshot].
abstract interface class SavingsWhatIfRepository {
  Future<SavingsWhatIfSnapshot> getWhatIf();
}

/// Repository contract for fetching a [StakingTermsSnapshot].
abstract interface class StakingTermsRepository {
  Future<StakingTermsSnapshot> getTerms();
}

/// Repository contract for fetching a [StakingRiskDisclosureSnapshot].
abstract interface class StakingRiskDisclosureRepository {
  Future<StakingRiskDisclosureSnapshot> getDisclosure();
}

/// Repository contract for fetching a [StakingRiskAssessmentSnapshot].
abstract interface class StakingRiskAssessmentRepository {
  Future<StakingRiskAssessmentSnapshot> getRiskAssessment();
}

/// Repository contract for fetching a [StakingDashboardSnapshot].
abstract interface class StakingDashboardRepository {
  Future<StakingDashboardSnapshot> getDashboard();
}

/// Repository contract for fetching a [StakingAnalyticsSnapshot].
abstract interface class StakingAnalyticsRepository {
  Future<StakingAnalyticsSnapshot> getAnalytics();
}

/// Repository contract for fetching a [StakingHistorySnapshot].
abstract interface class StakingHistoryRepository {
  Future<StakingHistorySnapshot> getHistory();
}

/// Repository contract for fetching a [StakingEarningsCalendarSnapshot].
abstract interface class StakingEarningsCalendarRepository {
  Future<StakingEarningsCalendarSnapshot> getCalendar();
}

/// Repository contract for fetching a [StakingValidatorSelectionSnapshot].
abstract interface class StakingValidatorSelectionRepository {
  Future<StakingValidatorSelectionSnapshot> getSelection();
}

/// Repository contract for fetching a [StakingAutoCompoundSnapshot].
abstract interface class StakingAutoCompoundRepository {
  Future<StakingAutoCompoundSnapshot> getAutoCompound();
}

/// Repository contract for fetching a [StakingLiquidStakingSnapshot].
abstract interface class StakingLiquidStakingRepository {
  Future<StakingLiquidStakingSnapshot> getLiquidStaking();
}

/// Repository contract for fetching a [StakingInsuranceSnapshot].
abstract interface class StakingInsuranceRepository {
  Future<StakingInsuranceSnapshot> getInsurance();
}

/// Repository contract for fetching a [StakingInsuranceFundTransparencySnapshot].
abstract interface class StakingInsuranceFundTransparencyRepository {
  Future<StakingInsuranceFundTransparencySnapshot> getTransparency();
}

/// Repository contract for fetching a [StakingTransactionReportingSnapshot].
abstract interface class StakingTransactionReportingRepository {
  Future<StakingTransactionReportingSnapshot> getReporting();
}

/// Repository contract for fetching a [StakingApiDocumentationSnapshot].
abstract interface class StakingApiDocumentationRepository {
  Future<StakingApiDocumentationSnapshot> getDocumentation();
}

/// Repository contract for fetching a [StakingProofOfReservesSnapshot].
abstract interface class StakingProofOfReservesRepository {
  Future<StakingProofOfReservesSnapshot> getProofOfReserves();
}

/// Repository contract for fetching a [StakingRiskDashboardSnapshot].
abstract interface class StakingRiskDashboardRepository {
  Future<StakingRiskDashboardSnapshot> getRiskDashboard();
}

/// Repository contract for fetching a [StakingSlashingHistorySnapshot].
abstract interface class StakingSlashingHistoryRepository {
  Future<StakingSlashingHistorySnapshot> getSlashingHistory();
}

/// Repository contract for fetching a [StakingValidatorHealthMonitorSnapshot].
abstract interface class StakingValidatorHealthMonitorRepository {
  Future<StakingValidatorHealthMonitorSnapshot> getValidatorHealth();
}

/// Repository contract for fetching a [StakingRiskScoreCalculatorSnapshot].
abstract interface class StakingRiskScoreCalculatorRepository {
  Future<StakingRiskScoreCalculatorSnapshot> getCalculator();
}

/// Repository contract for fetching a [StakingEmergencyActionsSnapshot].
abstract interface class StakingEmergencyActionsRepository {
  Future<StakingEmergencyActionsSnapshot> getEmergencyActions();
}

/// Repository contract for fetching a [StakingContingencyPlanSnapshot].
abstract interface class StakingContingencyPlanRepository {
  Future<StakingContingencyPlanSnapshot> getContingencyPlan();
}

/// Repository contract for fetching a [StakingSocialFeedSnapshot].
abstract interface class StakingSocialFeedRepository {
  Future<StakingSocialFeedSnapshot> getFeed();
}

/// Repository contract for fetching a [StakingCommunityGovernanceSnapshot].
abstract interface class StakingCommunityGovernanceRepository {
  Future<StakingCommunityGovernanceSnapshot> getGovernance();
}

/// Repository contract for fetching a [StakingProposalsSnapshot].
abstract interface class StakingProposalsRepository {
  Future<StakingProposalsSnapshot> getProposals();
}

/// Repository contract for fetching a [StakingVotingSnapshot].
abstract interface class StakingVotingRepository {
  Future<StakingVotingSnapshot> getVoting({String? proposalId});
}

/// Repository contract for fetching a [StakingForumSnapshot].
abstract interface class StakingForumRepository {
  Future<StakingForumSnapshot> getForum();
}

/// Repository contract for fetching a [StakingWebhooksSnapshot].
abstract interface class StakingWebhooksRepository {
  Future<StakingWebhooksSnapshot> getWebhooks();
}

/// Repository contract for fetching a [StakingDataExportSnapshot].
abstract interface class StakingDataExportRepository {
  Future<StakingDataExportSnapshot> getDataExport();
}

/// Repository contract for fetching a [StakingThirdPartyIntegrationsSnapshot].
abstract interface class StakingThirdPartyIntegrationsRepository {
  Future<StakingThirdPartyIntegrationsSnapshot> getIntegrations();
}

/// Repository contract for fetching a [StakingDeveloperConsoleSnapshot].
abstract interface class StakingDeveloperConsoleRepository {
  Future<StakingDeveloperConsoleSnapshot> getConsole();
}

/// Repository contract for fetching a [StakingAdvancedOrdersSnapshot].
abstract interface class StakingAdvancedOrdersRepository {
  Future<StakingAdvancedOrdersSnapshot> getAdvancedOrders();
}

/// Repository contract for fetching a [StakingMultiChainSnapshot].
abstract interface class StakingMultiChainRepository {
  Future<StakingMultiChainSnapshot> getMultiChain();
}

/// Repository contract for fetching a [StakingInstitutionalSnapshot].
abstract interface class StakingInstitutionalRepository {
  Future<StakingInstitutionalSnapshot> getInstitutional();
}

/// Repository contract for fetching a [StakingGuideSnapshot].
abstract interface class StakingGuideRepository {
  Future<StakingGuideSnapshot> getGuide();
}

/// Repository contract for fetching a [StakingFAQSnapshot].
abstract interface class StakingFAQRepository {
  Future<StakingFAQSnapshot> getFAQ();
}

/// Repository contract for fetching a [StakingNotificationsSnapshot].
abstract interface class StakingNotificationsRepository {
  Future<StakingNotificationsSnapshot> getNotifications();
}

/// Repository contract for fetching a [StakingRecommendationsSnapshot].
abstract interface class StakingRecommendationsRepository {
  Future<StakingRecommendationsSnapshot> getRecommendations();
}

/// Repository contract for fetching a [StakingRegulatoryFrameworkSnapshot].
abstract interface class StakingRegulatoryFrameworkRepository {
  Future<StakingRegulatoryFrameworkSnapshot> getFramework();
}

/// Repository contract for fetching a [StakingAuditReportsSnapshot].
abstract interface class StakingAuditReportsRepository {
  Future<StakingAuditReportsSnapshot> getAuditReports();
}

/// Repository contract for fetching a [StakingCustodySnapshot].
abstract interface class StakingCustodyRepository {
  Future<StakingCustodySnapshot> getCustody();
}

/// Repository contract for fetching a [StakingSuitabilityAssessmentSnapshot].
abstract interface class StakingSuitabilityAssessmentRepository {
  Future<StakingSuitabilityAssessmentSnapshot> getAssessment();
}

/// Repository contract for fetching a [StakingWithdrawalPolicySnapshot].
abstract interface class StakingWithdrawalPolicyRepository {
  Future<StakingWithdrawalPolicySnapshot> getPolicy();
}

/// Repository contract for fetching a [StakingTaxGuideSnapshot].
abstract interface class StakingTaxGuideRepository {
  Future<StakingTaxGuideSnapshot> getGuide();
}
