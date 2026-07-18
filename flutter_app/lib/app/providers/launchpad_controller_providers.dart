import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/launchpad/data/providers/launchpad_repository_provider.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/controllers/launchpad_controller.dart';

export 'package:vit_trade_flutter/features/launchpad/presentation/controllers/launchpad_controller.dart';

final launchpadControllerProvider = Provider<LaunchpadController>((ref) {
  return LaunchpadController(ref.watch(launchpadRepositoryProvider));
});

// GD4-F4: LaunchpadRepository methods are now Future<T> (ADR-001 read
// idiom). Every page previously called `ref.watch(launchpadControllerProvider)
// .getX()` directly inside build() — mục 3 của GD4-Async-Playbook.md (bước
// A+B gộp): mỗi getter giờ có 1 FutureProvider trung gian bên dưới, forward
// nguyên vẹn qua launchpadControllerProvider (semantics non-autoDispose
// không đổi). Pages bọc `.when()` quanh các provider này (mục 5).
// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md.

final launchpadHomeSnapshotProvider = FutureProvider<LaunchpadHomeSnapshot>(
  (ref) => ref.watch(launchpadControllerProvider).getHome(),
);

final launchpadDetailSnapshotProvider =
    FutureProvider.family<LaunchpadDetailSnapshot, String>(
      (ref, projectId) =>
          ref.watch(launchpadControllerProvider).getDetail(projectId),
    );

final launchpadPortfolioSnapshotProvider =
    FutureProvider<LaunchpadPortfolioSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getPortfolio(),
    );

final launchpadReceiptSnapshotProvider =
    FutureProvider.family<LaunchpadReceiptSnapshot, String>(
      (ref, subscriptionId) =>
          ref.watch(launchpadControllerProvider).getReceipt(subscriptionId),
    );

final launchpadPerformanceSnapshotProvider =
    FutureProvider<LaunchpadPerformanceSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getPerformance(),
    );

final launchpadStakingSnapshotProvider =
    FutureProvider<LaunchpadStakingSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getStaking(),
    );

final launchpadBatchClaimSnapshotProvider =
    FutureProvider<LaunchpadBatchClaimSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getBatchClaim(),
    );

final launchpadClaimReceiptSnapshotProvider =
    FutureProvider.family<LaunchpadClaimReceiptSnapshot, String>(
      (ref, positionId) =>
          ref.watch(launchpadControllerProvider).getClaimReceipt(positionId),
    );

final launchpadIdoBridgeSnapshotProvider =
    FutureProvider.family<LaunchpadIdoBridgeSnapshot, String>(
      (ref, projectId) =>
          ref.watch(launchpadControllerProvider).getIdoBridge(projectId),
    );

final launchpadBridgeCompareSnapshotProvider =
    FutureProvider<LaunchpadBridgeCompareSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getBridgeCompare(),
    );

final launchpadNotifSoundSnapshotProvider =
    FutureProvider<LaunchpadNotifSoundSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getNotifSound(),
    );

final launchpadEventLogSnapshotProvider =
    FutureProvider<LaunchpadEventLogSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getEventLog(),
    );

final launchpadAbiDiffSnapshotProvider =
    FutureProvider.family<LaunchpadAbiDiffSnapshot, String>(
      (ref, contractId) =>
          ref.watch(launchpadControllerProvider).getAbiDiff(contractId),
    );

final launchpadAddressBookSnapshotProvider =
    FutureProvider<LaunchpadAddressBookSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getAddressBook(),
    );

final launchpadWebhooksSnapshotProvider =
    FutureProvider<LaunchpadWebhooksSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getWebhooks(),
    );

final launchpadGasTrackerSnapshotProvider =
    FutureProvider<LaunchpadGasTrackerSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getGasTracker(),
    );

final launchpadRebalanceSnapshotProvider =
    FutureProvider<LaunchpadRebalanceSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getRebalance(),
    );

final launchpadMultisigSnapshotProvider =
    FutureProvider<LaunchpadMultisigSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getMultisig(),
    );

final launchpadSwapAggregatorSnapshotProvider =
    FutureProvider<LaunchpadSwapAggregatorSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getSwapAggregator(),
    );

final launchpadLimitOrdersSnapshotProvider =
    FutureProvider<LaunchpadLimitOrdersSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getLimitOrders(),
    );

final launchpadDcaBuilderSnapshotProvider =
    FutureProvider<LaunchpadDcaBuilderSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getDcaBuilder(),
    );

