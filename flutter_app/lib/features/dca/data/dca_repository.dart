import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DcaFrequency { daily, weekly, monthly }

enum DcaPlanStatus { active, paused, error }

enum DcaScreenState { loading, empty, error, offline, submitting, success }

enum DcaRebalanceStrategy { threshold, periodic, hybrid }

enum DcaRebalanceFrequency { weekly, biweekly, monthly, quarterly }

enum DcaScheduleStrategy { fixed, volatility, gasOptimized, volume, hybrid }

enum DcaScheduleTimePreference { morning, afternoon, evening, night, any }

enum DcaScheduleOptionIcon { clock, trend, bolt, chart }

enum DcaPortfolioAssetAccent { btc, eth, usdt, sol, bnb }

enum DcaPortfolioSuggestionType { increase, decrease, add, remove }

enum DcaDynamicStrategy { fixed, volatility, performance, balance, target }

enum DcaDynamicAdjustmentAction {
  normal,
  increased,
  decreased,
  skipped,
  paused,
}

enum DcaDynamicConfigAccent {
  neutral,
  primary,
  success,
  warning,
  danger,
  accent,
}

enum DcaBacktestFrequency { weekly, biweekly, monthly, daily }

enum DcaBacktestStrategy { fixed, valueAverage, buyDips }

enum DcaMultiAssetFrequency { weekly, monthly }

enum DcaPerformanceWinner { dca, lumpSum }

enum DcaSmartRuleType { entry, exit, adjust }

enum DcaSmartRuleStatus { active, paused, triggered }

enum DcaSmartRuleResult { executed, failed, pending }

class DcaRepository {
  const DcaRepository();

