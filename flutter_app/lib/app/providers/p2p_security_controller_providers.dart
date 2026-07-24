import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/p2p_core/data/providers/p2p_repository_provider.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';

export 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';

final p2pReportMerchantProvider =
    FutureProvider.family<P2PReportMerchantSnapshot, String>(
      (ref, merchantId) =>
          ref.watch(p2pTrustRepositoryProvider).getReportMerchant(merchantId),
    );

final p2pReviewsProvider = FutureProvider<P2PReviewsSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getReviews(),
);

final p2pContributionHistoryProvider =
    FutureProvider<P2PContributionHistorySnapshot>(
      (ref) => ref.watch(p2pTrustRepositoryProvider).getContributionHistory(),
    );

final p2pSecurityCenterProvider = FutureProvider<P2PSecurityCenterSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getSecurityCenter(),
);

final p2pTwoFactorSettingsProvider =
    FutureProvider<P2PTwoFactorSettingsSnapshot>(
      (ref) => ref.watch(p2pTrustRepositoryProvider).getTwoFactorSettings(),
    );

final p2pDeviceManagementProvider = FutureProvider<P2PDeviceManagementSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getDeviceManagement(),
);

final p2pAntiPhishingCodeProvider = FutureProvider<P2PAntiPhishingCodeSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getAntiPhishingCode(),
);

final p2pLoginHistoryProvider = FutureProvider<P2PLoginHistorySnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getLoginHistory(),
);

final p2pSuspiciousActivityProvider =
    FutureProvider<P2PSuspiciousActivitySnapshot>(
      (ref) => ref.watch(p2pTrustRepositoryProvider).getSuspiciousActivity(),
    );

final p2pE2EInfoProvider = FutureProvider<P2PE2EInfoSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getE2EInfo(),
);

final p2pFraudPreventionProvider = FutureProvider<P2PFraudPreventionSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getFraudPrevention(),
);

final p2pLimitTrackerProvider = FutureProvider<P2PLimitTrackerSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getLimitTracker(),
);

final p2pTransactionLimitsProvider =
    FutureProvider<P2PTransactionLimitsSnapshot>(
      (ref) => ref.watch(p2pTrustRepositoryProvider).getTransactionLimits(),
    );

final p2pComplianceOverviewProvider =
    FutureProvider<P2PComplianceOverviewSnapshot>(
      (ref) => ref.watch(p2pTrustRepositoryProvider).getComplianceOverview(),
    );

final p2pAmlScreeningProvider = FutureProvider<P2PAmlScreeningSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getAmlScreening(),
);

final p2pSourceOfFundsProvider = FutureProvider<P2PSourceOfFundsSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getSourceOfFunds(),
);

final p2pLargeTransactionJustificationProvider =
    FutureProvider.family<P2PLargeTransactionJustificationSnapshot, double>(
      (ref, amount) => ref
          .watch(p2pTrustRepositoryProvider)
          .getLargeTransactionJustification(amount: amount),
    );

final p2pRiskAssessmentProvider = FutureProvider<P2PRiskAssessmentSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getRiskAssessment(),
);

final p2pTaxReportingProvider =
    FutureProvider.family<
      P2PTaxReportingSnapshot,
      ({int selectedYear, String selectedJurisdiction})
    >((ref, request) {
      return ref
          .watch(p2pTrustRepositoryProvider)
          .getTaxReporting(
            selectedYear: request.selectedYear,
            selectedJurisdiction: request.selectedJurisdiction,
          );
    });

final p2pAchievementsProvider = FutureProvider<P2PAchievementsSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getAchievements(),
);

final p2pBlacklistAddProvider = FutureProvider<P2PBlacklistAddSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getBlacklistAdd(),
);

final p2pBlacklistProvider = FutureProvider<P2PBlacklistSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getBlacklist(),
);

