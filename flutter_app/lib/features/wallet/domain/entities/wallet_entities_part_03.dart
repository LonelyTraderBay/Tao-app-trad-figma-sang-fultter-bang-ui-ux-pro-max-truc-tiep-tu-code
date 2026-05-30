part of 'wallet_entities.dart';

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
