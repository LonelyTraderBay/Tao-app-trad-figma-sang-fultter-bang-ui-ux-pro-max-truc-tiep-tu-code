import 'package:vit_trade_flutter/features/dca/domain/entities/dca_common_entities.dart';

/// Strategy used to time smart-scheduled DCA buys.
enum DcaScheduleStrategy { fixed, volatility, gasOptimized, volume, hybrid }

/// Preferred time-of-day window for smart-scheduled DCA buys.
enum DcaScheduleTimePreference { morning, afternoon, evening, night, any }

/// Data for the DCA smart-schedule config screen: strategy/time-preference
/// settings, delay bounds, and their selectable option lists.
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

/// Data for one smart-schedule config's analytics screen, resolved from
/// [configId] (found/not-found + status message).
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

/// One selectable [DcaScheduleStrategy] entry with title/subtitle/icon/
/// accent copy.
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

/// One selectable [DcaScheduleTimePreference] entry with title/subtitle
/// copy.
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
