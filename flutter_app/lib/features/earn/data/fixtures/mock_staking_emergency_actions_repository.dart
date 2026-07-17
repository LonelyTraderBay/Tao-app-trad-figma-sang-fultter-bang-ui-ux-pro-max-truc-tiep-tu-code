part of '../repositories/mock_earn_repository.dart';

final class MockStakingEmergencyActionsRepository
    implements StakingEmergencyActionsRepository {
  const MockStakingEmergencyActionsRepository();

  @override
  StakingEmergencyActionsSnapshot getEmergencyActions() {
    return const StakingEmergencyActionsSnapshot(
      endpoint: '/api/mobile/earn/earn-emergency-actions',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Emergency Actions',
      backRoute: '/earn/risk-dashboard',
      warningTitle: 'Emergency Actions Only',
      warningBody:
          'Use these actions only in critical situations (smart contract exploits, validator failures, extreme market events). Normal unstaking is available anytime via Dashboard.',
      actions: [
        StakingEmergencyActionDraft(
          id: 'pause',
          title: 'Pause All Staking',
          body:
              'Temporarily halt all new staking transactions. Existing stakes continue earning.',
          impact: 'Moderate Impact - Reversible',
          tone: 'warning',
        ),
        StakingEmergencyActionDraft(
          id: 'withdraw',
          title: 'Emergency Withdrawal',
          body:
              'Immediately unstake all positions. May incur penalties for fixed-term stakes.',
          impact: 'High Impact - Penalties Apply',
          tone: 'danger',
        ),
        StakingEmergencyActionDraft(
          id: 'rebalance',
          title: 'Auto-Rebalance Validators',
          body:
              'Automatically move stakes from underperforming validators to healthy ones.',
          impact: 'Low Impact - Recommended',
          tone: 'info',
        ),
      ],
      useCases: [
        StakingEmergencyUseCaseDraft(
          title: 'Smart Contract Exploit',
          severity: 'critical',
          description:
              'Immediate withdrawal if contract vulnerability discovered',
        ),
        StakingEmergencyUseCaseDraft(
          title: 'Validator Mass Failure',
          severity: 'high',
          description: 'Multiple validators going offline simultaneously',
        ),
        StakingEmergencyUseCaseDraft(
          title: 'Extreme Market Event',
          severity: 'high',
          description: 'Black swan event with >50% asset price drop',
        ),
        StakingEmergencyUseCaseDraft(
          title: 'Regulatory Action',
          severity: 'medium',
          description: 'Government ban or restriction on staking',
        ),
      ],
      statusCards: [
        StakingEmergencyStatusDraft(
          title: 'System Status',
          value: 'All Systems Normal',
          body: 'No emergency action needed',
          tone: 'success',
        ),
        StakingEmergencyStatusDraft(
          title: 'Last Emergency',
          value: 'Never',
          body: 'No history',
          tone: 'neutral',
        ),
      ],
      pauseSheet: StakingEmergencySheetDraft(
        title: 'Pause All Staking',
        body:
            'This will pause all new staking transactions. Existing stakes will continue earning rewards. You can resume anytime.',
        bullets: [],
        confirmLabel: 'Confirm Pause',
        tone: 'warning',
      ),
      withdrawSheet: StakingEmergencySheetDraft(
        title: 'Emergency Withdrawal',
        body:
            'Warning: Emergency withdrawal may incur penalties and take 2-7 days depending on network.',
        bullets: [
          'Fixed-term stakes: 5% early withdrawal penalty',
          'Flexible stakes: Standard 2-day unstaking period',
          'Rewards earned to date will be included',
        ],
        confirmLabel: 'Confirm Emergency Withdrawal',
        tone: 'danger',
      ),
      footerNote:
          'Emergency actions are monitored and logged. Abuse may result in account restrictions. For non-emergency unstaking, use the Dashboard. Contact support before taking emergency actions.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, emergency actions, confirmation sheet copy, status cards, audit logging metadata, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingContingencyPlanRepository
    implements StakingContingencyPlanRepository {
  const MockStakingContingencyPlanRepository();

  @override
  StakingContingencyPlanSnapshot getContingencyPlan() {
    return const StakingContingencyPlanSnapshot(
      endpoint: '/api/mobile/earn/earn-contingency-plan',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Contingency Plan',
      backRoute: '/earn/risk-dashboard',
      infoTitle: 'Disaster Recovery & Business Continuity',
      infoBody:
          'Our contingency plan ensures continuity of service and asset protection in all emergency scenarios. Tested quarterly.',
      metrics: [
        StakingContingencyMetricDraft(
          label: 'Recovery Time (RTO)',
          value: '4 hours',
          tone: 'neutral',
        ),
        StakingContingencyMetricDraft(
          label: 'Data Loss Limit (RPO)',
          value: '15 minutes',
          tone: 'neutral',
        ),
        StakingContingencyMetricDraft(
          label: 'Mean Time To Recovery',
          value: '2 hours',
          tone: 'neutral',
        ),
        StakingContingencyMetricDraft(
          label: 'Insurance Coverage',
          value: '165%',
          tone: 'success',
        ),
      ],
      scenarios: [
        StakingContingencyScenarioDraft(
          scenario: 'Smart Contract Exploit',
          likelihood: 'Very Low',
          impact: 'Critical',
          response: [
            'Immediate pause of all deposits',
            'Emergency withdrawal enabled',
            'Insurance fund activation',
            'Full audit within 24 hours',
            'User communication within 1 hour',
          ],
          preventative: [
            'Quarterly security audits',
            'Bug bounty program',
            'Multi-sig wallet controls',
            'Insurance fund 165% coverage',
          ],
        ),
        StakingContingencyScenarioDraft(
          scenario: 'Validator Slashing Event',
          likelihood: 'Low',
          impact: 'Medium',
          response: [
            'Automatic stake rebalancing',
            'Insurance payout within 7 days',
            'Affected users notified immediately',
            'Validator removed from rotation',
          ],
          preventative: [
            '24/7 validator monitoring',
            'Multi-validator distribution',
            'Performance-based allocation',
            'Automatic failover',
          ],
        ),
        StakingContingencyScenarioDraft(
          scenario: 'Network Failure',
          likelihood: 'Very Low',
          impact: 'High',
          response: [
            'Failover to backup infrastructure',
            'Read-only mode activated',
            'Status page updated real-time',
            'Service restoration within 4 hours',
          ],
          preventative: [
            'Multi-region deployment',
            'Redundant infrastructure',
            'Daily backups',
            'Disaster recovery drills',
          ],
        ),
        StakingContingencyScenarioDraft(
          scenario: 'Regulatory Action',
          likelihood: 'Low',
          impact: 'High',
          response: [
            'Legal team engagement',
            'Compliance review',
            'User withdrawal window (30 days)',
            'Geographic restriction if required',
          ],
          preventative: [
            'Proactive compliance monitoring',
            'Multiple jurisdictional licenses',
            'Legal reserve fund',
          ],
        ),
      ],
      validationItems: [
        StakingContingencyValidationDraft(
          title: 'Last DR Test',
          dateLabel: '15 February 2026',
          tone: 'success',
        ),
        StakingContingencyValidationDraft(
          title: 'Next Scheduled Test',
          dateLabel: '15 May 2026',
          tone: 'warning',
        ),
      ],
      validationBody:
          'Our disaster recovery plan is tested quarterly with full simulations. All test results are documented and audited by third parties.',
      documents: [
        StakingContingencyDocumentDraft(
          name: 'Full Contingency Plan (PDF)',
          size: '2.5 MB',
          updatedLabel: '15/01/2026',
        ),
        StakingContingencyDocumentDraft(
          name: 'Incident Response Playbook',
          size: '1.8 MB',
          updatedLabel: '20/01/2026',
        ),
        StakingContingencyDocumentDraft(
          name: 'Business Continuity Plan',
          size: '3.2 MB',
          updatedLabel: '01/02/2026',
        ),
      ],
      footerNote:
          'Our contingency plan is reviewed annually and updated based on new threats, regulatory requirements, and industry best practices. For inquiries, contact compliance@platform.com.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, recovery metrics, contingency scenarios, validation schedule, documents, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingSocialFeedRepository
    implements StakingSocialFeedRepository {
  const MockStakingSocialFeedRepository();

  @override
  StakingSocialFeedSnapshot getFeed() {
    return const StakingSocialFeedSnapshot(
      endpoint: '/api/mobile/earn/earn-social-feed',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Community Feed',
      backRoute: '/earn',
      infoTitle: 'Share Your Staking Journey',
      infoBody:
          'Connect with fellow stakers, share strategies, and celebrate milestones. Learn from the community experience.',
      composerPlaceholder: 'Share your staking wins, tips, or questions...',
      defaultTabId: 'trending',
      tabs: [
        StakingSocialFeedTabDraft(
          id: 'trending',
          label: 'Trending',
          sectionTitle: 'Trending Posts',
        ),
        StakingSocialFeedTabDraft(
          id: 'following',
          label: 'Following',
          sectionTitle: 'From People You Follow',
        ),
        StakingSocialFeedTabDraft(
          id: 'my-posts',
          label: 'My Posts',
          sectionTitle: 'Your Posts',
        ),
      ],
      posts: [
        StakingSocialFeedPostDraft(
          id: 'p1',
          author: 'CryptoWhale',
          avatarLabel: 'CW',
          badge: 'VIP',
          timestamp: '2 hours ago',
          content:
              'Just hit 1000 ETH staked! The auto-compound feature is a game changer. Earned 12% more vs manual claiming.',
          type: 'milestone',
          likes: 234,
          comments: 45,
          asset: 'ETH',
        ),
        StakingSocialFeedPostDraft(
          id: 'p2',
          author: 'YieldMaximizer',
          avatarLabel: 'YM',
          timestamp: '5 hours ago',
          content:
              'Pro tip: Stake during validator rotation windows for better APY. I switched from Validator #3 to #1 and got +0.5% APY boost.',
          type: 'tip',
          likes: 156,
          comments: 28,
          asset: 'ETH',
          apy: '4.5% APY',
        ),
        StakingSocialFeedPostDraft(
          id: 'p3',
          author: 'DeFiBuilder',
          avatarLabel: 'DB',
          badge: 'Expert',
          timestamp: '1 day ago',
          content:
              'Comparison: Flexible vs Fixed 90D staking. Fixed gave me 1.2% higher APY, but liquidity risk during market dips. What is your strategy?',
          type: 'discussion',
          likes: 89,
          comments: 67,
        ),
        StakingSocialFeedPostDraft(
          id: 'p4',
          author: 'SafeStaker',
          avatarLabel: 'SS',
          timestamp: '1 day ago',
          content:
              'Achievement unlocked: 365 days uninterrupted staking! Total rewards: 125 ETH. Insurance fund saved me twice during slashing events.',
          type: 'achievement',
          likes: 312,
          comments: 52,
          asset: 'ETH',
        ),
      ],
      stats: [
        StakingSocialFeedStatDraft(
          value: '12.5K',
          label: 'Members',
          tone: 'neutral',
        ),
        StakingSocialFeedStatDraft(
          value: '3.2K',
          label: 'Posts Today',
          tone: 'neutral',
        ),
        StakingSocialFeedStatDraft(
          value: '89%',
          label: 'Active Rate',
          tone: 'success',
        ),
      ],
      footerNote:
          'Community guidelines apply. Be respectful, share knowledge, and support fellow stakers. Spam, financial advice, and referral links are prohibited.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, feed tabs, posts, reactions, comments, sharing metadata, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingCommunityGovernanceRepository
    implements StakingCommunityGovernanceRepository {
  const MockStakingCommunityGovernanceRepository();

  @override
  StakingCommunityGovernanceSnapshot getGovernance() {
    return const StakingCommunityGovernanceSnapshot(
      endpoint: '/api/mobile/earn/earn-community-governance',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Governance',
      backRoute: '/earn',
      proposalsRoute: '/earn/proposals',
      forumRoute: '/earn/forum',
      infoTitle: 'Community-Driven Decisions',
      infoBody:
          'Stakers vote on fee structures, new asset support, insurance fund policies, and platform improvements. Your stake = your voting power.',
      statsTitle: 'Governance Overview',
      stats: [
        StakingGovernanceStatDraft(
          label: 'Token Holders',
          value: '125,000',
          tone: 'neutral',
        ),
        StakingGovernanceStatDraft(
          label: 'Active Voters',
          value: '45,000',
          tone: 'accent',
        ),
        StakingGovernanceStatDraft(
          label: 'Participation Rate',
          value: '36%',
          tone: 'neutral',
        ),
        StakingGovernanceStatDraft(
          label: 'Proposals Passed',
          value: '89/127',
          tone: 'success',
        ),
      ],
      activeProposal: StakingGovernanceActiveProposalDraft(
        title: 'View All Active Proposals',
        body: 'Vote on platform fees, new features, and policy changes',
        badge: '3 Active',
      ),
      recentDecisions: [
        StakingGovernanceDecisionDraft(
          proposal: 'Reduce ETH staking fees from 2% to 1.5%',
          status: 'Passed',
          votes: '89,234',
          dateLabel: '15/02/2026',
        ),
        StakingGovernanceDecisionDraft(
          proposal: 'Add Polygon validator support',
          status: 'Passed',
          votes: '67,821',
          dateLabel: '20/01/2026',
        ),
        StakingGovernanceDecisionDraft(
          proposal: 'Increase insurance fund contribution to 3%',
          status: 'Passed',
          votes: '54,123',
          dateLabel: '10/12/2025',
        ),
      ],
      governanceSteps: [
        StakingGovernanceStepDraft(
          step: 1,
          title: 'Proposal Creation',
          description:
              'Community members with >=10,000 tokens can create proposals',
        ),
        StakingGovernanceStepDraft(
          step: 2,
          title: 'Discussion Period',
          description: '7-day discussion on forum before voting opens',
        ),
        StakingGovernanceStepDraft(
          step: 3,
          title: 'Voting Period',
          description: '14-day voting window. 1 token = 1 vote',
        ),
        StakingGovernanceStepDraft(
          step: 4,
          title: 'Execution',
          description:
              'Passed proposals (>50% approval, >10% quorum) executed within 7 days',
        ),
      ],
      votingPower: StakingGovernanceVotingPowerDraft(
        title: 'Your Voting Power',
        body: 'Based on your staked tokens. Stake more to increase influence.',
        value: '12,500',
        share: 'votes (1.25% of total)',
      ),
      footerNote:
          'Governance is on-chain and transparent. All votes are recorded on Ethereum. Proposal outcomes are binding and executed via smart contracts.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, governance stats, proposal routing, voting power, decision history, forum link, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingProposalsRepository
    implements StakingProposalsRepository {
  const MockStakingProposalsRepository();

  @override
  StakingProposalsSnapshot getProposals() {
    return const StakingProposalsSnapshot(
      endpoint: '/api/mobile/earn/earn-proposals',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Proposals',
      backRoute: '/earn/community-governance',
      createLabel: 'Create New Proposal (Requires 10K tokens)',
      proposals: [
        StakingProposalDraft(
          id: 'prop001',
          title: 'Lower ETH staking fees to 1%',
          status: 'active',
          yesVotes: 42000,
          noVotes: 18000,
          quorum: 65,
          endsIn: '5 days',
          category: 'Fees',
          votingRoute: '/earn/voting/prop001',
        ),
        StakingProposalDraft(
          id: 'prop002',
          title: 'Add support for Avalanche staking',
          status: 'active',
          yesVotes: 38000,
          noVotes: 22000,
          quorum: 58,
          endsIn: '12 days',
          category: 'Product',
          votingRoute: '/earn/voting/prop002',
        ),
        StakingProposalDraft(
          id: 'prop003',
          title: 'Increase insurance fund to 200% coverage',
          status: 'active',
          yesVotes: 28000,
          noVotes: 15000,
          quorum: 42,
          endsIn: '3 days',
          category: 'Risk',
          votingRoute: '/earn/voting/prop003',
        ),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, active proposal cards, vote ratios, quorum, proposal detail route, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}
