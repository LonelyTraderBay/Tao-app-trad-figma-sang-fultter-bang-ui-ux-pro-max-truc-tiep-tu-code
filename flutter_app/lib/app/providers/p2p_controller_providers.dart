import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/p2p/data/providers/p2p_repository_provider.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/controllers/p2p_controller.dart';

export 'package:vit_trade_flutter/features/p2p/presentation/controllers/p2p_controller.dart';

final p2pHomeProvider =
    Provider.family<
      P2PHomeSnapshot,
      ({P2PTradeType tradeType, String asset, String fiat})
    >((ref, request) {
      return ref
          .watch(p2pRepositoryProvider)
          .getHome(
            tradeType: request.tradeType,
            asset: request.asset,
            fiat: request.fiat,
          );
    });

final p2pExpressProvider = Provider<P2PExpressSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getExpress(),
);

final p2pExpressConfirmProvider =
    Provider.family<
      P2PExpressConfirmSnapshot,
      ({
        P2PTradeType tradeType,
        String asset,
        double fiatAmount,
        double cryptoAmount,
        String? adId,
        String? paymentMethod,
      })
    >((ref, request) {
      return ref
          .watch(p2pRepositoryProvider)
          .getExpressConfirm(
            tradeType: request.tradeType,
            asset: request.asset,
            fiatAmount: request.fiatAmount,
            cryptoAmount: request.cryptoAmount,
            adId: request.adId,
            paymentMethod: request.paymentMethod,
          );
    });

final p2pOrderTimelineProvider =
    Provider.family<P2POrderTimelineSnapshot, String>(
      (ref, orderId) =>
          ref.watch(p2pRepositoryProvider).getOrderTimeline(orderId),
    );

final p2pOrderRateProvider = Provider.family<P2POrderRateSnapshot, String>(
  (ref, orderId) => ref.watch(p2pRepositoryProvider).getOrderRate(orderId),
);

final p2pOrderCancelProvider = Provider.family<P2POrderCancelSnapshot, String>(
  (ref, orderId) => ref.watch(p2pRepositoryProvider).getOrderCancel(orderId),
);

final p2pOrderProofProvider = Provider.family<P2POrderProofSnapshot, String>(
  (ref, orderId) => ref.watch(p2pRepositoryProvider).getOrderProof(orderId),
);

final p2pOrderProvider = Provider.family<P2POrderSnapshot, String>(
  (ref, orderId) => ref.watch(p2pRepositoryProvider).getOrder(orderId),
);

final p2pChatProvider = Provider.family<P2PChatSnapshot, String>(
  (ref, orderId) => ref.watch(p2pRepositoryProvider).getChat(orderId),
);

final p2pDisputeDetailProvider =
    Provider.family<P2PDisputeDetailSnapshot, String>(
      (ref, disputeId) =>
          ref.watch(p2pRepositoryProvider).getDisputeDetail(disputeId),
    );

final p2pDisputeEvidenceProvider =
    Provider.family<P2PDisputeEvidenceSnapshot, String>(
      (ref, disputeId) =>
          ref.watch(p2pRepositoryProvider).getDisputeEvidence(disputeId),
    );

final p2pDisputeEvidenceControllerProvider =
    Provider.family<P2PDisputeEvidenceController, String>((ref, disputeId) {
      final snapshot = ref
          .watch(p2pRepositoryProvider)
          .getDisputeEvidence(disputeId);
      return P2PDisputeEvidenceController(
        state: P2PDisputeEvidenceViewState(snapshot: snapshot),
      );
    });

final p2pDisputeResolutionProvider =
    Provider.family<P2PDisputeResolutionSnapshot, String>(
      (ref, disputeId) =>
          ref.watch(p2pRepositoryProvider).getDisputeResolution(disputeId),
    );

final p2pDisputeOpenProvider = Provider.family<P2PDisputeOpenSnapshot, String>(
  (ref, orderId) => ref.watch(p2pRepositoryProvider).getDisputeOpen(orderId),
);

