import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/earn/data/providers/earn_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/earn/presentation/controllers/earn_controller.dart';

export 'package:vit_trade_flutter/features/earn/presentation/controllers/earn_controller.dart';
export 'package:vit_trade_flutter/features/earn/data/providers/earn_repository_provider.dart';

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

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — lựa chọn
/// thông báo giữ nguyên khi điều hướng đi/về trong phiên.
final class SavingsNotificationPreferencesStateController
    extends Notifier<SavingsNotificationPreferencesViewState> {
  @override
  SavingsNotificationPreferencesViewState build() {
    return SavingsNotificationPreferencesViewState.fromSnapshot(
      ref
          .watch(data.savingsNotificationPreferencesRepositoryProvider)
          .getPreferences(),
    );
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
