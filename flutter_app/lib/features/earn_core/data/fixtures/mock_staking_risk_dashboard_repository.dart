part of '../repositories/mock_earn_repository.dart';

final class MockStakingRiskDashboardRepository extends _MockEarnRepositoryBase
    implements StakingRiskDashboardRepository {
  const MockStakingRiskDashboardRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingRiskDashboardSnapshot> getRiskDashboard() async {
    await _simulateNetwork();
    return const StakingRiskDashboardSnapshot(
      endpoint: '/api/mobile/earn/earn-risk-dashboard',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Risk Dashboard',
      backRoute: '/earn/staking',
      overallScore: 28,
      totalStakedUsd: 100000,
      atRiskUsd: 5000,
      protectedPercent: 95,
      riskMetrics: [
        StakingRiskMetricDraft(
          category: 'Validator Health',
          score: 15,
          status: 'low',
          description: 'All validators performing normally. Avg uptime: 99.8%',
          actionRoute: '/earn/validator-health-monitor',
        ),
        StakingRiskMetricDraft(
          category: 'Slashing Risk',
          score: 8,
          status: 'low',
          description: 'No slashing events in 90 days. Insurance fund at 165%',
          actionRoute: '/earn/slashing-history',
        ),
        StakingRiskMetricDraft(
          category: 'Smart Contract Risk',
          score: 20,
          status: 'low',
          description: 'Last audit: 30 days ago. No critical vulnerabilities',
          actionRoute: '/earn/audit-reports',
        ),
        StakingRiskMetricDraft(
          category: 'Liquidity Risk',
          score: 35,
          status: 'medium',
          description:
              'Unstaking queue: 2-3 days. Normal range for current network',
        ),
        StakingRiskMetricDraft(
          category: 'Market Risk',
          score: 45,
          status: 'medium',
          description: 'ETH volatility: 25% (30-day). Higher than 12-month avg',
        ),
        StakingRiskMetricDraft(
          category: 'Concentration Risk',
          score: 52,
          status: 'medium',
          description: '45% of stake on ETH. Consider diversification',
        ),
      ],
      exposures: [
        StakingRiskExposureDraft(
          asset: 'ETH',
          valueUsd: 45000,
          percentage: 45,
          risk: 'medium',
        ),
        StakingRiskExposureDraft(
          asset: 'BTC',
          valueUsd: 30000,
          percentage: 30,
          risk: 'low',
        ),
        StakingRiskExposureDraft(
          asset: 'SOL',
          valueUsd: 15000,
          percentage: 15,
          risk: 'medium',
        ),
        StakingRiskExposureDraft(
          asset: 'USDT',
          valueUsd: 10000,
          percentage: 10,
          risk: 'low',
        ),
      ],
      events: [
        StakingRiskEventDraft(
          id: 're1',
          dateLabel: '05/03/2026',
          type: 'warning',
          title: 'High ETH Volatility Detected',
          description: '30-day volatility increased to 25% (avg: 18%)',
          severity: 'medium',
        ),
        StakingRiskEventDraft(
          id: 're2',
          dateLabel: '01/03/2026',
          type: 'info',
          title: 'Validator Uptime Alert',
          description: 'Validator #3 uptime dropped to 98.5% (threshold: 99%)',
          severity: 'low',
        ),
        StakingRiskEventDraft(
          id: 're3',
          dateLabel: '25/02/2026',
          type: 'resolved',
          title: 'Smart Contract Upgrade Completed',
          description:
              'Staking contract upgraded to v2.1 with security improvements',
          severity: 'low',
        ),
      ],
      actions: [
        StakingRiskActionDraft(
          title: 'Emergency Actions',
          subtitle: 'Pause, withdraw, or rebalance',
          route: '/earn/emergency-actions',
          tone: 'sell',
        ),
        StakingRiskActionDraft(
          title: 'Risk Calculator',
          subtitle: 'Simulate scenarios',
          route: '/earn/risk-score-calculator',
          tone: 'primary',
        ),
        StakingRiskActionDraft(
          title: 'Contingency Plan',
          subtitle: 'Disaster recovery',
          route: '/earn/contingency-plan',
          tone: 'buy',
        ),
        StakingRiskActionDraft(
          title: 'Insurance Fund',
          subtitle: '165% coverage',
          route: '/earn/insurance',
          tone: 'accent',
        ),
      ],
      footerNote:
          'Risk scores are updated every 10 minutes. Historical data available for 12 months. Risk metrics are for informational purposes only and do not constitute financial advice.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, overall risk score, risk metrics, exposure data, recent events, action edges, and loading/empty/error/offline/realtime-refresh states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.realtimeRefresh,
      },
    );
  }
}