final launchpadRiskAnalyticsSnapshotProvider =
    FutureProvider<LaunchpadRiskAnalyticsSnapshot>(
      (ref) => ref.watch(launchpadControllerProvider).getRiskAnalytics(),
    );

final launchpadBridgeOrderSnapshotProvider =
    FutureProvider.family<LaunchpadBridgeOrderSnapshot, String>(
      (ref, txId) =>
          ref.watch(launchpadControllerProvider).getBridgeOrder(txId),
    );

final launchpadContractSnapshotProvider =
    FutureProvider.family<LaunchpadContractSnapshot, String>(
      (ref, projectId) =>
          ref.watch(launchpadControllerProvider).getContract(projectId),
    );

/// STATE-S23: view-state bất biến của Webhooks — subscriptions sống ở
/// Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class LaunchpadWebhooksViewState {
  const LaunchpadWebhooksViewState({
    required this.snapshot,
    required this.subscriptions,
  });

  factory LaunchpadWebhooksViewState.fromSnapshot(
    LaunchpadWebhooksSnapshot snapshot,
  ) {
    return LaunchpadWebhooksViewState(
      snapshot: snapshot,
      subscriptions: List.unmodifiable(snapshot.subscriptions),
    );
  }

  final LaunchpadWebhooksSnapshot snapshot;
  final List<LaunchpadWebhookSubscriptionDraft> subscriptions;

  LaunchpadWebhooksViewState copyWith({
    List<LaunchpadWebhookSubscriptionDraft>? subscriptions,
  }) {
    return LaunchpadWebhooksViewState(
      snapshot: snapshot,
      subscriptions: subscriptions == null
          ? this.subscriptions
          : List.unmodifiable(subscriptions),
    );
  }
}

/// GD4-F4 khuôn "controller GHI" biến thể A (xem GD4-Async-Playbook.md mục
/// 6): Notifier vẫn SYNC — `build()` lấy dữ liệu qua
/// `ref.watch(launchpadWebhooksSnapshotProvider).value` (nullable ở
/// Riverpod 3.x) với fallback rỗng tường minh. Trang luôn gate qua
/// `launchpadWebhooksSnapshotProvider.when()` trước khi đọc Notifier này
/// (mục 5), nên `.value` đã có dữ liệu thật trong luồng UI thật — fallback
/// rỗng chỉ chạm tới khi test đọc Notifier trực tiếp trước khi provider
/// async resolve.
final class LaunchpadWebhooksStateController
    extends Notifier<LaunchpadWebhooksViewState> {
  @override
  LaunchpadWebhooksViewState build() {
    final snapshot =
        ref.watch(launchpadWebhooksSnapshotProvider).value ??
        _emptyWebhooksSnapshot;
    return LaunchpadWebhooksViewState.fromSnapshot(snapshot);
  }

  void toggleStatus(String id) {
    state = state.copyWith(
      subscriptions: [
        for (final subscription in state.subscriptions)
          if (subscription.id == id)
            subscription.copyWith(
              status: subscription.status == LaunchpadWebhookStatus.active
                  ? LaunchpadWebhookStatus.paused
                  : LaunchpadWebhookStatus.active,
            )
          else
            subscription,
      ],
    );
  }

  void deleteSubscription(String id) {
    state = state.copyWith(
      subscriptions: [
        for (final subscription in state.subscriptions)
          if (subscription.id != id) subscription,
      ],
    );
  }

  void createSubscription(LaunchpadWebhookSubscriptionDraft subscription) {
    state = state.copyWith(
      subscriptions: [...state.subscriptions, subscription],
    );
  }
}

const _emptyWebhooksSnapshot = LaunchpadWebhooksSnapshot(
  endpoint: '/api/mobile/launchpad/launchpad-webhooks',
  actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
  title: 'Webhooks',
  backRoute: '/launchpad',
  tabs: [],
  subscriptions: [],
  deliveries: [],
  eventTypes: [],
  contractNotes: '',
  supportedStates: {LaunchpadScreenState.loading},
);

final launchpadWebhooksStateControllerProvider =
    NotifierProvider<
      LaunchpadWebhooksStateController,
      LaunchpadWebhooksViewState
    >(LaunchpadWebhooksStateController.new);