/// STATE-S23: view-state bất biến của Cài đặt 2FA P2P — methods/thresholds
/// sống ở Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class P2PTwoFactorSettingsViewState {
  const P2PTwoFactorSettingsViewState({
    required this.snapshot,
    required this.methods,
    required this.thresholds,
  });

  factory P2PTwoFactorSettingsViewState.fromSnapshot(
    P2PTwoFactorSettingsSnapshot snapshot,
  ) {
    return P2PTwoFactorSettingsViewState(
      snapshot: snapshot,
      methods: List.unmodifiable(snapshot.methods),
      thresholds: List.unmodifiable(snapshot.thresholds),
    );
  }

  final P2PTwoFactorSettingsSnapshot snapshot;
  final List<P2PTwoFactorMethodDraft> methods;
  final List<P2PTransactionThresholdDraft> thresholds;

  P2PTwoFactorSettingsViewState copyWith({
    List<P2PTwoFactorMethodDraft>? methods,
    List<P2PTransactionThresholdDraft>? thresholds,
  }) {
    return P2PTwoFactorSettingsViewState(
      snapshot: snapshot,
      methods: methods == null ? this.methods : List.unmodifiable(methods),
      thresholds: thresholds == null
          ? this.thresholds
          : List.unmodifiable(thresholds),
    );
  }
}

/// STATE-S23 (khuôn NotificationsStateController) + GD4-F5 biến thể A
/// (async playbook mục 6): Notifier vẫn SYNC, build() unwrap AsyncValue qua
/// `.value` (nullable) với fallback rỗng tường minh. Trang gate qua
/// `p2pTwoFactorSettingsProvider.when()` trước khi đọc Notifier này nên
/// `.value` luôn có dữ liệu thật trong luồng UI; fallback rỗng chỉ chạm khi
/// test đọc Notifier trực tiếp trước khi provider async resolve.
final class P2P2FASettingsStateController
    extends Notifier<P2PTwoFactorSettingsViewState> {
  @override
  P2PTwoFactorSettingsViewState build() {
    final snapshot =
        ref.watch(p2pTwoFactorSettingsProvider).value ??
        _emptyTwoFactorSettingsSnapshot;
    return P2PTwoFactorSettingsViewState.fromSnapshot(snapshot);
  }

  void toggleMethod(String methodId) {
    state = state.copyWith(
      methods: [
        for (final method in state.methods)
          if (method.id == methodId)
            method.copyWith(
              enabled: !method.enabled,
              setupRequired: method.enabled ? method.setupRequired : false,
            )
          else
            method,
      ],
    );
  }

  void setPrimaryMethod(String methodId) {
    state = state.copyWith(
      methods: [
        for (final method in state.methods)
          method.copyWith(isPrimary: method.id == methodId),
      ],
    );
  }

  void toggleThreshold(String thresholdId) {
    state = state.copyWith(
      thresholds: [
        for (final threshold in state.thresholds)
          if (threshold.id == thresholdId)
            threshold.copyWith(enabled: !threshold.enabled)
          else
            threshold,
      ],
    );
  }
}

const _emptyTwoFactorSettingsSnapshot = P2PTwoFactorSettingsSnapshot(
  endpoint: '/api/mobile/p2p/p2p-security-2fa',
  actionDraft: 'POST /p2p/* workflow action where applicable',
  supportedStates: [P2PScreenState.loading],
  methods: [],
  thresholds: [],
  recommendation: '',
  parentRoute: '/p2p/security',
  emptyTitle: '',
  contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
);

final p2p2FASettingsStateControllerProvider =
    NotifierProvider<
      P2P2FASettingsStateController,
      P2PTwoFactorSettingsViewState
    >(P2P2FASettingsStateController.new);

/// STATE-S23: view-state bất biến của Quản lý thiết bị P2P — devices sống ở
/// Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class P2PDeviceManagementViewState {
  const P2PDeviceManagementViewState({
    required this.snapshot,
    required this.devices,
  });

  factory P2PDeviceManagementViewState.fromSnapshot(
    P2PDeviceManagementSnapshot snapshot,
  ) {
    return P2PDeviceManagementViewState(
      snapshot: snapshot,
      devices: List.unmodifiable(snapshot.devices),
    );
  }

  final P2PDeviceManagementSnapshot snapshot;
  final List<P2PTrustedDeviceDraft> devices;

  P2PDeviceManagementViewState copyWith({
    List<P2PTrustedDeviceDraft>? devices,
  }) {
    return P2PDeviceManagementViewState(
      snapshot: snapshot,
      devices: devices == null ? this.devices : List.unmodifiable(devices),
    );
  }
}

