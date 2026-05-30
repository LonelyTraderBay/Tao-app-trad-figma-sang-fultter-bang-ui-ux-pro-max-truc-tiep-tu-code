part of '../repositories/mock_earn_repository.dart';

final class MockStakingVotingRepository implements StakingVotingRepository {
  const MockStakingVotingRepository();

  @override
  StakingVotingSnapshot getVoting({String? proposalId}) {
    final endpoint = proposalId == null
        ? '/api/mobile/earn/earn-voting'
        : '/api/mobile/earn/earn-voting-$proposalId';
    return StakingVotingSnapshot(
      endpoint: endpoint,
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Proposal #127',
      backRoute: '/earn/proposals',
      category: 'Fees',
      proposalTitle: 'Lower ETH Staking Fees from 1.5% to 1%',
      proposalBody:
          'This proposal aims to reduce platform fees for ETH staking from 1.5% to 1% to remain competitive with other platforms. Revenue impact: -\$500K/year, offset by higher volume.',
      proposedByLabel: 'Proposed By',
      proposedBy: 'CommunityDAO',
      resultsTitle: 'Current Results',
      results: const [
        StakingVotingResultDraft(
          id: 'yes',
          label: 'Yes',
          percent: 70,
          votes: 42000,
          tone: 'success',
        ),
        StakingVotingResultDraft(
          id: 'no',
          label: 'No',
          percent: 30,
          votes: 18000,
          tone: 'danger',
        ),
      ],
      voteTitle: 'Cast Your Vote',
      options: const [
        StakingVotingOptionDraft(id: 'yes', label: 'Yes', tone: 'success'),
        StakingVotingOptionDraft(id: 'no', label: 'No', tone: 'danger'),
      ],
      votingPowerPrefix: 'Your voting power:',
      votingPower: '12,500 votes',
      votingPowerSuffix:
          '(based on staked tokens). Votes are final and cannot be changed.',
      submitLabel: 'Submit Vote',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, proposal detail, vote results, selected vote draft, voting power, and loading/empty/error/offline states.',
      supportedStates: const {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingForumRepository implements StakingForumRepository {
  const MockStakingForumRepository();

  @override
  StakingForumSnapshot getForum() {
    return const StakingForumSnapshot(
      endpoint: '/api/mobile/earn/earn-forum',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Forum',
      backRoute: '/earn/community-governance',
      heroTitle: 'Community Forum',
      heroBody:
          'Discuss strategies, proposals, and get support from fellow stakers.',
      categoriesTitle: 'Categories',
      categories: [
        StakingForumCategoryDraft(
          name: 'General Discussion',
          threads: 1234,
          posts: 8901,
        ),
        StakingForumCategoryDraft(
          name: 'Proposals & Voting',
          threads: 89,
          posts: 567,
        ),
        StakingForumCategoryDraft(
          name: 'Technical Support',
          threads: 456,
          posts: 2340,
        ),
        StakingForumCategoryDraft(
          name: 'Strategy & Tips',
          threads: 678,
          posts: 4521,
        ),
      ],
      threadsTitle: 'Trending Threads',
      threads: [
        StakingForumThreadDraft(
          title: 'Best validators for ETH staking in 2026?',
          replies: 234,
          views: 5678,
          pinned: true,
          author: 'CryptoGuru',
        ),
        StakingForumThreadDraft(
          title: 'Proposal #127 discussion: Lower fees',
          replies: 156,
          views: 3421,
          pinned: false,
          author: 'StakeMax',
        ),
        StakingForumThreadDraft(
          title: 'How to maximize rewards with auto-compound',
          replies: 89,
          views: 2103,
          pinned: false,
          author: 'YieldHunter',
        ),
      ],
      createLabel: 'Create New Thread',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, forum categories, trending threads, create-thread draft, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingWebhooksRepository implements StakingWebhooksRepository {
  const MockStakingWebhooksRepository();

  @override
  StakingWebhooksSnapshot getWebhooks() {
    return const StakingWebhooksSnapshot(
      endpoint: '/api/mobile/earn/earn-webhooks',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/webhooks; DELETE /earn/webhooks/:id',
      title: 'Webhooks',
      backRoute: '/earn',
      heroTitle: 'Real-time Event Notifications',
      heroBody:
          'Receive instant HTTP callbacks when staking events occur. Perfect for automation and integrations.',
      createLabel: 'Create Webhook',
      activeTitle: 'Active Webhooks',
      webhooks: [
        StakingWebhookDraft(
          id: 'w1',
          url: 'https://api.myapp.com/staking/rewards',
          events: ['reward_received'],
          active: true,
          lastTriggered: '2 mins ago',
        ),
        StakingWebhookDraft(
          id: 'w2',
          url: 'https://hooks.slack.com/services/...',
          events: ['stake_completed', 'unstake_completed'],
          active: true,
          lastTriggered: '1 hour ago',
        ),
        StakingWebhookDraft(
          id: 'w3',
          url: 'https://discord.com/api/webhooks/...',
          events: ['slashing_detected'],
          active: false,
          lastTriggered: 'Never',
        ),
      ],
      eventsTitle: 'Available Events',
      availableEvents: [
        'stake_completed',
        'unstake_completed',
        'reward_received',
        'validator_changed',
        'slashing_detected',
        'apy_changed',
      ],
      sheetTitle: 'Create Webhook',
      urlLabel: 'Webhook URL',
      urlPlaceholder: 'https://...',
      eventsLabel: 'Events',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, webhook URL draft, event subscriptions, create/delete action state, and loading/empty/error/offline states.',
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

final class MockStakingDataExportRepository
    implements StakingDataExportRepository {
  const MockStakingDataExportRepository();

  @override
  StakingDataExportSnapshot getDataExport() {
    return const StakingDataExportSnapshot(
      endpoint: '/api/mobile/earn/earn-data-export',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /exports',
      title: 'Data Export',
      backRoute: '/earn',
      heroTitle: 'Export Your Data',
      heroBody:
          'Download complete records for accounting, tax reporting, or personal analysis. All exports are encrypted.',
      quickTitle: 'Quick Exports',
      quickExports: [
        StakingQuickExportDraft(
          id: 'transactions',
          name: 'All Transactions',
          description: 'Complete transaction history (CSV)',
          iconKey: 'file',
        ),
        StakingQuickExportDraft(
          id: 'rewards',
          name: 'Rewards Report',
          description: 'Daily rewards breakdown (CSV)',
          iconKey: 'calendar',
        ),
        StakingQuickExportDraft(
          id: 'tax',
          name: 'Tax Report',
          description: 'Annual tax summary (PDF)',
          iconKey: 'file',
        ),
        StakingQuickExportDraft(
          id: 'portfolio',
          name: 'Portfolio Snapshot',
          description: 'Current positions (JSON)',
          iconKey: 'file',
        ),
      ],
      customTitle: 'Custom Export',
      dateRangeLabel: 'Date Range',
      startPlaceholder: 'mm/dd/yyyy',
      endPlaceholder: 'mm/dd/yyyy',
      formatLabel: 'Format',
      formatOptions: ['CSV', 'JSON', 'PDF'],
      defaultFormat: 'CSV',
      exportLabel: 'Export Custom Range',
      footerNote:
          'Exports are generated on-demand and available for download for 7 days. Large exports may take up to 5 minutes to process.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, quick export type, custom date range, format selection, export job state, and POST /exports action state.',
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

final class MockStakingThirdPartyIntegrationsRepository
    implements StakingThirdPartyIntegrationsRepository {
  const MockStakingThirdPartyIntegrationsRepository();

  @override
  StakingThirdPartyIntegrationsSnapshot getIntegrations() {
    return const StakingThirdPartyIntegrationsSnapshot(
      endpoint: '/api/mobile/earn/earn-third-party-integrations',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/integrations/:id/connect',
      title: 'Integrations',
      backRoute: '/earn',
      heroTitle: 'Connect Your Tools',
      heroBody:
          'Sync your staking data with tax software, portfolio trackers, and automation tools.',
      sectionTitle: 'Available Integrations',
      integrations: [
        StakingIntegrationDraft(
          id: 'turbotax',
          name: 'TurboTax',
          description: 'Automatic tax import',
          connected: true,
          iconKey: 'briefcase',
        ),
        StakingIntegrationDraft(
          id: 'cointracker',
          name: 'CoinTracker',
          description: 'Portfolio tracking',
          connected: true,
          iconKey: 'chart',
        ),
        StakingIntegrationDraft(
          id: 'ledger',
          name: 'Ledger Live',
          description: 'Hardware wallet sync',
          connected: false,
          iconKey: 'lock',
        ),
        StakingIntegrationDraft(
          id: 'metamask',
          name: 'MetaMask',
          description: 'Wallet integration',
          connected: true,
          iconKey: 'wallet',
        ),
        StakingIntegrationDraft(
          id: 'zapier',
          name: 'Zapier',
          description: 'Automation workflows',
          connected: false,
          iconKey: 'bolt',
        ),
        StakingIntegrationDraft(
          id: 'discord',
          name: 'Discord Bot',
          description: 'Notifications',
          connected: false,
          iconKey: 'bot',
        ),
      ],
      apiTitle: 'API Access',
      apiBody:
          'Build custom integrations using our API. Full documentation available.',
      apiActionLabel: 'View API Docs',
      apiDocsRoute: '/earn/api-documentation',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, integration connection state, API docs route, and loading/empty/error/offline/submitting/success states.',
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

final class MockStakingDeveloperConsoleRepository
    implements StakingDeveloperConsoleRepository {
  const MockStakingDeveloperConsoleRepository();

  @override
  StakingDeveloperConsoleSnapshot getConsole() {
    return const StakingDeveloperConsoleSnapshot(
      endpoint: '/api/mobile/earn/earn-developer-console',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/developer-console/api-keys',
      title: 'Developer Console',
      backRoute: '/earn',
      heroTitle: 'API Management',
      heroBody: 'Manage API keys, monitor usage, and access documentation.',
      defaultTab: 'keys',
      tabs: [
        StakingConsoleTabDraft(id: 'keys', label: 'API Keys'),
        StakingConsoleTabDraft(id: 'logs', label: 'Logs'),
        StakingConsoleTabDraft(id: 'docs', label: 'Docs'),
      ],
      stats: [
        StakingConsoleStatDraft(
          id: 'requests',
          value: '13.4K',
          label: 'Requests/day',
          tone: 'neutral',
        ),
        StakingConsoleStatDraft(
          id: 'uptime',
          value: '99.9%',
          label: 'Uptime',
          tone: 'success',
        ),
        StakingConsoleStatDraft(
          id: 'latency',
          value: '12ms',
          label: 'Avg latency',
          tone: 'neutral',
        ),
      ],
      keysTitle: 'API Keys',
      apiKeys: [
        StakingApiKeyDraft(
          id: 'key1',
          name: 'Production API',
          keyPreview: 'sk_live_4f8b...2a3c',
          created: '2026-01-15',
          lastUsed: '2 mins ago',
          requests: 12543,
        ),
        StakingApiKeyDraft(
          id: 'key2',
          name: 'Test Environment',
          keyPreview: 'sk_test_9d1e...7b4f',
          created: '2025-12-01',
          lastUsed: '1 day ago',
          requests: 892,
        ),
      ],
      createKeyLabel: 'Create New API Key',
      logsTitle: 'Recent API Requests',
      recentRequests: [
        StakingApiRequestDraft(
          endpoint: 'POST /staking/stake',
          status: 200,
          time: '45ms',
          timestamp: '14:32:15',
        ),
        StakingApiRequestDraft(
          endpoint: 'GET /staking/positions',
          status: 200,
          time: '23ms',
          timestamp: '14:30:02',
        ),
        StakingApiRequestDraft(
          endpoint: 'GET /staking/rewards',
          status: 200,
          time: '18ms',
          timestamp: '14:28:47',
        ),
      ],
      docsTitle: 'Quick Links',
      docs: [
        StakingConsoleDocDraft(
          title: 'API Reference',
          description: 'Complete endpoint documentation',
        ),
        StakingConsoleDocDraft(
          title: 'Authentication',
          description: 'API key setup and security',
        ),
        StakingConsoleDocDraft(
          title: 'Rate Limits',
          description: 'Request quotas and throttling',
        ),
        StakingConsoleDocDraft(
          title: 'Webhooks Guide',
          description: 'Real-time event notifications',
        ),
      ],
      contractNotes:
          'Reference/admin surface; gate behind internal role or dev flag. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, API key previews, request log samples, docs links, and loading/empty/error/offline/submitting/success states.',
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
