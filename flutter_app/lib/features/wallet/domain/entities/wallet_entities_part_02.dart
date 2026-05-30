part of 'wallet_entities.dart';

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
