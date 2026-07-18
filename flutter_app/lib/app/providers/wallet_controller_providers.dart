import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/wallet/data/providers/wallet_repository_provider.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';

export 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';

// GD4-F2: WalletRepository methods are now Future<T> (ADR-001 read idiom).
// Every "raw read" provider below is a plain FutureProvider forwarding the
// repository call — semantics (non-autoDispose) unchanged from the prior
// sync Provider<T>. See
// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md.

final walletSnapshotProvider = FutureProvider<WalletSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getWallet(),
);

final walletTransactionHistoryProvider =
    FutureProvider<WalletTransactionHistorySnapshot>(
      (ref) => ref.watch(walletRepositoryProvider).getTransactionHistory(),
    );

final walletTransactionDetailProvider =
    FutureProvider.family<WalletTransactionDetailSnapshot, String>(
      (ref, transactionId) => ref
          .watch(walletRepositoryProvider)
          .getTransactionDetail(transactionId),
    );

final walletPortfolioAnalyticsProvider =
    FutureProvider<WalletPortfolioAnalyticsSnapshot>(
      (ref) => ref.watch(walletRepositoryProvider).getPortfolioAnalytics(),
    );

final walletAddressAddSnapshotProvider =
    FutureProvider<WalletAddressAddSnapshot>(
      (ref) => ref.watch(walletRepositoryProvider).getAddressAdd(),
    );

final walletAddressBookProvider = FutureProvider<WalletAddressBookSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getAddressBook(),
);

final walletBuyCryptoProvider = FutureProvider<WalletBuyCryptoSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getBuyCrypto(),
);

final walletTransferProvider = FutureProvider<WalletTransferSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getTransfer(),
);

final walletAssetDetailProvider =
    FutureProvider.family<WalletAssetDetailSnapshot, String>(
      (ref, assetId) =>
          ref.watch(walletRepositoryProvider).getAssetDetail(assetId),
    );

final walletMultiManagerProvider = FutureProvider<WalletMultiManagerSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getMultiManager(),
);

final walletGasOptimizerProvider = FutureProvider<WalletGasOptimizerSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getGasOptimizer(),
);

final walletTokenApprovalsSnapshotProvider =
    FutureProvider<WalletTokenApprovalSnapshot>(
      (ref) => ref.watch(walletRepositoryProvider).getTokenApprovals(),
    );

final walletHealthScoreProvider = FutureProvider<WalletHealthScoreSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getHealthScore(),
);

final walletPendingDepositsProvider =
    FutureProvider<WalletPendingDepositsSnapshot>(
      (ref) => ref.watch(walletRepositoryProvider).getPendingDeposits(),
    );

final walletWithdrawLimitsProvider =
    FutureProvider<WalletWithdrawLimitsSnapshot>(
      (ref) => ref.watch(walletRepositoryProvider).getWithdrawLimits(),
    );

final walletDustConverterProvider = FutureProvider<WalletDustConverterSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getDustConverter(),
);

final walletNetworkStatusProvider = FutureProvider<WalletNetworkStatusSnapshot>(
  (ref) => ref.watch(walletRepositoryProvider).getNetworkStatus(),
);

final walletDepositControllerProvider =
    FutureProvider.family<
      WalletDepositSnapshot,
      ({String asset, bool assetScoped})
    >((ref, request) {
      return ref
          .watch(walletRepositoryProvider)
          .getDeposit(request.asset, assetScoped: request.assetScoped);
    });

final walletWithdrawSnapshotProvider =
    FutureProvider.family<
      WalletWithdrawSnapshot,
      ({String asset, bool assetScoped})
    >((ref, request) {
      return ref
          .watch(walletRepositoryProvider)
          .getWithdraw(request.asset, assetScoped: request.assetScoped);
    });

// STATE-S25 khuôn (xem home_controller_providers.dart): bọc AsyncValue thay
// vì unwrap bằng `requireValue` (từng ném StateError khi đọc lúc snapshot
// còn loading/error) — consumer widget tự `.when()` loading/error/data.
// Áp dụng cho 3 "controller đọc thuần" (không mutation) dưới đây.

final withdrawControllerProvider =
    Provider.family<
      AsyncValue<WithdrawController>,
      ({String asset, bool assetScoped})
    >((ref, request) {
      return ref
          .watch(walletWithdrawSnapshotProvider(request))
          .whenData(
            (snapshot) => WithdrawController(
              state: WithdrawViewState(snapshot: snapshot),
            ),
          );
    });

final addressAddControllerProvider = Provider<AsyncValue<AddressAddController>>(
  (ref) {
    return ref
        .watch(walletAddressAddSnapshotProvider)
        .whenData(
          (snapshot) => AddressAddController(
            state: AddressAddViewState(snapshot: snapshot),
          ),
        );
  },
);

final tokenApprovalControllerProvider =
    Provider<AsyncValue<TokenApprovalController>>((ref) {
      return ref
          .watch(walletTokenApprovalsSnapshotProvider)
          .whenData(
            (snapshot) => TokenApprovalController(
              state: TokenApprovalViewState(snapshot: snapshot),
            ),
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

/// GD4-F2 khuôn "controller GHI" (xem GD4-Async-Playbook.md mục "Controller
/// GHI"): Notifier vẫn SYNC (không đổi sang AsyncNotifier). `build()` lấy
/// dữ liệu qua `ref.watch(...).value` (nullable trong Riverpod 3.x) với
/// fallback rỗng tường minh
/// khi provider async chưa resolve/lỗi. Lý do chọn khuôn này thay vì
/// AsyncNotifier: mutation (toggleFavorite/deleteAddress) chỉ sửa state cục
/// bộ trong phiên, không gọi lại repo — giữ Notifier sync tránh phải
/// AsyncNotifier-hoá mọi call-site `ref.read(...).toggleFavorite(...)` chỉ
/// vì seed ban đầu là async. Trong luồng UI thật, trang luôn gate qua
/// `walletAddressBookProvider.when()` trước khi đọc Notifier này, nên
/// `.value` đã có dữ liệu thật — fallback rỗng chỉ chạm tới khi test
/// đọc Notifier trực tiếp trước khi provider async resolve.
final class AddressBookStateController extends Notifier<AddressBookViewState> {
  @override
  AddressBookViewState build() {
    final snapshot =
        ref.watch(walletAddressBookProvider).value ?? _emptyAddressBookSnapshot;
    return AddressBookViewState.fromSnapshot(snapshot);
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

const _emptyAddressBookSnapshot = WalletAddressBookSnapshot(
  addresses: [],
  networkFilters: [],
  endpoint: '/api/mobile/wallet/wallet-address-book',
  actionDraft: 'POST /kyc/submission-step',
  supportedStates: [WalletScreenState.loading],
);

final addressBookStateControllerProvider =
    NotifierProvider<AddressBookStateController, AddressBookViewState>(
      AddressBookStateController.new,
    );
