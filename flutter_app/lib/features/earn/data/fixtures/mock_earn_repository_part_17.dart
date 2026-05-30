part of '../repositories/mock_earn_repository.dart';

final class MockStakingCustodyRepository implements StakingCustodyRepository {
  const MockStakingCustodyRepository();

  @override
  StakingCustodySnapshot getCustody() {
    return const StakingCustodySnapshot(
      endpoint: '/api/mobile/earn/earn-custody',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Custody & Segregation',
      backRoute: '/earn/staking',
      heroTitle: 'Institutional-Grade Custody',
      heroBody:
          'Your staked assets are held by Fireblocks, a regulated institutional custodian, segregated from platform operational funds.',
      custodian: StakingCustodianDraft(
        name: 'Fireblocks',
        type: 'Institutional Digital Asset Custodian',
        founded: '2018',
        headquarters: 'New York, USA',
        licenses: ['NY Trust Charter', 'SOC 2 Type II', 'ISO 27001'],
        insurance: "\$255M Crime Insurance (Lloyd's of London)",
        clients: '1,800+ institutions',
        aum: '\$4 Trillion+ in digital assets transferred',
      ),
      segregationBody:
          'Client staking funds are completely segregated from platform operational funds. In the event of insolvency, your assets are protected and returned in full.',
      segregation: [
        StakingCustodyAllocationDraft(
          name: 'Client Staking Funds',
          value: 85,
          tone: EarnRiskLevel.low,
        ),
        StakingCustodyAllocationDraft(
          name: 'Platform Operational',
          value: 10,
          tone: EarnRiskLevel.high,
        ),
        StakingCustodyAllocationDraft(
          name: 'Insurance Reserve',
          value: 5,
          tone: EarnRiskLevel.medium,
        ),
      ],
      segregationLegend: [
        StakingCustodyLegendDraft(
          iconKey: 'building',
          label: 'Client Funds',
          description: 'Held in segregated accounts at custodian',
          tone: EarnRiskLevel.low,
        ),
        StakingCustodyLegendDraft(
          iconKey: 'lock',
          label: 'Platform Operational',
          description: 'Company operating capital (separate)',
          tone: EarnRiskLevel.high,
        ),
        StakingCustodyLegendDraft(
          iconKey: 'shield',
          label: 'Insurance Reserve',
          description: 'Emergency fund for slashing events',
          tone: EarnRiskLevel.medium,
        ),
      ],
      hotColdBody:
          '95% of staked assets are held in cold storage (offline, air-gapped). Only 5% in hot wallets for operational liquidity (withdrawals, auto-compound).',
      hotCold: [
        StakingCustodyAllocationDraft(
          name: 'Cold Wallet',
          value: 95,
          tone: EarnRiskLevel.low,
        ),
        StakingCustodyAllocationDraft(
          name: 'Hot Wallet',
          value: 5,
          tone: EarnRiskLevel.medium,
        ),
      ],
      reconciliationBody:
          'Every day, we reconcile on-chain balances with custodian records. 100% match rate since launch.',
      reconciliationLogs: [
        StakingReconciliationLogDraft(
          dateLabel: '07/03/2026',
          onChainUsd: 125430500,
          custodyUsd: 125430500,
          discrepancyUsd: 0,
        ),
        StakingReconciliationLogDraft(
          dateLabel: '06/03/2026',
          onChainUsd: 124850250,
          custodyUsd: 124850250,
          discrepancyUsd: 0,
        ),
        StakingReconciliationLogDraft(
          dateLabel: '05/03/2026',
          onChainUsd: 123900750,
          custodyUsd: 123900750,
          discrepancyUsd: 0,
        ),
        StakingReconciliationLogDraft(
          dateLabel: '04/03/2026',
          onChainUsd: 122500000,
          custodyUsd: 122500000,
          discrepancyUsd: 0,
        ),
        StakingReconciliationLogDraft(
          dateLabel: '03/03/2026',
          onChainUsd: 121200500,
          custodyUsd: 121200500,
          discrepancyUsd: 0,
        ),
      ],
      transparencyBody:
          'All staking transactions are visible on-chain. You can verify your stake anytime using blockchain explorers.',
      transparencyAddresses: [
        StakingTransparencyAddressDraft(
          label: 'Ethereum Mainnet',
          address: '0x1234...5678',
          explorer: 'etherscan.io',
        ),
        StakingTransparencyAddressDraft(
          label: 'Polygon',
          address: '0xabcd...ef12',
          explorer: 'polygonscan.com',
        ),
        StakingTransparencyAddressDraft(
          label: 'BNB Chain',
          address: '0x9876...5432',
          explorer: 'bscscan.com',
        ),
      ],
      footerNote:
          'Custody arrangements are reviewed quarterly. Custodian is independently audited annually. Insurance coverage is updated to reflect total AUM. All disclosures are accurate as of March 2026.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, custody provider, segregation allocations, hot/cold wallet distribution, reconciliation audit trail, transparency addresses, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingSuitabilityAssessmentRepository
    implements StakingSuitabilityAssessmentRepository {
  const MockStakingSuitabilityAssessmentRepository();

  @override
  StakingSuitabilityAssessmentSnapshot getAssessment() {
    return const StakingSuitabilityAssessmentSnapshot(
      endpoint: '/api/mobile/earn/earn-suitability-assessment',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Suitability Assessment',
      resultTitle: 'Assessment Result',
      backRoute: '/earn/staking',
      stakingRoute: '/earn/staking',
      infoTitle: 'Why This Assessment?',
      infoBody:
          'Regulatory compliance requires us to assess your suitability for high-risk staking products. This helps protect you from unsuitable investments. Your answers are confidential.',
      questions: [
        StakingSuitabilityQuestionDraft(
          id: 'experience',
          question: 'How long have you invested in cryptocurrency?',
          type: StakingSuitabilityQuestionType.single,
          options: [
            StakingSuitabilityOptionDraft(label: 'No experience', weight: 0),
            StakingSuitabilityOptionDraft(
              label: 'Less than 1 year',
              weight: 10,
            ),
            StakingSuitabilityOptionDraft(label: '1-3 years', weight: 20),
            StakingSuitabilityOptionDraft(label: '3-5 years', weight: 30),
            StakingSuitabilityOptionDraft(label: '5+ years', weight: 40),
          ],
        ),
        StakingSuitabilityQuestionDraft(
          id: 'net-worth',
          question:
              'What is your total net worth (excluding primary residence)?',
          type: StakingSuitabilityQuestionType.single,
          options: [
            StakingSuitabilityOptionDraft(
              label: 'Less than \$10,000',
              weight: 0,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$10,000-\$50,000',
              weight: 10,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$50,000-\$100,000',
              weight: 20,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$100,000-\$500,000',
              weight: 30,
            ),
            StakingSuitabilityOptionDraft(label: 'Over \$500,000', weight: 40),
          ],
        ),
        StakingSuitabilityQuestionDraft(
          id: 'income',
          question: 'What is your annual income?',
          type: StakingSuitabilityQuestionType.single,
          options: [
            StakingSuitabilityOptionDraft(
              label: 'Less than \$30,000',
              weight: 0,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$30,000-\$60,000',
              weight: 10,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$60,000-\$100,000',
              weight: 15,
            ),
            StakingSuitabilityOptionDraft(
              label: '\$100,000-\$200,000',
              weight: 20,
            ),
            StakingSuitabilityOptionDraft(label: 'Over \$200,000', weight: 25),
          ],
        ),
        StakingSuitabilityQuestionDraft(
          id: 'objectives',
          question: 'What is your primary investment objective?',
          type: StakingSuitabilityQuestionType.single,
          options: [
            StakingSuitabilityOptionDraft(
              label: 'Capital Preservation',
              weight: 5,
            ),
            StakingSuitabilityOptionDraft(label: 'Stable Income', weight: 15),
            StakingSuitabilityOptionDraft(label: 'Growth', weight: 25),
            StakingSuitabilityOptionDraft(
              label: 'Aggressive Growth',
              weight: 35,
            ),
          ],
        ),
        StakingSuitabilityQuestionDraft(
          id: 'horizon',
          question: 'What is your investment time horizon for staked assets?',
          type: StakingSuitabilityQuestionType.single,
          options: [
            StakingSuitabilityOptionDraft(label: 'Less than 1 year', weight: 0),
            StakingSuitabilityOptionDraft(label: '1-3 years', weight: 10),
            StakingSuitabilityOptionDraft(label: '3-5 years', weight: 20),
            StakingSuitabilityOptionDraft(label: '5+ years', weight: 30),
          ],
        ),
        StakingSuitabilityQuestionDraft(
          id: 'risk',
          question:
              'How would you rate your risk tolerance? (1 = Very Conservative, 10 = Very Aggressive)',
          type: StakingSuitabilityQuestionType.slider,
          min: 1,
          max: 10,
          weight: 3,
        ),
        StakingSuitabilityQuestionDraft(
          id: 'knowledge',
          question: 'Test your staking knowledge (5 questions)',
          type: StakingSuitabilityQuestionType.quiz,
          weight: 5,
          quizQuestions: [
            StakingSuitabilityQuizDraft(
              question: 'What is slashing in Proof of Stake?',
              options: [
                'A reward mechanism',
                'A penalty for validator misbehavior',
                'A way to unstake faster',
                'A fee structure',
              ],
              correctIndex: 1,
            ),
            StakingSuitabilityQuizDraft(
              question: 'What does APY stand for?',
              options: [
                'Annual Payment Yield',
                'Annual Percentage Yield',
                'Average Profit Yearly',
                'Asset Price Yield',
              ],
              correctIndex: 1,
            ),
            StakingSuitabilityQuizDraft(
              question: 'What is a lock-up period?',
              options: [
                'Time to earn rewards',
                'Time funds are locked and cannot be withdrawn',
                'Time to verify transactions',
                'Validator uptime',
              ],
              correctIndex: 1,
            ),
            StakingSuitabilityQuizDraft(
              question: 'What is liquid staking?',
              options: [
                'Staking only stablecoins',
                'Staking with instant withdrawal',
                'Staking while maintaining liquidity via derivative tokens',
                'Staking in liquidity pools',
              ],
              correctIndex: 2,
            ),
            StakingSuitabilityQuizDraft(
              question: 'What is the main risk of staking?',
              options: [
                'High fees',
                'Slashing and smart contract risk',
                'Slow transactions',
                'No rewards',
              ],
              correctIndex: 1,
            ),
          ],
        ),
      ],
      profiles: [
        StakingSuitabilityProfileDraft(
          level: StakingSuitabilityProfileLevel.conservative,
          minScore: 0,
          maxScore: 39,
          label: 'Conservative',
          description:
              'You prefer low-risk, stable returns. Suitable products: Flexible staking, stablecoins, short lock-up periods.',
          products: ['USDT Flexible', 'USDC Flexible', 'BTC Fixed 30D'],
          warning:
              'High-risk products are restricted until your suitability profile changes.',
        ),
        StakingSuitabilityProfileDraft(
          level: StakingSuitabilityProfileLevel.moderate,
          minScore: 40,
          maxScore: 69,
          label: 'Moderate',
          description:
              'You accept moderate risk for higher returns. Suitable products: ETH staking, 60-90 day fixed terms, auto-compound.',
          products: [
            'ETH Fixed 60D',
            'SOL Fixed 30D',
            'Auto-compound ETH',
            'BTC Fixed 90D',
          ],
          warning: null,
        ),
        StakingSuitabilityProfileDraft(
          level: StakingSuitabilityProfileLevel.aggressive,
          minScore: 70,
          maxScore: 100,
          label: 'Aggressive',
          description:
              'You seek maximum returns and accept high risk. Suitable products: DeFi staking, liquid staking, governance, long lock-ups.',
          products: [
            'Liquid Staking ETH',
            'DeFi Yield Farming',
            'Governance Staking',
            'Fixed 180D',
          ],
          warning: null,
        ),
      ],
      validUntil: 'March 7, 2027',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, questionnaire state, scoring result, suitability restrictions, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockSavingsComparisonRepository
    implements SavingsComparisonRepository {
  const MockSavingsComparisonRepository();

  @override
  SavingsComparisonSnapshot getComparison() {
    final savings = const MockSavingsRepository().getSavings();

    return SavingsComparisonSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-comparison',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'So sánh sản phẩm',
      backRoute: '/earn/savings',
      defaultProductIds: const ['sav001', 'sav002'],
      maxCompare: 3,
      products: savings.products,
      details: const {
        'sav001': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.low,
          capacityPercent: 62,
          participants: 45230,
          earlyWithdrawal: 'Bất kỳ lúc nào',
          interestPayout: 'Hàng ngày',
          compounding: 'Tự động',
          insurance: true,
          minAmount: '1.0000 USDT',
          minAmountValue: 1,
          maxDeposit: 'Không giới hạn',
          features: ['Auto-compound', 'Rút bất kỳ lúc nào', 'Bảo hiểm quỹ'],
        ),
        'sav002': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.low,
          capacityPercent: 90,
          participants: 12480,
          earlyWithdrawal: 'Mất toàn bộ lãi',
          interestPayout: 'Cuối kỳ',
          compounding: 'Không',
          insurance: true,
          minAmount: '100.0000 USDT',
          minAmountValue: 100,
          maxDeposit: '\$50,000',
          features: ['APY cao', 'VIP bonus', 'Bảo hiểm quỹ'],
        ),
        'sav003': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.medium,
          capacityPercent: 93,
          participants: 6720,
          earlyWithdrawal: 'Mất toàn bộ lãi',
          interestPayout: 'Cuối kỳ',
          compounding: 'Không',
          insurance: true,
          minAmount: '100.0000 USDT',
          minAmountValue: 100,
          maxDeposit: '\$100,000',
          features: ['APY cao nhất', 'Bảo hiểm quỹ', 'Priority support'],
        ),
        'sav004': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.low,
          capacityPercent: 48,
          participants: 18340,
          earlyWithdrawal: 'Bất kỳ lúc nào',
          interestPayout: 'Hàng ngày',
          compounding: 'Tự động',
          insurance: true,
          minAmount: '0.0001 BTC',
          minAmountValue: 0.0001,
          maxDeposit: 'Không giới hạn',
          features: ['Auto-compound', 'Rút bất kỳ lúc nào', 'BTC exposure'],
        ),
        'sav005': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.low,
          capacityPercent: 82,
          participants: 9120,
          earlyWithdrawal: 'Mất toàn bộ lãi',
          interestPayout: 'Cuối kỳ',
          compounding: 'Không',
          insurance: true,
          minAmount: '0.001 BTC',
          minAmountValue: 0.001,
          maxDeposit: '5 BTC',
          features: ['VIP bonus', 'Bảo hiểm quỹ', 'BTC exposure'],
        ),
        'sav006': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.low,
          capacityPercent: 55,
          participants: 15670,
          earlyWithdrawal: 'Bất kỳ lúc nào',
          interestPayout: 'Hàng ngày',
          compounding: 'Tự động',
          insurance: true,
          minAmount: '0.01 ETH',
          minAmountValue: 0.01,
          maxDeposit: 'Không giới hạn',
          features: ['Auto-compound', 'ETH exposure', 'Rút tức thì'],
        ),
        'sav007': SavingsComparisonDetailDraft(
          risk: EarnRiskLevel.medium,
          capacityPercent: 35,
          participants: 4890,
          earlyWithdrawal: 'Mất toàn bộ lãi',
          interestPayout: 'Cuối kỳ',
          compounding: 'Không',
          insurance: true,
          minAmount: '1 SOL',
          minAmountValue: 1,
          maxDeposit: '50K SOL',
          features: ['APY cao', 'SOL ecosystem', 'Quota thấp'],
        ),
      },
      disclaimer:
          'APY có thể thay đổi theo điều kiện thị trường. Dữ liệu so sánh mang tính tham khảo, không phải cam kết lợi nhuận. Vui lòng đọc kỹ điều khoản từng sản phẩm trước khi đăng ký.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, and riskData.',
      supportedStates: const {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}
