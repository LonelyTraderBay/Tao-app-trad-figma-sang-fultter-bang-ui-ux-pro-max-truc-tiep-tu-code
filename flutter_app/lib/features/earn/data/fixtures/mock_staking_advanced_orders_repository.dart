part of '../repositories/mock_earn_repository.dart';

final class MockStakingAdvancedOrdersRepository extends _MockEarnRepositoryBase
    implements StakingAdvancedOrdersRepository {
  const MockStakingAdvancedOrdersRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingAdvancedOrdersSnapshot> getAdvancedOrders() async {
    await _simulateNetwork();
    return const StakingAdvancedOrdersSnapshot(
      endpoint: '/api/mobile/earn/earn-advanced-orders',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/advanced-orders; DELETE /earn/staking/advanced-orders/:id',
      title: 'Advanced Orders',
      backRoute: '/earn/staking',
      infoTitle: 'Automate Your Liquid Staking Strategy',
      infoBody:
          'Set take-profit and stop-loss orders for liquid staking tokens (stETH, rETH). Automatically exit positions at target prices.',
      activeOrders: [
        StakingAdvancedOrderDraft(
          id: 'o1',
          type: StakingAdvancedOrderType.takeProfit,
          asset: 'stETH',
          trigger: 1.15,
          amount: 50,
          status: StakingAdvancedOrderStatus.active,
          created: '2026-03-01',
        ),
        StakingAdvancedOrderDraft(
          id: 'o2',
          type: StakingAdvancedOrderType.stopLoss,
          asset: 'rETH',
          trigger: 0.95,
          amount: 25,
          status: StakingAdvancedOrderStatus.active,
          created: '2026-02-28',
        ),
        StakingAdvancedOrderDraft(
          id: 'o3',
          type: StakingAdvancedOrderType.trailingStop,
          asset: 'stMATIC',
          trigger: 0.90,
          amount: 100,
          status: StakingAdvancedOrderStatus.active,
          created: '2026-02-25',
        ),
      ],
      orderHistory: [
        StakingAdvancedOrderDraft(
          id: 'h1',
          type: StakingAdvancedOrderType.takeProfit,
          asset: 'stETH',
          trigger: 1.12,
          amount: 30,
          status: StakingAdvancedOrderStatus.triggered,
          created: '2026-02-20',
        ),
        StakingAdvancedOrderDraft(
          id: 'h2',
          type: StakingAdvancedOrderType.stopLoss,
          asset: 'rETH',
          trigger: 0.98,
          amount: 15,
          status: StakingAdvancedOrderStatus.cancelled,
          created: '2026-02-15',
        ),
      ],
      statCards: [
        StakingAdvancedOrderStatDraft(
          label: 'Active Orders',
          value: '3',
          tone: 'success',
        ),
        StakingAdvancedOrderStatDraft(
          label: 'Triggered',
          value: '8',
          tone: 'neutral',
        ),
        StakingAdvancedOrderStatDraft(
          label: 'Saved P&L',
          value: '+\$12.4K',
          tone: 'neutral',
        ),
      ],
      orderTypeOptions: [
        StakingAdvancedOrderType.takeProfit,
        StakingAdvancedOrderType.stopLoss,
        StakingAdvancedOrderType.trailingStop,
      ],
      assetOptions: [
        'stETH (Lido)',
        'rETH (Rocket Pool)',
        'stMATIC (Lido Polygon)',
        'cbETH (Coinbase)',
      ],
      currentPriceLabel: 'Current: 1.05 ETH',
      availableLabel: 'Available: 150 stETH',
      orderTypeWarnings: {
        StakingAdvancedOrderType.takeProfit:
            'Order will execute automatically when price reaches trigger. Subject to market slippage.',
        StakingAdvancedOrderType.stopLoss:
            'Stop-loss protects against downside but may lock in losses during flash crashes.',
        StakingAdvancedOrderType.trailingStop:
            'Trailing stop follows price up but sells if it drops by set percentage.',
      },
      howItWorks: [
        StakingAdvancedOrderInfoDraft(
          title: 'Take Profit',
          description:
              'Automatically sell when price reaches target. Lock in gains without monitoring 24/7.',
        ),
        StakingAdvancedOrderInfoDraft(
          title: 'Stop Loss',
          description:
              'Exit position if price drops below threshold. Limit downside risk during market volatility.',
        ),
        StakingAdvancedOrderInfoDraft(
          title: 'Trailing Stop',
          description:
              'Dynamic stop that follows price up. Captures upside while protecting profits.',
        ),
      ],
      riskTitle: 'Risk Disclosure',
      riskBody:
          'Advanced orders execute at market prices and may experience slippage. Stop-loss orders do not guarantee execution price during extreme volatility. Only use with liquid staking tokens you understand.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, active orders, order history, create-order draft, cancel-order action, and loading/empty/error/offline/submitting/success states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.submitting,
        EarnScreenState.success,
      },
    );
  }
}

