import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';

final launchpadRepositoryProvider = Provider<LaunchpadRepository>((ref) {
  return const MockLaunchpadRepository();
});

abstract interface class LaunchpadRepository {
  LaunchpadHomeSnapshot getHome();

  LaunchpadDetailSnapshot getDetail(String projectId);

  LaunchpadPortfolioSnapshot getPortfolio();

  LaunchpadReceiptSnapshot getReceipt(String subscriptionId);

  LaunchpadPerformanceSnapshot getPerformance();

  LaunchpadStakingSnapshot getStaking();

  LaunchpadBatchClaimSnapshot getBatchClaim();

  LaunchpadClaimReceiptSnapshot getClaimReceipt(String positionId);

  LaunchpadIdoBridgeSnapshot getIdoBridge(String projectId);

  LaunchpadBridgeCompareSnapshot getBridgeCompare();

  LaunchpadNotifSoundSnapshot getNotifSound();

  LaunchpadEventLogSnapshot getEventLog();

  LaunchpadAbiDiffSnapshot getAbiDiff(String contractId);

  LaunchpadAddressBookSnapshot getAddressBook();

  LaunchpadWebhooksSnapshot getWebhooks();

  LaunchpadGasTrackerSnapshot getGasTracker();

  LaunchpadRebalanceSnapshot getRebalance();

  LaunchpadMultisigSnapshot getMultisig();

  LaunchpadSwapAggregatorSnapshot getSwapAggregator();

  LaunchpadLimitOrdersSnapshot getLimitOrders();

  LaunchpadDcaBuilderSnapshot getDcaBuilder();

  LaunchpadRiskAnalyticsSnapshot getRiskAnalytics();

  LaunchpadBridgeOrderSnapshot getBridgeOrder(String txId);

  LaunchpadContractSnapshot getContract(String projectId);
}

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

final class MockLaunchpadRepository implements LaunchpadRepository {
  const MockLaunchpadRepository();

