part of 'mock_dev_tools_repository.dart';

final class MockRouteCheckerRepository implements RouteCheckerRepository {
  const MockRouteCheckerRepository();

  @override
  RouteCheckerSnapshot getRouteChecker() {
    return const RouteCheckerSnapshot(
      endpoint: '/api/mobile/dev/dev-route-checker',
      actionDraft: 'read-only or local navigation action',
      title: 'Staking Route Checker',
      subtitle: 'Test all 43 routes systematically. Click to mark each route.',
      backRoute: '/home',
      routes: [
        DevRouteDraft(
          path: '/earn/staking/terms',
          name: 'Terms of Service',
          phase: 1,
        ),
        DevRouteDraft(
          path: '/earn/staking/risk-disclosure',
          name: 'Risk Disclosure',
          phase: 1,
        ),
        DevRouteDraft(
          path: '/earn/staking/withdrawal-policy',
          name: 'Withdrawal Policy',
          phase: 1,
        ),
        DevRouteDraft(
          path: '/earn/staking/tax-guide',
          name: 'Tax Guide',
          phase: 1,
        ),
        DevRouteDraft(
          path: '/earn/staking/risk-assessment',
          name: 'Risk Assessment',
          phase: 1,
        ),
        DevRouteDraft(path: '/earn/dashboard', name: 'Dashboard', phase: 2),
        DevRouteDraft(path: '/earn/analytics', name: 'Analytics', phase: 2),
        DevRouteDraft(path: '/earn/history', name: 'History', phase: 2),
        DevRouteDraft(
          path: '/earn/calendar',
          name: 'Earnings Calendar',
          phase: 2,
        ),
        DevRouteDraft(
          path: '/earn/validator-selection',
          name: 'Validator Selection',
          phase: 3,
        ),
        DevRouteDraft(
          path: '/earn/auto-compound',
          name: 'Auto-Compound',
          phase: 3,
        ),
        DevRouteDraft(
          path: '/earn/liquid-staking',
          name: 'Liquid Staking',
          phase: 3,
        ),
        DevRouteDraft(path: '/earn/insurance', name: 'Insurance', phase: 3),
        DevRouteDraft(
          path: '/earn/advanced-orders',
          name: 'Advanced Orders',
          phase: 3,
          featured: true,
        ),
        DevRouteDraft(
          path: '/earn/multi-chain',
          name: 'Multi-Chain',
          phase: 3,
          featured: true,
        ),
        DevRouteDraft(
          path: '/earn/institutional',
          name: 'Institutional',
          phase: 3,
          featured: true,
        ),
        DevRouteDraft(path: '/earn/guide', name: 'Guide', phase: 4),
        DevRouteDraft(path: '/earn/faq', name: 'FAQ', phase: 4),
        DevRouteDraft(
          path: '/earn/notifications',
          name: 'Notifications',
          phase: 4,
        ),
        DevRouteDraft(
          path: '/earn/recommendations',
          name: 'Recommendations',
          phase: 4,
        ),
        DevRouteDraft(
          path: '/earn/regulatory-framework',
          name: 'Regulatory Framework',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/audit-reports',
          name: 'Audit Reports',
          phase: 5,
        ),
        DevRouteDraft(path: '/earn/custody', name: 'Custody', phase: 5),
        DevRouteDraft(
          path: '/earn/suitability-assessment',
          name: 'Suitability Assessment',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/insurance-fund-transparency',
          name: 'Insurance Fund',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/transaction-reporting',
          name: 'Transaction Reporting',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/api-documentation',
          name: 'API Documentation',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/proof-of-reserves',
          name: 'Proof of Reserves',
          phase: 5,
        ),
        DevRouteDraft(
          path: '/earn/risk-dashboard',
          name: 'Risk Dashboard',
          phase: 6,
        ),
        DevRouteDraft(
          path: '/earn/slashing-history',
          name: 'Slashing History',
          phase: 6,
        ),
        DevRouteDraft(
          path: '/earn/validator-health-monitor',
          name: 'Validator Health',
          phase: 6,
        ),
        DevRouteDraft(
          path: '/earn/risk-score-calculator',
          name: 'Risk Calculator',
          phase: 6,
        ),
        DevRouteDraft(
          path: '/earn/emergency-actions',
          name: 'Emergency Actions',
          phase: 6,
        ),
        DevRouteDraft(
          path: '/earn/contingency-plan',
          name: 'Contingency Plan',
          phase: 6,
        ),
        DevRouteDraft(path: '/earn/social-feed', name: 'Social Feed', phase: 7),
        DevRouteDraft(
          path: '/earn/community-governance',
          name: 'Governance',
          phase: 7,
        ),
        DevRouteDraft(path: '/earn/proposals', name: 'Proposals', phase: 7),
        DevRouteDraft(path: '/earn/voting/p1', name: 'Voting', phase: 7),
        DevRouteDraft(path: '/earn/forum', name: 'Forum', phase: 7),
        DevRouteDraft(path: '/earn/webhooks', name: 'Webhooks', phase: 8),
        DevRouteDraft(path: '/earn/data-export', name: 'Data Export', phase: 8),
        DevRouteDraft(
          path: '/earn/third-party-integrations',
          name: 'Integrations',
          phase: 8,
        ),
        DevRouteDraft(
          path: '/earn/developer-console',
          name: 'Developer Console',
          phase: 8,
        ),
      ],
      contractNotes:
          'Reference/admin surface. Keep behind internal role or dev flag. Route rows are local QA checks until the target staking screens are ported.',
      supportedStates: {
        DevScreenState.loading,
        DevScreenState.empty,
        DevScreenState.error,
        DevScreenState.offline,
      },
    );
  }
}
