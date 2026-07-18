part of '../repositories/mock_dca_repository.dart';

mixin _DcaRepositoryMethodsPart01 on _MockDcaRepositoryBase {
  Future<DcaDashboardSnapshot> getDashboard() async {
    await _simulateNetwork();
    return const DcaDashboardSnapshot(
      endpoint: '/api/mobile/dca/dca',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
        DcaScreenState.success,
      ],
      screenState: DcaScreenState.success,
      overview: DcaOverview(
        currentValueVnd: 3027250000,
        totalInvestedVnd: 22200000,
        profitLossVnd: 3005050000,
        profitLossPercent: 13536.3,
        activePlans: 3,
        pausedPlans: 0,
        errorPlans: 0,
        nextRelativeTime: '47 giờ',
        nextAmountVnd: 500000,
      ),
      sparkline: [
        18,
        18.2,
        18.1,
        18.3,
        18.4,
        19.2,
        19.1,
        20.1,
        21.7,
        20.8,
        22.4,
        22.1,
        24.2,
        23.5,
        26.4,
        27.8,
        26.9,
        30.2,
        29.5,
        33.8,
      ],
      tools: [
        DcaTool(
          title: 'Portfolio Optimizer',
          subtitle: 'Frontier, risk, backtest',
          route: '/dca/portfolio-optimizer',
          icon: DcaToolIcon.target,
          accent: DcaToolAccent.purple,
        ),
        DcaTool(
          title: 'Dynamic Amount',
          subtitle: 'Điều chỉnh lượng mua thông minh',
          route: '/dca/dynamic-amount',
          icon: DcaToolIcon.activity,
          accent: DcaToolAccent.primary,
        ),
        DcaTool(
          title: 'Auto-Rebalance',
          subtitle: 'Cân bằng danh mục tự động',
          route: '/dca/rebalance/config',
          icon: DcaToolIcon.sliders,
          accent: DcaToolAccent.success,
        ),
        DcaTool(
          title: 'Smart Schedule',
          subtitle: 'Lịch mua theo thị trường',
          route: '/dca/schedule/config',
          icon: DcaToolIcon.clock,
          accent: DcaToolAccent.warning,
        ),
      ],
      plans: [
        DcaPlan(
          id: 'plan-1',
          coinSymbol: 'BTC',
          coinName: 'Bitcoin',
          frequency: DcaFrequency.weekly,
          amountPerPurchaseVnd: 500000,
          nextExecutionLabel: '1 ngày',
          status: DcaPlanStatus.active,
          totalInvestedVnd: 12000000,
          currentHoldings: 0.0065,
          profitLossPercent: 0,
        ),
        DcaPlan(
          id: 'plan-2',
          coinSymbol: 'ETH',
          coinName: 'Ethereum',
          frequency: DcaFrequency.weekly,
          amountPerPurchaseVnd: 300000,
          nextExecutionLabel: '3 ngày',
          status: DcaPlanStatus.active,
          totalInvestedVnd: 7200000,
          currentHoldings: 0.085,
          profitLossPercent: 0,
        ),
        DcaPlan(
          id: 'plan-3',
          coinSymbol: 'SOL',
          coinName: 'Solana',
          frequency: DcaFrequency.monthly,
          amountPerPurchaseVnd: 1000000,
          nextExecutionLabel: '14 ngày',
          status: DcaPlanStatus.active,
          totalInvestedVnd: 3000000,
          currentHoldings: 940,
          profitLossPercent: -99.9,
        ),
      ],
      history: [
        DcaHistoryPoint(day: 'T-6', portfolioValueM: 22.2, investedM: 19.2),
        DcaHistoryPoint(day: 'T-5', portfolioValueM: 31.8, investedM: 19.7),
        DcaHistoryPoint(day: 'T-4', portfolioValueM: 38.4, investedM: 20.2),
        DcaHistoryPoint(day: 'T-3', portfolioValueM: 52.6, investedM: 20.7),
        DcaHistoryPoint(day: 'T-2', portfolioValueM: 74.4, investedM: 21.2),
        DcaHistoryPoint(day: 'T-1', portfolioValueM: 96.9, investedM: 21.7),
        DcaHistoryPoint(day: 'Now', portfolioValueM: 122.1, investedM: 22.2),
      ],
    );
  }

  Future<DcaRebalanceConfigSnapshot> getRebalanceConfig() async {
    await _simulateNetwork();
    return const DcaRebalanceConfigSnapshot(
      endpoint: '/api/mobile/dca/dca-rebalance-config',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
        DcaScreenState.submitting,
        DcaScreenState.success,
      ],
      totalPortfolioUsd: 45000,
      driftThreshold: 10,
      minTradeAmountUsd: 50,
      strategy: DcaRebalanceStrategy.threshold,
      frequency: DcaRebalanceFrequency.monthly,
      targets: [
        DcaRebalanceTarget(
          id: 'target-btc',
          symbol: 'BTC',
          assetName: 'Bitcoin',
          currentPercent: 50,
          targetPercent: 40,
          tolerance: 5,
          currentValueUsd: 22500,
          unitPriceUsd: 45000,
          accent: DcaRebalanceAccent.primary,
        ),
        DcaRebalanceTarget(
          id: 'target-eth',
          symbol: 'ETH',
          assetName: 'Ethereum',
          currentPercent: 44.44,
          targetPercent: 30,
          tolerance: 5,
          currentValueUsd: 20000,
          unitPriceUsd: 2500,
          accent: DcaRebalanceAccent.accent,
        ),
        DcaRebalanceTarget(
          id: 'target-usdt',
          symbol: 'USDT',
          assetName: 'Tether USD',
          currentPercent: 5.56,
          targetPercent: 30,
          tolerance: 5,
          currentValueUsd: 2500,
          unitPriceUsd: 1,
          accent: DcaRebalanceAccent.success,
        ),
      ],
      strategyOptions: [
        DcaRebalanceStrategyOption(
          strategy: DcaRebalanceStrategy.threshold,
          title: 'Ngưỡng drift',
          subtitle: 'Kích hoạt khi lệch vượt ngưỡng',
          icon: DcaRebalanceOptionIcon.zap,
        ),
        DcaRebalanceStrategyOption(
          strategy: DcaRebalanceStrategy.periodic,
          title: 'Định kỳ',
          subtitle: 'Theo lịch cố định',
          icon: DcaRebalanceOptionIcon.clock,
        ),
        DcaRebalanceStrategyOption(
          strategy: DcaRebalanceStrategy.hybrid,
          title: 'Kết hợp',
          subtitle: 'Drift hoặc định kỳ',
          icon: DcaRebalanceOptionIcon.combine,
        ),
      ],
      frequencyOptions: [
        DcaRebalanceFrequencyOption(
          frequency: DcaRebalanceFrequency.weekly,
          title: 'Tuần',
          subtitle: '7 ngày',
        ),
        DcaRebalanceFrequencyOption(
          frequency: DcaRebalanceFrequency.biweekly,
          title: '2 Tuần',
          subtitle: '14 ngày',
        ),
        DcaRebalanceFrequencyOption(
          frequency: DcaRebalanceFrequency.monthly,
          title: 'Tháng',
          subtitle: '30 ngày',
        ),
        DcaRebalanceFrequencyOption(
          frequency: DcaRebalanceFrequency.quarterly,
          title: 'Quý',
          subtitle: '90 ngày',
        ),
      ],
    );
  }

  Future<DcaRebalanceDashboardSnapshot> getRebalanceDashboard(
    String configId,
  ) async {
    await _simulateNetwork();
    return DcaRebalanceDashboardSnapshot(
      endpoint: '/api/mobile/dca/dca-rebalance-config001',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: const [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ],
      configId: configId,
      configFound: false,
      message: 'Configuration not found',
      dcaPlans: const [],
      schedules: const [],
      rules: const [],
      portfolioTargets: const [],
      backtests: const [],
    );
  }

  Future<DcaScheduleConfigSnapshot> getScheduleConfig() async {
    await _simulateNetwork();
    return const DcaScheduleConfigSnapshot(
      endpoint: '/api/mobile/dca/dca-schedule-config',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ],
      strategy: DcaScheduleStrategy.hybrid,
      timePreference: DcaScheduleTimePreference.any,
      maxDelayHours: 6,
      maxAdvanceHours: 6,
      volatilityThreshold: 3,
      gasPriceThreshold: 30,
      enabled: true,
      strategies: [
        DcaScheduleStrategyOption(
          strategy: DcaScheduleStrategy.fixed,
          title: 'Cố định',
          subtitle: 'Thực thi đúng giờ, không tối ưu',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaRebalanceAccent.primary,
        ),
        DcaScheduleStrategyOption(
          strategy: DcaScheduleStrategy.volatility,
          title: 'Volatility',
          subtitle: 'Ưu tiên thời điểm volatility thấp',
          icon: DcaScheduleOptionIcon.trend,
          accent: DcaRebalanceAccent.accent,
        ),
        DcaScheduleStrategyOption(
          strategy: DcaScheduleStrategy.gasOptimized,
          title: 'Gas Optimized',
          subtitle: 'Ưu tiên gas fee thấp',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaRebalanceAccent.warning,
        ),
        DcaScheduleStrategyOption(
          strategy: DcaScheduleStrategy.volume,
          title: 'Volume',
          subtitle: 'Ưu tiên khối lượng giao dịch cao',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaRebalanceAccent.primary,
        ),
        DcaScheduleStrategyOption(
          strategy: DcaScheduleStrategy.hybrid,
          title: 'Hybrid',
          subtitle: 'Kết hợp nhiều yếu tố (khuyên dùng)',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaRebalanceAccent.success,
        ),
      ],
      timePreferences: [
        DcaScheduleTimePreferenceOption(
          preference: DcaScheduleTimePreference.morning,
          title: 'Sáng',
          subtitle: '6:00 - 12:00',
        ),
        DcaScheduleTimePreferenceOption(
          preference: DcaScheduleTimePreference.afternoon,
          title: 'Chiều',
          subtitle: '12:00 - 18:00',
        ),
        DcaScheduleTimePreferenceOption(
          preference: DcaScheduleTimePreference.evening,
          title: 'Tối',
          subtitle: '18:00 - 24:00',
        ),
        DcaScheduleTimePreferenceOption(
          preference: DcaScheduleTimePreference.night,
          title: 'Đêm',
          subtitle: '0:00 - 6:00',
        ),
        DcaScheduleTimePreferenceOption(
          preference: DcaScheduleTimePreference.any,
          title: 'Bất kỳ',
          subtitle: '0:00 - 24:00',
        ),
      ],
    );
  }

  Future<DcaScheduleAnalyticsSnapshot> getScheduleAnalytics(
    String configId,
  ) async {
    await _simulateNetwork();
    return DcaScheduleAnalyticsSnapshot(
      endpoint: '/api/mobile/dca/dca-schedule-config001',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: const [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ],
      configId: configId,
      configFound: false,
      message: 'Configuration not found',
      dcaPlans: const [],
      schedules: const [],
      rules: const [],
      portfolioTargets: const [],
      backtests: const [],
    );
  }

  Future<DcaPortfolioOptimizerSnapshot> getPortfolioOptimizer() async {
    await _simulateNetwork();
    return const DcaPortfolioOptimizerSnapshot(
      endpoint: '/api/mobile/dca/dca-portfolio-optimizer',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ],
      score: 73,
      driftPercent: 25,
      driftThresholdPercent: 5,
      optimalSharpe: 1.40,
      optimalReturnPercent: 35,
      optimalRiskPercent: 25,
      currentAllocations: [
        DcaPortfolioAllocation(
          symbol: 'BTC',
          name: 'Bitcoin',
          currentPercent: 55,
          optimalPercent: 45,
          accent: DcaPortfolioAssetAccent.btc,
        ),
        DcaPortfolioAllocation(
          symbol: 'ETH',
          name: 'Ethereum',
          currentPercent: 30,
          optimalPercent: 30,
          accent: DcaPortfolioAssetAccent.eth,
        ),
        DcaPortfolioAllocation(
          symbol: 'USDT',
          name: 'Tether',
          currentPercent: 15,
          optimalPercent: 0,
          accent: DcaPortfolioAssetAccent.usdt,
        ),
        DcaPortfolioAllocation(
          symbol: 'SOL',
          name: 'Solana',
          currentPercent: 0,
          optimalPercent: 15,
          accent: DcaPortfolioAssetAccent.sol,
        ),
        DcaPortfolioAllocation(
          symbol: 'BNB',
          name: 'BNB',
          currentPercent: 0,
          optimalPercent: 10,
          accent: DcaPortfolioAssetAccent.bnb,
        ),
      ],
      frontier: [
        DcaFrontierPoint(
          label: 'Conservative',
          riskPercent: 8,
          returnPercent: 6,
          sharpe: .75,
        ),
        DcaFrontierPoint(
          label: 'Balanced',
          riskPercent: 18,
          returnPercent: 22,
          sharpe: 1.22,
        ),
        DcaFrontierPoint(
          label: 'Optimal (Max Sharpe)',
          riskPercent: 25,
          returnPercent: 35,
          sharpe: 1.40,
        ),
        DcaFrontierPoint(
          label: 'Growth',
          riskPercent: 35,
          returnPercent: 42,
          sharpe: 1.20,
        ),
        DcaFrontierPoint(
          label: 'Aggressive',
          riskPercent: 48,
          returnPercent: 55,
          sharpe: 1.15,
        ),
      ],
      suggestions: [
        DcaPortfolioSuggestion(
          type: DcaPortfolioSuggestionType.decrease,
          symbol: 'BTC',
          currentPercent: 55,
          suggestedPercent: 45,
          reason: 'Giảm BTC từ 55% xuống 45% để cân bằng rủi ro',
        ),
        DcaPortfolioSuggestion(
          type: DcaPortfolioSuggestionType.add,
          symbol: 'SOL',
          currentPercent: 0,
          suggestedPercent: 15,
          reason: 'Thêm Solana để cải thiện diversification',
        ),
        DcaPortfolioSuggestion(
          type: DcaPortfolioSuggestionType.add,
          symbol: 'BNB',
          currentPercent: 0,
          suggestedPercent: 10,
          reason: 'Thêm BNB để cải thiện diversification',
        ),
        DcaPortfolioSuggestion(
          type: DcaPortfolioSuggestionType.remove,
          symbol: 'USDT',
          currentPercent: 15,
          suggestedPercent: 0,
          reason: 'Giảm USDT, không nằm trong phân bổ tối ưu',
        ),
      ],
      dcaPlans: [],
      schedules: [],
      rules: [],
      portfolioTargets: [],
      backtests: [],
    );
  }
}
