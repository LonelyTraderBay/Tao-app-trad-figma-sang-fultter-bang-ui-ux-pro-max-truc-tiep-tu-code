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
