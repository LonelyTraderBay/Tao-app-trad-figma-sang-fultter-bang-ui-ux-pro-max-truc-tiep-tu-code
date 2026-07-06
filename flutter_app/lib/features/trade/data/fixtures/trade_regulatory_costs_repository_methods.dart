part of '../repositories/mock_trade_repository.dart';

mixin _MockTradeRepositoryRegulatoryCostsMethods on _MockTradeRepositoryBase {
  @override
  TradeClientMoneyProtectionSnapshot getClientMoneyProtection() {
    return const TradeClientMoneyProtectionSnapshot(
      balance: 45230.50,
      trustAccount: 'Barclays UK',
      lastReconciled: 'Today 09:00 UTC',
      protections: _clientMoneyProtections,
      insolvencySummary:
          'If we become insolvent, your segregated funds will be '
          'distributed to clients proportionally, not used to pay company '
          'debts.',
      insolvencyDetail:
          "Segregated client money is held on trust and is not available to "
          "general creditors. The FCA's client money rules ensure you have "
          'priority access to your funds in an insolvency scenario.',
      endpoint: '/api/mobile/trade/trade-copy-trading-client-money-protection',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCassReconciliationSnapshot getCassReconciliation() {
    return const TradeCassReconciliationSnapshot(
      reconciledCount: 3,
      resolvedCount: 1,
      outstandingCount: 0,
      records: _cassReconciliationRecords,
      endpoint: '/api/mobile/trade/trade-copy-trading-cass-reconciliation',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeInvestorCompensationSnapshot getInvestorCompensation() {
    return const TradeInvestorCompensationSnapshot(
      coverageLimit: '£85,000',
      summary:
          'Your investments are protected by the UK Financial Services '
          'Compensation Scheme (FSCS)',
      coveredMessage:
          "You're covered: If our firm fails, FSCS may pay compensation for "
          'claims up to £85,000 per eligible person.',
      automaticProtection:
          'FSCS protection is automatic for eligible claimants. No '
          'registration required. Coverage applies if we cannot meet our '
          'obligations.',
      overviewDescription:
          "The Financial Services Compensation Scheme (FSCS) is the UK's "
          'statutory deposit insurance and investors compensation scheme for '
          'customers of authorised financial services firms.',
      overviewItems: _investorCompensationOverviewItems,
      coverageItems: _investorCompensationCoverageItems,
      warning:
          'Note: Some products may not be covered. Check eligibility for each '
          'product type.',
      eligibleCustomers: _investorCompensationEligibleCustomers,
      ineligibleCustomers: _investorCompensationIneligibleCustomers,
      claimSteps: _investorCompensationClaimSteps,
      endpoint: '/api/mobile/trade/trade-copy-trading-investor-compensation',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeExAnteCostsSnapshot getExAnteCosts() {
    return const TradeExAnteCostsSnapshot(
      investmentAmount: 10000,
      holdingPeriodYears: 3,
      costs: _exAnteCostItems,
      endpoint: '/api/mobile/trade/trade-copy-trading-ex-ante-costs',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeRiyCalculatorSnapshot getRiyCalculator() {
    return const TradeRiyCalculatorSnapshot(
      investmentAmount: 10000,
      expectedReturnPct: 8,
      totalCostsPct: 4.5,
      holdingPeriodYears: 5,
      endpoint: '/api/mobile/trade/trade-copy-trading-riy-calculator',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeExPostCostsReportSnapshot getExPostCostsReport() {
    return const TradeExPostCostsReportSnapshot(
      reports: _exPostCostReports,
      endpoint: '/api/mobile/trade/trade-copy-trading-ex-post-costs-report',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable; '
          'POST /exports',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeKidGeneratorSnapshot getKidGenerator() {
    return const TradeKidGeneratorSnapshot(
      document: TradeKidDocument(
        title: 'Mirror Copy Trading - KID',
        lastUpdated: 'March 8, 2026',
        version: '2.1',
        documentType: 'PRIIPs KID',
        pages: 3,
        maxPages: 3,
      ),
      sections: _kidSections,
      endpoint: '/api/mobile/trade/trade-copy-trading-kid-generator',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradePerformanceScenariosSnapshot getPerformanceScenarios() {
    return const TradePerformanceScenariosSnapshot(
      investment: 10000,
      holdingPeriods: [1, 3, 5],
      defaultHoldingPeriod: 3,
      scenarios: _performanceScenarios,
      endpoint: '/api/mobile/trade/trade-copy-trading-performance-scenarios',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeRiskIndicatorSnapshot getRiskIndicatorExplainer() {
    return const TradeRiskIndicatorSnapshot(
      productName: 'Mirror Copy Trading',
      productSri: 6,
      holdingPeriodYears: 3,
      levels: _riskIndicatorLevels,
      additionalRisks: _riskIndicatorAdditionalRisks,
      endpoint: '/api/mobile/trade/trade-copy-trading-risk-indicator-explainer',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeExPostCostsReportExportResult createExPostCostsReportExport({
    int year = 2025,
  }) {
    return TradeExPostCostsReportExportResult(
      status: 'ready',
      year: year,
      downloadUrl: '/exports/ex-post-cost-report-$year.pdf',
    );
  }
}
