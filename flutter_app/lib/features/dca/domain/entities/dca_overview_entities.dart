import 'package:vit_trade_flutter/features/dca/domain/entities/dca_common_entities.dart';

/// Data for the DCA component demo/showcase screen: header copy plus the
/// list of demo [scenarios] and the featured [mobilePreview].
class DcaOverviewDemoSnapshot {
  const DcaOverviewDemoSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.componentName,
    required this.componentLocation,
    required this.contractNotes,
    required this.scenarios,
    required this.mobilePreview,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String backRoute;
  final String componentName;
  final String componentLocation;
  final String contractNotes;
  final List<DcaOverviewDemoScenario> scenarios;
  final DcaOverviewDemoScenario mobilePreview;
}

/// One named demo scenario (data + sparkline) shown on the DCA demo screen.
class DcaOverviewDemoScenario {
  const DcaOverviewDemoScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.data,
    required this.sparkline,
    required this.showActions,
  });

  final String id;
  final String title;
  final String description;
  final DcaOverviewDemoData data;
  final List<double> sparkline;
  final bool showActions;
}

/// Portfolio value/P&L/plan-count data backing one [DcaOverviewDemoScenario].
class DcaOverviewDemoData {
  const DcaOverviewDemoData({
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
  final String? nextRelativeTime;
  final int? nextAmountVnd;

  int get totalPlans => activePlans + pausedPlans + errorPlans;

  int get averagePerPlanVnd {
    if (totalPlans == 0) return 0;
    return (totalInvestedVnd / totalPlans).round();
  }

  bool get isProfit => profitLossVnd >= 0;
}

/// Data for the DCA dashboard/home screen: portfolio [overview], sparkline,
/// tool shortcuts, active [plans], and history chart.
class DcaDashboardSnapshot {
  const DcaDashboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.screenState,
    required this.overview,
    required this.sparkline,
    required this.tools,
    required this.plans,
    required this.history,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final DcaScreenState screenState;
  final DcaOverview overview;
  final List<double> sparkline;
  final List<DcaTool> tools;
  final List<DcaPlan> plans;
  final List<DcaHistoryPoint> history;
}

/// Portfolio-level summary (value, P&L, plan counts, next execution) shown
/// on the DCA dashboard.
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

/// Leading icon choice for a [DcaTool] shortcut card.
enum DcaToolIcon { target, activity, sliders, clock }

/// Accent color choice for a [DcaTool] shortcut card.
enum DcaToolAccent { purple, primary, success, warning }

/// One DCA tool shortcut (title/route/icon/accent) shown on the dashboard.
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

/// One active/paused/error DCA plan (coin, frequency, amount, holdings,
/// P&L) shown on the dashboard.
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

/// One daily portfolio-value/invested data point in the dashboard's
/// history chart.
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
