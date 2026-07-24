import 'package:vit_trade_flutter/features/p2p_core/domain/entities/p2p_entities.dart';

/// Orders / escrow / P2P-wallet slice of [P2PRepository].
abstract interface class P2POrdersRepository {
  Future<P2POrderTimelineSnapshot> getOrderTimeline(String orderId);

  Future<P2POrderRateSnapshot> getOrderRate(String orderId);

  Future<P2POrderCancelSnapshot> getOrderCancel(String orderId);

  Future<P2POrderProofSnapshot> getOrderProof(String orderId);

  Future<P2POrderSnapshot> getOrder(String orderId);

  Future<P2PChatSnapshot> getChat(String orderId);

  Future<P2PEscrowBalanceSnapshot> getEscrowBalance({String asset = 'USDT'});

  Future<P2PEscrowDetailSnapshot> getEscrowDetail(String orderId);

  Future<P2PWalletTransferSnapshot> getWalletTransfer({
    String asset = 'USDT',
    String type = 'deposit',
  });

  Future<P2PFundLockHistorySnapshot> getFundLockHistory({
    bool walletHistoryAlias = false,
  });

  Future<P2PWalletSnapshot> getWallet();

  Future<P2PMyOrdersSnapshot> getMyOrders();
}