/// STATE-S23: view-state bất biến của Multisig — transactions sống ở
/// Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class LaunchpadMultisigViewState {
  const LaunchpadMultisigViewState({
    required this.snapshot,
    required this.transactions,
  });

  factory LaunchpadMultisigViewState.fromSnapshot(
    LaunchpadMultisigSnapshot snapshot,
  ) {
    return LaunchpadMultisigViewState(
      snapshot: snapshot,
      transactions: List.unmodifiable(snapshot.transactions),
    );
  }

  final LaunchpadMultisigSnapshot snapshot;
  final List<LaunchpadMultisigTxDraft> transactions;

  LaunchpadMultisigViewState copyWith({
    List<LaunchpadMultisigTxDraft>? transactions,
  }) {
    return LaunchpadMultisigViewState(
      snapshot: snapshot,
      transactions: transactions == null
          ? this.transactions
          : List.unmodifiable(transactions),
    );
  }
}

/// GD4-F4 khuôn "controller GHI" biến thể A (xem GD4-Async-Playbook.md mục
/// 6): build() lấy dữ liệu qua `.value` với fallback rỗng — trang gate qua
/// `launchpadMultisigSnapshotProvider.when()` trước khi đọc Notifier này.
final class LaunchpadMultisigStateController
    extends Notifier<LaunchpadMultisigViewState> {
  @override
  LaunchpadMultisigViewState build() {
    final snapshot =
        ref.watch(launchpadMultisigSnapshotProvider).value ??
        _emptyMultisigSnapshot;
    return LaunchpadMultisigViewState.fromSnapshot(snapshot);
  }

  void signTx(String id) {
    state = state.copyWith(
      transactions: [
        for (final tx in state.transactions)
          if (tx.id != id) tx else _signedTransaction(tx),
      ],
    );
  }

  void executeTx(String id) {
    state = state.copyWith(
      transactions: [
        for (final tx in state.transactions)
          tx.id == id
              ? tx.copyWith(
                  status: LaunchpadMultisigTxStatus.executed,
                  executedAt: '07/03/2026 10:15',
                  executeTxHash: '0xExec...313',
                )
              : tx,
      ],
    );
  }

  void createTx(LaunchpadMultisigTxDraft tx) {
    state = state.copyWith(transactions: [tx, ...state.transactions]);
  }
}

LaunchpadMultisigTxDraft _signedTransaction(LaunchpadMultisigTxDraft tx) {
  var changed = false;
  final signers = [
    for (final signer in tx.signers)
      if (!changed && !signer.signed)
        (() {
          changed = true;
          return signer.copyWith(signed: true, signedAt: '07/03/2026 10:10');
        })()
      else
        signer,
  ];
  final signedCount = signers.where((signer) => signer.signed).length;
  return tx.copyWith(
    signers: signers,
    signedCount: signedCount,
    status: signedCount >= tx.threshold
        ? LaunchpadMultisigTxStatus.ready
        : LaunchpadMultisigTxStatus.pendingSignatures,
  );
}

const _emptyMultisigSnapshot = LaunchpadMultisigSnapshot(
  endpoint: '/api/mobile/launchpad/launchpad-multisig',
  actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
  title: 'Multi-sig',
  backRoute: '/launchpad',
  tabs: [],
  safes: [],
  transactions: [],
  defaultSafeAddress: '',
  contractNotes: '',
  supportedStates: {LaunchpadScreenState.loading},
);

final launchpadMultisigStateControllerProvider =
    NotifierProvider<
      LaunchpadMultisigStateController,
      LaunchpadMultisigViewState
    >(LaunchpadMultisigStateController.new);

/// STATE-S23: view-state bất biến của Gas Tracker — alerts sống ở Notifier
/// (một nguồn sự thật), trang chỉ watch + gọi method.
final class LaunchpadGasTrackerViewState {
  const LaunchpadGasTrackerViewState({
    required this.snapshot,
    required this.alerts,
  });

  factory LaunchpadGasTrackerViewState.fromSnapshot(
    LaunchpadGasTrackerSnapshot snapshot,
  ) {
    return LaunchpadGasTrackerViewState(
      snapshot: snapshot,
      alerts: List.unmodifiable(snapshot.alerts),
    );
  }

  final LaunchpadGasTrackerSnapshot snapshot;
  final List<LaunchpadGasAlertDraft> alerts;

  LaunchpadGasTrackerViewState copyWith({
    List<LaunchpadGasAlertDraft>? alerts,
  }) {
    return LaunchpadGasTrackerViewState(
      snapshot: snapshot,
      alerts: alerts == null ? this.alerts : List.unmodifiable(alerts),
    );
  }
}

