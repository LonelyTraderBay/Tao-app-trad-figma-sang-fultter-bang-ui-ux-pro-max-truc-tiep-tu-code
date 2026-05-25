import 'package:flutter_riverpod/flutter_riverpod.dart';

final crossModuleAnalyticsRepositoryProvider =
    Provider<CrossModuleAnalyticsRepository>((ref) {
      return const MockCrossModuleAnalyticsRepository();
    });

abstract interface class CrossModuleAnalyticsRepository {
  CrossModuleAnalyticsSnapshot getAnalytics();
}

enum CrossModuleAnalyticsScreenState {
  loading,
  empty,
  error,
  offline,
  realtimeRefresh,
}

enum CrossModuleAnalyticsTab { performance, metrics, comparison }

enum AnalyticsModuleId { trading, p2p, predictions, dca }

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

final class CrossModuleAnalyticsTabDraft {
  const CrossModuleAnalyticsTabDraft({required this.tab, required this.label});

  final CrossModuleAnalyticsTab tab;
  final String label;
}

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

final class MockCrossModuleAnalyticsRepository
    implements CrossModuleAnalyticsRepository {
  const MockCrossModuleAnalyticsRepository();

  @override
  CrossModuleAnalyticsSnapshot getAnalytics() {
    return const CrossModuleAnalyticsSnapshot(
      endpoint: '/api/mobile/cross-module/cross-module-analytics',
      actionDraft: 'read-only or local navigation action',
      title: 'Cross-Module Analytics',
      backRoute: '/home',
      tabs: [
        CrossModuleAnalyticsTabDraft(
          tab: CrossModuleAnalyticsTab.performance,
          label: 'Hieu suat',
        ),
        CrossModuleAnalyticsTabDraft(
          tab: CrossModuleAnalyticsTab.metrics,
          label: 'Chi so',
        ),
        CrossModuleAnalyticsTabDraft(
          tab: CrossModuleAnalyticsTab.comparison,
          label: 'So sanh',
        ),
      ],
      modules: [
        CrossModuleMetricDraft(
          id: AnalyticsModuleId.trading,
          name: 'Spot Trading',
          roi: 12.5,
          totalTrades: 245,
          winRate: 62,
          avgTradeSize: 850,
          totalVolume: 208250,
          activeTimeHours: 48,
          riskScore: 65,
        ),
        CrossModuleMetricDraft(
          id: AnalyticsModuleId.p2p,
          name: 'P2P Trading',
          roi: 1.2,
          totalTrades: 28,
          winRate: 96,
          avgTradeSize: 1200,
          totalVolume: 33600,
          activeTimeHours: 12,
          riskScore: 35,
        ),
        CrossModuleMetricDraft(
          id: AnalyticsModuleId.predictions,
          name: 'Prediction Markets',
          roi: 18.3,
          totalTrades: 87,
          winRate: 58,
          avgTradeSize: 320,
          totalVolume: 27840,
          activeTimeHours: 24,
          riskScore: 72,
        ),
        CrossModuleMetricDraft(
          id: AnalyticsModuleId.dca,
          name: 'DCA Strategy',
          roi: 9.8,
          totalTrades: 12,
          winRate: 100,
          avgTradeSize: 1000,
          totalVolume: 12000,
          activeTimeHours: 6,
          riskScore: 25,
        ),
      ],
      monthlyPerformance: [
        CrossModuleMonthlyPerformanceDraft(
          month: 'Jan',
          trading: 8,
          p2p: 1,
          predictions: 15,
          dca: 9,
        ),
        CrossModuleMonthlyPerformanceDraft(
          month: 'Feb',
          trading: 10,
          p2p: 1.5,
          predictions: 12,
          dca: 9.5,
        ),
        CrossModuleMonthlyPerformanceDraft(
          month: 'Mar',
          trading: 9,
          p2p: .8,
          predictions: 20,
          dca: 10,
        ),
        CrossModuleMonthlyPerformanceDraft(
          month: 'Apr',
          trading: 11,
          p2p: 1.2,
          predictions: 16,
          dca: 9.8,
        ),
        CrossModuleMonthlyPerformanceDraft(
          month: 'May',
          trading: 13,
          p2p: 1.4,
          predictions: 19,
          dca: 10.2,
        ),
        CrossModuleMonthlyPerformanceDraft(
          month: 'Jun',
          trading: 12.5,
          p2p: 1.2,
          predictions: 18.3,
          dca: 9.8,
        ),
      ],
      contractNotes:
          'Cross-module analytics compares value-based modules only. Open Arena is points-only and stays outside financial analytics.',
      supportedStates: {
        CrossModuleAnalyticsScreenState.loading,
        CrossModuleAnalyticsScreenState.empty,
        CrossModuleAnalyticsScreenState.error,
        CrossModuleAnalyticsScreenState.offline,
        CrossModuleAnalyticsScreenState.realtimeRefresh,
      },
    );
  }
}
