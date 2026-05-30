part of 'launchpad_entities.dart';

final class LaunchpadMultisigSnapshot {
  const LaunchpadMultisigSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.safes,
    required this.transactions,
    required this.defaultSafeAddress,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<String> tabs;
  final List<LaunchpadMultisigSafeDraft> safes;
  final List<LaunchpadMultisigTxDraft> transactions;
  final String defaultSafeAddress;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

enum LaunchpadMultisigTxStatus {
  draft,
  pendingSignatures,
  ready,
  executing,
  executed,
  expired,
  cancelled,
}

enum LaunchpadMultisigSignerRole { owner, signer, observer }

final class LaunchpadMultisigSignerDraft {
  const LaunchpadMultisigSignerDraft({
    required this.address,
    required this.label,
    required this.signed,
    required this.role,
    this.signedAt,
  });

  final String address;
  final String label;
  final bool signed;
  final LaunchpadMultisigSignerRole role;
  final String? signedAt;

  LaunchpadMultisigSignerDraft copyWith({bool? signed, String? signedAt}) {
    return LaunchpadMultisigSignerDraft(
      address: address,
      label: label,
      signed: signed ?? this.signed,
      role: role,
      signedAt: signedAt ?? this.signedAt,
    );
  }
}

final class LaunchpadMultisigSafeDraft {
  const LaunchpadMultisigSafeDraft({
    required this.address,
    required this.label,
    required this.chain,
    required this.accent,
    required this.threshold,
    required this.owners,
    required this.balance,
    required this.txCount,
    required this.pendingCount,
  });

  final String address;
  final String label;
  final String chain;
  final Color accent;
  final int threshold;
  final List<LaunchpadMultisigSignerDraft> owners;
  final String balance;
  final int txCount;
  final int pendingCount;
}

final class LaunchpadMultisigTxDraft {
  const LaunchpadMultisigTxDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.contractAddress,
    required this.chain,
    required this.accent,
    required this.functionName,
    required this.params,
    required this.value,
    required this.estimatedGas,
    required this.status,
    required this.threshold,
    required this.signers,
    required this.signedCount,
    required this.createdAt,
    required this.expiresAt,
    required this.nonce,
    required this.safeAddress,
    this.executedAt,
    this.executeTxHash,
  });

  final String id;
  final String label;
  final String description;
  final String contractAddress;
  final String chain;
  final Color accent;
  final String functionName;
  final Map<String, String> params;
  final String value;
  final String estimatedGas;
  final LaunchpadMultisigTxStatus status;
  final int threshold;
  final List<LaunchpadMultisigSignerDraft> signers;
  final int signedCount;
  final String createdAt;
  final String expiresAt;
  final String? executedAt;
  final String? executeTxHash;
  final int nonce;
  final String safeAddress;

  LaunchpadMultisigTxDraft copyWith({
    LaunchpadMultisigTxStatus? status,
    List<LaunchpadMultisigSignerDraft>? signers,
    int? signedCount,
    String? executedAt,
    String? executeTxHash,
  }) {
    return LaunchpadMultisigTxDraft(
      id: id,
      label: label,
      description: description,
      contractAddress: contractAddress,
      chain: chain,
      accent: accent,
      functionName: functionName,
      params: params,
      value: value,
      estimatedGas: estimatedGas,
      status: status ?? this.status,
      threshold: threshold,
      signers: signers ?? this.signers,
      signedCount: signedCount ?? this.signedCount,
      createdAt: createdAt,
      expiresAt: expiresAt,
      executedAt: executedAt ?? this.executedAt,
      executeTxHash: executeTxHash ?? this.executeTxHash,
      nonce: nonce,
      safeAddress: safeAddress,
    );
  }
}

