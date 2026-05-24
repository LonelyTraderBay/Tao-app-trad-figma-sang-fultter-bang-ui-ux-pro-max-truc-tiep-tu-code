import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';

final launchpadRepositoryProvider = Provider<LaunchpadRepository>((ref) {
  return const MockLaunchpadRepository();
});

abstract interface class LaunchpadRepository {
  LaunchpadHomeSnapshot getHome();

  LaunchpadPortfolioSnapshot getPortfolio();

  LaunchpadPerformanceSnapshot getPerformance();

  LaunchpadStakingSnapshot getStaking();

  LaunchpadIdoBridgeSnapshot getIdoBridge(String projectId);

  LaunchpadContractSnapshot getContract(String projectId);
}

enum LaunchpadScreenState { loading, empty, error, offline }

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