  DcaDashboardSnapshot getDashboard() {
    return const DcaDashboardSnapshot(
      endpoint: '/api/mobile/dca/dca',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ],
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

  DcaRebalanceConfigSnapshot getRebalanceConfig() {
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

  DcaRebalanceDashboardSnapshot getRebalanceDashboard(String configId) {
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

  DcaScheduleConfigSnapshot getScheduleConfig() {
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

  DcaScheduleAnalyticsSnapshot getScheduleAnalytics(String configId) {
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

  DcaPortfolioOptimizerSnapshot getPortfolioOptimizer() {
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

  DcaDynamicAmountSnapshot getDynamicAmount() {
    return const DcaDynamicAmountSnapshot(
      endpoint: '/api/mobile/dca/dca-dynamic-amount',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ],
      activeStrategy: DcaDynamicStrategy.volatility,
      adjustment: DcaDynamicAdjustment(
        originalAmountVnd: 500000,
        adjustedAmountVnd: 500000,
        multiplier: 1,
        reason: 'Volatility bình thường (19.8%)',
        action: DcaDynamicAdjustmentAction.normal,
      ),
      strategies: [
        DcaDynamicStrategyOption(
          strategy: DcaDynamicStrategy.fixed,
          title: 'Cố định',
          subtitle: 'Cùng số tiền mỗi kỳ',
          description:
              'Mua cùng một số tiền cố định trong mỗi kỳ DCA, không phụ thuộc điều kiện thị trường.',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.neutral,
        ),
        DcaDynamicStrategyOption(
          strategy: DcaDynamicStrategy.volatility,
          title: 'Volatility',
          subtitle: 'Mua theo biến động',
          description:
              'Tăng lượng mua khi thị trường biến động mạnh để tận dụng cơ hội DCA, giảm khi ổn định.',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.accent,
        ),
        DcaDynamicStrategyOption(
          strategy: DcaDynamicStrategy.performance,
          title: 'Hiệu suất',
          subtitle: 'Theo P/L portfolio',
          description:
              'Điều chỉnh số tiền dựa trên hiệu suất portfolio, tăng khi đang lời và giảm khi lỗ nặng.',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaDynamicConfigAccent.primary,
        ),
        DcaDynamicStrategyOption(
          strategy: DcaDynamicStrategy.balance,
          title: 'Số dư',
          subtitle: 'Tự giảm khi ví thấp',
          description:
              'Tự động giảm hoặc tạm dừng mua khi số dư ví xuống dưới ngưỡng an toàn.',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.success,
        ),
        DcaDynamicStrategyOption(
          strategy: DcaDynamicStrategy.target,
          title: 'Mục tiêu',
          subtitle: 'Đạt target đúng hạn',
          description:
              'Tính toán số tiền mỗi kỳ để đạt được mục tiêu đầu tư trong thời gian đặt ra.',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaDynamicConfigAccent.warning,
        ),
      ],
      volatilityHistory: [
        DcaVolatilitySnapshot(
          date: '01/01',
          volatilityPercent: 12.5,
          multiplier: .7,
          amountVnd: 350000,
        ),
        DcaVolatilitySnapshot(
          date: '08/01',
          volatilityPercent: 18.2,
          multiplier: 1,
          amountVnd: 500000,
        ),
        DcaVolatilitySnapshot(
          date: '15/01',
          volatilityPercent: 35.8,
          multiplier: 1.5,
          amountVnd: 750000,
        ),
        DcaVolatilitySnapshot(
          date: '22/01',
          volatilityPercent: 28.4,
          multiplier: 1.3,
          amountVnd: 650000,
        ),
        DcaVolatilitySnapshot(
          date: '29/01',
          volatilityPercent: 15.3,
          multiplier: .8,
          amountVnd: 400000,
        ),
        DcaVolatilitySnapshot(
          date: '05/02',
          volatilityPercent: 42.1,
          multiplier: 1.5,
          amountVnd: 750000,
        ),
        DcaVolatilitySnapshot(
          date: '12/02',
          volatilityPercent: 22,
          multiplier: 1,
          amountVnd: 500000,
        ),
        DcaVolatilitySnapshot(
          date: '19/02',
          volatilityPercent: 8.5,
          multiplier: .7,
          amountVnd: 350000,
        ),
        DcaVolatilitySnapshot(
          date: '26/02',
          volatilityPercent: 31.2,
          multiplier: 1.4,
          amountVnd: 700000,
        ),
        DcaVolatilitySnapshot(
          date: '05/03',
          volatilityPercent: 19.8,
          multiplier: 1,
          amountVnd: 500000,
        ),
      ],
      amountHistory: [
        DcaAmountHistoryEntry(
          date: '05/03/26',
          baseAmountVnd: 500000,
          adjustedAmountVnd: 500000,
          strategy: DcaDynamicStrategy.volatility,
          reason: 'Volatility bình thường (19.8%)',
        ),
        DcaAmountHistoryEntry(
          date: '26/02/26',
          baseAmountVnd: 500000,
          adjustedAmountVnd: 700000,
          strategy: DcaDynamicStrategy.volatility,
          reason: 'Volatility cao (31.2%) - cơ hội mua giá tốt',
        ),
        DcaAmountHistoryEntry(
          date: '19/02/26',
          baseAmountVnd: 500000,
          adjustedAmountVnd: 350000,
          strategy: DcaDynamicStrategy.volatility,
          reason: 'Volatility thấp (8.5%) - giảm lượng mua',
        ),
        DcaAmountHistoryEntry(
          date: '12/02/26',
          baseAmountVnd: 500000,
          adjustedAmountVnd: 500000,
          strategy: DcaDynamicStrategy.volatility,
          reason: 'Volatility bình thường (22.0%)',
        ),
        DcaAmountHistoryEntry(
          date: '05/02/26',
          baseAmountVnd: 500000,
          adjustedAmountVnd: 750000,
          strategy: DcaDynamicStrategy.volatility,
          reason: 'Volatility rất cao (42.1%) - tối đa lượng mua',
        ),
        DcaAmountHistoryEntry(
          date: '29/01/26',
          baseAmountVnd: 500000,
          adjustedAmountVnd: 400000,
          strategy: DcaDynamicStrategy.performance,
          reason: 'Portfolio lỗ -3.2% - giảm nhẹ',
        ),
      ],
      configItems: [
        DcaDynamicConfigItem(
          label: 'Số tiền gốc',
          value: '500K',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Hệ số vol cao',
          value: 'x1.5',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaDynamicConfigAccent.success,
        ),
        DcaDynamicConfigItem(
          label: 'Hệ số vol thấp',
          value: 'x0.7',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Ngưỡng cao',
          value: '25%',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.danger,
        ),
        DcaDynamicConfigItem(
          label: 'Ngưỡng thấp',
          value: '12%',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.primary,
        ),
        DcaDynamicConfigItem(
          label: 'Bỏ qua khi',
          value: '>60%',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.danger,
        ),
      ],
      dcaPlans: [],
      schedules: [],
      rules: [],
      portfolioTargets: [],
      backtests: [],
    );
  }

  DcaBacktesterSnapshot getBacktester() {
    return const DcaBacktesterSnapshot(
      endpoint: '/api/mobile/dca/dca-backtester',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ],
      assets: ['BTC', 'ETH', 'BNB', 'SOL'],
      startDate: '01/01/2024',
      endDate: '12/31/2024',
      investmentAmountUsd: 1000,
      activeFrequency: DcaBacktestFrequency.monthly,
      activeStrategy: DcaBacktestStrategy.fixed,
      frequencies: [
        DcaBacktestFrequencyOption(
          frequency: DcaBacktestFrequency.weekly,
          label: 'Weekly',
        ),
        DcaBacktestFrequencyOption(
          frequency: DcaBacktestFrequency.biweekly,
          label: 'Bi-weekly',
        ),
        DcaBacktestFrequencyOption(
          frequency: DcaBacktestFrequency.monthly,
          label: 'Monthly',
        ),
        DcaBacktestFrequencyOption(
          frequency: DcaBacktestFrequency.daily,
          label: 'Daily',
        ),
      ],
      strategies: [
        DcaBacktestStrategyOption(
          strategy: DcaBacktestStrategy.fixed,
          title: 'Fixed Amount',
          subtitle: 'Invest same amount each period',
        ),
        DcaBacktestStrategyOption(
          strategy: DcaBacktestStrategy.valueAverage,
          title: 'Value Averaging',
          subtitle: 'Adjust amount to reach target value',
        ),
        DcaBacktestStrategyOption(
          strategy: DcaBacktestStrategy.buyDips,
          title: 'Buy the Dips',
          subtitle: 'Invest more when price drops',
        ),
      ],
      result: DcaBacktestResult(
        totalInvestedUsd: 12000,
        finalValueUsd: 145000,
        totalReturnUsd: 133000,
        returnPercent: 1108.33,
        avgBuyPriceUsd: 50000,
        totalShares: 2.4,
        maxDrawdownPercent: -9.5,
        sharpeRatio: 2.34,
        volatilityPercent: 18.2,
        winRatePercent: 75,
        numberOfBuys: 12,
      ),
      historicalData: [
        DcaBacktestPoint(
          date: '2024-01',
          priceUsd: 42000,
          dcaValueUsd: 10000,
          lumpValueUsd: 10000,
        ),
        DcaBacktestPoint(
          date: '2024-02',
          priceUsd: 38000,
          dcaValueUsd: 20526,
          lumpValueUsd: 9048,
        ),
        DcaBacktestPoint(
          date: '2024-03',
          priceUsd: 45000,
          dcaValueUsd: 30889,
          lumpValueUsd: 10714,
        ),
        DcaBacktestPoint(
          date: '2024-04',
          priceUsd: 41000,
          dcaValueUsd: 40667,
          lumpValueUsd: 9762,
        ),
        DcaBacktestPoint(
          date: '2024-05',
          priceUsd: 50000,
          dcaValueUsd: 52083,
          lumpValueUsd: 11905,
        ),
        DcaBacktestPoint(
          date: '2024-06',
          priceUsd: 48000,
          dcaValueUsd: 61875,
          lumpValueUsd: 11429,
        ),
        DcaBacktestPoint(
          date: '2024-07',
          priceUsd: 55000,
          dcaValueUsd: 73438,
          lumpValueUsd: 13095,
        ),
        DcaBacktestPoint(
          date: '2024-08',
          priceUsd: 52000,
          dcaValueUsd: 83750,
          lumpValueUsd: 12381,
        ),
        DcaBacktestPoint(
          date: '2024-09',
          priceUsd: 60000,
          dcaValueUsd: 97500,
          lumpValueUsd: 14286,
        ),
        DcaBacktestPoint(
          date: '2024-10',
          priceUsd: 58000,
          dcaValueUsd: 110417,
          lumpValueUsd: 13810,
        ),
        DcaBacktestPoint(
          date: '2024-11',
          priceUsd: 68000,
          dcaValueUsd: 131563,
          lumpValueUsd: 16190,
        ),
        DcaBacktestPoint(
          date: '2024-12',
          priceUsd: 65000,
          dcaValueUsd: 145000,
          lumpValueUsd: 15476,
        ),
      ],
      drawdowns: [
        DcaDrawdownPoint(date: '2024-01', drawdownPercent: 0),
        DcaDrawdownPoint(date: '2024-02', drawdownPercent: -9.5),
        DcaDrawdownPoint(date: '2024-03', drawdownPercent: -2.1),
        DcaDrawdownPoint(date: '2024-04', drawdownPercent: -8.9),
        DcaDrawdownPoint(date: '2024-05', drawdownPercent: 0),
        DcaDrawdownPoint(date: '2024-06', drawdownPercent: -4),
        DcaDrawdownPoint(date: '2024-07', drawdownPercent: 0),
        DcaDrawdownPoint(date: '2024-08', drawdownPercent: -5.5),
        DcaDrawdownPoint(date: '2024-09', drawdownPercent: 0),
        DcaDrawdownPoint(date: '2024-10', drawdownPercent: -3.3),
        DcaDrawdownPoint(date: '2024-11', drawdownPercent: 0),
        DcaDrawdownPoint(date: '2024-12', drawdownPercent: -4.4),
      ],
      dcaPlans: [],
      schedules: [],
      rules: [],
      portfolioTargets: [],
      backtests: [],
    );
  }

  DcaMultiAssetSnapshot getMultiAsset() {
    return const DcaMultiAssetSnapshot(
      endpoint: '/api/mobile/dca/dca-multi-asset',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ],
      totalBudgetUsd: 1000,
      activeFrequency: DcaMultiAssetFrequency.monthly,
      rebalanceEnabled: true,
      rebalanceThresholdPercent: 5,
      allocations: [
        DcaMultiAssetAllocation(
          id: 'asset-btc',
          symbol: 'BTC',
          assetName: 'Bitcoin',
          targetPercent: 40,
          currentPercent: 42,
          amountPerPeriodUsd: 400,
          totalInvestedUsd: 4800,
          currentValueUsd: 5280,
          shares: 0.096,
          averagePriceUsd: 50000,
        ),
        DcaMultiAssetAllocation(
          id: 'asset-eth',
          symbol: 'ETH',
          assetName: 'Ethereum',
          targetPercent: 30,
          currentPercent: 28,
          amountPerPeriodUsd: 300,
          totalInvestedUsd: 3600,
          currentValueUsd: 3960,
          shares: 1.44,
          averagePriceUsd: 2500,
        ),
        DcaMultiAssetAllocation(
          id: 'asset-bnb',
          symbol: 'BNB',
          assetName: 'Binance Coin',
          targetPercent: 20,
          currentPercent: 20,
          amountPerPeriodUsd: 200,
          totalInvestedUsd: 2400,
          currentValueUsd: 2640,
          shares: 8,
          averagePriceUsd: 300,
        ),
        DcaMultiAssetAllocation(
          id: 'asset-sol',
          symbol: 'SOL',
          assetName: 'Solana',
          targetPercent: 10,
          currentPercent: 10,
          amountPerPeriodUsd: 100,
          totalInvestedUsd: 1200,
          currentValueUsd: 1320,
          shares: 12,
          averagePriceUsd: 100,
        ),
      ],
      performance: [
        DcaMultiAssetPerformancePoint(
          month: 'Jan',
          btcUsd: 400,
          ethUsd: 300,
          bnbUsd: 200,
          solUsd: 100,
        ),
        DcaMultiAssetPerformancePoint(
          month: 'Feb',
          btcUsd: 820,
          ethUsd: 615,
          bnbUsd: 410,
          solUsd: 205,
        ),
        DcaMultiAssetPerformancePoint(
          month: 'Mar',
          btcUsd: 1260,
          ethUsd: 945,
          bnbUsd: 630,
          solUsd: 315,
        ),
        DcaMultiAssetPerformancePoint(
          month: 'Apr',
          btcUsd: 1680,
          ethUsd: 1260,
          bnbUsd: 840,
          solUsd: 420,
        ),
        DcaMultiAssetPerformancePoint(
          month: 'May',
          btcUsd: 2120,
          ethUsd: 1590,
          bnbUsd: 1060,
          solUsd: 530,
        ),
        DcaMultiAssetPerformancePoint(
          month: 'Jun',
          btcUsd: 2640,
          ethUsd: 1980,
          bnbUsd: 1320,
          solUsd: 660,
        ),
      ],
      dcaPlans: [],
      schedules: [],
      rules: [],
      portfolioTargets: [],
      backtests: [],
    );
  }

  DcaPerformanceCompareSnapshot getPerformanceCompare() {
    return const DcaPerformanceCompareSnapshot(
      endpoint: '/api/mobile/dca/dca-performance-compare',
      actionDraft: 'POST /dca/plans|rebalance|schedule; GET with query filters',
      supportedStates: [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ],
      investedUsd: 12000,
      comparison: [
        DcaPerformancePoint(
          month: 'Jan',
          dcaValueUsd: 1000,
          lumpSumValueUsd: 1000,
          priceUsd: 42000,
        ),
        DcaPerformancePoint(
          month: 'Feb',
          dcaValueUsd: 2053,
          lumpSumValueUsd: 905,
          priceUsd: 38000,
        ),
        DcaPerformancePoint(
          month: 'Mar',
          dcaValueUsd: 3089,
          lumpSumValueUsd: 1071,
          priceUsd: 45000,
        ),
        DcaPerformancePoint(
          month: 'Apr',
          dcaValueUsd: 4067,
          lumpSumValueUsd: 976,
          priceUsd: 41000,
        ),
        DcaPerformancePoint(
          month: 'May',
          dcaValueUsd: 5208,
          lumpSumValueUsd: 1190,
          priceUsd: 50000,
        ),
        DcaPerformancePoint(
          month: 'Jun',
          dcaValueUsd: 6188,
          lumpSumValueUsd: 1143,
          priceUsd: 48000,
        ),
        DcaPerformancePoint(
          month: 'Jul',
          dcaValueUsd: 7344,
          lumpSumValueUsd: 1310,
          priceUsd: 55000,
        ),
        DcaPerformancePoint(
          month: 'Aug',
          dcaValueUsd: 8375,
          lumpSumValueUsd: 1238,
          priceUsd: 52000,
        ),
        DcaPerformancePoint(
          month: 'Sep',
          dcaValueUsd: 9750,
          lumpSumValueUsd: 1429,
          priceUsd: 60000,
        ),
        DcaPerformancePoint(
          month: 'Oct',
          dcaValueUsd: 11042,
          lumpSumValueUsd: 1381,
          priceUsd: 58000,
        ),
        DcaPerformancePoint(
          month: 'Nov',
          dcaValueUsd: 13156,
          lumpSumValueUsd: 1619,
          priceUsd: 68000,
        ),
        DcaPerformancePoint(
          month: 'Dec',
          dcaValueUsd: 14500,
          lumpSumValueUsd: 1548,
          priceUsd: 65000,
        ),
      ],
      metrics: [
        DcaComparisonMetric(
          label: 'Average Entry Price',
          dcaValue: r'$50,000',
          lumpSumValue: r'$42,000',
          winner: DcaPerformanceWinner.lumpSum,
        ),
        DcaComparisonMetric(
          label: 'Max Drawdown',
          dcaValue: '-8.5%',
          lumpSumValue: '-15.2%',
          winner: DcaPerformanceWinner.dca,
        ),
        DcaComparisonMetric(
          label: 'Volatility Exposure',
          dcaValue: 'Low',
          lumpSumValue: 'High',
          winner: DcaPerformanceWinner.dca,
        ),
        DcaComparisonMetric(
          label: 'Timing Risk',
          dcaValue: 'Minimal',
          lumpSumValue: 'High',
          winner: DcaPerformanceWinner.dca,
        ),
        DcaComparisonMetric(
          label: 'Upfront Capital',
          dcaValue: r'$1,000/mo',
          lumpSumValue: r'$12,000',
          winner: DcaPerformanceWinner.dca,
        ),
      ],
      scenarios: [
        DcaVolatilityScenario(
          name: 'Low Volatility',
          scenario: 'Steady uptrend',
          description: 'Lump sum typically wins in low-volatility bull markets',
          dcaAdvantage: 2,
          lumpSumAdvantage: 8,
        ),
        DcaVolatilityScenario(
          name: 'Medium Volatility',
          scenario: 'Sideways market',
          description: 'Both strategies perform similarly',
          dcaAdvantage: 5,
          lumpSumAdvantage: 5,
        ),
        DcaVolatilityScenario(
          name: 'High Volatility',
          scenario: 'Sharp dips',
          description: 'DCA shines by buying dips consistently',
          dcaAdvantage: 8,
          lumpSumAdvantage: 3,
        ),
        DcaVolatilityScenario(
          name: 'Bear Market',
          scenario: 'Prolonged decline',
          description: 'DCA reduces average cost significantly',
          dcaAdvantage: 9,
          lumpSumAdvantage: 2,
        ),
      ],
      radar: [
        DcaRadarMetric(metric: 'Returns', dcaScore: 120, lumpSumScore: 155),
        DcaRadarMetric(
          metric: 'Risk Management',
          dcaScore: 180,
          lumpSumScore: 80,
        ),
        DcaRadarMetric(
          metric: 'Emotional Ease',
          dcaScore: 170,
          lumpSumScore: 90,
        ),
        DcaRadarMetric(metric: 'Timing Risk', dcaScore: 160, lumpSumScore: 60),
        DcaRadarMetric(metric: 'Flexibility', dcaScore: 150, lumpSumScore: 100),
      ],
      dcaPlans: [],
      schedules: [],
      rules: [],
      portfolioTargets: [],
      backtests: [],
    );
  }

  DcaSmartRulesSnapshot getSmartRules() {
    return const DcaSmartRulesSnapshot(
      endpoint: '/api/mobile/dca/dca-smart-rules',
      actionDraft: 'POST /dca/plans|rebalance|schedule',
      supportedStates: [
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ],
      successPercent: 95,
      smartRules: [
        DcaSmartRule(
          id: 'rule-buy-dip',
          name: 'Buy the Dip -10%',
          type: DcaSmartRuleType.entry,
          condition: 'Price drops 10% from 7-day average',
          action: 'Double investment amount',
          status: DcaSmartRuleStatus.active,
          triggeredCount: 3,
          lastTriggeredLabel: '11 thg 5',
        ),
        DcaSmartRule(
          id: 'rule-rsi',
          name: 'RSI Oversold',
          type: DcaSmartRuleType.entry,
          condition: 'RSI < 30',
          action: 'Increase by 50%',
          status: DcaSmartRuleStatus.active,
          triggeredCount: 2,
          lastTriggeredLabel: '4 thg 5',
        ),
        DcaSmartRule(
          id: 'rule-profit',
          name: 'Take Profit 30%',
          type: DcaSmartRuleType.exit,
          condition: 'Position up 30%',
          action: 'Sell 25% of holdings',
          status: DcaSmartRuleStatus.active,
          triggeredCount: 0,
        ),
        DcaSmartRule(
          id: 'rule-volatility',
          name: 'Pause High Volatility',
          type: DcaSmartRuleType.adjust,
          condition: 'Volatility > 40%',
          action: 'Pause DCA for 2 weeks',
          status: DcaSmartRuleStatus.paused,
          triggeredCount: 1,
          lastTriggeredLabel: '15 thg 5',
        ),
      ],
      templates: [
        DcaRuleTemplate(
          id: 'template-dips',
          name: 'Buy Major Dips',
          category: 'Entry',
          description: 'Double investment when price drops significantly',
          condition: 'Price < 7-day MA by 15%',
          action: '2x investment',
          popularityPercent: 87,
        ),
        DcaRuleTemplate(
          id: 'template-rsi',
          name: 'RSI Oversold Entry',
          category: 'Entry',
          description: 'Increase buying when RSI shows oversold',
          condition: 'RSI < 30',
          action: '1.5x investment',
          popularityPercent: 72,
        ),
        DcaRuleTemplate(
          id: 'template-cross',
          name: 'Golden Cross',
          category: 'Entry',
          description: 'Increase on bullish MA crossover',
          condition: 'MA(50) crosses above MA(200)',
          action: '2x for next 4 weeks',
          popularityPercent: 65,
        ),
        DcaRuleTemplate(
          id: 'template-profit',
          name: 'Profit Protection',
          category: 'Exit',
          description: 'Take partial profits at targets',
          condition: 'Position up 25%',
          action: 'Sell 20%',
          popularityPercent: 58,
        ),
        DcaRuleTemplate(
          id: 'template-stop',
          name: 'Stop Loss',
          category: 'Exit',
          description: 'Cut losses on major decline',
          condition: 'Position down 30%',
          action: 'Pause DCA & reduce 50%',
          popularityPercent: 45,
        ),
        DcaRuleTemplate(
          id: 'template-pause',
          name: 'High Volatility Pause',
          category: 'Adjust',
          description: 'Wait out extreme volatility',
          condition: '30-day volatility > 50%',
          action: 'Pause 2 weeks',
          popularityPercent: 52,
        ),
      ],
      history: [
        DcaRuleHistoryEntry(
          id: 'history-dip',
          ruleName: 'Buy the Dip -10%',
          triggeredAtLabel: '11 thg 5, 10:00',
          condition: r'Price dropped to $45,000',
          action: r'Doubled to $2,000',
          result: DcaSmartRuleResult.executed,
        ),
        DcaRuleHistoryEntry(
          id: 'history-rsi',
          ruleName: 'RSI Oversold',
          triggeredAtLabel: '4 thg 5, 10:00',
          condition: 'RSI = 28',
          action: r'Increased to $1,500',
          result: DcaSmartRuleResult.executed,
        ),
        DcaRuleHistoryEntry(
          id: 'history-volatility',
          ruleName: 'Pause High Volatility',
          triggeredAtLabel: '15 thg 5, 10:00',
          condition: 'Volatility = 45%',
          action: 'Paused DCA',
          result: DcaSmartRuleResult.executed,
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

final dcaRepositoryProvider = Provider<DcaRepository>((ref) {
  return const DcaRepository();
});

class DcaDashboardSnapshot {
  const DcaDashboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.overview,
    required this.sparkline,
    required this.tools,
    required this.plans,
    required this.history,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final DcaOverview overview;
  final List<double> sparkline;
  final List<DcaTool> tools;
  final List<DcaPlan> plans;
  final List<DcaHistoryPoint> history;
}

class DcaOverview {
  const DcaOverview({
    required this.currentValueVnd,
    required this.totalInvestedVnd,
    required this.profitLossVnd,
    required this.profitLossPercent,
    required this.activePlans,
    required this.pausedPlans,
    required this.errorPlans,
    required this.nextRelativeTime,
    required this.nextAmountVnd,
  });

  final int currentValueVnd;
  final int totalInvestedVnd;
  final int profitLossVnd;
  final double profitLossPercent;
  final int activePlans;
  final int pausedPlans;
  final int errorPlans;
  final String nextRelativeTime;
  final int nextAmountVnd;

  int get totalPlans => activePlans + pausedPlans + errorPlans;

  int get averagePerPlanVnd {
    if (totalPlans == 0) return 0;
    return (totalInvestedVnd / totalPlans).round();
  }
}

enum DcaToolIcon { target, activity, sliders, clock }

enum DcaToolAccent { purple, primary, success, warning }

class DcaTool {
  const DcaTool({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String route;
  final DcaToolIcon icon;
  final DcaToolAccent accent;
}

class DcaPlan {
  const DcaPlan({
    required this.id,
    required this.coinSymbol,
    required this.coinName,
    required this.frequency,
    required this.amountPerPurchaseVnd,
    required this.nextExecutionLabel,
    required this.status,
    required this.totalInvestedVnd,
    required this.currentHoldings,
    required this.profitLossPercent,
  });

  final String id;
  final String coinSymbol;
  final String coinName;
  final DcaFrequency frequency;
  final int amountPerPurchaseVnd;
  final String nextExecutionLabel;
  final DcaPlanStatus status;
  final int totalInvestedVnd;
  final double currentHoldings;
  final double profitLossPercent;
}

class DcaHistoryPoint {
  const DcaHistoryPoint({
    required this.day,
    required this.portfolioValueM,
    required this.investedM,
  });

  final String day;
  final double portfolioValueM;
  final double investedM;
}

class DcaRebalanceConfigSnapshot {
  const DcaRebalanceConfigSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalPortfolioUsd,
    required this.driftThreshold,
    required this.minTradeAmountUsd,
    required this.strategy,
    required this.frequency,
    required this.targets,
    required this.strategyOptions,
    required this.frequencyOptions,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int totalPortfolioUsd;
  final double driftThreshold;
  final int minTradeAmountUsd;
  final DcaRebalanceStrategy strategy;
  final DcaRebalanceFrequency frequency;
  final List<DcaRebalanceTarget> targets;
  final List<DcaRebalanceStrategyOption> strategyOptions;
  final List<DcaRebalanceFrequencyOption> frequencyOptions;
}

enum DcaRebalanceAccent { primary, accent, success, warning }

class DcaRebalanceTarget {
  const DcaRebalanceTarget({
    required this.id,
    required this.symbol,
    required this.assetName,
    required this.currentPercent,
    required this.targetPercent,
    required this.tolerance,
    required this.currentValueUsd,
    required this.unitPriceUsd,
    required this.accent,
  });

  final String id;
  final String symbol;
  final String assetName;
  final double currentPercent;
  final double targetPercent;
  final double tolerance;
  final int currentValueUsd;
  final int unitPriceUsd;
  final DcaRebalanceAccent accent;

  DcaRebalanceTarget copyWith({double? targetPercent, double? tolerance}) {
    return DcaRebalanceTarget(
      id: id,
      symbol: symbol,
      assetName: assetName,
      currentPercent: currentPercent,
      targetPercent: targetPercent ?? this.targetPercent,
      tolerance: tolerance ?? this.tolerance,
      currentValueUsd: currentValueUsd,
      unitPriceUsd: unitPriceUsd,
      accent: accent,
    );
  }
}

enum DcaRebalanceOptionIcon { zap, clock, combine }

class DcaRebalanceStrategyOption {
  const DcaRebalanceStrategyOption({
    required this.strategy,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final DcaRebalanceStrategy strategy;
  final String title;
  final String subtitle;
  final DcaRebalanceOptionIcon icon;
}

class DcaRebalanceFrequencyOption {
  const DcaRebalanceFrequencyOption({
    required this.frequency,
    required this.title,
    required this.subtitle,
  });

  final DcaRebalanceFrequency frequency;
  final String title;
  final String subtitle;
}

class DcaRebalanceDashboardSnapshot {
  const DcaRebalanceDashboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.configId,
    required this.configFound,
    required this.message,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final String configId;
  final bool configFound;
  final String message;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaScheduleConfigSnapshot {
  const DcaScheduleConfigSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.strategy,
    required this.timePreference,
    required this.maxDelayHours,
    required this.maxAdvanceHours,
    required this.volatilityThreshold,
    required this.gasPriceThreshold,
    required this.enabled,
    required this.strategies,
    required this.timePreferences,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final DcaScheduleStrategy strategy;
  final DcaScheduleTimePreference timePreference;
  final int maxDelayHours;
  final int maxAdvanceHours;
  final double volatilityThreshold;
  final int gasPriceThreshold;
  final bool enabled;
  final List<DcaScheduleStrategyOption> strategies;
  final List<DcaScheduleTimePreferenceOption> timePreferences;
}

class DcaScheduleAnalyticsSnapshot {
  const DcaScheduleAnalyticsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.configId,
    required this.configFound,
    required this.message,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final String configId;
  final bool configFound;
  final String message;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaScheduleStrategyOption {
  const DcaScheduleStrategyOption({
    required this.strategy,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  final DcaScheduleStrategy strategy;
  final String title;
  final String subtitle;
  final DcaScheduleOptionIcon icon;
  final DcaRebalanceAccent accent;
}

class DcaScheduleTimePreferenceOption {
  const DcaScheduleTimePreferenceOption({
    required this.preference,
    required this.title,
    required this.subtitle,
  });

  final DcaScheduleTimePreference preference;
  final String title;
  final String subtitle;
}

class DcaPortfolioOptimizerSnapshot {
  const DcaPortfolioOptimizerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.score,
    required this.driftPercent,
    required this.driftThresholdPercent,
    required this.optimalSharpe,
    required this.optimalReturnPercent,
    required this.optimalRiskPercent,
    required this.currentAllocations,
    required this.frontier,
    required this.suggestions,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int score;
  final double driftPercent;
  final double driftThresholdPercent;
  final double optimalSharpe;
  final double optimalReturnPercent;
  final double optimalRiskPercent;
  final List<DcaPortfolioAllocation> currentAllocations;
  final List<DcaFrontierPoint> frontier;
  final List<DcaPortfolioSuggestion> suggestions;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaPortfolioAllocation {
  const DcaPortfolioAllocation({
    required this.symbol,
    required this.name,
    required this.currentPercent,
    required this.optimalPercent,
    required this.accent,
  });

  final String symbol;
  final String name;
  final double currentPercent;
  final double optimalPercent;
  final DcaPortfolioAssetAccent accent;

  double get diffPercent => optimalPercent - currentPercent;
}

class DcaFrontierPoint {
  const DcaFrontierPoint({
    required this.label,
    required this.riskPercent,
    required this.returnPercent,
    required this.sharpe,
  });

  final String label;
  final double riskPercent;
  final double returnPercent;
  final double sharpe;
}

class DcaPortfolioSuggestion {
  const DcaPortfolioSuggestion({
    required this.type,
    required this.symbol,
    required this.currentPercent,
    required this.suggestedPercent,
    required this.reason,
  });

  final DcaPortfolioSuggestionType type;
  final String symbol;
  final double currentPercent;
  final double suggestedPercent;
  final String reason;
}

class DcaDynamicAmountSnapshot {
  const DcaDynamicAmountSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.activeStrategy,
    required this.adjustment,
    required this.strategies,
    required this.volatilityHistory,
    required this.amountHistory,
    required this.configItems,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final DcaDynamicStrategy activeStrategy;
  final DcaDynamicAdjustment adjustment;
  final List<DcaDynamicStrategyOption> strategies;
  final List<DcaVolatilitySnapshot> volatilityHistory;
  final List<DcaAmountHistoryEntry> amountHistory;
  final List<DcaDynamicConfigItem> configItems;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaDynamicAdjustment {
  const DcaDynamicAdjustment({
    required this.originalAmountVnd,
    required this.adjustedAmountVnd,
    required this.multiplier,
    required this.reason,
    required this.action,
  });

  final int originalAmountVnd;
  final int adjustedAmountVnd;
  final double multiplier;
  final String reason;
  final DcaDynamicAdjustmentAction action;
}

class DcaDynamicStrategyOption {
  const DcaDynamicStrategyOption({
    required this.strategy,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.accent,
  });

  final DcaDynamicStrategy strategy;
  final String title;
  final String subtitle;
  final String description;
  final DcaScheduleOptionIcon icon;
  final DcaDynamicConfigAccent accent;
}

class DcaVolatilitySnapshot {
  const DcaVolatilitySnapshot({
    required this.date,
    required this.volatilityPercent,
    required this.multiplier,
    required this.amountVnd,
  });

  final String date;
  final double volatilityPercent;
  final double multiplier;
  final int amountVnd;
}

class DcaAmountHistoryEntry {
  const DcaAmountHistoryEntry({
    required this.date,
    required this.baseAmountVnd,
    required this.adjustedAmountVnd,
    required this.strategy,
    required this.reason,
  });

  final String date;
  final int baseAmountVnd;
  final int adjustedAmountVnd;
  final DcaDynamicStrategy strategy;
  final String reason;

  double get changePercent {
    if (baseAmountVnd == 0) return 0;
    return ((adjustedAmountVnd - baseAmountVnd) / baseAmountVnd) * 100;
  }
}

class DcaDynamicConfigItem {
  const DcaDynamicConfigItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final DcaScheduleOptionIcon icon;
  final DcaDynamicConfigAccent accent;
}

class DcaBacktesterSnapshot {
  const DcaBacktesterSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.assets,
    required this.startDate,
    required this.endDate,
    required this.investmentAmountUsd,
    required this.activeFrequency,
    required this.activeStrategy,
    required this.frequencies,
    required this.strategies,
    required this.result,
    required this.historicalData,
    required this.drawdowns,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final List<String> assets;
  final String startDate;
  final String endDate;
  final int investmentAmountUsd;
  final DcaBacktestFrequency activeFrequency;
  final DcaBacktestStrategy activeStrategy;
  final List<DcaBacktestFrequencyOption> frequencies;
  final List<DcaBacktestStrategyOption> strategies;
  final DcaBacktestResult result;
  final List<DcaBacktestPoint> historicalData;
  final List<DcaDrawdownPoint> drawdowns;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaBacktestFrequencyOption {
  const DcaBacktestFrequencyOption({
    required this.frequency,
    required this.label,
  });

  final DcaBacktestFrequency frequency;
  final String label;
}

class DcaBacktestStrategyOption {
  const DcaBacktestStrategyOption({
    required this.strategy,
    required this.title,
    required this.subtitle,
  });

  final DcaBacktestStrategy strategy;
  final String title;
  final String subtitle;
}

class DcaBacktestResult {
  const DcaBacktestResult({
    required this.totalInvestedUsd,
    required this.finalValueUsd,
    required this.totalReturnUsd,
    required this.returnPercent,
    required this.avgBuyPriceUsd,
    required this.totalShares,
    required this.maxDrawdownPercent,
    required this.sharpeRatio,
    required this.volatilityPercent,
    required this.winRatePercent,
    required this.numberOfBuys,
  });

  final int totalInvestedUsd;
  final int finalValueUsd;
  final int totalReturnUsd;
  final double returnPercent;
  final int avgBuyPriceUsd;
  final double totalShares;
  final double maxDrawdownPercent;
  final double sharpeRatio;
  final double volatilityPercent;
  final double winRatePercent;
  final int numberOfBuys;
}

class DcaBacktestPoint {
  const DcaBacktestPoint({
    required this.date,
    required this.priceUsd,
    required this.dcaValueUsd,
    required this.lumpValueUsd,
  });

  final String date;
  final int priceUsd;
  final int dcaValueUsd;
  final int lumpValueUsd;
}

class DcaDrawdownPoint {
  const DcaDrawdownPoint({required this.date, required this.drawdownPercent});

  final String date;
  final double drawdownPercent;
}

class DcaMultiAssetSnapshot {
  const DcaMultiAssetSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalBudgetUsd,
    required this.activeFrequency,
    required this.rebalanceEnabled,
    required this.rebalanceThresholdPercent,
    required this.allocations,
    required this.performance,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int totalBudgetUsd;
  final DcaMultiAssetFrequency activeFrequency;
  final bool rebalanceEnabled;
  final double rebalanceThresholdPercent;
  final List<DcaMultiAssetAllocation> allocations;
  final List<DcaMultiAssetPerformancePoint> performance;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;

  int get totalInvestedUsd {
    return allocations.fold(0, (sum, asset) => sum + asset.totalInvestedUsd);
  }

  int get currentValueUsd {
    return allocations.fold(0, (sum, asset) => sum + asset.currentValueUsd);
  }

  int get totalReturnUsd => currentValueUsd - totalInvestedUsd;

  double get totalReturnPercent {
    if (totalInvestedUsd == 0) return 0;
    return totalReturnUsd / totalInvestedUsd * 100;
  }

  bool get needsRebalance {
    return allocations.any(
      (asset) =>
          (asset.currentPercent - asset.targetPercent).abs() >
          rebalanceThresholdPercent,
    );
  }
}

class DcaMultiAssetAllocation {
  const DcaMultiAssetAllocation({
    required this.id,
    required this.symbol,
    required this.assetName,
    required this.targetPercent,
    required this.currentPercent,
    required this.amountPerPeriodUsd,
    required this.totalInvestedUsd,
    required this.currentValueUsd,
    required this.shares,
    required this.averagePriceUsd,
  });

  final String id;
  final String symbol;
  final String assetName;
  final double targetPercent;
  final double currentPercent;
  final int amountPerPeriodUsd;
  final int totalInvestedUsd;
  final int currentValueUsd;
  final double shares;
  final int averagePriceUsd;

  int get returnUsd => currentValueUsd - totalInvestedUsd;

  double get returnPercent {
    if (totalInvestedUsd == 0) return 0;
    return returnUsd / totalInvestedUsd * 100;
  }
}

class DcaMultiAssetPerformancePoint {
  const DcaMultiAssetPerformancePoint({
    required this.month,
    required this.btcUsd,
    required this.ethUsd,
    required this.bnbUsd,
    required this.solUsd,
  });

  final String month;
  final int btcUsd;
  final int ethUsd;
  final int bnbUsd;
  final int solUsd;

  int get totalUsd => btcUsd + ethUsd + bnbUsd + solUsd;
}

class DcaPerformanceCompareSnapshot {
  const DcaPerformanceCompareSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.investedUsd,
    required this.comparison,
    required this.metrics,
    required this.scenarios,
    required this.radar,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int investedUsd;
  final List<DcaPerformancePoint> comparison;
  final List<DcaComparisonMetric> metrics;
  final List<DcaVolatilityScenario> scenarios;
  final List<DcaRadarMetric> radar;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;

  DcaPerformancePoint get finalPoint => comparison.last;

  int get dcaFinalValueUsd => finalPoint.dcaValueUsd;

  int get lumpSumFinalValueUsd => finalPoint.lumpSumValueUsd;

  double get dcaReturnPercent {
    if (investedUsd == 0) return 0;
    return (dcaFinalValueUsd - investedUsd) / investedUsd * 100;
  }

  double get lumpSumReturnPercent {
    if (investedUsd == 0) return 0;
    return (lumpSumFinalValueUsd - investedUsd) / investedUsd * 100;
  }

  double get advantagePercent => dcaReturnPercent - lumpSumReturnPercent;

  DcaPerformanceWinner get winner {
    return advantagePercent >= 0
        ? DcaPerformanceWinner.dca
        : DcaPerformanceWinner.lumpSum;
  }
}

class DcaPerformancePoint {
  const DcaPerformancePoint({
    required this.month,
    required this.dcaValueUsd,
    required this.lumpSumValueUsd,
    required this.priceUsd,
  });

  final String month;
  final int dcaValueUsd;
  final int lumpSumValueUsd;
  final int priceUsd;
}

class DcaComparisonMetric {
  const DcaComparisonMetric({
    required this.label,
    required this.dcaValue,
    required this.lumpSumValue,
    required this.winner,
  });

  final String label;
  final String dcaValue;
  final String lumpSumValue;
  final DcaPerformanceWinner winner;
}

class DcaVolatilityScenario {
  const DcaVolatilityScenario({
    required this.name,
    required this.scenario,
    required this.description,
    required this.dcaAdvantage,
    required this.lumpSumAdvantage,
  });

  final String name;
  final String scenario;
  final String description;
  final int dcaAdvantage;
  final int lumpSumAdvantage;
}

class DcaRadarMetric {
  const DcaRadarMetric({
    required this.metric,
    required this.dcaScore,
    required this.lumpSumScore,
  });

  final String metric;
  final int dcaScore;
  final int lumpSumScore;
}

class DcaSmartRulesSnapshot {
  const DcaSmartRulesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.successPercent,
    required this.smartRules,
    required this.templates,
    required this.history,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int successPercent;
  final List<DcaSmartRule> smartRules;
  final List<DcaRuleTemplate> templates;
  final List<DcaRuleHistoryEntry> history;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;

  int get activeRules {
    return smartRules
        .where((rule) => rule.status == DcaSmartRuleStatus.active)
        .length;
  }

  int get totalTriggers {
    return smartRules.fold(0, (sum, rule) => sum + rule.triggeredCount);
  }
}

class DcaSmartRule {
  const DcaSmartRule({
    required this.id,
    required this.name,
    required this.type,
    required this.condition,
    required this.action,
    required this.status,
    required this.triggeredCount,
    this.lastTriggeredLabel,
  });

  final String id;
  final String name;
  final DcaSmartRuleType type;
  final String condition;
  final String action;
  final DcaSmartRuleStatus status;
  final int triggeredCount;
  final String? lastTriggeredLabel;
}

class DcaRuleTemplate {
  const DcaRuleTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.condition,
    required this.action,
    required this.popularityPercent,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final String condition;
  final String action;
  final int popularityPercent;
}

class DcaRuleHistoryEntry {
  const DcaRuleHistoryEntry({
    required this.id,
    required this.ruleName,
    required this.triggeredAtLabel,
    required this.condition,
    required this.action,
    required this.result,
  });

  final String id;
  final String ruleName;
  final String triggeredAtLabel;
  final String condition;
  final String action;
  final DcaSmartRuleResult result;
}

class DcaRebalanceTradePreview {
  const DcaRebalanceTradePreview({
    required this.symbol,
    required this.action,
    required this.currentPercent,
    required this.targetPercent,
    required this.tradeAmountUsd,
    required this.tradeQuantity,
  });

  final String symbol;
  final DcaRebalanceTradeAction action;
  final double currentPercent;
  final double targetPercent;
  final double tradeAmountUsd;
  final double tradeQuantity;
}

enum DcaRebalanceTradeAction { buy, sell, hold }