/// STATE-S23 (khuôn NotificationsStateController) + GD4-F5 biến thể A:
/// Notifier vẫn SYNC, build() unwrap AsyncValue qua `.value` (nullable) với
/// fallback rỗng. Trang gate qua `p2pDeviceManagementProvider.when()` nên
/// `.value` luôn có dữ liệu thật trong luồng UI thật.
final class P2PDeviceManagementStateController
    extends Notifier<P2PDeviceManagementViewState> {
  @override
  P2PDeviceManagementViewState build() {
    final snapshot =
        ref.watch(p2pDeviceManagementProvider).value ??
        _emptyDeviceManagementSnapshot;
    return P2PDeviceManagementViewState.fromSnapshot(snapshot);
  }

  void trustDevice(String deviceId) {
    state = state.copyWith(
      devices: [
        for (final device in state.devices)
          if (device.id == deviceId)
            device.copyWith(isTrusted: true)
          else
            device,
      ],
    );
  }

  void revokeTrust(String deviceId) {
    state = state.copyWith(
      devices: [
        for (final device in state.devices)
          if (device.id == deviceId)
            device.copyWith(isTrusted: false)
          else
            device,
      ],
    );
  }

  void removeDevice(String deviceId) {
    state = state.copyWith(
      devices: state.devices
          .where((device) => device.id != deviceId)
          .toList(growable: false),
    );
  }
}

const _emptyDeviceManagementSnapshot = P2PDeviceManagementSnapshot(
  endpoint: '/api/mobile/p2p/p2p-security-devices',
  actionDraft: 'POST /p2p/* workflow action where applicable',
  supportedStates: [P2PScreenState.loading],
  devices: [],
  infoTitle: '',
  infoBody: '',
  securityTips: [],
  parentRoute: '/p2p/security',
  emptyTitle: '',
  contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
);

final p2pDeviceManagementStateControllerProvider =
    NotifierProvider<
      P2PDeviceManagementStateController,
      P2PDeviceManagementViewState
    >(P2PDeviceManagementStateController.new);

/// STATE-S23: view-state bất biến của Phòng chống gian lận P2P — checklist
/// sống ở Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class P2PFraudPreventionViewState {
  const P2PFraudPreventionViewState({
    required this.snapshot,
    required this.checklist,
  });

  factory P2PFraudPreventionViewState.fromSnapshot(
    P2PFraudPreventionSnapshot snapshot,
  ) {
    return P2PFraudPreventionViewState(
      snapshot: snapshot,
      checklist: List.unmodifiable(snapshot.checklist),
    );
  }

  final P2PFraudPreventionSnapshot snapshot;
  final List<P2PSafetyChecklistItemDraft> checklist;

  P2PFraudPreventionViewState copyWith({
    List<P2PSafetyChecklistItemDraft>? checklist,
  }) {
    return P2PFraudPreventionViewState(
      snapshot: snapshot,
      checklist: checklist == null
          ? this.checklist
          : List.unmodifiable(checklist),
    );
  }
}

/// STATE-S23 (khuôn NotificationsStateController) + GD4-F5 biến thể A:
/// Notifier vẫn SYNC, build() unwrap AsyncValue qua `.value` (nullable) với
/// fallback rỗng. Trang gate qua `p2pFraudPreventionProvider.when()` nên
/// `.value` luôn có dữ liệu thật trong luồng UI thật.
final class P2PFraudPreventionStateController
    extends Notifier<P2PFraudPreventionViewState> {
  @override
  P2PFraudPreventionViewState build() {
    final snapshot =
        ref.watch(p2pFraudPreventionProvider).value ??
        _emptyFraudPreventionSnapshot;
    return P2PFraudPreventionViewState.fromSnapshot(snapshot);
  }

  void toggleChecklistItem(String itemId) {
    state = state.copyWith(
      checklist: [
        for (final item in state.checklist)
          if (item.id == itemId)
            item.copyWith(checked: !item.checked)
          else
            item,
      ],
    );
  }
}

