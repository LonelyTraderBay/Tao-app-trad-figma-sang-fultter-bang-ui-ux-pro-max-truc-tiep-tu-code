part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryEscrowMethods on _MockP2PRepositoryBase {
  @override
  P2PEscrowBalanceSnapshot getEscrowBalance({String asset = 'USDT'}) {
    final selectedAsset = _p2pEscrowOrders.containsKey(asset) ? asset : 'USDT';
    return P2PEscrowBalanceSnapshot(
      endpoint: '/api/mobile/p2p/p2p-escrow-balance',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      selectedAsset: selectedAsset,
      assets: _p2pEscrowAssets,
      ordersByAsset: _p2pEscrowOrders,
      title: 'Escrow Balance',
      subtitle: 'Escrow · P2P',
      infoTitle: 'Escrow là gì?',
      infoBody:
          'Khi bạn bán crypto, số tiền sẽ bị khóa trong escrow cho đến khi buyer thanh toán và bạn release. Điều này đảm bảo an toàn cho cả hai bên.',
      helpTitle: 'Khi nào tiền được giải phóng?',
      helpBullets: _p2pEscrowHelpBullets,
      parentRoute: '/p2p',
      emptyTitle: 'Không có tiền trong escrow',
      emptySubtitle: '$selectedAsset của bạn chưa bị khóa trong đơn hàng nào',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PEscrowDetailSnapshot getEscrowDetail(String orderId) {
    // Cross-domain: reuses Orders' getOrder() for order context. Safe
    // because MockP2PRepository composes both mixins; no import needed.
    final order = getOrder(orderId).order;
    return P2PEscrowDetailSnapshot(
      endpoint: '/api/mobile/p2p/p2p-escrow-$orderId',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      orderId: orderId,
      order: order,
      statusLabel: 'Đang khóa — Bảo vệ giao dịch',
      statusToneKey: 'warn',
      escrowAddress: _p2pEscrowAddress,
      explorerRoute: 'https://bscscan.com/address/$_p2pEscrowAddress',
      signers: _p2pEscrowSigners,
      timeline: _p2pEscrowTimeline,
      securityTitle: 'Bảo vệ bởi VitTrade Escrow',
      securityBody:
          'Coin được khóa trong smart contract đa chữ ký (2/3 multisig). Không bên nào có thể đơn phương rút coin. Nếu phát sinh tranh chấp, VitTrade sẽ đóng vai trò tài (arbiter).',
      parentRoute: '/p2p/order/$orderId',
      emptyTitle: 'Không tìm thấy escrow',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }
}
