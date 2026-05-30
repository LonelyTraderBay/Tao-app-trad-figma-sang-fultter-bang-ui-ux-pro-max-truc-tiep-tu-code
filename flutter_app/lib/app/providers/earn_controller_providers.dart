import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/earn/data/providers/earn_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/earn/presentation/controllers/earn_controller.dart';

export 'package:vit_trade_flutter/features/earn/presentation/controllers/earn_controller.dart';

final savingsControllerProvider = Provider<SavingsController>((ref) {
  final snapshot = ref.watch(data.savingsRepositoryProvider).getSavings();
  return SavingsController(state: SavingsViewState(snapshot: snapshot));
});

final savingsRedeemControllerProvider =
    Provider.family<SavingsRedeemController, String>((ref, positionId) {
      final snapshot = ref
          .watch(data.savingsRedeemRepositoryProvider)
          .getRedeem(positionId: positionId);
      return SavingsRedeemController(
        state: SavingsRedeemViewState(snapshot: snapshot),
      );
    });

final savingsRiskAssessmentControllerProvider =
    Provider<SavingsRiskAssessmentController>((ref) {
      final snapshot = ref
          .watch(data.savingsRiskAssessmentRepositoryProvider)
          .getRiskAssessment();
      return SavingsRiskAssessmentController(
        state: SavingsRiskAssessmentViewState(snapshot: snapshot),
      );
    });

final stakingRiskAssessmentControllerProvider =
    Provider<StakingRiskAssessmentController>((ref) {
      final snapshot = ref
          .watch(data.stakingRiskAssessmentRepositoryProvider)
          .getRiskAssessment();
      return StakingRiskAssessmentController(
        state: StakingRiskAssessmentViewState(snapshot: snapshot),
      );
    });

final stakingSuitabilityControllerProvider =
    Provider<StakingSuitabilityController>((ref) {
      final snapshot = ref
          .watch(data.stakingSuitabilityAssessmentRepositoryProvider)
          .getAssessment();
      return StakingSuitabilityController(
        state: StakingSuitabilityViewState(snapshot: snapshot),
      );
    });

final stakingEmergencyActionsControllerProvider =
    Provider<StakingEmergencyActionsController>((ref) {
      final snapshot = ref
          .watch(data.stakingEmergencyActionsRepositoryProvider)
          .getEmergencyActions();
      return StakingEmergencyActionsController(
        state: StakingEmergencyActionsViewState(snapshot: snapshot),
      );
    });

final stakingEarnRepositoryProvider = Provider<StakingEarnRepository>((ref) {
  return ref.watch(data.stakingEarnRepositoryProvider);
});

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  return ref.watch(data.savingsRepositoryProvider);
});

final savingsProductDetailRepositoryProvider =
    Provider<SavingsProductDetailRepository>((ref) {
      return ref.watch(data.savingsProductDetailRepositoryProvider);
    });

final savingsRedeemRepositoryProvider = Provider<SavingsRedeemRepository>((
  ref,
) {
  return ref.watch(data.savingsRedeemRepositoryProvider);
});

final savingsReceiptRepositoryProvider = Provider<SavingsReceiptRepository>((
  ref,
) {
  return ref.watch(data.savingsReceiptRepositoryProvider);
});

final savingsPortfolioRepositoryProvider = Provider<SavingsPortfolioRepository>(
  (ref) {
    return ref.watch(data.savingsPortfolioRepositoryProvider);
  },
);

final savingsHistoryRepositoryProvider = Provider<SavingsHistoryRepository>((
  ref,
) {
  return ref.watch(data.savingsHistoryRepositoryProvider);
});

final savingsGuideRepositoryProvider = Provider<SavingsGuideRepository>((ref) {
  return ref.watch(data.savingsGuideRepositoryProvider);
});

final savingsFAQRepositoryProvider = Provider<SavingsFAQRepository>((ref) {
  return ref.watch(data.savingsFAQRepositoryProvider);
});

