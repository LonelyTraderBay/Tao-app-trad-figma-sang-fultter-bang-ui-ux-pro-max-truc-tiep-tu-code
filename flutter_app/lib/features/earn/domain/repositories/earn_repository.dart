import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';

/// Repository contract for fetching a [StakingEarnSnapshot].
abstract interface class StakingEarnRepository {
  StakingEarnSnapshot getStakingEarn({
    StakingEarnRoute route = StakingEarnRoute.earn,
  });
}

/// Repository contract for fetching a [SavingsSnapshot].
abstract interface class SavingsRepository {
  SavingsSnapshot getSavings();
}

/// Repository contract for fetching a [SavingsProductDetailSnapshot].
abstract interface class SavingsProductDetailRepository {
  SavingsProductDetailSnapshot getProductDetail({required String productId});
}

/// Repository contract for fetching a [SavingsRedeemSnapshot].
abstract interface class SavingsRedeemRepository {
  SavingsRedeemSnapshot getRedeem({required String positionId});
}

/// Repository contract for fetching a [SavingsReceiptSnapshot].
abstract interface class SavingsReceiptRepository {
  SavingsReceiptSnapshot getReceipt();
}

/// Repository contract for fetching a [SavingsPortfolioSnapshot].
abstract interface class SavingsPortfolioRepository {
  SavingsPortfolioSnapshot getPortfolio();
}

/// Repository contract for fetching a [SavingsHistorySnapshot].
abstract interface class SavingsHistoryRepository {
  SavingsHistorySnapshot getHistory();
}

/// Repository contract for fetching a [SavingsGuideSnapshot].
abstract interface class SavingsGuideRepository {
  SavingsGuideSnapshot getGuide();
}

/// Repository contract for fetching a [SavingsFAQSnapshot].
abstract interface class SavingsFAQRepository {
  SavingsFAQSnapshot getFAQ();
}

/// Repository contract for fetching a [SavingsNotificationsSnapshot].
abstract interface class SavingsNotificationsRepository {
  SavingsNotificationsSnapshot getNotifications();
}

/// Repository contract for fetching a [SavingsRecommendationsSnapshot].
abstract interface class SavingsRecommendationsRepository {
  SavingsRecommendationsSnapshot getRecommendations();
}

/// Repository contract for fetching a [SavingsRiskAssessmentSnapshot].
abstract interface class SavingsRiskAssessmentRepository {
  SavingsRiskAssessmentSnapshot getRiskAssessment();
}

/// Repository contract for fetching a [SavingsComparisonSnapshot].
abstract interface class SavingsComparisonRepository {
  SavingsComparisonSnapshot getComparison();
}

/// Repository contract for fetching a [AutoCompoundSettingsSnapshot].
abstract interface class AutoCompoundSettingsRepository {
  AutoCompoundSettingsSnapshot getSettings();
}

/// Repository contract for fetching a [SavingsGoalsSnapshot].
abstract interface class SavingsGoalsRepository {
  SavingsGoalsSnapshot getGoals();
}

/// Repository contract for fetching a [SavingsAnalyticsSnapshot].
abstract interface class SavingsAnalyticsRepository {
  SavingsAnalyticsSnapshot getAnalytics();
}

/// Repository contract for fetching a [SavingsAutoRebalanceSnapshot].
abstract interface class SavingsAutoRebalanceRepository {
  SavingsAutoRebalanceSnapshot getRebalance();
}

/// Repository contract for fetching a [SavingsNotificationPreferencesSnapshot].
abstract interface class SavingsNotificationPreferencesRepository {
  SavingsNotificationPreferencesSnapshot getPreferences();
}

/// Repository contract for fetching a [SavingsDcaSnapshot].
abstract interface class SavingsDcaRepository {
  SavingsDcaSnapshot getDca();
}

/// Repository contract for fetching a [SavingsSmartSuggestionsSnapshot].
abstract interface class SavingsSmartSuggestionsRepository {
  SavingsSmartSuggestionsSnapshot getSuggestions();
}

/// Repository contract for fetching a [SavingsExportSnapshot].
abstract interface class SavingsExportRepository {
  SavingsExportSnapshot getExport();
}

/// Repository contract for fetching a [SavingsBacktestSnapshot].
abstract interface class SavingsBacktestRepository {
  SavingsBacktestSnapshot getBacktest();
}

