import 'package:vit_trade_flutter/features/dca/domain/entities/dca_common_entities.dart';

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