final savingsNotificationsRepositoryProvider =
    Provider<SavingsNotificationsRepository>((ref) {
      return ref.watch(data.savingsNotificationsRepositoryProvider);
    });

final savingsRecommendationsRepositoryProvider =
    Provider<SavingsRecommendationsRepository>((ref) {
      return ref.watch(data.savingsRecommendationsRepositoryProvider);
    });

final savingsRiskAssessmentRepositoryProvider =
    Provider<SavingsRiskAssessmentRepository>((ref) {
      return ref.watch(data.savingsRiskAssessmentRepositoryProvider);
    });

final savingsComparisonRepositoryProvider =
    Provider<SavingsComparisonRepository>((ref) {
      return ref.watch(data.savingsComparisonRepositoryProvider);
    });

final autoCompoundSettingsRepositoryProvider =
    Provider<AutoCompoundSettingsRepository>((ref) {
      return ref.watch(data.autoCompoundSettingsRepositoryProvider);
    });

final savingsGoalsRepositoryProvider = Provider<SavingsGoalsRepository>((ref) {
  return ref.watch(data.savingsGoalsRepositoryProvider);
});

final savingsAnalyticsRepositoryProvider = Provider<SavingsAnalyticsRepository>(
  (ref) {
    return ref.watch(data.savingsAnalyticsRepositoryProvider);
  },
);

final savingsAutoRebalanceRepositoryProvider =
    Provider<SavingsAutoRebalanceRepository>((ref) {
      return ref.watch(data.savingsAutoRebalanceRepositoryProvider);
    });

final savingsNotificationPreferencesRepositoryProvider =
    Provider<SavingsNotificationPreferencesRepository>((ref) {
      return ref.watch(data.savingsNotificationPreferencesRepositoryProvider);
    });

final savingsDcaRepositoryProvider = Provider<SavingsDcaRepository>((ref) {
  return ref.watch(data.savingsDcaRepositoryProvider);
});

final savingsSmartSuggestionsRepositoryProvider =
    Provider<SavingsSmartSuggestionsRepository>((ref) {
      return ref.watch(data.savingsSmartSuggestionsRepositoryProvider);
    });

final savingsExportRepositoryProvider = Provider<SavingsExportRepository>((
  ref,
) {
  return ref.watch(data.savingsExportRepositoryProvider);
});

final savingsBacktestRepositoryProvider = Provider<SavingsBacktestRepository>((
  ref,
) {
  return ref.watch(data.savingsBacktestRepositoryProvider);
});

final savingsAutoPilotRepositoryProvider = Provider<SavingsAutoPilotRepository>(
  (ref) {
    return ref.watch(data.savingsAutoPilotRepositoryProvider);
  },
);

final savingsLadderRepositoryProvider = Provider<SavingsLadderRepository>((
  ref,
) {
  return ref.watch(data.savingsLadderRepositoryProvider);
});

final savingsWhatIfRepositoryProvider = Provider<SavingsWhatIfRepository>((
  ref,
) {
  return ref.watch(data.savingsWhatIfRepositoryProvider);
});

final stakingTermsRepositoryProvider = Provider<StakingTermsRepository>((ref) {
  return ref.watch(data.stakingTermsRepositoryProvider);
});

final stakingRiskDisclosureRepositoryProvider =
    Provider<StakingRiskDisclosureRepository>((ref) {
      return ref.watch(data.stakingRiskDisclosureRepositoryProvider);
    });

final stakingWithdrawalPolicyRepositoryProvider =
    Provider<StakingWithdrawalPolicyRepository>((ref) {
      return ref.watch(data.stakingWithdrawalPolicyRepositoryProvider);
    });

final stakingTaxGuideRepositoryProvider = Provider<StakingTaxGuideRepository>((
  ref,
) {
  return ref.watch(data.stakingTaxGuideRepositoryProvider);
});

