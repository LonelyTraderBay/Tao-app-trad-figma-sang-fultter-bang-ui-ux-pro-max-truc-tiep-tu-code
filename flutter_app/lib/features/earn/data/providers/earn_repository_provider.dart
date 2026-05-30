import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/earn/domain/repositories/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn/data/repositories/mock_earn_repository.dart';

import '../repositories/fail_closed_earn_repository.dart';

T _guardedEarnRepository<T>(Ref ref, T Function() mock) {
  return guardedRepository(
    ref,
    featureName: 'Earn',
    mock: mock,
    failClosed: failClosedEarnRepository<T>,
  );
}

final stakingEarnRepositoryProvider = Provider<StakingEarnRepository>(
  (ref) => _guardedEarnRepository(ref, () => const MockStakingEarnRepository()),
);

final savingsRepositoryProvider = Provider<SavingsRepository>(
  (ref) => _guardedEarnRepository(ref, () => const MockSavingsRepository()),
);

final savingsProductDetailRepositoryProvider =
    Provider<SavingsProductDetailRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockSavingsProductDetailRepository(),
      ),
    );

final savingsRedeemRepositoryProvider = Provider<SavingsRedeemRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsRedeemRepository()),
);

final savingsReceiptRepositoryProvider = Provider<SavingsReceiptRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsReceiptRepository()),
);

final savingsPortfolioRepositoryProvider = Provider<SavingsPortfolioRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsPortfolioRepository()),
);

final savingsHistoryRepositoryProvider = Provider<SavingsHistoryRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsHistoryRepository()),
);

final savingsGuideRepositoryProvider = Provider<SavingsGuideRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsGuideRepository()),
);

final savingsFAQRepositoryProvider = Provider<SavingsFAQRepository>(
  (ref) => _guardedEarnRepository(ref, () => const MockSavingsFAQRepository()),
);

final savingsNotificationsRepositoryProvider =
    Provider<SavingsNotificationsRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockSavingsNotificationsRepository(),
      ),
    );

final savingsRecommendationsRepositoryProvider =
    Provider<SavingsRecommendationsRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockSavingsRecommendationsRepository(),
      ),
    );

final savingsRiskAssessmentRepositoryProvider =
    Provider<SavingsRiskAssessmentRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockSavingsRiskAssessmentRepository(),
      ),
    );

final savingsComparisonRepositoryProvider =
    Provider<SavingsComparisonRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockSavingsComparisonRepository(),
      ),
    );

final autoCompoundSettingsRepositoryProvider =
    Provider<AutoCompoundSettingsRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockAutoCompoundSettingsRepository(),
      ),
    );

final savingsGoalsRepositoryProvider = Provider<SavingsGoalsRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsGoalsRepository()),
);

final savingsAnalyticsRepositoryProvider = Provider<SavingsAnalyticsRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsAnalyticsRepository()),
);

final savingsAutoRebalanceRepositoryProvider =
    Provider<SavingsAutoRebalanceRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockSavingsAutoRebalanceRepository(),
      ),
    );

final savingsNotificationPreferencesRepositoryProvider =
    Provider<SavingsNotificationPreferencesRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockSavingsNotificationPreferencesRepository(),
      ),
    );

final savingsDcaRepositoryProvider = Provider<SavingsDcaRepository>(
  (ref) => _guardedEarnRepository(ref, () => const MockSavingsDcaRepository()),
);

final savingsSmartSuggestionsRepositoryProvider =
    Provider<SavingsSmartSuggestionsRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockSavingsSmartSuggestionsRepository(),
      ),
    );

final savingsExportRepositoryProvider = Provider<SavingsExportRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsExportRepository()),
);

final savingsBacktestRepositoryProvider = Provider<SavingsBacktestRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsBacktestRepository()),
);

final savingsAutoPilotRepositoryProvider = Provider<SavingsAutoPilotRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsAutoPilotRepository()),
);

final savingsLadderRepositoryProvider = Provider<SavingsLadderRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsLadderRepository()),
);

final savingsWhatIfRepositoryProvider = Provider<SavingsWhatIfRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockSavingsWhatIfRepository()),
);

final stakingTermsRepositoryProvider = Provider<StakingTermsRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingTermsRepository()),
);

final stakingRiskDisclosureRepositoryProvider =
    Provider<StakingRiskDisclosureRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingRiskDisclosureRepository(),
      ),
    );

final stakingWithdrawalPolicyRepositoryProvider =
    Provider<StakingWithdrawalPolicyRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingWithdrawalPolicyRepository(),
      ),
    );

final stakingTaxGuideRepositoryProvider = Provider<StakingTaxGuideRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingTaxGuideRepository()),
);

final stakingRiskAssessmentRepositoryProvider =
    Provider<StakingRiskAssessmentRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingRiskAssessmentRepository(),
      ),
    );

final stakingDashboardRepositoryProvider = Provider<StakingDashboardRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingDashboardRepository()),
);

final stakingAnalyticsRepositoryProvider = Provider<StakingAnalyticsRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingAnalyticsRepository()),
);

final stakingHistoryRepositoryProvider = Provider<StakingHistoryRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingHistoryRepository()),
);

