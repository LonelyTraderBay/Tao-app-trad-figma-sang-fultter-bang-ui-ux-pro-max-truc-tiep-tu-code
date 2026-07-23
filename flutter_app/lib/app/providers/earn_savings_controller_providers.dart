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
