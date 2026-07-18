/// UI state the cross-module analytics screen supports rendering.
enum CrossModuleAnalyticsScreenState {
  loading,
  empty,
  error,
  offline,
  realtimeRefresh,
}

/// The active tab on the cross-module analytics screen.
enum CrossModuleAnalyticsTab { performance, metrics, comparison }

/// A product module tracked by cross-module analytics.
enum AnalyticsModuleId { trading, p2p, predictions, dca }

/// Data for the cross-module analytics screen: per-module [modules]
/// metrics, monthly performance series, and available [tabs].
final class CrossModuleAnalyticsSnapshot {
  const CrossModuleAnalyticsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.modules,
    required this.monthlyPerformance,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<CrossModuleAnalyticsTabDraft> tabs;
  final List<CrossModuleMetricDraft> modules;
  final List<CrossModuleMonthlyPerformanceDraft> monthlyPerformance;
  final String contractNotes;
  final Set<CrossModuleAnalyticsScreenState> supportedStates;

  double get averageRoi =>
      modules.fold<double>(0, (sum, module) => sum + module.roi) /
      modules.length;

  int get totalTrades =>
      modules.fold(0, (sum, module) => sum + module.totalTrades);

  int get totalVolume =>
      modules.fold(0, (sum, module) => sum + module.totalVolume);

  double get averageWinRate =>
      modules.fold<double>(0, (sum, module) => sum + module.winRate) /
      modules.length;

  CrossModuleMetricDraft get bestRoiModule {
    final sorted = [...modules]..sort((a, b) => b.roi.compareTo(a.roi));
    return sorted.first;
  }

  CrossModuleMetricDraft get mostActiveModule {
    final sorted = [...modules]
      ..sort((a, b) => b.totalTrades.compareTo(a.totalTrades));
    return sorted.first;
  }
}

/// One selectable [CrossModuleAnalyticsTab] entry with its display label.
final class CrossModuleAnalyticsTabDraft {
  const CrossModuleAnalyticsTabDraft({required this.tab, required this.label});

  final CrossModuleAnalyticsTab tab;
  final String label;
}

/// One module's performance metrics (ROI, trades, win rate, volume, risk
/// score) shown on the cross-module analytics screen.
final class CrossModuleMetricDraft {
  const CrossModuleMetricDraft({
    required this.id,
    required this.name,
    required this.roi,
    required this.totalTrades,
    required this.winRate,
    required this.avgTradeSize,
    required this.totalVolume,
    required this.activeTimeHours,
    required this.riskScore,
  });

  final AnalyticsModuleId id;
  final String name;
  final double roi;
  final int totalTrades;
  final double winRate;
  final int avgTradeSize;
  final int totalVolume;
  final int activeTimeHours;
  final int riskScore;
}

/// One month's per-module performance values in the cross-module
/// analytics comparison chart.
final class CrossModuleMonthlyPerformanceDraft {
  const CrossModuleMonthlyPerformanceDraft({
    required this.month,
    required this.trading,
    required this.p2p,
    required this.predictions,
    required this.dca,
  });

  final String month;
  final double trading;
  final double p2p;
  final double predictions;
  final double dca;
}
