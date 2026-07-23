part of '../repositories/mock_earn_repository.dart';

final class MockStakingInsuranceFundTransparencyRepository
    extends _MockEarnRepositoryBase
    implements StakingInsuranceFundTransparencyRepository {
  const MockStakingInsuranceFundTransparencyRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingInsuranceFundTransparencySnapshot> getTransparency() async {
    await _simulateNetwork();
    return const StakingInsuranceFundTransparencySnapshot(
      endpoint: '/api/mobile/earn/earn-insurance-fund-transparency',
      actionDraft: 'POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Insurance Fund',
      backRoute: '/earn/staking',
      infoTitle: 'User Protection Fund',
      infoBody:
          'A dedicated fund covers up to 50-100% of losses from slashing, smart contract exploits, and validator failures. Fully transparent, audited monthly.',
      totalBalance: 50000000,
      targetRatio: 150,
      currentRatio: 165,
      liabilities: 30303030,
      surplus: 19696970,
      lastUpdated: '07/03/2026, 21:30',
      assets: [
        StakingInsuranceFundAssetDraft(
          asset: 'ETH',
          value: 30000000,
          percentage: 60,
          colorKey: 'primary',
        ),
        StakingInsuranceFundAssetDraft(
          asset: 'BTC',
          value: 15000000,
          percentage: 30,
          colorKey: 'warning',
        ),
        StakingInsuranceFundAssetDraft(
          asset: 'USDT',
          value: 5000000,
          percentage: 10,
          colorKey: 'success',
        ),
      ],
      claims: [
        StakingInsuranceFundClaimDraft(
          id: 'c-20260220',
          date: '20/02/2026',
          user: 'User#12345',
          reason: 'Validator slashing (2%)',
          loss: 125.50,
          coverage: 50,
          payout: 62.75,
          status: 'approved',
          processingDays: 3,
        ),
        StakingInsuranceFundClaimDraft(
          id: 'c-20260115',
          date: '15/01/2026',
          user: 'User#67890',
          reason: 'Smart contract exploit (partial)',
          loss: 5000,
          coverage: 80,
          payout: 4000,
          status: 'approved',
          processingDays: 7,
        ),
        StakingInsuranceFundClaimDraft(
          id: 'c-20251210',
          date: '10/12/2025',
          user: 'User#24680',
          reason: 'Validator downtime loss',
          loss: 50,
          coverage: 100,
          payout: 50,
          status: 'approved',
          processingDays: 2,
        ),
        StakingInsuranceFundClaimDraft(
          id: 'c-20251105',
          date: '05/11/2025',
          user: 'User#13579',
          reason: 'Slashing event (1.5%)',
          loss: 200,
          coverage: 50,
          payout: 100,
          status: 'approved',
          processingDays: 4,
        ),
      ],
      history: [
        StakingInsuranceFundHistoryDraft(
          month: 'Apr 2025',
          balance: 45.2,
          ratio: 155,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'May 2025',
          balance: 46,
          ratio: 157,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Jun 2025',
          balance: 46.8,
          ratio: 159,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Jul 2025',
          balance: 47.5,
          ratio: 160,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Aug 2025',
          balance: 48,
          ratio: 161,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Sep 2025',
          balance: 48.5,
          ratio: 162,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Oct 2025',
          balance: 49,
          ratio: 163,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Nov 2025',
          balance: 49.2,
          ratio: 164,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Dec 2025',
          balance: 49.5,
          ratio: 164,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Jan 2026',
          balance: 49.8,
          ratio: 165,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Feb 2026',
          balance: 49.9,
          ratio: 165,
        ),
        StakingInsuranceFundHistoryDraft(
          month: 'Mar 2026',
          balance: 50,
          ratio: 165,
        ),
      ],
      stakingFeeContribution: 2,
      monthlyContribution: 150000,
      ytdContributions: 450000,
      totalContributed: 5200000,
      footerNote:
          'Insurance fund is audited monthly by third-party firms. All claim data is anonymized. Fund balance and ratio are updated in real-time. Last audit: March 1, 2026.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, insurance fund balance, asset breakdown, claims history, monthly audit report metadata, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingTransactionReportingRepository
    extends _MockEarnRepositoryBase
    implements StakingTransactionReportingRepository {
  const MockStakingTransactionReportingRepository({
    super.simulateError,
    super.loadDelay,
  });

  @override
  Future<StakingTransactionReportingSnapshot> getReporting() async {
    await _simulateNetwork();
    return const StakingTransactionReportingSnapshot(
      endpoint: '/api/mobile/earn/earn-transaction-reporting',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /exports',
      title: 'Tax Reporting',
      backRoute: '/earn/staking',
      infoTitle: 'Tax Compliance Made Easy',
      infoBody:
          'Generate IRS-compliant tax reports. Export to TurboTax, CoinTracker, or download PDF forms. Always consult a tax professional.',
      years: ['2025', '2024', '2023'],
      defaultYear: '2025',
      defaultCostBasis: 'FIFO',
      summary: StakingTaxSummaryDraft(
        totalStakingIncome: 5234.56,
        totalCapitalGains: 12345.67,
        costBasis: 100000,
        proceeds: 112345.67,
        shortTermGains: 8000,
        longTermGains: 4345.67,
        rewardsByAsset: [
          StakingTaxRewardAssetDraft(asset: 'ETH', amount: 2.5, usdValue: 7000),
          StakingTaxRewardAssetDraft(
            asset: 'BTC',
            amount: 0.05,
            usdValue: 2250,
          ),
          StakingTaxRewardAssetDraft(asset: 'SOL', amount: 50, usdValue: 4750),
        ],
      ),
      transactions: [
        StakingTaxTransactionDraft(
          date: '31/12/2025',
          type: 'stake',
          asset: 'ETH',
          amount: 10,
          usdValue: 28000,
          costBasis: 28000,
          taxable: false,
        ),
        StakingTaxTransactionDraft(
          date: '15/12/2025',
          type: 'reward',
          asset: 'ETH',
          amount: 0.1,
          usdValue: 280,
          taxable: true,
        ),
        StakingTaxTransactionDraft(
          date: '20/11/2025',
          type: 'unstake',
          asset: 'BTC',
          amount: 0.5,
          usdValue: 22500,
          costBasis: 20000,
          taxable: true,
        ),
        StakingTaxTransactionDraft(
          date: '01/11/2025',
          type: 'reward',
          asset: 'SOL',
          amount: 25,
          usdValue: 2375,
          taxable: true,
        ),
        StakingTaxTransactionDraft(
          date: '15/10/2025',
          type: 'stake',
          asset: 'SOL',
          amount: 200,
          usdValue: 18000,
          costBasis: 18000,
          taxable: false,
        ),
        StakingTaxTransactionDraft(
          date: '01/09/2025',
          type: 'reward',
          asset: 'ETH',
          amount: 0.05,
          usdValue: 140,
          taxable: true,
        ),
      ],
      costBasisMethods: [
        StakingCostBasisMethodDraft(
          value: 'FIFO',
          label: 'First In, First Out (FIFO)',
          description:
              'Default IRS method. First purchased assets are first sold.',
        ),
        StakingCostBasisMethodDraft(
          value: 'LIFO',
          label: 'Last In, First Out (LIFO)',
          description:
              'Last purchased assets are first sold. May reduce short-term gains.',
        ),
        StakingCostBasisMethodDraft(
          value: 'Specific ID',
          label: 'Specific Identification',
          description:
              'Manually identify which lots to sell. Requires detailed records.',
        ),
        StakingCostBasisMethodDraft(
          value: 'Average Cost',
          label: 'Average Cost Basis',
          description: 'Average cost of all holdings. Simplified calculation.',
        ),
      ],
      taxForms: [
        StakingTaxExportOptionDraft(
          name: 'Form 1099-MISC',
          description: 'Staking income report',
        ),
        StakingTaxExportOptionDraft(
          name: 'Form 8949',
          description: 'Capital gains & losses',
        ),
        StakingTaxExportOptionDraft(
          name: 'Schedule D',
          description: 'Capital gains summary',
        ),
      ],
      integrations: [
        StakingTaxExportOptionDraft(
          name: 'TurboTax CSV',
          description: 'Import directly to TurboTax',
        ),
        StakingTaxExportOptionDraft(
          name: 'CoinTracker JSON',
          description: 'Export to CoinTracker',
        ),
        StakingTaxExportOptionDraft(
          name: 'Koinly CSV',
          description: 'Export to Koinly',
        ),
      ],
      rawDataFormats: [
        StakingTaxExportOptionDraft(
          name: 'CSV',
          description: 'All transactions',
        ),
        StakingTaxExportOptionDraft(
          name: 'JSON',
          description: 'Developer-friendly format',
        ),
      ],
      resources: [
        StakingTaxResourceDraft(label: 'IRS Crypto Tax Guide', url: 'irs.gov'),
        StakingTaxResourceDraft(
          label: 'Find a Crypto Tax Professional',
          url: 'taxbit.com',
        ),
        StakingTaxResourceDraft(
          label: 'Tax Loss Harvesting Guide',
          url: 'platform.com/tax-guide',
        ),
      ],
      taxNotice:
          'These reports are for informational purposes only. Tax laws vary by jurisdiction. Always consult a qualified tax professional or CPA before filing. We are not tax advisors.',
      footerNote:
          'Tax reports are generated using real-time transaction data. Historical data cannot be modified once a tax year closes. Reports use fair market value at the time of transaction (UTC timezone). Last updated: 25/05/2026.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, tax summary, transaction ledger, cost basis method state, export job state, and loading/empty/error/offline states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}