/// Repository contract for fetching a [SavingsAutoPilotSnapshot].
abstract interface class SavingsAutoPilotRepository {
  SavingsAutoPilotSnapshot getAutoPilot();
}

/// Repository contract for fetching a [SavingsLadderSnapshot].
abstract interface class SavingsLadderRepository {
  SavingsLadderSnapshot getLadder();
}

/// Repository contract for fetching a [SavingsWhatIfSnapshot].
abstract interface class SavingsWhatIfRepository {
  SavingsWhatIfSnapshot getWhatIf();
}

/// Repository contract for fetching a [StakingTermsSnapshot].
abstract interface class StakingTermsRepository {
  StakingTermsSnapshot getTerms();
}

/// Repository contract for fetching a [StakingRiskDisclosureSnapshot].
abstract interface class StakingRiskDisclosureRepository {
  StakingRiskDisclosureSnapshot getDisclosure();
}

/// Repository contract for fetching a [StakingRiskAssessmentSnapshot].
abstract interface class StakingRiskAssessmentRepository {
  StakingRiskAssessmentSnapshot getRiskAssessment();
}

/// Repository contract for fetching a [StakingDashboardSnapshot].
abstract interface class StakingDashboardRepository {
  StakingDashboardSnapshot getDashboard();
}

/// Repository contract for fetching a [StakingAnalyticsSnapshot].
abstract interface class StakingAnalyticsRepository {
  StakingAnalyticsSnapshot getAnalytics();
}

/// Repository contract for fetching a [StakingHistorySnapshot].
abstract interface class StakingHistoryRepository {
  StakingHistorySnapshot getHistory();
}

/// Repository contract for fetching a [StakingEarningsCalendarSnapshot].
abstract interface class StakingEarningsCalendarRepository {
  StakingEarningsCalendarSnapshot getCalendar();
}

/// Repository contract for fetching a [StakingValidatorSelectionSnapshot].
abstract interface class StakingValidatorSelectionRepository {
  StakingValidatorSelectionSnapshot getSelection();
}

/// Repository contract for fetching a [StakingAutoCompoundSnapshot].
abstract interface class StakingAutoCompoundRepository {
  StakingAutoCompoundSnapshot getAutoCompound();
}

/// Repository contract for fetching a [StakingLiquidStakingSnapshot].
abstract interface class StakingLiquidStakingRepository {
  StakingLiquidStakingSnapshot getLiquidStaking();
}

/// Repository contract for fetching a [StakingInsuranceSnapshot].
abstract interface class StakingInsuranceRepository {
  StakingInsuranceSnapshot getInsurance();
}

/// Repository contract for fetching a [StakingInsuranceFundTransparencySnapshot].
abstract interface class StakingInsuranceFundTransparencyRepository {
  StakingInsuranceFundTransparencySnapshot getTransparency();
}

/// Repository contract for fetching a [StakingTransactionReportingSnapshot].
abstract interface class StakingTransactionReportingRepository {
  StakingTransactionReportingSnapshot getReporting();
}

/// Repository contract for fetching a [StakingApiDocumentationSnapshot].
abstract interface class StakingApiDocumentationRepository {
  StakingApiDocumentationSnapshot getDocumentation();
}

/// Repository contract for fetching a [StakingProofOfReservesSnapshot].
abstract interface class StakingProofOfReservesRepository {
  StakingProofOfReservesSnapshot getProofOfReserves();
}

/// Repository contract for fetching a [StakingRiskDashboardSnapshot].
abstract interface class StakingRiskDashboardRepository {
  StakingRiskDashboardSnapshot getRiskDashboard();
}

/// Repository contract for fetching a [StakingSlashingHistorySnapshot].
abstract interface class StakingSlashingHistoryRepository {
  StakingSlashingHistorySnapshot getSlashingHistory();
}

/// Repository contract for fetching a [StakingValidatorHealthMonitorSnapshot].
abstract interface class StakingValidatorHealthMonitorRepository {
  StakingValidatorHealthMonitorSnapshot getValidatorHealth();
}

/// Repository contract for fetching a [StakingRiskScoreCalculatorSnapshot].
abstract interface class StakingRiskScoreCalculatorRepository {
  StakingRiskScoreCalculatorSnapshot getCalculator();
}

/// Repository contract for fetching a [StakingEmergencyActionsSnapshot].
abstract interface class StakingEmergencyActionsRepository {
  StakingEmergencyActionsSnapshot getEmergencyActions();
}

