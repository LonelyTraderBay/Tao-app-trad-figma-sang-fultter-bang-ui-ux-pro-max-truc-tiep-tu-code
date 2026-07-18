import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/earn/data/providers/earn_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/earn/presentation/controllers/earn_controller.dart';

export 'package:vit_trade_flutter/features/earn/presentation/controllers/earn_controller.dart';
export 'package:vit_trade_flutter/features/earn/data/providers/earn_repository_provider.dart';

// GD4 async playbook mục 3/4: một FutureProvider "snapshot" trung gian cho
// MỖI repository đọc-thuần của Earn (68 method — xem
// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md). Đa số
// trang gọi thẳng các provider này rồi `.when()` (mục 5); 6 trang có
// "controller wrapper" (SavingsController...) và 1 trang có Notifier ghi
// (SavingsNotificationPreferencesStateController) bọc thêm bên dưới.

final autoCompoundSettingsSnapshotProvider =
    FutureProvider<AutoCompoundSettingsSnapshot>(
      (ref) =>
          ref.watch(data.autoCompoundSettingsRepositoryProvider).getSettings(),
    );

final savingsAnalyticsSnapshotProvider =
    FutureProvider<SavingsAnalyticsSnapshot>(
      (ref) =>
          ref.watch(data.savingsAnalyticsRepositoryProvider).getAnalytics(),
    );

final savingsAutoPilotSnapshotProvider =
    FutureProvider<SavingsAutoPilotSnapshot>(
      (ref) =>
          ref.watch(data.savingsAutoPilotRepositoryProvider).getAutoPilot(),
    );

final savingsAutoRebalanceSnapshotProvider =
    FutureProvider<SavingsAutoRebalanceSnapshot>(
      (ref) =>
          ref.watch(data.savingsAutoRebalanceRepositoryProvider).getRebalance(),
    );

final savingsBacktestSnapshotProvider = FutureProvider<SavingsBacktestSnapshot>(
  (ref) => ref.watch(data.savingsBacktestRepositoryProvider).getBacktest(),
);

final savingsComparisonSnapshotProvider =
    FutureProvider<SavingsComparisonSnapshot>(
      (ref) =>
          ref.watch(data.savingsComparisonRepositoryProvider).getComparison(),
    );

final savingsDcaSnapshotProvider = FutureProvider<SavingsDcaSnapshot>(
  (ref) => ref.watch(data.savingsDcaRepositoryProvider).getDca(),
);

final savingsExportSnapshotProvider = FutureProvider<SavingsExportSnapshot>(
  (ref) => ref.watch(data.savingsExportRepositoryProvider).getExport(),
);

final savingsFAQSnapshotProvider = FutureProvider<SavingsFAQSnapshot>(
  (ref) => ref.watch(data.savingsFAQRepositoryProvider).getFAQ(),
);

final savingsGoalsSnapshotProvider = FutureProvider<SavingsGoalsSnapshot>(
  (ref) => ref.watch(data.savingsGoalsRepositoryProvider).getGoals(),
);

final savingsGuideSnapshotProvider = FutureProvider<SavingsGuideSnapshot>(
  (ref) => ref.watch(data.savingsGuideRepositoryProvider).getGuide(),
);

final savingsHistorySnapshotProvider = FutureProvider<SavingsHistorySnapshot>(
  (ref) => ref.watch(data.savingsHistoryRepositoryProvider).getHistory(),
);

final savingsLadderSnapshotProvider = FutureProvider<SavingsLadderSnapshot>(
  (ref) => ref.watch(data.savingsLadderRepositoryProvider).getLadder(),
);

final savingsNotificationPreferencesSnapshotProvider =
    FutureProvider<SavingsNotificationPreferencesSnapshot>(
      (ref) => ref
          .watch(data.savingsNotificationPreferencesRepositoryProvider)
          .getPreferences(),
    );

final savingsNotificationsSnapshotProvider =
    FutureProvider<SavingsNotificationsSnapshot>(
      (ref) => ref
          .watch(data.savingsNotificationsRepositoryProvider)
          .getNotifications(),
    );