final stakingRiskAssessmentRepositoryProvider =
    Provider<StakingRiskAssessmentRepository>((ref) {
      return ref.watch(data.stakingRiskAssessmentRepositoryProvider);
    });

final stakingDashboardRepositoryProvider = Provider<StakingDashboardRepository>(
  (ref) {
    return ref.watch(data.stakingDashboardRepositoryProvider);
  },
);

final stakingAnalyticsRepositoryProvider = Provider<StakingAnalyticsRepository>(
  (ref) {
    return ref.watch(data.stakingAnalyticsRepositoryProvider);
  },
);

final stakingHistoryRepositoryProvider = Provider<StakingHistoryRepository>((
  ref,
) {
  return ref.watch(data.stakingHistoryRepositoryProvider);
});

final stakingEarningsCalendarRepositoryProvider =
    Provider<StakingEarningsCalendarRepository>((ref) {
      return ref.watch(data.stakingEarningsCalendarRepositoryProvider);
    });

final stakingValidatorSelectionRepositoryProvider =
    Provider<StakingValidatorSelectionRepository>((ref) {
      return ref.watch(data.stakingValidatorSelectionRepositoryProvider);
    });

final stakingAutoCompoundRepositoryProvider =
    Provider<StakingAutoCompoundRepository>((ref) {
      return ref.watch(data.stakingAutoCompoundRepositoryProvider);
    });

final stakingLiquidStakingRepositoryProvider =
    Provider<StakingLiquidStakingRepository>((ref) {
      return ref.watch(data.stakingLiquidStakingRepositoryProvider);
    });

final stakingInsuranceRepositoryProvider = Provider<StakingInsuranceRepository>(
  (ref) {
    return ref.watch(data.stakingInsuranceRepositoryProvider);
  },
);

final stakingInsuranceFundTransparencyRepositoryProvider =
    Provider<StakingInsuranceFundTransparencyRepository>((ref) {
      return ref.watch(data.stakingInsuranceFundTransparencyRepositoryProvider);
    });

final stakingTransactionReportingRepositoryProvider =
    Provider<StakingTransactionReportingRepository>((ref) {
      return ref.watch(data.stakingTransactionReportingRepositoryProvider);
    });

final stakingApiDocumentationRepositoryProvider =
    Provider<StakingApiDocumentationRepository>((ref) {
      return ref.watch(data.stakingApiDocumentationRepositoryProvider);
    });

final stakingProofOfReservesRepositoryProvider =
    Provider<StakingProofOfReservesRepository>((ref) {
      return ref.watch(data.stakingProofOfReservesRepositoryProvider);
    });

final stakingRiskDashboardRepositoryProvider =
    Provider<StakingRiskDashboardRepository>((ref) {
      return ref.watch(data.stakingRiskDashboardRepositoryProvider);
    });

final stakingSlashingHistoryRepositoryProvider =
    Provider<StakingSlashingHistoryRepository>((ref) {
      return ref.watch(data.stakingSlashingHistoryRepositoryProvider);
    });

final stakingValidatorHealthMonitorRepositoryProvider =
    Provider<StakingValidatorHealthMonitorRepository>((ref) {
      return ref.watch(data.stakingValidatorHealthMonitorRepositoryProvider);
    });

final stakingRiskScoreCalculatorRepositoryProvider =
    Provider<StakingRiskScoreCalculatorRepository>((ref) {
      return ref.watch(data.stakingRiskScoreCalculatorRepositoryProvider);
    });

final stakingEmergencyActionsRepositoryProvider =
    Provider<StakingEmergencyActionsRepository>((ref) {
      return ref.watch(data.stakingEmergencyActionsRepositoryProvider);
    });

final stakingContingencyPlanRepositoryProvider =
    Provider<StakingContingencyPlanRepository>((ref) {
      return ref.watch(data.stakingContingencyPlanRepositoryProvider);
    });