/// Repository contract for fetching a [StakingContingencyPlanSnapshot].
abstract interface class StakingContingencyPlanRepository {
  StakingContingencyPlanSnapshot getContingencyPlan();
}

/// Repository contract for fetching a [StakingSocialFeedSnapshot].
abstract interface class StakingSocialFeedRepository {
  StakingSocialFeedSnapshot getFeed();
}

/// Repository contract for fetching a [StakingCommunityGovernanceSnapshot].
abstract interface class StakingCommunityGovernanceRepository {
  StakingCommunityGovernanceSnapshot getGovernance();
}

/// Repository contract for fetching a [StakingProposalsSnapshot].
abstract interface class StakingProposalsRepository {
  StakingProposalsSnapshot getProposals();
}

/// Repository contract for fetching a [StakingVotingSnapshot].
abstract interface class StakingVotingRepository {
  StakingVotingSnapshot getVoting({String? proposalId});
}

/// Repository contract for fetching a [StakingForumSnapshot].
abstract interface class StakingForumRepository {
  StakingForumSnapshot getForum();
}

/// Repository contract for fetching a [StakingWebhooksSnapshot].
abstract interface class StakingWebhooksRepository {
  StakingWebhooksSnapshot getWebhooks();
}

/// Repository contract for fetching a [StakingDataExportSnapshot].
abstract interface class StakingDataExportRepository {
  StakingDataExportSnapshot getDataExport();
}

/// Repository contract for fetching a [StakingThirdPartyIntegrationsSnapshot].
abstract interface class StakingThirdPartyIntegrationsRepository {
  StakingThirdPartyIntegrationsSnapshot getIntegrations();
}

/// Repository contract for fetching a [StakingDeveloperConsoleSnapshot].
abstract interface class StakingDeveloperConsoleRepository {
  StakingDeveloperConsoleSnapshot getConsole();
}

/// Repository contract for fetching a [StakingAdvancedOrdersSnapshot].
abstract interface class StakingAdvancedOrdersRepository {
  StakingAdvancedOrdersSnapshot getAdvancedOrders();
}

/// Repository contract for fetching a [StakingMultiChainSnapshot].
abstract interface class StakingMultiChainRepository {
  StakingMultiChainSnapshot getMultiChain();
}

/// Repository contract for fetching a [StakingInstitutionalSnapshot].
abstract interface class StakingInstitutionalRepository {
  StakingInstitutionalSnapshot getInstitutional();
}

/// Repository contract for fetching a [StakingGuideSnapshot].
abstract interface class StakingGuideRepository {
  StakingGuideSnapshot getGuide();
}

/// Repository contract for fetching a [StakingFAQSnapshot].
abstract interface class StakingFAQRepository {
  StakingFAQSnapshot getFAQ();
}

/// Repository contract for fetching a [StakingNotificationsSnapshot].
abstract interface class StakingNotificationsRepository {
  StakingNotificationsSnapshot getNotifications();
}

/// Repository contract for fetching a [StakingRecommendationsSnapshot].
abstract interface class StakingRecommendationsRepository {
  StakingRecommendationsSnapshot getRecommendations();
}

/// Repository contract for fetching a [StakingRegulatoryFrameworkSnapshot].
abstract interface class StakingRegulatoryFrameworkRepository {
  StakingRegulatoryFrameworkSnapshot getFramework();
}

/// Repository contract for fetching a [StakingAuditReportsSnapshot].
abstract interface class StakingAuditReportsRepository {
  StakingAuditReportsSnapshot getAuditReports();
}

/// Repository contract for fetching a [StakingCustodySnapshot].
abstract interface class StakingCustodyRepository {
  StakingCustodySnapshot getCustody();
}

/// Repository contract for fetching a [StakingSuitabilityAssessmentSnapshot].
abstract interface class StakingSuitabilityAssessmentRepository {
  StakingSuitabilityAssessmentSnapshot getAssessment();
}

/// Repository contract for fetching a [StakingWithdrawalPolicySnapshot].
abstract interface class StakingWithdrawalPolicyRepository {
  StakingWithdrawalPolicySnapshot getPolicy();
}

/// Repository contract for fetching a [StakingTaxGuideSnapshot].
abstract interface class StakingTaxGuideRepository {
  StakingTaxGuideSnapshot getGuide();
}