  @override
  LaunchpadHomeSnapshot getHome() {
    return const LaunchpadHomeSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Launchpad',
      subtitle: 'Dự án mới · Token Launch',
      backRoute: '/home',
      performanceRoute: '/launchpad/performance',
      portfolioRoute: '/launchpad/portfolio',
      stakingRoute: '/launchpad/staking',
      projects: _launchpadProjects,
      advancedTools: _advancedTools,
      riskTools: _riskTools,
      contractNotes:
          'Launchpad home returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, route metadata, and screenState. Subscribe/claim/bridge actions remain draft POST contracts until backend schemas are finalized.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadDetailSnapshot getDetail(String projectId) {
    final normalizedId = projectId.trim().isEmpty ? 'sample' : projectId.trim();
    final matchingProjects = _launchpadProjects.where(
      (project) => project.id == normalizedId,
    );
    return LaunchpadDetailSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-$normalizedId',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Launchpad',
      backRoute: '/launchpad',
      projectId: normalizedId,
      project: matchingProjects.isEmpty ? null : matchingProjects.first,
      contractRoute: '/launchpad/contract/$normalizedId',
      idoBridgeRoute: '/launchpad/idobridge/$normalizedId',
      receiptRoute: '/launchpad/receipt/new',
      stakingRoute: '/launchpad/staking',
      contractNotes:
          'Launchpad detail returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, selected project detail, tokenomics, vesting, team audit data, eligibility gates, and screenState. Captured route sample intentionally has no matching project and mirrors the React error baseline; dynamic contract, IDO bridge, and new receipt routes remain safe placeholders until backend id semantics are confirmed.',
      supportedStates: const {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadPortfolioSnapshot getPortfolio() {
    return const LaunchpadPortfolioSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-portfolio',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Launchpad Portfolio',
      subtitle: 'Các dự án đã tham gia',
      backRoute: '/launchpad',
      launchpadRoute: '/launchpad',
      receiptRoute: '/launchpad/receipt/sub001',
      subscriptions: _launchpadSubscriptions,
      contractNotes:
          'Launchpad portfolio returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, receiptRoute, and screenState. Claim/refund buttons are local action placeholders until POST claim/refund contracts are finalized.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadReceiptSnapshot getReceipt(String subscriptionId) {
    final normalizedId = subscriptionId.trim();
    final matchingSubscriptions = _launchpadSubscriptions.where(
      (subscription) => subscription.id == normalizedId,
    );
    return LaunchpadReceiptSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-receipt-$normalizedId',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Biên lai',
      backRoute: '/launchpad/portfolio',
      launchpadRoute: '/launchpad',
      portfolioRoute: '/launchpad/portfolio',
      subscriptionId: normalizedId,
      subscription: matchingSubscriptions.isEmpty
          ? null
          : matchingSubscriptions.first,
      contractNotes:
          'Launchpad receipt returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, selected subscription details, portfolioRoute, launchpadRoute, and screenState. Direct captured route sub001 intentionally has no hydrated subscription state and mirrors the React error baseline.',
      supportedStates: const {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadPerformanceSnapshot getPerformance() {
    return const LaunchpadPerformanceSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-performance',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Hiệu suất Launchpad',
      subtitle: 'Lịch sử · Thống kê',
      backRoute: '/launchpad',
      summary: LaunchpadPerformanceSummaryDraft(
        averageRoiAth: 193,
        medianRoi: 232,
        positiveRate: 87.5,
        totalProjects: 8,
        totalRaised: r'$25,800,000',
        totalParticipants: '222K+',
        bestProjectName: 'MetaPay',
        bestProjectRoi: 370,
        worstProjectName: 'CryptoLens',
        worstProjectRoi: -55,
      ),
      projects: _historicalProjects,
      chartPoints: _performancePoints,
      contractNotes:
          'Launchpad performance returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, historicalProjects, performanceSummary, chartPoints, and screenState. This screen is read-only.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadStakingSnapshot getStaking() {
    return const LaunchpadStakingSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-staking',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Launchpool Staking',
      subtitle: 'Stake token · Nhận phần thưởng',
      backRoute: '/launchpad',
      detailRoute: '/launchpad/sample',
      batchClaimRoute: '/launchpad/batch-claim',
      claimReceiptRoute: '/launchpad/claim-receipt/pos001',
      pools: _launchpoolPools,
      positions: _stakePositions,
      contractNotes:
          'Launchpad staking returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, launchpoolPools, stakingPositions, batchClaimRoute, claimReceiptRoute, and screenState. Stake, unstake, claim, and batch-claim actions remain draft POST contracts until backend schemas are finalized.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadBatchClaimSnapshot getBatchClaim() {
    return const LaunchpadBatchClaimSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-batch-claim',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Batch Claim',
      backRoute: '/launchpad/staking',
      claimReceiptRoute: '/launchpad/claim-receipt/pos001',
      positions: _batchClaimPositions,
      summary: _batchClaimSummary,
      contractNotes:
          'Launchpad batch claim returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, claimable positions, per-token summary, gas estimate, selected position ids, and screenState. Dynamic receipt navigation from each position remains backend-confirmed; the Flutter port uses the safe pos001 receipt route until route-specific ids are finalized.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      },
    );
  }

  @override
  LaunchpadClaimReceiptSnapshot getClaimReceipt(String positionId) {
    final normalizedId = positionId.trim();
    final matchingReceipts = _claimReceipts.where(
      (receipt) => receipt.positionId == normalizedId,
    );
    return LaunchpadClaimReceiptSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-claim-receipt-$normalizedId',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Phần thưởng',
      backRoute: '/launchpad/staking',
      positionId: normalizedId,
      receipt: matchingReceipts.isEmpty
          ? _claimReceipts.first
          : matchingReceipts.first,
      contractNotes:
          'Launchpad claim receipt returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, selected reward claim receipt, vestingSchedule, claimHistory, notification preferences, and screenState. Captured route pos001 follows the React fallback to the first claim receipt when the route id is not found.',
      supportedStates: const {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadIdoBridgeSnapshot getIdoBridge(String projectId) {
    final normalizedId = projectId.trim();
    final matchingProjects = _launchpadProjects.where(
      (project) => project.id == normalizedId,
    );
    return LaunchpadIdoBridgeSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-idobridge-$normalizedId',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'IDO Bridge',
      backRoute: '/launchpad',
      projectId: normalizedId,
      project: matchingProjects.isEmpty ? null : matchingProjects.first,
      sourceNetworks: _bridgeNetworks,
      routes: _swapRoutes,
      bridgeCompareRoute: '/launchpad/bridge-compare',
      bridgeOrderRoute: '/launchpad/bridge-order/tx001',
      contractNotes:
          'Launchpad IDO bridge returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, bridgeNetworks, swapRoutes, bridgeCompareRoute, bridgeOrderRoute, and screenState. Route ids from runtime bridge records require backend confirmation; sample route intentionally renders the React not-found state.',
      supportedStates: const {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadBridgeCompareSnapshot getBridgeCompare() {
    return const LaunchpadBridgeCompareSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-bridge-compare',
      actionDraft:
          'POST /launchpad/subscribe|claim|bridge where applicable; GET with query filters',
      title: 'So sánh routes',
      backRoute: '/launchpad',
      bridgeOrderRoute: '/launchpad/bridge-order/tx001',
      comparison: _bridgeComparison,
      sortOptions: _bridgeSortOptions,
      contractNotes:
          r'Launchpad bridge compare returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, bridge comparison input, candidate route options, route metrics, sort filters, selectedRouteId, and screenState. React navigates to a dynamic batch_${Date.now()} bridge order; the Flutter port uses the existing tx001 bridge-order route until backend route ids are confirmed.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadNotifSoundSnapshot getNotifSound() {
    return const LaunchpadNotifSoundSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-notif-sound',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Âm thanh thông báo',
      backRoute: '/launchpad',
      masterEnabled: true,
      masterVolume: 80,
      vibrate: true,
      doNotDisturb: false,
      dndStartHour: 22,
      dndEndHour: 7,
      categories: _notifSoundCategories,
      soundTypes: _notifSoundTypes,
      contractNotes:
          'Launchpad notification sound settings return launchpadProjects, subscriptions, claims, bridgeOrders, contracts, master sound state, DND schedule, category sound settings, local preview controls, and screenState. Saving maps to a future user/module settings mutation; current Flutter mock keeps changes local.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadEventLogSnapshot getEventLog() {
    return const LaunchpadEventLogSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-event-log',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Event Log',
      backRoute: '/launchpad',
      events: _eventLogEntries,
      exportFormats: _eventLogExportFormats,
      contractNotes:
          'Launchpad event log returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, event log rows, level/source filters, selection state, export format options, clipboard payload metadata, and screenState. Export is local clipboard-first until backend audit-log export is confirmed.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadAbiDiffSnapshot getAbiDiff(String contractId) {
    final normalizedId = contractId.trim().isEmpty
        ? 'contract001'
        : contractId.trim();
    return LaunchpadAbiDiffSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-abi-diff-$normalizedId',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'ABI Diff',
      backRoute: '/launchpad',
      contractId: normalizedId,
      diff: _abiDiffResult,
      contractNotes:
          'Launchpad ABI diff returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, selected contract id, implementation metadata, ABI diff entries, summary counts, risk score, filters, copy affordances, and screenState. Dynamic contract-address routing from contract detail remains pinned to contract001 until backend confirms address encoding and authorization.',
      supportedStates: const {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadAddressBookSnapshot getAddressBook() {
    return const LaunchpadAddressBookSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-address-book',
      actionDraft:
          'POST /kyc/submission-step; POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'So dia chi',
      backRoute: '/launchpad',
      addresses: _launchpadWalletAddresses,
      chainFilters: ['all', 'Ethereum', 'BSC', 'Polygon', 'Arbitrum'],
      contractNotes:
          'Launchpad address book returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, multi-chain saved addresses, chain filters, favorite/default state, local copy/add/delete affordances, KYC verification hints, and screenState. Address mutations map to future wallet address APIs and KYC submission-step checks.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadWebhooksSnapshot getWebhooks() {
    return const LaunchpadWebhooksSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-webhooks',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Webhooks',
      backRoute: '/launchpad',
      tabs: ['subscriptions', 'deliveries'],
      subscriptions: _launchpadWebhookSubscriptions,
      deliveries: _launchpadWebhookDeliveries,
      eventTypes: _launchpadWebhookEvents,
      contractNotes:
          'Launchpad webhooks returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, webhook subscription list, delivery history, event catalog, retry policy, copyable contract/webhook fields, and screenState. Create, pause/resume, delete, and retry policy edits map to future launchpad webhook endpoints while preserving the current launchpad action draft.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      },
    );
  }

  @override
  LaunchpadGasTrackerSnapshot getGasTracker() {
    return const LaunchpadGasTrackerSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-gas-tracker',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Gas Tracker',
      backRoute: '/launchpad',
      tabs: ['prices', 'estimator', 'alerts'],
      prices: _launchpadGasPrices,
      estimates: _launchpadGasEstimates,
      alerts: _launchpadGasAlerts,
      contractNotes:
          'Launchpad gas tracker returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, multi-chain gas prices, operation cost estimates, gas alerts, EIP-1559 fields, deterministic history points, and screenState. Alert create/toggle/delete actions map to future gas alert APIs while preserving launchpad action draft.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      },
    );
  }

  @override
  LaunchpadRebalanceSnapshot getRebalance() {
    return const LaunchpadRebalanceSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-rebalance',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Rebalance',
      backRoute: '/launchpad',
      assets: _launchpadRebalanceAssets,
      strategies: _launchpadRebalanceStrategies,
      defaultStrategyId: 'moderate',
      contractNotes:
          'Launchpad rebalance returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, portfolio assets, strategy targets, current/target allocation, generated buy/sell/hold suggestions, preview summary, and screenState. Confirm action is mock-only until launchpad rebalance execution API is confirmed.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      },
    );
  }

  @override
  LaunchpadMultisigSnapshot getMultisig() {
    return const LaunchpadMultisigSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-multisig',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Multi-sig',
      backRoute: '/launchpad',
      tabs: ['queue', 'history', 'safes'],
      safes: _launchpadMultisigSafes,
      transactions: _launchpadMultisigTxs,
      defaultSafeAddress: '0xSafe1111...aaaa',
      contractNotes:
          'Launchpad multisig returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, multisig safes, owners/signers, queue/history transactions, signature progress, create/sign/execute action state, selectedSafeAddress, and screenState. Create/sign/execute are mock-local until multisig execution endpoints are confirmed.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      },
    );
  }

  @override
  LaunchpadSwapAggregatorSnapshot getSwapAggregator() {
    return const LaunchpadSwapAggregatorSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-swap-aggregator',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Swap Aggregator',
      backRoute: '/launchpad',
      tabs: ['So sanh', 'Lich su', 'Cai dat'],
      fromToken: 'USDT',
      toToken: 'ARB',
      amount: '1000',
      slippageTolerance: .5,
      autoRefresh: true,
      dexQuotes: _launchpadSwapDexQuotes,
      history: _launchpadSwapHistory,
      contractNotes:
          'Launchpad swap aggregator returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, from/to token inputs, amount, slippage settings, DEX quotes, route details, swap history, auto-refresh state, selected quote, and screenState. Swap CTA is mock-only until aggregator execution API is confirmed.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      },
    );
  }

  @override
  LaunchpadLimitOrdersSnapshot getLimitOrders() {
    return const LaunchpadLimitOrdersSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-limit-orders',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Limit Orders',
      backRoute: '/launchpad',
      tabs: ['Hoat dong', 'Lich su', 'Tao lenh'],
      orders: _launchpadLimitOrders,
      filled24h: 3,
      totalValueLabel: r'$4.2K',
      contractNotes:
          'Launchpad limit orders returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, active/history orders, create order draft, cancel/edit actions, execution state, and screenState. Create/edit/cancel are mock-local until limit order execution API is confirmed.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      },
    );
  }

  @override
  LaunchpadDcaBuilderSnapshot getDcaBuilder() {
    return const LaunchpadDcaBuilderSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-dca-builder',
      actionDraft:
          'POST /launchpad/subscribe|claim|bridge where applicable; POST /dca/plans|rebalance|schedule',
      title: 'DCA Builder',
      backRoute: '/launchpad',
      tabs: ['Chien luoc', 'Lich su', 'Tao moi'],
      strategies: _launchpadDcaStrategies,
      executions: _launchpadDcaExecutions,
      contractNotes:
          'Launchpad DCA builder returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, DCA strategies, execution history, create strategy draft, schedule/rebalance action state, and screenState. Create/pause/resume/settings are mock-local until DCA plan execution API is confirmed.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadRiskAnalyticsSnapshot getRiskAnalytics() {
    return const LaunchpadRiskAnalyticsSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-risk-analytics',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Risk Analytics',
      backRoute: '/launchpad',
      tabs: ['Tong quan', 'Due Diligence', 'Bao cao'],
      project: _launchpadRiskProject,
      comparisonProjects: _launchpadRiskProjects,
      auditReports: _launchpadRiskAudits,
      resources: _launchpadRiskResources,
      contractNotes:
          'Launchpad risk analytics returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, selected project risk score, due diligence checks, warnings, strengths, comparison reports, resources, realtime refresh metadata, and screenState. This read model keeps subscribe, claim, and bridge actions read-only from this screen until risk-review execution APIs are confirmed.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }

  @override
  LaunchpadBridgeOrderSnapshot getBridgeOrder(String txId) {
    final normalizedId = txId.trim();
    return LaunchpadBridgeOrderSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-bridge-order-$normalizedId',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Chi tiet Bridge',
      backRoute: '/launchpad/idobridge/sample',
      txId: normalizedId,
      order: _bridgeOrder,
      events: _bridgeEvents,
      contractNotes:
          'Launchpad bridge order returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, selected bridge order, polling steps, websocket event summary, action routes, and screenState. Captured route tx001 follows the React fallback to the first bridge history order while preserving the route-scoped endpoint.',
      supportedStates: const {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      },
    );
  }

  @override
  LaunchpadContractSnapshot getContract(String projectId) {
    final normalizedId = projectId.trim();
    final matchingProjects = _launchpadProjects.where(
      (project) => project.id == normalizedId,
    );
    return LaunchpadContractSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-contract-$normalizedId',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Contract',
      backRoute: '/launchpad',
      projectId: normalizedId,
      project: matchingProjects.isEmpty ? null : matchingProjects.first,
      networks: _bridgeNetworks,
      functions: _contractFunctions,
      simulations: _txSimulations,
      abiDiffRoute: '/launchpad/abi-diff/contract001',
      contractNotes:
          'Launchpad contract returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, bridgeNetworks, contractFunctions, txSimulations, abiDiffRoute, and screenState. ABI diff route is kept on the safe contract001 placeholder because encoded contract-address navigation requires backend confirmation.',
      supportedStates: const {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }
}

const _launchpadProjects = [
  LaunchpadProjectDraft(
    id: 'proj1',
    name: 'NexaAI Protocol',
    symbol: 'NEXA',
    logo: 'NA',
    accent: AppColors.accent,
    description:
        'AI-powered DeFi protocol tối ưu lợi suất tự động với Machine Learning trên-chain.',
    type: LaunchpadProjectType.ieo,
    status: LaunchpadProjectStatus.active,
    totalRaise: r'$2,500,000',
    hardCap: r'$3,000,000',
    price: 0.05,
    priceUnit: 'USDT',
    endDate: '08/03/2026 10:00',
    progress: 67,
    participants: 12843,
    tags: ['AI', 'DeFi', 'Yield'],
    kyc: true,
    kycLevel: 2,
    whitelist: false,
    chain: 'BSC',
    audit: 'CertiK',
    auditStatus: LaunchpadAuditStatus.passed,
  ),
  LaunchpadProjectDraft(
    id: 'proj2',
    name: 'MetaVerse Land',
    symbol: 'MVL',
    logo: 'MV',
    accent: AppColors.accent,
    description:
        'Nền tảng metaverse đất ảo kết hợp NFT và gaming với cộng đồng 5M người dùng.',
    type: LaunchpadProjectType.ido,
    status: LaunchpadProjectStatus.active,
    totalRaise: r'$800,000',
    hardCap: r'$1,000,000',
    price: 0.008,
    priceUnit: 'USDT',
    endDate: '07/03/2026 14:00',
    progress: 89,
    participants: 8420,
    tags: ['Metaverse', 'NFT', 'Gaming'],
    kyc: true,
    kycLevel: 2,
    whitelist: true,
    chain: 'ETH',
    audit: 'PeckShield',
    auditStatus: LaunchpadAuditStatus.passed,
  ),
  LaunchpadProjectDraft(
    id: 'proj3',
    name: 'GreenChain Eco',
    symbol: 'GCE',
    logo: 'GC',
    accent: AppColors.buy,
    description:
        'Blockchain carbon credit trading platform giúp các doanh nghiệp offset khí thải CO2.',
    type: LaunchpadProjectType.launchpool,
    status: LaunchpadProjectStatus.upcoming,
    totalRaise: r'$1,200,000',
    hardCap: r'$1,500,000',
    price: 0.12,
    priceUnit: 'USDT',
    endDate: '21/03/2026 10:00',
    progress: 0,
    participants: 0,
    tags: ['RWA', 'ESG', 'Carbon'],
    kyc: false,
    kycLevel: 1,
    whitelist: false,
    chain: 'Polygon',
    audit: 'SlowMist',
    auditStatus: LaunchpadAuditStatus.pending,
  ),
  LaunchpadProjectDraft(
    id: 'proj4',
    name: 'ZetaPay Finance',
    symbol: 'ZPF',
    logo: 'ZP',
    accent: AppColors.warn,
    description:
        'Layer 2 payment protocol cho phép giao dịch USDT tức thì với phí gần bằng 0.',
    type: LaunchpadProjectType.ieo,
    status: LaunchpadProjectStatus.ended,
    totalRaise: r'$5,000,000',
    hardCap: r'$5,000,000',
    price: 0.02,
    priceUnit: 'USDT',
    endDate: '17/01/2026 10:00',
    progress: 100,
    participants: 45230,
    tags: ['L2', 'Payment', 'DeFi'],
    kyc: true,
    kycLevel: 2,
    whitelist: false,
    chain: 'ETH',
    audit: 'CertiK',
    auditStatus: LaunchpadAuditStatus.passed,
    roi: 340,
  ),
  LaunchpadProjectDraft(
    id: 'proj5',
    name: 'OmniDEX',
    symbol: 'OMX',
    logo: 'OM',
    accent: AppColors.primary,
    description:
        'Cross-chain DEX aggregator kết nối tất cả blockchain với routing thông minh nhất.',
    type: LaunchpadProjectType.ido,
    status: LaunchpadProjectStatus.ended,
    totalRaise: r'$3,200,000',
    hardCap: r'$3,200,000',
    price: 0.15,
    priceUnit: 'USDT',
    endDate: '08/01/2026 10:00',
    progress: 100,
    participants: 31200,
    tags: ['DEX', 'Cross-chain', 'DeFi'],
    kyc: true,
    kycLevel: 1,
    whitelist: false,
    chain: 'Multi',
    audit: 'Hacken',
    auditStatus: LaunchpadAuditStatus.passed,
    roi: 185,
  ),
];

const _advancedTools = [
  LaunchpadToolDraft(
    id: 'notif-sound',
    label: 'Âm thanh thông báo',
    description: 'Cài đặt âm thanh & rung',
    route: '/launchpad/notif-sound',
    iconKey: 'bell',
    accent: AppColors.accent,
  ),
  LaunchpadToolDraft(
    id: 'event-log',
    label: 'Event Log',
    description: 'Xuất log giao dịch',
    route: '/launchpad/event-log',
    iconKey: 'event',
    accent: AppColors.primary,
  ),
  LaunchpadToolDraft(
    id: 'abi-diff',
    label: 'ABI Diff',
    description: 'So sánh proxy upgrade',
    route: '/launchpad/abi-diff/contract001',
    iconKey: 'compare',
    accent: AppColors.warn,
  ),
  LaunchpadToolDraft(
    id: 'address-book',
    label: 'Sổ địa chỉ',
    description: 'Quản lý ví đa mạng',
    route: '/launchpad/address-book',
    iconKey: 'book',
    accent: AppColors.buy,
  ),
  LaunchpadToolDraft(
    id: 'webhooks',
    label: 'Webhooks',
    description: 'Đăng ký event contract',
    route: '/launchpad/webhooks',
    iconKey: 'webhook',
    accent: AppColors.accent,
  ),
  LaunchpadToolDraft(
    id: 'gas-tracker',
    label: 'Gas Tracker',
    description: 'Theo dõi gas đa mạng',
    route: '/launchpad/gas-tracker',
    iconKey: 'fuel',
    accent: AppColors.warn,
  ),
  LaunchpadToolDraft(
    id: 'rebalance',
    label: 'Rebalance',
    description: 'Cân bằng portfolio',
    route: '/launchpad/rebalance',
    iconKey: 'pie',
    accent: AppColors.primary,
  ),
  LaunchpadToolDraft(
    id: 'multisig',
    label: 'Multi-sig',
    description: 'Giao dịch nhiều chữ ký',
    route: '/launchpad/multisig',
    iconKey: 'lock',
    accent: AppColors.accent,
  ),
];

const _riskTools = [
  LaunchpadToolDraft(
    id: 'swap-aggregator',
    label: 'Swap Aggregator',
    description: 'So sánh giá DEX',
    route: '/launchpad/swap-aggregator',
    iconKey: 'swap',
    accent: AppColors.primary,
  ),
  LaunchpadToolDraft(
    id: 'limit-orders',
    label: 'Limit Orders',
    description: 'Lệnh tự động',
    route: '/launchpad/limit-orders',
    iconKey: 'clock',
    accent: AppColors.buy,
  ),
  LaunchpadToolDraft(
    id: 'dca-builder',
    label: 'DCA Builder',
    description: 'Chiến lược DCA',
    route: '/launchpad/dca-builder',
    iconKey: 'money',
    accent: AppColors.warn,
  ),
  LaunchpadToolDraft(
    id: 'risk-analytics',
    label: 'Risk Analytics',
    description: 'Phân tích rủi ro',
    route: '/launchpad/risk-analytics',
    iconKey: 'shield',
    accent: AppColors.sell,
  ),
];

const _launchpadSubscriptions = [
  LaunchpadSubscriptionDraft(
    id: 'sub1',
    projectName: 'NexaAI Protocol',
    projectSymbol: 'NEXA',
    projectLogo: 'NA',
    accent: AppColors.accent,
    amount: 500,
    tokensAllocated: 7500,
    status: LaunchpadSubscriptionStatus.partiallyAllocated,
    allocationRatio: .75,
    timestamp: '06/03/2026 10:32',
    refundAmount: 125,
    vestingProgress: 0,
    tokensClaimed: 0,
    nextUnlockDate: '10/03/2026',
    txHash: '0xabc...def123',
  ),
  LaunchpadSubscriptionDraft(
    id: 'sub2',
    projectName: 'ZetaPay Finance',
    projectSymbol: 'ZPF',
    projectLogo: 'ZP',
    accent: AppColors.warn,
    amount: 1000,
    tokensAllocated: 50000,
    status: LaunchpadSubscriptionStatus.claimed,
    allocationRatio: 1,
    timestamp: '15/01/2026 11:45',
    refundAmount: 0,
    vestingProgress: 15,
    tokensClaimed: 7500,
    nextUnlockDate: '20/04/2026',
    txHash: '0xdef...ghi456',
  ),
  LaunchpadSubscriptionDraft(
    id: 'sub3',
    projectName: 'OmniDEX',
    projectSymbol: 'OMX',
    projectLogo: 'OM',
    accent: AppColors.primary,
    amount: 2000,
    tokensAllocated: 13333,
    status: LaunchpadSubscriptionStatus.allocated,
    allocationRatio: 1,
    timestamp: '06/01/2026 09:20',
    refundAmount: 0,
    vestingProgress: 40,
    tokensClaimed: 5333,
    nextUnlockDate: '12/04/2026',
    txHash: '0xghi...jkl789',
  ),
];

const _historicalProjects = [
  LaunchpadHistoricalProjectDraft(
    id: 'hp6',
    name: 'MetaPay',
    symbol: 'MTP',
    type: 'IEO',
    launchDate: '08/2025',
    launchPrice: .03,
    athPrice: .141,
    currentPrice: .087,
    roiAth: 370,
    roiCurrent: 190,
    participants: 51000,
    totalRaised: r'$6,000,000',
    accent: AppColors.buy,
  ),
  LaunchpadHistoricalProjectDraft(
    id: 'hp1',
    name: 'ZetaPay Finance',
    symbol: 'ZPF',
    type: 'IEO',
    launchDate: '01/2026',
    launchPrice: .02,
    athPrice: .088,
    currentPrice: .072,
    roiAth: 340,
    roiCurrent: 260,
    participants: 45230,
    totalRaised: r'$5,000,000',
    accent: AppColors.warn,
  ),
  LaunchpadHistoricalProjectDraft(
    id: 'hp3',
    name: 'ShieldVault',
    symbol: 'SVT',
    type: 'IEO',
    launchDate: '11/2025',
    launchPrice: .05,
    athPrice: .21,
    currentPrice: .165,
    roiAth: 320,
    roiCurrent: 230,
    participants: 28900,
    totalRaised: r'$2,000,000',
    accent: AppColors.buy,
  ),
  LaunchpadHistoricalProjectDraft(
    id: 'hp4',
    name: 'DataMesh AI',
    symbol: 'DMA',
    type: 'IDO',
    launchDate: '10/2025',
    launchPrice: .08,
    athPrice: .312,
    currentPrice: .096,
    roiAth: 290,
    roiCurrent: 20,
    participants: 19500,
    totalRaised: r'$1,500,000',
    accent: AppColors.accent,
  ),
  LaunchpadHistoricalProjectDraft(
    id: 'hp7',
    name: 'HashBridge',
    symbol: 'HBG',
    type: 'IDO',
    launchDate: '07/2025',
    launchPrice: .1,
    athPrice: .38,
    currentPrice: .22,
    roiAth: 280,
    roiCurrent: 120,
    participants: 15800,
    totalRaised: r'$2,500,000',
    accent: AppColors.primary,
  ),
  LaunchpadHistoricalProjectDraft(
    id: 'hp5',
    name: 'SolarChain',
    symbol: 'SLC',
    type: 'Launchpool',
    launchDate: '09/2025',
    launchPrice: .25,
    athPrice: .75,
    currentPrice: .42,
    roiAth: 200,
    roiCurrent: 68,
    participants: 22100,
    totalRaised: r'$4,000,000',
    accent: AppColors.warn,
  ),
  LaunchpadHistoricalProjectDraft(
    id: 'hp2',
    name: 'OmniDEX',
    symbol: 'OMX',
    type: 'IDO',
    launchDate: '01/2026',
    launchPrice: .15,
    athPrice: .4275,
    currentPrice: .352,
    roiAth: 185,
    roiCurrent: 135,
    participants: 31200,
    totalRaised: r'$3,200,000',
    accent: AppColors.primary,
  ),
  LaunchpadHistoricalProjectDraft(
    id: 'hp8',
    name: 'CryptoLens',
    symbol: 'CLN',
    type: 'IEO',
    launchDate: '06/2025',
    launchPrice: .04,
    athPrice: .06,
    currentPrice: .018,
    roiAth: 50,
    roiCurrent: -55,
    participants: 8900,
    totalRaised: r'$800,000',
    accent: AppColors.sell,
  ),
];

const _performancePoints = [
  LaunchpadPerformancePointDraft(month: '06/25', avgRoi: 50, volume: 800000),
  LaunchpadPerformancePointDraft(month: '07/25', avgRoi: 280, volume: 2500000),
  LaunchpadPerformancePointDraft(month: '08/25', avgRoi: 370, volume: 6000000),
  LaunchpadPerformancePointDraft(month: '09/25', avgRoi: 200, volume: 4000000),
  LaunchpadPerformancePointDraft(month: '10/25', avgRoi: 290, volume: 1500000),
  LaunchpadPerformancePointDraft(month: '11/25', avgRoi: 320, volume: 2000000),
  LaunchpadPerformancePointDraft(month: '01/26', avgRoi: 263, volume: 8200000),
];

const _greenChainTiers = [
  LaunchpadStakingTierDraft(
    minStake: 50,
    label: 'Bronze',
    apyBonus: 0,
    accent: AppColors.warn,
  ),
  LaunchpadStakingTierDraft(
    minStake: 500,
    label: 'Silver',
    apyBonus: 5,
    accent: AppColors.text2,
  ),
  LaunchpadStakingTierDraft(
    minStake: 2000,
    label: 'Gold',
    apyBonus: 12,
    accent: AppColors.primarySoft,
  ),
  LaunchpadStakingTierDraft(
    minStake: 10000,
    label: 'Platinum',
    apyBonus: 22.5,
    accent: AppColors.text1,
  ),
];

const _nexaTiers = [
  LaunchpadStakingTierDraft(
    minStake: 100,
    label: 'Bronze',
    apyBonus: 0,
    accent: AppColors.warn,
  ),
  LaunchpadStakingTierDraft(
    minStake: 1000,
    label: 'Silver',
    apyBonus: 4,
    accent: AppColors.text2,
  ),
  LaunchpadStakingTierDraft(
    minStake: 5000,
    label: 'Gold',
    apyBonus: 10,
    accent: AppColors.primarySoft,
  ),
  LaunchpadStakingTierDraft(
    minStake: 20000,
    label: 'Platinum',
    apyBonus: 17,
    accent: AppColors.text1,
  ),
];

const _omniTiers = [
  LaunchpadStakingTierDraft(
    minStake: 50,
    label: 'Bronze',
    apyBonus: 0,
    accent: AppColors.warn,
  ),
  LaunchpadStakingTierDraft(
    minStake: 500,
    label: 'Silver',
    apyBonus: 3,
    accent: AppColors.text2,
  ),
  LaunchpadStakingTierDraft(
    minStake: 3000,
    label: 'Gold',
    apyBonus: 7,
    accent: AppColors.primarySoft,
  ),
  LaunchpadStakingTierDraft(
    minStake: 15000,
    label: 'Platinum',
    apyBonus: 12,
    accent: AppColors.text1,
  ),
];

const _launchpoolPools = [
  LaunchpoolPoolDraft(
    id: 'pool1',
    projectId: 'proj3',
    projectName: 'GreenChain Eco',
    projectSymbol: 'GCE',
    projectLogo: 'GC',
    accent: AppColors.buy,
    stakeToken: 'USDT',
    rewardToken: 'GCE',
    baseApy: 42.5,
    totalStaked: 850000,
    totalStakedDisplay: r'$850,000',
    poolCap: 1500000,
    userStaked: 0,
    userRewards: 0,
    rewardTokenPrice: .12,
    lockPeriodDays: 30,
    chain: 'Polygon',
    status: LaunchpoolPoolStatus.upcoming,
    startDate: '15/03/2026 10:00',
    endDate: '15/04/2026 10:00',
    tiers: _greenChainTiers,
  ),
  LaunchpoolPoolDraft(
    id: 'pool2',
    projectId: 'proj1',
    projectName: 'NexaAI Protocol',
    projectSymbol: 'NEXA',
    projectLogo: 'NA',
    accent: AppColors.accent,
    stakeToken: 'BNB',
    rewardToken: 'NEXA',
    baseApy: 38,
    totalStaked: 1200000,
    totalStakedDisplay: r'$1,200,000',
    poolCap: 2000000,
    userStaked: 2500,
    userRewards: 1250,
    rewardTokenPrice: .05,
    lockPeriodDays: 14,
    chain: 'BSC',
    status: LaunchpoolPoolStatus.active,
    startDate: '05/03/2026 10:00',
    endDate: '05/04/2026 10:00',
    tiers: _nexaTiers,
  ),
  LaunchpoolPoolDraft(
    id: 'pool3',
    projectId: 'proj5',
    projectName: 'OmniDEX',
    projectSymbol: 'OMX',
    projectLogo: 'OM',
    accent: AppColors.primary,
    stakeToken: 'USDT',
    rewardToken: 'OMX',
    baseApy: 28,
    totalStaked: 2800000,
    totalStakedDisplay: r'$2,800,000',
    poolCap: 3200000,
    userStaked: 5000,
    userRewards: 890,
    rewardTokenPrice: .352,
    lockPeriodDays: 7,
    chain: 'Multi',
    status: LaunchpoolPoolStatus.active,
    startDate: '01/01/2026 10:00',
    endDate: '01/04/2026 10:00',
    tiers: _omniTiers,
  ),
];

const _stakePositions = [
  LaunchpadStakePositionDraft(
    id: 'sp1',
    poolId: 'pool2',
    projectName: 'NexaAI Protocol',
    projectSymbol: 'NEXA',
    accent: AppColors.accent,
    stakeToken: 'BNB',
    rewardToken: 'NEXA',
    stakedAmount: 2500,
    stakedAt: '06/03/2026 10:00',
    lockUntil: '20/03/2026 10:00',
    pendingRewards: 1250,
    claimedRewards: 0,
    apy: 48,
    status: LaunchpadStakePositionStatus.active,
  ),
  LaunchpadStakePositionDraft(
    id: 'sp2',
    poolId: 'pool3',
    projectName: 'OmniDEX',
    projectSymbol: 'OMX',
    accent: AppColors.primary,
    stakeToken: 'USDT',
    rewardToken: 'OMX',
    stakedAmount: 5000,
    stakedAt: '15/01/2026 10:00',
    lockUntil: '22/01/2026 10:00',
    pendingRewards: 890,
    claimedRewards: 2340,
    apy: 35,
    status: LaunchpadStakePositionStatus.active,
  ),
];

const _claimReceipts = [
  LaunchpadRewardClaimReceiptDraft(
    id: 'cr1',
    positionId: 'sp1',
    poolId: 'pool2',
    projectName: 'NexaAI Protocol',
    projectSymbol: 'NEXA',
    accent: AppColors.accent,
    rewardToken: 'NEXA',
    rewardTokenPrice: .05,
    totalEarned: 3850,
    totalClaimed: 2340,
    totalPending: 1510,
    totalVested: 3080,
    stakedAmount: 2500,
    stakeToken: 'BNB',
    poolApy: 48,
    chain: 'BSC',
    contractAddress: '0x1a2b3c4d5e6f7890abcdef1234567890abcdef12',
    nextUnlockDate: '14/03/2026 10:00',
    nextUnlockAmount: 462.5,
    vestingSchedule: [
      LaunchpadRewardVestingEntryDraft(
        id: 'v1',
        label: 'TGE Instant',
        percent: 20,
        amount: 770,
        token: 'NEXA',
        unlockDate: '06/03/2026',
        status: LaunchpadVestingEntryStatus.claimed,
        claimedAt: '06/03/2026 10:15',
        txHash: '0xa1b2...c3d4',
      ),
      LaunchpadRewardVestingEntryDraft(
        id: 'v2',
        label: 'Week 1',
        percent: 20,
        amount: 770,
        token: 'NEXA',
        unlockDate: '06/03/2026',
        status: LaunchpadVestingEntryStatus.claimed,
        claimedAt: '06/03/2026 18:00',
        txHash: '0xe5f6...7890',
      ),
      LaunchpadRewardVestingEntryDraft(
        id: 'v3',
        label: 'Week 2',
        percent: 20,
        amount: 770,
        token: 'NEXA',
        unlockDate: '07/03/2026',
        status: LaunchpadVestingEntryStatus.claimed,
        claimedAt: '07/03/2026 11:30',
        txHash: '0x1234...5678',
      ),
      LaunchpadRewardVestingEntryDraft(
        id: 'v4',
        label: 'Week 3',
        percent: 12,
        amount: 462.5,
        token: 'NEXA',
        unlockDate: '14/03/2026',
        status: LaunchpadVestingEntryStatus.unlocking,
      ),
      LaunchpadRewardVestingEntryDraft(
        id: 'v5',
        label: 'Week 4',
        percent: 12,
        amount: 462.5,
        token: 'NEXA',
        unlockDate: '21/03/2026',
        status: LaunchpadVestingEntryStatus.locked,
      ),
      LaunchpadRewardVestingEntryDraft(
        id: 'v6',
        label: 'Week 5 (Final)',
        percent: 16,
        amount: 615,
        token: 'NEXA',
        unlockDate: '28/03/2026',
        status: LaunchpadVestingEntryStatus.locked,
      ),
    ],
    claimHistory: [
      LaunchpadClaimHistoryEntryDraft(
        id: 'ch1',
        amount: 770,
        token: 'NEXA',
        usdValue: 38.5,
        claimedAt: '06/03/2026 10:15',
        txHash: '0xa1b2...c3d4',
        vestingEntryId: 'v1',
        status: LaunchpadClaimHistoryStatus.confirmed,
        gasUsed: '52,000',
      ),
      LaunchpadClaimHistoryEntryDraft(
        id: 'ch2',
        amount: 770,
        token: 'NEXA',
        usdValue: 38.5,
        claimedAt: '06/03/2026 18:00',
        txHash: '0xe5f6...7890',
        vestingEntryId: 'v2',
        status: LaunchpadClaimHistoryStatus.confirmed,
        gasUsed: '48,000',
      ),
      LaunchpadClaimHistoryEntryDraft(
        id: 'ch3',
        amount: 800,
        token: 'NEXA',
        usdValue: 40,
        claimedAt: '07/03/2026 11:30',
        txHash: '0x1234...5678',
        vestingEntryId: 'v3',
        status: LaunchpadClaimHistoryStatus.confirmed,
        gasUsed: '51,000',
      ),
    ],
  ),
  LaunchpadRewardClaimReceiptDraft(
    id: 'cr2',
    positionId: 'sp2',
    poolId: 'pool3',
    projectName: 'OmniDEX',
    projectSymbol: 'OMX',
    accent: AppColors.primary,
    rewardToken: 'OMX',
    rewardTokenPrice: .352,
    totalEarned: 3230,
    totalClaimed: 2340,
    totalPending: 890,
    totalVested: 2900,
    stakedAmount: 5000,
    stakeToken: 'USDT',
    poolApy: 35,
    chain: 'Multi',
    contractAddress: '0xfedcba0987654321fedcba0987654321fedcba09',
    nextUnlockDate: '10/03/2026 10:00',
    nextUnlockAmount: 320,
    vestingSchedule: [
      LaunchpadRewardVestingEntryDraft(
        id: 'v1',
        label: 'Instant',
        percent: 30,
        amount: 969,
        token: 'OMX',
        unlockDate: '15/01/2026',
        status: LaunchpadVestingEntryStatus.claimed,
        claimedAt: '15/01/2026 10:20',
        txHash: '0xaa11...bb22',
      ),
      LaunchpadRewardVestingEntryDraft(
        id: 'v2',
        label: 'Month 1',
        percent: 20,
        amount: 646,
        token: 'OMX',
        unlockDate: '15/02/2026',
        status: LaunchpadVestingEntryStatus.claimed,
        claimedAt: '15/02/2026 12:00',
        txHash: '0xcc33...dd44',
      ),
      LaunchpadRewardVestingEntryDraft(
        id: 'v3',
        label: 'Month 2',
        percent: 20,
        amount: 646,
        token: 'OMX',
        unlockDate: '15/03/2026',
        status: LaunchpadVestingEntryStatus.unlocking,
      ),
      LaunchpadRewardVestingEntryDraft(
        id: 'v4',
        label: 'Month 3',
        percent: 15,
        amount: 484.5,
        token: 'OMX',
        unlockDate: '15/04/2026',
        status: LaunchpadVestingEntryStatus.locked,
      ),
      LaunchpadRewardVestingEntryDraft(
        id: 'v5',
        label: 'Month 4 (Final)',
        percent: 15,
        amount: 484.5,
        token: 'OMX',
        unlockDate: '15/05/2026',
        status: LaunchpadVestingEntryStatus.locked,
      ),
    ],
    claimHistory: [
      LaunchpadClaimHistoryEntryDraft(
        id: 'ch1',
        amount: 969,
        token: 'OMX',
        usdValue: 341.1,
        claimedAt: '15/01/2026 10:20',
        txHash: '0xaa11...bb22',
        vestingEntryId: 'v1',
        status: LaunchpadClaimHistoryStatus.confirmed,
        gasUsed: '44,000',
      ),
      LaunchpadClaimHistoryEntryDraft(
        id: 'ch2',
        amount: 646,
        token: 'OMX',
        usdValue: 227.4,
        claimedAt: '15/02/2026 12:00',
        txHash: '0xcc33...dd44',
        vestingEntryId: 'v2',
        status: LaunchpadClaimHistoryStatus.confirmed,
        gasUsed: '46,000',
      ),
      LaunchpadClaimHistoryEntryDraft(
        id: 'ch3',
        amount: 725,
        token: 'OMX',
        usdValue: 255.2,
        claimedAt: '05/03/2026 14:30',
        txHash: '0xee55...ff66',
        vestingEntryId: 'v3',
        status: LaunchpadClaimHistoryStatus.confirmed,
        gasUsed: '49,000',
      ),
    ],
  ),
];

const _batchClaimPositions = [
  LaunchpadBatchClaimPositionDraft(
    positionId: 'sp1',
    poolId: 'pool2',
    projectName: 'NexaAI Protocol',
    projectSymbol: 'NEXA',
    accent: AppColors.accent,
    rewardToken: 'NEXA',
    rewardTokenPrice: .05,
    claimableAmount: 462.5,
    claimableUsd: 23.13,
    chain: 'BSC',
    contractAddress: '0x1a2b3c4d5e6f7890abcdef1234567890abcdef12',
    stakedAmount: 2500,
    stakeToken: 'BNB',
    apy: 48,
    vestingEntries: [
      LaunchpadRewardVestingEntryDraft(
        id: 'v4',
        label: 'Week 3',
        percent: 12,
        amount: 462.5,
        token: 'NEXA',
        unlockDate: '14/03/2026',
        status: LaunchpadVestingEntryStatus.unlocking,
      ),
    ],
  ),
  LaunchpadBatchClaimPositionDraft(
    positionId: 'sp2',
    poolId: 'pool3',
    projectName: 'OmniDEX',
    projectSymbol: 'OMX',
    accent: AppColors.primary,
    rewardToken: 'OMX',
    rewardTokenPrice: .352,
    claimableAmount: 646,
    claimableUsd: 227.39,
    chain: 'Multi',
    contractAddress: '0xfedcba0987654321fedcba0987654321fedcba09',
    stakedAmount: 5000,
    stakeToken: 'USDT',
    apy: 35,
    vestingEntries: [
      LaunchpadRewardVestingEntryDraft(
        id: 'v3',
        label: 'Month 2',
        percent: 20,
        amount: 646,
        token: 'OMX',
        unlockDate: '15/03/2026',
        status: LaunchpadVestingEntryStatus.unlocking,
      ),
    ],
  ),
];

const _batchClaimSummary = LaunchpadBatchClaimSummaryDraft(
  totalClaimable: {'NEXA': 462.5, 'OMX': 646},
  totalClaimableUsd: 250.52,
  estimatedGasIndividual: r'$0.36',
  estimatedGasBatch: r'$0.24',
  gasSavingsPercent: 33,
  gasSavingsUsd: .12,
  chains: ['BSC', 'Multi'],
);

const _bridgeNetworks = [
  LaunchpadBridgeNetworkDraft(
    id: 'eth',
    name: 'Ethereum',
    symbol: 'ETH',
    accent: AppColors.accent,
    logo: 'ET',
    nativeCoin: 'ETH',
    gasEstimate: r'$2.50',
    confirmations: 12,
    averageTime: '~3 min',
  ),
  LaunchpadBridgeNetworkDraft(
    id: 'bsc',
    name: 'BNB Smart Chain',
    symbol: 'BSC',
    accent: AppColors.warn,
    logo: 'BS',
    nativeCoin: 'BNB',
    gasEstimate: r'$0.15',
    confirmations: 15,
    averageTime: '~45 sec',
  ),
  LaunchpadBridgeNetworkDraft(
    id: 'polygon',
    name: 'Polygon',
    symbol: 'MATIC',
    accent: AppColors.primary,
    logo: 'PG',
    nativeCoin: 'MATIC',
    gasEstimate: r'$0.01',
    confirmations: 128,
    averageTime: '~2 min',
  ),
];

const _swapRoutes = [
  LaunchpadSwapRouteDraft(
    id: 'route1',
    provider: 'VitBridge Aggregator',
    estimatedOutput: 8290,
    priceImpact: .12,
    gasCost: r'$2.85',
    totalFee: r'$3.50',
    estimatedTime: '~5 min',
    recommended: true,
    hops: [
      LaunchpadSwapHopDraft(
        fromToken: 'USDT',
        toToken: 'ETH',
        dex: 'Uniswap V3',
        chain: 'Ethereum',
        rate: .000385,
      ),
      LaunchpadSwapHopDraft(
        fromToken: 'ETH',
        toToken: 'USDT',
        dex: 'Bridge',
        chain: 'Polygon',
        rate: 2597,
      ),
      LaunchpadSwapHopDraft(
        fromToken: 'USDT',
        toToken: 'GCE',
        dex: 'QuickSwap',
        chain: 'Polygon',
        rate: 8.33,
      ),
    ],
  ),
  LaunchpadSwapRouteDraft(
    id: 'route2',
    provider: 'Direct Bridge',
    estimatedOutput: 8240,
    priceImpact: .18,
    gasCost: r'$0.35',
    totalFee: r'$1.20',
    estimatedTime: '~3 min',
    recommended: false,
    hops: [
      LaunchpadSwapHopDraft(
        fromToken: 'USDT',
        toToken: 'USDT',
        dex: 'Bridge',
        chain: 'Polygon',
        rate: 1,
      ),
      LaunchpadSwapHopDraft(
        fromToken: 'USDT',
        toToken: 'GCE',
        dex: 'QuickSwap',
        chain: 'Polygon',
        rate: 8.28,
      ),
    ],
  ),
  LaunchpadSwapRouteDraft(
    id: 'route3',
    provider: 'Multi-hop Route',
    estimatedOutput: 8180,
    priceImpact: .35,
    gasCost: r'$3.20',
    totalFee: r'$4.80',
    estimatedTime: '~7 min',
    recommended: false,
    hops: [
      LaunchpadSwapHopDraft(
        fromToken: 'USDT',
        toToken: 'MATIC',
        dex: 'Uniswap V3',
        chain: 'Ethereum',
        rate: 1.82,
      ),
      LaunchpadSwapHopDraft(
        fromToken: 'MATIC',
        toToken: 'MATIC',
        dex: 'Bridge',
        chain: 'Polygon',
        rate: 1,
      ),
      LaunchpadSwapHopDraft(
        fromToken: 'MATIC',
        toToken: 'GCE',
        dex: 'SushiSwap',
        chain: 'Polygon',
        rate: 4.55,
      ),
    ],
  ),
];

const _bridgeSortOptions = [
  LaunchpadBridgeSortOptionDraft(
    value: 'recommended',
    label: 'Khuyến nghị',
    iconKey: 'star',
  ),
  LaunchpadBridgeSortOptionDraft(
    value: 'output',
    label: 'Output cao nhất',
    iconKey: 'trending',
  ),
  LaunchpadBridgeSortOptionDraft(
    value: 'fee',
    label: 'Phí thấp nhất',
    iconKey: 'fuel',
  ),
  LaunchpadBridgeSortOptionDraft(
    value: 'speed',
    label: 'Nhanh nhất',
    iconKey: 'clock',
  ),
  LaunchpadBridgeSortOptionDraft(
    value: 'security',
    label: 'An toàn nhất',
    iconKey: 'shield',
  ),
];

const _bridgeComparison = LaunchpadBridgeComparisonDraft(
  id: 'comp_static',
  timestamp: '04/03/2026 23:38',
  sourceChain: 'Ethereum',
  targetChain: 'Polygon',
  inputToken: 'USDT',
  outputToken: 'GCE',
  inputAmount: 1000,
  bestOutput: 'rc_1',
  bestFee: 'rc_2',
  bestSpeed: 'rc_2',
  bestSecurity: 'rc_1',
  routes: [
    LaunchpadBridgeRouteOptionDraft(
      id: 'rc_1',
      provider: 'VitBridge Aggregator',
      providerIcon: 'VB',
      accent: AppColors.primary,
      sourceChain: 'Ethereum',
      targetChain: 'Polygon',
      inputToken: 'USDT',
      outputToken: 'GCE',
      inputAmount: 1000,
      outputAmount: 8290,
      priceImpact: .12,
      gasCost: 2.85,
      bridgeFee: .65,
      totalFee: 3.50,
      totalFeeUsd: r'$3.50',
      estimatedTime: '~5 min',
      estimatedSeconds: 300,
      hops: 3,
      securityScore: 95,
      liquidityDepth: r'$12.4M',
      slippage: .3,
      recommended: true,
      tags: ['Best output', 'Most secure', 'Audited'],
      warnings: [],
      path: [
        LaunchpadSwapHopDraft(
          fromToken: 'USDT',
          toToken: 'ETH',
          dex: 'Uniswap V3',
          chain: 'Ethereum',
          rate: .000385,
        ),
        LaunchpadSwapHopDraft(
          fromToken: 'ETH',
          toToken: 'USDT',
          dex: 'Bridge',
          chain: 'Polygon',
          rate: 2597,
        ),
        LaunchpadSwapHopDraft(
          fromToken: 'USDT',
          toToken: 'GCE',
          dex: 'QuickSwap',
          chain: 'Polygon',
          rate: 8.33,
        ),
      ],
    ),
    LaunchpadBridgeRouteOptionDraft(
      id: 'rc_2',
      provider: 'Direct Bridge',
      providerIcon: 'DB',
      accent: AppColors.buy,
      sourceChain: 'Ethereum',
      targetChain: 'Polygon',
      inputToken: 'USDT',
      outputToken: 'GCE',
      inputAmount: 1000,
      outputAmount: 8240,
      priceImpact: .18,
      gasCost: .35,
      bridgeFee: .85,
      totalFee: 1.20,
      totalFeeUsd: r'$1.20',
      estimatedTime: '~3 min',
      estimatedSeconds: 180,
      hops: 2,
      securityScore: 88,
      liquidityDepth: r'$8.1M',
      slippage: .5,
      recommended: false,
      tags: ['Lowest fee', 'Fastest'],
      warnings: [],
      path: [
        LaunchpadSwapHopDraft(
          fromToken: 'USDT',
          toToken: 'USDT',
          dex: 'Bridge',
          chain: 'Polygon',
          rate: 1,
        ),
        LaunchpadSwapHopDraft(
          fromToken: 'USDT',
          toToken: 'GCE',
          dex: 'QuickSwap',
          chain: 'Polygon',
          rate: 8.28,
        ),
      ],
    ),
    LaunchpadBridgeRouteOptionDraft(
      id: 'rc_3',
      provider: 'Multi-hop Route',
      providerIcon: 'MH',
      accent: AppColors.warn,
      sourceChain: 'Ethereum',
      targetChain: 'Polygon',
      inputToken: 'USDT',
      outputToken: 'GCE',
      inputAmount: 1000,
      outputAmount: 8180,
      priceImpact: .35,
      gasCost: 3.20,
      bridgeFee: 1.60,
      totalFee: 4.80,
      totalFeeUsd: r'$4.80',
      estimatedTime: '~7 min',
      estimatedSeconds: 420,
      hops: 3,
      securityScore: 82,
      liquidityDepth: r'$5.6M',
      slippage: .8,
      recommended: false,
      tags: [],
      warnings: ['Higher price impact'],
      path: [
        LaunchpadSwapHopDraft(
          fromToken: 'USDT',
          toToken: 'MATIC',
          dex: 'Uniswap V3',
          chain: 'Ethereum',
          rate: 1.82,
        ),
        LaunchpadSwapHopDraft(
          fromToken: 'MATIC',
          toToken: 'MATIC',
          dex: 'Bridge',
          chain: 'Polygon',
          rate: 1,
        ),
        LaunchpadSwapHopDraft(
          fromToken: 'MATIC',
          toToken: 'GCE',
          dex: 'SushiSwap',
          chain: 'Polygon',
          rate: 4.55,
        ),
      ],
    ),
    LaunchpadBridgeRouteOptionDraft(
      id: 'rc_4',
      provider: 'LayerZero',
      providerIcon: 'LZ',
      accent: AppColors.primarySoft,
      sourceChain: 'Ethereum',
      targetChain: 'Polygon',
      inputToken: 'USDT',
      outputToken: 'GCE',
      inputAmount: 1000,
      outputAmount: 8260,
      priceImpact: .15,
      gasCost: 1.80,
      bridgeFee: 1.20,
      totalFee: 3.00,
      totalFeeUsd: r'$3.00',
      estimatedTime: '~4 min',
      estimatedSeconds: 240,
      hops: 2,
      securityScore: 92,
      liquidityDepth: r'$18.2M',
      slippage: .4,
      recommended: false,
      tags: ['High security', 'Deep liquidity'],
      warnings: [],
      path: [
        LaunchpadSwapHopDraft(
          fromToken: 'USDT',
          toToken: 'USDT',
          dex: 'LayerZero OFT',
          chain: 'Polygon',
          rate: .998,
        ),
        LaunchpadSwapHopDraft(
          fromToken: 'USDT',
          toToken: 'GCE',
          dex: 'Balancer',
          chain: 'Polygon',
          rate: 8.28,
        ),
      ],
    ),
    LaunchpadBridgeRouteOptionDraft(
      id: 'rc_5',
      provider: 'Wormhole',
      providerIcon: 'WH',
      accent: AppColors.accent,
      sourceChain: 'Ethereum',
      targetChain: 'Polygon',
      inputToken: 'USDT',
      outputToken: 'GCE',
      inputAmount: 1000,
      outputAmount: 8210,
      priceImpact: .22,
      gasCost: 2.10,
      bridgeFee: .90,
      totalFee: 3.00,
      totalFeeUsd: r'$3.00',
      estimatedTime: '~6 min',
      estimatedSeconds: 360,
      hops: 2,
      securityScore: 90,
      liquidityDepth: r'$15.7M',
      slippage: .5,
      recommended: false,
      tags: ['Trusted bridge'],
      warnings: [],
      path: [
        LaunchpadSwapHopDraft(
          fromToken: 'USDT',
          toToken: 'USDT',
          dex: 'Wormhole',
          chain: 'Polygon',
          rate: .997,
        ),
        LaunchpadSwapHopDraft(
          fromToken: 'USDT',
          toToken: 'GCE',
          dex: 'Curve',
          chain: 'Polygon',
          rate: 8.24,
        ),
      ],
    ),
  ],
);

const _notifSoundTypes = [
  LaunchpadSoundTypeDraft(value: 'default', label: 'Mặc định'),
  LaunchpadSoundTypeDraft(value: 'chime', label: 'Chime'),
  LaunchpadSoundTypeDraft(value: 'bell', label: 'Chuông'),
  LaunchpadSoundTypeDraft(value: 'ping', label: 'Ping'),
  LaunchpadSoundTypeDraft(value: 'none', label: 'Không âm'),
];

const _notifSoundCategories = [
  LaunchpadNotifSoundCategoryDraft(
    id: 'price_alert',
    label: 'Cảnh báo giá',
    description: 'Âm thanh khi giá đến ngưỡng đã đặt',
    iconKey: 'chart',
    accent: AppColors.accent,
    enabled: true,
    soundType: 'chime',
    volume: 80,
  ),
  LaunchpadNotifSoundCategoryDraft(
    id: 'order_fill',
    label: 'Lệnh khớp',
    description: 'Âm thanh khi lệnh được thực thi',
    iconKey: 'check',
    accent: AppColors.buy,
    enabled: true,
    soundType: 'bell',
    volume: 90,
  ),
  LaunchpadNotifSoundCategoryDraft(
    id: 'vesting_unlock',
    label: 'Mở khóa vesting',
    description: 'Âm thanh khi token được mở khóa',
    iconKey: 'unlock',
    accent: AppColors.accent,
    enabled: true,
    soundType: 'default',
    volume: 70,
  ),
  LaunchpadNotifSoundCategoryDraft(
    id: 'bridge_complete',
    label: 'Bridge hoàn thành',
    description: 'Âm thanh khi bridge tx xong',
    iconKey: 'bridge',
    accent: AppColors.warn,
    enabled: true,
    soundType: 'ping',
    volume: 75,
  ),
  LaunchpadNotifSoundCategoryDraft(
    id: 'staking_reward',
    label: 'Phần thưởng staking',
    description: 'Âm thanh khi nhận reward từ pool',
    iconKey: 'gift',
    accent: AppColors.primarySoft,
    enabled: false,
    soundType: 'chime',
    volume: 60,
  ),
  LaunchpadNotifSoundCategoryDraft(
    id: 'security_alert',
    label: 'Cảnh báo bảo mật',
    description: 'Âm thanh cho thông báo bảo mật',
    iconKey: 'shield',
    accent: AppColors.sell,
    enabled: true,
    soundType: 'bell',
    volume: 100,
  ),
  LaunchpadNotifSoundCategoryDraft(
    id: 'p2p_message',
    label: 'Tin nhắn P2P',
    description: 'Âm thanh khi có tin nhắn mới trong order room',
    iconKey: 'chat',
    accent: AppColors.primary,
    enabled: true,
    soundType: 'default',
    volume: 70,
  ),
  LaunchpadNotifSoundCategoryDraft(
    id: 'system',
    label: 'Hệ thống',
    description: 'Thông báo chung và cập nhật hệ thống',
    iconKey: 'settings',
    accent: AppColors.text2,
    enabled: false,
    soundType: 'none',
    volume: 50,
  ),
];

const _eventLogExportFormats = [
  LaunchpadEventLogExportFormatDraft(
    value: 'text',
    label: 'Text',
    iconKey: 'text',
  ),
  LaunchpadEventLogExportFormatDraft(
    value: 'json',
    label: 'JSON',
    iconKey: 'json',
  ),
  LaunchpadEventLogExportFormatDraft(
    value: 'csv',
    label: 'CSV',
    iconKey: 'csv',
  ),
];

const _eventLogEntries = [
  LaunchpadEventLogEntryDraft(
    id: 'ev01',
    timestamp: '23:36:08',
    level: LaunchpadEventLogLevel.info,
    source: 'Bridge',
    message: 'Bridge transaction initiated',
    details: 'USDT -> GCE via VitBridge on Polygon',
    txHash: '0x7a3f...8d2c',
    chain: 'Polygon',
    gasUsed: '124,500',
    blockNumber: 58234102,
    tags: ['bridge', 'initiate'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev02',
    timestamp: '23:36:13',
    level: LaunchpadEventLogLevel.success,
    source: 'Bridge',
    message: 'Token approval confirmed',
    details: 'Approved 1,000 USDT for VitBridge router',
    txHash: '0x9b1e...f4a8',
    chain: 'Ethereum',
    gasUsed: '46,200',
    blockNumber: 19284531,
    tags: ['approval', 'bridge'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev03',
    timestamp: '23:36:28',
    level: LaunchpadEventLogLevel.tx,
    source: 'Contract',
    message: 'stake() executed on NexaAI Pool',
    details: 'Staked 500 NEXA tokens for 90-day lock',
    txHash: '0x2c8d...1a7f',
    chain: 'BSC',
    contractAddress: '0x1234...abcd',
    gasUsed: '89,340',
    blockNumber: 38291042,
    tags: ['staking', 'contract'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev04',
    timestamp: '23:36:48',
    level: LaunchpadEventLogLevel.warning,
    source: 'ABI Scanner',
    message: 'Proxy upgrade detected',
    details:
        'Contract 0x1234...abcd has been upgraded. New implementation: 0x5678...efgh',
    chain: 'BSC',
    contractAddress: '0x1234...abcd',
    blockNumber: 38291100,
    tags: ['proxy', 'upgrade', 'security'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev05',
    timestamp: '23:36:53',
    level: LaunchpadEventLogLevel.info,
    source: 'Staking',
    message: 'Reward accrual checkpoint',
    details: 'Earned 12.5 NEXA rewards since last checkpoint',
    chain: 'BSC',
    tags: ['staking', 'reward'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev06',
    timestamp: '23:37:08',
    level: LaunchpadEventLogLevel.success,
    source: 'Claim',
    message: 'Batch claim executed successfully',
    details: '3 positions claimed: 45.2 NEXA + 120 GCE + 8.5 SOLAR',
    txHash: '0xf3e1...6b9d',
    chain: 'BSC',
    gasUsed: '245,800',
    blockNumber: 38291200,
    tags: ['claim', 'batch'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev07',
    timestamp: '23:37:23',
    level: LaunchpadEventLogLevel.error,
    source: 'Bridge',
    message: 'Bridge transaction failed',
    details: 'Insufficient liquidity on target chain. Refund initiated.',
    txHash: '0xd4a2...3c5e',
    chain: 'Polygon',
    gasUsed: '78,100',
    blockNumber: 58234300,
    tags: ['bridge', 'error', 'refund'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev08',
    timestamp: '23:37:38',
    level: LaunchpadEventLogLevel.debug,
    source: 'WebSocket',
    message: 'Connection state: reconnecting',
    details: 'WS endpoint wss://events.launchpad.io - retry attempt 2/5',
    tags: ['ws', 'connection'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev09',
    timestamp: '23:37:48',
    level: LaunchpadEventLogLevel.success,
    source: 'WebSocket',
    message: 'Connection restored',
    details: 'WS reconnected successfully after 8.2s downtime',
    tags: ['ws', 'connection'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev10',
    timestamp: '23:37:53',
    level: LaunchpadEventLogLevel.tx,
    source: 'Contract',
    message: 'claimRewards() called',
    details: 'Claimed 25.8 NEXA from Launchpool #1',
    txHash: '0xa1b2...c3d4',
    chain: 'BSC',
    contractAddress: '0x1234...abcd',
    gasUsed: '67,200',
    blockNumber: 38291350,
    tags: ['claim', 'contract'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev11',
    timestamp: '23:37:58',
    level: LaunchpadEventLogLevel.info,
    source: 'Price',
    message: r'Price alert triggered: NEXA > $0.12',
    details: r'NEXA price reached $0.124 (+8.7% in 1h)',
    tags: ['price', 'alert'],
  ),
  LaunchpadEventLogEntryDraft(
    id: 'ev12',
    timestamp: '23:38:03',
    level: LaunchpadEventLogLevel.warning,
    source: 'Security',
    message: 'New login detected from unfamiliar device',
    details: 'IP: 103.xxx.xxx.xx - Chrome/MacOS. Verify if this was you.',
    tags: ['security', 'login'],
  ),
];

const _abiDiffResult = LaunchpadAbiDiffResultDraft(
  contractAddress: '0x1234567890abcdef1234567890abcdef12345678',
  chain: 'BSC',
  oldImpl: '0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
  newImpl: '0xBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
  oldImplLabel: 'v1.2.0 (14/02/2026)',
  newImplLabel: 'v1.3.0 (05/03/2026)',
  upgradeBlock: 38291100,
  upgradeTimestamp: '05/03/2026 14:32 UTC',
  upgradeTxHash: '0xf9e8d7c6b5a493827160c1b0',
  totalFunctionsOld: 12,
  totalFunctionsNew: 14,
  totalEventsOld: 8,
  totalEventsNew: 10,
  added: 5,
  removed: 2,
  modified: 2,
  unchanged: 5,
  riskScore: 72,
  entries: [
    LaunchpadAbiDiffEntryDraft(
      name: 'stake',
      type: 'function',
      changeType: LaunchpadAbiChangeType.unchanged,
      oldSignature: 'stake(uint256 amount) -> bool',
      newSignature: 'stake(uint256 amount) -> bool',
      riskLevel: LaunchpadAbiRiskLevel.none,
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'unstake',
      type: 'function',
      changeType: LaunchpadAbiChangeType.modified,
      oldSignature: 'unstake(uint256 amount) -> bool',
      newSignature: 'unstake(uint256 amount, bool emergency) -> bool',
      oldStateMutability: 'nonpayable',
      newStateMutability: 'nonpayable',
      riskLevel: LaunchpadAbiRiskLevel.medium,
      riskNote: 'Parameter added - emergency unstake bypass may skip cooldown.',
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'claimRewards',
      type: 'function',
      changeType: LaunchpadAbiChangeType.unchanged,
      oldSignature: 'claimRewards() -> uint256',
      newSignature: 'claimRewards() -> uint256',
      riskLevel: LaunchpadAbiRiskLevel.none,
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'batchClaim',
      type: 'function',
      changeType: LaunchpadAbiChangeType.added,
      newSignature: 'batchClaim(uint256[] positionIds) -> uint256[]',
      newVisibility: 'external',
      newStateMutability: 'nonpayable',
      riskLevel: LaunchpadAbiRiskLevel.low,
      riskNote: 'New batch claim - reduces gas for multi-position users.',
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'setEmergencyAdmin',
      type: 'function',
      changeType: LaunchpadAbiChangeType.added,
      newSignature: 'setEmergencyAdmin(address admin) -> void',
      newVisibility: 'external',
      newStateMutability: 'nonpayable',
      riskLevel: LaunchpadAbiRiskLevel.critical,
      riskNote:
          'New admin function - can set emergency admin who may bypass governance.',
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'pause',
      type: 'function',
      changeType: LaunchpadAbiChangeType.modified,
      oldSignature: 'pause() -> void',
      newSignature: 'pause(string reason) -> void',
      oldVisibility: 'external',
      newVisibility: 'external',
      riskLevel: LaunchpadAbiRiskLevel.low,
      riskNote: 'Added reason parameter for audit trail.',
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'getRewardRate',
      type: 'function',
      changeType: LaunchpadAbiChangeType.unchanged,
      oldSignature: 'getRewardRate() -> uint256',
      newSignature: 'getRewardRate() -> uint256',
      oldStateMutability: 'view',
      newStateMutability: 'view',
      riskLevel: LaunchpadAbiRiskLevel.none,
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'getPoolInfo',
      type: 'function',
      changeType: LaunchpadAbiChangeType.unchanged,
      oldSignature: 'getPoolInfo(uint256 pid) -> PoolInfo',
      newSignature: 'getPoolInfo(uint256 pid) -> PoolInfo',
      riskLevel: LaunchpadAbiRiskLevel.none,
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'migratePositions',
      type: 'function',
      changeType: LaunchpadAbiChangeType.added,
      newSignature: 'migratePositions(address from, address to) -> bool',
      newVisibility: 'external',
      newStateMutability: 'nonpayable',
      riskLevel: LaunchpadAbiRiskLevel.high,
      riskNote:
          'Position migration - could transfer positions without consent if admin compromised.',
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'withdrawFees',
      type: 'function',
      changeType: LaunchpadAbiChangeType.removed,
      oldSignature: 'withdrawFees(address token, uint256 amount) -> bool',
      oldVisibility: 'external',
      riskLevel: LaunchpadAbiRiskLevel.medium,
      riskNote: 'Fee withdrawal removed - fees may now be handled differently.',
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'Staked',
      type: 'event',
      changeType: LaunchpadAbiChangeType.unchanged,
      oldSignature: 'Staked(address indexed user, uint256 amount)',
      newSignature: 'Staked(address indexed user, uint256 amount)',
      riskLevel: LaunchpadAbiRiskLevel.none,
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'EmergencyUnstake',
      type: 'event',
      changeType: LaunchpadAbiChangeType.added,
      newSignature:
          'EmergencyUnstake(address indexed user, uint256 amount, bool penalized)',
      riskLevel: LaunchpadAbiRiskLevel.low,
      riskNote: 'New event for emergency unstake tracking.',
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'AdminChanged',
      type: 'event',
      changeType: LaunchpadAbiChangeType.added,
      newSignature:
          'AdminChanged(address indexed oldAdmin, address indexed newAdmin)',
      riskLevel: LaunchpadAbiRiskLevel.medium,
      riskNote: 'Tracks admin changes - important for governance monitoring.',
    ),
    LaunchpadAbiDiffEntryDraft(
      name: 'FeeWithdrawn',
      type: 'event',
      changeType: LaunchpadAbiChangeType.removed,
      oldSignature:
          'FeeWithdrawn(address indexed token, uint256 amount, address indexed to)',
      riskLevel: LaunchpadAbiRiskLevel.low,
    ),
  ],
);

const _launchpadWalletAddresses = [
  LaunchpadWalletAddressDraft(
    id: 'w1',
    label: 'Vi chinh',
    address: '0x742d35Cc6634C0532925a3b844Bc9e7595f2bD68',
    chain: 'Ethereum',
    accent: AppColors.accent,
    iconKey: 'eth',
    isDefault: true,
    isFavorite: true,
    lastUsed: '07/03/2026 08:15',
    usageCount: 47,
    notes: 'Vi MetaMask chinh, dung cho mua IDO',
    tags: ['main', 'ido'],
    createdAt: '01/01/2026',
    verified: true,
  ),
  LaunchpadWalletAddressDraft(
    id: 'w2',
    label: 'Vi BSC',
    address: '0x8Ba1f109551bD432803012645Ac136ddd64DBA72',
    chain: 'BSC',
    accent: AppColors.warn,
    iconKey: 'bsc',
    isDefault: false,
    isFavorite: true,
    lastUsed: '06/03/2026 14:30',
    usageCount: 32,
    notes: 'Vi BNB cho staking va launchpool',
    tags: ['staking', 'launchpool'],
    createdAt: '15/01/2026',
    verified: true,
  ),
  LaunchpadWalletAddressDraft(
    id: 'w4',
    label: 'Hardware Wallet',
    address: '0xbDA5747bFD65F08deb54cb465eB87D40e51B197E',
    chain: 'Ethereum',
    accent: AppColors.accent,
    iconKey: 'eth',
    isDefault: false,
    isFavorite: true,
    lastUsed: '04/03/2026 11:20',
    usageCount: 8,
    notes: 'Ledger Nano X chi dung cho giao dich lon',
    tags: ['hardware', 'cold'],
    createdAt: '10/01/2026',
    verified: true,
  ),
  LaunchpadWalletAddressDraft(
    id: 'w6',
    label: 'Vi test DeFi',
    address: '0xDf3B3a3b8E6b12c04e81eb5f4C85e8E8A58796d1',
    chain: 'BSC',
    accent: AppColors.warn,
    iconKey: 'bsc',
    isDefault: false,
    isFavorite: false,
    lastUsed: '01/03/2026 16:00',
    usageCount: 22,
    notes: 'Chi dung cho test smart contract',
    tags: ['test', 'defi'],
    createdAt: '05/02/2026',
    verified: true,
  ),
  LaunchpadWalletAddressDraft(
    id: 'w3',
    label: 'Vi Polygon',
    address: '0x2546BcD3c84621e976D8185a91A922aE77ECEc30',
    chain: 'Polygon',
    accent: AppColors.accent,
    iconKey: 'polygon',
    isDefault: false,
    isFavorite: false,
    lastUsed: '05/03/2026 09:45',
    usageCount: 15,
    notes: 'Cho bridge va DEX trades',
    tags: ['bridge', 'dex'],
    createdAt: '01/02/2026',
    verified: true,
  ),
  LaunchpadWalletAddressDraft(
    id: 'w5',
    label: 'Vi Arbitrum',
    address: '0xcd3B766CCDd6AE721141F452C550Ca635964ce71',
    chain: 'Arbitrum',
    accent: AppColors.primary,
    iconKey: 'arbitrum',
    isDefault: false,
    isFavorite: false,
    usageCount: 3,
    tags: ['l2'],
    createdAt: '20/02/2026',
    verified: false,
  ),
];

const _launchpadWebhookEvents = [
  LaunchpadWebhookEventDraft(
    type: 'Transfer',
    label: 'Transfer',
    description: 'Token transfers (ERC20/721)',
    accent: AppColors.primary,
  ),
  LaunchpadWebhookEventDraft(
    type: 'Approval',
    label: 'Approval',
    description: 'Token approval changes',
    accent: AppColors.warn,
  ),
  LaunchpadWebhookEventDraft(
    type: 'Staked',
    label: 'Staked',
    description: 'Staking deposits',
    accent: AppColors.buy,
  ),
  LaunchpadWebhookEventDraft(
    type: 'Withdrawn',
    label: 'Withdrawn',
    description: 'Staking withdrawals',
    accent: AppColors.sell,
  ),
  LaunchpadWebhookEventDraft(
    type: 'RewardPaid',
    label: 'RewardPaid',
    description: 'Reward distributions',
    accent: AppColors.accent,
  ),
  LaunchpadWebhookEventDraft(
    type: 'OwnershipTransferred',
    label: 'OwnershipTransferred',
    description: 'Ownership changes',
    accent: AppColors.accent,
  ),
  LaunchpadWebhookEventDraft(
    type: 'Paused',
    label: 'Paused',
    description: 'Contract paused',
    accent: AppColors.warn,
  ),
  LaunchpadWebhookEventDraft(
    type: 'Unpaused',
    label: 'Unpaused',
    description: 'Contract unpaused',
    accent: AppColors.buy,
  ),
  LaunchpadWebhookEventDraft(
    type: 'ProxyUpgraded',
    label: 'ProxyUpgraded',
    description: 'Implementation changed',
    accent: AppColors.sell,
  ),
];

const _launchpadWebhookSubscriptions = [
  LaunchpadWebhookSubscriptionDraft(
    id: 'wh1',
    label: 'NexaAI Staking Events',
    contractAddress: '0x1a2b3c4d5e6f7890abcdef1234567890abcdef12',
    chain: 'BSC',
    accent: AppColors.warn,
    eventTypes: ['Staked', 'Withdrawn', 'RewardPaid'],
    webhookUrl: 'https://api.myapp.io/webhooks/nexa-staking',
    secret: 'whsec_xxx...xxx',
    status: LaunchpadWebhookStatus.active,
    createdAt: '01/03/2026',
    lastTriggered: '07/03/2026 09:15',
    triggerCount: 142,
    errorCount: 2,
    filters: [],
    retryPolicy: LaunchpadWebhookRetryPolicy.exponential,
    maxRetries: 3,
  ),
  LaunchpadWebhookSubscriptionDraft(
    id: 'wh2',
    label: 'GCE Token Transfers',
    contractAddress: '0x9876543210abcdef9876543210abcdef98765432',
    chain: 'Polygon',
    accent: AppColors.accent,
    eventTypes: ['Transfer', 'Approval'],
    webhookUrl: 'https://api.myapp.io/webhooks/gce-transfers',
    status: LaunchpadWebhookStatus.active,
    createdAt: '03/03/2026',
    lastTriggered: '07/03/2026 08:45',
    triggerCount: 89,
    errorCount: 0,
    filters: [
      LaunchpadWebhookFilterDraft(
        field: 'value',
        operator: 'gt',
        value: '1000',
      ),
    ],
    retryPolicy: LaunchpadWebhookRetryPolicy.linear,
    maxRetries: 5,
  ),
  LaunchpadWebhookSubscriptionDraft(
    id: 'wh3',
    label: 'Security Monitor',
    contractAddress: '0x1a2b3c4d5e6f7890abcdef1234567890abcdef12',
    chain: 'BSC',
    accent: AppColors.warn,
    eventTypes: ['OwnershipTransferred', 'Paused', 'ProxyUpgraded'],
    webhookUrl: 'https://alerts.myapp.io/security',
    status: LaunchpadWebhookStatus.error,
    createdAt: '28/02/2026',
    lastTriggered: '05/03/2026 14:32',
    triggerCount: 5,
    errorCount: 3,
    lastError: 'Connection refused: target server unreachable',
    filters: [],
    retryPolicy: LaunchpadWebhookRetryPolicy.exponential,
    maxRetries: 3,
  ),
  LaunchpadWebhookSubscriptionDraft(
    id: 'wh4',
    label: 'IDO Participation Tracker',
    contractAddress: '0xabcdef1234567890abcdef1234567890abcdef12',
    chain: 'Ethereum',
    accent: AppColors.primary,
    eventTypes: ['Transfer'],
    webhookUrl: 'https://api.myapp.io/webhooks/ido-track',
    status: LaunchpadWebhookStatus.paused,
    createdAt: '15/02/2026',
    triggerCount: 234,
    errorCount: 1,
    filters: [],
    retryPolicy: LaunchpadWebhookRetryPolicy.none,
    maxRetries: 0,
  ),
];

const _launchpadWebhookDeliveries = [
  LaunchpadWebhookDeliveryDraft(
    id: 'wd1',
    subscriptionId: 'wh1',
    eventType: 'Staked',
    timestamp: '07/03/2026 09:15:32',
    status: LaunchpadWebhookDeliveryStatus.delivered,
    statusCode: 200,
    responseTime: 145,
    payload: '{"event":"Staked","user":"0x742d...bD68","amount":"500"}',
    txHash: '0xab12...cd34',
    blockNumber: 38291500,
    retryCount: 0,
  ),
  LaunchpadWebhookDeliveryDraft(
    id: 'wd2',
    subscriptionId: 'wh1',
    eventType: 'RewardPaid',
    timestamp: '07/03/2026 08:30:12',
    status: LaunchpadWebhookDeliveryStatus.delivered,
    statusCode: 200,
    responseTime: 98,
    payload: '{"event":"RewardPaid","user":"0x742d...bD68","amount":"12.5"}',
    txHash: '0xef56...gh78',
    blockNumber: 38291480,
    retryCount: 0,
  ),
  LaunchpadWebhookDeliveryDraft(
    id: 'wd3',
    subscriptionId: 'wh2',
    eventType: 'Transfer',
    timestamp: '07/03/2026 08:45:55',
    status: LaunchpadWebhookDeliveryStatus.delivered,
    statusCode: 200,
    responseTime: 212,
    payload:
        '{"event":"Transfer","from":"0x0000...0000","to":"0x8Ba1...BA72","value":"5000"}',
    txHash: '0xij90...kl12',
    blockNumber: 58234500,
    retryCount: 0,
  ),
  LaunchpadWebhookDeliveryDraft(
    id: 'wd4',
    subscriptionId: 'wh3',
    eventType: 'ProxyUpgraded',
    timestamp: '05/03/2026 14:32:08',
    status: LaunchpadWebhookDeliveryStatus.failed,
    statusCode: 502,
    responseTime: 5000,
    payload: '{"event":"ProxyUpgraded","implementation":"0xBBBB...BBBB"}',
    txHash: '0xmn34...op56',
    blockNumber: 38291100,
    retryCount: 3,
  ),
  LaunchpadWebhookDeliveryDraft(
    id: 'wd5',
    subscriptionId: 'wh1',
    eventType: 'Withdrawn',
    timestamp: '06/03/2026 16:22:41',
    status: LaunchpadWebhookDeliveryStatus.delivered,
    statusCode: 200,
    responseTime: 167,
    payload: '{"event":"Withdrawn","user":"0xcd3B...ce71","amount":"1000"}',
    txHash: '0xqr78...st90',
    blockNumber: 38291450,
    retryCount: 0,
  ),
  LaunchpadWebhookDeliveryDraft(
    id: 'wd6',
    subscriptionId: 'wh3',
    eventType: 'Paused',
    timestamp: '04/03/2026 22:10:05',
    status: LaunchpadWebhookDeliveryStatus.failed,
    statusCode: 0,
    responseTime: 30000,
    payload: '{"event":"Paused","reason":"scheduled-maintenance"}',
    blockNumber: 38291000,
    retryCount: 3,
  ),
];

const _launchpadGasPrices = [
  LaunchpadGasPriceDraft(
    chain: 'Ethereum',
    accent: AppColors.accent,
    chainIcon: 'ET',
    slow: 12,
    standard: 18,
    fast: 25,
    instant: 35,
    unit: 'Gwei',
    baseFee: 15,
    priorityFee: 3,
    lastUpdated: '07/03/2026 10:30',
    trend: LaunchpadGasTrend.down,
    change24h: -12.5,
  ),
  LaunchpadGasPriceDraft(
    chain: 'BSC',
    accent: AppColors.warn,
    chainIcon: 'BS',
    slow: 3,
    standard: 5,
    fast: 7,
    instant: 10,
    unit: 'Gwei',
    lastUpdated: '07/03/2026 10:30',
    trend: LaunchpadGasTrend.stable,
    change24h: 2.1,
  ),
  LaunchpadGasPriceDraft(
    chain: 'Polygon',
    accent: AppColors.accent,
    chainIcon: 'PG',
    slow: 30,
    standard: 45,
    fast: 80,
    instant: 120,
    unit: 'Gwei',
    lastUpdated: '07/03/2026 10:30',
    trend: LaunchpadGasTrend.up,
    change24h: 18.3,
  ),
  LaunchpadGasPriceDraft(
    chain: 'Arbitrum',
    accent: AppColors.primary,
    chainIcon: 'AR',
    slow: .1,
    standard: .15,
    fast: .25,
    instant: .4,
    unit: 'Gwei',
    lastUpdated: '07/03/2026 10:30',
    trend: LaunchpadGasTrend.down,
    change24h: -5.2,
  ),
  LaunchpadGasPriceDraft(
    chain: 'Avalanche',
    accent: AppColors.sell,
    chainIcon: 'AV',
    slow: 25,
    standard: 30,
    fast: 40,
    instant: 55,
    unit: 'nAVAX',
    lastUpdated: '07/03/2026 10:30',
    trend: LaunchpadGasTrend.stable,
    change24h: .8,
  ),
];

const _launchpadGasEstimates = [
  LaunchpadGasEstimateDraft(
    operation: 'ERC20 Transfer',
    gasUnits: 65000,
    costs: [
      LaunchpadGasEstimateCostDraft(
        chain: 'Ethereum',
        slow: r'$0.94',
        standard: r'$1.40',
        fast: r'$1.95',
      ),
      LaunchpadGasEstimateCostDraft(
        chain: 'BSC',
        slow: r'$0.04',
        standard: r'$0.06',
        fast: r'$0.09',
      ),
      LaunchpadGasEstimateCostDraft(
        chain: 'Polygon',
        slow: '<\$0.01',
        standard: '<\$0.01',
        fast: r'$0.01',
      ),
    ],
  ),
  LaunchpadGasEstimateDraft(
    operation: 'ERC20 Approve',
    gasUnits: 46000,
    costs: [
      LaunchpadGasEstimateCostDraft(
        chain: 'Ethereum',
        slow: r'$0.66',
        standard: r'$0.99',
        fast: r'$1.38',
      ),
      LaunchpadGasEstimateCostDraft(
        chain: 'BSC',
        slow: r'$0.03',
        standard: r'$0.04',
        fast: r'$0.06',
      ),
      LaunchpadGasEstimateCostDraft(
        chain: 'Polygon',
        slow: '<\$0.01',
        standard: '<\$0.01',
        fast: '<\$0.01',
      ),
    ],
  ),
  LaunchpadGasEstimateDraft(
    operation: 'Stake',
    gasUnits: 120000,
    costs: [
      LaunchpadGasEstimateCostDraft(
        chain: 'Ethereum',
        slow: r'$1.73',
        standard: r'$2.59',
        fast: r'$3.60',
      ),
      LaunchpadGasEstimateCostDraft(
        chain: 'BSC',
        slow: r'$0.07',
        standard: r'$0.11',
        fast: r'$0.16',
      ),
      LaunchpadGasEstimateCostDraft(
        chain: 'Polygon',
        slow: '<\$0.01',
        standard: r'$0.01',
        fast: r'$0.02',
      ),
    ],
  ),
  LaunchpadGasEstimateDraft(
    operation: 'Claim Rewards',
    gasUnits: 85000,
    costs: [
      LaunchpadGasEstimateCostDraft(
        chain: 'Ethereum',
        slow: r'$1.22',
        standard: r'$1.84',
        fast: r'$2.55',
      ),
      LaunchpadGasEstimateCostDraft(
        chain: 'BSC',
        slow: r'$0.05',
        standard: r'$0.08',
        fast: r'$0.11',
      ),
      LaunchpadGasEstimateCostDraft(
        chain: 'Polygon',
        slow: '<\$0.01',
        standard: '<\$0.01',
        fast: r'$0.01',
      ),
    ],
  ),
  LaunchpadGasEstimateDraft(
    operation: 'Bridge (cross-chain)',
    gasUnits: 250000,
    costs: [
      LaunchpadGasEstimateCostDraft(
        chain: 'Ethereum',
        slow: r'$3.60',
        standard: r'$5.40',
        fast: r'$7.50',
      ),
      LaunchpadGasEstimateCostDraft(
        chain: 'BSC',
        slow: r'$0.14',
        standard: r'$0.24',
        fast: r'$0.33',
      ),
      LaunchpadGasEstimateCostDraft(
        chain: 'Polygon',
        slow: r'$0.02',
        standard: r'$0.03',
        fast: r'$0.05',
      ),
    ],
  ),
];

const _launchpadGasAlerts = [
  LaunchpadGasAlertDraft(
    id: 'ga1',
    chain: 'Ethereum',
    accent: AppColors.accent,
    threshold: 15,
    direction: LaunchpadGasAlertDirection.below,
    unit: 'Gwei',
    enabled: true,
    lastTriggered: '07/03/2026 03:15',
    triggerCount: 3,
  ),
  LaunchpadGasAlertDraft(
    id: 'ga2',
    chain: 'Ethereum',
    accent: AppColors.accent,
    threshold: 50,
    direction: LaunchpadGasAlertDirection.above,
    unit: 'Gwei',
    enabled: true,
    triggerCount: 0,
  ),
  LaunchpadGasAlertDraft(
    id: 'ga3',
    chain: 'Polygon',
    accent: AppColors.accent,
    threshold: 100,
    direction: LaunchpadGasAlertDirection.above,
    unit: 'Gwei',
    enabled: false,
    lastTriggered: '06/03/2026 18:45',
    triggerCount: 7,
  ),
];

const _launchpadRebalanceStrategies = [
  LaunchpadRebalanceStrategyDraft(
    id: 'conservative',
    name: 'An toan',
    description: 'Stablecoin + Blue chip, rui ro thap',
    riskLevel: LaunchpadRebalanceRisk.conservative,
    accent: AppColors.buy,
    targets: [
      LaunchpadRebalanceTargetDraft(symbol: 'USDT', percent: 40),
      LaunchpadRebalanceTargetDraft(symbol: 'BTC', percent: 25),
      LaunchpadRebalanceTargetDraft(symbol: 'ETH', percent: 20),
      LaunchpadRebalanceTargetDraft(symbol: 'BNB', percent: 10),
      LaunchpadRebalanceTargetDraft(symbol: 'Other', percent: 5),
    ],
  ),
  LaunchpadRebalanceStrategyDraft(
    id: 'moderate',
    name: 'Can bang',
    description: 'Pha tron blue chip va altcoin trien vong',
    riskLevel: LaunchpadRebalanceRisk.moderate,
    accent: AppColors.primary,
    targets: [
      LaunchpadRebalanceTargetDraft(symbol: 'USDT', percent: 20),
      LaunchpadRebalanceTargetDraft(symbol: 'BTC', percent: 25),
      LaunchpadRebalanceTargetDraft(symbol: 'ETH', percent: 25),
      LaunchpadRebalanceTargetDraft(symbol: 'BNB', percent: 15),
      LaunchpadRebalanceTargetDraft(symbol: 'Other', percent: 15),
    ],
  ),
  LaunchpadRebalanceStrategyDraft(
    id: 'aggressive',
    name: 'Tang truong',
    description: 'Tap trung altcoin va launchpad tokens',
    riskLevel: LaunchpadRebalanceRisk.aggressive,
    accent: AppColors.warn,
    targets: [
      LaunchpadRebalanceTargetDraft(symbol: 'USDT', percent: 10),
      LaunchpadRebalanceTargetDraft(symbol: 'BTC', percent: 15),
      LaunchpadRebalanceTargetDraft(symbol: 'ETH', percent: 20),
      LaunchpadRebalanceTargetDraft(symbol: 'BNB', percent: 20),
      LaunchpadRebalanceTargetDraft(symbol: 'Other', percent: 35),
    ],
  ),
];

const _launchpadRebalanceAssets = [
  LaunchpadRebalanceAssetDraft(
    id: 'pa1',
    symbol: 'USDT',
    name: 'Tether',
    accent: AppColors.buy,
    currentAmount: 8500,
    currentValue: 8500,
    currentPercent: 34,
    targetPercent: 20,
    price: 1,
    change24h: 0,
    chain: 'Multi',
  ),
  LaunchpadRebalanceAssetDraft(
    id: 'pa2',
    symbol: 'BTC',
    name: 'Bitcoin',
    accent: AppColors.warn,
    currentAmount: .082,
    currentValue: 7134,
    currentPercent: 28.5,
    targetPercent: 25,
    price: 87000,
    change24h: 2.3,
    chain: 'Multi',
  ),
  LaunchpadRebalanceAssetDraft(
    id: 'pa3',
    symbol: 'ETH',
    name: 'Ethereum',
    accent: AppColors.accent,
    currentAmount: 1.85,
    currentValue: 4810,
    currentPercent: 19.2,
    targetPercent: 25,
    price: 2600,
    change24h: -1.2,
    chain: 'Ethereum',
  ),
  LaunchpadRebalanceAssetDraft(
    id: 'pa4',
    symbol: 'BNB',
    name: 'BNB',
    accent: AppColors.primarySoft,
    currentAmount: 5.2,
    currentValue: 2860,
    currentPercent: 11.4,
    targetPercent: 15,
    price: 550,
    change24h: .8,
    chain: 'BSC',
  ),
  LaunchpadRebalanceAssetDraft(
    id: 'pa5',
    symbol: 'NEXA',
    name: 'NexaAI',
    accent: AppColors.accent,
    currentAmount: 12500,
    currentValue: 625,
    currentPercent: 2.5,
    targetPercent: 5,
    price: .05,
    change24h: 8.7,
    chain: 'BSC',
  ),
  LaunchpadRebalanceAssetDraft(
    id: 'pa6',
    symbol: 'GCE',
    name: 'GreenChain',
    accent: AppColors.buy,
    currentAmount: 4200,
    currentValue: 504,
    currentPercent: 2,
    targetPercent: 5,
    price: .12,
    change24h: -3.1,
    chain: 'Polygon',
  ),
  LaunchpadRebalanceAssetDraft(
    id: 'pa7',
    symbol: 'OMX',
    name: 'OmniDEX',
    accent: AppColors.primary,
    currentAmount: 1700,
    currentValue: 598.4,
    currentPercent: 2.4,
    targetPercent: 5,
    price: .352,
    change24h: 1.5,
    chain: 'Multi',
  ),
];

const _launchpadMultisigOwnersBsc = [
  LaunchpadMultisigSignerDraft(
    address: '0x742d...bD68',
    label: 'Admin 1',
    signed: false,
    role: LaunchpadMultisigSignerRole.owner,
  ),
  LaunchpadMultisigSignerDraft(
    address: '0x8Ba1...BA72',
    label: 'Admin 2',
    signed: false,
    role: LaunchpadMultisigSignerRole.owner,
  ),
  LaunchpadMultisigSignerDraft(
    address: '0x2546...EC30',
    label: 'CTO',
    signed: false,
    role: LaunchpadMultisigSignerRole.signer,
  ),
];

const _launchpadMultisigOwnersEth = [
  LaunchpadMultisigSignerDraft(
    address: '0x742d...bD68',
    label: 'Admin 1',
    signed: false,
    role: LaunchpadMultisigSignerRole.owner,
  ),
  LaunchpadMultisigSignerDraft(
    address: '0x8Ba1...BA72',
    label: 'Admin 2',
    signed: false,
    role: LaunchpadMultisigSignerRole.owner,
  ),
  LaunchpadMultisigSignerDraft(
    address: '0x2546...EC30',
    label: 'CTO',
    signed: false,
    role: LaunchpadMultisigSignerRole.signer,
  ),
  LaunchpadMultisigSignerDraft(
    address: '0xbDA5...97E',
    label: 'CFO',
    signed: false,
    role: LaunchpadMultisigSignerRole.signer,
  ),
];

const _launchpadMultisigSafes = [
  LaunchpadMultisigSafeDraft(
    address: '0xSafe1111...aaaa',
    label: 'Team Treasury',
    chain: 'BSC',
    accent: AppColors.primary,
    threshold: 2,
    owners: _launchpadMultisigOwnersBsc,
    balance: r'$125,400',
    txCount: 34,
    pendingCount: 2,
  ),
  LaunchpadMultisigSafeDraft(
    address: '0xSafe2222...bbbb',
    label: 'Operations Fund',
    chain: 'Ethereum',
    accent: AppColors.accent,
    threshold: 3,
    owners: _launchpadMultisigOwnersEth,
    balance: r'$48,200',
    txCount: 12,
    pendingCount: 1,
  ),
];

const _launchpadMultisigTxs = [
  LaunchpadMultisigTxDraft(
    id: 'mtx1',
    label: 'Withdraw staking rewards',
    description: 'Rut 500 NEXA rewards tu pool NexaAI',
    contractAddress: '0x1a2b...ef12',
    chain: 'BSC',
    accent: AppColors.primary,
    functionName: 'claimRewards',
    params: {},
    value: '0',
    estimatedGas: r'$0.18',
    status: LaunchpadMultisigTxStatus.pendingSignatures,
    threshold: 2,
    signers: [
      LaunchpadMultisigSignerDraft(
        address: '0x742d...bD68',
        label: 'Admin 1',
        signed: true,
        signedAt: '07/03/2026 09:00',
        role: LaunchpadMultisigSignerRole.owner,
      ),
      LaunchpadMultisigSignerDraft(
        address: '0x8Ba1...BA72',
        label: 'Admin 2',
        signed: false,
        role: LaunchpadMultisigSignerRole.owner,
      ),
      LaunchpadMultisigSignerDraft(
        address: '0x2546...EC30',
        label: 'CTO',
        signed: false,
        role: LaunchpadMultisigSignerRole.signer,
      ),
    ],
    signedCount: 1,
    createdAt: '07/03/2026 08:45',
    expiresAt: '14/03/2026 08:45',
    nonce: 35,
    safeAddress: '0xSafe1111...aaaa',
  ),
  LaunchpadMultisigTxDraft(
    id: 'mtx2',
    label: 'Approve bridge router',
    description: 'Approve router de bridge GCE sang Ethereum',
    contractAddress: '0xBridge...Router',
    chain: 'BSC',
    accent: AppColors.primary,
    functionName: 'approve',
    params: {'spender': '0xBridge...Router', 'amount': '10000'},
    value: '0',
    estimatedGas: r'$0.04',
    status: LaunchpadMultisigTxStatus.ready,
    threshold: 2,
    signers: [
      LaunchpadMultisigSignerDraft(
        address: '0x742d...bD68',
        label: 'Admin 1',
        signed: true,
        signedAt: '06/03/2026 15:00',
        role: LaunchpadMultisigSignerRole.owner,
      ),
      LaunchpadMultisigSignerDraft(
        address: '0x8Ba1...BA72',
        label: 'Admin 2',
        signed: true,
        signedAt: '06/03/2026 16:30',
        role: LaunchpadMultisigSignerRole.owner,
      ),
      LaunchpadMultisigSignerDraft(
        address: '0x2546...EC30',
        label: 'CTO',
        signed: false,
        role: LaunchpadMultisigSignerRole.signer,
      ),
    ],
    signedCount: 2,
    createdAt: '06/03/2026 14:30',
    expiresAt: '13/03/2026 14:30',
    nonce: 34,
    safeAddress: '0xSafe1111...aaaa',
  ),
  LaunchpadMultisigTxDraft(
    id: 'mtx3',
    label: 'Pause launchpad contract',
    description: 'Emergency pause truoc audit patch',
    contractAddress: '0x1a2b...ef12',
    chain: 'BSC',
    accent: AppColors.primary,
    functionName: 'pause',
    params: {'reason': 'security-review'},
    value: '0',
    estimatedGas: r'$0.06',
    status: LaunchpadMultisigTxStatus.executed,
    threshold: 2,
    signers: [
      LaunchpadMultisigSignerDraft(
        address: '0x742d...bD68',
        label: 'Admin 1',
        signed: true,
        signedAt: '05/03/2026 14:00',
        role: LaunchpadMultisigSignerRole.owner,
      ),
      LaunchpadMultisigSignerDraft(
        address: '0x8Ba1...BA72',
        label: 'Admin 2',
        signed: true,
        signedAt: '05/03/2026 14:05',
        role: LaunchpadMultisigSignerRole.owner,
      ),
      LaunchpadMultisigSignerDraft(
        address: '0x2546...EC30',
        label: 'CTO',
        signed: true,
        signedAt: '05/03/2026 14:02',
        role: LaunchpadMultisigSignerRole.signer,
      ),
    ],
    signedCount: 3,
    createdAt: '05/03/2026 13:50',
    expiresAt: '12/03/2026 13:50',
    executedAt: '05/03/2026 14:06',
    executeTxHash: '0xExec...1234',
    nonce: 33,
    safeAddress: '0xSafe1111...aaaa',
  ),
  LaunchpadMultisigTxDraft(
    id: 'mtx4',
    label: 'Transfer operations reserve',
    description: 'Move ETH reserve to Operations Fund',
    contractAddress: '0xSafe2222...bbbb',
    chain: 'Ethereum',
    accent: AppColors.accent,
    functionName: 'transfer',
    params: {'to': '0xSafe2222...bbbb', 'amount': '5'},
    value: '5 ETH',
    estimatedGas: r'$2.50',
    status: LaunchpadMultisigTxStatus.pendingSignatures,
    threshold: 3,
    signers: [
      LaunchpadMultisigSignerDraft(
        address: '0x742d...bD68',
        label: 'Admin 1',
        signed: true,
        signedAt: '07/03/2026 07:00',
        role: LaunchpadMultisigSignerRole.owner,
      ),
      LaunchpadMultisigSignerDraft(
        address: '0x8Ba1...BA72',
        label: 'Admin 2',
        signed: false,
        role: LaunchpadMultisigSignerRole.owner,
      ),
      LaunchpadMultisigSignerDraft(
        address: '0x2546...EC30',
        label: 'CTO',
        signed: true,
        signedAt: '07/03/2026 07:30',
        role: LaunchpadMultisigSignerRole.signer,
      ),
      LaunchpadMultisigSignerDraft(
        address: '0xbDA5...97E',
        label: 'CFO',
        signed: false,
        role: LaunchpadMultisigSignerRole.signer,
      ),
    ],
    signedCount: 2,
    createdAt: '07/03/2026 06:45',
    expiresAt: '14/03/2026 06:45',
    nonce: 13,
    safeAddress: '0xSafe2222...bbbb',
  ),
];

const _launchpadSwapDexQuotes = [
  LaunchpadSwapDexQuoteDraft(
    id: 'uniswap',
    name: 'Uniswap V3',
    symbol: 'UNI',
    accent: AppColors.accent,
    price: 2456.32,
    priceImpact: .12,
    gas: 45,
    liquidity: 12500000,
    route: ['USDT', 'WETH', 'ARB'],
    estimatedTime: '~30s',
    security: LaunchpadSwapSecurity.high,
    recommended: true,
  ),
  LaunchpadSwapDexQuoteDraft(
    id: 'pancake',
    name: 'PancakeSwap',
    symbol: 'PCS',
    accent: AppColors.primary,
    price: 2454.18,
    priceImpact: .24,
    gas: 12,
    liquidity: 8900000,
    route: ['USDT', 'BNB', 'ARB'],
    estimatedTime: '~3s',
    security: LaunchpadSwapSecurity.high,
    recommended: false,
  ),
  LaunchpadSwapDexQuoteDraft(
    id: 'sushi',
    name: 'SushiSwap',
    symbol: 'SUS',
    accent: AppColors.sell,
    price: 2453.67,
    priceImpact: .31,
    gas: 38,
    liquidity: 5200000,
    route: ['USDT', 'ARB'],
    estimatedTime: '~20s',
    security: LaunchpadSwapSecurity.medium,
    recommended: false,
  ),
  LaunchpadSwapDexQuoteDraft(
    id: 'curve',
    name: 'Curve',
    symbol: 'CRV',
    accent: AppColors.accent,
    price: 2452.89,
    priceImpact: .15,
    gas: 52,
    liquidity: 18000000,
    route: ['USDT', 'USDC', 'WETH', 'ARB'],
    estimatedTime: '~45s',
    security: LaunchpadSwapSecurity.high,
    recommended: false,
  ),
  LaunchpadSwapDexQuoteDraft(
    id: 'balancer',
    name: 'Balancer',
    symbol: 'BAL',
    accent: AppColors.warn,
    price: 2450.12,
    priceImpact: .42,
    gas: 67,
    liquidity: 3400000,
    route: ['USDT', 'DAI', 'WETH', 'ARB'],
    estimatedTime: '~1m',
    security: LaunchpadSwapSecurity.medium,
    recommended: false,
  ),
];

const _launchpadSwapHistory = [
  LaunchpadSwapHistoryDraft(
    id: 'sw_001',
    from: 'USDT',
    to: 'ARB',
    amount: 1000,
    dex: 'Uniswap V3',
    rate: 2456.32,
    timestamp: '07/03/2026 09:00',
    txHash: '0xabc...def',
    status: LaunchpadSwapStatus.success,
  ),
  LaunchpadSwapHistoryDraft(
    id: 'sw_002',
    from: 'USDC',
    to: 'OP',
    amount: 500,
    dex: 'PancakeSwap',
    rate: 1.87,
    timestamp: '06/03/2026 09:00',
    txHash: '0x123...456',
    status: LaunchpadSwapStatus.success,
  ),
  LaunchpadSwapHistoryDraft(
    id: 'sw_003',
    from: 'DAI',
    to: 'MATIC',
    amount: 250,
    dex: 'Curve',
    rate: .89,
    timestamp: '05/03/2026 09:00',
    txHash: '0x789...abc',
    status: LaunchpadSwapStatus.pending,
  ),
];

const _launchpadLimitOrders = [
  LaunchpadLimitOrderDraft(
    id: 'lo_001',
    token: 'Arbitrum',
    symbol: 'ARB',
    side: LaunchpadLimitOrderSide.buy,
    targetPrice: 2.35,
    currentPrice: 2.48,
    amount: 1000,
    filled: 0,
    status: LaunchpadLimitOrderStatus.active,
    expiresAt: '5/25/2026',
    createdAt: '5/18/2026 22:38',
    partialFill: true,
    accent: AppColors.buy,
  ),
  LaunchpadLimitOrderDraft(
    id: 'lo_002',
    token: 'Optimism',
    symbol: 'OP',
    side: LaunchpadLimitOrderSide.sell,
    targetPrice: 2.10,
    currentPrice: 1.87,
    amount: 500,
    filled: 0,
    status: LaunchpadLimitOrderStatus.active,
    expiresAt: '6/1/2026',
    createdAt: '5/17/2026 23:38',
    partialFill: false,
    accent: AppColors.sell,
  ),
  LaunchpadLimitOrderDraft(
    id: 'lo_003',
    token: 'Polygon',
    symbol: 'MATIC',
    side: LaunchpadLimitOrderSide.buy,
    targetPrice: .85,
    currentPrice: .89,
    amount: 2000,
    filled: 2000,
    status: LaunchpadLimitOrderStatus.filled,
    expiresAt: '5/25/2026',
    createdAt: '5/16/2026 23:38',
    partialFill: true,
    accent: AppColors.accent,
  ),
  LaunchpadLimitOrderDraft(
    id: 'lo_004',
    token: 'Avalanche',
    symbol: 'AVAX',
    side: LaunchpadLimitOrderSide.buy,
    targetPrice: 38.50,
    currentPrice: 42.30,
    amount: 100,
    filled: 45,
    status: LaunchpadLimitOrderStatus.active,
    expiresAt: '5/21/2026',
    createdAt: '5/15/2026 23:38',
    partialFill: true,
    accent: AppColors.buy,
  ),
];

const _launchpadDcaStrategies = [
  LaunchpadDcaStrategyDraft(
    id: 'dca_001',
    token: 'Arbitrum',
    symbol: 'ARB',
    frequency: LaunchpadDcaFrequency.weekly,
    amount: 100,
    startDate: '4/18/2026',
    nextBuy: '5/20/2026',
    totalInvested: 400,
    totalTokens: 165.32,
    avgPrice: 2.42,
    currentValue: 410.19,
    status: LaunchpadDcaStrategyStatus.active,
    executedOrders: 4,
    remainingBudget: 600,
    accent: AppColors.primary,
  ),
  LaunchpadDcaStrategyDraft(
    id: 'dca_002',
    token: 'Optimism',
    symbol: 'OP',
    frequency: LaunchpadDcaFrequency.biweekly,
    amount: 200,
    startDate: '3/19/2026',
    nextBuy: '5/23/2026',
    totalInvested: 600,
    totalTokens: 324.68,
    avgPrice: 1.85,
    currentValue: 607.15,
    status: LaunchpadDcaStrategyStatus.active,
    executedOrders: 3,
    remainingBudget: 400,
    accent: AppColors.primary,
  ),
  LaunchpadDcaStrategyDraft(
    id: 'dca_003',
    token: 'Polygon',
    symbol: 'MATIC',
    frequency: LaunchpadDcaFrequency.monthly,
    amount: 500,
    startDate: '2/18/2026',
    nextBuy: '5/15/2026',
    totalInvested: 1500,
    totalTokens: 1695.24,
    avgPrice: .89,
    currentValue: 1508.76,
    status: LaunchpadDcaStrategyStatus.paused,
    executedOrders: 3,
    remainingBudget: 0,
    accent: AppColors.primary,
  ),
];

const _launchpadDcaExecutions = [
  LaunchpadDcaExecutionDraft(
    id: 'exec_001',
    date: '4/20/2026 23:38',
    amount: 100,
    price: 2.45,
    tokens: 40.82,
    fee: .5,
  ),
  LaunchpadDcaExecutionDraft(
    id: 'exec_002',
    date: '4/27/2026 23:38',
    amount: 100,
    price: 2.38,
    tokens: 42.02,
    fee: .5,
  ),
  LaunchpadDcaExecutionDraft(
    id: 'exec_003',
    date: '5/4/2026 23:38',
    amount: 100,
    price: 2.51,
    tokens: 39.84,
    fee: .5,
  ),
  LaunchpadDcaExecutionDraft(
    id: 'exec_004',
    date: '5/11/2026 23:38',
    amount: 100,
    price: 2.35,
    tokens: 42.55,
    fee: .5,
  ),
];

const _launchpadRiskProject = LaunchpadRiskProjectDraft(
  id: 'proj1',
  name: 'VitToken',
  symbol: 'VIT',
  score: LaunchpadRiskScoreDraft(
    overall: 78,
    teamTransparency: 85,
    auditScore: 92,
    tokenomics: 68,
    communityTrust: 75,
    techSecurity: 88,
    liquidityRisk: 62,
  ),
  level: LaunchpadRiskLevel.medium,
  auditStatus: LaunchpadRiskAuditStatus.verified,
  teamDoxxed: true,
  contractVerified: true,
  liquidityLocked: true,
  warnings: [
    'High token concentration in top 10 wallets (45%)',
    'Liquidity unlock scheduled in 3 months',
    'Limited trading history (< 30 days)',
  ],
  strengths: [
    'Multiple security audits passed',
    'Doxxed team with verifiable LinkedIn profiles',
    'Active community engagement (10K+ members)',
    'Transparent tokenomics documentation',
  ],
);

const _launchpadRiskProjects = [
  LaunchpadRiskProjectDraft(
    id: 'safe',
    name: 'SafeToken',
    symbol: 'SAFE',
    score: LaunchpadRiskScoreDraft(
      overall: 92,
      teamTransparency: 94,
      auditScore: 96,
      tokenomics: 88,
      communityTrust: 90,
      techSecurity: 95,
      liquidityRisk: 85,
    ),
    level: LaunchpadRiskLevel.low,
    auditStatus: LaunchpadRiskAuditStatus.verified,
    teamDoxxed: true,
    contractVerified: true,
    liquidityLocked: true,
    warnings: [],
    strengths: ['Long audit trail', 'Deep liquidity'],
  ),
  _launchpadRiskProject,
  LaunchpadRiskProjectDraft(
    id: 'moon',
    name: 'MoonCoin',
    symbol: 'MOON',
    score: LaunchpadRiskScoreDraft(
      overall: 45,
      teamTransparency: 42,
      auditScore: 51,
      tokenomics: 39,
      communityTrust: 58,
      techSecurity: 47,
      liquidityRisk: 33,
    ),
    level: LaunchpadRiskLevel.high,
    auditStatus: LaunchpadRiskAuditStatus.pending,
    teamDoxxed: false,
    contractVerified: true,
    liquidityLocked: false,
    warnings: ['Pending audit', 'Thin liquidity'],
    strengths: ['Active community'],
  ),
  LaunchpadRiskProjectDraft(
    id: 'rug',
    name: 'RugToken',
    symbol: 'RUG',
    score: LaunchpadRiskScoreDraft(
      overall: 18,
      teamTransparency: 12,
      auditScore: 20,
      tokenomics: 15,
      communityTrust: 31,
      techSecurity: 19,
      liquidityRisk: 10,
    ),
    level: LaunchpadRiskLevel.critical,
    auditStatus: LaunchpadRiskAuditStatus.failed,
    teamDoxxed: false,
    contractVerified: false,
    liquidityLocked: false,
    warnings: ['Failed audit', 'Unlocked liquidity'],
    strengths: [],
  ),
];

const _launchpadRiskAudits = [
  LaunchpadRiskAuditDraft(
    firm: 'CertiK',
    date: '2025-02-15',
    status: 'Passed',
    criticalIssues: 0,
  ),
  LaunchpadRiskAuditDraft(
    firm: 'Quantstamp',
    date: '2025-03-01',
    status: 'Passed',
    criticalIssues: 2,
  ),
];

const _launchpadRiskResources = [
  LaunchpadRiskResourceDraft(
    label: 'Official Website',
    url: 'https://vittoken.io',
  ),
  LaunchpadRiskResourceDraft(
    label: 'Whitepaper',
    url: 'https://docs.vittoken.io',
  ),
  LaunchpadRiskResourceDraft(
    label: 'CertiK Audit Report',
    url: 'https://certik.com/projects/vit',
  ),
  LaunchpadRiskResourceDraft(
    label: 'Token Contract',
    url: 'https://etherscan.io/token/0x...',
  ),
];

const _bridgeOrder = LaunchpadBridgeOrderDraft(
  id: 'btx1',
  projectId: 'proj2',
  projectName: 'MetaVerse Land',
  projectSymbol: 'MVL',
  accent: AppColors.accent,
  sourceChain: 'Ethereum',
  targetChain: 'Polygon',
  inputToken: 'USDT',
  outputToken: 'MVL',
  inputAmount: 500,
  expectedOutput: 62500,
  routeProvider: 'VitBridge Aggregator',
  routeHops: 3,
  slippage: .5,
  gasCost: r'$2.85',
  totalFee: r'$3.50',
  priceImpact: .15,
  status: LaunchpadBridgeOrderStatus.approved,
  createdAt: '04/03/2026 15:30',
  etaSeconds: 19,
  pollCount: 2,
  sourceTxHash: '0x4a7b...e2f1',
  connectionState: LaunchpadBridgeConnectionState.connected,
  steps: [
    LaunchpadBridgeStepDraft(
      id: 'initiated',
      status: LaunchpadBridgeOrderStatus.initiated,
      label: 'Giao dịch được tạo',
      detail: 'Đơn bridge đã gửi thành công',
      timestamp: '18/05/2026 23:38:00',
    ),
    LaunchpadBridgeStepDraft(
      id: 'approved',
      status: LaunchpadBridgeOrderStatus.approved,
      label: 'Token approved',
      detail: 'USDT đã được approve cho bridge contract',
      timestamp: '23:38:01',
    ),
    LaunchpadBridgeStepDraft(
      id: 'bridging',
      status: LaunchpadBridgeOrderStatus.bridging,
      label: 'Đang bridge cross-chain',
      detail: 'Ethereum -> Polygon',
      confirmationsCurrent: 0,
      confirmationsRequired: 12,
    ),
    LaunchpadBridgeStepDraft(
      id: 'confirming',
      status: LaunchpadBridgeOrderStatus.confirming,
      label: 'Chờ xác nhận',
      detail: 'Chờ block confirmations trên chuỗi đích',
      confirmationsCurrent: 0,
      confirmationsRequired: 6,
    ),
    LaunchpadBridgeStepDraft(
      id: 'swapping',
      status: LaunchpadBridgeOrderStatus.swapping,
      label: 'Swap on-chain',
      detail: 'Swap sang MVL trên Polygon',
    ),
    LaunchpadBridgeStepDraft(
      id: 'finalizing',
      status: LaunchpadBridgeOrderStatus.finalizing,
      label: 'Hoàn tất',
      detail: 'Kiểm tra số dư và ghi nhận giao dịch',
    ),
    LaunchpadBridgeStepDraft(
      id: 'completed',
      status: LaunchpadBridgeOrderStatus.completed,
      label: 'Hoàn tất',
      detail: 'Đã nhận 62,500 MVL',
    ),
  ],
);

const _bridgeEvents = [
  LaunchpadBridgeEventDraft(
    id: 'ws1',
    timestamp: '23:38:00.200',
    level: LaunchpadBridgeEventLevel.system,
    source: 'ws',
    message:
        'WebSocket connecting to wss://bridge-relay.vitrading.io/v2/stream',
  ),
  LaunchpadBridgeEventDraft(
    id: 'ws2',
    timestamp: '23:38:01.000',
    level: LaunchpadBridgeEventLevel.system,
    source: 'ws',
    message: 'Connection established. Protocol: bridge-v2',
  ),
];

const _accountParam = LaunchpadContractParamDraft(
  name: 'account',
  type: 'address',
  label: 'Địa chỉ ví',
  placeholder: '0x...',
  required: true,
);

const _spenderParam = LaunchpadContractParamDraft(
  name: 'spender',
  type: 'address',
  label: 'Contract address',
  placeholder: '0x...',
  required: true,
);

const _amountParam = LaunchpadContractParamDraft(
  name: 'amount',
  type: 'uint256',
  label: 'Số lượng',
  placeholder: '0.00',
  required: true,
);

const _contractFunctions = [
  LaunchpadContractFunctionDraft(
    name: 'approve',
    description: 'Cho phép contract sử dụng token của bạn',
    type: LaunchpadContractFunctionType.write,
    riskLevel: LaunchpadContractRiskLevel.medium,
    estimatedGas: '46,000',
    params: [_spenderParam, _amountParam],
  ),
  LaunchpadContractFunctionDraft(
    name: 'participate',
    description: 'Tham gia IDO với số tiền chỉ định',
    type: LaunchpadContractFunctionType.write,
    riskLevel: LaunchpadContractRiskLevel.high,
    estimatedGas: '150,000',
    params: [_amountParam],
  ),
  LaunchpadContractFunctionDraft(
    name: 'claim',
    description: 'Nhận token sau khi IDO kết thúc',
    type: LaunchpadContractFunctionType.write,
    riskLevel: LaunchpadContractRiskLevel.low,
    estimatedGas: '80,000',
    params: [],
  ),
  LaunchpadContractFunctionDraft(
    name: 'refund',
    description: 'Yêu cầu hoàn tiền nếu chưa được phân bổ',
    type: LaunchpadContractFunctionType.write,
    riskLevel: LaunchpadContractRiskLevel.medium,
    estimatedGas: '90,000',
    params: [],
  ),
  LaunchpadContractFunctionDraft(
    name: 'getUserAllocation',
    description: 'Xem phân bổ token của bạn',
    type: LaunchpadContractFunctionType.read,
    riskLevel: LaunchpadContractRiskLevel.low,
    params: [_accountParam],
  ),
];

const _txSimulations = [
  LaunchpadTxSimulationDraft(
    id: 'sim1',
    functionName: 'stake',
    chain: 'BSC',
    contractAddress: '0x1a2b3c4d5e6f7890abcdef1234567890abcdef12',
    params: {'amount': '2500', 'lockPeriod': '14'},
    status: LaunchpadTxSimulationStatus.success,
    gasEstimate: '120,000',
    gasPrice: '5 Gwei',
    totalCost: r'$0.18',
    expectedOutput: 'Stake 2,500 BNB for 14 days at 48% APY',
    warnings: [],
    stateChanges: [
      'Số dư BNB: 5,000.00 -> 2,500.00',
      'Staked amount: 0.00 -> 2,500.00',
      'Lock until: 20/03/2026',
    ],
  ),
  LaunchpadTxSimulationDraft(
    id: 'sim2',
    functionName: 'approve',
    chain: 'Polygon',
    contractAddress: '0x9876543210abcdef9876543210abcdef98765432',
    params: {'spender': '0x9876...5432', 'amount': 'unlimited'},
    status: LaunchpadTxSimulationStatus.warning,
    gasEstimate: '46,000',
    gasPrice: '30 Gwei',
    totalCost: r'$0.01',
    expectedOutput: 'Approve unlimited USDT spending',
    warnings: [
      'Bạn đang approve không giới hạn. Nên chỉ approve số lượng cần thiết.',
    ],
    stateChanges: ['USDT allowance: 0 -> Unlimited'],
  ),
];
