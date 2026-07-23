import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/earn_core/data/providers/earn_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/earn_core/presentation/controllers/earn_controller.dart';

export 'package:vit_trade_flutter/features/earn_core/presentation/controllers/earn_controller.dart';
export 'package:vit_trade_flutter/features/earn_core/data/providers/earn_repository_provider.dart';

// GD4 async playbook mục 3/4: một FutureProvider "snapshot" trung gian cho
// MỖI repository đọc-thuần của Earn (68 method — xem
// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md). Đa số
// trang gọi thẳng các provider này rồi `.when()` (mục 5); 6 trang có
// "controller wrapper" (SavingsController...) và 1 trang có Notifier ghi
// (SavingsNotificationPreferencesStateController) bọc thêm bên dưới.

final stakingAdvancedOrdersSnapshotProvider =
    FutureProvider<StakingAdvancedOrdersSnapshot>(
      (ref) => ref
          .watch(data.stakingAdvancedOrdersRepositoryProvider)
          .getAdvancedOrders(),
    );

final stakingAnalyticsSnapshotProvider =
    FutureProvider<StakingAnalyticsSnapshot>(
      (ref) =>
          ref.watch(data.stakingAnalyticsRepositoryProvider).getAnalytics(),
    );

final stakingApiDocumentationSnapshotProvider =
    FutureProvider<StakingApiDocumentationSnapshot>(
      (ref) => ref
          .watch(data.stakingApiDocumentationRepositoryProvider)
          .getDocumentation(),
    );

final stakingAuditReportsSnapshotProvider =
    FutureProvider<StakingAuditReportsSnapshot>(
      (ref) => ref
          .watch(data.stakingAuditReportsRepositoryProvider)
          .getAuditReports(),
    );

final stakingAutoCompoundSnapshotProvider =
    FutureProvider<StakingAutoCompoundSnapshot>(
      (ref) => ref
          .watch(data.stakingAutoCompoundRepositoryProvider)
          .getAutoCompound(),
    );

final stakingCommunityGovernanceSnapshotProvider =
    FutureProvider<StakingCommunityGovernanceSnapshot>(
      (ref) => ref
          .watch(data.stakingCommunityGovernanceRepositoryProvider)
          .getGovernance(),
    );

final stakingContingencyPlanSnapshotProvider =
    FutureProvider<StakingContingencyPlanSnapshot>(
      (ref) => ref
          .watch(data.stakingContingencyPlanRepositoryProvider)
          .getContingencyPlan(),
    );

final stakingCustodySnapshotProvider = FutureProvider<StakingCustodySnapshot>(
  (ref) => ref.watch(data.stakingCustodyRepositoryProvider).getCustody(),
);

final stakingDashboardSnapshotProvider =
    FutureProvider<StakingDashboardSnapshot>(
      (ref) =>
          ref.watch(data.stakingDashboardRepositoryProvider).getDashboard(),
    );

final stakingDataExportSnapshotProvider =
    FutureProvider<StakingDataExportSnapshot>(
      (ref) =>
          ref.watch(data.stakingDataExportRepositoryProvider).getDataExport(),
    );

final stakingDeveloperConsoleSnapshotProvider =
    FutureProvider<StakingDeveloperConsoleSnapshot>(
      (ref) => ref
          .watch(data.stakingDeveloperConsoleRepositoryProvider)
          .getConsole(),
    );

final stakingEarnSnapshotProvider =
    FutureProvider.family<StakingEarnSnapshot, StakingEarnRoute>(
      (ref, route) => ref
          .watch(data.stakingEarnRepositoryProvider)
          .getStakingEarn(route: route),
    );

final stakingEarningsCalendarSnapshotProvider =
    FutureProvider<StakingEarningsCalendarSnapshot>(
      (ref) => ref
          .watch(data.stakingEarningsCalendarRepositoryProvider)
          .getCalendar(),
    );

final stakingEmergencyActionsSnapshotProvider =
    FutureProvider<StakingEmergencyActionsSnapshot>(
      (ref) => ref
          .watch(data.stakingEmergencyActionsRepositoryProvider)
          .getEmergencyActions(),
    );

final stakingFAQSnapshotProvider = FutureProvider<StakingFAQSnapshot>(
  (ref) => ref.watch(data.stakingFAQRepositoryProvider).getFAQ(),
);