final savingsPortfolioSnapshotProvider =
    FutureProvider<SavingsPortfolioSnapshot>(
      (ref) =>
          ref.watch(data.savingsPortfolioRepositoryProvider).getPortfolio(),
    );

final savingsProductDetailSnapshotProvider =
    FutureProvider.family<SavingsProductDetailSnapshot, String>(
      (ref, productId) => ref
          .watch(data.savingsProductDetailRepositoryProvider)
          .getProductDetail(productId: productId),
    );

final savingsReceiptSnapshotProvider = FutureProvider<SavingsReceiptSnapshot>(
  (ref) => ref.watch(data.savingsReceiptRepositoryProvider).getReceipt(),
);

final savingsRecommendationsSnapshotProvider =
    FutureProvider<SavingsRecommendationsSnapshot>(
      (ref) => ref
          .watch(data.savingsRecommendationsRepositoryProvider)
          .getRecommendations(),
    );

final savingsRedeemSnapshotProvider =
    FutureProvider.family<SavingsRedeemSnapshot, String>(
      (ref, positionId) => ref
          .watch(data.savingsRedeemRepositoryProvider)
          .getRedeem(positionId: positionId),
    );

final savingsSnapshotProvider = FutureProvider<SavingsSnapshot>(
  (ref) => ref.watch(data.savingsRepositoryProvider).getSavings(),
);

final savingsRiskAssessmentSnapshotProvider =
    FutureProvider<SavingsRiskAssessmentSnapshot>(
      (ref) => ref
          .watch(data.savingsRiskAssessmentRepositoryProvider)
          .getRiskAssessment(),
    );

final savingsSmartSuggestionsSnapshotProvider =
    FutureProvider<SavingsSmartSuggestionsSnapshot>(
      (ref) => ref
          .watch(data.savingsSmartSuggestionsRepositoryProvider)
          .getSuggestions(),
    );

final savingsWhatIfSnapshotProvider = FutureProvider<SavingsWhatIfSnapshot>(
  (ref) => ref.watch(data.savingsWhatIfRepositoryProvider).getWhatIf(),
);

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

final savingsControllerProvider = Provider<AsyncValue<SavingsController>>((
  ref,
) {
  return ref
      .watch(savingsSnapshotProvider)
      .whenData(
        (snapshot) =>
            SavingsController(state: SavingsViewState(snapshot: snapshot)),
      );
});

final savingsRedeemControllerProvider =
    Provider.family<AsyncValue<SavingsRedeemController>, String>((
      ref,
      positionId,
    ) {
      return ref
          .watch(savingsRedeemSnapshotProvider(positionId))
          .whenData(
            (snapshot) => SavingsRedeemController(
              state: SavingsRedeemViewState(snapshot: snapshot),
            ),
          );
    });

final savingsRiskAssessmentControllerProvider =
    Provider<AsyncValue<SavingsRiskAssessmentController>>((ref) {
      return ref
          .watch(savingsRiskAssessmentSnapshotProvider)
          .whenData(
            (snapshot) => SavingsRiskAssessmentController(
              state: SavingsRiskAssessmentViewState(snapshot: snapshot),
            ),
          );
    });

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

/// STATE-S23: view-state bất biến của Cài đặt thông báo tiết kiệm — master
/// toggle + alerts + channels sống ở Notifier (một nguồn sự thật), trang chỉ
/// watch + gọi method.
final class SavingsNotificationPreferencesViewState {
  const SavingsNotificationPreferencesViewState({
    required this.snapshot,
    required this.masterEnabled,
    required this.alerts,
    required this.channels,
  });

  factory SavingsNotificationPreferencesViewState.fromSnapshot(
    SavingsNotificationPreferencesSnapshot snapshot,
  ) {
    return SavingsNotificationPreferencesViewState(
      snapshot: snapshot,
      masterEnabled: snapshot.masterEnabled,
      alerts: List.unmodifiable(snapshot.alerts),
      channels: List.unmodifiable(snapshot.channels),
    );
  }

