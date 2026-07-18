import 'package:vit_trade_flutter/features/dca/domain/entities/dca_common_entities.dart';

/// Trigger strategy for a portfolio rebalance plan.
enum DcaRebalanceStrategy { threshold, periodic, hybrid }

/// Recurring check frequency for a periodic/hybrid rebalance plan.
enum DcaRebalanceFrequency { weekly, biweekly, monthly, quarterly }

/// Data for the DCA rebalance config screen: strategy/frequency settings
/// plus per-asset [targets] and their selectable option lists.
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

/// One asset's target allocation percent/tolerance within a rebalance
/// config.
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

/// Leading icon choice for a rebalance strategy option row.
enum DcaRebalanceOptionIcon { zap, clock, combine }

/// One selectable [DcaRebalanceStrategy] entry with title/subtitle/icon
/// copy.
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

/// One selectable [DcaRebalanceFrequency] entry with title/subtitle copy.
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

/// Data for one rebalance config's dashboard screen, resolved from
/// [configId] (found/not-found + status message).
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

/// One proposed buy/sell trade (amount, quantity, current-vs-target
/// percent) needed to execute a rebalance.
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

/// The action a [DcaRebalanceTradePreview] proposes for one asset.
enum DcaRebalanceTradeAction { buy, sell, hold }