final p2pDisputesProvider = Provider<P2PDisputesSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getDisputes(),
);

final p2pAdAnalyticsProvider = Provider.family<P2PAdAnalyticsSnapshot, String>(
  (ref, adId) => ref.watch(p2pRepositoryProvider).getAdAnalytics(adId),
);

final p2pAdDetailProvider = Provider.family<P2PAdDetailSnapshot, String>(
  (ref, adId) => ref.watch(p2pRepositoryProvider).getAdDetail(adId),
);

final p2pMyAdsProvider = Provider<P2PMyAdsSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getMyAds(),
);

final p2pCreateAdProvider = Provider<P2PCreateAdSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getCreateAd(),
);

final p2pMerchantApplyProvider = Provider<P2PMerchantApplySnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getMerchantApply(),
);

final p2pMerchantProfileProvider =
    Provider.family<P2PMerchantProfileSnapshot, String>(
      (ref, merchantId) =>
          ref.watch(p2pRepositoryProvider).getMerchantProfile(merchantId),
    );

final p2pReportMerchantProvider =
    Provider.family<P2PReportMerchantSnapshot, String>(
      (ref, merchantId) =>
          ref.watch(p2pRepositoryProvider).getReportMerchant(merchantId),
    );

final p2pTradingLevelProvider = Provider<P2PTradingLevelSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getTradingLevel(),
);

final p2pReviewsProvider = Provider<P2PReviewsSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getReviews(),
);

final p2pPaymentMethodAddProvider = Provider<P2PPaymentMethodAddSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getPaymentMethodAdd(),
);

final p2pPaymentMethodVerificationProvider =
    Provider.family<P2PPaymentMethodVerificationSnapshot, String>(
      (ref, methodId) => ref
          .watch(p2pRepositoryProvider)
          .getPaymentMethodVerification(methodId),
    );

final p2pPaymentMethodOwnershipProvider =
    Provider.family<P2PPaymentMethodOwnershipSnapshot, String>(
      (ref, methodId) =>
          ref.watch(p2pRepositoryProvider).getPaymentMethodOwnership(methodId),
    );

final p2pPaymentMethodOwnershipControllerProvider =
    Provider.family<P2PPaymentMethodOwnershipController, String>((
      ref,
      methodId,
    ) {
      final snapshot = ref
          .watch(p2pRepositoryProvider)
          .getPaymentMethodOwnership(methodId);
      return P2PPaymentMethodOwnershipController(
        state: P2PPaymentMethodOwnershipViewState(snapshot: snapshot),
      );
    });

final p2pPaymentMethodCoolingPeriodProvider =
    Provider<P2PPaymentMethodCoolingPeriodSnapshot>(
      (ref) => ref.watch(p2pRepositoryProvider).getPaymentMethodCoolingPeriod(),
    );

final p2pPaymentMethodCoolingPeriodControllerProvider =
    Provider<P2PPaymentMethodCoolingPeriodController>((ref) {
      final snapshot = ref
          .watch(p2pRepositoryProvider)
          .getPaymentMethodCoolingPeriod();
      return P2PPaymentMethodCoolingPeriodController(
        state: P2PPaymentMethodCoolingPeriodViewState(snapshot: snapshot),
      );
    });

final p2pPaymentMethodHistoryProvider =
    Provider<P2PPaymentMethodHistorySnapshot>(
      (ref) => ref.watch(p2pRepositoryProvider).getPaymentMethodHistory(),
    );

final p2pPaymentMethodsProvider = Provider<P2PPaymentMethodsSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getPaymentMethods(),
);

final p2pInsuranceFundProvider = Provider<P2PInsuranceFundSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getInsuranceFund(),
);

final p2pInsuranceCertificateProvider =
    Provider<P2PInsuranceCertificateSnapshot>(
      (ref) => ref.watch(p2pRepositoryProvider).getInsuranceCertificate(),
    );