  final SavingsNotificationPreferencesSnapshot snapshot;
  final bool masterEnabled;
  final List<SavingsNotificationAlertDraft> alerts;
  final List<SavingsDeliveryChannelDraft> channels;

  SavingsNotificationPreferencesViewState copyWith({
    bool? masterEnabled,
    List<SavingsNotificationAlertDraft>? alerts,
    List<SavingsDeliveryChannelDraft>? channels,
  }) {
    return SavingsNotificationPreferencesViewState(
      snapshot: snapshot,
      masterEnabled: masterEnabled ?? this.masterEnabled,
      alerts: alerts == null ? this.alerts : List.unmodifiable(alerts),
      channels: channels == null ? this.channels : List.unmodifiable(channels),
    );
  }
}

/// Snapshot rỗng hợp lệ (GD4 playbook mục 6, biến thể A) — chỉ chạm tới khi
/// test đọc Notifier trực tiếp trước khi `savingsNotificationPreferencesSnapshotProvider`
/// resolve; luồng UI thật luôn gate qua trang (chưa cần bọc `.when()` ở đây
/// vì trang này không đọc trực tiếp provider async — xem
/// `savings_notification_preferences_page.dart`, nó chỉ watch Notifier này).
const _emptySavingsNotificationPreferencesSnapshot =
    SavingsNotificationPreferencesSnapshot(
      endpoint: '',
      actionDraft: '',
      title: '',
      backRoute: '',
      tabs: [],
      defaultTab: '',
      masterEnabled: false,
      alerts: [],
      productAlerts: [],
      channels: [],
      digestFrequency: SavingsDeliveryFrequency.instant,
      quietHours: SavingsQuietHoursDraft(
        enabled: false,
        startHour: 0,
        endHour: 0,
        allowCritical: false,
      ),
      contractNotes: '',
      supportedStates: {},
    );

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — lựa chọn
/// thông báo giữ nguyên khi điều hướng đi/về trong phiên.
final class SavingsNotificationPreferencesStateController
    extends Notifier<SavingsNotificationPreferencesViewState> {
  @override
  SavingsNotificationPreferencesViewState build() {
    final snapshot =
        ref.watch(savingsNotificationPreferencesSnapshotProvider).value ??
        _emptySavingsNotificationPreferencesSnapshot;
    return SavingsNotificationPreferencesViewState.fromSnapshot(snapshot);
  }

  void setMasterEnabled(bool value) {
    state = state.copyWith(
      masterEnabled: value,
      alerts: value
          ? state.alerts
          : [
              for (final alert in state.alerts)
                SavingsNotificationAlertDraft(
                  id: alert.id,
                  title: alert.title,
                  description: alert.description,
                  iconKey: alert.iconKey,
                  enabled: false,
                  category: alert.category,
                  severity: alert.severity,
                ),
            ],
    );
  }

  void toggleAlert(String id) {
    state = state.copyWith(
      alerts: [
        for (final alert in state.alerts)
          alert.id == id
              ? SavingsNotificationAlertDraft(
                  id: alert.id,
                  title: alert.title,
                  description: alert.description,
                  iconKey: alert.iconKey,
                  enabled: !alert.enabled,
                  category: alert.category,
                  severity: alert.severity,
                )
              : alert,
      ],
    );
  }

  void toggleChannel(String id) {
    state = state.copyWith(
      channels: [
        for (final channel in state.channels)
          channel.id == id && !channel.locked
              ? SavingsDeliveryChannelDraft(
                  id: channel.id,
                  label: channel.label,
                  detail: channel.detail,
                  iconKey: channel.iconKey,
                  enabled: !channel.enabled,
                  locked: channel.locked,
                )
              : channel,
      ],
    );
  }
}

final savingsNotificationPreferencesStateControllerProvider =
    NotifierProvider<
      SavingsNotificationPreferencesStateController,
      SavingsNotificationPreferencesViewState
    >(SavingsNotificationPreferencesStateController.new);
