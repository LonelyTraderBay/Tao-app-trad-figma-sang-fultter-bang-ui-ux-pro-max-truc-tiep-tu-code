import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/domain/repositories/wallet_repository.dart';

final class MockWalletRepository implements WalletRepository {
  const MockWalletRepository();

  @override
  WalletSnapshot getWallet() {
    return const WalletSnapshot(
      totalUsd: 57664,
      totalBtc: 0.85373496,
      availableUsd: 49763.67,
      inOrderUsd: 4815.39,
      frozenUsd: 3084.95,
      actions: _walletActions,
      dca: _walletDca,
      tools: _walletTools,
      assets: _walletAssets,
      endpoint: '/api/mobile/wallet/wallet',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
    );
  }

  @override
  WalletTransactionHistorySnapshot getTransactionHistory() {
    return const WalletTransactionHistorySnapshot(
      transactions: _walletTransactions,
      filters: _walletTransactionFilters,
      endpoint: '/api/mobile/wallet/wallet-history',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
    );
  }

  @override
  WalletTransactionDetailSnapshot getTransactionDetail(String transactionId) {
    WalletTransaction? tx;
    for (final transaction in _walletTransactions) {
      if (transaction.id == transactionId) {
        tx = transaction;
        break;
      }
    }
    return WalletTransactionDetailSnapshot(
      transaction: tx,
      endpoint:
          '/api/mobile/wallet/wallet-transaction-${transactionId.toLowerCase()}',
      actionDraft: 'read-only or local navigation action',
      supportedStates: const [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
    );
  }

  @override
  WalletPortfolioAnalyticsSnapshot getPortfolioAnalytics() {
    const totalUsd = 57664.00;
    return const WalletPortfolioAnalyticsSnapshot(
      totalUsd: totalUsd,
      totalReturnUsd: 10072.74,
      totalReturnPct: 21.17,
      bestProfitUsd: 2310,
      bestProfitAsset: 'BTC',
      worstLossUsd: -234,
      worstLossAsset: 'DOT',
      assets: _walletAssets,
      periods: ['1D', '1W', '1M', '3M', '1Y', 'ALL'],
      activePeriod: '1M',
      history: _walletPortfolioHistory,
      metrics: _walletPortfolioMetrics,
      endpoint: '/api/mobile/wallet/wallet-portfolio-analytics',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  WalletAddressAddSnapshot getAddressAdd() {
    return const WalletAddressAddSnapshot(
      networks: _walletAddressNetworks,
      assets: _walletAddressAssets,
      endpoint: '/api/mobile/wallet/wallet-address-book-add',
      actionDraft: 'POST /wallet/addresses; POST /kyc/submission-step',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
      auditTrailNote:
          'High-risk action: preview + confirm + audit trail required.',
    );
  }

  @override
  WalletAddressBookSnapshot getAddressBook() {
    return const WalletAddressBookSnapshot(
      addresses: _walletSavedAddresses,
      networkFilters: _walletAddressNetworkFilters,
      endpoint: '/api/mobile/wallet/wallet-address-book',
      actionDraft: 'POST /kyc/submission-step',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
    );
  }

  @override
  WalletBuyCryptoSnapshot getBuyCrypto() {
    return const WalletBuyCryptoSnapshot(
      cryptoOptions: _walletBuyCryptoOptions,
      paymentMethods: _walletBuyPaymentMethods,
      presetAmounts: _walletBuyPresetAmounts,
      endpoint: '/api/mobile/wallet/wallet-buy-crypto',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
    );
  }

  @override
  WalletTransferSnapshot getTransfer() {
    return const WalletTransferSnapshot(
      wallets: _walletTransferWallets,
      assets: _walletTransferAssets,
      recentTransfers: _walletRecentTransfers,
      endpoint: '/api/mobile/wallet/wallet-transfer',
      actionDraft:
          'POST /wallet/transfer-preview + POST /wallet/transfer-confirm',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.submitting,
        WalletScreenState.success,
      ],
    );
  }

  @override
  WalletAssetDetailSnapshot getAssetDetail(String assetId) {
    final normalized = assetId.toLowerCase();
    if (normalized == 'btc' || normalized == 'bitcoin') {
      return _walletBtcAssetDetail;
    }
    return _walletBtcAssetDetail;
  }

  @override
  WalletMultiManagerSnapshot getMultiManager() {
    return const WalletMultiManagerSnapshot(
      wallets: _walletManagerWallets,
      groups: _walletManagerGroups,
      endpoint: '/api/mobile/wallet/wallet-multi-manager',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
    );
  }

  @override
  WalletGasOptimizerSnapshot getGasOptimizer() {
    return const WalletGasOptimizerSnapshot(
      levels: _walletGasLevels,
      history: _walletGasHistory,
      networkActivity: _walletNetworkActivity,
      comparisons: _walletGasComparisons,
      tips: _walletGasTips,
      historicalAverageGwei: 28,
      endpoint: '/api/mobile/wallet/wallet-gas-optimizer',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
    );
  }

  @override
  WalletTokenApprovalSnapshot getTokenApprovals() {
    return const WalletTokenApprovalSnapshot(
      approvals: _walletTokenApprovals,
      revokedApprovals: _walletRevokedApprovals,
      endpoint: '/api/mobile/wallet/wallet-token-approval',
      actionDraft:
          'POST /wallet/token-approval/revoke-preview + POST /wallet/token-approval/revoke-confirm',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.submitting,
        WalletScreenState.success,
      ],
    );
  }

  @override
  WalletHealthScoreSnapshot getHealthScore() {
    return const WalletHealthScoreSnapshot(
      metrics: _walletHealthMetrics,
      diversification: _walletHealthDiversification,
      history: _walletHealthHistory,
      recommendations: _walletHealthRecommendations,
      securityChecklist: _walletSecurityChecklist,
      endpoint: '/api/mobile/wallet/wallet-health-score',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
    );
  }

  @override
  WalletPendingDepositsSnapshot getPendingDeposits() {
    return const WalletPendingDepositsSnapshot(
      deposits: _walletPendingDeposits,
      endpoint: '/api/mobile/wallet/wallet-pending-deposits',
      actionDraft: 'POST /wallet/deposit-intent',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.submitting,
        WalletScreenState.success,
      ],
    );
  }

  @override
  WalletWithdrawLimitsSnapshot getWithdrawLimits() {
    return const WalletWithdrawLimitsSnapshot(
      currentLevel: 2,
      usedToday: 2450,
      usedMonth: 18750,
      tiers: _walletKycTiers,
      faqs: _walletLimitFaqs,
      endpoint: '/api/mobile/wallet/wallet-limits',
      actionDraft: 'read-only + local navigation to /profile/kyc',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
    );
  }

