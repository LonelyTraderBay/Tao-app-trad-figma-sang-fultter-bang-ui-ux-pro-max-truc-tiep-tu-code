import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';

abstract interface class StakingEarnRepository {
  StakingEarnSnapshot getStakingEarn({
    StakingEarnRoute route = StakingEarnRoute.earn,
  });
}

abstract interface class SavingsRepository {
  SavingsSnapshot getSavings();
}

abstract interface class SavingsProductDetailRepository {
  SavingsProductDetailSnapshot getProductDetail({required String productId});
}

abstract interface class SavingsRedeemRepository {
  SavingsRedeemSnapshot getRedeem({required String positionId});
}

abstract interface class SavingsReceiptRepository {
  SavingsReceiptSnapshot getReceipt();
}

abstract interface class SavingsPortfolioRepository {
  SavingsPortfolioSnapshot getPortfolio();
}

abstract interface class SavingsHistoryRepository {
  SavingsHistorySnapshot getHistory();
}

abstract interface class SavingsGuideRepository {
  SavingsGuideSnapshot getGuide();
}

abstract interface class SavingsFAQRepository {
  SavingsFAQSnapshot getFAQ();
}

abstract interface class SavingsNotificationsRepository {
  SavingsNotificationsSnapshot getNotifications();
}

abstract interface class SavingsRecommendationsRepository {
  SavingsRecommendationsSnapshot getRecommendations();
}

abstract interface class SavingsRiskAssessmentRepository {
  SavingsRiskAssessmentSnapshot getRiskAssessment();
}

abstract interface class SavingsComparisonRepository {
  SavingsComparisonSnapshot getComparison();
}

abstract interface class AutoCompoundSettingsRepository {
  AutoCompoundSettingsSnapshot getSettings();
}

abstract interface class SavingsGoalsRepository {
  SavingsGoalsSnapshot getGoals();
}

abstract interface class SavingsAnalyticsRepository {
  SavingsAnalyticsSnapshot getAnalytics();
}

abstract interface class SavingsAutoRebalanceRepository {
  SavingsAutoRebalanceSnapshot getRebalance();
}

abstract interface class SavingsNotificationPreferencesRepository {
  SavingsNotificationPreferencesSnapshot getPreferences();
}

abstract interface class SavingsDcaRepository {
  SavingsDcaSnapshot getDca();
}

abstract interface class SavingsSmartSuggestionsRepository {
  SavingsSmartSuggestionsSnapshot getSuggestions();
}

abstract interface class SavingsExportRepository {
  SavingsExportSnapshot getExport();
}

abstract interface class SavingsBacktestRepository {
  SavingsBacktestSnapshot getBacktest();
}

abstract interface class SavingsAutoPilotRepository {
  SavingsAutoPilotSnapshot getAutoPilot();
}

abstract interface class SavingsLadderRepository {
  SavingsLadderSnapshot getLadder();
}

abstract interface class SavingsWhatIfRepository {
  SavingsWhatIfSnapshot getWhatIf();
}

abstract interface class StakingTermsRepository {
  StakingTermsSnapshot getTerms();
}

abstract interface class StakingRiskDisclosureRepository {
  StakingRiskDisclosureSnapshot getDisclosure();
}

abstract interface class StakingRiskAssessmentRepository {
  StakingRiskAssessmentSnapshot getRiskAssessment();
}

abstract interface class StakingDashboardRepository {
  StakingDashboardSnapshot getDashboard();
}

abstract interface class StakingAnalyticsRepository {
  StakingAnalyticsSnapshot getAnalytics();
}

abstract interface class StakingHistoryRepository {
  StakingHistorySnapshot getHistory();
}

abstract interface class StakingEarningsCalendarRepository {
  StakingEarningsCalendarSnapshot getCalendar();
}

abstract interface class StakingValidatorSelectionRepository {
  StakingValidatorSelectionSnapshot getSelection();
}

abstract interface class StakingAutoCompoundRepository {
  StakingAutoCompoundSnapshot getAutoCompound();
}