final stakingEarningsCalendarRepositoryProvider =
    Provider<StakingEarningsCalendarRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingEarningsCalendarRepository(),
      ),
    );

final stakingValidatorSelectionRepositoryProvider =
    Provider<StakingValidatorSelectionRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingValidatorSelectionRepository(),
      ),
    );

final stakingAutoCompoundRepositoryProvider =
    Provider<StakingAutoCompoundRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingAutoCompoundRepository(),
      ),
    );

final stakingLiquidStakingRepositoryProvider =
    Provider<StakingLiquidStakingRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingLiquidStakingRepository(),
      ),
    );

final stakingInsuranceRepositoryProvider = Provider<StakingInsuranceRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingInsuranceRepository()),
);

final stakingInsuranceFundTransparencyRepositoryProvider =
    Provider<StakingInsuranceFundTransparencyRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingInsuranceFundTransparencyRepository(),
      ),
    );

final stakingTransactionReportingRepositoryProvider =
    Provider<StakingTransactionReportingRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingTransactionReportingRepository(),
      ),
    );

final stakingApiDocumentationRepositoryProvider =
    Provider<StakingApiDocumentationRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingApiDocumentationRepository(),
      ),
    );

final stakingProofOfReservesRepositoryProvider =
    Provider<StakingProofOfReservesRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingProofOfReservesRepository(),
      ),
    );

final stakingRiskDashboardRepositoryProvider =
    Provider<StakingRiskDashboardRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingRiskDashboardRepository(),
      ),
    );

final stakingSlashingHistoryRepositoryProvider =
    Provider<StakingSlashingHistoryRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingSlashingHistoryRepository(),
      ),
    );

final stakingValidatorHealthMonitorRepositoryProvider =
    Provider<StakingValidatorHealthMonitorRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingValidatorHealthMonitorRepository(),
      ),
    );

final stakingRiskScoreCalculatorRepositoryProvider =
    Provider<StakingRiskScoreCalculatorRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingRiskScoreCalculatorRepository(),
      ),
    );

final stakingEmergencyActionsRepositoryProvider =
    Provider<StakingEmergencyActionsRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingEmergencyActionsRepository(),
      ),
    );

final stakingContingencyPlanRepositoryProvider =
    Provider<StakingContingencyPlanRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingContingencyPlanRepository(),
      ),
    );

final stakingSocialFeedRepositoryProvider =
    Provider<StakingSocialFeedRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingSocialFeedRepository(),
      ),
    );

final stakingCommunityGovernanceRepositoryProvider =
    Provider<StakingCommunityGovernanceRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingCommunityGovernanceRepository(),
      ),
    );

final stakingProposalsRepositoryProvider = Provider<StakingProposalsRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingProposalsRepository()),
);

final stakingVotingRepositoryProvider = Provider<StakingVotingRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingVotingRepository()),
);

final stakingForumRepositoryProvider = Provider<StakingForumRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingForumRepository()),
);

final stakingWebhooksRepositoryProvider = Provider<StakingWebhooksRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingWebhooksRepository()),
);

final stakingDataExportRepositoryProvider =
    Provider<StakingDataExportRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingDataExportRepository(),
      ),
    );

final stakingThirdPartyIntegrationsRepositoryProvider =
    Provider<StakingThirdPartyIntegrationsRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingThirdPartyIntegrationsRepository(),
      ),
    );

final stakingDeveloperConsoleRepositoryProvider =
    Provider<StakingDeveloperConsoleRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingDeveloperConsoleRepository(),
      ),
    );

final stakingAdvancedOrdersRepositoryProvider =
    Provider<StakingAdvancedOrdersRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingAdvancedOrdersRepository(),
      ),
    );

final stakingMultiChainRepositoryProvider =
    Provider<StakingMultiChainRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingMultiChainRepository(),
      ),
    );

final stakingInstitutionalRepositoryProvider =
    Provider<StakingInstitutionalRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingInstitutionalRepository(),
      ),
    );

final stakingGuideRepositoryProvider = Provider<StakingGuideRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingGuideRepository()),
);

final stakingFAQRepositoryProvider = Provider<StakingFAQRepository>(
  (ref) => _guardedEarnRepository(ref, () => const MockStakingFAQRepository()),
);

final stakingNotificationsRepositoryProvider =
    Provider<StakingNotificationsRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingNotificationsRepository(),
      ),
    );

final stakingRecommendationsRepositoryProvider =
    Provider<StakingRecommendationsRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingRecommendationsRepository(),
      ),
    );

final stakingRegulatoryFrameworkRepositoryProvider =
    Provider<StakingRegulatoryFrameworkRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingRegulatoryFrameworkRepository(),
      ),
    );

final stakingAuditReportsRepositoryProvider =
    Provider<StakingAuditReportsRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingAuditReportsRepository(),
      ),
    );

final stakingCustodyRepositoryProvider = Provider<StakingCustodyRepository>(
  (ref) =>
      _guardedEarnRepository(ref, () => const MockStakingCustodyRepository()),
);

final stakingSuitabilityAssessmentRepositoryProvider =
    Provider<StakingSuitabilityAssessmentRepository>(
      (ref) => _guardedEarnRepository(
        ref,
        () => const MockStakingSuitabilityAssessmentRepository(),
      ),
    );