  @override
  WalletDustConverterSnapshot getDustConverter() {
    return const WalletDustConverterSnapshot(
      dustThresholdUsd: 10,
      conversionFeePct: .5,
      targets: _walletDustTargets,
      assets: _walletDustAssets,
      endpoint: '/api/mobile/wallet/wallet-dust-converter',
      actionDraft:
          'POST /wallet/dust-converter/preview + POST /wallet/dust-converter/confirm',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.submitting,
        WalletScreenState.success,
      ],
    );
  }

  @override
  WalletNetworkStatusSnapshot getNetworkStatus() {
    return const WalletNetworkStatusSnapshot(
      networks: _walletNetworks,
      refreshIntervalSeconds: 4,
      endpoint: '/api/mobile/wallet/wallet-network-status',
      actionDraft: 'read-only refresh',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  WalletDepositSnapshot getDeposit(String asset, {bool assetScoped = false}) {
    final normalizedAsset = asset.toUpperCase();
    return WalletDepositSnapshot(
      asset: normalizedAsset,
      networks:
          _walletDepositNetworks[normalizedAsset] ??
          _walletDepositNetworks['USDT']!,
      endpoint: assetScoped
          ? '/api/mobile/wallet/wallet-deposit-${normalizedAsset.toLowerCase()}'
          : '/api/mobile/wallet/wallet-deposit',
      actionDraft: 'POST /wallet/deposit-intent',
      supportedStates: const [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.submitting,
        WalletScreenState.success,
      ],
    );
  }

  @override
  WalletWithdrawSnapshot getWithdraw(String asset, {bool assetScoped = false}) {
    final normalizedAsset = asset.toUpperCase();
    return WalletWithdrawSnapshot(
      asset: normalizedAsset,
      available: _walletWithdrawAvailable[normalizedAsset] ?? 10200,
      networks:
          _walletWithdrawNetworks[normalizedAsset] ??
          _walletWithdrawNetworks['USDT']!,
      recentAddresses: _walletRecentAddresses,
      endpoint: assetScoped
          ? '/api/mobile/wallet/wallet-withdraw-${normalizedAsset.toLowerCase()}'
          : '/api/mobile/wallet/wallet-withdraw',
      actionDraft:
          'POST /wallet/withdraw-preview + POST /wallet/withdraw-confirm',
      supportedStates: const [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.submitting,
        WalletScreenState.success,
      ],
    );
  }
}

const List<WalletTransactionFilter> _walletTransactionFilters = [
  WalletTransactionFilter(id: 'all', label: 'Tất cả'),
  WalletTransactionFilter(id: 'deposit', label: 'Nạp'),
  WalletTransactionFilter(id: 'withdraw', label: 'Rút'),
  WalletTransactionFilter(id: 'trade', label: 'Giao dịch'),
  WalletTransactionFilter(id: 'p2p', label: 'P2P'),
];

const List<WalletTransaction> _walletTransactions = [
  WalletTransaction(
    id: 'tx001',
    type: WalletTransactionType.deposit,
    asset: 'USDT',
    amount: 5000,
    status: WalletTransactionStatus.completed,
    txHash: '0x1a2b3c...',
    network: 'TRC20',
    createdAt: '2024-02-21 08:00:00',
  ),
  WalletTransaction(
    id: 'tx002',
    type: WalletTransactionType.tradeBuy,
    asset: 'BTC',
    amount: 0.1,
    status: WalletTransactionStatus.completed,
    createdAt: '2024-02-20 14:22:01',
    fee: 3.33,
  ),
  WalletTransaction(
    id: 'tx003',
    type: WalletTransactionType.tradeSell,
    asset: 'ETH',
    amount: 2,
    status: WalletTransactionStatus.completed,
    createdAt: '2024-02-20 11:10:09',
    fee: 0.72,
  ),
  WalletTransaction(
    id: 'tx004',
    type: WalletTransactionType.withdraw,
    asset: 'USDT',
    amount: 1000,
    status: WalletTransactionStatus.pending,
    address: 'TQn...Xyz',
    network: 'TRC20',
    createdAt: '2024-02-19 20:15:00',
    fee: 1,
  ),
  WalletTransaction(
    id: 'tx005',
    type: WalletTransactionType.deposit,
    asset: 'ETH',
    amount: 5,
    status: WalletTransactionStatus.completed,
    txHash: '0x4d5e6f...',
    network: 'ERC20',
    createdAt: '2024-02-18 12:30:00',
  ),
  WalletTransaction(
    id: 'tx006',
    type: WalletTransactionType.p2pBuy,
    asset: 'USDT',
    amount: 2000,
    status: WalletTransactionStatus.completed,
    createdAt: '2024-02-17 09:45:00',
  ),
];

const List<WalletPortfolioPoint> _walletPortfolioHistory = [
  WalletPortfolioPoint(label: '18/4', value: 47080),
  WalletPortfolioPoint(label: '20/4', value: 46920),
  WalletPortfolioPoint(label: '21/4', value: 46880),
  WalletPortfolioPoint(label: '23/4', value: 45820),
  WalletPortfolioPoint(label: '24/4', value: 46440),
  WalletPortfolioPoint(label: '26/4', value: 46480),
  WalletPortfolioPoint(label: '27/4', value: 44820),
  WalletPortfolioPoint(label: '29/4', value: 43220),
  WalletPortfolioPoint(label: '30/4', value: 44880),
  WalletPortfolioPoint(label: '1/5', value: 45820),
  WalletPortfolioPoint(label: '3/5', value: 47240),
  WalletPortfolioPoint(label: '4/5', value: 46240),
  WalletPortfolioPoint(label: '6/5', value: 45920),
  WalletPortfolioPoint(label: '7/5', value: 45820),
  WalletPortfolioPoint(label: '9/5', value: 45720),
  WalletPortfolioPoint(label: '10/5', value: 45680),
  WalletPortfolioPoint(label: '12/5', value: 47420),
  WalletPortfolioPoint(label: '13/5', value: 48180),
  WalletPortfolioPoint(label: '15/5', value: 47860),
  WalletPortfolioPoint(label: '16/5', value: 49300),
  WalletPortfolioPoint(label: '18/5', value: 48690),
  WalletPortfolioPoint(label: '19/5', value: 47280),
  WalletPortfolioPoint(label: '20/5', value: 47860),
  WalletPortfolioPoint(label: '21/5', value: 48340),
  WalletPortfolioPoint(label: '22/5', value: 46920),
  WalletPortfolioPoint(label: '23/5', value: 49280),
  WalletPortfolioPoint(label: '24/5', value: 50720),
  WalletPortfolioPoint(label: '25/5', value: 51780),
  WalletPortfolioPoint(label: '26/5', value: 52280),
  WalletPortfolioPoint(label: '27/5', value: 51480),
  WalletPortfolioPoint(label: '28/5', value: 51480),
];

const List<WalletPortfolioMetric> _walletPortfolioMetrics = [
  WalletPortfolioMetric(
    label: 'Lợi nhuận theo kỳ',
    value: '+21.17%',
    colorHex: 0xFF10B981,
  ),
  WalletPortfolioMetric(
    label: 'Lợi nhuận tuyệt đối',
    value: '+\$10,072.74',
    colorHex: 0xFF10B981,
  ),
  WalletPortfolioMetric(
    label: 'Giá trị cao nhất',
    value: '\$48,589.63',
    colorHex: 0xFFE8ECF8,
  ),
  WalletPortfolioMetric(
    label: 'Giá trị thấp nhất',
    value: '\$46,721.44',
    colorHex: 0xFFE8ECF8,
  ),
  WalletPortfolioMetric(
    label: 'Số lệnh thực hiện',
    value: '47',
    colorHex: 0xFFE8ECF8,
  ),
  WalletPortfolioMetric(
    label: 'Phí giao dịch tổng',
    value: '\$38.42',
    colorHex: 0xFFF59E0B,
  ),
];

const List<WalletAddressNetwork> _walletAddressNetworks = [
  WalletAddressNetwork(
    id: 'btc',
    label: 'BTC',
    colorHex: 0xFFF7931A,
    addressHint: 'Bắt đầu với bc1... hoặc 1... hoặc 3...',
  ),
  WalletAddressNetwork(
    id: 'erc20',
    label: 'ETH (ERC20)',
    colorHex: 0xFF627EEA,
    addressHint: 'Bắt đầu với 0x... (42 ký tự)',
  ),
  WalletAddressNetwork(
    id: 'bep20',
    label: 'BSC (BEP20)',
    colorHex: 0xFFF3BA2F,
    addressHint: 'Bắt đầu với 0x... (42 ký tự)',
  ),
  WalletAddressNetwork(
    id: 'trc20',
    label: 'TRC20',
    colorHex: 0xFFEF4444,
    addressHint: 'Bắt đầu với T... (34 ký tự)',
  ),
  WalletAddressNetwork(
    id: 'sol',
    label: 'SOL',
    colorHex: 0xFF9945FF,
    addressHint: 'Base58, 32-44 ký tự',
  ),
  WalletAddressNetwork(
    id: 'polygon',
    label: 'Polygon',
    colorHex: 0xFF8247E5,
    addressHint: 'Bắt đầu với 0x... (42 ký tự)',
  ),
];

const List<String> _walletAddressAssets = [
  'BTC',
  'ETH',
  'USDT',
  'BNB',
  'SOL',
  'MATIC',
];

const List<String> _walletAddressNetworkFilters = [
  'Tất cả',
  'BTC',
  'ETH (ERC20)',
  'BSC (BEP20)',
  'SOL',
  'TRC20',
  'Polygon',
];

const List<WalletSavedAddress> _walletSavedAddresses = [
  WalletSavedAddress(
    id: 'addr1',
    label: 'Ví lạnh cá nhân',
    address: 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh',
    network: 'BTC',
    asset: 'BTC',
    isFavorite: true,
    createdAt: '15/01/2026',
    lastUsed: '20/02/2026',
    isWhitelisted: true,
  ),
  WalletSavedAddress(
    id: 'addr2',
    label: 'Binance Exchange',
    address: '0x742d35Cc6634C0532925a3b844Bc9e7595f6C29f',
    network: 'ETH (ERC20)',
    asset: 'ETH',
    isFavorite: true,
    createdAt: '10/01/2026',
    lastUsed: '18/02/2026',
    isWhitelisted: true,
  ),
  WalletSavedAddress(
    id: 'addr3',
    label: 'Ví USDT BSC',
    address: '0x8Ba1f109551bD432803012645Ac136ddd64DBa72',
    network: 'BSC (BEP20)',
    asset: 'USDT',
    isFavorite: false,
    createdAt: '20/01/2026',
    lastUsed: '15/02/2026',
    isWhitelisted: false,
  ),
  WalletSavedAddress(
    id: 'addr4',
    label: 'Phantom Wallet',
    address: 'BkJMJfHtjL8o69n2vxqHE6MbEv4ZR3zqRPnLVe2bFpYo',
    network: 'SOL',
    asset: 'SOL',
    isFavorite: false,
    createdAt: '05/02/2026',
    isWhitelisted: false,
  ),
  WalletSavedAddress(
    id: 'addr5',
    label: 'Sàn OKX',
    address: 'TN3W4H6rK2ce4vX9YnFQHwKx8Vq9m6dxWc',
    network: 'TRC20',
    asset: 'USDT',
    isFavorite: false,
    createdAt: '01/02/2026',
    lastUsed: '10/02/2026',
    isWhitelisted: true,
  ),
];

const List<WalletBuyCryptoOption> _walletBuyCryptoOptions = [
  WalletBuyCryptoOption(
    symbol: 'USDT',
    name: 'Tether USD',
    colorHex: 0xFF26A17B,
    minBuyVnd: 100000,
    priceVnd: 25350,
  ),
  WalletBuyCryptoOption(
    symbol: 'BTC',
    name: 'Bitcoin',
    colorHex: 0xFFF7931A,
    minBuyVnd: 500000,
    priceVnd: 1713600000,
  ),
  WalletBuyCryptoOption(
    symbol: 'ETH',
    name: 'Ethereum',
    colorHex: 0xFF627EEA,
    minBuyVnd: 300000,
    priceVnd: 89323800,
  ),
  WalletBuyCryptoOption(
    symbol: 'BNB',
    name: 'BNB',
    colorHex: 0xFFF3BA2F,
    minBuyVnd: 200000,
    priceVnd: 10475000,
  ),
  WalletBuyCryptoOption(
    symbol: 'SOL',
    name: 'Solana',
    colorHex: 0xFF9945FF,
    minBuyVnd: 200000,
    priceVnd: 4522000,
  ),
];

const List<WalletPaymentMethod> _walletBuyPaymentMethods = [
  WalletPaymentMethod(
    id: 'vietcombank',
    name: 'Vietcombank',
    type: WalletPaymentMethodType.bank,
    logo: 'VCB',
    logoColorHex: 0xFF007F3E,
    processingTime: '2-5 phút',
    feeVnd: 0,
    dailyLimitLabel: '1,000,000,000',
    isPopular: true,
  ),
  WalletPaymentMethod(
    id: 'techcombank',
    name: 'Techcombank',
    type: WalletPaymentMethodType.bank,
    logo: 'TCB',
    logoColorHex: 0xFFE02020,
    processingTime: '2-5 phút',
    feeVnd: 0,
    dailyLimitLabel: '1,000,000,000',
  ),
  WalletPaymentMethod(
    id: 'bidv',
    name: 'BIDV',
    type: WalletPaymentMethodType.bank,
    logo: 'BIDV',
    logoColorHex: 0xFF0066CC,
    processingTime: '2-5 phút',
    feeVnd: 0,
    dailyLimitLabel: '500,000,000',
  ),
  WalletPaymentMethod(
    id: 'momo',
    name: 'Ví MoMo',
    type: WalletPaymentMethodType.ewallet,
    logo: 'MM',
    logoColorHex: 0xFFAE2070,
    processingTime: 'Tức thì',
    feeVnd: 0,
    dailyLimitLabel: '100,000,000',
    isPopular: true,
  ),
  WalletPaymentMethod(
    id: 'zalopay',
    name: 'ZaloPay',
    type: WalletPaymentMethodType.ewallet,
    logo: 'ZP',
    logoColorHex: 0xFF008FE8,
    processingTime: 'Tức thì',
    feeVnd: 0,
    dailyLimitLabel: '100,000,000',
  ),
  WalletPaymentMethod(
    id: 'vnpay',
    name: 'VNPAY QR',
    type: WalletPaymentMethodType.qr,
    logo: 'QR',
    logoColorHex: 0xFF1A73E8,
    processingTime: '1-2 phút',
    feeVnd: 0,
    dailyLimitLabel: '200,000,000',
  ),
];

const List<WalletTransferWallet> _walletTransferWallets = [
  WalletTransferWallet(
    id: 'spot',
    name: 'Ví Spot',
    balanceUsd: 54276.79,
    colorHex: 0xFF3B82F6,
    iconKey: 'spot',
  ),
  WalletTransferWallet(
    id: 'funding',
    name: 'Ví Funding',
    balanceUsd: 8450.20,
    colorHex: 0xFF10B981,
    iconKey: 'funding',
  ),
  WalletTransferWallet(
    id: 'futures',
    name: 'Ví Futures',
    balanceUsd: 3200.00,
    colorHex: 0xFFF59E0B,
    iconKey: 'futures',
  ),
];

const List<WalletTransferAsset> _walletTransferAssets = [
  WalletTransferAsset(
    id: 'usdt',
    symbol: 'USDT',
    name: 'Tether USD',
    available: 10200.00,
    usdRate: 1,
    colorHex: 0xFF10B981,
  ),
  WalletTransferAsset(
    id: 'btc',
    symbol: 'BTC',
    name: 'Bitcoin',
    available: .1254,
    usdRate: 67543.21,
    colorHex: 0xFFF7931A,
  ),
  WalletTransferAsset(
    id: 'eth',
    symbol: 'ETH',
    name: 'Ethereum',
    available: 2.384,
    usdRate: 3460.20,
    colorHex: 0xFF627EEA,
  ),
  WalletTransferAsset(
    id: 'sol',
    symbol: 'SOL',
    name: 'Solana',
    available: 48.75,
    usdRate: 188.30,
    colorHex: 0xFF9945FF,
  ),
];

const List<WalletRecentTransfer> _walletRecentTransfers = [
  WalletRecentTransfer(
    fromWallet: 'Spot',
    toWallet: 'Funding',
    asset: 'USDT',
    amount: 2000,
    time: '21/02 11:30',
  ),
  WalletRecentTransfer(
    fromWallet: 'Funding',
    toWallet: 'Spot',
    asset: 'USDT',
    amount: 500,
    time: '20/02 09:15',
  ),
  WalletRecentTransfer(
    fromWallet: 'Spot',
    toWallet: 'Futures',
    asset: 'USDT',
    amount: 1000,
    time: '19/02 14:20',
  ),
];

const WalletAssetDetailSnapshot _walletBtcAssetDetail =
    WalletAssetDetailSnapshot(
      assetId: 'btc',
      name: 'Bitcoin',
      symbol: 'BTC',
      colorHex: 0xFFF7931A,
      balance: 0.234510,
      usdValue: 15842.10,
      change24h: 2.34,
      available: 0.214510,
      inOrder: 0.020000,
      frozen: 0,
      currentPrice: 67543.21,
      actions: _walletBtcAssetActions,
      chart: _walletBtcAssetChart,
      transactions: _walletBtcAssetTransactions,
      endpoint: '/api/mobile/wallet/wallet-asset-btc',
      actionDraft: 'read-only or local navigation action',
      supportedStates: [
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ],
    );

const List<WalletAssetDetailAction> _walletBtcAssetActions = [
  WalletAssetDetailAction(
    id: 'deposit',
    label: 'Nạp',
    route: '/wallet/deposit/btc',
    colorHex: 0xFF10B981,
    iconKey: 'deposit',
  ),
  WalletAssetDetailAction(
    id: 'withdraw',
    label: 'Rút',
    route: '/wallet/withdraw/btc',
    colorHex: 0xFFEF4444,
    iconKey: 'withdraw',
  ),
  WalletAssetDetailAction(
    id: 'transfer',
    label: 'Chuyển',
    route: '/wallet/transfer',
    colorHex: 0xFF3B82F6,
    iconKey: 'transfer',
  ),
  WalletAssetDetailAction(
    id: 'dca',
    label: 'DCA',
    route: '/dca',
    colorHex: 0xFF8B5CF6,
    iconKey: 'dca',
  ),
];

const List<WalletAssetChartPoint> _walletBtcAssetChart = [
  WalletAssetChartPoint(index: 0, price: 60300),
  WalletAssetChartPoint(index: 1, price: 59600),
  WalletAssetChartPoint(index: 2, price: 60850),
  WalletAssetChartPoint(index: 3, price: 60900),
  WalletAssetChartPoint(index: 4, price: 62000),
  WalletAssetChartPoint(index: 5, price: 63000),
  WalletAssetChartPoint(index: 6, price: 60400),
  WalletAssetChartPoint(index: 7, price: 61700),
  WalletAssetChartPoint(index: 8, price: 64200),
  WalletAssetChartPoint(index: 9, price: 68100),
  WalletAssetChartPoint(index: 10, price: 69200),
  WalletAssetChartPoint(index: 11, price: 73500),
  WalletAssetChartPoint(index: 12, price: 69800),
  WalletAssetChartPoint(index: 13, price: 70500),
  WalletAssetChartPoint(index: 14, price: 72000),
  WalletAssetChartPoint(index: 15, price: 71300),
  WalletAssetChartPoint(index: 16, price: 71800),
  WalletAssetChartPoint(index: 17, price: 68400),
  WalletAssetChartPoint(index: 18, price: 71600),
  WalletAssetChartPoint(index: 19, price: 69200),
  WalletAssetChartPoint(index: 20, price: 73200),
  WalletAssetChartPoint(index: 21, price: 77500),
  WalletAssetChartPoint(index: 22, price: 76200),
  WalletAssetChartPoint(index: 23, price: 80100),
  WalletAssetChartPoint(index: 24, price: 78500),
  WalletAssetChartPoint(index: 25, price: 80100),
  WalletAssetChartPoint(index: 26, price: 84200),
  WalletAssetChartPoint(index: 27, price: 82400),
  WalletAssetChartPoint(index: 28, price: 79300),
  WalletAssetChartPoint(index: 29, price: 77500),
];

const List<WalletAssetDetailTransaction> _walletBtcAssetTransactions = [
  WalletAssetDetailTransaction(
    id: 'tx001',
    label: 'Mua',
    amount: 0.100000,
    asset: 'BTC',
    createdAt: '2024-02-20 14:22',
    status: 'Hoàn thành',
    isIncoming: true,
    route: '/wallet/transaction/tx001',
  ),
];

const List<WalletManagerItem> _walletManagerWallets = [
  WalletManagerItem(
    id: 'w1',
    name: 'Main Wallet',
    address: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb',
    type: 'hot',
    balanceUsd: 45280,
    change24hPct: 3.2,
    lastActiveLabel: '23:27 18 thg 5',
    isDefault: true,
    isFavorite: true,
    groupId: 'g1',
    accentColorHex: 0xFF10B981,
    typeColorHex: 0xFFF59E0B,
    distributionColorHex: 0xFF10B981,
    assets: [
      WalletManagerAsset(symbol: 'BTC', balance: .45, valueUsd: 28500),
      WalletManagerAsset(symbol: 'ETH', balance: 5.2, valueUsd: 13000),
      WalletManagerAsset(symbol: 'USDT', balance: 3780, valueUsd: 3780),
    ],
  ),
  WalletManagerItem(
    id: 'w2',
    name: 'Trading Wallet',
    address: '0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063',
    type: 'hot',
    balanceUsd: 28900,
    change24hPct: -1.5,
    lastActiveLabel: '22:32 18 thg 5',
    isDefault: false,
    isFavorite: true,
    groupId: 'g1',
    accentColorHex: 0xFF3B82F6,
    typeColorHex: 0xFFF59E0B,
    distributionColorHex: 0xFF3B82F6,
    assets: [
      WalletManagerAsset(symbol: 'ETH', balance: 8.5, valueUsd: 21250),
      WalletManagerAsset(symbol: 'BNB', balance: 15, valueUsd: 7650),
    ],
  ),
  WalletManagerItem(
    id: 'w3',
    name: 'Cold Storage',
    address: '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984',
    type: 'cold',
    balanceUsd: 125000,
    change24hPct: .8,
    lastActiveLabel: '23:31 11 thg 5',
    isDefault: false,
    isFavorite: false,
    groupId: 'g2',
    accentColorHex: 0xFFF59E0B,
    typeColorHex: 0xFF3B82F6,
    distributionColorHex: 0xFFF59E0B,
    assets: [
      WalletManagerAsset(symbol: 'BTC', balance: 1.5, valueUsd: 95000),
      WalletManagerAsset(symbol: 'ETH', balance: 12, valueUsd: 30000),
    ],
  ),
  WalletManagerItem(
    id: 'w4',
    name: 'Hardware Ledger',
    address: '0x514910771AF9Ca656af840dff83E8264EcF986CA',
    type: 'hardware',
    balanceUsd: 68500,
    change24hPct: 2.1,
    lastActiveLabel: '23:32 16 thg 5',
    isDefault: false,
    isFavorite: false,
    groupId: 'g2',
    accentColorHex: 0xFF8B5CF6,
    typeColorHex: 0xFF10B981,
    distributionColorHex: 0xFF8B5CF6,
    assets: [
      WalletManagerAsset(symbol: 'BTC', balance: .85, valueUsd: 53900),
      WalletManagerAsset(symbol: 'USDT', balance: 14600, valueUsd: 14600),
    ],
  ),
];

const List<WalletManagerGroup> _walletManagerGroups = [
  WalletManagerGroup(
    id: 'g1',
    name: 'Active Trading',
    colorHex: 0xFF10B981,
    walletIds: ['w1', 'w2'],
    totalValueUsd: 74180,
  ),
  WalletManagerGroup(
    id: 'g2',
    name: 'Long Term Hold',
    colorHex: 0xFF3B82F6,
    walletIds: ['w3', 'w4'],
    totalValueUsd: 193500,
  ),
];

const List<WalletGasLevel> _walletGasLevels = [
  WalletGasLevel(
    speed: 'slow',
    label: 'Slow',
    gwei: 15,
    usd: 2.10,
    timeEstimate: '~3 min',
    recommended: false,
    colorHex: 0xFF10B981,
  ),
  WalletGasLevel(
    speed: 'standard',
    label: 'Standard',
    gwei: 25,
    usd: 3.50,
    timeEstimate: '~1 min',
    recommended: true,
    colorHex: 0xFFF59E0B,
  ),
  WalletGasLevel(
    speed: 'fast',
    label: 'Fast',
    gwei: 35,
    usd: 4.90,
    timeEstimate: '~15 sec',
    recommended: false,
    colorHex: 0xFFEF4444,
  ),
];

const List<WalletGasComparison> _walletGasComparisons = [
  WalletGasComparison(type: 'Simple Transfer', gas: 21000, usd: 3.50),
  WalletGasComparison(type: 'Token Transfer', gas: 65000, usd: 10.80),
  WalletGasComparison(type: 'Swap (DEX)', gas: 180000, usd: 29.70),
  WalletGasComparison(type: 'NFT Mint', gas: 120000, usd: 19.80),
];

const List<WalletGasHistoryPoint> _walletGasHistory = [
  WalletGasHistoryPoint(time: '00:00', slow: 12, standard: 20, fast: 28),
  WalletGasHistoryPoint(time: '04:00', slow: 10, standard: 18, fast: 25),
  WalletGasHistoryPoint(time: '08:00', slow: 18, standard: 28, fast: 38),
  WalletGasHistoryPoint(time: '12:00', slow: 22, standard: 35, fast: 48),
  WalletGasHistoryPoint(time: '16:00', slow: 20, standard: 32, fast: 42),
  WalletGasHistoryPoint(time: '20:00', slow: 15, standard: 25, fast: 35),
  WalletGasHistoryPoint(time: 'Now', slow: 15, standard: 25, fast: 35),
];

const List<WalletNetworkActivityPoint> _walletNetworkActivity = [
  WalletNetworkActivityPoint(hour: '0h', txCount: 1200),
  WalletNetworkActivityPoint(hour: '4h', txCount: 800),
  WalletNetworkActivityPoint(hour: '8h', txCount: 2400),
  WalletNetworkActivityPoint(hour: '12h', txCount: 3200),
  WalletNetworkActivityPoint(hour: '16h', txCount: 2800),
  WalletNetworkActivityPoint(hour: '20h', txCount: 1800),
  WalletNetworkActivityPoint(hour: 'Now', txCount: 1500),
];

const List<WalletGasTip> _walletGasTips = [
  WalletGasTip(
    id: 't1',
    title: 'Transact During Low Activity',
    description:
        'Gas fees are lowest between 2 AM - 6 AM UTC when network activity is minimal',
    potentialSaving: 'Up to 60%',
    difficulty: 'easy',
    category: 'timing',
  ),
  WalletGasTip(
    id: 't2',
    title: 'Batch Transactions',
    description:
        'Combine multiple operations into one transaction to save on base gas fees',
    potentialSaving: '30-40%',
    difficulty: 'medium',
    category: 'optimization',
  ),
  WalletGasTip(
    id: 't3',
    title: 'Use Layer 2 Solutions',
    description:
        'Move assets to L2 networks like Arbitrum or Optimism for 90% lower fees',
    potentialSaving: 'Up to 90%',
    difficulty: 'easy',
    category: 'strategy',
  ),
  WalletGasTip(
    id: 't4',
    title: 'Set Custom Gas Limit',
    description: 'Reduce gas limit for simple transfers to avoid overpaying.',
    potentialSaving: '10-20%',
    difficulty: 'medium',
    category: 'optimization',
  ),
];

const List<WalletTokenApproval> _walletTokenApprovals = [
  WalletTokenApproval(
    id: 'a1',
    token: 'USDT',
    tokenAddress: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
    spender: '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',
    spenderName: 'Uniswap V2 Router',
    amountLabel: 'Unlimited',
    approvedAtLabel: 'thg 2 2026',
    lastUsedLabel: '11 thg 5',
    usageCount: 45,
    riskLevel: 'medium',
    verified: true,
    category: 'dex',
  ),
  WalletTokenApproval(
    id: 'a2',
    token: 'DAI',
    tokenAddress: '0x6B175474E89094C44Da98b954EedeAC495271d0F',
    spender: '0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9',
    spenderName: 'Aave Lending Pool',
    amountLabel: '50,000',
    approvedAtLabel: 'thg 3 2026',
    lastUsedLabel: '4 thg 5',
    usageCount: 12,
    riskLevel: 'low',
    verified: true,
    category: 'lending',
  ),
  WalletTokenApproval(
    id: 'a3',
    token: 'WETH',
    tokenAddress: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
    spender: '0x1234567890123456789012345678901234567890',
    spenderName: 'Unknown Contract',
    amountLabel: 'Unlimited',
    approvedAtLabel: 'thg 11 2025',
    lastUsedLabel: 'Never',
    usageCount: 0,
    riskLevel: 'critical',
    verified: false,
    category: 'unknown',
  ),
  WalletTokenApproval(
    id: 'a4',
    token: 'USDC',
    tokenAddress: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
    spender: '0xdef1c0ded9bec7f1a1670819833240f027b25eff',
    spenderName: '0x Exchange Proxy',
    amountLabel: '100,000',
    approvedAtLabel: 'thg 4 2026',
    lastUsedLabel: '15 thg 5',
    usageCount: 28,
    riskLevel: 'low',
    verified: true,
    category: 'dex',
  ),
  WalletTokenApproval(
    id: 'a5',
    token: 'UNI',
    tokenAddress: '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984',
    spender: '0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45',
    spenderName: 'Uniswap V3 Router',
    amountLabel: 'Unlimited',
    approvedAtLabel: 'thg 1 2026',
    lastUsedLabel: '3 thg 4',
    usageCount: 8,
    riskLevel: 'high',
    verified: true,
    category: 'dex',
  ),
];

const List<WalletRevokedApproval> _walletRevokedApprovals = [
  WalletRevokedApproval(
    id: 'r1',
    token: 'SHIB',
    spenderName: 'Suspicious Contract',
    revokedAtLabel: '13 thg 5, 23:32',
    reason: 'Security risk detected',
  ),
  WalletRevokedApproval(
    id: 'r2',
    token: 'LINK',
    spenderName: 'Old DeFi Protocol',
    revokedAtLabel: '28 thg 4, 23:32',
    reason: 'No longer using',
  ),
];

const List<WalletHealthMetric> _walletHealthMetrics = [
  WalletHealthMetric(
    category: 'Security',
    score: 75,
    maxScore: 100,
    status: 'good',
  ),
  WalletHealthMetric(
    category: 'Diversification',
    score: 60,
    maxScore: 100,
    status: 'warning',
  ),
  WalletHealthMetric(
    category: 'Activity',
    score: 85,
    maxScore: 100,
    status: 'excellent',
  ),
  WalletHealthMetric(
    category: 'Risk Management',
    score: 70,
    maxScore: 100,
    status: 'good',
  ),
  WalletHealthMetric(
    category: 'Backup & Recovery',
    score: 45,
    maxScore: 100,
    status: 'critical',
  ),
];

const List<WalletDiversificationSlice> _walletHealthDiversification = [
  WalletDiversificationSlice(name: 'BTC', value: 42, colorHex: 0xFFF59E0B),
  WalletDiversificationSlice(name: 'ETH', value: 28, colorHex: 0xFF3B82F6),
  WalletDiversificationSlice(
    name: 'Stablecoins',
    value: 18,
    colorHex: 0xFF10B981,
  ),
  WalletDiversificationSlice(name: 'Altcoins', value: 12, colorHex: 0xFF8B5CF6),
];

const List<WalletHealthHistoryPoint> _walletHealthHistory = [
  WalletHealthHistoryPoint(month: 'Jan', score: 65),
  WalletHealthHistoryPoint(month: 'Feb', score: 68),
  WalletHealthHistoryPoint(month: 'Mar', score: 72),
  WalletHealthHistoryPoint(month: 'Apr', score: 70),
  WalletHealthHistoryPoint(month: 'May', score: 75),
  WalletHealthHistoryPoint(month: 'Jun', score: 73),
];

const List<WalletHealthRecommendation> _walletHealthRecommendations = [
  WalletHealthRecommendation(
    id: 'r1',
    title: 'Enable 2FA',
    description:
        'Two-factor authentication adds an extra security layer to your wallet',
    impact: 'high',
    category: 'security',
    actionLabel: 'Enable Now',
  ),
  WalletHealthRecommendation(
    id: 'r2',
    title: 'Backup Seed Phrase',
    description:
        'Create an encrypted backup of your seed phrase in secure storage',
    impact: 'high',
    category: 'backup',
    actionLabel: 'Backup Now',
  ),
  WalletHealthRecommendation(
    id: 'r3',
    title: 'Diversify Portfolio',
    description:
        '42% concentration in BTC. Consider rebalancing to reduce risk',
    impact: 'medium',
    category: 'diversification',
    actionLabel: 'View Plan',
  ),
  WalletHealthRecommendation(
    id: 'r4',
    title: 'Review Token Approvals',
    description: 'You have 3 unlimited approvals to unverified contracts',
    impact: 'high',
    category: 'security',
    actionLabel: 'Review',
  ),
  WalletHealthRecommendation(
    id: 'r5',
    title: 'Test Recovery Process',
    description:
        'Last recovery test was 6 months ago. Test your backup regularly',
    impact: 'medium',
    category: 'backup',
    actionLabel: 'Test Now',
  ),
];

const List<WalletSecurityChecklistItem> _walletSecurityChecklist = [
  WalletSecurityChecklistItem(
    item: '2FA Enabled',
    enabled: true,
    description: 'Google Authenticator active',
  ),
  WalletSecurityChecklistItem(
    item: 'Email Verification',
    enabled: true,
    description: 'Verified on signup',
  ),
  WalletSecurityChecklistItem(
    item: 'Biometric Lock',
    enabled: true,
    description: 'Face ID enabled',
  ),
  WalletSecurityChecklistItem(
    item: 'Seed Phrase Backup',
    enabled: false,
    description: 'Not backed up securely',
  ),
  WalletSecurityChecklistItem(
    item: 'Anti-Phishing Code',
    enabled: true,
    description: 'Set: XK89',
  ),
  WalletSecurityChecklistItem(
    item: 'Withdrawal Whitelist',
    enabled: false,
    description: 'Not configured',
  ),
  WalletSecurityChecklistItem(
    item: 'Session Timeout',
    enabled: true,
    description: '15 minutes',
  ),
  WalletSecurityChecklistItem(
    item: 'Device Authorization',
    enabled: true,
    description: '2 devices registered',
  ),
];

const List<WalletPendingDeposit> _walletPendingDeposits = [
  WalletPendingDeposit(
    id: 'pd001',
    asset: 'USDT',
    amountLabel: '5,000.00',
    network: 'TRC20',
    txHash: '0xa1b2c3d4e5f6...789abc',
    confirmations: 1,
    requiredConfirmations: 1,
    status: 'credited',
    createdAt: '11/03/2026 14:32',
    estimatedArrival: '\u0110\u00E3 xong',
    fromAddress: 'TQnK...Xyz12',
  ),
  WalletPendingDeposit(
    id: 'pd002',
    asset: 'BTC',
    amountLabel: '0.050000',
    network: 'Bitcoin',
    txHash: 'bc1q...f8a2d3',
    confirmations: 1,
    requiredConfirmations: 2,
    status: 'confirming',
    createdAt: '11/03/2026 13:15',
    estimatedArrival: '~15 ph\u00FAt',
    fromAddress: 'bc1q...sW8k',
  ),
  WalletPendingDeposit(
    id: 'pd003',
    asset: 'ETH',
    amountLabel: '1.2000',
    network: 'ERC20',
    txHash: '0x7e8f9a0b1c2d...e3f456',
    confirmations: 5,
    requiredConfirmations: 12,
    status: 'confirming',
    createdAt: '11/03/2026 12:40',
    estimatedArrival: '~7 ph\u00FAt',
    fromAddress: '0x742d...C29f',
  ),
  WalletPendingDeposit(
    id: 'pd004',
    asset: 'USDT',
    amountLabel: '200.0000',
    network: 'ERC20',
    txHash: '0xdead...beef',
    confirmations: 0,
    requiredConfirmations: 12,
    status: 'failed',
    createdAt: '10/03/2026 09:00',
    estimatedArrival: 'Th\u1EA5t b\u1EA1i',
    fromAddress: '0x123...456',
  ),
];

const List<WalletKycTier> _walletKycTiers = [
  WalletKycTier(
    level: 0,
    name: 'Ch\u01B0a x\u00E1c minh',
    dailyLimit: 0,
    monthlyLimit: 0,
    singleTxLimit: 0,
    requirements: ['\u0110\u0103ng k\u00FD t\u00E0i kho\u1EA3n'],
    features: ['Xem gi\u00E1', 'Danh s\u00E1ch theo d\u00F5i'],
    colorHex: 0xFF94A3B8,
  ),
  WalletKycTier(
    level: 1,
    name: 'C\u01A1 b\u1EA3n',
    dailyLimit: 10000,
    monthlyLimit: 50000,
    singleTxLimit: 5000,
    requirements: ['Email x\u00E1c minh', 'S\u1ED1 \u0111i\u1EC7n tho\u1EA1i'],
    features: [
      'N\u1EA1p ti\u1EC1n',
      'Giao d\u1ECBch Spot',
      'R\u00FAt ti\u1EC1n c\u01A1 b\u1EA3n',
    ],
    colorHex: 0xFF3B82F6,
  ),
  WalletKycTier(
    level: 2,
    name: 'N\u00E2ng cao',
    dailyLimit: 100000,
    monthlyLimit: 500000,
    singleTxLimit: 50000,
    requirements: ['CMND/CCCD', 'Nh\u1EADn di\u1EC7n khu\u00F4n m\u1EB7t'],
    features: ['P2P Trading', 'R\u00FAt ti\u1EC1n n\u00E2ng cao', 'API Access'],
    colorHex: 0xFF10B981,
  ),
  WalletKycTier(
    level: 3,
    name: 'VIP',
    dailyLimit: 1000000,
    monthlyLimit: 5000000,
    singleTxLimit: 500000,
    requirements: [
      'KYC Level 2',
      'Volume > \$100K/th\u00E1ng',
      'Duy\u1EC7t VIP',
    ],
    features: [
      'H\u1EA1n m\u1EE9c VIP',
      'Ph\u00ED giao d\u1ECBch gi\u1EA3m',
      'H\u1ED7 tr\u1EE3 \u01B0u ti\u00EAn',
      'OTC Trading',
    ],
    colorHex: 0xFFF59E0B,
  ),
];

const List<WalletLimitFaq> _walletLimitFaqs = [
  WalletLimitFaq(
    question: 'H\u1EA1n m\u1EE9c reset khi n\u00E0o?',
    answer:
        'H\u1EA1n m\u1EE9c ng\u00E0y reset l\u00FAc 00:00 UTC. H\u1EA1n m\u1EE9c th\u00E1ng reset ng\u00E0y 1 h\u00E0ng th\u00E1ng.',
  ),
  WalletLimitFaq(
    question: 'R\u00FAt v\u01B0\u1EE3t h\u1EA1n m\u1EE9c th\u00EC sao?',
    answer:
        'Y\u00EAu c\u1EA7u r\u00FAt s\u1EBD b\u1ECB t\u1EEB ch\u1ED1i. B\u1EA1n c\u00F3 th\u1EC3 n\u00E2ng c\u1EA5p KYC ho\u1EB7c ch\u1EDD h\u1EA1n m\u1EE9c reset.',
  ),
  WalletLimitFaq(
    question: 'Ph\u00ED r\u00FAt c\u00F3 t\u00EDnh v\u00E0o h\u1EA1n m\u1EE9c?',
    answer:
        'Kh\u00F4ng. H\u1EA1n m\u1EE9c ch\u1EC9 t\u00EDnh s\u1ED1 ti\u1EC1n th\u1EF1c r\u00FAt, kh\u00F4ng bao g\u1ED3m ph\u00ED m\u1EA1ng.',
  ),
];

const List<WalletDustTarget> _walletDustTargets = [
  WalletDustTarget(symbol: 'USDT', name: 'Tether USD', colorHex: 0xFF26A17B),
  WalletDustTarget(symbol: 'BNB', name: 'BNB', colorHex: 0xFFF3BA2F),
];

const List<WalletDustAsset> _walletDustAssets = [
  WalletDustAsset(
    id: 'dot',
    symbol: 'DOT',
    name: 'Polkadot',
    availableLabel: '0.420000',
    usdValue: 3.15,
    colorHex: 0xFFE6007A,
  ),
  WalletDustAsset(
    id: 'avax',
    symbol: 'AVAX',
    name: 'Avalanche',
    availableLabel: '0.080000',
    usdValue: 2.88,
    colorHex: 0xFFE84142,
  ),
  WalletDustAsset(
    id: 'link',
    symbol: 'LINK',
    name: 'Chainlink',
    availableLabel: '0.150000',
    usdValue: 2.25,
    colorHex: 0xFF2A5ADA,
  ),
  WalletDustAsset(
    id: 'matic',
    symbol: 'MATIC',
    name: 'Polygon',
    availableLabel: '3.2000',
    usdValue: 1.92,
    colorHex: 0xFF8247E5,
  ),
  WalletDustAsset(
    id: 'atom',
    symbol: 'ATOM',
    name: 'Cosmos',
    availableLabel: '0.050000',
    usdValue: .45,
    colorHex: 0xFF2E3148,
  ),
  WalletDustAsset(
    id: 'doge',
    symbol: 'DOGE',
    name: 'Dogecoin',
    availableLabel: '12.0000',
    usdValue: 1.56,
    colorHex: 0xFFC2A633,
  ),
];

const List<WalletNetworkInfo> _walletNetworks = [
  WalletNetworkInfo(
    id: 'btc',
    name: 'Bitcoin',
    symbol: 'BTC',
    colorHex: 0xFFF7931A,
    health: 'operational',
    blockHeight: 886543,
    lastBlock: '2 ph\u00FAt tr\u01B0\u1EDBc',
    avgConfirmTime: '~30 ph\u00FAt',
    txPending: 4521,
    gasFee: '12 sat/vB',
    congestionPct: 25,
    depositEnabled: true,
    withdrawEnabled: true,
  ),
  WalletNetworkInfo(
    id: 'eth',
    name: 'Ethereum',
    symbol: 'ETH',
    colorHex: 0xFF627EEA,
    health: 'operational',
    blockHeight: 19847231,
    lastBlock: '12 gi\u00E2y tr\u01B0\u1EDBc',
    avgConfirmTime: '~5 ph\u00FAt',
    txPending: 142350,
    gasFee: '28 Gwei',
    congestionPct: 42,
    depositEnabled: true,
    withdrawEnabled: true,
  ),
  WalletNetworkInfo(
    id: 'trc20',
    name: 'TRON (TRC20)',
    symbol: 'TRX',
    colorHex: 0xFFFF0013,
    health: 'operational',
    blockHeight: 61234567,
    lastBlock: '3 gi\u00E2y tr\u01B0\u1EDBc',
    avgConfirmTime: '~3 ph\u00FAt',
    txPending: 8920,
    gasFee: '27 TRX',
    congestionPct: 15,
    depositEnabled: true,
    withdrawEnabled: true,
  ),
  WalletNetworkInfo(
    id: 'bsc',
    name: 'BNB Chain (BEP20)',
    symbol: 'BNB',
    colorHex: 0xFFF3BA2F,
    health: 'degraded',
    blockHeight: 38912456,
    lastBlock: '6 gi\u00E2y tr\u01B0\u1EDBc',
    avgConfirmTime: '~8 ph\u00FAt',
    txPending: 52100,
    gasFee: '5 Gwei',
    congestionPct: 65,
    depositEnabled: true,
    withdrawEnabled: true,
    notes:
        'X\u00E1c nh\u1EADn ch\u1EADm h\u01A1n b\u00ECnh th\u01B0\u1EDDng do l\u01B0u l\u01B0\u1EE3ng cao',
  ),
  WalletNetworkInfo(
    id: 'sol',
    name: 'Solana',
    symbol: 'SOL',
    colorHex: 0xFF9945FF,
    health: 'operational',
    blockHeight: 245678901,
    lastBlock: '400ms tr\u01B0\u1EDBc',
    avgConfirmTime: '~1 gi\u00E2y',
    txPending: 890,
    gasFee: '0.000005 SOL',
    congestionPct: 8,
    depositEnabled: true,
    withdrawEnabled: true,
  ),
  WalletNetworkInfo(
    id: 'xrp',
    name: 'Ripple',
    symbol: 'XRP',
    colorHex: 0xFF23292F,
    health: 'operational',
    blockHeight: 87654321,
    lastBlock: '4 gi\u00E2y tr\u01B0\u1EDBc',
    avgConfirmTime: '~5 gi\u00E2y',
    txPending: 245,
    gasFee: '0.00001 XRP',
    congestionPct: 3,
    depositEnabled: true,
    withdrawEnabled: true,
  ),
  WalletNetworkInfo(
    id: 'polygon',
    name: 'Polygon',
    symbol: 'MATIC',
    colorHex: 0xFF8247E5,
    health: 'down',
    blockHeight: 56789012,
    lastBlock: '3 gi\u1EDD tr\u01B0\u1EDBc',
    avgConfirmTime: 'N/A',
    txPending: 0,
    gasFee: 'N/A',
    congestionPct: 0,
    depositEnabled: false,
    withdrawEnabled: false,
    notes:
        '\u0110ang b\u1EA3o tr\u00EC h\u1EC7 th\u1ED1ng. D\u1EF1 ki\u1EBFn ho\u00E0n t\u1EA5t: 15:00 UTC',
  ),
];

const List<int> _walletBuyPresetAmounts = [
  100000,
  500000,
  1000000,
  5000000,
  10000000,
];

const Map<String, List<WalletDepositNetwork>> _walletDepositNetworks = {
  'USDT': [
    WalletDepositNetwork(
      id: 'trc20',
      name: 'TRC20 (TRON)',
      fee: 'Miễn phí',
      minDeposit: 1,
      address: 'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
      arrivalTime: '~3 phút',
      confirmations: 1,
    ),
    WalletDepositNetwork(
      id: 'erc20',
      name: 'ERC20 (Ethereum)',
      fee: 'Miễn phí',
      minDeposit: 10,
      address: '0x1a2b3c4d5e6f7890abcdef1234567890Abc456',
      arrivalTime: '~10 phút',
      confirmations: 12,
    ),
    WalletDepositNetwork(
      id: 'bep20',
      name: 'BEP20 (BSC)',
      fee: 'Miễn phí',
      minDeposit: 1,
      address: '0x9z8y7x6w5v4u3t2s1r0qponmlkjihgDef789',
      arrivalTime: '~5 phút',
      confirmations: 15,
    ),
  ],
  'BTC': [
    WalletDepositNetwork(
      id: 'btc',
      name: 'Bitcoin (BTC)',
      fee: 'Miễn phí',
      minDeposit: 0.0001,
      address: 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0sW8',
      arrivalTime: '~30 phút',
      confirmations: 2,
    ),
  ],
  'ETH': [
    WalletDepositNetwork(
      id: 'erc20',
      name: 'ERC20 (Ethereum)',
      fee: 'Miễn phí',
      minDeposit: 0.01,
      address: '0x2b3c4d5e6f7890abcdef1234567890abGhi012',
      arrivalTime: '~10 phút',
      confirmations: 12,
    ),
  ],
  'BNB': [
    WalletDepositNetwork(
      id: 'bep20',
      name: 'BEP20 (BSC)',
      fee: 'Miễn phí',
      minDeposit: 0.01,
      address: '0x7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f56',
      arrivalTime: '~5 phút',
      confirmations: 15,
    ),
    WalletDepositNetwork(
      id: 'bep2',
      name: 'BEP2 (Beacon Chain)',
      fee: 'Miễn phí',
      minDeposit: 0.01,
      address: 'bnb1grpf0955h0efa8603ukn5g8vlzx6awd3mfe7q2',
      arrivalTime: '~1 phút',
      confirmations: 1,
      memo: '104857923',
      memoLabel: 'Memo',
    ),
  ],
  'XRP': [
    WalletDepositNetwork(
      id: 'xrp',
      name: 'Ripple (XRP)',
      fee: 'Miễn phí',
      minDeposit: 1,
      address: 'rN7UqJdShKzAJx62h3bnKFWRcuSMmTGx9V',
      arrivalTime: '~5 giây',
      confirmations: 1,
      memo: '2847561',
      memoLabel: 'Destination Tag',
    ),
  ],
};

const Map<String, double> _walletWithdrawAvailable = {
  'USDT': 10200,
  'BTC': 0.21451,
  'ETH': 2.3,
  'SOL': 45.8,
  'BNB': 12.5,
};

const Map<String, List<WalletWithdrawNetwork>> _walletWithdrawNetworks = {
  'USDT': [
    WalletWithdrawNetwork(
      id: 'trc20',
      name: 'TRC20 (TRON)',
      fee: 1,
      minWithdraw: 5,
      maxWithdraw: 500000,
    ),
    WalletWithdrawNetwork(
      id: 'erc20',
      name: 'ERC20 (Ethereum)',
      fee: 15,
      minWithdraw: 20,
      maxWithdraw: 500000,
    ),
    WalletWithdrawNetwork(
      id: 'bep20',
      name: 'BEP20 (BSC)',
      fee: .5,
      minWithdraw: 5,
      maxWithdraw: 500000,
    ),
  ],
  'BTC': [
    WalletWithdrawNetwork(
      id: 'btc',
      name: 'Bitcoin (BTC)',
      fee: .0005,
      minWithdraw: .001,
      maxWithdraw: 10,
    ),
  ],
  'ETH': [
    WalletWithdrawNetwork(
      id: 'erc20',
      name: 'ERC20 (Ethereum)',
      fee: .003,
      minWithdraw: .01,
      maxWithdraw: 100,
    ),
  ],
  'BNB': [
    WalletWithdrawNetwork(
      id: 'bep20',
      name: 'BEP20 (BSC)',
      fee: .005,
      minWithdraw: .02,
      maxWithdraw: 1000,
    ),
    WalletWithdrawNetwork(
      id: 'bep2',
      name: 'BEP2 (Beacon Chain)',
      fee: .01,
      minWithdraw: .1,
      maxWithdraw: 1000,
      requiresMemo: true,
      memoLabel: 'Memo',
      memoPlaceholder: 'Nhập Memo (bắt buộc)',
    ),
  ],
};

const List<WalletRecentAddress> _walletRecentAddresses = [
  WalletRecentAddress(
    label: 'Ví lạnh cá nhân',
    address: 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh',
    network: 'BTC',
    lastUsed: '20/02',
  ),
  WalletRecentAddress(
    label: 'Binance Exchange',
    address: '0x742d35Cc6634C0532925a3b844Bc9e7595f6C29f',
    network: 'ETH (ERC20)',
    lastUsed: '18/02',
  ),
  WalletRecentAddress(
    label: 'Sàn OKX',
    address: 'TN3W4H6rK2ce4vX9YnFQHwKx8Vq9m6dxWc',
    network: 'TRC20',
    lastUsed: '10/02',
  ),
];

const List<WalletAction> _walletActions = [
  WalletAction(
    id: 'deposit',
    label: 'Nạp',
    route: '/wallet/deposit/USDT',
    colorHex: 0xFF10B981,
    iconKey: 'deposit',
  ),
  WalletAction(
    id: 'withdraw',
    label: 'Rút',
    route: '/wallet/withdraw/USDT',
    colorHex: 0xFFEF4444,
    iconKey: 'withdraw',
  ),
  WalletAction(
    id: 'buy',
    label: 'Mua',
    route: '/wallet/buy-crypto',
    colorHex: 0xFF3B82F6,
    iconKey: 'buy',
  ),
  WalletAction(
    id: 'transfer',
    label: 'Chuyển',
    route: '/wallet/transfer',
    colorHex: 0xFF8B5CF6,
    iconKey: 'transfer',
  ),
  WalletAction(
    id: 'history',
    label: 'Lịch sử',
    route: '/wallet/history',
    colorHex: 0xFF94A3B8,
    iconKey: 'history',
  ),
];

const WalletDcaSnapshot _walletDca = WalletDcaSnapshot(
  title: 'Mua định kỳ (DCA)',
  subtitle: 'Tự động mua crypto theo lịch trình',
  returnLabel: '+13536.3%',
  activePlans: 3,
  invested: 22200000,
  nextTrade: '47 giờ • 500.000',
);

const List<WalletTool> _walletTools = [
  WalletTool(
    id: 'pending',
    label: 'Nạp đang chờ',
    route: '/wallet/pending-deposits',
    colorHex: 0xFFF59E0B,
    iconKey: 'pending',
  ),
  WalletTool(
    id: 'limits',
    label: 'Hạn mức rút',
    route: '/wallet/limits',
    colorHex: 0xFF3B82F6,
    iconKey: 'limits',
  ),
  WalletTool(
    id: 'dust',
    label: 'Dọn dust',
    route: '/wallet/dust-converter',
    colorHex: 0xFF8B5CF6,
    iconKey: 'dust',
  ),
  WalletTool(
    id: 'network',
    label: 'Trạng thái mạng',
    route: '/wallet/network-status',
    colorHex: 0xFF10B981,
    iconKey: 'network',
  ),
];

const List<WalletAsset> _walletAssets = [
  WalletAsset(
    id: 'usdt',
    symbol: 'USDT',
    name: 'Tether USD',
    balance: 12450.80,
    usdValue: 12450.80,
    change24h: 0.01,
    colorHex: 0xFF26A17B,
  ),
  WalletAsset(
    id: 'btc',
    symbol: 'BTC',
    name: 'Bitcoin',
    balance: 0.234510,
    usdValue: 15842.10,
    change24h: 2.34,
    colorHex: 0xFFF7931A,
  ),
  WalletAsset(
    id: 'eth',
    symbol: 'ETH',
    name: 'Ethereum',
    balance: 3.5210,
    usdValue: 12395.45,
    change24h: -1.23,
    colorHex: 0xFF627EEA,
  ),
  WalletAsset(
    id: 'sol',
    symbol: 'SOL',
    name: 'Solana',
    balance: 45.8,
    usdValue: 8167.06,
    change24h: 8.07,
    colorHex: 0xFF9945FF,
  ),
  WalletAsset(
    id: 'bnb',
    symbol: 'BNB',
    name: 'BNB',
    balance: 12.5,
    usdValue: 5160.88,
    change24h: 3.61,
    colorHex: 0xFFF3BA2F,
  ),
  WalletAsset(
    id: 'ada',
    symbol: 'ADA',
    name: 'Cardano',
    balance: 5000,
    usdValue: 2260.50,
    change24h: 3.22,
    colorHex: 0xFF0033AD,
  ),
  WalletAsset(
    id: 'xrp',
    symbol: 'XRP',
    name: 'Ripple',
    balance: 2500,
    usdValue: 1375,
    change24h: 1.85,
    colorHex: 0xFF23292F,
  ),
  WalletAsset(
    id: 'dot',
    symbol: 'DOT',
    name: 'Polkadot',
    balance: 0.42,
    usdValue: 3.15,
    change24h: -0.85,
    colorHex: 0xFFE6007A,
  ),
  WalletAsset(
    id: 'avax',
    symbol: 'AVAX',
    name: 'Avalanche',
    balance: 0.08,
    usdValue: 2.88,
    change24h: 1.42,
    colorHex: 0xFFE84142,
  ),
  WalletAsset(
    id: 'link',
    symbol: 'LINK',
    name: 'Chainlink',
    balance: 0.15,
    usdValue: 2.25,
    change24h: -2.10,
    colorHex: 0xFF2A5ADA,
  ),
  WalletAsset(
    id: 'matic',
    symbol: 'MATIC',
    name: 'Polygon',
    balance: 3.2,
    usdValue: 1.92,
    change24h: 0.55,
    colorHex: 0xFF8247E5,
  ),
  WalletAsset(
    id: 'atom',
    symbol: 'ATOM',
    name: 'Cosmos',
    balance: 0.05,
    usdValue: 0.45,
    change24h: -1.30,
    colorHex: 0xFF2E3148,
  ),
  WalletAsset(
    id: 'doge',
    symbol: 'DOGE',
    name: 'Dogecoin',
    balance: 12,
    usdValue: 1.56,
    change24h: 3.80,
    colorHex: 0xFFC2A633,
  ),
];
