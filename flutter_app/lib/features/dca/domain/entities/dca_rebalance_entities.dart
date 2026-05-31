import 'dca_common_entities.dart';

enum DcaRebalanceStrategy { threshold, periodic, hybrid }

enum DcaRebalanceFrequency { weekly, biweekly, monthly, quarterly }

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
