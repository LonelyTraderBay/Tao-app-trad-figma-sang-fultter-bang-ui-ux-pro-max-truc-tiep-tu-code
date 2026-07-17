import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/wallet/data/providers/wallet_repository_provider.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';

export 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';

final walletSnapshotProvider = Provider<WalletSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getWallet(),
);

final walletTransactionHistoryProvider =
    Provider<WalletTransactionHistorySnapshot>(
      (ref) => ref.watch(walletRepositoryProvider).getTransactionHistory(),
    );

final walletTransactionDetailProvider =
    Provider.family<WalletTransactionDetailSnapshot, String>(
      (ref, transactionId) => ref
          .watch(walletRepositoryProvider)
          .getTransactionDetail(transactionId),
    );

final walletPortfolioAnalyticsProvider =
    Provider<WalletPortfolioAnalyticsSnapshot>(
      (ref) => ref.watch(walletRepositoryProvider).getPortfolioAnalytics(),
    );

final walletAddressBookProvider = Provider<WalletAddressBookSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getAddressBook(),
);

final walletBuyCryptoProvider = Provider<WalletBuyCryptoSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getBuyCrypto(),
);

final walletTransferProvider = Provider<WalletTransferSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getTransfer(),
);

final walletAssetDetailProvider =
    Provider.family<WalletAssetDetailSnapshot, String>(
      (ref, assetId) =>
          ref.watch(walletRepositoryProvider).getAssetDetail(assetId),
    );

final walletMultiManagerProvider = Provider<WalletMultiManagerSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getMultiManager(),
);

final walletGasOptimizerProvider = Provider<WalletGasOptimizerSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getGasOptimizer(),
);

final walletHealthScoreProvider = Provider<WalletHealthScoreSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getHealthScore(),
);

final walletPendingDepositsProvider = Provider<WalletPendingDepositsSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getPendingDeposits(),
);

final walletWithdrawLimitsProvider = Provider<WalletWithdrawLimitsSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getWithdrawLimits(),
);

final walletDustConverterProvider = Provider<WalletDustConverterSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getDustConverter(),
);

final walletNetworkStatusProvider = Provider<WalletNetworkStatusSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getNetworkStatus(),
);

final walletDepositControllerProvider =
    Provider.family<WalletDepositSnapshot, ({String asset, bool assetScoped})>((
      ref,
      request,
    ) {
      return ref
          .watch(walletRepositoryProvider)
          .getDeposit(request.asset, assetScoped: request.assetScoped);
    });

final withdrawControllerProvider =
    Provider.family<WithdrawController, ({String asset, bool assetScoped})>((
      ref,
      request,
    ) {
      final snapshot = ref
          .watch(walletRepositoryProvider)
          .getWithdraw(request.asset, assetScoped: request.assetScoped);
      return WithdrawController(state: WithdrawViewState(snapshot: snapshot));
    });

final addressAddControllerProvider = Provider<AddressAddController>((ref) {
  final snapshot = ref.watch(walletRepositoryProvider).getAddressAdd();
  return AddressAddController(state: AddressAddViewState(snapshot: snapshot));
});

final tokenApprovalControllerProvider = Provider<TokenApprovalController>((
  ref,
) {
  final snapshot = ref.watch(walletRepositoryProvider).getTokenApprovals();
  return TokenApprovalController(
    state: TokenApprovalViewState(snapshot: snapshot),
  );
});

/// STATE-S23: view-state bất biến của Sổ địa chỉ — danh sách địa chỉ sống ở
/// Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class AddressBookViewState {
  const AddressBookViewState({required this.snapshot, required this.addresses});

  factory AddressBookViewState.fromSnapshot(
    WalletAddressBookSnapshot snapshot,
  ) {
    return AddressBookViewState(
      snapshot: snapshot,
      addresses: List.unmodifiable(snapshot.addresses),
    );
  }

  final WalletAddressBookSnapshot snapshot;
  final List<WalletSavedAddress> addresses;

  AddressBookViewState copyWith({List<WalletSavedAddress>? addresses}) {
    return AddressBookViewState(
      snapshot: snapshot,
      addresses: addresses == null
          ? this.addresses
          : List.unmodifiable(addresses),
    );
  }
}

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — state danh
/// bạ giữ nguyên khi điều hướng đi/về trong phiên.
final class AddressBookStateController extends Notifier<AddressBookViewState> {
  @override
  AddressBookViewState build() {
    return AddressBookViewState.fromSnapshot(
      ref.watch(walletAddressBookProvider),
    );
  }

  void toggleFavorite(String addressId) {
    state = state.copyWith(
      addresses: [
        for (final address in state.addresses)
          address.id == addressId
              ? address.copyWith(isFavorite: !address.isFavorite)
              : address,
      ],
    );
  }

  void deleteAddress(String addressId) {
    state = state.copyWith(
      addresses: state.addresses
          .where((address) => address.id != addressId)
          .toList(growable: false),
    );
  }
}

final addressBookStateControllerProvider =
    NotifierProvider<AddressBookStateController, AddressBookViewState>(
      AddressBookStateController.new,
    );