final class LaunchpadSwapAggregatorSnapshot {
  const LaunchpadSwapAggregatorSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.fromToken,
    required this.toToken,
    required this.amount,
    required this.slippageTolerance,
    required this.autoRefresh,
    required this.dexQuotes,
    required this.history,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<String> tabs;
  final String fromToken;
  final String toToken;
  final String amount;
  final double slippageTolerance;
  final bool autoRefresh;
  final List<LaunchpadSwapDexQuoteDraft> dexQuotes;
  final List<LaunchpadSwapHistoryDraft> history;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

enum LaunchpadSwapSecurity { high, medium, low }

enum LaunchpadSwapStatus { success, pending, failed }

final class LaunchpadSwapDexQuoteDraft {
  const LaunchpadSwapDexQuoteDraft({
    required this.id,
    required this.name,
    required this.symbol,
    required this.accent,
    required this.price,
    required this.priceImpact,
    required this.gas,
    required this.liquidity,
    required this.route,
    required this.estimatedTime,
    required this.security,
    required this.recommended,
  });

  final String id;
  final String name;
  final String symbol;
  final Color accent;
  final double price;
  final double priceImpact;
  final double gas;
  final double liquidity;
  final List<String> route;
  final String estimatedTime;
  final LaunchpadSwapSecurity security;
  final bool recommended;
}

final class LaunchpadSwapHistoryDraft {
  const LaunchpadSwapHistoryDraft({
    required this.id,
    required this.from,
    required this.to,
    required this.amount,
    required this.dex,
    required this.rate,
    required this.timestamp,
    required this.txHash,
    required this.status,
  });

  final String id;
  final String from;
  final String to;
  final double amount;
  final String dex;
  final double rate;
  final String timestamp;
  final String txHash;
  final LaunchpadSwapStatus status;
}

final class LaunchpadLimitOrdersSnapshot {
  const LaunchpadLimitOrdersSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.orders,
    required this.filled24h,
    required this.totalValueLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<String> tabs;
  final List<LaunchpadLimitOrderDraft> orders;
  final int filled24h;
  final String totalValueLabel;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;

  List<LaunchpadLimitOrderDraft> get activeOrders => orders
      .where((order) => order.status == LaunchpadLimitOrderStatus.active)
      .toList();

  List<LaunchpadLimitOrderDraft> get historyOrders => orders
      .where((order) => order.status != LaunchpadLimitOrderStatus.active)
      .toList();
}

enum LaunchpadLimitOrderSide { buy, sell }

enum LaunchpadLimitOrderStatus { active, filled, cancelled, expired }

final class LaunchpadLimitOrderDraft {
  const LaunchpadLimitOrderDraft({
    required this.id,
    required this.token,
    required this.symbol,
    required this.side,
    required this.targetPrice,
    required this.currentPrice,
    required this.amount,
    required this.filled,
    required this.status,
    required this.expiresAt,
    required this.createdAt,
    required this.partialFill,
    required this.accent,
  });

  final String id;
  final String token;
  final String symbol;
  final LaunchpadLimitOrderSide side;
  final double targetPrice;
  final double currentPrice;
  final double amount;
  final double filled;
  final LaunchpadLimitOrderStatus status;
  final String expiresAt;
  final String createdAt;
  final bool partialFill;
  final Color accent;

  double get distancePercent =>
      (currentPrice - targetPrice) / targetPrice * 100;

  double get progressToTarget {
    if (side == LaunchpadLimitOrderSide.buy) {
      return (((targetPrice - currentPrice) / targetPrice) * 100 + 100)
          .clamp(0, 100)
          .toDouble();
    }
    return (currentPrice / targetPrice * 100).clamp(0, 100).toDouble();
  }

  String get sideLabel => side == LaunchpadLimitOrderSide.buy ? 'Buy' : 'Sell';
}

final class LaunchpadDcaBuilderSnapshot {
  const LaunchpadDcaBuilderSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.strategies,
    required this.executions,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<String> tabs;
  final List<LaunchpadDcaStrategyDraft> strategies;
  final List<LaunchpadDcaExecutionDraft> executions;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;

  double get totalInvested =>
      strategies.fold(0, (sum, strategy) => sum + strategy.totalInvested);

  double get currentValue =>
      strategies.fold(0, (sum, strategy) => sum + strategy.currentValue);

  int get activeStrategyCount => strategies
      .where((strategy) => strategy.status == LaunchpadDcaStrategyStatus.active)
      .length;

