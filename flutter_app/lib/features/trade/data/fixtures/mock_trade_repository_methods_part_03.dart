part of '../repositories/mock_trade_repository.dart';

mixin _MockTradeRepositoryMethodsPart03 on _MockTradeRepositoryBase {
  @override
  TradePerformanceAttributionSnapshot getPerformanceAttribution({
    String copyId = 'copy001',
  }) {
    return TradePerformanceAttributionSnapshot(
      copyId: copyId,
      totalReturnPct: 9.2,
      alphaPct: -4.1,
      beta: 1.15,
      rSquared: .72,
      returns: _performanceAttributionReturns,
      drawdowns: _performanceAttributionDrawdowns,
      monteCarloPaths: _performanceAttributionProjectionPaths,
      correlationPoints: _performanceAttributionCorrelation,
      marketContributionPct: 13.4,
      skillContributionPct: -4.1,
      maxDrawdownPct: -8.7,
      avgDrawdownPct: -3.2,
      medianProjection: 5630,
      worstProjection: 4920,
      bestProjection: 6425,
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
  TradeProviderComparisonSnapshot getProviderComparison() {
    return const TradeProviderComparisonSnapshot(
      selectedCount: 3,
      maxProviders: 5,
      providers: [],
      metrics: _providerComparisonMetrics,
      disclaimer:
          'So sánh dựa trên hiệu suất lịch sử. Hiệu suất quá khứ không đảm bảo kết quả tương lai.',
      legend:
          '"Tốt nhất" không có nghĩa là "phù hợp nhất". Xem xét risk tolerance và mục tiêu đầu tư của bạn.',
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
  TradeCopyAuditLogSnapshot getCopyAuditLog({String copyId = 'copy001'}) {
    int countFor(TradeCopyAuditEventType type) =>
        _copyAuditEvents.where((event) => event.type == type).length;

    return TradeCopyAuditLogSnapshot(
      copyId: copyId,
      complianceTitle: 'MiFID II Compliant Audit Trail',
      complianceDescription:
          'Tất cả hành động được ghi log và lưu trữ 5 năm. Bạn có thể export bất cứ lúc nào.',
      tabs: [
        TradeCopyAuditTab(
          id: 'all',
          label: 'Tất cả',
          badge: _copyAuditEvents.length,
        ),
        TradeCopyAuditTab(
          id: 'trade',
          label: 'Trades',
          badge: countFor(TradeCopyAuditEventType.trade),
          type: TradeCopyAuditEventType.trade,
        ),
        TradeCopyAuditTab(
          id: 'config',
          label: 'Config',
          badge: countFor(TradeCopyAuditEventType.config),
          type: TradeCopyAuditEventType.config,
        ),
        TradeCopyAuditTab(
          id: 'risk',
          label: 'Risk',
          badge: countFor(TradeCopyAuditEventType.risk),
          type: TradeCopyAuditEventType.risk,
        ),
        TradeCopyAuditTab(
          id: 'system',
          label: 'System',
          badge: countFor(TradeCopyAuditEventType.system),
          type: TradeCopyAuditEventType.system,
        ),
      ],
      events: _copyAuditEvents,
      exportFormats: _copyAuditExportFormats,
      retentionYears: 5,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradePortfolioRiskAnalysisSnapshot getPortfolioRiskAnalysis() {
    return const TradePortfolioRiskAnalysisSnapshot(
      totalExposure: 8000,
      var95: -273,
      var99: -424,
      diversificationScore: 93,
      assetExposures: _portfolioRiskAssets,
      riskAlerts: [
        'BTC chiếm 35% (khuyến nghị <30%)',
        'High correlation: CryptoKing ↔ cryptoKing (1.00)',
        'High correlation: SwingMaster ↔ swingMaster (1.00)',
      ],
      tabs: [
        TradePortfolioRiskTab(id: 'exposure', label: 'Exposure'),
        TradePortfolioRiskTab(id: 'correlation', label: 'Correlation'),
        TradePortfolioRiskTab(id: 'var', label: 'VaR'),
        TradePortfolioRiskTab(id: 'scenarios', label: 'Stress Test'),
      ],
      scenarios: _portfolioRiskScenarios,
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
  TradeProviderLeaderboardSnapshot getProviderLeaderboard() {
    return TradeProviderLeaderboardSnapshot(
      trade: getTrade(),
      providers: _copyTraders,
      sortOptions: _providerLeaderboardSortOptions,
      riskFilters: _providerLeaderboardRiskFilters,
      defaultSortId: 'roi',
      defaultRiskFilterId: 'all',
      defaultVerifiedOnly: false,
      warningTitle: 'Survivorship Bias Warning',
      warningText:
          'Leaderboard chỉ hiển thị providers đang active. Nhiều traders đã thua lỗ và dừng không xuất hiện ở đây. Hiệu suất thực tế của ngành có thể thấp hơn nhiều.',
      verifiedOnlyLabel: 'Chỉ hiện Verified providers',
      disclaimer:
          'Rankings dựa trên hiệu suất lịch sử và không đảm bảo kết quả tương lai. Provider xếp hạng cao vẫn có thể thua lỗ trong tương lai. Luôn đọc kỹ risk disclosure trước khi copy.',
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
  TradeSafetyEducationSnapshot getSafetyEducation() {
    return TradeSafetyEducationSnapshot(
      trade: getTrade(),
      tabs: _safetyEducationTabs,
      defaultTabId: 'scams',
      heroTitle: 'Bảo vệ bản thân khỏi scams',
      heroDescription:
          'Copy trading có nhiều rủi ro từ scammers. Đọc kỹ guide này trước khi copy bất kỳ ai.',
      scams: _safetyScams,
      redFlags: _safetyRedFlags,
      verificationTiers: _safetyVerificationTiers,
      reportReasons: _safetyReportReasons,
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
  TradeProviderGovernanceSnapshot getProviderGovernance() {
    return TradeProviderGovernanceSnapshot(
      trade: getTrade(),
      tabs: _providerGovernanceTabs,
      defaultTabId: 'modifications',
      stats: const TradeProviderGovernanceStats(
        followers: 245,
        aum: 125000,
        monthlyFeesEarned: 1850,
        allTimeFeesEarned: 12400,
        complianceScore: 95,
      ),
      warning:
          '24-Hour Notice Required: You must notify all followers at least 24 hours before implementing major strategy changes.',
      modifications: _strategyModifications,
      messages: _followerMessages,
      feeContributors: _feeContributors,
      complianceItems: _complianceItems,
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
  TradeDisputeResolutionSnapshot getDisputeResolution() {
    return TradeDisputeResolutionSnapshot(
      trade: getTrade(),
      tabs: const [
        TradeDisputeTab(id: 'file', label: 'File Complaint'),
        TradeDisputeTab(id: 'active', label: 'Active Cases', badgeCount: 1),
        TradeDisputeTab(id: 'history', label: 'History', badgeCount: 1),
      ],
      defaultTabId: 'file',
      noticeTitle: 'Fair Dispute Resolution',
      noticeBody:
          'We investigate all complaints fairly. Most cases are resolved within 48 hours.',
      complaintTypes: _disputeComplaintTypes,
      providers: _disputeProviders,
      activeCases: _activeDisputeCases,
      resolvedCases: _resolvedDisputeCases,
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
  TradeCopySafetyCenterSnapshot getCopySafetyCenter() {
    return TradeCopySafetyCenterSnapshot(
      trade: getTrade(),
      tabs: _copySafetyCenterTabs,
      defaultTabId: 'verification',
      heroTitle: 'Your Safety is Our Priority',
      heroDescription:
          'Learn how to identify trustworthy providers and protect yourself from scams.',
      verificationIntro: 'Provider verification tiers explained:',
      verificationTiers: _copyVerificationTiers,
      trustMetrics: _copyTrustMetrics,
      prohibitedBehaviors: _copyProhibitedBehaviors,
      followerResponsibilities: _copyFollowerResponsibilities,
      reportingSteps: _copyReportingSteps,
      safetyTools: _copySafetyTools,
      enforcementActions: _copyEnforcementActions,
      warningText:
          'Important: Verification badges confirm identity and track record, but DO NOT guarantee future performance. Always check risk metrics before copying.',
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
  TradeRegulatoryDisclosuresSnapshot getRegulatoryDisclosures() {
    return TradeRegulatoryDisclosuresSnapshot(
      trade: getTrade(),
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
  TradeMarginTradingSnapshot getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  }) {
    final trade = getTrade(pairId: pairId);
    final pair = trade.pairs.firstWhere(
      (item) => item.id == pairId,
      orElse: () => trade.pair,
    );
    return TradeMarginTradingSnapshot(
      trade: trade,
      pair: pair,
      account: _marginAccount,
      positions: _marginPositions,
      modeTabs: _marginModeTabs,
      contentTabs: _marginContentTabs,
      defaultMode: 'cross',
      defaultTab: 'trade',
      defaultSide: 'long',
      defaultLeverage: 5,
      clientCategory: _marginClientCategory,
      referencePrices: pairRouteVariant
          ? _marginPairRouteReferencePrices
          : _marginReferencePrices,
      orderDraft: _marginOrderDraft,
      riskWarning: _marginRiskWarning,
      negativeBalance: _marginNegativeBalance,
      bestExecution: _marginBestExecution,
      lastUpdatedLabel: 'realtime-refresh',
      highRiskContractId: HighRiskFlowContractIds.tradeMarginFutures,
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
  TradeTraderProfileSnapshot getTraderProfile({String traderId = 'trader001'}) {
    final trader = _copyTraders.firstWhere(
      (item) => item.id == traderId,
      orElse: () => _copyTraders.first,
    );
    return TradeTraderProfileSnapshot(
      traderId: traderId,
      trader: trader,
      pnlHistory: _traderProfilePnlHistory,
      recentTrades: _traderProfileRecentTrades,
      defaultTab: 'overview',
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
  TradeAdvancedTradingDemoSnapshot getAdvancedTradingDemo() {
    return TradeAdvancedTradingDemoSnapshot(
      position: _advancedDemoPosition,
      positionActions: _advancedDemoPositionActions,
      orderTypes: _advancedDemoOrderTypes,
      timeInForce: _advancedDemoTimeInForce,
      orderSummary: _advancedDemoOrderSummary,
      pnlSummary: _advancedDemoPnlSummary,
      performanceMetrics: _advancedDemoPerformanceMetrics,
      defaultTab: 'position',
      defaultPositionMode: 'one-way',
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
  TradeMarketDataAnalyticsSnapshot getMarketDataAnalytics() {
    return const TradeMarketDataAnalyticsSnapshot(
      selectedPair: 'BTC/USDT',
      markPrice: 67543.21,
      openInterest: _marketOpenInterest,
      longShortRatio: _marketLongShortRatio,
      topTraders: _marketTopTraders,
      fundingRate: _marketFundingRate,
      liquidationStats: _marketLiquidationStats,
      liquidationClusters: _marketLiquidationClusters,
      recentLiquidations: _marketRecentLiquidations,
      sentiment: _marketSentiment,
      defaultTab: 'market',
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
  TradeMarginTradingHubSnapshot getMarginTradingHub() {
    return const TradeMarginTradingHubSnapshot(
      stats: _marginHubStats,
      menuItems: _marginHubMenuItems,
      features: _marginHubFeatures,
      compliance: _marginHubCompliance,
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
  TradeMarketDataAnalyticsSnapshot getLiveMarketDataAnalytics() {
    return const TradeMarketDataAnalyticsSnapshot(
      selectedPair: 'BTC/USDT',
      markPrice: 67543.21,
      openInterest: _liveMarketOpenInterest,
      longShortRatio: _liveMarketLongShortRatio,
      topTraders: _liveMarketTopTraders,
      fundingRate: _liveMarketFundingRate,
      liquidationStats: _marketLiquidationStats,
      liquidationClusters: _marketLiquidationClusters,
      recentLiquidations: _marketRecentLiquidations,
      sentiment: _marketSentiment,
      defaultTab: 'market',
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
  TradeAdvancedAnalyticsSnapshot getAdvancedAnalytics() {
    return const TradeAdvancedAnalyticsSnapshot(
      stats: _advancedAnalyticsStats,
      signals: _advancedAnalyticsSignals,
      features: _advancedAnalyticsFeatures,
      risk: _advancedAnalyticsRisk,
      journal: _advancedAnalyticsJournal,
      sizing: _advancedAnalyticsSizing,
      defaultTab: 'ai',
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
}
