part of '../repositories/mock_trade_repository.dart';

mixin _MockTradeRepositoryMethodsPart04 on _MockTradeRepositoryBase {
  @override
  TradeArmIntegrationStatusSnapshot getArmIntegrationStatus() {
    return const TradeArmIntegrationStatusSnapshot(
      connections: _armConnections,
      latencyHistory: _armLatencyHistory,
      sla: _armSlaMetrics,
      lastUpdatedLabel: 'realtime-refresh',
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
  TradeBestExecutionReportsSnapshot getBestExecutionReports() {
    return const TradeBestExecutionReportsSnapshot(
      venues: _bestExecutionVenues,
      archive: _bestExecutionArchive,
      summary: _bestExecutionSummary,
      defaultTab: 'current',
      lastUpdatedLabel: 'realtime-refresh',
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
  TradeExecutionVenueAnalysisSnapshot getExecutionVenueAnalysis() {
    return const TradeExecutionVenueAnalysisSnapshot(
      venues: _executionVenueMetrics,
      costTrends: _executionVenueCostTrends,
      summary: _executionVenueSummary,
      defaultSort: 'volume',
      defaultTab: 'comparison',
      lastUpdatedLabel: 'realtime-refresh',
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
  TradeSlippageMonitoringSnapshot getSlippageMonitoring() {
    return const TradeSlippageMonitoringSnapshot(
      events: _slippageEvents,
      providers: _slippageProviderStats,
      history: _slippageHistory,
      summary: _slippageSummary,
      defaultTab: 'realtime',
      lastUpdatedLabel: 'realtime-refresh',
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
  TradeClientCategorizationSnapshot getClientCategorization() {
    return const TradeClientCategorizationSnapshot(
      categories: _clientCategorizationCategories,
      history: _clientCategorizationHistory,
      currentCategoryId: 'retail',
      defaultTab: 'overview',
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
  TradeProductGovernanceSnapshot getProductGovernance() {
    return const TradeProductGovernanceSnapshot(
      products: _productGovernanceProducts,
      defaultTab: 'products',
      nextReviewLabel: 'June 2026',
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
  TradeTargetMarketDefinitionSnapshot getTargetMarketDefinition({
    String productId = 'prod-1',
  }) {
    final product = _productGovernanceProducts.firstWhere(
      (item) => item.id == productId,
      orElse: () => _productGovernanceProducts.first,
    );

    return TradeTargetMarketDefinitionSnapshot(
      product: product,
      dimensions: _targetMarketDimensions,
      endpoint: '/api/mobile/trade/trade-copy-trading-target-market-definition',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

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
  TradeComplaintsHandlingSnapshot getComplaintsHandling() {
    return const TradeComplaintsHandlingSnapshot(
      activeCount: 1,
      resolvedCount: 1,
      averageResolutionDays: 12,
      categories: _complaintCategories,
      timeline: _complaintTimeline,
      complaints: _complaints,
      processSteps: _complaintProcessSteps,
      ombudsman: TradeOmbudsmanInfo(
        description:
            'The Financial Ombudsman Service is a free, independent service '
            'that settles complaints between consumers and businesses that '
            'provide financial services.',
        phone: '0800 023 4567',
        website: 'www.financial-ombudsman.org.uk',
      ),
      endpoint: '/api/mobile/trade/trade-copy-trading-complaints-handling',
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
  TradeComplaintSubmissionSnapshot getComplaintSubmission() {
    return const TradeComplaintSubmissionSnapshot(
      processTitle: 'Complaint Process',
      processDescription:
          "We'll acknowledge your complaint within 5 business days and "
          'provide a final response within 8 weeks.',
      categories: [
        'Trade Execution',
        'Account Management',
        'Payments & Withdrawals',
        'Customer Service',
        'Fees & Charges',
        'Other',
      ],
      subjectMinLength: 10,
      subjectMaxLength: 100,
      descriptionMinLength: 50,
      descriptionMaxLength: 2000,
      termsIntro:
          'I confirm that the information provided is accurate and I understand:',
      terms: [
        'We will respond within 8 weeks',
        'I can refer to the Financial Ombudsman if not satisfied',
        'My complaint will be investigated fairly',
      ],
      confirmationComplaintId: 'COMP-2026-NEW',
      endpoint: '/api/mobile/trade/trade-copy-trading-complaint-submission',
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
  TradeComplaintTrackingSnapshot getComplaintTracking({String? complaintId}) {
    return TradeComplaintTrackingSnapshot(
      complaintId: complaintId ?? 'undefined',
      statusLabel: 'Under Review',
      submittedLabel: 'Feb 15, 2026',
      responseDueLabel: 'Apr 12, 2026',
      daysRemaining: 34,
      deadlineNotice:
          'We must provide a final response by April 12, 2026 '
          '(8 weeks from submission).',
      timeline: _complaintTrackingTimeline,
      actions: _complaintTrackingActions,
      endpoint: '/api/mobile/trade/trade-copy-trading-complaint-tracking',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeOmbudsmanReferralSnapshot getOmbudsmanReferral() {
    return const TradeOmbudsmanReferralSnapshot(
      infoTitle: 'Free & Independent',
      infoDescription:
          'The Financial Ombudsman Service (FOS) is a free service that '
          'settles complaints between consumers and financial businesses.',
      eligibility: _ombudsmanEligibility,
      contacts: _ombudsmanContacts,
      processSteps: _ombudsmanProcessSteps,
      ctaLabel: 'Visit FOS Website',
      externalUrl: 'https://www.financial-ombudsman.org.uk',
      endpoint: '/api/mobile/trade/trade-copy-trading-ombudsman-referral',
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
  TradeAuditTrailSnapshot getAuditTrail() {
    return const TradeAuditTrailSnapshot(
      noticeTitle: 'Complete Record-Keeping',
      noticeDescription:
          'All actions are logged for 7 years as required by MiFID II. '
          'This audit trail is available for regulatory inspection.',
      stats: _auditTrailStats,
      searchPlaceholder: 'Search audit trail...',
      tabs: _auditTrailTabs,
      entries: _auditTrailEntries,
      exportFormats: ['CSV', 'PDF'],
      endpoint: '/api/mobile/trade/trade-copy-trading-audit-trail',
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
}