final p2pInsuranceScoreProvider = Provider<P2PInsuranceScoreSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getInsuranceScore(),
);

final p2pInsurancePolicyProvider = Provider<P2PInsurancePolicySnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getInsurancePolicy(),
);

final p2pContributionHistoryProvider = Provider<P2PContributionHistorySnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getContributionHistory(),
);

final p2pClaimDetailProvider = Provider.family<P2PClaimDetailSnapshot, String>(
  (ref, claimId) => ref.watch(p2pRepositoryProvider).getClaimDetail(claimId),
);

final p2pEscrowBalanceProvider =
    Provider.family<P2PEscrowBalanceSnapshot, String>(
      (ref, asset) =>
          ref.watch(p2pRepositoryProvider).getEscrowBalance(asset: asset),
    );

final p2pEscrowDetailProvider =
    Provider.family<P2PEscrowDetailSnapshot, String>(
      (ref, orderId) =>
          ref.watch(p2pRepositoryProvider).getEscrowDetail(orderId),
    );

final p2pKycRequirementsProvider = Provider<P2PKycRequirementsSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getKycRequirements(),
);

final p2pKycStatusProvider = Provider<P2PKycStatusSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getKycStatus(),
);

final p2pIdentityVerificationProvider =
    Provider<P2PIdentityVerificationSnapshot>(
      (ref) => ref.watch(p2pRepositoryProvider).getIdentityVerification(),
    );

final p2pAddressProofProvider = Provider<P2PAddressProofSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getAddressProof(),
);

final p2pSelfieVerificationProvider = Provider<P2PSelfieVerificationSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getSelfieVerification(),
);

final p2pVideoVerificationProvider = Provider<P2PVideoVerificationSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getVideoVerification(),
);

final p2pSecurityCenterProvider = Provider<P2PSecurityCenterSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getSecurityCenter(),
);

final p2pTwoFactorSettingsProvider = Provider<P2PTwoFactorSettingsSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getTwoFactorSettings(),
);

final p2pDeviceManagementProvider = Provider<P2PDeviceManagementSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getDeviceManagement(),
);

final p2pAntiPhishingCodeProvider = Provider<P2PAntiPhishingCodeSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getAntiPhishingCode(),
);

final p2pLoginHistoryProvider = Provider<P2PLoginHistorySnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getLoginHistory(),
);

final p2pSuspiciousActivityProvider = Provider<P2PSuspiciousActivitySnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getSuspiciousActivity(),
);

final p2pE2EInfoProvider = Provider<P2PE2EInfoSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getE2EInfo(),
);

final p2pFraudPreventionProvider = Provider<P2PFraudPreventionSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getFraudPrevention(),
);

final p2pWalletTransferProvider =
    Provider.family<P2PWalletTransferSnapshot, ({String asset, String type})>((
      ref,
      request,
    ) {
      return ref
          .watch(p2pRepositoryProvider)
          .getWalletTransfer(asset: request.asset, type: request.type);
    });

final p2pFundLockHistoryProvider =
    Provider.family<P2PFundLockHistorySnapshot, bool>(
      (ref, walletHistoryAlias) => ref
          .watch(p2pRepositoryProvider)
          .getFundLockHistory(walletHistoryAlias: walletHistoryAlias),
    );

final p2pWalletProvider = Provider<P2PWalletSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getWallet(),
);

final p2pLimitTrackerProvider = Provider<P2PLimitTrackerSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getLimitTracker(),
);

final p2pTransactionLimitsProvider = Provider<P2PTransactionLimitsSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getTransactionLimits(),
);

final p2pComplianceOverviewProvider = Provider<P2PComplianceOverviewSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getComplianceOverview(),
);

final p2pAmlScreeningProvider = Provider<P2PAmlScreeningSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getAmlScreening(),
);

final p2pSourceOfFundsProvider = Provider<P2PSourceOfFundsSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getSourceOfFunds(),
);