final stakingForumSnapshotProvider = FutureProvider<StakingForumSnapshot>(
  (ref) => ref.watch(data.stakingForumRepositoryProvider).getForum(),
);

final stakingGuideSnapshotProvider = FutureProvider<StakingGuideSnapshot>(
  (ref) => ref.watch(data.stakingGuideRepositoryProvider).getGuide(),
);

final stakingHistorySnapshotProvider = FutureProvider<StakingHistorySnapshot>(
  (ref) => ref.watch(data.stakingHistoryRepositoryProvider).getHistory(),
);

final stakingInstitutionalSnapshotProvider =
    FutureProvider<StakingInstitutionalSnapshot>(
      (ref) => ref
          .watch(data.stakingInstitutionalRepositoryProvider)
          .getInstitutional(),
    );

final stakingInsuranceFundTransparencySnapshotProvider =
    FutureProvider<StakingInsuranceFundTransparencySnapshot>(
      (ref) => ref
          .watch(data.stakingInsuranceFundTransparencyRepositoryProvider)
          .getTransparency(),
    );

final stakingInsuranceSnapshotProvider =
    FutureProvider<StakingInsuranceSnapshot>(
      (ref) =>
          ref.watch(data.stakingInsuranceRepositoryProvider).getInsurance(),
    );

final stakingLiquidStakingSnapshotProvider =
    FutureProvider<StakingLiquidStakingSnapshot>(
      (ref) => ref
          .watch(data.stakingLiquidStakingRepositoryProvider)
          .getLiquidStaking(),
    );

final stakingMultiChainSnapshotProvider =
    FutureProvider<StakingMultiChainSnapshot>(
      (ref) =>
          ref.watch(data.stakingMultiChainRepositoryProvider).getMultiChain(),
    );

final stakingNotificationsSnapshotProvider =
    FutureProvider<StakingNotificationsSnapshot>(
      (ref) => ref
          .watch(data.stakingNotificationsRepositoryProvider)
          .getNotifications(),
    );

final stakingProofOfReservesSnapshotProvider =
    FutureProvider<StakingProofOfReservesSnapshot>(
      (ref) => ref
          .watch(data.stakingProofOfReservesRepositoryProvider)
          .getProofOfReserves(),
    );

final stakingProposalsSnapshotProvider =
    FutureProvider<StakingProposalsSnapshot>(
      (ref) =>
          ref.watch(data.stakingProposalsRepositoryProvider).getProposals(),
    );

final stakingRecommendationsSnapshotProvider =
    FutureProvider<StakingRecommendationsSnapshot>(
      (ref) => ref
          .watch(data.stakingRecommendationsRepositoryProvider)
          .getRecommendations(),
    );

final stakingRegulatoryFrameworkSnapshotProvider =
    FutureProvider<StakingRegulatoryFrameworkSnapshot>(
      (ref) => ref
          .watch(data.stakingRegulatoryFrameworkRepositoryProvider)
          .getFramework(),
    );

final stakingRiskAssessmentSnapshotProvider =
    FutureProvider<StakingRiskAssessmentSnapshot>(
      (ref) => ref
          .watch(data.stakingRiskAssessmentRepositoryProvider)
          .getRiskAssessment(),
    );

final stakingRiskDashboardSnapshotProvider =
    FutureProvider<StakingRiskDashboardSnapshot>(
      (ref) => ref
          .watch(data.stakingRiskDashboardRepositoryProvider)
          .getRiskDashboard(),
    );

final stakingRiskDisclosureSnapshotProvider =
    FutureProvider<StakingRiskDisclosureSnapshot>(
      (ref) => ref
          .watch(data.stakingRiskDisclosureRepositoryProvider)
          .getDisclosure(),
    );

final stakingRiskScoreCalculatorSnapshotProvider =
    FutureProvider<StakingRiskScoreCalculatorSnapshot>(
      (ref) => ref
          .watch(data.stakingRiskScoreCalculatorRepositoryProvider)
          .getCalculator(),
    );

final stakingSlashingHistorySnapshotProvider =
    FutureProvider<StakingSlashingHistorySnapshot>(
      (ref) => ref
          .watch(data.stakingSlashingHistoryRepositoryProvider)
          .getSlashingHistory(),
    );

