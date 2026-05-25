import 'package:flutter_riverpod/flutter_riverpod.dart';

final unifiedPortfolioRepositoryProvider = Provider<UnifiedPortfolioRepository>(
  (ref) {
    return const MockUnifiedPortfolioRepository();
  },
);

abstract interface class UnifiedPortfolioRepository {
  UnifiedPortfolioSnapshot getDashboard();
}

enum UnifiedPortfolioScreenState { loading, empty, error, offline }

enum UnifiedPortfolioTab { overview, analysis, history }

enum UnifiedPortfolioModuleId { wallet, trading, p2p, predictions, arena, dca }

final class UnifiedPortfolioSnapshot {
  const UnifiedPortfolioSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.modules,
    required this.history,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<UnifiedPortfolioTabDraft> tabs;
  final List<UnifiedPortfolioModuleDraft> modules;
  final List<UnifiedPortfolioHistoryPoint> history;
  final String contractNotes;
  final Set<UnifiedPortfolioScreenState> supportedStates;

  Iterable<UnifiedPortfolioModuleDraft> get financialModules =>
      modules.where((module) => !module.pointsOnly && module.value > 0);

  int get totalValue =>
      financialModules.fold(0, (sum, item) => sum + item.value);

  int get totalPnl => financialModules.fold(0, (sum, item) => sum + item.pnl);

  double get totalPnlPercent {
    final principal = totalValue - totalPnl;
    if (principal == 0) return 0;
    return totalPnl / principal * 100;
  }

  int get totalPositions =>
      modules.fold(0, (sum, item) => sum + item.activePositions);

  int get activeModules =>
      modules.where((module) => module.activePositions > 0).length;
}

final class UnifiedPortfolioTabDraft {
  const UnifiedPortfolioTabDraft({required this.tab, required this.label});

  final UnifiedPortfolioTab tab;
  final String label;
}

final class UnifiedPortfolioModuleDraft {
  const UnifiedPortfolioModuleDraft({
    required this.id,
    required this.name,
    required this.value,
    required this.change24h,
    required this.activePositions,
    required this.pnl,
    required this.route,
    this.pointsOnly = false,
  });

  final UnifiedPortfolioModuleId id;
  final String name;
  final int value;
  final double change24h;
  final int activePositions;
  final int pnl;
  final String route;
  final bool pointsOnly;
}

final class UnifiedPortfolioHistoryPoint {
  const UnifiedPortfolioHistoryPoint({
    required this.label,
    required this.wallet,
    required this.trading,
    required this.p2p,
    required this.predictions,
    required this.dca,
  });

  final String label;
  final int wallet;
  final int trading;
  final int p2p;
  final int predictions;
  final int dca;
}

final class MockUnifiedPortfolioRepository
    implements UnifiedPortfolioRepository {
  const MockUnifiedPortfolioRepository();

  @override
  UnifiedPortfolioSnapshot getDashboard() {
    return const UnifiedPortfolioSnapshot(
      endpoint: '/api/mobile/cross-module/unified-portfolio',
      actionDraft: 'read-only or local navigation action',
      title: 'Unified Portfolio',
      backRoute: '/home',
      tabs: [
        UnifiedPortfolioTabDraft(
          tab: UnifiedPortfolioTab.overview,
          label: 'Tong quan',
        ),
        UnifiedPortfolioTabDraft(
          tab: UnifiedPortfolioTab.analysis,
          label: 'Phan tich',
        ),
        UnifiedPortfolioTabDraft(
          tab: UnifiedPortfolioTab.history,
          label: 'Lich su',
        ),
      ],
      modules: [
        UnifiedPortfolioModuleDraft(
          id: UnifiedPortfolioModuleId.wallet,
          name: 'Wallet Holdings',
          value: 45280,
          change24h: 3.2,
          activePositions: 8,
          pnl: 1350,
          route: '/wallet',
        ),
        UnifiedPortfolioModuleDraft(
          id: UnifiedPortfolioModuleId.trading,
          name: 'Trading Positions',
          value: 28900,
          change24h: -1.5,
          activePositions: 12,
          pnl: -420,
          route: '/trade',
        ),
        UnifiedPortfolioModuleDraft(
          id: UnifiedPortfolioModuleId.p2p,
          name: 'P2P Orders',
          value: 8500,
          change24h: 0.8,
          activePositions: 3,
          pnl: 85,
          route: '/p2p',
        ),
        UnifiedPortfolioModuleDraft(
          id: UnifiedPortfolioModuleId.predictions,
          name: 'Prediction Markets',
          value: 5200,
          change24h: 5.6,
          activePositions: 7,
          pnl: 780,
          route: '/markets/predictions',
        ),
        UnifiedPortfolioModuleDraft(
          id: UnifiedPortfolioModuleId.arena,
          name: 'Arena (Points Only)',
          value: 0,
          change24h: 0,
          activePositions: 4,
          pnl: 0,
          route: '/arena',
          pointsOnly: true,
        ),
        UnifiedPortfolioModuleDraft(
          id: UnifiedPortfolioModuleId.dca,
          name: 'DCA Plans',
          value: 14500,
          change24h: 2.1,
          activePositions: 2,
          pnl: 1200,
          route: '/dca',
        ),
      ],
      history: [
        UnifiedPortfolioHistoryPoint(
          label: 'Jan',
          wallet: 42000,
          trading: 30000,
          p2p: 8000,
          predictions: 4500,
          dca: 12000,
        ),
        UnifiedPortfolioHistoryPoint(
          label: 'Feb',
          wallet: 43000,
          trading: 29500,
          p2p: 8200,
          predictions: 4800,
          dca: 13000,
        ),
        UnifiedPortfolioHistoryPoint(
          label: 'Mar',
          wallet: 44000,
          trading: 28800,
          p2p: 8400,
          predictions: 5000,
          dca: 13800,
        ),
        UnifiedPortfolioHistoryPoint(
          label: 'Apr',
          wallet: 44500,
          trading: 28500,
          p2p: 8300,
          predictions: 5100,
          dca: 14200,
        ),
        UnifiedPortfolioHistoryPoint(
          label: 'May',
          wallet: 45000,
          trading: 29200,
          p2p: 8600,
          predictions: 5300,
          dca: 14600,
        ),
        UnifiedPortfolioHistoryPoint(
          label: 'Now',
          wallet: 45280,
          trading: 28900,
          p2p: 8500,
          predictions: 5200,
          dca: 14500,
        ),
      ],
      contractNotes:
          'Unified Portfolio aggregates value-bearing modules while preserving the Arena points-only boundary. CTAs are local navigation into each owning module.',
      supportedStates: {
        UnifiedPortfolioScreenState.loading,
        UnifiedPortfolioScreenState.empty,
        UnifiedPortfolioScreenState.error,
        UnifiedPortfolioScreenState.offline,
      },
    );
  }
}