final p2pLargeTransactionJustificationProvider =
    Provider.family<P2PLargeTransactionJustificationSnapshot, double>(
      (ref, amount) => ref
          .watch(p2pRepositoryProvider)
          .getLargeTransactionJustification(amount: amount),
    );

final p2pRiskAssessmentProvider = Provider<P2PRiskAssessmentSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getRiskAssessment(),
);

final p2pTaxReportingProvider =
    Provider.family<
      P2PTaxReportingSnapshot,
      ({int selectedYear, String selectedJurisdiction})
    >((ref, request) {
      return ref
          .watch(p2pRepositoryProvider)
          .getTaxReporting(
            selectedYear: request.selectedYear,
            selectedJurisdiction: request.selectedJurisdiction,
          );
    });

final p2pOrderBookProvider = Provider.family<P2POrderBookSnapshot, String>(
  (ref, selectedAsset) => ref
      .watch(p2pRepositoryProvider)
      .getOrderBook(selectedAsset: selectedAsset),
);

final p2pDashboardProvider = Provider.family<P2PDashboardSnapshot, String>(
  (ref, timeFilter) =>
      ref.watch(p2pRepositoryProvider).getDashboard(timeFilter: timeFilter),
);

final p2pAchievementsProvider = Provider<P2PAchievementsSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getAchievements(),
);

final p2pBlacklistAddProvider = Provider<P2PBlacklistAddSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getBlacklistAdd(),
);

final p2pBlacklistProvider = Provider<P2PBlacklistSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getBlacklist(),
);

final p2pNotificationSettingsProvider =
    Provider<P2PNotificationSettingsSnapshot>(
      (ref) => ref.watch(p2pRepositoryProvider).getNotificationSettings(),
    );

final p2pSettingsProvider = Provider<P2PSettingsSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getSettings(),
);

final p2pGuideProvider = Provider<P2PGuideSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getGuide(),
);

final p2pMyOrdersProvider = Provider<P2PMyOrdersSnapshot>(
  (ref) => ref.watch(p2pRepositoryProvider).getMyOrders(),
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

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — state cài đặt
/// 2FA giữ nguyên khi điều hướng đi/về trong phiên.
final class P2P2FASettingsStateController
    extends Notifier<P2PTwoFactorSettingsViewState> {
  @override
  P2PTwoFactorSettingsViewState build() {
    return P2PTwoFactorSettingsViewState.fromSnapshot(
      ref.watch(p2pTwoFactorSettingsProvider),
    );
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

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — state thiết bị
/// tin cậy giữ nguyên khi điều hướng đi/về trong phiên.
final class P2PDeviceManagementStateController
    extends Notifier<P2PDeviceManagementViewState> {
  @override
  P2PDeviceManagementViewState build() {
    return P2PDeviceManagementViewState.fromSnapshot(
      ref.watch(p2pDeviceManagementProvider),
    );
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

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — state checklist
/// an toàn giữ nguyên khi điều hướng đi/về trong phiên.
final class P2PFraudPreventionStateController
    extends Notifier<P2PFraudPreventionViewState> {
  @override
  P2PFraudPreventionViewState build() {
    return P2PFraudPreventionViewState.fromSnapshot(
      ref.watch(p2pFraudPreventionProvider),
    );
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

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — state cảnh
/// báo giữ nguyên khi điều hướng đi/về trong phiên.
final class P2PSuspiciousActivityStateController
    extends Notifier<P2PSuspiciousActivityViewState> {
  @override
  P2PSuspiciousActivityViewState build() {
    return P2PSuspiciousActivityViewState.fromSnapshot(
      ref.watch(p2pSuspiciousActivityProvider),
    );
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

final p2pSuspiciousActivityStateControllerProvider =
    NotifierProvider<
      P2PSuspiciousActivityStateController,
      P2PSuspiciousActivityViewState
    >(P2PSuspiciousActivityStateController.new);