final class MockStakingSlashingHistoryRepository extends _MockEarnRepositoryBase
    implements StakingSlashingHistoryRepository {
  const MockStakingSlashingHistoryRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingSlashingHistorySnapshot> getSlashingHistory() async {
    await _simulateNetwork();
    return const StakingSlashingHistorySnapshot(
      endpoint: '/api/mobile/earn/earn-slashing-history',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Slashing History',
      backRoute: '/earn/risk-dashboard',
      infoTitle: 'Protected by Insurance',
      infoBody:
          'All slashing events are covered by our insurance fund. 89.5% of historical losses have been fully compensated.',
      stats: StakingSlashingStatsDraft(
        totalEvents: 3,
        totalSlashedEth: 5.7,
        totalCoveredEth: 5.1,
        coverageRate: 89.5,
        avgRecoveryTime: '2.5 days',
        lastEvent: '2026-02-20',
      ),
      events: [
        StakingSlashingEventDraft(
          id: 'se-20260220',
          dateLabel: '20/02/2026',
          validator: 'Validator #3',
          network: 'Ethereum',
          reason: 'Validator Downtime',
          slashedAmount: 0.5,
          affectedUsers: 12,
          insuranceCoverage: 100,
          status: 'covered',
        ),
        StakingSlashingEventDraft(
          id: 'se-20251115',
          dateLabel: '15/11/2025',
          validator: 'Validator #7',
          network: 'Ethereum',
          reason: 'Missed Attestations',
          slashedAmount: 0.2,
          affectedUsers: 8,
          insuranceCoverage: 100,
          status: 'covered',
        ),
        StakingSlashingEventDraft(
          id: 'se-20250820',
          dateLabel: '20/08/2025',
          validator: 'Validator #12',
          network: 'Solana',
          reason: 'Double Signing',
          slashedAmount: 5,
          affectedUsers: 25,
          insuranceCoverage: 80,
          status: 'partial',
        ),
      ],
      trend: [
        StakingSlashingTrendPointDraft(
          month: 'Apr 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'May 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Jun 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Jul 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Aug 2025',
          events: 1,
          amountEth: 5,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Sep 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Oct 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Nov 2025',
          events: 1,
          amountEth: 0.2,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Dec 2025',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Jan 2026',
          events: 0,
          amountEth: 0,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Feb 2026',
          events: 1,
          amountEth: 0.5,
        ),
        StakingSlashingTrendPointDraft(
          month: 'Mar 2026',
          events: 0,
          amountEth: 0,
        ),
      ],
      networkBreakdown: [
        StakingSlashingNetworkDraft(
          network: 'Ethereum',
          events: 2,
          amount: 0.7,
          unit: 'ETH',
          coverage: 100,
        ),
        StakingSlashingNetworkDraft(
          network: 'Solana',
          events: 1,
          amount: 5,
          unit: 'SOL',
          coverage: 80,
        ),
      ],
      reasonBreakdown: [
        StakingSlashingReasonDraft(
          reason: 'Double Signing',
          events: 1,
          severity: 'critical',
        ),
        StakingSlashingReasonDraft(
          reason: 'Validator Downtime',
          events: 1,
          severity: 'high',
        ),
        StakingSlashingReasonDraft(
          reason: 'Missed Attestations',
          events: 1,
          severity: 'medium',
        ),
      ],
      preventionMeasures: [
        StakingSlashingPreventionDraft(
          measure: 'Multi-Validator Distribution',
          status: 'active',
          description:
              'Stakes distributed across 15+ validators to minimize single-point failure',
        ),
        StakingSlashingPreventionDraft(
          measure: 'Real-time Monitoring',
          status: 'active',
          description:
              '24/7 automated monitoring of validator uptime and performance',
        ),
        StakingSlashingPreventionDraft(
          measure: 'Auto-Rebalancing',
          status: 'active',
          description:
              'Automatic stake reallocation from underperforming validators',
        ),
        StakingSlashingPreventionDraft(
          measure: 'Insurance Fund',
          status: 'active',
          description:
              '165% coverage ratio ensures full compensation for slashing events',
        ),
      ],
      exportLabel: 'Export Slashing Report (CSV)',
      footerNote:
          'Slashing data is updated in real-time. Insurance claims are processed within 7 business days. Historical data available for 24 months. For questions, contact support@platform.com.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, slashing events, trend data, network and reason breakdowns, prevention measures, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingValidatorHealthMonitorRepository
    extends _MockEarnRepositoryBase
    implements StakingValidatorHealthMonitorRepository {
  const MockStakingValidatorHealthMonitorRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingValidatorHealthMonitorSnapshot> getValidatorHealth() async {
    await _simulateNetwork();
    return const StakingValidatorHealthMonitorSnapshot(
      endpoint: '/api/mobile/earn/earn-validator-health-monitor',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Validator Health',
      backRoute: '/earn/risk-dashboard',
      validators: [
        StakingValidatorHealthDraft(
          id: 'v1',
          name: 'Validator #1',
          address: '0x1234...5678',
          uptime: 99.95,
          apr: 4.5,
          totalStakedEth: 15000,
          commission: 10,
          status: 'healthy',
          lastBlock: '2 mins ago',
          missedBlocks: 2,
        ),
        StakingValidatorHealthDraft(
          id: 'v2',
          name: 'Validator #2',
          address: '0xabcd...ef12',
          uptime: 99.92,
          apr: 4.3,
          totalStakedEth: 12500,
          commission: 10,
          status: 'healthy',
          lastBlock: '1 min ago',
          missedBlocks: 3,
        ),
        StakingValidatorHealthDraft(
          id: 'v3',
          name: 'Validator #3',
          address: '0x9876...5432',
          uptime: 98.5,
          apr: 3.8,
          totalStakedEth: 10000,
          commission: 10,
          status: 'warning',
          lastBlock: '5 mins ago',
          missedBlocks: 15,
        ),
      ],
      uptimeHistory: [
        StakingUptimeHistoryPointDraft(
          dateLabel: '01 Mar',
          validatorOne: 99.9,
          validatorTwo: 99.8,
          validatorThree: 99.2,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '02 Mar',
          validatorOne: 99.95,
          validatorTwo: 99.9,
          validatorThree: 99,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '03 Mar',
          validatorOne: 99.92,
          validatorTwo: 99.85,
          validatorThree: 98.8,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '04 Mar',
          validatorOne: 99.96,
          validatorTwo: 99.9,
          validatorThree: 98.5,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '05 Mar',
          validatorOne: 99.94,
          validatorTwo: 99.88,
          validatorThree: 98.4,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '06 Mar',
          validatorOne: 99.95,
          validatorTwo: 99.92,
          validatorThree: 98.5,
        ),
        StakingUptimeHistoryPointDraft(
          dateLabel: '07 Mar',
          validatorOne: 99.95,
          validatorTwo: 99.92,
          validatorThree: 98.5,
        ),
      ],
      actionTitle: 'Action Required',
      actionBody:
          '1 validator(s) showing degraded performance. Consider rebalancing your stake to healthier validators.',
      actionLabel: 'Auto-Rebalance Stake',
      footerNote:
          'Validator metrics updated every 5 minutes. Uptime calculated based on last 10,000 blocks. Auto-rebalancing triggers when validator uptime drops below 99%.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, validator status, uptime trend, action warning, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingRiskScoreCalculatorRepository
    extends _MockEarnRepositoryBase
    implements StakingRiskScoreCalculatorRepository {
  const MockStakingRiskScoreCalculatorRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingRiskScoreCalculatorSnapshot> getCalculator() async {
    await _simulateNetwork();
    return const StakingRiskScoreCalculatorSnapshot(
      endpoint: '/api/mobile/earn/earn-risk-score-calculator',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Risk Calculator',
      backRoute: '/earn/risk-dashboard',
      defaultAmountUsd: 10000,
      defaultAsset: 'ETH',
      defaultDuration: 'flexible',
      defaultValidators: 3,
      assetOptions: [
        StakingRiskScoreOptionDraft(value: 'USDT', label: 'USDT (Stablecoin)'),
        StakingRiskScoreOptionDraft(
          value: 'BTC',
          label: 'BTC (Low Volatility)',
        ),
        StakingRiskScoreOptionDraft(
          value: 'ETH',
          label: 'ETH (Medium Volatility)',
        ),
        StakingRiskScoreOptionDraft(
          value: 'SOL',
          label: 'SOL (High Volatility)',
        ),
      ],
      durationOptions: [
        StakingRiskScoreOptionDraft(
          value: 'flexible',
          label: 'Flexible (No lock)',
        ),
        StakingRiskScoreOptionDraft(value: 'fixed-30', label: 'Fixed 30 Days'),
        StakingRiskScoreOptionDraft(value: 'fixed-60', label: 'Fixed 60 Days'),
        StakingRiskScoreOptionDraft(value: 'fixed-90', label: 'Fixed 90 Days'),
        StakingRiskScoreOptionDraft(
          value: 'fixed-180',
          label: 'Fixed 180 Days',
        ),
      ],
      recommendations: [
        StakingRiskScoreRecommendationDraft(
          trigger: 'reduce-risk',
          title: 'Consider Reducing Risk',
          body: 'Diversify across more validators or reduce lock-up duration.',
          tone: 'warning',
        ),
        StakingRiskScoreRecommendationDraft(
          trigger: 'large-position',
          title: 'Large Position',
          body: 'Consider splitting across multiple products.',
          tone: 'info',
        ),
        StakingRiskScoreRecommendationDraft(
          trigger: 'balanced',
          title: 'Well-Balanced Portfolio',
          body: 'Your scenario has low risk. Good diversification!',
          tone: 'success',
        ),
      ],
      proceedLabel: 'Proceed with This Configuration',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, scenario inputs, calculated score, radar factors, recommendations, CTA edge, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}
