import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_errors.dart';
import 'package:vit_trade_flutter/features/wallet/domain/repositories/wallet_repository.dart';

final class FailClosedWalletRepository implements WalletRepository {
  const FailClosedWalletRepository();

  static const _endpoint = '/api/mobile/wallet/pending-contract';
  static const _states = [WalletScreenState.error, WalletScreenState.offline];
  static const _neutralColor = 0xFF64748B;
  static const _accentColor = 0xFF22D3EE;

  static String get unavailableMessage =>
      const WalletBackendContractMissingException().userMessage;

  @override
  WalletSnapshot getWallet() {
    return WalletSnapshot(
      totalUsd: 0,
      totalBtc: 0,
      availableUsd: 0,
      inOrderUsd: 0,
      frozenUsd: 0,
      actions: const [],
      dca: const WalletDcaSnapshot(
        title: 'Unavailable',
        subtitle: 'Backend contract required',
        returnLabel: 'Paused',
        activePlans: 0,
        invested: 0,
        nextTrade: 'Paused',
      ),
      tools: const [
        WalletTool(
          id: 'pending',
          label: 'Pending',
          route: '/wallet',
          colorHex: _neutralColor,
          iconKey: 'pending',
        ),
        WalletTool(
          id: 'limits',
          label: 'Limits',
          route: '/wallet',
          colorHex: _neutralColor,
          iconKey: 'limits',
        ),
        WalletTool(
          id: 'dust',
          label: 'Dust',
          route: '/wallet',
          colorHex: _neutralColor,
          iconKey: 'dust',
        ),
        WalletTool(
          id: 'network',
          label: 'Network',
          route: '/wallet',
          colorHex: _neutralColor,
          iconKey: 'network',
        ),
      ],
      assets: const [],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletTransactionHistorySnapshot getTransactionHistory() {
    return WalletTransactionHistorySnapshot(
      transactions: const [],
      filters: const [WalletTransactionFilter(id: 'all', label: 'All')],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletTransactionDetailSnapshot getTransactionDetail(String transactionId) {
    return WalletTransactionDetailSnapshot(
      transaction: null,
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletPortfolioAnalyticsSnapshot getPortfolioAnalytics() {
    return WalletPortfolioAnalyticsSnapshot(
      totalUsd: 0,
      totalReturnUsd: 0,
      totalReturnPct: 0,
      bestProfitUsd: 0,
      bestProfitAsset: 'N/A',
      worstLossUsd: 0,
      worstLossAsset: 'N/A',
      assets: const [],
      periods: const ['1D'],
      activePeriod: '1D',
      history: const [
        WalletPortfolioPoint(label: 'Start', value: 0),
        WalletPortfolioPoint(label: 'Now', value: 0),
      ],
      metrics: const [
        WalletPortfolioMetric(
          label: 'Backend status',
          value: 'Unavailable',
          colorHex: _neutralColor,
        ),
      ],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletAddressAddSnapshot getAddressAdd() {
    return WalletAddressAddSnapshot(
      networks: const [
        WalletAddressNetwork(
          id: 'unavailable',
          label: 'Backend contract required',
          colorHex: _neutralColor,
          addressHint: 'Address validation unavailable',
        ),
      ],
      assets: const ['USDT'],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
      auditTrailNote: unavailableMessage,
    );
  }

  @override
  WalletAddressBookSnapshot getAddressBook() {
    return WalletAddressBookSnapshot(
      addresses: const [],
      networkFilters: const ['All'],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletBuyCryptoSnapshot getBuyCrypto() {
    return WalletBuyCryptoSnapshot(
      cryptoOptions: const [
        WalletBuyCryptoOption(
          symbol: 'USDT',
          name: 'Unavailable',
          colorHex: _neutralColor,
          minBuyVnd: 0,
          priceVnd: 0,
        ),
      ],
      paymentMethods: const [
        WalletPaymentMethod(
          id: 'unavailable',
          name: 'Backend contract required',
          type: WalletPaymentMethodType.bank,
          logo: 'N/A',
          logoColorHex: _neutralColor,
          processingTime: 'Unavailable',
          feeVnd: 0,
          dailyLimitLabel: 'Unavailable',
        ),
      ],
      presetAmounts: const [],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletTransferSnapshot getTransfer() {
    return WalletTransferSnapshot(
      wallets: const [
        WalletTransferWallet(
          id: 'unavailable',
          name: 'Wallet unavailable',
          balanceUsd: 0,
          colorHex: _neutralColor,
          iconKey: 'wallet',
        ),
      ],
      assets: const [
        WalletTransferAsset(
          id: 'usdt',
          symbol: 'USDT',
          name: 'Unavailable',
          available: 0,
          usdRate: 0,
          colorHex: _neutralColor,
        ),
      ],
      recentTransfers: const [],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletAssetDetailSnapshot getAssetDetail(String assetId) {
    final symbol = assetId.trim().isEmpty ? 'ASSET' : assetId.toUpperCase();
    return WalletAssetDetailSnapshot(
      assetId: assetId,
      name: 'Backend contract required',
      symbol: symbol,
      colorHex: _neutralColor,
      balance: 0,
      usdValue: 0,
      change24h: 0,
      available: 0,
      inOrder: 0,
      frozen: 0,
      currentPrice: 0,
      actions: const [],
      chart: const [
        WalletAssetChartPoint(index: 0, price: 0),
        WalletAssetChartPoint(index: 1, price: 0),
      ],
      transactions: const [],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletMultiManagerSnapshot getMultiManager() {
    return WalletMultiManagerSnapshot(
      wallets: const [
        WalletManagerItem(
          id: 'unavailable',
          name: 'Wallet unavailable',
          address: '0x0000000000000000',
          type: 'Production backend',
          balanceUsd: 0,
          change24hPct: 0,
          lastActiveLabel: 'Unavailable',
          isDefault: true,
          isFavorite: false,
          groupId: 'default',
          assets: [],
          accentColorHex: _neutralColor,
          typeColorHex: _neutralColor,
          distributionColorHex: _neutralColor,
        ),
      ],
      groups: const [
        WalletManagerGroup(
          id: 'default',
          name: 'Unavailable',
          colorHex: _neutralColor,
          walletIds: ['unavailable'],
          totalValueUsd: 0,
        ),
      ],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletGasOptimizerSnapshot getGasOptimizer() {
    return WalletGasOptimizerSnapshot(
      levels: const [
        WalletGasLevel(
          speed: 'slow',
          label: 'Unavailable',
          gwei: 1,
          usd: 0,
          timeEstimate: 'N/A',
          recommended: false,
          colorHex: _neutralColor,
        ),
        WalletGasLevel(
          speed: 'standard',
          label: 'Backend required',
          gwei: 1,
          usd: 0,
          timeEstimate: 'N/A',
          recommended: true,
          colorHex: _accentColor,
        ),
        WalletGasLevel(
          speed: 'fast',
          label: 'Unavailable',
          gwei: 1,
          usd: 0,
          timeEstimate: 'N/A',
          recommended: false,
          colorHex: _neutralColor,
        ),
      ],
      history: const [
        WalletGasHistoryPoint(time: 'Start', slow: 1, standard: 1, fast: 1),
        WalletGasHistoryPoint(time: 'Now', slow: 1, standard: 1, fast: 1),
      ],
      networkActivity: const [
        WalletNetworkActivityPoint(hour: 'Now', txCount: 0),
      ],
      comparisons: const [],
      tips: const [
        WalletGasTip(
          id: 'backend-contract',
          title: 'Backend contract required',
          description: 'Gas recommendations are unavailable in production.',
          potentialSaving: 'N/A',
          difficulty: 'N/A',
          category: 'Production',
        ),
      ],
      historicalAverageGwei: 1,
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletTokenApprovalSnapshot getTokenApprovals() {
    return WalletTokenApprovalSnapshot(
      approvals: const [],
      revokedApprovals: const [],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletHealthScoreSnapshot getHealthScore() {
    return WalletHealthScoreSnapshot(
      metrics: const [
        WalletHealthMetric(
          category: 'Security',
          score: 0,
          maxScore: 100,
          status: 'Unavailable',
        ),
        WalletHealthMetric(
          category: 'Diversification',
          score: 0,
          maxScore: 100,
          status: 'Unavailable',
        ),
      ],
      diversification: const [
        WalletDiversificationSlice(
          name: 'Unavailable',
          value: 100,
          colorHex: _neutralColor,
        ),
      ],
      history: const [
        WalletHealthHistoryPoint(month: 'Start', score: 0),
        WalletHealthHistoryPoint(month: 'Now', score: 0),
      ],
      recommendations: const [
        WalletHealthRecommendation(
          id: 'backend-contract',
          title: 'Backend contract required',
          description: 'Wallet health cannot be calculated without live data.',
          impact: 'high',
          category: 'Production',
          actionLabel: 'Contact support',
        ),
      ],
      securityChecklist: const [
        WalletSecurityChecklistItem(
          item: 'Production backend',
          enabled: false,
          description: 'Wallet backend contract is not configured.',
        ),
      ],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletPendingDepositsSnapshot getPendingDeposits() {
    return WalletPendingDepositsSnapshot(
      deposits: const [],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletWithdrawLimitsSnapshot getWithdrawLimits() {
    return WalletWithdrawLimitsSnapshot(
      currentLevel: 0,
      usedToday: 0,
      usedMonth: 0,
      tiers: const [
        WalletKycTier(
          level: 0,
          name: 'Unavailable',
          dailyLimit: 0,
          monthlyLimit: 0,
          singleTxLimit: 0,
          requirements: ['Backend contract required'],
          features: ['Withdrawals disabled'],
          colorHex: _neutralColor,
        ),
      ],
      faqs: const [
        WalletLimitFaq(
          question: 'Why are limits unavailable?',
          answer: 'The production wallet backend contract is not configured.',
        ),
      ],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletDustConverterSnapshot getDustConverter() {
    return WalletDustConverterSnapshot(
      dustThresholdUsd: 0,
      conversionFeePct: 0,
      targets: const [
        WalletDustTarget(
          symbol: 'USDT',
          name: 'Unavailable',
          colorHex: _neutralColor,
        ),
      ],
      assets: const [],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletNetworkStatusSnapshot getNetworkStatus() {
    return WalletNetworkStatusSnapshot(
      networks: const [],
      refreshIntervalSeconds: 0,
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletDepositSnapshot getDeposit(String asset, {bool assetScoped = false}) {
    return WalletDepositSnapshot(
      asset: asset,
      networks: const [
        WalletDepositNetwork(
          id: 'unavailable',
          name: 'Backend contract required',
          fee: 'N/A',
          minDeposit: 0,
          address: 'Unavailable until backend contract is configured',
          arrivalTime: 'N/A',
          confirmations: 0,
        ),
      ],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  WalletWithdrawSnapshot getWithdraw(String asset, {bool assetScoped = false}) {
    return WalletWithdrawSnapshot(
      asset: asset,
      available: 0,
      networks: const [
        WalletWithdrawNetwork(
          id: 'unavailable',
          name: 'Backend contract required',
          fee: 0,
          minWithdraw: 1,
          maxWithdraw: 0,
        ),
      ],
      recentAddresses: const [],
      endpoint: _endpoint,
      actionDraft: unavailableMessage,
      supportedStates: _states,
    );
  }
}