abstract interface class StakingLiquidStakingRepository {
  StakingLiquidStakingSnapshot getLiquidStaking();
}

abstract interface class StakingInsuranceRepository {
  StakingInsuranceSnapshot getInsurance();
}

abstract interface class StakingInsuranceFundTransparencyRepository {
  StakingInsuranceFundTransparencySnapshot getTransparency();
}

abstract interface class StakingTransactionReportingRepository {
  StakingTransactionReportingSnapshot getReporting();
}

abstract interface class StakingApiDocumentationRepository {
  StakingApiDocumentationSnapshot getDocumentation();
}

abstract interface class StakingProofOfReservesRepository {
  StakingProofOfReservesSnapshot getProofOfReserves();
}

abstract interface class StakingRiskDashboardRepository {
  StakingRiskDashboardSnapshot getRiskDashboard();
}

abstract interface class StakingSlashingHistoryRepository {
  StakingSlashingHistorySnapshot getSlashingHistory();
}

abstract interface class StakingValidatorHealthMonitorRepository {
  StakingValidatorHealthMonitorSnapshot getValidatorHealth();
}

abstract interface class StakingRiskScoreCalculatorRepository {
  StakingRiskScoreCalculatorSnapshot getCalculator();
}

abstract interface class StakingEmergencyActionsRepository {
  StakingEmergencyActionsSnapshot getEmergencyActions();
}

abstract interface class StakingContingencyPlanRepository {
  StakingContingencyPlanSnapshot getContingencyPlan();
}

abstract interface class StakingSocialFeedRepository {
  StakingSocialFeedSnapshot getFeed();
}

abstract interface class StakingCommunityGovernanceRepository {
  StakingCommunityGovernanceSnapshot getGovernance();
}

abstract interface class StakingProposalsRepository {
  StakingProposalsSnapshot getProposals();
}

abstract interface class StakingVotingRepository {
  StakingVotingSnapshot getVoting({String? proposalId});
}

abstract interface class StakingForumRepository {
  StakingForumSnapshot getForum();
}

abstract interface class StakingWebhooksRepository {
  StakingWebhooksSnapshot getWebhooks();
}

abstract interface class StakingDataExportRepository {
  StakingDataExportSnapshot getDataExport();
}

abstract interface class StakingThirdPartyIntegrationsRepository {
  StakingThirdPartyIntegrationsSnapshot getIntegrations();
}

abstract interface class StakingDeveloperConsoleRepository {
  StakingDeveloperConsoleSnapshot getConsole();
}

abstract interface class StakingAdvancedOrdersRepository {
  StakingAdvancedOrdersSnapshot getAdvancedOrders();
}

abstract interface class StakingMultiChainRepository {
  StakingMultiChainSnapshot getMultiChain();
}

abstract interface class StakingInstitutionalRepository {
  StakingInstitutionalSnapshot getInstitutional();
}

abstract interface class StakingGuideRepository {
  StakingGuideSnapshot getGuide();
}

abstract interface class StakingFAQRepository {
  StakingFAQSnapshot getFAQ();
}

abstract interface class StakingNotificationsRepository {
  StakingNotificationsSnapshot getNotifications();
}

abstract interface class StakingRecommendationsRepository {
  StakingRecommendationsSnapshot getRecommendations();
}

abstract interface class StakingRegulatoryFrameworkRepository {
  StakingRegulatoryFrameworkSnapshot getFramework();
}

abstract interface class StakingAuditReportsRepository {
  StakingAuditReportsSnapshot getAuditReports();
}

abstract interface class StakingCustodyRepository {
  StakingCustodySnapshot getCustody();
}

abstract interface class StakingSuitabilityAssessmentRepository {
  StakingSuitabilityAssessmentSnapshot getAssessment();
}

abstract interface class StakingWithdrawalPolicyRepository {
  StakingWithdrawalPolicySnapshot getPolicy();
}

abstract interface class StakingTaxGuideRepository {
  StakingTaxGuideSnapshot getGuide();
}
