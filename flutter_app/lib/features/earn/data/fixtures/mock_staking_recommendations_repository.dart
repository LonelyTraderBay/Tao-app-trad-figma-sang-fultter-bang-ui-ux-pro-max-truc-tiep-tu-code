part of '../repositories/mock_earn_repository.dart';

final class MockStakingRecommendationsRepository
    implements StakingRecommendationsRepository {
  const MockStakingRecommendationsRepository();

  @override
  StakingRecommendationsSnapshot getRecommendations() {
    return const StakingRecommendationsSnapshot(
      endpoint: '/api/mobile/earn/earn-recommendations',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Gợi ý Staking',
      backRoute: '/earn/staking',
      riskAssessmentRoute: '/earn/staking/risk-assessment',
      stakingRoute: '/earn/staking',
      heroTitle: 'Gợi ý Staking Cá nhân hóa',
      heroSubtitle:
          'Dựa trên risk tolerance, investment horizon, và portfolio size của bạn, chúng tôi đề xuất chiến lược tối ưu.',
      profile: StakingRecommendationProfileDraft(
        riskTolerance: StakingRecommendationProfileRisk.moderate,
        investmentHorizon: StakingRecommendationHorizon.medium,
        liquidityNeed: StakingRecommendationLiquidity.medium,
        totalPortfolio: 10000,
      ),
      strategies: [
        StakingStrategyDraft(
          id: 'conservative',
          title: 'Chiến lược An toàn',
          description:
              'Ưu tiên bảo toàn vốn với APY ổn định. Phù hợp beginners và người không thích rủi ro.',
          expectedApy: 5.8,
          riskLevel: StakingRecommendationRiskLevel.low,
          allocation: [
            StakingRecommendationAllocationDraft(
              product: 'USDT Flexible',
              asset: 'USDT',
              percentage: 50,
              apy: 6.5,
            ),
            StakingRecommendationAllocationDraft(
              product: 'BTC Fixed 60D',
              asset: 'BTC',
              percentage: 30,
              apy: 5.8,
            ),
            StakingRecommendationAllocationDraft(
              product: 'ETH Fixed 30D',
              asset: 'ETH',
              percentage: 20,
              apy: 4.5,
            ),
          ],
          pros: [
            'Rủi ro thấp nhất (stablecoin + top crypto)',
            '50% thanh khoản tức thì (Flexible)',
            'APY ổn định, không biến động',
          ],
          cons: [
            'APY thấp hơn chiến lược khác',
            'Phụ thuộc stablecoin (USDT risk)',
          ],
          bestFor: [
            'Beginners mới bắt đầu staking',
            'Số lượng lớn (>\$50,000)',
            'Người không thích rủi ro',
          ],
        ),
        StakingStrategyDraft(
          id: 'balanced',
          title: 'Chiến lược Cân bằng',
          description:
              'Cân bằng giữa APY và rủi ro. Phù hợp nhất cho đa số users.',
          expectedApy: 7.2,
          riskLevel: StakingRecommendationRiskLevel.medium,
          recommended: true,
          allocation: [
            StakingRecommendationAllocationDraft(
              product: 'USDT Flexible',
              asset: 'USDT',
              percentage: 30,
              apy: 6.5,
            ),
            StakingRecommendationAllocationDraft(
              product: 'ETH Fixed 60D',
              asset: 'ETH',
              percentage: 35,
              apy: 7.2,
            ),
            StakingRecommendationAllocationDraft(
              product: 'SOL Fixed 30D',
              asset: 'SOL',
              percentage: 25,
              apy: 9.8,
            ),
            StakingRecommendationAllocationDraft(
              product: 'stETH Liquid',
              asset: 'stETH',
              percentage: 10,
              apy: 4.2,
            ),
          ],
          pros: [
            'APY cao hơn 25% so với Conservative',
            'Vẫn có 30% thanh khoản tức thì',
            'Đa dạng hóa tốt (stablecoin + top alts)',
          ],
          cons: [
            'Rủi ro giá altcoin (ETH, SOL)',
            'Liquid staking có depegging risk',
          ],
          bestFor: [
            'Users có kinh nghiệm crypto',
            'Số lượng \$5,000-50,000',
            'Người chấp nhận rủi ro vừa phải',
          ],
        ),
        StakingStrategyDraft(
          id: 'aggressive',
          title: 'Chiến lược Tăng trưởng',
          description:
              'Tối đa hóa APY với rủi ro cao hơn. Phù hợp cho risk-seekers và số lượng nhỏ.',
          expectedApy: 11.3,
          riskLevel: StakingRecommendationRiskLevel.high,
          allocation: [
            StakingRecommendationAllocationDraft(
              product: 'SOL Fixed 90D',
              asset: 'SOL',
              percentage: 35,
              apy: 10.5,
            ),
            StakingRecommendationAllocationDraft(
              product: 'ETH-USDT LP (DeFi)',
              asset: 'ETH-USDT',
              percentage: 30,
              apy: 18.7,
            ),
            StakingRecommendationAllocationDraft(
              product: 'rETH Liquid',
              asset: 'rETH',
              percentage: 20,
              apy: 4.5,
            ),
            StakingRecommendationAllocationDraft(
              product: 'USDT Flexible',
              asset: 'USDT',
              percentage: 15,
              apy: 6.5,
            ),
          ],
          pros: [
            'APY cao nhất (+95% so với Conservative)',
            'Tận dụng DeFi liquidity mining',
            'Vẫn giữ 15% stablecoin an toàn',
          ],
          cons: [
            'Rủi ro smart contract (DeFi)',
            'Chỉ 15% thanh khoản tức thì',
            'Rủi ro giá altcoin cao',
          ],
          bestFor: [
            'Experienced traders',
            'Số lượng nhỏ (<\$5,000)',
            'Người sẵn sàng chấp nhận rủi ro',
          ],
        ),
      ],
      tips: [
        StakingPersonalizedTipDraft(
          id: 'profile',
          title: 'Dựa trên Profile của bạn',
          description:
              'Moderate risk + Medium horizon → Balanced Strategy phù hợp nhất',
          iconKey: 'target',
          tone: EarnRiskLevel.medium,
        ),
        StakingPersonalizedTipDraft(
          id: 'compound',
          title: 'Tối ưu hóa nhanh',
          description:
              'Bật Auto-compound cho tất cả vị thế để tăng APY thêm 5-10%',
          iconKey: 'zap',
          tone: EarnRiskLevel.low,
        ),
        StakingPersonalizedTipDraft(
          id: 'insurance',
          title: 'Giảm rủi ro',
          description:
              'Với \$10,000 portfolio, nên mua Standard Insurance Plan (\$100/năm)',
          iconKey: 'shield',
          tone: EarnRiskLevel.high,
        ),
      ],
      disclaimer:
          'Disclaimer: Đây chỉ là gợi ý dựa trên profile. Không phải tư vấn tài chính. Bạn nên tự nghiên cứu (DYOR) và chịu trách nhiệm cho quyết định đầu tư. APY có thể thay đổi theo thị trường.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, user profile, allocation strategies, personalized tips, and strategy handoff.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingRegulatoryFrameworkRepository
    implements StakingRegulatoryFrameworkRepository {
  const MockStakingRegulatoryFrameworkRepository();

  @override
  StakingRegulatoryFrameworkSnapshot getFramework() {
    return const StakingRegulatoryFrameworkSnapshot(
      endpoint: '/api/mobile/earn/earn-regulatory-framework',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Regulatory Framework',
      backRoute: '/earn/staking',
      tabs: [
        StakingRegulatoryTabDraft(id: 'licenses', label: 'Licenses'),
        StakingRegulatoryTabDraft(id: 'protection', label: 'Protection'),
        StakingRegulatoryTabDraft(id: 'complaints', label: 'Complaints'),
      ],
      defaultTabId: 'licenses',
      heroTitle: 'Regulated & Compliant',
      heroBody:
          'We operate under licenses from leading global regulators. Your funds are protected by investor protection schemes where eligible.',
      licenses: [
        StakingLicenseDraft(
          jurisdiction: 'United States',
          regulator: 'FinCEN (Financial Crimes Enforcement Network)',
          licenseNumber: 'MSB-31000198765432',
          status: StakingLicenseStatus.active,
          issuedDate: '2023-01-15',
          scope: ['Money Services Business', 'Virtual Currency Exchange'],
          website: 'fincen.gov',
        ),
        StakingLicenseDraft(
          jurisdiction: 'United Kingdom',
          regulator: 'Financial Conduct Authority (FCA)',
          licenseNumber: 'FRN: 928619',
          status: StakingLicenseStatus.active,
          issuedDate: '2022-09-20',
          scope: ['Cryptoasset Exchange', 'Custodian Wallet Provider'],
          website: 'fca.org.uk',
        ),
        StakingLicenseDraft(
          jurisdiction: 'European Union',
          regulator: 'Central Bank of Ireland',
          licenseNumber: 'C193305',
          status: StakingLicenseStatus.active,
          issuedDate: '2023-03-10',
          scope: ['MiFID II Investment Firm', 'Payment Institution'],
          website: 'centralbank.ie',
        ),
        StakingLicenseDraft(
          jurisdiction: 'Singapore',
          regulator: 'Monetary Authority of Singapore (MAS)',
          licenseNumber: 'DPT-000123-2023',
          status: StakingLicenseStatus.active,
          issuedDate: '2023-06-01',
          scope: ['Digital Payment Token Service Provider'],
          website: 'mas.gov.sg',
        ),
        StakingLicenseDraft(
          jurisdiction: 'Hong Kong',
          regulator: 'Securities and Futures Commission (SFC)',
          licenseNumber: 'Type 1 & 7: BQR123',
          status: StakingLicenseStatus.pending,
          issuedDate: '2024-01-10',
          scope: ['Virtual Asset Trading Platform'],
          website: 'sfc.hk',
        ),
      ],
      protectionSchemes: [
        StakingProtectionSchemeDraft(
          jurisdiction: 'United Kingdom',
          scheme: 'Financial Services Compensation Scheme (FSCS)',
          coverage: 'GBP 85,000 per person',
          description: 'Protects eligible customers if authorized firm fails',
          eligibility: 'UK retail customers holding fiat currency',
        ),
        StakingProtectionSchemeDraft(
          jurisdiction: 'European Union',
          scheme: 'Deposit Guarantee Scheme (DGS)',
          coverage: 'EUR 100,000 per person',
          description: 'EU-wide protection for eligible deposits',
          eligibility: 'EU residents with eligible deposits',
        ),
        StakingProtectionSchemeDraft(
          jurisdiction: 'United States',
          scheme: 'FDIC Insurance (via partner banks)',
          coverage: '\$250,000 per depositor',
          description: 'Protection for USD deposits held at partner banks',
          eligibility: 'US customers with fiat balances at partner banks',
        ),
      ],
      complaintSteps: [
        StakingComplaintStepDraft(
          step: 1,
          title: 'Contact Customer Support',
          description:
              'Submit your complaint via Live Chat, Email, or Support Ticket. Response within 24 hours.',
          action: 'support@platform.com',
        ),
        StakingComplaintStepDraft(
          step: 2,
          title: 'Escalate to Compliance Team',
          description:
              'If not resolved within 7 days, escalate to our Compliance Officer.',
          action: 'compliance@platform.com',
        ),
        StakingComplaintStepDraft(
          step: 3,
          title: 'External Dispute Resolution',
          description:
              'If unresolved after 8 weeks, you may refer to the Financial Ombudsman Service or relevant authority.',
          action: 'financial-ombudsman.org.uk',
        ),
      ],
      authorityContacts: [
        StakingAuthorityContactDraft(
          name: 'UK Financial Conduct Authority',
          email: 'consumer.queries@fca.org.uk',
          phone: '+44 800 111 6768',
        ),
        StakingAuthorityContactDraft(
          name: 'US FinCEN',
          email: 'frc@fincen.gov',
          phone: '+1 800-949-2732',
        ),
        StakingAuthorityContactDraft(
          name: 'EU Financial Ombudsman',
          email: 'enquiries@financialombudsman.ie',
          phone: '+353 1 567 7000',
        ),
      ],
      licenseNote:
          'All licenses are verified and up-to-date. Tap any license to view full details and verify directly with the regulator.',
      protectionWarning:
          'Important: Cryptocurrency holdings are not covered by traditional deposit insurance. Only fiat balances held at partner banks are eligible for FDIC/FSCS/DGS protection. Staking rewards are subject to smart contract and validator risks.',
      footerNote:
          'This information is accurate as of March 2026. Regulatory status may change. For the most current information, contact Compliance Team or verify directly with the respective regulators.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, jurisdiction licenses, protection schemes, complaint process, authority contacts, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingAuditReportsRepository
    implements StakingAuditReportsRepository {
  const MockStakingAuditReportsRepository();

  @override
  StakingAuditReportsSnapshot getAuditReports() {
    return const StakingAuditReportsSnapshot(
      endpoint: '/api/mobile/earn/earn-audit-reports',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /exports',
      title: 'Audit Reports',
      backRoute: '/earn/staking',
      tabs: [
        StakingAuditTabDraft(id: 'all', label: 'All'),
        StakingAuditTabDraft(id: 'smart-contract', label: 'Smart Contract'),
        StakingAuditTabDraft(id: 'financial', label: 'Financial'),
        StakingAuditTabDraft(id: 'security', label: 'Security'),
      ],
      defaultTabId: 'all',
      heroTitle: 'Transparency & Trust',
      heroBody:
          'All staking smart contracts are audited quarterly by leading security firms. Financial and security audits are conducted annually.',
      stats: [
        StakingAuditStatDraft(
          label: 'Published Audits',
          value: '4',
          tone: EarnRiskLevel.low,
        ),
        StakingAuditStatDraft(
          label: 'Critical Issues',
          value: '0',
          caption: 'All-time',
          tone: EarnRiskLevel.low,
        ),
        StakingAuditStatDraft(
          label: 'Bug Bounty',
          value: '\$2M',
          caption: 'Max payout',
          tone: EarnRiskLevel.medium,
        ),
      ],
      reports: [
        StakingAuditReportDraft(
          id: 'sc-2026-q1',
          type: StakingAuditReportType.smartContract,
          title: 'Q1 2026 Smart Contract Security Audit',
          auditor: 'Trail of Bits',
          dateLabel: '28/02/2026',
          status: StakingAuditReportStatus.published,
          findings: StakingAuditFindingsDraft(
            critical: 0,
            high: 0,
            medium: 2,
            low: 5,
            informational: 8,
          ),
          summary:
              'Comprehensive security audit of staking smart contracts. All critical and high-severity issues resolved. Medium-severity findings relate to gas optimization opportunities.',
          scope: [
            'Staking Pool Contract',
            'Reward Distribution',
            'Validator Registry',
            'Emergency Pause Mechanism',
          ],
          pdfUrl: '/audits/trail-of-bits-q1-2026.pdf',
        ),
        StakingAuditReportDraft(
          id: 'sc-2025-q4',
          type: StakingAuditReportType.smartContract,
          title: 'Q4 2025 Smart Contract Audit',
          auditor: 'Sigma Prime',
          dateLabel: '20/11/2025',
          status: StakingAuditReportStatus.published,
          findings: StakingAuditFindingsDraft(
            critical: 0,
            high: 1,
            medium: 3,
            low: 7,
            informational: 12,
          ),
          summary:
              'All high-severity issues patched before deployment. Focus areas: reentrancy protection, integer overflow checks, access control.',
          scope: [
            'Liquid Staking Module',
            'Auto-Compound Logic',
            'Insurance Fund Contract',
          ],
          pdfUrl: '/audits/sigma-prime-q4-2025.pdf',
        ),
        StakingAuditReportDraft(
          id: 'fin-2025',
          type: StakingAuditReportType.financial,
          title: '2025 Annual Financial Audit',
          auditor: 'Deloitte',
          dateLabel: '31/01/2026',
          status: StakingAuditReportStatus.published,
          findings: StakingAuditFindingsDraft(
            critical: 0,
            high: 0,
            medium: 0,
            low: 0,
            informational: 0,
          ),
          summary:
              'Unqualified opinion. Financial statements present fairly the financial position. Internal controls are adequate and effective.',
          scope: [
            'Balance Sheet',
            'Income Statement',
            'Cash Flow',
            'Internal Controls',
            'Client Fund Segregation',
          ],
          pdfUrl: '/audits/deloitte-financial-2025.pdf',
        ),
        StakingAuditReportDraft(
          id: 'sec-2025',
          type: StakingAuditReportType.security,
          title: 'SOC 2 Type II Audit 2025',
          auditor: 'PwC',
          dateLabel: '15/12/2025',
          status: StakingAuditReportStatus.published,
          findings: StakingAuditFindingsDraft(
            critical: 0,
            high: 0,
            medium: 1,
            low: 3,
            informational: 5,
          ),
          summary:
              'Successfully passed SOC 2 Type II audit. Controls operating effectively for Security, Availability, and Confidentiality.',
          scope: [
            'Access Controls',
            'Encryption',
            'Incident Response',
            'Business Continuity',
            'Change Management',
          ],
          pdfUrl: '/audits/pwc-soc2-2025.pdf',
        ),
        StakingAuditReportDraft(
          id: 'sc-2026-q2',
          type: StakingAuditReportType.smartContract,
          title: 'Q2 2026 Smart Contract Audit',
          auditor: 'ConsenSys Diligence',
          dateLabel: '15/05/2026',
          status: StakingAuditReportStatus.inProgress,
          findings: StakingAuditFindingsDraft(
            critical: 0,
            high: 0,
            medium: 0,
            low: 0,
            informational: 0,
          ),
          summary:
              'Audit currently in progress. Expected completion: May 20, 2026.',
          scope: [
            'Cross-Chain Staking',
            'Governance Module',
            'Slashing Protection',
          ],
        ),
      ],
      bugBounty: StakingBugBountyDraft(
        title: 'Immunefi Bug Bounty',
        subtitle: 'Up to \$2M for critical vulnerabilities',
        body:
            'We partner with Immunefi to reward security researchers who discover vulnerabilities in our smart contracts and infrastructure.',
        programUrl: 'https://immunefi.com',
        payouts: [
          StakingBugBountyPayoutDraft(
            severity: 'Critical',
            amount: '\$2,000,000',
            tone: EarnRiskLevel.high,
          ),
          StakingBugBountyPayoutDraft(
            severity: 'High',
            amount: '\$100,000',
            tone: EarnRiskLevel.medium,
          ),
          StakingBugBountyPayoutDraft(
            severity: 'Medium',
            amount: '\$10,000',
            tone: EarnRiskLevel.medium,
          ),
          StakingBugBountyPayoutDraft(
            severity: 'Low',
            amount: '\$1,000',
            tone: EarnRiskLevel.low,
          ),
        ],
      ),
      footerNote:
          'All audit reports are published within 14 days of completion. Smart contract audits are conducted quarterly. Financial and security audits are conducted annually. Reports are available for download and verification.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, audit reports, findings, scope chips, bug bounty data, POST /exports action state, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}
