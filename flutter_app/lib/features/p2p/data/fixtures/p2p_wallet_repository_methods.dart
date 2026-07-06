part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryWalletMethods on _MockP2PRepositoryBase {
  @override
  P2PWalletTransferSnapshot getWalletTransfer({
    String asset = 'USDT',
    String type = 'deposit',
  }) {
    return const P2PWalletTransferSnapshot(
      endpoint: '/api/mobile/p2p/p2p-wallet-transfer',
      actionDraft:
          'POST /wallet/transfer-preview + POST /wallet/transfer-confirm; POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      defaultAsset: 'USDT',
      defaultType: 'deposit',
      assets: _p2pWalletTransferAssets,
      balances: _p2pWalletTransferBalances,
      feeLabel: 'Miễn phí',
      processingLabel: 'Tức thì',
      escrowNote:
          'P2P Wallet và Main Wallet hoạt động độc lập để đảm bảo an toàn. Số dư trong escrow không thể chuyển.',
      confirmationNote:
          'Giao dịch nội bộ giữa P2P Wallet và Main Wallet được xử lý tức thì và hoàn toàn miễn phí.',
      parentRoute: '/p2p/wallet',
      emptyTitle: 'Chưa có dữ liệu chuyển ví P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PFundLockHistorySnapshot getFundLockHistory({
    bool walletHistoryAlias = false,
  }) {
    return P2PFundLockHistorySnapshot(
      endpoint: walletHistoryAlias
          ? '/api/mobile/p2p/p2p-wallet-history'
          : '/api/mobile/p2p/p2p-wallet-fund-lock-history',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Fund Lock History',
      subtitle: 'Escrow · P2P',
      heroTitle: 'Lịch sử khóa tiền',
      records: _p2pFundLockRecords,
      parentRoute: '/p2p/wallet',
      emptyTitle: walletHistoryAlias
          ? 'Chưa có lịch sử ví P2P'
          : 'Chưa có lịch sử khóa tiền',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PWalletSnapshot getWallet() {
    return const P2PWalletSnapshot(
      endpoint: '/api/mobile/p2p/p2p-wallet',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'P2P Wallet',
      subtitle: 'Ví · P2P',
      totalUsdValue: 22793.70,
      privacyMask: '••••••',
      balances: _p2pWalletBalances,
      transactions: _p2pWalletTransactions,
      infoNote:
          'P2P Wallet tách biệt khỏi Main Wallet để đảm bảo an toàn. Chuyển tiền nội bộ miễn phí & tức thì.',
      parentRoute: '/p2p',
      transferRoute: '/p2p/wallet/transfer',
      historyRoute: '/p2p/wallet/history',
      escrowBalanceRoute: '/p2p/escrow/balance',
      emptyTitle: 'Chưa có dữ liệu ví P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }
}
