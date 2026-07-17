part of '../repositories/mock_launchpad_repository.dart';

mixin _MockLaunchpadRepositoryMethodsPart01 on _MockLaunchpadRepositoryBase {
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
      receiptRoute: '/launchpad/receipt/sub001',
      stakingRoute: '/launchpad/staking',
      contractNotes:
          'Launchpad detail returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, selected project detail, tokenomics, vesting, team audit data, eligibility gates, and screenState. Captured route sample intentionally has no matching project and preserves the Flutter error state; dynamic contract and IDO bridge routes remain safe placeholders until backend id semantics are confirmed.',
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
          'Launchpad receipt returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, selected subscription details, portfolioRoute, launchpadRoute, and screenState. Direct captured route sub001 intentionally has no hydrated subscription state and preserves the Flutter error state.',
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
          'Launchpad claim receipt returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, selected reward claim receipt, vestingSchedule, claimHistory, notification preferences, and screenState. Captured route pos001 follows the Flutter fallback to the first claim receipt when the route id is not found.',
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
          'Launchpad IDO bridge returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, bridgeNetworks, swapRoutes, bridgeCompareRoute, bridgeOrderRoute, and screenState. Route ids from runtime bridge records require backend confirmation; sample route intentionally renders the Flutter not-found state.',
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
          'Launchpad bridge compare returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, bridge comparison input, candidate route options, route metrics, sort filters, selectedRouteId, and screenState. Flutter uses the existing tx001 bridge-order route until backend route ids are confirmed.',
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
      tabs: ['So s\u00E1nh', 'L\u1ECBch s\u1EED', 'C\u00E0i \u0111\u1EB7t'],
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
}
