import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/earn/domain/repositories/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn/data/repositories/mock_earn_repository.dart';

final stakingEarnRepositoryProvider = Provider<StakingEarnRepository>((ref) {
  return const MockStakingEarnRepository();
});

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  return const MockSavingsRepository();
});

final savingsProductDetailRepositoryProvider =
    Provider<SavingsProductDetailRepository>((ref) {
      return const MockSavingsProductDetailRepository();
    });

final savingsRedeemRepositoryProvider = Provider<SavingsRedeemRepository>((
  ref,
) {
  return const MockSavingsRedeemRepository();
});

final savingsReceiptRepositoryProvider = Provider<SavingsReceiptRepository>((
  ref,
) {
  return const MockSavingsReceiptRepository();
});

final savingsPortfolioRepositoryProvider = Provider<SavingsPortfolioRepository>(
  (ref) {
    return const MockSavingsPortfolioRepository();
  },
);

final savingsHistoryRepositoryProvider = Provider<SavingsHistoryRepository>((
  ref,
) {
  return const MockSavingsHistoryRepository();
});

final savingsGuideRepositoryProvider = Provider<SavingsGuideRepository>((ref) {
  return const MockSavingsGuideRepository();
});

final savingsFAQRepositoryProvider = Provider<SavingsFAQRepository>((ref) {
  return const MockSavingsFAQRepository();
});

final savingsNotificationsRepositoryProvider =
    Provider<SavingsNotificationsRepository>((ref) {
      return const MockSavingsNotificationsRepository();
    });

final savingsRecommendationsRepositoryProvider =
    Provider<SavingsRecommendationsRepository>((ref) {
      return const MockSavingsRecommendationsRepository();
    });

final savingsRiskAssessmentRepositoryProvider =
    Provider<SavingsRiskAssessmentRepository>((ref) {
      return const MockSavingsRiskAssessmentRepository();
    });

final savingsComparisonRepositoryProvider =
    Provider<SavingsComparisonRepository>((ref) {
      return const MockSavingsComparisonRepository();
    });

final autoCompoundSettingsRepositoryProvider =
    Provider<AutoCompoundSettingsRepository>((ref) {
      return const MockAutoCompoundSettingsRepository();
    });

final savingsGoalsRepositoryProvider = Provider<SavingsGoalsRepository>((ref) {
  return const MockSavingsGoalsRepository();
});

final savingsAnalyticsRepositoryProvider = Provider<SavingsAnalyticsRepository>(
  (ref) {
    return const MockSavingsAnalyticsRepository();
  },
);

final savingsAutoRebalanceRepositoryProvider =
    Provider<SavingsAutoRebalanceRepository>((ref) {
      return const MockSavingsAutoRebalanceRepository();
    });

final savingsNotificationPreferencesRepositoryProvider =
    Provider<SavingsNotificationPreferencesRepository>((ref) {
      return const MockSavingsNotificationPreferencesRepository();
    });

final savingsDcaRepositoryProvider = Provider<SavingsDcaRepository>((ref) {
  return const MockSavingsDcaRepository();
});

final savingsSmartSuggestionsRepositoryProvider =
    Provider<SavingsSmartSuggestionsRepository>((ref) {
      return const MockSavingsSmartSuggestionsRepository();
    });

final savingsExportRepositoryProvider = Provider<SavingsExportRepository>((
  ref,
) {
  return const MockSavingsExportRepository();
});

final savingsBacktestRepositoryProvider = Provider<SavingsBacktestRepository>((
  ref,
) {
  return const MockSavingsBacktestRepository();
});

final savingsAutoPilotRepositoryProvider = Provider<SavingsAutoPilotRepository>(
  (ref) {
    return const MockSavingsAutoPilotRepository();
  },
);

final savingsLadderRepositoryProvider = Provider<SavingsLadderRepository>((
  ref,
) {
  return const MockSavingsLadderRepository();
});

final savingsWhatIfRepositoryProvider = Provider<SavingsWhatIfRepository>((
  ref,
) {
  return const MockSavingsWhatIfRepository();
});

final stakingTermsRepositoryProvider = Provider<StakingTermsRepository>((ref) {
  return const MockStakingTermsRepository();
});

final stakingRiskDisclosureRepositoryProvider =
    Provider<StakingRiskDisclosureRepository>((ref) {
      return const MockStakingRiskDisclosureRepository();
    });

final stakingWithdrawalPolicyRepositoryProvider =
    Provider<StakingWithdrawalPolicyRepository>((ref) {
      return const MockStakingWithdrawalPolicyRepository();
    });

final stakingTaxGuideRepositoryProvider = Provider<StakingTaxGuideRepository>((
  ref,
) {
  return const MockStakingTaxGuideRepository();
});

final stakingRiskAssessmentRepositoryProvider =
    Provider<StakingRiskAssessmentRepository>((ref) {
      return const MockStakingRiskAssessmentRepository();
    });

final stakingDashboardRepositoryProvider = Provider<StakingDashboardRepository>(
  (ref) {
    return const MockStakingDashboardRepository();
  },
);

final stakingAnalyticsRepositoryProvider = Provider<StakingAnalyticsRepository>(
  (ref) {
    return const MockStakingAnalyticsRepository();
  },
);

final stakingHistoryRepositoryProvider = Provider<StakingHistoryRepository>((
  ref,
) {
  return const MockStakingHistoryRepository();
});

final stakingEarningsCalendarRepositoryProvider =
    Provider<StakingEarningsCalendarRepository>((ref) {
      return const MockStakingEarningsCalendarRepository();
    });

final stakingValidatorSelectionRepositoryProvider =
    Provider<StakingValidatorSelectionRepository>((ref) {
      return const MockStakingValidatorSelectionRepository();
    });

