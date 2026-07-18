part of 'wallet_entities.dart';

/// Data for the withdraw limits screen: KYC [tiers], today/month usage,
/// and FAQs, with derived remaining/percent-used helpers.
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
    this.highRiskContractId,
  });

  final int currentLevel;
  final double usedToday;
  final double usedMonth;
  final List<WalletKycTier> tiers;
  final List<WalletLimitFaq> faqs;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
  final String? highRiskContractId;

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

/// One KYC verification tier (limits, requirements, unlocked features) on
/// the withdraw limits screen.
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

/// One question/answer FAQ entry on the withdraw limits screen.
final class WalletLimitFaq {
  const WalletLimitFaq({required this.question, required this.answer});

  final String question;
  final String answer;
}

/// Data for the dust converter screen: convertible small-balance [assets],
/// selectable convert [targets], and the fee/threshold config.
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

/// One selectable conversion-target asset on the dust converter screen.
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

/// One small-balance ("dust") asset eligible for conversion.
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

/// Data for the network status screen: per-network health info with
/// derived operational/degraded/congested/down counts.
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

/// One blockchain network's live status (health, congestion, deposit/
/// withdraw availability) on the network status screen.
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

/// One selectable transaction-type filter on the transaction history
/// screen.
final class WalletTransactionFilter {
  const WalletTransactionFilter({required this.id, required this.label});

  final String id;
  final String label;
}

/// Category of a [WalletTransaction].
enum WalletTransactionType {
  deposit,
  withdraw,
  tradeBuy,
  tradeSell,
  p2pBuy,
  p2pSell,
}

/// Settlement status of a [WalletTransaction].
enum WalletTransactionStatus { completed, pending, failed }

/// One wallet transaction (deposit/withdraw/trade/P2P) shown in history and
/// detail screens.
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

/// Data for the deposit screen: the target [asset] and its selectable
/// [networks].
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

/// One selectable deposit network (address, fee, arrival time, optional
/// memo requirement) on the deposit screen.
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

/// Data for the withdraw screen: the target [asset], available balance,
/// selectable [networks], and recently used addresses.
final class WalletWithdrawSnapshot {
  const WalletWithdrawSnapshot({
    required this.asset,
    required this.available,
    required this.networks,
    required this.recentAddresses,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    this.highRiskContractId,
  });

  final String asset;
  final double available;
  final List<WalletWithdrawNetwork> networks;
  final List<WalletRecentAddress> recentAddresses;
  final String endpoint;
  final String actionDraft;
  final List<WalletScreenState> supportedStates;
  final String? highRiskContractId;
}

/// One selectable withdraw network (fee, min/max, optional memo
/// requirement) on the withdraw screen.
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

/// One recently used withdrawal address shown as a quick-pick on the
/// withdraw screen.
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
