import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/launchpad/data/providers/launchpad_repository_provider.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/controllers/launchpad_controller.dart';

export 'package:vit_trade_flutter/features/launchpad/presentation/controllers/launchpad_controller.dart';

final launchpadControllerProvider = Provider<LaunchpadController>((ref) {
  return LaunchpadController(ref.watch(launchpadRepositoryProvider));
});

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

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — hàng đợi
/// webhook giữ nguyên khi điều hướng đi/về trong phiên.
final class LaunchpadWebhooksStateController
    extends Notifier<LaunchpadWebhooksViewState> {
  @override
  LaunchpadWebhooksViewState build() {
    return LaunchpadWebhooksViewState.fromSnapshot(
      ref.watch(launchpadControllerProvider).getWebhooks(),
    );
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

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — hàng đợi
/// multisig giữ nguyên khi điều hướng đi/về trong phiên.
final class LaunchpadMultisigStateController
    extends Notifier<LaunchpadMultisigViewState> {
  @override
  LaunchpadMultisigViewState build() {
    return LaunchpadMultisigViewState.fromSnapshot(
      ref.watch(launchpadControllerProvider).getMultisig(),
    );
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

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — danh sách
/// alert gas giữ nguyên khi điều hướng đi/về trong phiên.
final class LaunchpadGasTrackerStateController
    extends Notifier<LaunchpadGasTrackerViewState> {
  @override
  LaunchpadGasTrackerViewState build() {
    return LaunchpadGasTrackerViewState.fromSnapshot(
      ref.watch(launchpadControllerProvider).getGasTracker(),
    );
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

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — sổ địa chỉ
/// giữ nguyên khi điều hướng đi/về trong phiên.
final class LaunchpadAddressBookStateController
    extends Notifier<LaunchpadAddressBookViewState> {
  @override
  LaunchpadAddressBookViewState build() {
    return LaunchpadAddressBookViewState.fromSnapshot(
      ref.watch(launchpadControllerProvider).getAddressBook(),
    );
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

final launchpadAddressBookStateControllerProvider =
    NotifierProvider<
      LaunchpadAddressBookStateController,
      LaunchpadAddressBookViewState
    >(LaunchpadAddressBookStateController.new);
