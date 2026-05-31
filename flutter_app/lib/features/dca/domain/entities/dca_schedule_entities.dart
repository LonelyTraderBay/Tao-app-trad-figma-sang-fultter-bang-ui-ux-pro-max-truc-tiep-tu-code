import 'dca_common_entities.dart';

enum DcaScheduleStrategy { fixed, volatility, gasOptimized, volume, hybrid }

enum DcaScheduleTimePreference { morning, afternoon, evening, night, any }

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