  int get executedOrderCount =>
      strategies.fold(0, (sum, strategy) => sum + strategy.executedOrders);
}

enum LaunchpadDcaFrequency { daily, weekly, biweekly, monthly }

enum LaunchpadDcaStrategyStatus { active, paused, completed }

final class LaunchpadDcaStrategyDraft {
  const LaunchpadDcaStrategyDraft({
    required this.id,
    required this.token,
    required this.symbol,
    required this.frequency,
    required this.amount,
    required this.startDate,
    required this.nextBuy,
    required this.totalInvested,
    required this.totalTokens,
    required this.avgPrice,
    required this.currentValue,
    required this.status,
    required this.executedOrders,
    required this.remainingBudget,
    required this.accent,
  });

  final String id;
  final String token;
  final String symbol;
  final LaunchpadDcaFrequency frequency;
  final double amount;
  final String startDate;
  final String nextBuy;
  final double totalInvested;
  final double totalTokens;
  final double avgPrice;
  final double currentValue;
  final LaunchpadDcaStrategyStatus status;
  final int executedOrders;
  final double remainingBudget;
  final Color accent;

  double get pnl => currentValue - totalInvested;

  double get pnlPercent => pnl / totalInvested * 100;
}

final class LaunchpadDcaExecutionDraft {
  const LaunchpadDcaExecutionDraft({
    required this.id,
    required this.date,
    required this.amount,
    required this.price,
    required this.tokens,
    required this.fee,
  });

  final String id;
  final String date;
  final double amount;
  final double price;
  final double tokens;
  final double fee;
}

final class LaunchpadRiskAnalyticsSnapshot {
  const LaunchpadRiskAnalyticsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.project,
    required this.comparisonProjects,
    required this.auditReports,
    required this.resources,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<String> tabs;
  final LaunchpadRiskProjectDraft project;
  final List<LaunchpadRiskProjectDraft> comparisonProjects;
  final List<LaunchpadRiskAuditDraft> auditReports;
  final List<LaunchpadRiskResourceDraft> resources;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;

  List<LaunchpadRiskMetricDraft> get metrics => [
    LaunchpadRiskMetricDraft(
      label: 'Team',
      value: project.score.teamTransparency,
    ),
    LaunchpadRiskMetricDraft(label: 'Audit', value: project.score.auditScore),
    LaunchpadRiskMetricDraft(
      label: 'Tokenomics',
      value: project.score.tokenomics,
    ),
    LaunchpadRiskMetricDraft(
      label: 'Community',
      value: project.score.communityTrust,
    ),
    LaunchpadRiskMetricDraft(
      label: 'Security',
      value: project.score.techSecurity,
    ),
    LaunchpadRiskMetricDraft(
      label: 'Liquidity',
      value: project.score.liquidityRisk,
    ),
  ];
}

enum LaunchpadRiskLevel { low, medium, high, critical }

enum LaunchpadRiskAuditStatus { verified, pending, failed, none }

final class LaunchpadRiskScoreDraft {
  const LaunchpadRiskScoreDraft({
    required this.overall,
    required this.teamTransparency,
    required this.auditScore,
    required this.tokenomics,
    required this.communityTrust,
    required this.techSecurity,
    required this.liquidityRisk,
  });

  final int overall;
  final int teamTransparency;
  final int auditScore;
  final int tokenomics;
  final int communityTrust;
  final int techSecurity;
  final int liquidityRisk;
}

final class LaunchpadRiskProjectDraft {
  const LaunchpadRiskProjectDraft({
    required this.id,
    required this.name,
    required this.symbol,
    required this.score,
    required this.level,
    required this.auditStatus,
    required this.teamDoxxed,
    required this.contractVerified,
    required this.liquidityLocked,
    required this.warnings,
    required this.strengths,
  });

  final String id;
  final String name;
  final String symbol;
  final LaunchpadRiskScoreDraft score;
  final LaunchpadRiskLevel level;
  final LaunchpadRiskAuditStatus auditStatus;
  final bool teamDoxxed;
  final bool contractVerified;
  final bool liquidityLocked;
  final List<String> warnings;
  final List<String> strengths;
}

final class LaunchpadRiskMetricDraft {
  const LaunchpadRiskMetricDraft({required this.label, required this.value});

  final String label;
  final int value;
}
