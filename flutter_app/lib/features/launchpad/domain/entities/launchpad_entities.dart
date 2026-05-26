import 'package:flutter/material.dart';

enum LaunchpadScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
}

enum LaunchpadProjectStatus { upcoming, active, ended }

enum LaunchpadProjectType { ido, ieo, launchpool }

enum LaunchpadAuditStatus { passed, pending, issues }

enum LaunchpadSubscriptionStatus {
  pending,
  allocated,
  partiallyAllocated,
  claimed,
  refunded,
}

final class LaunchpadHomeSnapshot {
  const LaunchpadHomeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.performanceRoute,
    required this.portfolioRoute,
    required this.stakingRoute,
    required this.projects,
    required this.advancedTools,
    required this.riskTools,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String performanceRoute;
  final String portfolioRoute;
  final String stakingRoute;
  final List<LaunchpadProjectDraft> projects;
  final List<LaunchpadToolDraft> advancedTools;
  final List<LaunchpadToolDraft> riskTools;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadProjectDraft {
  const LaunchpadProjectDraft({
    required this.id,
    required this.name,
    required this.symbol,
    required this.logo,
    required this.accent,
    required this.description,
    required this.type,
    required this.status,
    required this.totalRaise,
    required this.hardCap,
    required this.price,
    required this.priceUnit,
    required this.endDate,
    required this.progress,
    required this.participants,
    required this.tags,
    required this.kyc,
    required this.kycLevel,
    required this.whitelist,
    required this.chain,
    required this.audit,
    required this.auditStatus,
    this.roi,
  });

  final String id;
  final String name;
  final String symbol;
  final String logo;
  final Color accent;
  final String description;
  final LaunchpadProjectType type;
  final LaunchpadProjectStatus status;
  final String totalRaise;
  final String hardCap;
  final double price;
  final String priceUnit;
  final String endDate;
  final int progress;
  final int participants;
  final List<String> tags;
  final bool kyc;
  final int kycLevel;
  final bool whitelist;
  final String chain;
  final String audit;
  final LaunchpadAuditStatus auditStatus;
  final int? roi;
}

final class LaunchpadDetailSnapshot {
  const LaunchpadDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.projectId,
    required this.project,
    required this.contractRoute,
    required this.idoBridgeRoute,
    required this.receiptRoute,
    required this.stakingRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String projectId;
  final LaunchpadProjectDraft? project;
  final String contractRoute;
  final String idoBridgeRoute;
  final String receiptRoute;
  final String stakingRoute;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadToolDraft {
  const LaunchpadToolDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.route,
    required this.iconKey,
    required this.accent,
  });

  final String id;
  final String label;
  final String description;
  final String route;
  final String iconKey;
  final Color accent;
}