final stakingSocialFeedRepositoryProvider =
    Provider<StakingSocialFeedRepository>((ref) {
      return ref.watch(data.stakingSocialFeedRepositoryProvider);
    });

final stakingCommunityGovernanceRepositoryProvider =
    Provider<StakingCommunityGovernanceRepository>((ref) {
      return ref.watch(data.stakingCommunityGovernanceRepositoryProvider);
    });

final stakingProposalsRepositoryProvider = Provider<StakingProposalsRepository>(
  (ref) {
    return ref.watch(data.stakingProposalsRepositoryProvider);
  },
);

final stakingVotingRepositoryProvider = Provider<StakingVotingRepository>((
  ref,
) {
  return ref.watch(data.stakingVotingRepositoryProvider);
});

final stakingForumRepositoryProvider = Provider<StakingForumRepository>((ref) {
  return ref.watch(data.stakingForumRepositoryProvider);
});

final stakingWebhooksRepositoryProvider = Provider<StakingWebhooksRepository>((
  ref,
) {
  return ref.watch(data.stakingWebhooksRepositoryProvider);
});

final stakingDataExportRepositoryProvider =
    Provider<StakingDataExportRepository>((ref) {
      return ref.watch(data.stakingDataExportRepositoryProvider);
    });

final stakingThirdPartyIntegrationsRepositoryProvider =
    Provider<StakingThirdPartyIntegrationsRepository>((ref) {
      return ref.watch(data.stakingThirdPartyIntegrationsRepositoryProvider);
    });

final stakingDeveloperConsoleRepositoryProvider =
    Provider<StakingDeveloperConsoleRepository>((ref) {
      return ref.watch(data.stakingDeveloperConsoleRepositoryProvider);
    });

final stakingAdvancedOrdersRepositoryProvider =
    Provider<StakingAdvancedOrdersRepository>((ref) {
      return ref.watch(data.stakingAdvancedOrdersRepositoryProvider);
    });

final stakingMultiChainRepositoryProvider =
    Provider<StakingMultiChainRepository>((ref) {
      return ref.watch(data.stakingMultiChainRepositoryProvider);
    });

final stakingInstitutionalRepositoryProvider =
    Provider<StakingInstitutionalRepository>((ref) {
      return ref.watch(data.stakingInstitutionalRepositoryProvider);
    });

final stakingGuideRepositoryProvider = Provider<StakingGuideRepository>((ref) {
  return ref.watch(data.stakingGuideRepositoryProvider);
});

final stakingFAQRepositoryProvider = Provider<StakingFAQRepository>((ref) {
  return ref.watch(data.stakingFAQRepositoryProvider);
});

final stakingNotificationsRepositoryProvider =
    Provider<StakingNotificationsRepository>((ref) {
      return ref.watch(data.stakingNotificationsRepositoryProvider);
    });

final stakingRecommendationsRepositoryProvider =
    Provider<StakingRecommendationsRepository>((ref) {
      return ref.watch(data.stakingRecommendationsRepositoryProvider);
    });

final stakingRegulatoryFrameworkRepositoryProvider =
    Provider<StakingRegulatoryFrameworkRepository>((ref) {
      return ref.watch(data.stakingRegulatoryFrameworkRepositoryProvider);
    });

final stakingAuditReportsRepositoryProvider =
    Provider<StakingAuditReportsRepository>((ref) {
      return ref.watch(data.stakingAuditReportsRepositoryProvider);
    });

final stakingCustodyRepositoryProvider = Provider<StakingCustodyRepository>((
  ref,
) {
  return ref.watch(data.stakingCustodyRepositoryProvider);
});

final stakingSuitabilityAssessmentRepositoryProvider =
    Provider<StakingSuitabilityAssessmentRepository>((ref) {
      return ref.watch(data.stakingSuitabilityAssessmentRepositoryProvider);
    });
