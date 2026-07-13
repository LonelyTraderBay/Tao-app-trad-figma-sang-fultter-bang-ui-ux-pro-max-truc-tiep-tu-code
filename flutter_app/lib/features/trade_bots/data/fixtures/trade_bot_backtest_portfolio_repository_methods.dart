part of '../repositories/mock_trade_bots_repository.dart';

mixin _MockTradeBotsRepositoryBacktestPortfolioMethods
    on _MockTradeBotsRepositoryBase {
  @override
  TradeBotBacktestingSnapshot getBotBacktesting() {
    return const TradeBotBacktestingSnapshot(
      strategies: _botBacktestStrategies,
      pairs: _botBacktestPairs,
      dateRanges: _botBacktestDateRanges,
      defaultStrategyId: 'grid',
      defaultPair: 'BTC/USDT',
      defaultDateRangeId: '6m',
      defaultCapital: 1000,
      endpoint: '/api/mobile/trade/trade-bots-backtesting',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable; '
          'POST /bots/backtest/run',
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
  TradeBotStrategyCompareSnapshot getBotStrategyCompare() {
    return const TradeBotStrategyCompareSnapshot(
      strategies: _botCompareStrategies,
      equityPoints: _botCompareEquityPoints,
      recommendations: _botCompareRecommendations,
      defaultSelectedIds: ['grid', 'momentum'],
      analysisPeriod:
          'All strategies backtested on BTC/USDT from Sep 2025 - Mar 2026 '
          'with \$1,000 initial capital. Results assume same market '
          'conditions - actual performance will vary.',
      endpoint: '/api/mobile/trade/trade-bots-strategy-compare',
      actionDraft:
          'GET /bots/strategy-compare?strategies=grid,momentum; '
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotOptimizationSnapshot getBotOptimization() {
    return const TradeBotOptimizationSnapshot(
      targets: _botOptimizationTargets,
      parameterRanges: _botOptimizationRanges,
      steps: _botOptimizationSteps,
      defaultTargetId: 'sharpe',
      endpoint: '/api/mobile/trade/trade-bots-optimization',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable; '
          'POST /bots/optimization/run',
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
  TradeBotPortfolioDashboardSnapshot getBotPortfolioDashboard() {
    return const TradeBotPortfolioDashboardSnapshot(
      summary: _botPortfolioSummary,
      allocations: _botPortfolioAllocations,
      equityPoints: _botPortfolioEquity,
      correlations: _botPortfolioCorrelations,
      healthItems: _botPortfolioHealthItems,
      endpoint: '/api/mobile/trade/trade-bots-portfolio-dashboard',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotDrawdownAnalyzerSnapshot getBotDrawdownAnalyzer() {
    return const TradeBotDrawdownAnalyzerSnapshot(
      summary: _botDrawdownSummary,
      underwaterPoints: _botUnderwaterPoints,
      durationBuckets: _botDrawdownDurationBuckets,
      events: _botDrawdownEvents,
      insights: _botDrawdownInsights,
      endpoint: '/api/mobile/trade/trade-bots-drawdown-analyzer',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotEquityCurveSnapshot getBotEquityCurve() {
    return const TradeBotEquityCurveSnapshot(
      summary: _botEquityCurveSummary,
      equityPoints: _botEquityCurvePoints,
      monthlyReturns: _botEquityMonthlyReturns,
      performanceStats: _botEquityPerformanceStats,
      analysisItems: _botEquityAnalysisItems,
      endpoint: '/api/mobile/trade/trade-bots-equity-curve',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotGuideSnapshot getBotGuide() {
    return const TradeBotGuideSnapshot(
      strategies: _botGuideStrategies,
      bestPractices: _botGuideBestPractices,
      mistakes: _botGuideMistakes,
      endpoint: '/api/mobile/trade/trade-bots-guide',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotFaqSnapshot getBotFaq() {
    return const TradeBotFaqSnapshot(
      categories: _botFaqCategories,
      endpoint: '/api/mobile/trade/trade-bots-faq',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotTaxReportingSnapshot getBotTaxReporting() {
    return const TradeBotTaxReportingSnapshot(
      taxYears: ['2026', '2025', '2024', '2023'],
      defaultYear: '2025',
      defaultCostBasisMethod: 'FIFO',
      summary: _botTaxSummary,
      reportTypes: _botTaxReportTypes,
      breakdown: _botTaxBreakdown,
      taxNotes: _botTaxNotes,
      endpoint: '/api/mobile/trade/trade-bots-tax-reporting',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable; '
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
  TradeBotApiDocumentationSnapshot getBotApiDocumentation() {
    return const TradeBotApiDocumentationSnapshot(
      tabs: [
        TradeBotApiTab(id: 'endpoints', label: 'endpoints'),
        TradeBotApiTab(id: 'websocket', label: 'websocket'),
        TradeBotApiTab(id: 'examples', label: 'examples'),
      ],
      defaultView: 'endpoints',
      defaultLanguage: 'javascript',
      endpoints: _botApiEndpoints,
      websocketUrl: 'wss://ws.tradingplatform.com/bots?apiKey=YOUR_API_KEY',
      websocketEvents: _botApiWebSocketEvents,
      codeExamples: _botApiCodeExamples,
      rateLimits: _botApiRateLimits,
      authenticationHeader: 'Authorization: Bearer YOUR_API_KEY',
      endpoint: '/api/mobile/trade/trade-bots-api-documentation',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotBacktestResult runBotBacktest(TradeBotBacktestRequest request) {
    return const TradeBotBacktestResult(
      status: 'queued',
      reportId: 'BOT-BACKTEST-125',
      progress: 0,
    );
  }

  @override
  TradeBotOptimizationResult runBotOptimization(
    TradeBotOptimizationRequest request,
  ) {
    return const TradeBotOptimizationResult(
      status: 'queued',
      jobId: 'BOT-OPT-127',
      estimatedMinutes: 3,
    );
  }

  @override
  TradeBotTaxReportExportResult createBotTaxReportExport(
    TradeBotTaxReportExportRequest request,
  ) {
    return TradeBotTaxReportExportResult(
      status: request.reportTypeIds.isEmpty ? 'blocked' : 'ready',
      year: request.year,
      reportCount: request.reportTypeIds.length,
      exportId:
          'BOT-TAX-${request.year}-${request.costBasisMethod.toUpperCase()}',
    );
  }
}