/// GD4-F4 khuôn "controller GHI" biến thể A (xem GD4-Async-Playbook.md mục
/// 6): build() lấy dữ liệu qua `.value` với fallback rỗng — trang gate qua
/// `launchpadGasTrackerSnapshotProvider.when()` trước khi đọc Notifier này.
final class LaunchpadGasTrackerStateController
    extends Notifier<LaunchpadGasTrackerViewState> {
  @override
  LaunchpadGasTrackerViewState build() {
    final snapshot =
        ref.watch(launchpadGasTrackerSnapshotProvider).value ??
        _emptyGasTrackerSnapshot;
    return LaunchpadGasTrackerViewState.fromSnapshot(snapshot);
  }

  void toggleAlert(String id) {
    state = state.copyWith(
      alerts: [
        for (final alert in state.alerts)
          if (alert.id == id)
            alert.copyWith(enabled: !alert.enabled)
          else
            alert,
      ],
    );
  }

  void deleteAlert(String id) {
    state = state.copyWith(
      alerts: [
        for (final alert in state.alerts)
          if (alert.id != id) alert,
      ],
    );
  }

  void addAlert(LaunchpadGasAlertDraft alert) {
    state = state.copyWith(alerts: [...state.alerts, alert]);
  }
}

const _emptyGasTrackerSnapshot = LaunchpadGasTrackerSnapshot(
  endpoint: '/api/mobile/launchpad/launchpad-gas-tracker',
  actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
  title: 'Gas Tracker',
  backRoute: '/launchpad',
  tabs: [],
  prices: [],
  estimates: [],
  alerts: [],
  contractNotes: '',
  supportedStates: {LaunchpadScreenState.loading},
);

final launchpadGasTrackerStateControllerProvider =
    NotifierProvider<
      LaunchpadGasTrackerStateController,
      LaunchpadGasTrackerViewState
    >(LaunchpadGasTrackerStateController.new);

/// STATE-S23: view-state bất biến của Sổ địa chỉ — addresses sống ở
/// Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class LaunchpadAddressBookViewState {
  const LaunchpadAddressBookViewState({
    required this.snapshot,
    required this.addresses,
  });

  factory LaunchpadAddressBookViewState.fromSnapshot(
    LaunchpadAddressBookSnapshot snapshot,
  ) {
    return LaunchpadAddressBookViewState(
      snapshot: snapshot,
      addresses: List.unmodifiable(snapshot.addresses),
    );
  }

  final LaunchpadAddressBookSnapshot snapshot;
  final List<LaunchpadWalletAddressDraft> addresses;

  LaunchpadAddressBookViewState copyWith({
    List<LaunchpadWalletAddressDraft>? addresses,
  }) {
    return LaunchpadAddressBookViewState(
      snapshot: snapshot,
      addresses: addresses == null
          ? this.addresses
          : List.unmodifiable(addresses),
    );
  }
}

/// GD4-F4 khuôn "controller GHI" biến thể A (xem GD4-Async-Playbook.md mục
/// 6): build() lấy dữ liệu qua `.value` với fallback rỗng — trang gate qua
/// `launchpadAddressBookSnapshotProvider.when()` trước khi đọc Notifier này.
final class LaunchpadAddressBookStateController
    extends Notifier<LaunchpadAddressBookViewState> {
  @override
  LaunchpadAddressBookViewState build() {
    final snapshot =
        ref.watch(launchpadAddressBookSnapshotProvider).value ??
        _emptyAddressBookSnapshot;
    return LaunchpadAddressBookViewState.fromSnapshot(snapshot);
  }

  void toggleFavorite(String id) {
    state = state.copyWith(
      addresses: [
        for (final address in state.addresses)
          address.id == id
              ? address.copyWith(isFavorite: !address.isFavorite)
              : address,
      ],
    );
  }

  void setDefault(String id) {
    state = state.copyWith(
      addresses: [
        for (final address in state.addresses)
          address.copyWith(isDefault: address.id == id),
      ],
    );
  }
}

const _emptyAddressBookSnapshot = LaunchpadAddressBookSnapshot(
  endpoint: '/api/mobile/launchpad/launchpad-address-book',
  actionDraft:
      'POST /kyc/submission-step; POST /launchpad/subscribe|claim|bridge where applicable',
  title: 'So dia chi',
  backRoute: '/launchpad',
  addresses: [],
  chainFilters: [],
  contractNotes: '',
  supportedStates: {LaunchpadScreenState.loading},
);

final launchpadAddressBookStateControllerProvider =
    NotifierProvider<
      LaunchpadAddressBookStateController,
      LaunchpadAddressBookViewState
    >(LaunchpadAddressBookStateController.new);