final stakingAutoCompoundRepositoryProvider =
    Provider<StakingAutoCompoundRepository>((ref) {
      return const MockStakingAutoCompoundRepository();
    });

final stakingLiquidStakingRepositoryProvider =
    Provider<StakingLiquidStakingRepository>((ref) {
      return const MockStakingLiquidStakingRepository();
    });

final stakingInsuranceRepositoryProvider = Provider<StakingInsuranceRepository>(
  (ref) {
    return const MockStakingInsuranceRepository();
  },
);

final stakingInsuranceFundTransparencyRepositoryProvider =
    Provider<StakingInsuranceFundTransparencyRepository>((ref) {
      return const MockStakingInsuranceFundTransparencyRepository();
    });

final stakingTransactionReportingRepositoryProvider =
    Provider<StakingTransactionReportingRepository>((ref) {
      return const MockStakingTransactionReportingRepository();
    });

final stakingApiDocumentationRepositoryProvider =
    Provider<StakingApiDocumentationRepository>((ref) {
      return const MockStakingApiDocumentationRepository();
    });

final stakingProofOfReservesRepositoryProvider =
    Provider<StakingProofOfReservesRepository>((ref) {
      return const MockStakingProofOfReservesRepository();
    });

final stakingRiskDashboardRepositoryProvider =
    Provider<StakingRiskDashboardRepository>((ref) {
      return const MockStakingRiskDashboardRepository();
    });

final stakingSlashingHistoryRepositoryProvider =
    Provider<StakingSlashingHistoryRepository>((ref) {
      return const MockStakingSlashingHistoryRepository();
    });

final stakingValidatorHealthMonitorRepositoryProvider =
    Provider<StakingValidatorHealthMonitorRepository>((ref) {
      return const MockStakingValidatorHealthMonitorRepository();
    });

final stakingRiskScoreCalculatorRepositoryProvider =
    Provider<StakingRiskScoreCalculatorRepository>((ref) {
      return const MockStakingRiskScoreCalculatorRepository();
    });

final stakingEmergencyActionsRepositoryProvider =
    Provider<StakingEmergencyActionsRepository>((ref) {
      return const MockStakingEmergencyActionsRepository();
    });

final stakingContingencyPlanRepositoryProvider =
    Provider<StakingContingencyPlanRepository>((ref) {
      return const MockStakingContingencyPlanRepository();
    });

final stakingSocialFeedRepositoryProvider =
    Provider<StakingSocialFeedRepository>((ref) {
      return const MockStakingSocialFeedRepository();
    });

final stakingCommunityGovernanceRepositoryProvider =
    Provider<StakingCommunityGovernanceRepository>((ref) {
      return const MockStakingCommunityGovernanceRepository();
    });

final stakingProposalsRepositoryProvider = Provider<StakingProposalsRepository>(
  (ref) {
    return const MockStakingProposalsRepository();
  },
);

final stakingVotingRepositoryProvider = Provider<StakingVotingRepository>((
  ref,
) {
  return const MockStakingVotingRepository();
});

final stakingForumRepositoryProvider = Provider<StakingForumRepository>((ref) {
  return const MockStakingForumRepository();
});

final stakingWebhooksRepositoryProvider = Provider<StakingWebhooksRepository>((
  ref,
) {
  return const MockStakingWebhooksRepository();
});

final stakingDataExportRepositoryProvider =
    Provider<StakingDataExportRepository>((ref) {
      return const MockStakingDataExportRepository();
    });

final stakingThirdPartyIntegrationsRepositoryProvider =
    Provider<StakingThirdPartyIntegrationsRepository>((ref) {
      return const MockStakingThirdPartyIntegrationsRepository();
    });

final stakingDeveloperConsoleRepositoryProvider =
    Provider<StakingDeveloperConsoleRepository>((ref) {
      return const MockStakingDeveloperConsoleRepository();
    });

final stakingAdvancedOrdersRepositoryProvider =
    Provider<StakingAdvancedOrdersRepository>((ref) {
      return const MockStakingAdvancedOrdersRepository();
    });

final stakingMultiChainRepositoryProvider =
    Provider<StakingMultiChainRepository>((ref) {
      return const MockStakingMultiChainRepository();
    });

final stakingInstitutionalRepositoryProvider =
    Provider<StakingInstitutionalRepository>((ref) {
      return const MockStakingInstitutionalRepository();
    });

final stakingGuideRepositoryProvider = Provider<StakingGuideRepository>((ref) {
  return const MockStakingGuideRepository();
});

final stakingFAQRepositoryProvider = Provider<StakingFAQRepository>((ref) {
  return const MockStakingFAQRepository();
});

final stakingNotificationsRepositoryProvider =
    Provider<StakingNotificationsRepository>((ref) {
      return const MockStakingNotificationsRepository();
    });

final stakingRecommendationsRepositoryProvider =
    Provider<StakingRecommendationsRepository>((ref) {
      return const MockStakingRecommendationsRepository();
    });

final stakingRegulatoryFrameworkRepositoryProvider =
    Provider<StakingRegulatoryFrameworkRepository>((ref) {
      return const MockStakingRegulatoryFrameworkRepository();
    });

final stakingAuditReportsRepositoryProvider =
    Provider<StakingAuditReportsRepository>((ref) {
      return const MockStakingAuditReportsRepository();
    });

final stakingCustodyRepositoryProvider = Provider<StakingCustodyRepository>((
  ref,
) {
  return const MockStakingCustodyRepository();
});

final stakingSuitabilityAssessmentRepositoryProvider =
    Provider<StakingSuitabilityAssessmentRepository>((ref) {
      return const MockStakingSuitabilityAssessmentRepository();
    });
