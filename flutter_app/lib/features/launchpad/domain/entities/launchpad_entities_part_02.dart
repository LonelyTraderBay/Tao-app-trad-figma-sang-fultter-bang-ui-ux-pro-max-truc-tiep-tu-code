part of 'launchpad_entities.dart';

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
