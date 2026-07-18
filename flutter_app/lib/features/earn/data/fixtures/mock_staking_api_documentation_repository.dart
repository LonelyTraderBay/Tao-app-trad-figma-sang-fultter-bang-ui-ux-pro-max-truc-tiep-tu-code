part of '../repositories/mock_earn_repository.dart';

final class MockStakingApiDocumentationRepository
    extends _MockEarnRepositoryBase
    implements StakingApiDocumentationRepository {
  const MockStakingApiDocumentationRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingApiDocumentationSnapshot> getDocumentation() async {
    await _simulateNetwork();
    return const StakingApiDocumentationSnapshot(
      endpoint: '/api/mobile/earn/earn-api-documentation',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'API Documentation',
      backRoute: '/earn/staking',
      infoTitle: 'Programmatic Staking API',
      infoBody:
          'RESTful API with JSON payloads. Rate limits apply. API key authentication required. Test in sandbox environment before production.',
      stats: [
        StakingApiStatDraft(label: 'Uptime', value: '99.9%', tone: 'warn'),
        StakingApiStatDraft(label: 'Endpoints', value: '5', tone: 'primary'),
        StakingApiStatDraft(label: 'API Version', value: 'v1.0', tone: 'buy'),
      ],
      defaultTab: 'endpoints',
      defaultLanguage: 'javascript',
      endpoints: [
        StakingApiEndpointDraft(
          method: 'POST',
          path: '/staking/stake',
          name: 'Create Stake Position',
          description: 'Stake assets to a specific product',
          params: [
            StakingApiParameterDraft(
              name: 'asset',
              type: 'string',
              required: true,
              description: 'ETH, BTC, SOL, etc.',
            ),
            StakingApiParameterDraft(
              name: 'amount',
              type: 'number',
              required: true,
              description: 'Amount to stake',
            ),
            StakingApiParameterDraft(
              name: 'product',
              type: 'string',
              required: true,
              description: 'flexible, fixed-30, fixed-60, etc.',
            ),
            StakingApiParameterDraft(
              name: 'validator',
              type: 'string',
              required: false,
              description: 'Optional validator address',
            ),
          ],
          responseJson: r'''{
  "positionId": "pos_abc123",
  "asset": "ETH",
  "amount": 1.5,
  "product": "flexible",
  "apy": 4.2,
  "status": "active",
  "createdAt": "2026-03-07T14:30:00Z"
}''',
        ),
        StakingApiEndpointDraft(
          method: 'GET',
          path: '/staking/positions',
          name: 'Get Staking Positions',
          description: 'Retrieve all staking positions for authenticated user',
          params: [
            StakingApiParameterDraft(
              name: 'asset',
              type: 'string',
              required: false,
              description: 'Filter by asset',
            ),
            StakingApiParameterDraft(
              name: 'status',
              type: 'string',
              required: false,
              description: 'active, unstaking, completed',
            ),
            StakingApiParameterDraft(
              name: 'limit',
              type: 'number',
              required: false,
              description: 'Max 100',
            ),
            StakingApiParameterDraft(
              name: 'offset',
              type: 'number',
              required: false,
              description: 'Pagination offset',
            ),
          ],
          responseJson: r'''{
  "positions": [
    {
      "positionId": "pos_abc123",
      "asset": "ETH",
      "amount": 1.5,
      "product": "flexible",
      "apy": 4.2,
      "earnedRewards": 0.05,
      "status": "active"
    }
  ],
  "total": 1
}''',
        ),
        StakingApiEndpointDraft(
          method: 'POST',
          path: '/staking/unstake',
          name: 'Unstake Position',
          description: 'Unstake assets from a position',
          params: [
            StakingApiParameterDraft(
              name: 'positionId',
              type: 'string',
              required: true,
              description: 'Position ID to unstake',
            ),
            StakingApiParameterDraft(
              name: 'amount',
              type: 'number',
              required: false,
              description: 'Partial unstake amount (optional)',
            ),
          ],
          responseJson: r'''{
  "unstakeId": "uns_xyz789",
  "positionId": "pos_abc123",
  "amount": 1.5,
  "estimatedCompletion": "2026-03-09T14:30:00Z",
  "status": "unstaking"
}''',
        ),
        StakingApiEndpointDraft(
          method: 'GET',
          path: '/staking/rewards',
          name: 'Get Rewards History',
          description: 'Retrieve rewards history with filters',
          params: [
            StakingApiParameterDraft(
              name: 'asset',
              type: 'string',
              required: false,
              description: 'Filter by asset',
            ),
            StakingApiParameterDraft(
              name: 'startDate',
              type: 'string',
              required: false,
              description: 'ISO 8601 date',
            ),
            StakingApiParameterDraft(
              name: 'endDate',
              type: 'string',
              required: false,
              description: 'ISO 8601 date',
            ),
            StakingApiParameterDraft(
              name: 'limit',
              type: 'number',
              required: false,
              description: 'Max 100',
            ),
          ],
          responseJson: r'''{
  "rewards": [
    {
      "rewardId": "rew_123",
      "asset": "ETH",
      "amount": 0.001,
      "usdValue": 2.8,
      "timestamp": "2026-03-07T00:00:00Z"
    }
  ],
  "total": 50
}''',
        ),
        StakingApiEndpointDraft(
          method: 'GET',
          path: '/staking/validators',
          name: 'Get Validators List',
          description: 'Get available validators with performance metrics',
          params: [
            StakingApiParameterDraft(
              name: 'asset',
              type: 'string',
              required: true,
              description: 'ETH, SOL, etc.',
            ),
            StakingApiParameterDraft(
              name: 'sortBy',
              type: 'string',
              required: false,
              description: 'apy, uptime, commission',
            ),
          ],
          responseJson: r'''{
  "validators": [
    {
      "address": "0x1234...5678",
      "name": "Validator A",
      "apy": 4.5,
      "commission": 10,
      "uptime": 99.8,
      "totalStaked": 125000
    }
  ],
  "total": 25
}''',
        ),
      ],
      codeExamples: [
        StakingApiCodeExampleDraft(
          language: 'javascript',
          label: 'JavaScript',
          source: r'''// JavaScript/Node.js
const logger = require('./logger');

const response = await fetch('https://api.platform.com/v1/staking/stake', {
  method: 'POST',
  headers: {
    'X-API-Key': 'YOUR_API_KEY',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    asset: 'ETH',
    amount: 1.5,
    product: 'flexible'
  })
});
const data = await response.json();
logger.info('Stake response', { data });''',
        ),
        StakingApiCodeExampleDraft(
          language: 'python',
          label: 'Python',
          source: r'''# Python
import logging
import requests

logger = logging.getLogger('vittrade.staking')
url = 'https://api.platform.com/v1/staking/stake'
headers = {
    'X-API-Key': 'YOUR_API_KEY',
    'Content-Type': 'application/json'
}
body = {
    'asset': 'ETH',
    'amount': 1.5,
    'product': 'flexible'
}

response = requests.post(url, headers=headers, json=body)
data = response.json()
logger.info('Stake response: %s', data)''',
        ),
        StakingApiCodeExampleDraft(
          language: 'curl',
          label: 'cURL',
          source: r'''# cURL
curl -X POST https://api.platform.com/v1/staking/stake \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "asset": "ETH",
    "amount": 1.5,
    "product": "flexible"
  }' ''',
        ),
      ],
      sandboxBaseUrl: 'https://sandbox.platform.com/v1',
      authHeaderExample:
          'curl -H "X-API-Key: YOUR_API_KEY" https://api.platform.com/v1/staking/positions',
      rateLimits: [
        StakingApiRateLimitDraft(
          tier: 'Free',
          requests: 100,
          window: '1 hour',
          price: r'$0',
          recommended: false,
        ),
        StakingApiRateLimitDraft(
          tier: 'Pro',
          requests: 1000,
          window: '1 hour',
          price: r'$29/mo',
          recommended: true,
        ),
        StakingApiRateLimitDraft(
          tier: 'Enterprise',
          requests: 10000,
          window: '1 hour',
          price: 'Custom',
          recommended: false,
        ),
      ],
      errorCodes: [
        StakingApiErrorCodeDraft(
          code: 401,
          message: 'Unauthorized - Invalid API key',
        ),
        StakingApiErrorCodeDraft(
          code: 403,
          message: 'Forbidden - Rate limit exceeded',
        ),
        StakingApiErrorCodeDraft(
          code: 400,
          message: 'Bad Request - Invalid parameters',
        ),
        StakingApiErrorCodeDraft(
          code: 404,
          message: 'Not Found - Endpoint does not exist',
        ),
        StakingApiErrorCodeDraft(code: 500, message: 'Internal Server Error'),
      ],
      footerNote:
          'API documentation last updated: March 7, 2026. For enterprise support, contact api-support@platform.com. Join our Discord for community help.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, endpoint catalogue, code examples, auth details, rate limits, error codes, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingProofOfReservesRepository extends _MockEarnRepositoryBase
    implements StakingProofOfReservesRepository {
  const MockStakingProofOfReservesRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingProofOfReservesSnapshot> getProofOfReserves() async {
    await _simulateNetwork();
    return const StakingProofOfReservesSnapshot(
      endpoint: '/api/mobile/earn/earn-proof-of-reserves',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Proof of Reserves',
      backRoute: '/earn/staking',
      infoTitle: 'Cryptographic Proof of Reserves',
      infoBody:
          'All reserves are verifiable on-chain. Third-party audited monthly. Users can verify their balance inclusion via Merkle tree proofs.',
      overall: StakingReserveOverallDraft(
        totalAssetsUsd: 350000000,
        totalLiabilitiesUsd: 340000000,
        reserveRatio: 102.9,
        lastAudit: '2026-03-01',
        lastUpdated: '25/05/2026, 18:58:56',
      ),
      assets: [
        StakingAssetReserveDraft(
          asset: 'ETH',
          onChainBalance: 125430.50,
          userLiabilities: 122000,
          reserveRatio: 102.8,
          lastUpdated: '14:30',
          walletAddress: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb',
          explorer: 'etherscan.io',
        ),
        StakingAssetReserveDraft(
          asset: 'BTC',
          onChainBalance: 2100.25,
          userLiabilities: 2050,
          reserveRatio: 102.5,
          lastUpdated: '14:30',
          walletAddress: 'bc1q...xyz',
          explorer: 'blockchain.com',
        ),
        StakingAssetReserveDraft(
          asset: 'SOL',
          onChainBalance: 850000,
          userLiabilities: 820000,
          reserveRatio: 103.7,
          lastUpdated: '14:30',
          walletAddress: 'DYw8...ABC',
          explorer: 'solscan.io',
        ),
      ],
      auditReports: [
        StakingReserveAuditReportDraft(
          id: 'por-202603',
          auditor: 'Armanino LLP',
          dateLabel: 'March 2026',
          status: 'Verified',
          reportUrl: '/por/armanino-march-2026.pdf',
          findings:
              'All liabilities covered. Reserve ratio: 102.9%. No discrepancies found.',
        ),
        StakingReserveAuditReportDraft(
          id: 'por-202602',
          auditor: 'Armanino LLP',
          dateLabel: 'February 2026',
          status: 'Verified',
          reportUrl: '/por/armanino-feb-2026.pdf',
          findings: 'Reserve ratio: 102.5%. All balances verified on-chain.',
        ),
        StakingReserveAuditReportDraft(
          id: 'por-202601',
          auditor: 'Armanino LLP',
          dateLabel: 'January 2026',
          status: 'Verified',
          reportUrl: '/por/armanino-jan-2026.pdf',
          findings: 'Reserve ratio: 101.8%. Surplus increased by 3.2% MoM.',
        ),
      ],
      history: [
        StakingReserveHistoryPointDraft(month: 'Apr 2025', ratio: 101.2),
        StakingReserveHistoryPointDraft(month: 'May 2025', ratio: 101.5),
        StakingReserveHistoryPointDraft(month: 'Jun 2025', ratio: 101.7),
        StakingReserveHistoryPointDraft(month: 'Jul 2025', ratio: 101.8),
        StakingReserveHistoryPointDraft(month: 'Aug 2025', ratio: 102.0),
        StakingReserveHistoryPointDraft(month: 'Sep 2025', ratio: 102.1),
        StakingReserveHistoryPointDraft(month: 'Oct 2025', ratio: 102.3),
        StakingReserveHistoryPointDraft(month: 'Nov 2025', ratio: 102.4),
        StakingReserveHistoryPointDraft(month: 'Dec 2025', ratio: 102.5),
        StakingReserveHistoryPointDraft(month: 'Jan 2026', ratio: 101.8),
        StakingReserveHistoryPointDraft(month: 'Feb 2026', ratio: 102.5),
        StakingReserveHistoryPointDraft(month: 'Mar 2026', ratio: 102.9),
      ],
      verifyInfo:
          'Enter your User ID and staked balance to verify inclusion in the Merkle tree. This proves your balance is included in our Proof of Reserves.',
      verifySteps: [
        StakingReserveVerifyStepDraft(
          step: 1,
          title: 'Merkle Tree Generation',
          description:
              'All user balances are hashed and organized into a Merkle tree. The root hash represents the entire set of balances.',
        ),
        StakingReserveVerifyStepDraft(
          step: 2,
          title: 'Proof Generation',
          description:
              'When you verify, you receive a cryptographic proof that links your balance to the Merkle root.',
        ),
        StakingReserveVerifyStepDraft(
          step: 3,
          title: 'Independent Verification',
          description:
              'You can verify the proof independently without revealing other users data.',
        ),
        StakingReserveVerifyStepDraft(
          step: 4,
          title: 'Audit Confirmation',
          description:
              'Third-party auditors verify the Merkle root matches on-chain balances, ensuring 100% coverage.',
        ),
      ],
      privacyNote:
          'Merkle tree verification allows you to prove inclusion without revealing your exact balance to others. Only the hash of your balance is used in the tree.',
      footerNote:
          'Proof of Reserves is updated in real-time. On-chain balances are verified every 10 minutes. Third-party audits conducted monthly by Armanino LLP. Merkle root published publicly at por.platform.com.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, overall reserves, per-asset reserves, audit reports, Merkle verification state, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}
