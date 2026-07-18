part of 'launchpad_entities.dart';

/// UI loading/data state shared by Launchpad screen snapshots.
enum LaunchpadScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
}

/// Sale phase of a launchpad project.
enum LaunchpadProjectStatus { upcoming, active, ended }

/// Fundraising/sale format of a launchpad project.
enum LaunchpadProjectType { ido, ieo, launchpool }

/// Outcome of a project's third-party security audit.
enum LaunchpadAuditStatus { passed, pending, issues }

/// Lifecycle status of a user's subscription to a launchpad sale.
enum LaunchpadSubscriptionStatus {
  pending,
  allocated,
  partiallyAllocated,
  claimed,
  refunded,
}

/// Data for the Launchpad home screen: projects and available tools.
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

/// A single launchpad project as listed across home, detail, and portfolio screens.
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
  final AccentTone accent;
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

/// Full detail of a single launchpad project and its related routes.
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

/// A single advanced or risk tool shortcut listed on the Launchpad home screen.
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
  final AccentTone accent;
}

/// A user's launchpad subscriptions for the portfolio screen.
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

/// A single subscription to a launchpad sale and its allocation/vesting status.
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
  final AccentTone accent;
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

/// Receipt detail for a single launchpad subscription.
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

/// Historical performance summary across past launchpad projects.
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

/// Aggregate performance metrics across past launchpad projects.
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

/// A single past project's launch and current price performance.
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
  final AccentTone accent;
}

/// A single month's aggregate performance point in the performance chart.
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

/// Lifecycle status of a staking pool.
enum LaunchpoolPoolStatus { upcoming, active, ended }

/// Lifecycle status of a user's staking position.
enum LaunchpadStakePositionStatus { active, cooldown, unlocked, withdrawn }

/// Staking pools and a user's positions for the staking screen.
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

/// A single staking pool and its capacity/reward terms.
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
  final AccentTone accent;
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

/// A single stake-amount tier granting a bonus APY.
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
  final AccentTone accent;
}

/// A single user staking position and its pending rewards.
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
  final AccentTone accent;
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

/// Lock/claim status of a single vesting tranche.
enum LaunchpadVestingEntryStatus { claimed, claimable, unlocking, locked }

/// Confirmation status of a past reward claim.
enum LaunchpadClaimHistoryStatus { confirmed, pending }

/// Full reward-claim receipt for a single staking position.
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