final class LaunchpadPortfolioSnapshot {
  const LaunchpadPortfolioSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.launchpadRoute,
    required this.receiptRoute,
    required this.subscriptions,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String launchpadRoute;
  final String receiptRoute;
  final List<LaunchpadSubscriptionDraft> subscriptions;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadSubscriptionDraft {
  const LaunchpadSubscriptionDraft({
    required this.id,
    required this.projectName,
    required this.projectSymbol,
    required this.projectLogo,
    required this.accent,
    required this.amount,
    required this.tokensAllocated,
    required this.status,
    required this.allocationRatio,
    required this.timestamp,
    required this.refundAmount,
    required this.vestingProgress,
    required this.tokensClaimed,
    required this.nextUnlockDate,
    required this.txHash,
  });

  final String id;
  final String projectName;
  final String projectSymbol;
  final String projectLogo;
  final Color accent;
  final double amount;
  final int tokensAllocated;
  final LaunchpadSubscriptionStatus status;
  final double allocationRatio;
  final String timestamp;
  final double refundAmount;
  final int vestingProgress;
  final int tokensClaimed;
  final String nextUnlockDate;
  final String txHash;
}

final class LaunchpadReceiptSnapshot {
  const LaunchpadReceiptSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.launchpadRoute,
    required this.portfolioRoute,
    required this.subscriptionId,
    required this.subscription,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String launchpadRoute;
  final String portfolioRoute;
  final String subscriptionId;
  final LaunchpadSubscriptionDraft? subscription;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadPerformanceSnapshot {
  const LaunchpadPerformanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.summary,
    required this.projects,
    required this.chartPoints,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final LaunchpadPerformanceSummaryDraft summary;
  final List<LaunchpadHistoricalProjectDraft> projects;
  final List<LaunchpadPerformancePointDraft> chartPoints;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadPerformanceSummaryDraft {
  const LaunchpadPerformanceSummaryDraft({
    required this.averageRoiAth,
    required this.medianRoi,
    required this.positiveRate,
    required this.totalProjects,
    required this.totalRaised,
    required this.totalParticipants,
    required this.bestProjectName,
    required this.bestProjectRoi,
    required this.worstProjectName,
    required this.worstProjectRoi,
  });

  final int averageRoiAth;
  final int medianRoi;
  final double positiveRate;
  final int totalProjects;
  final String totalRaised;
  final String totalParticipants;
  final String bestProjectName;
  final int bestProjectRoi;
  final String worstProjectName;
  final int worstProjectRoi;
}

final class LaunchpadHistoricalProjectDraft {
  const LaunchpadHistoricalProjectDraft({
    required this.id,
    required this.name,
    required this.symbol,
    required this.type,
    required this.launchDate,
    required this.launchPrice,
    required this.athPrice,
    required this.currentPrice,
    required this.roiAth,
    required this.roiCurrent,
    required this.participants,
    required this.totalRaised,
    required this.accent,
  });

  final String id;
  final String name;
  final String symbol;
  final String type;
  final String launchDate;
  final double launchPrice;
  final double athPrice;
  final double currentPrice;
  final int roiAth;
  final int roiCurrent;
  final int participants;
  final String totalRaised;
  final Color accent;
}

final class LaunchpadPerformancePointDraft {
  const LaunchpadPerformancePointDraft({
    required this.month,
    required this.avgRoi,
    required this.volume,
  });

  final String month;
  final int avgRoi;
  final int volume;
}

enum LaunchpoolPoolStatus { upcoming, active, ended }

enum LaunchpadStakePositionStatus { active, cooldown, unlocked, withdrawn }

final class LaunchpadStakingSnapshot {
  const LaunchpadStakingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.detailRoute,
    required this.batchClaimRoute,
    required this.claimReceiptRoute,
    required this.pools,
    required this.positions,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String detailRoute;
  final String batchClaimRoute;
  final String claimReceiptRoute;
  final List<LaunchpoolPoolDraft> pools;
  final List<LaunchpadStakePositionDraft> positions;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;

  double get totalStaked =>
      positions.fold(0, (sum, position) => sum + position.stakedAmount);

  double get totalPendingRewards =>
      positions.fold(0, (sum, position) => sum + position.pendingRewards);

  int get activePoolCount =>
      pools.where((pool) => pool.status == LaunchpoolPoolStatus.active).length;
}

final class LaunchpoolPoolDraft {
  const LaunchpoolPoolDraft({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.projectSymbol,
    required this.projectLogo,
    required this.accent,
    required this.stakeToken,
    required this.rewardToken,
    required this.baseApy,
    required this.totalStaked,
    required this.totalStakedDisplay,
    required this.poolCap,
    required this.userStaked,
    required this.userRewards,
    required this.rewardTokenPrice,
    required this.lockPeriodDays,
    required this.chain,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.tiers,
  });

  final String id;
  final String projectId;
  final String projectName;
  final String projectSymbol;
  final String projectLogo;
  final Color accent;
  final String stakeToken;
  final String rewardToken;
  final double baseApy;
  final double totalStaked;
  final String totalStakedDisplay;
  final double poolCap;
  final double userStaked;
  final double userRewards;
  final double rewardTokenPrice;
  final int lockPeriodDays;
  final String chain;
  final LaunchpoolPoolStatus status;
  final String startDate;
  final String endDate;
  final List<LaunchpadStakingTierDraft> tiers;

  double get fillRatio => totalStaked / poolCap;

  double get effectiveApy {
    final eligible = tiers
        .where((tier) => userStaked >= tier.minStake)
        .fold<double>(0, (bonus, tier) => tier.apyBonus);
    return baseApy + eligible;
  }
}

final class LaunchpadStakingTierDraft {
  const LaunchpadStakingTierDraft({
    required this.minStake,
    required this.label,
    required this.apyBonus,
    required this.accent,
  });

  final double minStake;
  final String label;
  final double apyBonus;
  final Color accent;
}

final class LaunchpadStakePositionDraft {
  const LaunchpadStakePositionDraft({
    required this.id,
    required this.poolId,
    required this.projectName,
    required this.projectSymbol,
    required this.accent,
    required this.stakeToken,
    required this.rewardToken,
    required this.stakedAmount,
    required this.stakedAt,
    required this.lockUntil,
    required this.pendingRewards,
    required this.claimedRewards,
    required this.apy,
    required this.status,
  });

  final String id;
  final String poolId;
  final String projectName;
  final String projectSymbol;
  final Color accent;
  final String stakeToken;
  final String rewardToken;
  final double stakedAmount;
  final String stakedAt;
  final String lockUntil;
  final double pendingRewards;
  final double claimedRewards;
  final double apy;
  final LaunchpadStakePositionStatus status;
}

enum LaunchpadVestingEntryStatus { claimed, claimable, unlocking, locked }

enum LaunchpadClaimHistoryStatus { confirmed, pending }

final class LaunchpadClaimReceiptSnapshot {
  const LaunchpadClaimReceiptSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.positionId,
    required this.receipt,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String positionId;
  final LaunchpadRewardClaimReceiptDraft receipt;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadRewardClaimReceiptDraft {
  const LaunchpadRewardClaimReceiptDraft({
    required this.id,
    required this.positionId,
    required this.poolId,
    required this.projectName,
    required this.projectSymbol,
    required this.accent,
    required this.rewardToken,
    required this.rewardTokenPrice,
    required this.totalEarned,
    required this.totalClaimed,
    required this.totalPending,
    required this.totalVested,
    required this.vestingSchedule,
    required this.claimHistory,
    required this.poolApy,
    required this.stakedAmount,
    required this.stakeToken,
    required this.chain,
    required this.contractAddress,
    required this.nextUnlockDate,
    required this.nextUnlockAmount,
  });

  final String id;
  final String positionId;
  final String poolId;
  final String projectName;
  final String projectSymbol;
  final Color accent;
  final String rewardToken;
  final double rewardTokenPrice;
  final double totalEarned;
  final double totalClaimed;
  final double totalPending;
  final double totalVested;
  final List<LaunchpadRewardVestingEntryDraft> vestingSchedule;
  final List<LaunchpadClaimHistoryEntryDraft> claimHistory;
  final double poolApy;
  final double stakedAmount;
  final String stakeToken;
  final String chain;
  final String contractAddress;
  final String nextUnlockDate;
  final double nextUnlockAmount;

  double get claimedRatio => totalClaimed / totalEarned;

  double get vestedRatio => totalVested / totalEarned;

  double get lockedAmount => totalEarned - totalVested;

  double get claimableTotal => vestingSchedule
      .where(
        (entry) =>
            entry.status == LaunchpadVestingEntryStatus.claimable ||
            entry.status == LaunchpadVestingEntryStatus.unlocking,
      )
      .fold(0, (sum, entry) => sum + entry.amount);
}

final class LaunchpadRewardVestingEntryDraft {
  const LaunchpadRewardVestingEntryDraft({
    required this.id,
    required this.label,
    required this.percent,
    required this.amount,
    required this.token,
    required this.unlockDate,
    required this.status,
    this.claimedAt,
    this.txHash,
  });

  final String id;
  final String label;
  final int percent;
  final double amount;
  final String token;
  final String unlockDate;
  final LaunchpadVestingEntryStatus status;
  final String? claimedAt;
  final String? txHash;
}

final class LaunchpadClaimHistoryEntryDraft {
  const LaunchpadClaimHistoryEntryDraft({
    required this.id,
    required this.amount,
    required this.token,
    required this.usdValue,
    required this.claimedAt,
    required this.txHash,
    required this.vestingEntryId,
    required this.status,
    required this.gasUsed,
  });

  final String id;
  final double amount;
  final String token;
  final double usdValue;
  final String claimedAt;
  final String txHash;
  final String vestingEntryId;
  final LaunchpadClaimHistoryStatus status;
  final String gasUsed;
}

final class LaunchpadBatchClaimSnapshot {
  const LaunchpadBatchClaimSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.claimReceiptRoute,
    required this.positions,
    required this.summary,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String claimReceiptRoute;
  final List<LaunchpadBatchClaimPositionDraft> positions;
  final LaunchpadBatchClaimSummaryDraft summary;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadBatchClaimPositionDraft {
  const LaunchpadBatchClaimPositionDraft({
    required this.positionId,
    required this.poolId,
    required this.projectName,
    required this.projectSymbol,
    required this.accent,
    required this.rewardToken,
    required this.rewardTokenPrice,
    required this.claimableAmount,
    required this.claimableUsd,
    required this.vestingEntries,
    required this.chain,
    required this.contractAddress,
    required this.stakedAmount,
    required this.stakeToken,
    required this.apy,
  });

  final String positionId;
  final String poolId;
  final String projectName;
  final String projectSymbol;
  final Color accent;
  final String rewardToken;
  final double rewardTokenPrice;
  final double claimableAmount;
  final double claimableUsd;
  final List<LaunchpadRewardVestingEntryDraft> vestingEntries;
  final String chain;
  final String contractAddress;
  final double stakedAmount;
  final String stakeToken;
  final double apy;
}

final class LaunchpadBatchClaimSummaryDraft {
  const LaunchpadBatchClaimSummaryDraft({
    required this.totalClaimable,
    required this.totalClaimableUsd,
    required this.estimatedGasIndividual,
    required this.estimatedGasBatch,
    required this.gasSavingsPercent,
    required this.gasSavingsUsd,
    required this.chains,
  });

  final Map<String, double> totalClaimable;
  final double totalClaimableUsd;
  final String estimatedGasIndividual;
  final String estimatedGasBatch;
  final int gasSavingsPercent;
  final double gasSavingsUsd;
  final List<String> chains;
}

final class LaunchpadIdoBridgeSnapshot {
  const LaunchpadIdoBridgeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.projectId,
    required this.project,
    required this.sourceNetworks,
    required this.routes,
    required this.bridgeCompareRoute,
    required this.bridgeOrderRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String projectId;
  final LaunchpadProjectDraft? project;
  final List<LaunchpadBridgeNetworkDraft> sourceNetworks;
  final List<LaunchpadSwapRouteDraft> routes;
  final String bridgeCompareRoute;
  final String bridgeOrderRoute;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadBridgeNetworkDraft {
  const LaunchpadBridgeNetworkDraft({
    required this.id,
    required this.name,
    required this.symbol,
    required this.accent,
    required this.logo,
    required this.nativeCoin,
    required this.gasEstimate,
    required this.confirmations,
    required this.averageTime,
  });

  final String id;
  final String name;
  final String symbol;
  final Color accent;
  final String logo;
  final String nativeCoin;
  final String gasEstimate;
  final int confirmations;
  final String averageTime;
}

final class LaunchpadSwapRouteDraft {
  const LaunchpadSwapRouteDraft({
    required this.id,
    required this.provider,
    required this.estimatedOutput,
    required this.priceImpact,
    required this.gasCost,
    required this.totalFee,
    required this.estimatedTime,
    required this.recommended,
    required this.hops,
  });

  final String id;
  final String provider;
  final int estimatedOutput;
  final double priceImpact;
  final String gasCost;
  final String totalFee;
  final String estimatedTime;
  final bool recommended;
  final List<LaunchpadSwapHopDraft> hops;
}

final class LaunchpadSwapHopDraft {
  const LaunchpadSwapHopDraft({
    required this.fromToken,
    required this.toToken,
    required this.dex,
    required this.chain,
    required this.rate,
  });

  final String fromToken;
  final String toToken;
  final String dex;
  final String chain;
  final double rate;
}

final class LaunchpadBridgeCompareSnapshot {
  const LaunchpadBridgeCompareSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.bridgeOrderRoute,
    required this.comparison,
    required this.sortOptions,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String bridgeOrderRoute;
  final LaunchpadBridgeComparisonDraft comparison;
  final List<LaunchpadBridgeSortOptionDraft> sortOptions;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadBridgeComparisonDraft {
  const LaunchpadBridgeComparisonDraft({
    required this.id,
    required this.timestamp,
    required this.sourceChain,
    required this.targetChain,
    required this.inputToken,
    required this.outputToken,
    required this.inputAmount,
    required this.routes,
    required this.bestOutput,
    required this.bestFee,
    required this.bestSpeed,
    required this.bestSecurity,
  });

  final String id;
  final String timestamp;
  final String sourceChain;
  final String targetChain;
  final String inputToken;
  final String outputToken;
  final double inputAmount;
  final List<LaunchpadBridgeRouteOptionDraft> routes;
  final String bestOutput;
  final String bestFee;
  final String bestSpeed;
  final String bestSecurity;
}

final class LaunchpadBridgeRouteOptionDraft {
  const LaunchpadBridgeRouteOptionDraft({
    required this.id,
    required this.provider,
    required this.providerIcon,
    required this.accent,
    required this.sourceChain,
    required this.targetChain,
    required this.inputToken,
    required this.outputToken,
    required this.inputAmount,
    required this.outputAmount,
    required this.priceImpact,
    required this.gasCost,
    required this.bridgeFee,
    required this.totalFee,
    required this.totalFeeUsd,
    required this.estimatedTime,
    required this.estimatedSeconds,
    required this.hops,
    required this.path,
    required this.securityScore,
    required this.liquidityDepth,
    required this.slippage,
    required this.recommended,
    required this.tags,
    required this.warnings,
  });

  final String id;
  final String provider;
  final String providerIcon;
  final Color accent;
  final String sourceChain;
  final String targetChain;
  final String inputToken;
  final String outputToken;
  final double inputAmount;
  final double outputAmount;
  final double priceImpact;
  final double gasCost;
  final double bridgeFee;
  final double totalFee;
  final String totalFeeUsd;
  final String estimatedTime;
  final int estimatedSeconds;
  final int hops;
  final List<LaunchpadSwapHopDraft> path;
  final int securityScore;
  final String liquidityDepth;
  final double slippage;
  final bool recommended;
  final List<String> tags;
  final List<String> warnings;
}

final class LaunchpadBridgeSortOptionDraft {
  const LaunchpadBridgeSortOptionDraft({
    required this.value,
    required this.label,
    required this.iconKey,
  });

  final String value;
  final String label;
  final String iconKey;
}

final class LaunchpadNotifSoundSnapshot {
  const LaunchpadNotifSoundSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.masterEnabled,
    required this.masterVolume,
    required this.vibrate,
    required this.doNotDisturb,
    required this.dndStartHour,
    required this.dndEndHour,
    required this.categories,
    required this.soundTypes,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final bool masterEnabled;
  final int masterVolume;
  final bool vibrate;
  final bool doNotDisturb;
  final int dndStartHour;
  final int dndEndHour;
  final List<LaunchpadNotifSoundCategoryDraft> categories;
  final List<LaunchpadSoundTypeDraft> soundTypes;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadNotifSoundCategoryDraft {
  const LaunchpadNotifSoundCategoryDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.accent,
    required this.enabled,
    required this.soundType,
    required this.volume,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final Color accent;
  final bool enabled;
  final String soundType;
  final int volume;
}

final class LaunchpadSoundTypeDraft {
  const LaunchpadSoundTypeDraft({required this.value, required this.label});

  final String value;
  final String label;
}

enum LaunchpadEventLogLevel { info, success, warning, error, debug, tx }

final class LaunchpadEventLogSnapshot {
  const LaunchpadEventLogSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.events,
    required this.exportFormats,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<LaunchpadEventLogEntryDraft> events;
  final List<LaunchpadEventLogExportFormatDraft> exportFormats;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadEventLogEntryDraft {
  const LaunchpadEventLogEntryDraft({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.source,
    required this.message,
    required this.tags,
    this.details,
    this.txHash,
    this.chain,
    this.contractAddress,
    this.gasUsed,
    this.blockNumber,
  });

  final String id;
  final String timestamp;
  final LaunchpadEventLogLevel level;
  final String source;
  final String message;
  final String? details;
  final String? txHash;
  final String? chain;
  final String? contractAddress;
  final String? gasUsed;
  final int? blockNumber;
  final List<String> tags;
}

final class LaunchpadEventLogExportFormatDraft {
  const LaunchpadEventLogExportFormatDraft({
    required this.value,
    required this.label,
    required this.iconKey,
  });

  final String value;
  final String label;
  final String iconKey;
}

enum LaunchpadAbiChangeType { added, removed, modified, unchanged }

enum LaunchpadAbiRiskLevel { none, low, medium, high, critical }

final class LaunchpadAbiDiffSnapshot {
  const LaunchpadAbiDiffSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.contractId,
    required this.diff,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String contractId;
  final LaunchpadAbiDiffResultDraft diff;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadAbiDiffResultDraft {
  const LaunchpadAbiDiffResultDraft({
    required this.contractAddress,
    required this.chain,
    required this.oldImpl,
    required this.newImpl,
    required this.oldImplLabel,
    required this.newImplLabel,
    required this.upgradeBlock,
    required this.upgradeTimestamp,
    required this.upgradeTxHash,
    required this.totalFunctionsOld,
    required this.totalFunctionsNew,
    required this.totalEventsOld,
    required this.totalEventsNew,
    required this.added,
    required this.removed,
    required this.modified,
    required this.unchanged,
    required this.riskScore,
    required this.entries,
  });

  final String contractAddress;
  final String chain;
  final String oldImpl;
  final String newImpl;
  final String oldImplLabel;
  final String newImplLabel;
  final int upgradeBlock;
  final String upgradeTimestamp;
  final String upgradeTxHash;
  final int totalFunctionsOld;
  final int totalFunctionsNew;
  final int totalEventsOld;
  final int totalEventsNew;
  final int added;
  final int removed;
  final int modified;
  final int unchanged;
  final int riskScore;
  final List<LaunchpadAbiDiffEntryDraft> entries;
}

final class LaunchpadAbiDiffEntryDraft {
  const LaunchpadAbiDiffEntryDraft({
    required this.name,
    required this.type,
    required this.changeType,
    required this.riskLevel,
    this.oldSignature,
    this.newSignature,
    this.oldVisibility,
    this.newVisibility,
    this.oldStateMutability,
    this.newStateMutability,
    this.riskNote,
  });

  final String name;
  final String type;
  final LaunchpadAbiChangeType changeType;
  final LaunchpadAbiRiskLevel riskLevel;
  final String? oldSignature;
  final String? newSignature;
  final String? oldVisibility;
  final String? newVisibility;
  final String? oldStateMutability;
  final String? newStateMutability;
  final String? riskNote;
}

final class LaunchpadAddressBookSnapshot {
  const LaunchpadAddressBookSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.addresses,
    required this.chainFilters,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<LaunchpadWalletAddressDraft> addresses;
  final List<String> chainFilters;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadWalletAddressDraft {
  const LaunchpadWalletAddressDraft({
    required this.id,
    required this.label,
    required this.address,
    required this.chain,
    required this.accent,
    required this.iconKey,
    required this.isDefault,
    required this.isFavorite,
    required this.usageCount,
    required this.tags,
    required this.createdAt,
    required this.verified,
    this.lastUsed,
    this.notes,
  });

  final String id;
  final String label;
  final String address;
  final String chain;
  final Color accent;
  final String iconKey;
  final bool isDefault;
  final bool isFavorite;
  final int usageCount;
  final List<String> tags;
  final String createdAt;
  final bool verified;
  final String? lastUsed;
  final String? notes;

  String get maskedAddress => address.length <= 12
      ? address
      : '${address.substring(0, 6)}...${address.substring(address.length - 4)}';

  LaunchpadWalletAddressDraft copyWith({bool? isDefault, bool? isFavorite}) {
    return LaunchpadWalletAddressDraft(
      id: id,
      label: label,
      address: address,
      chain: chain,
      accent: accent,
      iconKey: iconKey,
      isDefault: isDefault ?? this.isDefault,
      isFavorite: isFavorite ?? this.isFavorite,
      usageCount: usageCount,
      tags: tags,
      createdAt: createdAt,
      verified: verified,
      lastUsed: lastUsed,
      notes: notes,
    );
  }
}

final class LaunchpadWebhooksSnapshot {
  const LaunchpadWebhooksSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.subscriptions,
    required this.deliveries,
    required this.eventTypes,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<String> tabs;
  final List<LaunchpadWebhookSubscriptionDraft> subscriptions;
  final List<LaunchpadWebhookDeliveryDraft> deliveries;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

enum LaunchpadWebhookStatus { active, paused, error, pending }

enum LaunchpadWebhookDeliveryStatus { delivered, failed, retrying, pending }

enum LaunchpadWebhookRetryPolicy { none, linear, exponential }

final class LaunchpadWebhookEventDraft {
  const LaunchpadWebhookEventDraft({
    required this.type,
    required this.label,
    required this.description,
    required this.accent,
  });

  final String type;
  final String label;
  final String description;
  final Color accent;
}

final class LaunchpadWebhookFilterDraft {
  const LaunchpadWebhookFilterDraft({
    required this.field,
    required this.operator,
    required this.value,
  });

  final String field;
  final String operator;
  final String value;
}

final class LaunchpadWebhookSubscriptionDraft {
  const LaunchpadWebhookSubscriptionDraft({
    required this.id,
    required this.label,
    required this.contractAddress,
    required this.chain,
    required this.accent,
    required this.eventTypes,
    required this.webhookUrl,
    required this.status,
    required this.createdAt,
    required this.triggerCount,
    required this.errorCount,
    required this.filters,
    required this.retryPolicy,
    required this.maxRetries,
    this.secret,
    this.lastTriggered,
    this.lastError,
  });

  final String id;
  final String label;
  final String contractAddress;
  final String chain;
  final Color accent;
  final List<String> eventTypes;
  final String webhookUrl;
  final String? secret;
  final LaunchpadWebhookStatus status;
  final String createdAt;
  final String? lastTriggered;
  final int triggerCount;
  final int errorCount;
  final String? lastError;
  final List<LaunchpadWebhookFilterDraft> filters;
  final LaunchpadWebhookRetryPolicy retryPolicy;
  final int maxRetries;

  String get maskedContract => contractAddress.length <= 12
      ? contractAddress
      : '${contractAddress.substring(0, 10)}...${contractAddress.substring(contractAddress.length - 4)}';

  LaunchpadWebhookSubscriptionDraft copyWith({LaunchpadWebhookStatus? status}) {
    return LaunchpadWebhookSubscriptionDraft(
      id: id,
      label: label,
      contractAddress: contractAddress,
      chain: chain,
      accent: accent,
      eventTypes: eventTypes,
      webhookUrl: webhookUrl,
      secret: secret,
      status: status ?? this.status,
      createdAt: createdAt,
      lastTriggered: lastTriggered,
      triggerCount: triggerCount,
      errorCount: errorCount,
      lastError: lastError,
      filters: filters,
      retryPolicy: retryPolicy,
      maxRetries: maxRetries,
    );
  }
}

final class LaunchpadWebhookDeliveryDraft {
  const LaunchpadWebhookDeliveryDraft({
    required this.id,
    required this.subscriptionId,
    required this.eventType,
    required this.timestamp,
    required this.status,
    required this.payload,
    required this.retryCount,
    this.statusCode,
    this.responseTime,
    this.txHash,
    this.blockNumber,
  });

  final String id;
  final String subscriptionId;
  final String eventType;
  final String timestamp;
  final LaunchpadWebhookDeliveryStatus status;
  final int? statusCode;
  final int? responseTime;
  final String payload;
  final String? txHash;
  final int? blockNumber;
  final int retryCount;
}

final class LaunchpadGasTrackerSnapshot {
  const LaunchpadGasTrackerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.prices,
    required this.estimates,
    required this.alerts,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<String> tabs;
  final List<LaunchpadGasPriceDraft> prices;
  final List<LaunchpadGasEstimateDraft> estimates;
  final List<LaunchpadGasAlertDraft> alerts;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

enum LaunchpadGasTrend { up, down, stable }

enum LaunchpadGasAlertDirection { above, below }

final class LaunchpadGasPriceDraft {
  const LaunchpadGasPriceDraft({
    required this.chain,
    required this.accent,
    required this.chainIcon,
    required this.slow,
    required this.standard,
    required this.fast,
    required this.instant,
    required this.unit,
    required this.lastUpdated,
    required this.trend,
    required this.change24h,
    this.baseFee,
    this.priorityFee,
  });

  final String chain;
  final Color accent;
  final String chainIcon;
  final double slow;
  final double standard;
  final double fast;
  final double instant;
  final String unit;
  final double? baseFee;
  final double? priorityFee;
  final String lastUpdated;
  final LaunchpadGasTrend trend;
  final double change24h;
}

final class LaunchpadGasEstimateDraft {
  const LaunchpadGasEstimateDraft({
    required this.operation,
    required this.gasUnits,
    required this.costs,
  });

  final String operation;
  final int gasUnits;
  final List<LaunchpadGasEstimateCostDraft> costs;
}

final class LaunchpadGasEstimateCostDraft {
  const LaunchpadGasEstimateCostDraft({
    required this.chain,
    required this.slow,
    required this.standard,
    required this.fast,
  });

  final String chain;
  final String slow;
  final String standard;
  final String fast;
}

final class LaunchpadGasAlertDraft {
  const LaunchpadGasAlertDraft({
    required this.id,
    required this.chain,
    required this.accent,
    required this.threshold,
    required this.direction,
    required this.unit,
    required this.enabled,
    required this.triggerCount,
    this.lastTriggered,
  });

  final String id;
  final String chain;
  final Color accent;
  final double threshold;
  final LaunchpadGasAlertDirection direction;
  final String unit;
  final bool enabled;
  final String? lastTriggered;
  final int triggerCount;

  LaunchpadGasAlertDraft copyWith({bool? enabled}) {
    return LaunchpadGasAlertDraft(
      id: id,
      chain: chain,
      accent: accent,
      threshold: threshold,
      direction: direction,
      unit: unit,
      enabled: enabled ?? this.enabled,
      lastTriggered: lastTriggered,
      triggerCount: triggerCount,
    );
  }
}

final class LaunchpadRebalanceSnapshot {
  const LaunchpadRebalanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.assets,
    required this.strategies,
    required this.defaultStrategyId,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<LaunchpadRebalanceAssetDraft> assets;
  final List<LaunchpadRebalanceStrategyDraft> strategies;
  final String defaultStrategyId;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

enum LaunchpadRebalanceRisk { conservative, moderate, aggressive }

enum LaunchpadRebalanceAction { buy, sell, hold }

final class LaunchpadRebalanceAssetDraft {
  const LaunchpadRebalanceAssetDraft({
    required this.id,
    required this.symbol,
    required this.name,
    required this.accent,
    required this.currentAmount,
    required this.currentValue,
    required this.currentPercent,
    required this.targetPercent,
    required this.price,
    required this.change24h,
    required this.chain,
  });

  final String id;
  final String symbol;
  final String name;
  final Color accent;
  final double currentAmount;
  final double currentValue;
  final double currentPercent;
  final double targetPercent;
  final double price;
  final double change24h;
  final String chain;

  LaunchpadRebalanceAssetDraft copyWith({double? targetPercent}) {
    return LaunchpadRebalanceAssetDraft(
      id: id,
      symbol: symbol,
      name: name,
      accent: accent,
      currentAmount: currentAmount,
      currentValue: currentValue,
      currentPercent: currentPercent,
      targetPercent: targetPercent ?? this.targetPercent,
      price: price,
      change24h: change24h,
      chain: chain,
    );
  }
}

final class LaunchpadRebalanceStrategyDraft {
  const LaunchpadRebalanceStrategyDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.riskLevel,
    required this.accent,
    required this.targets,
  });

  final String id;
  final String name;
  final String description;
  final LaunchpadRebalanceRisk riskLevel;
  final Color accent;
  final List<LaunchpadRebalanceTargetDraft> targets;
}

final class LaunchpadRebalanceTargetDraft {
  const LaunchpadRebalanceTargetDraft({
    required this.symbol,
    required this.percent,
  });

  final String symbol;
  final double percent;
}

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

final class LaunchpadRiskAuditDraft {
  const LaunchpadRiskAuditDraft({
    required this.firm,
    required this.date,
    required this.status,
    required this.criticalIssues,
  });

  final String firm;
  final String date;
  final String status;
  final int criticalIssues;
}

final class LaunchpadRiskResourceDraft {
  const LaunchpadRiskResourceDraft({required this.label, required this.url});

  final String label;
  final String url;
}

enum LaunchpadBridgeOrderStatus {
  initiated,
  approved,
  bridging,
  confirming,
  swapping,
  finalizing,
  completed,
  failed,
}

enum LaunchpadBridgeEventLevel { info, success, warning, error, debug, system }

enum LaunchpadBridgeConnectionState {
  connecting,
  connected,
  reconnecting,
  disconnected,
}

final class LaunchpadBridgeOrderSnapshot {
  const LaunchpadBridgeOrderSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.txId,
    required this.order,
    required this.events,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String txId;
  final LaunchpadBridgeOrderDraft order;
  final List<LaunchpadBridgeEventDraft> events;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadBridgeOrderDraft {
  const LaunchpadBridgeOrderDraft({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.projectSymbol,
    required this.accent,
    required this.sourceChain,
    required this.targetChain,
    required this.inputToken,
    required this.outputToken,
    required this.inputAmount,
    required this.expectedOutput,
    required this.routeProvider,
    required this.routeHops,
    required this.slippage,
    required this.gasCost,
    required this.totalFee,
    required this.priceImpact,
    required this.status,
    required this.steps,
    required this.createdAt,
    required this.etaSeconds,
    required this.pollCount,
    required this.sourceTxHash,
    required this.connectionState,
  });

  final String id;
  final String projectId;
  final String projectName;
  final String projectSymbol;
  final Color accent;
  final String sourceChain;
  final String targetChain;
  final String inputToken;
  final String outputToken;
  final double inputAmount;
  final int expectedOutput;
  final String routeProvider;
  final int routeHops;
  final double slippage;
  final String gasCost;
  final String totalFee;
  final double priceImpact;
  final LaunchpadBridgeOrderStatus status;
  final List<LaunchpadBridgeStepDraft> steps;
  final String createdAt;
  final int etaSeconds;
  final int pollCount;
  final String sourceTxHash;
  final LaunchpadBridgeConnectionState connectionState;
}

final class LaunchpadBridgeStepDraft {
  const LaunchpadBridgeStepDraft({
    required this.id,
    required this.status,
    required this.label,
    required this.detail,
    this.timestamp,
    this.txHash,
    this.confirmationsCurrent,
    this.confirmationsRequired,
  });

  final String id;
  final LaunchpadBridgeOrderStatus status;
  final String label;
  final String detail;
  final String? timestamp;
  final String? txHash;
  final int? confirmationsCurrent;
  final int? confirmationsRequired;
}

final class LaunchpadBridgeEventDraft {
  const LaunchpadBridgeEventDraft({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.source,
    required this.message,
    this.txHash,
  });

  final String id;
  final String timestamp;
  final LaunchpadBridgeEventLevel level;
  final String source;
  final String message;
  final String? txHash;
}

enum LaunchpadContractFunctionType { read, write }

enum LaunchpadContractRiskLevel { low, medium, high }

enum LaunchpadTxSimulationStatus { simulating, success, warning, failed }

final class LaunchpadContractSnapshot {
  const LaunchpadContractSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.projectId,
    required this.project,
    required this.networks,
    required this.functions,
    required this.simulations,
    required this.abiDiffRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String projectId;
  final LaunchpadProjectDraft? project;
  final List<LaunchpadBridgeNetworkDraft> networks;
  final List<LaunchpadContractFunctionDraft> functions;
  final List<LaunchpadTxSimulationDraft> simulations;
  final String abiDiffRoute;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadContractFunctionDraft {
  const LaunchpadContractFunctionDraft({
    required this.name,
    required this.description,
    required this.type,
    required this.riskLevel,
    required this.params,
    this.estimatedGas,
  });

  final String name;
  final String description;
  final LaunchpadContractFunctionType type;
  final LaunchpadContractRiskLevel riskLevel;
  final List<LaunchpadContractParamDraft> params;
  final String? estimatedGas;
}

final class LaunchpadContractParamDraft {
  const LaunchpadContractParamDraft({
    required this.name,
    required this.type,
    required this.label,
    required this.placeholder,
    required this.required,
  });

  final String name;
  final String type;
  final String label;
  final String placeholder;
  final bool required;
}

final class LaunchpadTxSimulationDraft {
  const LaunchpadTxSimulationDraft({
    required this.id,
    required this.functionName,
    required this.chain,
    required this.contractAddress,
    required this.params,
    required this.status,
    required this.gasEstimate,
    required this.gasPrice,
    required this.totalCost,
    required this.expectedOutput,
    required this.warnings,
    required this.stateChanges,
  });

  final String id;
  final String functionName;
  final String chain;
  final String contractAddress;
  final Map<String, String> params;
  final LaunchpadTxSimulationStatus status;
  final String gasEstimate;
  final String gasPrice;
  final String totalCost;
  final String expectedOutput;
  final List<String> warnings;
  final List<String> stateChanges;
}
