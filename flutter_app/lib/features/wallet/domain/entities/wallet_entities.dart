enum WalletScreenState {
  loading,
  empty,
  error,
  offline,
  realtimeRefresh,
  submitting,
  success,
}

final class WalletSnapshot {
  const WalletSnapshot({
    required this.totalUsd,
    required this.totalBtc,
    required this.availableUsd,
    required this.inOrderUsd,
    required this.frozenUsd,
    required this.actions,
    required this.dca,
    required this.tools,
    required this.assets,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double totalUsd;
  final double totalBtc;
  final double availableUsd;
  final double inOrderUsd;
  final double frozenUsd;
  final List<WalletAction> actions;
  final WalletDcaSnapshot dca;
  final List<WalletTool> tools;
  final List<WalletAsset> assets;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletAction {
  const WalletAction({
    required this.id,
    required this.label,
    required this.route,
    required this.colorHex,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final int colorHex;
  final String iconKey;
}

final class WalletDcaSnapshot {
  const WalletDcaSnapshot({
    required this.title,
    required this.subtitle,
    required this.returnLabel,
    required this.activePlans,
    required this.invested,
    required this.nextTrade,
  });

  final String title;
  final String subtitle;
  final String returnLabel;
  final int activePlans;
  final double invested;
  final String nextTrade;
}

final class WalletTool {
  const WalletTool({
    required this.id,
    required this.label,
    required this.route,
    required this.colorHex,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final int colorHex;
  final String iconKey;
}

final class WalletAsset {
  const WalletAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.balance,
    required this.usdValue,
    required this.change24h,
    required this.colorHex,
  });

  final String id;
  final String symbol;
  final String name;
  final double balance;
  final double usdValue;
  final double change24h;
  final int colorHex;
}

final class WalletTransactionHistorySnapshot {
  const WalletTransactionHistorySnapshot({
    required this.transactions,
    required this.filters,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletTransaction> transactions;
  final List<WalletTransactionFilter> filters;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletTransactionDetailSnapshot {
  const WalletTransactionDetailSnapshot({
    required this.transaction,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final WalletTransaction? transaction;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletPortfolioAnalyticsSnapshot {
  const WalletPortfolioAnalyticsSnapshot({
    required this.totalUsd,
    required this.totalReturnUsd,
    required this.totalReturnPct,
    required this.bestProfitUsd,
    required this.bestProfitAsset,
    required this.worstLossUsd,
    required this.worstLossAsset,
    required this.assets,
    required this.periods,
    required this.activePeriod,
    required this.history,
    required this.metrics,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double totalUsd;
  final double totalReturnUsd;
  final double totalReturnPct;
  final double bestProfitUsd;
  final String bestProfitAsset;
  final double worstLossUsd;
  final String worstLossAsset;
  final List<WalletAsset> assets;
  final List<String> periods;
  final String activePeriod;
  final List<WalletPortfolioPoint> history;
  final List<WalletPortfolioMetric> metrics;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletPortfolioPoint {
  const WalletPortfolioPoint({required this.label, required this.value});

  final String label;
  final double value;
}

final class WalletPortfolioMetric {
  const WalletPortfolioMetric({
    required this.label,
    required this.value,
    required this.colorHex,
  });

  final String label;
  final String value;
  final int colorHex;
}

final class WalletAddressAddSnapshot {
  const WalletAddressAddSnapshot({
    required this.networks,
    required this.assets,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.auditTrailNote,
  });

  final List<WalletAddressNetwork> networks;
  final List<String> assets;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
  final String auditTrailNote;
}

final class WalletAddressNetwork {
  const WalletAddressNetwork({
    required this.id,
    required this.label,
    required this.colorHex,
    required this.addressHint,
  });

  final String id;
  final String label;
  final int colorHex;
  final String addressHint;
}

final class WalletAddressBookSnapshot {
  const WalletAddressBookSnapshot({
    required this.addresses,
    required this.networkFilters,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletSavedAddress> addresses;
  final List<String> networkFilters;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletSavedAddress {
  const WalletSavedAddress({
    required this.id,
    required this.label,
    required this.address,
    required this.network,
    required this.asset,
    required this.isFavorite,
    required this.createdAt,
    required this.isWhitelisted,
    this.lastUsed,
  });

  final String id;
  final String label;
  final String address;
  final String network;
  final String asset;
  final bool isFavorite;
  final String createdAt;
  final bool isWhitelisted;
  final String? lastUsed;

  WalletSavedAddress copyWith({bool? isFavorite, bool? isWhitelisted}) {
    return WalletSavedAddress(
      id: id,
      label: label,
      address: address,
      network: network,
      asset: asset,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
      isWhitelisted: isWhitelisted ?? this.isWhitelisted,
      lastUsed: lastUsed,
    );
  }
}

final class WalletBuyCryptoSnapshot {
  const WalletBuyCryptoSnapshot({
    required this.cryptoOptions,
    required this.paymentMethods,
    required this.presetAmounts,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletBuyCryptoOption> cryptoOptions;
  final List<WalletPaymentMethod> paymentMethods;
  final List<int> presetAmounts;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletBuyCryptoOption {
  const WalletBuyCryptoOption({
    required this.symbol,
    required this.name,
    required this.colorHex,
    required this.minBuyVnd,
    required this.priceVnd,
  });

  final String symbol;
  final String name;
  final int colorHex;
  final int minBuyVnd;
  final int priceVnd;
}

enum WalletPaymentMethodType { bank, ewallet, qr }

final class WalletPaymentMethod {
  const WalletPaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    required this.logo,
    required this.logoColorHex,
    required this.processingTime,
    required this.feeVnd,
    required this.dailyLimitLabel,
    this.isPopular = false,
  });

  final String id;
  final String name;
  final WalletPaymentMethodType type;
  final String logo;
  final int logoColorHex;
  final String processingTime;
  final int feeVnd;
  final String dailyLimitLabel;
  final bool isPopular;
}

final class WalletTransferSnapshot {
  const WalletTransferSnapshot({
    required this.wallets,
    required this.assets,
    required this.recentTransfers,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletTransferWallet> wallets;
  final List<WalletTransferAsset> assets;
  final List<WalletRecentTransfer> recentTransfers;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletTransferWallet {
  const WalletTransferWallet({
    required this.id,
    required this.name,
    required this.balanceUsd,
    required this.colorHex,
    required this.iconKey,
  });

  final String id;
  final String name;
  final double balanceUsd;
  final int colorHex;
  final String iconKey;
}

final class WalletTransferAsset {
  const WalletTransferAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.available,
    required this.usdRate,
    required this.colorHex,
  });

  final String id;
  final String symbol;
  final String name;
  final double available;
  final double usdRate;
  final int colorHex;
}

final class WalletRecentTransfer {
  const WalletRecentTransfer({
    required this.fromWallet,
    required this.toWallet,
    required this.asset,
    required this.amount,
    required this.time,
  });

  final String fromWallet;
  final String toWallet;
  final String asset;
  final double amount;
  final String time;
}

final class WalletAssetDetailSnapshot {
  const WalletAssetDetailSnapshot({
    required this.assetId,
    required this.name,
    required this.symbol,
    required this.colorHex,
    required this.balance,
    required this.usdValue,
    required this.change24h,
    required this.available,
    required this.inOrder,
    required this.frozen,
    required this.currentPrice,
    required this.actions,
    required this.chart,
    required this.transactions,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String assetId;
  final String name;
  final String symbol;
  final int colorHex;
  final double balance;
  final double usdValue;
  final double change24h;
  final double available;
  final double inOrder;
  final double frozen;
  final double currentPrice;
  final List<WalletAssetDetailAction> actions;
  final List<WalletAssetChartPoint> chart;
  final List<WalletAssetDetailTransaction> transactions;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletAssetDetailAction {
  const WalletAssetDetailAction({
    required this.id,
    required this.label,
    required this.route,
    required this.colorHex,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final int colorHex;
  final String iconKey;
}

final class WalletAssetChartPoint {
  const WalletAssetChartPoint({required this.index, required this.price});

  final int index;
  final double price;
}

final class WalletAssetDetailTransaction {
  const WalletAssetDetailTransaction({
    required this.id,
    required this.label,
    required this.amount,
    required this.asset,
    required this.createdAt,
    required this.status,
    required this.isIncoming,
    required this.route,
  });

  final String id;
  final String label;
  final double amount;
  final String asset;
  final String createdAt;
  final String status;
  final bool isIncoming;
  final String route;
}

final class WalletMultiManagerSnapshot {
  const WalletMultiManagerSnapshot({
    required this.wallets,
    required this.groups,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletManagerItem> wallets;
  final List<WalletManagerGroup> groups;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;

  double get totalBalance =>
      wallets.fold<double>(0, (sum, wallet) => sum + wallet.balanceUsd);

  double get totalChangeUsd => wallets.fold<double>(
    0,
    (sum, wallet) => sum + (wallet.balanceUsd * wallet.change24hPct / 100),
  );

  double get totalChangePct =>
      totalBalance == 0 ? 0 : (totalChangeUsd / totalBalance) * 100;
}

final class WalletManagerItem {
  const WalletManagerItem({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.balanceUsd,
    required this.change24hPct,
    required this.lastActiveLabel,
    required this.isDefault,
    required this.isFavorite,
    required this.groupId,
    required this.assets,
    required this.accentColorHex,
    required this.typeColorHex,
    required this.distributionColorHex,
  });

  final String id;
  final String name;
  final String address;
  final String type;
  final double balanceUsd;
  final double change24hPct;
  final String lastActiveLabel;
  final bool isDefault;
  final bool isFavorite;
  final String groupId;
  final List<WalletManagerAsset> assets;
  final int accentColorHex;
  final int typeColorHex;
  final int distributionColorHex;

  String get maskedAddress =>
      '${address.substring(0, 6)}...'
      '${address.substring(address.length - 4)}';
}

final class WalletManagerAsset {
  const WalletManagerAsset({
    required this.symbol,
    required this.balance,
    required this.valueUsd,
  });

  final String symbol;
  final double balance;
  final double valueUsd;
}

final class WalletManagerGroup {
  const WalletManagerGroup({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.walletIds,
    required this.totalValueUsd,
  });

  final String id;
  final String name;
  final int colorHex;
  final List<String> walletIds;
  final double totalValueUsd;
}

final class WalletGasOptimizerSnapshot {
  const WalletGasOptimizerSnapshot({
    required this.levels,
    required this.history,
    required this.networkActivity,
    required this.comparisons,
    required this.tips,
    required this.historicalAverageGwei,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletGasLevel> levels;
  final List<WalletGasHistoryPoint> history;
  final List<WalletNetworkActivityPoint> networkActivity;
  final List<WalletGasComparison> comparisons;
  final List<WalletGasTip> tips;
  final int historicalAverageGwei;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;

  WalletGasLevel get recommendedLevel =>
      levels.firstWhere((level) => level.recommended, orElse: () => levels[1]);

  double get vsAveragePct =>
      ((recommendedLevel.gwei - historicalAverageGwei) /
          historicalAverageGwei) *
      100;
}

final class WalletGasLevel {
  const WalletGasLevel({
    required this.speed,
    required this.label,
    required this.gwei,
    required this.usd,
    required this.timeEstimate,
    required this.recommended,
    required this.colorHex,
  });

  final String speed;
  final String label;
  final int gwei;
  final double usd;
  final String timeEstimate;
  final bool recommended;
  final int colorHex;
}

final class WalletGasComparison {
  const WalletGasComparison({
    required this.type,
    required this.gas,
    required this.usd,
  });

  final String type;
  final int gas;
  final double usd;
}

final class WalletGasHistoryPoint {
  const WalletGasHistoryPoint({
    required this.time,
    required this.slow,
    required this.standard,
    required this.fast,
  });

  final String time;
  final int slow;
  final int standard;
  final int fast;
}

final class WalletNetworkActivityPoint {
  const WalletNetworkActivityPoint({required this.hour, required this.txCount});

  final String hour;
  final int txCount;
}

final class WalletGasTip {
  const WalletGasTip({
    required this.id,
    required this.title,
    required this.description,
    required this.potentialSaving,
    required this.difficulty,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final String potentialSaving;
  final String difficulty;
  final String category;
}

final class WalletTokenApprovalSnapshot {
  const WalletTokenApprovalSnapshot({
    required this.approvals,
    required this.revokedApprovals,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletTokenApproval> approvals;
  final List<WalletRevokedApproval> revokedApprovals;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;

  int get criticalCount =>
      approvals.where((approval) => approval.riskLevel == 'critical').length;

  int get highRiskCount =>
      approvals.where((approval) => approval.riskLevel == 'high').length;

  int get unlimitedCount =>
      approvals.where((approval) => approval.amountLabel == 'Unlimited').length;

  int get unusedCount =>
      approvals.where((approval) => approval.usageCount == 0).length;

  List<WalletTokenApproval> get riskSortedApprovals {
    final sorted = List<WalletTokenApproval>.of(approvals);
    sorted.sort(
      (a, b) => _walletApprovalRiskRank(
        a.riskLevel,
      ).compareTo(_walletApprovalRiskRank(b.riskLevel)),
    );
    return sorted;
  }
}

final class WalletTokenApproval {
  const WalletTokenApproval({
    required this.id,
    required this.token,
    required this.tokenAddress,
    required this.spender,
    required this.spenderName,
    required this.amountLabel,
    required this.approvedAtLabel,
    required this.lastUsedLabel,
    required this.usageCount,
    required this.riskLevel,
    required this.verified,
    required this.category,
  });

  final String id;
  final String token;
  final String tokenAddress;
  final String spender;
  final String spenderName;
  final String amountLabel;
  final String approvedAtLabel;
  final String lastUsedLabel;
  final int usageCount;
  final String riskLevel;
  final bool verified;
  final String category;

  bool get unlimited => amountLabel == 'Unlimited';

  String get maskedSpender =>
      '${spender.substring(0, 6)}...'
      '${spender.substring(spender.length - 4)}';
}

final class WalletRevokedApproval {
  const WalletRevokedApproval({
    required this.id,
    required this.token,
    required this.spenderName,
    required this.revokedAtLabel,
    required this.reason,
  });

  final String id;
  final String token;
  final String spenderName;
  final String revokedAtLabel;
  final String reason;
}

final class WalletHealthScoreSnapshot {
  const WalletHealthScoreSnapshot({
    required this.metrics,
    required this.diversification,
    required this.history,
    required this.recommendations,
    required this.securityChecklist,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletHealthMetric> metrics;
  final List<WalletDiversificationSlice> diversification;
  final List<WalletHealthHistoryPoint> history;
  final List<WalletHealthRecommendation> recommendations;
  final List<WalletSecurityChecklistItem> securityChecklist;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;

  int get overallScore =>
      (metrics.fold<int>(0, (sum, metric) => sum + metric.score) /
              metrics.length)
          .round();

  String get overallStatus {
    if (overallScore >= 80) return 'Excellent';
    if (overallScore >= 60) return 'Good';
    if (overallScore >= 40) return 'Needs Improvement';
    return 'Critical';
  }

  String get overallMessage {
    if (overallScore >= 80) return 'well-secured and diversified';
    if (overallScore >= 60) return 'in good shape with room for improvement';
    return 'at risk - take action now';
  }

  List<WalletHealthRecommendation> get priorityRecommendations =>
      recommendations
          .where((recommendation) => recommendation.impact == 'high')
          .take(3)
          .toList(growable: false);

  WalletHealthMetric metricByCategory(String category) =>
      metrics.firstWhere((metric) => metric.category == category);
}

final class WalletHealthMetric {
  const WalletHealthMetric({
    required this.category,
    required this.score,
    required this.maxScore,
    required this.status,
  });

  final String category;
  final int score;
  final int maxScore;
  final String status;
}

final class WalletDiversificationSlice {
  const WalletDiversificationSlice({
    required this.name,
    required this.value,
    required this.colorHex,
  });

  final String name;
  final int value;
  final int colorHex;
}

final class WalletHealthHistoryPoint {
  const WalletHealthHistoryPoint({required this.month, required this.score});

  final String month;
  final int score;
}

final class WalletHealthRecommendation {
  const WalletHealthRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.impact,
    required this.category,
    required this.actionLabel,
  });

  final String id;
  final String title;
  final String description;
  final String impact;
  final String category;
  final String actionLabel;
}

final class WalletSecurityChecklistItem {
  const WalletSecurityChecklistItem({
    required this.item,
    required this.enabled,
    required this.description,
  });

  final String item;
  final bool enabled;
  final String description;
}

final class WalletPendingDepositsSnapshot {
  const WalletPendingDepositsSnapshot({
    required this.deposits,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletPendingDeposit> deposits;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;

  int get pendingCount => deposits
      .where(
        (deposit) =>
            deposit.status == 'confirming' || deposit.status == 'processing',
      )
      .length;
}

final class WalletPendingDeposit {
  const WalletPendingDeposit({
    required this.id,
    required this.asset,
    required this.amountLabel,
    required this.network,
    required this.txHash,
    required this.confirmations,
    required this.requiredConfirmations,
    required this.status,
    required this.createdAt,
    required this.estimatedArrival,
    required this.fromAddress,
  });

  final String id;
  final String asset;
  final String amountLabel;
  final String network;
  final String txHash;
  final int confirmations;
  final int requiredConfirmations;
  final String status;
  final String createdAt;
  final String estimatedArrival;
  final String fromAddress;

  double get progress => requiredConfirmations == 0
      ? 0
      : (confirmations / requiredConfirmations).clamp(0, 1).toDouble();
}

final class WalletWithdrawLimitsSnapshot {
  const WalletWithdrawLimitsSnapshot({
    required this.currentLevel,
    required this.usedToday,
    required this.usedMonth,
    required this.tiers,
    required this.faqs,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int currentLevel;
  final double usedToday;
  final double usedMonth;
  final List<WalletKycTier> tiers;
  final List<WalletLimitFaq> faqs;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;

  WalletKycTier get currentTier =>
      tiers.firstWhere((tier) => tier.level == currentLevel);

  double get dailyRemaining => currentTier.dailyLimit - usedToday;

  double get monthlyRemaining => currentTier.monthlyLimit - usedMonth;

  double get dailyPercent => currentTier.dailyLimit == 0
      ? 0
      : (usedToday / currentTier.dailyLimit) * 100;

  double get monthlyPercent => currentTier.monthlyLimit == 0
      ? 0
      : (usedMonth / currentTier.monthlyLimit) * 100;
}

final class WalletKycTier {
  const WalletKycTier({
    required this.level,
    required this.name,
    required this.dailyLimit,
    required this.monthlyLimit,
    required this.singleTxLimit,
    required this.requirements,
    required this.features,
    required this.colorHex,
  });

  final int level;
  final String name;
  final double dailyLimit;
  final double monthlyLimit;
  final double singleTxLimit;
  final List<String> requirements;
  final List<String> features;
  final int colorHex;
}

final class WalletLimitFaq {
  const WalletLimitFaq({required this.question, required this.answer});

  final String question;
  final String answer;
}

final class WalletDustConverterSnapshot {
  const WalletDustConverterSnapshot({
    required this.dustThresholdUsd,
    required this.conversionFeePct,
    required this.targets,
    required this.assets,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double dustThresholdUsd;
  final double conversionFeePct;
  final List<WalletDustTarget> targets;
  final List<WalletDustAsset> assets;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;

  List<WalletDustAsset> eligibleAssets(String targetSymbol) => assets
      .where((asset) => asset.usdValue > 0 && asset.symbol != targetSymbol)
      .toList(growable: false);
}

final class WalletDustTarget {
  const WalletDustTarget({
    required this.symbol,
    required this.name,
    required this.colorHex,
  });

  final String symbol;
  final String name;
  final int colorHex;
}

final class WalletDustAsset {
  const WalletDustAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.availableLabel,
    required this.usdValue,
    required this.colorHex,
  });

  final String id;
  final String symbol;
  final String name;
  final String availableLabel;
  final double usdValue;
  final int colorHex;
}

final class WalletNetworkStatusSnapshot {
  const WalletNetworkStatusSnapshot({
    required this.networks,
    required this.refreshIntervalSeconds,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<WalletNetworkInfo> networks;
  final int refreshIntervalSeconds;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;

  int get operationalCount =>
      networks.where((network) => network.health == 'operational').length;

  int get degradedCount =>
      networks.where((network) => network.health == 'degraded').length;

  int get congestedCount =>
      networks.where((network) => network.health == 'congested').length;

  int get issueCount => degradedCount + congestedCount;

  int get downCount =>
      networks.where((network) => network.health == 'down').length;
}

final class WalletNetworkInfo {
  const WalletNetworkInfo({
    required this.id,
    required this.name,
    required this.symbol,
    required this.colorHex,
    required this.health,
    required this.blockHeight,
    required this.lastBlock,
    required this.avgConfirmTime,
    required this.txPending,
    required this.gasFee,
    required this.congestionPct,
    required this.depositEnabled,
    required this.withdrawEnabled,
    this.notes,
  });

  final String id;
  final String name;
  final String symbol;
  final int colorHex;
  final String health;
  final int blockHeight;
  final String lastBlock;
  final String avgConfirmTime;
  final int txPending;
  final String gasFee;
  final int congestionPct;
  final bool depositEnabled;
  final bool withdrawEnabled;
  final String? notes;
}

final class WalletTransactionFilter {
  const WalletTransactionFilter({required this.id, required this.label});

  final String id;
  final String label;
}

enum WalletTransactionType {
  deposit,
  withdraw,
  tradeBuy,
  tradeSell,
  p2pBuy,
  p2pSell,
}

enum WalletTransactionStatus { completed, pending, failed }

final class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.type,
    required this.asset,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.txHash,
    this.address,
    this.network,
    this.fee,
  });

  final String id;
  final WalletTransactionType type;
  final String asset;
  final double amount;
  final WalletTransactionStatus status;
  final String createdAt;
  final String? txHash;
  final String? address;
  final String? network;
  final double? fee;
}

final class WalletDepositSnapshot {
  const WalletDepositSnapshot({
    required this.asset,
    required this.networks,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String asset;
  final List<WalletDepositNetwork> networks;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletDepositNetwork {
  const WalletDepositNetwork({
    required this.id,
    required this.name,
    required this.fee,
    required this.minDeposit,
    required this.address,
    required this.arrivalTime,
    required this.confirmations,
    this.memo,
    this.memoLabel,
  });

  final String id;
  final String name;
  final String fee;
  final double minDeposit;
  final String address;
  final String arrivalTime;
  final int confirmations;
  final String? memo;
  final String? memoLabel;
}

final class WalletWithdrawSnapshot {
  const WalletWithdrawSnapshot({
    required this.asset,
    required this.available,
    required this.networks,
    required this.recentAddresses,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String asset;
  final double available;
  final List<WalletWithdrawNetwork> networks;
  final List<WalletRecentAddress> recentAddresses;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
}

final class WalletWithdrawNetwork {
  const WalletWithdrawNetwork({
    required this.id,
    required this.name,
    required this.fee,
    required this.minWithdraw,
    required this.maxWithdraw,
    this.requiresMemo = false,
    this.memoLabel,
    this.memoPlaceholder,
  });

  final String id;
  final String name;
  final double fee;
  final double minWithdraw;
  final double maxWithdraw;
  final bool requiresMemo;
  final String? memoLabel;
  final String? memoPlaceholder;
}

final class WalletRecentAddress {
  const WalletRecentAddress({
    required this.label,
    required this.address,
    required this.network,
    required this.lastUsed,
  });

  final String label;
  final String address;
  final String network;
  final String lastUsed;
}

int _walletApprovalRiskRank(String riskLevel) {
  return switch (riskLevel) {
    'critical' => 0,
    'high' => 1,
    'medium' => 2,
    'low' => 3,
    _ => 4,
  };
}