final class MockStakingMultiChainRepository extends _MockEarnRepositoryBase
    implements StakingMultiChainRepository {
  const MockStakingMultiChainRepository({super.simulateError, super.loadDelay});

  @override
  Future<StakingMultiChainSnapshot> getMultiChain() async {
    await _simulateNetwork();
    return const StakingMultiChainSnapshot(
      endpoint: '/api/mobile/earn/earn-multi-chain',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/multi-chain/rebalance; POST /earn/staking/multi-chain/connect',
      title: 'Multi-Chain Portfolio',
      backRoute: '/earn/staking',
      dashboardRoute: '/earn/dashboard',
      infoTitle: 'Cross-Chain Staking Hub',
      infoBody:
          'Manage staking positions across Ethereum, Polygon, Avalanche, Cosmos, and Solana from one dashboard. Unified rewards tracking.',
      totalValue: 482150,
      totalGainLabel: '+12.4%',
      totalRewards24h: 156.8,
      avgApy: 7.84,
      activeChains: 5,
      positions: [
        StakingChainPositionDraft(
          chainId: StakingChainId.ethereum,
          chain: 'Ethereum',
          asset: 'ETH',
          staked: 125.5,
          value: 287650,
          apy: 4.2,
        ),
        StakingChainPositionDraft(
          chainId: StakingChainId.polygon,
          chain: 'Polygon',
          asset: 'MATIC',
          staked: 50000,
          value: 45000,
          apy: 8.5,
        ),
        StakingChainPositionDraft(
          chainId: StakingChainId.avalanche,
          chain: 'Avalanche',
          asset: 'AVAX',
          staked: 1200,
          value: 48000,
          apy: 6.8,
        ),
        StakingChainPositionDraft(
          chainId: StakingChainId.cosmos,
          chain: 'Cosmos',
          asset: 'ATOM',
          staked: 3500,
          value: 38500,
          apy: 12.5,
        ),
        StakingChainPositionDraft(
          chainId: StakingChainId.solana,
          chain: 'Solana',
          asset: 'SOL',
          staked: 450,
          value: 63000,
          apy: 7.2,
        ),
      ],
      quickActions: [
        StakingMultiChainInfoDraft(
          title: 'Rebalance',
          description: 'Optimize allocation across chains',
          icon: 'trend',
        ),
        StakingMultiChainInfoDraft(
          title: 'Add Chain',
          description: 'Expand to new networks',
          icon: 'globe',
        ),
      ],
      benefits: [
        StakingMultiChainInfoDraft(
          title: 'Diversification',
          description: 'Reduce risk by spreading across multiple blockchains',
          icon: 'shield',
        ),
        StakingMultiChainInfoDraft(
          title: 'APY Optimization',
          description: 'Access higher yields on different networks',
          icon: 'trend',
        ),
        StakingMultiChainInfoDraft(
          title: 'Network Resilience',
          description: 'Not dependent on single chain performance',
          icon: 'globe',
        ),
        StakingMultiChainInfoDraft(
          title: 'Gas Efficiency',
          description: 'Choose low-cost chains for smaller positions',
          icon: 'cost',
        ),
      ],
      technicalNote:
          'Cross-chain positions require separate wallet connections for each network. Bridge fees apply when moving assets between chains. Always verify contract addresses.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, chain allocation, per-chain positions, rebalance action draft, chain connection state, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingInstitutionalRepository extends _MockEarnRepositoryBase
    implements StakingInstitutionalRepository {
  const MockStakingInstitutionalRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingInstitutionalSnapshot> getInstitutional() async {
    await _simulateNetwork();
    return const StakingInstitutionalSnapshot(
      endpoint: '/api/mobile/earn/earn-institutional',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/institutional/batches; POST /earn/staking/institutional/batches/:id/approve; POST /earn/staking/institutional/batches/:id/execute',
      title: 'Institutional Dashboard',
      backRoute: '/earn/staking',
      infoTitle: 'Enterprise Staking Platform',
      infoBody:
          'Batch operations, multi-signature approvals, and institutional-grade custody for large-scale staking.',
      stats: [
        StakingInstitutionalStatDraft(
          label: 'Total Staked',
          value: '\$25.6M',
          tone: 'primary',
          icon: 'building',
        ),
        StakingInstitutionalStatDraft(
          label: 'Multi-Sig',
          value: '3/5',
          tone: 'neutral',
          icon: 'users',
        ),
        StakingInstitutionalStatDraft(
          label: 'Certified',
          value: 'SOC 2',
          tone: 'success',
          icon: 'shield',
        ),
      ],
      pendingBatches: [
        StakingInstitutionalBatchDraft(
          id: 'b1',
          type: StakingInstitutionalBatchType.stake,
          operations: 12,
          totalAmount: 500,
          status: StakingInstitutionalBatchStatus.pending,
          created: '2026-03-07 14:30',
          approvals: 1,
          requiredApprovals: 3,
        ),
        StakingInstitutionalBatchDraft(
          id: 'b2',
          type: StakingInstitutionalBatchType.claim,
          operations: 8,
          totalAmount: 24.5,
          status: StakingInstitutionalBatchStatus.approved,
          created: '2026-03-07 13:15',
          approvals: 3,
          requiredApprovals: 3,
        ),
      ],
      executedBatches: [
        StakingInstitutionalBatchDraft(
          id: 'e1',
          type: StakingInstitutionalBatchType.stake,
          operations: 15,
          totalAmount: 750,
          status: StakingInstitutionalBatchStatus.executed,
          created: '2026-03-06 16:20',
          approvals: 3,
          requiredApprovals: 3,
        ),
        StakingInstitutionalBatchDraft(
          id: 'e2',
          type: StakingInstitutionalBatchType.unstake,
          operations: 5,
          totalAmount: 150,
          status: StakingInstitutionalBatchStatus.executed,
          created: '2026-03-05 11:45',
          approvals: 3,
          requiredApprovals: 3,
        ),
      ],
      signers: [
        StakingInstitutionalSignerDraft(
          name: 'Alice Chen',
          role: 'CFO',
          address: '0x1234...5678',
          status: StakingInstitutionalSignerStatus.approved,
        ),
        StakingInstitutionalSignerDraft(
          name: 'Bob Martinez',
          role: 'CTO',
          address: '0xabcd...ef01',
          status: StakingInstitutionalSignerStatus.approved,
        ),
        StakingInstitutionalSignerDraft(
          name: 'Carol Wu',
          role: 'COO',
          address: '0x9876...5432',
          status: StakingInstitutionalSignerStatus.pending,
        ),
      ],
      features: [
        StakingInstitutionalFeatureDraft(
          title: 'Cold Storage',
          description: '95% of funds in cold wallets',
          icon: 'shield',
        ),
        StakingInstitutionalFeatureDraft(
          title: 'Audit Trail',
          description: 'Complete transaction logs',
          icon: 'file',
        ),
        StakingInstitutionalFeatureDraft(
          title: 'RBAC',
          description: 'Role-based access control',
          icon: 'users',
        ),
        StakingInstitutionalFeatureDraft(
          title: 'Custody',
          description: 'Fireblocks integration',
          icon: 'building',
        ),
      ],
      complianceTitle: 'Institutional Compliance',
      complianceBody:
          'SOC 2 Type II certified. MiFID II compliant. Multi-signature custody with Fireblocks. 24/7 institutional support. Dedicated account manager for AUM > \$10M.',
      operationTypes: [
        'Batch Stake',
        'Batch Unstake',
        'Batch Claim Rewards',
        'Batch Validator Change',
      ],
      csvFormatNote: 'Format: address, amount, validator',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, batch operations, signer approvals, RBAC roles, custody provider status, and loading/empty/error/offline/submitting/success states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.submitting,
        EarnScreenState.success,
      },
    );
  }
}