final stakingSocialFeedSnapshotProvider =
    FutureProvider<StakingSocialFeedSnapshot>(
      (ref) => ref.watch(data.stakingSocialFeedRepositoryProvider).getFeed(),
    );

final stakingSuitabilityAssessmentSnapshotProvider =
    FutureProvider<StakingSuitabilityAssessmentSnapshot>(
      (ref) => ref
          .watch(data.stakingSuitabilityAssessmentRepositoryProvider)
          .getAssessment(),
    );

final stakingTaxGuideSnapshotProvider = FutureProvider<StakingTaxGuideSnapshot>(
  (ref) => ref.watch(data.stakingTaxGuideRepositoryProvider).getGuide(),
);

final stakingTermsSnapshotProvider = FutureProvider<StakingTermsSnapshot>(
  (ref) => ref.watch(data.stakingTermsRepositoryProvider).getTerms(),
);

final stakingThirdPartyIntegrationsSnapshotProvider =
    FutureProvider<StakingThirdPartyIntegrationsSnapshot>(
      (ref) => ref
          .watch(data.stakingThirdPartyIntegrationsRepositoryProvider)
          .getIntegrations(),
    );

final stakingTransactionReportingSnapshotProvider =
    FutureProvider<StakingTransactionReportingSnapshot>(
      (ref) => ref
          .watch(data.stakingTransactionReportingRepositoryProvider)
          .getReporting(),
    );

final stakingValidatorHealthMonitorSnapshotProvider =
    FutureProvider<StakingValidatorHealthMonitorSnapshot>(
      (ref) => ref
          .watch(data.stakingValidatorHealthMonitorRepositoryProvider)
          .getValidatorHealth(),
    );

final stakingValidatorSelectionSnapshotProvider =
    FutureProvider<StakingValidatorSelectionSnapshot>(
      (ref) => ref
          .watch(data.stakingValidatorSelectionRepositoryProvider)
          .getSelection(),
    );

final stakingVotingSnapshotProvider =
    FutureProvider.family<StakingVotingSnapshot, String?>(
      (ref, proposalId) => ref
          .watch(data.stakingVotingRepositoryProvider)
          .getVoting(proposalId: proposalId),
    );

final stakingWebhooksSnapshotProvider = FutureProvider<StakingWebhooksSnapshot>(
  (ref) => ref.watch(data.stakingWebhooksRepositoryProvider).getWebhooks(),
);

final stakingWithdrawalPolicySnapshotProvider =
    FutureProvider<StakingWithdrawalPolicySnapshot>(
      (ref) =>
          ref.watch(data.stakingWithdrawalPolicyRepositoryProvider).getPolicy(),
    );

// STATE-S25 (đã dùng ở home_controller_providers.dart): controller wrapper
// thuần đọc dùng `Provider<AsyncValue<XController>>` + `.whenData()` — map
// đồng bộ, không thêm 1 tầng Future/microtask; consumer vẫn `.when()` giống
// mọi snapshot provider khác (GD4 playbook mục 4).

final stakingRiskAssessmentControllerProvider =
    Provider<AsyncValue<StakingRiskAssessmentController>>((ref) {
      return ref
          .watch(stakingRiskAssessmentSnapshotProvider)
          .whenData(
            (snapshot) => StakingRiskAssessmentController(
              state: StakingRiskAssessmentViewState(snapshot: snapshot),
            ),
          );
    });

final stakingSuitabilityControllerProvider =
    Provider<AsyncValue<StakingSuitabilityController>>((ref) {
      return ref
          .watch(stakingSuitabilityAssessmentSnapshotProvider)
          .whenData(
            (snapshot) => StakingSuitabilityController(
              state: StakingSuitabilityViewState(snapshot: snapshot),
            ),
          );
    });

final stakingEmergencyActionsControllerProvider =
    Provider<AsyncValue<StakingEmergencyActionsController>>((ref) {
      return ref
          .watch(stakingEmergencyActionsSnapshotProvider)
          .whenData(
            (snapshot) => StakingEmergencyActionsController(
              state: StakingEmergencyActionsViewState(snapshot: snapshot),
            ),
          );
    });
