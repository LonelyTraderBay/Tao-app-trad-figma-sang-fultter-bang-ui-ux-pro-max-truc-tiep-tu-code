part of '../repositories/mock_trade_regulatory_repository.dart';

mixin _MockTradeRegulatoryRepositoryDisclosuresMethods
    on _MockTradeRegulatoryRepositoryBase {
  @override
  TradeRegulatoryDisclosuresSnapshot getRegulatoryDisclosures() {
    return TradeRegulatoryDisclosuresSnapshot(
      trade: _regulatoryDisclosuresTradeSnapshot,
      tabs: _regulatoryTabs,
      defaultTabId: 'mifid',
      heroTitle: 'Legal & Regulatory Framework',
      heroDescription:
          'Understanding your rights and protections under MiFID II',
      mifidTitle: 'MiFID II Compliance Statement',
      mifidArticles: _regulatoryMifidArticles,
      commitmentText:
          'Our Commitment: We comply with all MiFID II requirements to protect retail investors. Our compliance is audited annually by independent third parties.',
      protection: _regulatoryProtection,
      restrictions: _regulatoryRestrictions,
      liability: _regulatoryLiability,
      contacts: _regulatoryContacts,
      whistleblower: _regulatoryWhistleblower,
      terms: _regulatoryTerms,
      lastUpdatedLabel: 'realtime-refresh',
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
  TradeTransactionReportingSnapshot getTransactionReporting() {
    return const TradeTransactionReportingSnapshot(
      reports: _transactionReports,
      stats: _transactionReportingStats,
      defaultTab: 'queue',
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
  TradeRegulatoryReportsDashboardSnapshot getRegulatoryReportsDashboard() {
    return const TradeRegulatoryReportsDashboardSnapshot(
      dailyStats: _regulatoryDailyStats,
      providers: _regulatoryArmProviders,
      distribution: _regulatoryReportDistribution,
      totals: _regulatoryDashboardTotals,
      timeRanges: ['24H', '7D', '30D', '90D'],
      defaultRange: '7D',
      defaultTab: 'overview',
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

  @override
  TradeRegulatoryInspectionSnapshot getRegulatoryInspectionReady() {
    return const TradeRegulatoryInspectionSnapshot(
      complianceScore: 97,
      scoreLabel: 'Overall Compliance Score',
      readyTitle: 'Inspection Ready:',
      readyDescription:
          'All regulatory requirements met. Full documentation available '
          'for FCA/ESMA inspection.',
      stats: _regulatoryInspectionStats,
      frameworks: _regulatoryFrameworks,
      documents: _regulatoryDocuments,
      portalTitle: 'Secure Inspector Portal',
      portalDescription:
          'FCA/ESMA inspectors can access all required documents through '
          'our secure portal with audit logging.',
      portalCta: 'Inspector Portal Access',
      reportCta: 'Download Full Compliance Report (PDF)',
      endpoint:
          '/api/mobile/trade/trade-copy-trading-regulatory-inspection-ready',
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