// checklist giữ 1 placeholder (không rỗng): P2PFraudPreventionSnapshot.
// safetyScore chia cho checklist.length — rỗng sẽ tạo NaN.round() throw.
const _emptyFraudPreventionSnapshot = P2PFraudPreventionSnapshot(
  endpoint: '/api/mobile/p2p/p2p-fraud-prevention',
  actionDraft: 'POST /p2p/* workflow action where applicable',
  supportedStates: [P2PScreenState.loading],
  patterns: [],
  checklist: [
    P2PSafetyChecklistItemDraft(
      id: 'placeholder',
      label: '',
      description: '',
      checked: false,
      category: '',
    ),
  ],
  emergencyActions: [],
  disclosure: '',
  parentRoute: '/p2p/security',
  emptyTitle: '',
  contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
);

final p2pFraudPreventionStateControllerProvider =
    NotifierProvider<
      P2PFraudPreventionStateController,
      P2PFraudPreventionViewState
    >(P2PFraudPreventionStateController.new);

/// STATE-S23: view-state bất biến của Hoạt động đáng ngờ P2P — alerts sống ở
/// Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class P2PSuspiciousActivityViewState {
  const P2PSuspiciousActivityViewState({
    required this.snapshot,
    required this.alerts,
  });

  factory P2PSuspiciousActivityViewState.fromSnapshot(
    P2PSuspiciousActivitySnapshot snapshot,
  ) {
    return P2PSuspiciousActivityViewState(
      snapshot: snapshot,
      alerts: List.unmodifiable(snapshot.alerts),
    );
  }

  final P2PSuspiciousActivitySnapshot snapshot;
  final List<P2PSuspiciousAlertDraft> alerts;

  P2PSuspiciousActivityViewState copyWith({
    List<P2PSuspiciousAlertDraft>? alerts,
  }) {
    return P2PSuspiciousActivityViewState(
      snapshot: snapshot,
      alerts: alerts == null ? this.alerts : List.unmodifiable(alerts),
    );
  }
}

/// STATE-S23 (khuôn NotificationsStateController) + GD4-F5 biến thể A:
/// Notifier vẫn SYNC, build() unwrap AsyncValue qua `.value` (nullable) với
/// fallback rỗng. Trang gate qua `p2pSuspiciousActivityProvider.when()` nên
/// `.value` luôn có dữ liệu thật trong luồng UI thật.
final class P2PSuspiciousActivityStateController
    extends Notifier<P2PSuspiciousActivityViewState> {
  @override
  P2PSuspiciousActivityViewState build() {
    final snapshot =
        ref.watch(p2pSuspiciousActivityProvider).value ??
        _emptySuspiciousActivitySnapshot;
    return P2PSuspiciousActivityViewState.fromSnapshot(snapshot);
  }

  void markReviewed(String alertId) {
    state = state.copyWith(
      alerts: [
        for (final alert in state.alerts)
          if (alert.id == alertId) alert.copyWith(reviewed: true) else alert,
      ],
    );
  }
}

const _emptySuspiciousActivitySnapshot = P2PSuspiciousActivitySnapshot(
  endpoint: '/api/mobile/p2p/p2p-security-suspicious-activity',
  actionDraft: 'POST /p2p/* workflow action where applicable',
  supportedStates: [P2PScreenState.loading],
  alerts: [],
  summarySubtitle: '',
  parentRoute: '/p2p/security',
  emptyTitle: '',
  contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
);

final p2pSuspiciousActivityStateControllerProvider =
    NotifierProvider<
      P2PSuspiciousActivityStateController,
      P2PSuspiciousActivityViewState
    >(P2PSuspiciousActivityStateController.new);
