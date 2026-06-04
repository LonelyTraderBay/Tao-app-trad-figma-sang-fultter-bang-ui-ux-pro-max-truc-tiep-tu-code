part of '../repositories/mock_wallet_repository.dart';

mixin _MockWalletRepositoryMethodsPart01 on _MockWalletRepositoryBase {
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
      highRiskContractId: HighRiskFlowContractIds.walletMoneyMovement,
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
      highRiskContractId: HighRiskFlowContractIds.walletMoneyMovement,
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
