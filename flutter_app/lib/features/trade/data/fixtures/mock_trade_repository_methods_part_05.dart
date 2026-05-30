part of '../repositories/mock_trade_repository.dart';

mixin _MockTradeRepositoryMethodsPart05 on _MockTradeRepositoryBase {
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

  @override
  TradeBotTermsSnapshot getBotTermsOfService() {
    return const TradeBotTermsSnapshot(
      infoTitle: 'Legal Agreement Required',
      infoDescription:
          'You must read and accept these terms before using Trading Bots. '
          'Scroll to the bottom to enable acceptance.',
      title: 'Trading Bots Terms of Service',
      lastUpdatedLabel: 'Last Updated: March 8, 2026',
      sections: _botTermsSections,
      acceptSectionLabel: 'Accept Terms',
      scrollWarning:
          'Please scroll to the bottom of the terms to enable acceptance.',
      agreementTitle:
          'I have read and agree to the Trading Bots Terms of Service',
      agreementDescription:
          'By checking this box, you acknowledge that you understand the '
          'risks of automated trading and accept the terms outlined above.',
      disabledCta: 'Read Terms to Continue',
      enabledCta: 'Accept & Continue',
      complianceTitle: 'Regulatory Compliance',
      complianceDescription:
          'These terms comply with MiFID II (EU), SEC regulations (US), '
          'FCA guidelines (UK), and other applicable financial regulations. '
          'Acceptance is recorded and auditable.',
      endpoint: '/api/mobile/trade/trade-bots-terms-of-service',
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
  TradeBotRiskDisclosureSnapshot getBotRiskDisclosure() {
    return const TradeBotRiskDisclosureSnapshot(
      highRiskTitle: 'HIGH RISK WARNING',
      highRiskBody:
          'Trading Bots are complex financial products involving significant '
          'risk of loss. You may lose your entire investment. Only use '
          'capital you can afford to lose completely.',
      pastPerformanceTitle: 'Past Performance Disclaimer',
      pastPerformanceBody:
          'Backtest results and historical performance do not guarantee '
          'future results. Market conditions change, and strategies that '
          'worked in the past may fail in the future. Always assume actual '
          'performance will be worse than backtests due to slippage, fees, '
          'and execution delays.',
      riskSectionLabel: 'Risk Categories',
      categories: _botRiskCategories,
      additionalWarningsLabel: 'Additional Warnings',
      additionalWarnings: _botRiskWarnings,
      regulatoryNoticeLabel: 'Regulatory Notice',
      regulatoryTitle: 'MiFID II / ESMA / SEC Compliance',
      regulatoryBody:
          'Trading Bots are classified as complex financial products under '
          'European (MiFID II) and US (SEC) regulations. You must complete '
          'an appropriateness assessment to ensure you understand the risks '
          'before using this service.',
      regulatoryNotes: [
        'EU residents: Subject to ESMA leverage limits and negative balance protection',
        'US residents: May be restricted based on accredited investor status',
        'UK residents: FCA appropriateness test required for complex products',
      ],
      acknowledgmentLabel: 'Acknowledgment',
      acknowledgmentTitle: 'I acknowledge and accept all risks disclosed above',
      acknowledgmentDescription:
          'I understand that Trading Bots are high-risk, I may lose my '
          'entire investment, and past performance does not guarantee future '
          'results. I accept full responsibility for my trading decisions.',
      disabledCta: 'Acknowledge Risks to Continue',
      enabledCta: 'I Understand the Risks - Continue',
      helpTitle: 'Need Help Understanding Risks?',
      helpDescription:
          "If you don't fully understand these risks, we recommend consulting "
          'a financial advisor before proceeding.',
      helpCta: 'View Risk Education Guide ->',
      nextPath: '/trade/bots/suitability-assessment',
      endpoint: '/api/mobile/trade/trade-bots-risk-disclosure',
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
  TradeBotSuitabilityAssessmentSnapshot getBotSuitabilityAssessment() {
    return const TradeBotSuitabilityAssessmentSnapshot(
      questions: _botSuitabilityQuestions,
      infoTitle: 'Why we ask:',
      infoDescription:
          'These questions help determine if Trading Bots are suitable for '
          'your experience level and risk profile. Answer honestly for '
          'accurate results.',
      pass: TradeBotSuitabilityOutcomeCopy(
        outcome: TradeBotSuitabilityOutcome.pass,
        title: 'Suitable for Trading Bots',
        message:
            'Based on your responses, you have sufficient knowledge and risk '
            'tolerance to use Trading Bots.',
        recommendations: [
          'You may use all bot strategies (DCA, Grid, Momentum, Martingale)',
          'Still recommended to start with small amounts (\$100-500)',
          'Monitor performance daily and adjust parameters as needed',
        ],
        ctaLabel: 'Continue to Trading Bots',
      ),
      warning: TradeBotSuitabilityOutcomeCopy(
        outcome: TradeBotSuitabilityOutcome.warning,
        title: 'Proceed with Caution',
        message:
            'You have some experience, but we recommend starting with small '
            'amounts and simpler strategies like DCA. Avoid high-risk '
            'strategies like Martingale.',
        recommendations: [
          'Start with DCA Bot only - avoid Grid and Martingale',
          'Use small amounts (\$50-200 maximum per bot)',
          'Complete the Bot Guide tutorial before creating your first bot',
        ],
        ctaLabel: 'Continue to Trading Bots',
      ),
      fail: TradeBotSuitabilityOutcomeCopy(
        outcome: TradeBotSuitabilityOutcome.fail,
        title: 'Not Recommended',
        message:
            'Based on your responses, Trading Bots may not be suitable for '
            'you at this time. We recommend gaining more trading experience '
            'and knowledge before using automated strategies.',
        recommendations: [
          'Not recommended to proceed at this time',
          'Gain more manual trading experience first (3-6 months)',
          'Review educational materials and retake assessment later',
        ],
        ctaLabel: 'Review Educational Materials',
      ),
      regulatoryTitle: 'Regulatory Compliance (MiFID II)',
      regulatoryDescription:
          'This appropriateness assessment is required under European '
          'regulations for complex financial products. Your responses have '
          'been recorded for compliance purposes.',
      completionPath: '/trade/bots',
      endpoint: '/api/mobile/trade/trade-bots-suitability-assessment',
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
  TradeBotRiskDashboardSnapshot getBotRiskDashboard() {
    return const TradeBotRiskDashboardSnapshot(
      riskScore: 68,
      riskLabel: 'Medium Risk',
      riskMessage:
          'Moderate risk detected. Consider reducing position sizes or '
          'stopping high-risk bots.',
      currentDrawdown: -15.2,
      maxDrawdownLimit: -20,
      dailyLoss: -127,
      dailyLossLimit: -500,
      totalExposure: 2500,
      maxExposure: 5000,
      var95: 178,
      runningBots: 3,
      drawdownPoints: _botRiskDrawdownPoints,
      exposures: _botRiskExposures,
      varHistory: _botRiskVarHistory,
      safetyControls: _botRiskSafetyControls,
      emergencyPath: '/trade/bots/emergency-stop',
      endpoint: '/api/mobile/trade/trade-bots-risk-dashboard',
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
  TradeBotEmergencyStopSnapshot getBotEmergencyStop() {
    return const TradeBotEmergencyStopSnapshot(
      warningTitle: 'EMERGENCY STOP',
      warningDescription:
          'This will immediately stop all running bots and cancel pending '
          'orders. Use this only in emergency situations (market crash, '
          'technical issues, unauthorized activity).',
      bots: _botEmergencyStopBots,
      reasons: _botEmergencyStopReasons,
      closePositionsTitle: 'Also close all open positions (market sell)',
      closePositionsDescription:
          'WARNING: This will sell all holdings at market price. Only use if '
          'you need to exit immediately. May incur slippage.',
      confirmationTitle: 'I understand this is a destructive action',
      confirmationDescription:
          'All running bots will stop immediately. Pending orders will be '
          'cancelled. This action cannot be undone. I take full '
          'responsibility for this decision.',
      supportTitle: 'Support Will Be Notified',
      supportDescription:
          'Our security team will be automatically notified of this emergency '
          'stop for review and assistance. You will receive a confirmation '
          'email within 5 minutes.',
      completionPath: '/trade/bots',
      endpoint: '/api/mobile/trade/trade-bots-emergency-stop',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotSecuritySettingsSnapshot getBotSecuritySettings() {
    return const TradeBotSecuritySettingsSnapshot(
      twoFaEnabled: true,
      apiKeys: _botSecurityApiKeys,
      ipWhitelist: _botSecurityIpWhitelist,
      recentActivity: _botSecurityRecentActivity,
      securityTips: _botSecurityTips,
      generatedApiKeyPreview: 'sk_live_vittrade_demo_122',
      endpoint: '/api/mobile/trade/trade-bots-security-settings',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable; '
          'PATCH /user/settings or module settings',
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
  TradeBotHistorySnapshot getBotHistory() {
    return const TradeBotHistorySnapshot(
      trades: _botHistoryTrades,
      endpoint: '/api/mobile/trade/trade-bots-history',
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
  TradeBotPerformanceAnalyticsSnapshot getBotPerformanceAnalytics() {
    return const TradeBotPerformanceAnalyticsSnapshot(
      metrics: TradeBotPerformanceMetrics(
        totalPnl: 199.30,
        winRate: 68.2,
        sharpeRatio: 1.87,
        avgWin: 12.30,
        avgLoss: -8.50,
        profitFactor: 2.14,
        totalTrades: 96,
        bestTrade: 42.80,
        worstTrade: -24.50,
      ),
      pnlPoints: _botPerformancePnlPoints,
      winLossPoints: _botPerformanceWinLossPoints,
      strategyPerformance: _botStrategyPerformance,
      durationDistribution: _botDurationDistribution,
      endpoint: '/api/mobile/trade/trade-bots-performance-analytics',
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
}
