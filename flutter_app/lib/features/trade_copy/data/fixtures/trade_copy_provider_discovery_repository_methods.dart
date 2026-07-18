part of '../repositories/mock_trade_copy_trading_repository.dart';

mixin _MockTradeCopyTradingRepositoryProviderDiscoveryMethods
    on _MockTradeCopyTradingRepositoryBase {
  @override
  Future<TradeProviderComparisonSnapshot> getProviderComparison() async {
    await _simulateNetwork();
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
  Future<TradeProviderLeaderboardSnapshot> getProviderLeaderboard() async {
    await _simulateNetwork();
    return const TradeProviderLeaderboardSnapshot(
      trade: _providerDiscoveryTradeSnapshot,
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
  Future<TradeProviderGovernanceSnapshot> getProviderGovernance() async {
    await _simulateNetwork();
    return const TradeProviderGovernanceSnapshot(
      trade: _providerDiscoveryTradeSnapshot,
      tabs: _providerGovernanceTabs,
      defaultTabId: 'modifications',
      stats: TradeProviderGovernanceStats(
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
  Future<TradeTraderProfileSnapshot> getTraderProfile({
    String traderId = 'trader001',
  }) async {
    await _simulateNetwork();
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
  Future<TradeProviderApplicationSnapshot> getProviderApplication() async {
    await _simulateNetwork();
    return const TradeProviderApplicationSnapshot(
      trade: _providerDiscoveryTradeSnapshot,
      steps: [
        TradeProviderApplicationStep.intro,
        TradeProviderApplicationStep.requirements,
        TradeProviderApplicationStep.disclosure,
        TradeProviderApplicationStep.fees,
        TradeProviderApplicationStep.review,
      ],
      defaultStep: TradeProviderApplicationStep.intro,
      benefits: _providerApplicationBenefits,
      requirements: _providerApplicationRequirements,
      responsibilities: _providerApplicationResponsibilities,
      defaultDraft: _defaultProviderApplicationDraft,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: [
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
  Future<TradeCopyProviderDetailSnapshot> getCopyProviderDetail({
    String providerId = 'provider001',
  }) async {
    await _simulateNetwork();
    TradeCopyTrader? provider;
    for (final trader in _copyTraders) {
      if (trader.id == providerId) {
        provider = trader;
        break;
      }
    }

    return TradeCopyProviderDetailSnapshot(
      providerId: providerId,
      provider: provider,
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
  Future<TradePreCopyAssessmentSnapshot> getPreCopyAssessment({
    String providerId = 'provider001',
  }) async {
    await _simulateNetwork();
    final detail = await getCopyProviderDetail(providerId: providerId);
    return TradePreCopyAssessmentSnapshot(
      providerId: providerId,
      provider: detail.provider,
      questions: _preCopyQuestions,
      educationDocs: _preCopyEducationDocs,
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
  Future<TradeProviderApplicationResult> submitProviderApplication(
    TradeProviderApplicationDraft draft,
  ) async {
    await _simulateNetwork();
    return const TradeProviderApplicationResult(
      applicationId: 'CPA-069-DEMO',
      status: 'submitted',
      reviewWindow: '2-3 ngày làm việc',
    );
  }
}
