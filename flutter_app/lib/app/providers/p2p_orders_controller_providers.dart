import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/p2p_core/data/providers/p2p_repository_provider.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';

export 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';

final p2pOrderTimelineProvider =
    FutureProvider.family<P2POrderTimelineSnapshot, String>(
      (ref, orderId) =>
          ref.watch(p2pOrdersRepositoryProvider).getOrderTimeline(orderId),
    );

final p2pOrderRateProvider =
    FutureProvider.family<P2POrderRateSnapshot, String>(
      (ref, orderId) =>
          ref.watch(p2pOrdersRepositoryProvider).getOrderRate(orderId),
    );

final p2pOrderCancelProvider =
    FutureProvider.family<P2POrderCancelSnapshot, String>(
      (ref, orderId) =>
          ref.watch(p2pOrdersRepositoryProvider).getOrderCancel(orderId),
    );

final p2pOrderProofProvider =
    FutureProvider.family<P2POrderProofSnapshot, String>(
      (ref, orderId) =>
          ref.watch(p2pOrdersRepositoryProvider).getOrderProof(orderId),
    );

final p2pOrderProvider = FutureProvider.family<P2POrderSnapshot, String>(
  (ref, orderId) => ref.watch(p2pOrdersRepositoryProvider).getOrder(orderId),
);

final p2pChatProvider = FutureProvider.family<P2PChatSnapshot, String>(
  (ref, orderId) => ref.watch(p2pOrdersRepositoryProvider).getChat(orderId),
);

final p2pEscrowBalanceProvider =
    FutureProvider.family<P2PEscrowBalanceSnapshot, String>(
      (ref, asset) =>
          ref.watch(p2pOrdersRepositoryProvider).getEscrowBalance(asset: asset),
    );

final p2pEscrowDetailProvider =
    FutureProvider.family<P2PEscrowDetailSnapshot, String>(
      (ref, orderId) =>
          ref.watch(p2pOrdersRepositoryProvider).getEscrowDetail(orderId),
    );

final p2pWalletTransferProvider =
    FutureProvider.family<
      P2PWalletTransferSnapshot,
      ({String asset, String type})
    >((ref, request) {
      return ref
          .watch(p2pOrdersRepositoryProvider)
          .getWalletTransfer(asset: request.asset, type: request.type);
    });

final p2pFundLockHistoryProvider =
    FutureProvider.family<P2PFundLockHistorySnapshot, bool>(
      (ref, walletHistoryAlias) => ref
          .watch(p2pOrdersRepositoryProvider)
          .getFundLockHistory(walletHistoryAlias: walletHistoryAlias),
    );

final p2pWalletProvider = FutureProvider<P2PWalletSnapshot>(
  (ref) => ref.watch(p2pOrdersRepositoryProvider).getWallet(),
);

final p2pMyOrdersProvider = FutureProvider<P2PMyOrdersSnapshot>(
  (ref) => ref.watch(p2pOrdersRepositoryProvider).getMyOrders(),
);
