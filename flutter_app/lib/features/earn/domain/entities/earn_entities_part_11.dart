part of 'earn_entities.dart';

final class SavingsExportReportDraft {
  const SavingsExportReportDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.rowsLabel,
  });

  final SavingsExportReportType id;
  final String title;
  final String description;
  final String iconKey;
  final String rowsLabel;
}

final class SavingsExportFormatDraft {
  const SavingsExportFormatDraft({
    required this.id,
    required this.label,
    required this.description,
  });

  final SavingsExportFormat id;
  final String label;
  final String description;
}

final class SavingsExportPeriodDraft {
  const SavingsExportPeriodDraft({required this.id, required this.label});

  final SavingsExportPeriod id;
  final String label;
}

final class SavingsExportScopeDraft {
  const SavingsExportScopeDraft({
    required this.id,
    required this.label,
    required this.iconKey,
  });

  final SavingsExportScope id;
  final String label;
  final String iconKey;
}

final class SavingsExportOptionDraft {
  const SavingsExportOptionDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconKey;
}

final class SavingsExportHistoryDraft {
  const SavingsExportHistoryDraft({
    required this.id,
    required this.fileName,
    required this.format,
    required this.reportType,
    required this.period,
    required this.rowsLabel,
    required this.fileSize,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
  });

  final String id;
  final String fileName;
  final SavingsExportFormat format;
  final SavingsExportReportType reportType;
  final String period;
  final String rowsLabel;
  final String fileSize;
  final SavingsExportStatus status;
  final String createdAt;
  final String expiresAt;
}

final class SavingsBacktestSnapshot {
  const SavingsBacktestSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.recommendationsRoute,
    required this.tabs,
    required this.defaultTab,
    required this.heroLabel,
    required this.defaultAmountUsd,
    required this.quickAmounts,
    required this.defaultPeriod,
    required this.periods,
    required this.defaultPreset,
    required this.presets,
    required this.disclaimer,
    required this.result,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String recommendationsRoute;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final String heroLabel;
  final int defaultAmountUsd;
  final List<int> quickAmounts;
  final SavingsBacktestPeriod defaultPeriod;
  final List<SavingsBacktestPeriodDraft> periods;
  final SavingsBacktestPreset defaultPreset;
  final List<SavingsBacktestPresetDraft> presets;
  final String disclaimer;
  final SavingsBacktestResultDraft result;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsBacktestPeriodDraft {
  const SavingsBacktestPeriodDraft({
    required this.id,
    required this.label,
    required this.months,
  });

  final SavingsBacktestPeriod id;
  final String label;
  final int months;
}

final class SavingsBacktestPresetDraft {
  const SavingsBacktestPresetDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.riskLabel,
    required this.slots,
  });

  final SavingsBacktestPreset id;
  final String label;
  final String description;
  final String iconKey;
  final String riskLabel;
  final List<SavingsBacktestSlotDraft> slots;
}

final class SavingsBacktestSlotDraft {
  const SavingsBacktestSlotDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.typeLabel,
    required this.percentage,
    required this.avgApy,
    required this.colorKey,
    this.lockDays,
  });

  final String id;
  final String product;
  final String asset;
  final String typeLabel;
  final int percentage;
  final double avgApy;
  final String colorKey;
  final int? lockDays;
}

final class SavingsBacktestResultDraft {
  const SavingsBacktestResultDraft({
    required this.totalReturnUsd,
    required this.totalReturnPct,
    required this.annualizedReturnPct,
    required this.maxDrawdownPct,
    required this.sharpeRatio,
    required this.finalValueUsd,
    required this.bestMonthUsd,
    required this.worstMonthUsd,
    required this.monthsPositive,
    required this.monthsNegative,
    required this.points,
  });

  final double totalReturnUsd;
  final double totalReturnPct;
  final double annualizedReturnPct;
  final double maxDrawdownPct;
  final double sharpeRatio;
  final double finalValueUsd;
  final double bestMonthUsd;
  final double worstMonthUsd;
  final int monthsPositive;
  final int monthsNegative;
  final List<SavingsBacktestPointDraft> points;
}

final class SavingsBacktestPointDraft {
  const SavingsBacktestPointDraft({
    required this.month,
    required this.valueUsd,
    required this.interestUsd,
  });

  final String month;
  final double valueUsd;
  final double interestUsd;
}

final class SavingsAutoPilotSnapshot {
  const SavingsAutoPilotSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.heroLabel,
    required this.config,
    required this.modes,
    required this.metrics,
    required this.modules,
    required this.actions,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final String heroLabel;
  final SavingsAutoPilotConfigDraft config;
  final List<SavingsAutoPilotModeDraft> modes;
  final List<SavingsAutoPilotMetricDraft> metrics;
  final List<SavingsAutoPilotModuleDraft> modules;
  final List<SavingsAutoPilotActionDraft> actions;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsAutoPilotConfigDraft {
  const SavingsAutoPilotConfigDraft({
    required this.mode,
    required this.status,
    required this.monthlyBudgetUsd,
    required this.dcaEnabled,
    required this.dcaFrequencyLabel,
    required this.rebalanceEnabled,
    required this.rebalanceThresholdPct,
    required this.smartSwitchEnabled,
    required this.switchMinApyGainPct,
    required this.compoundEnabled,
    required this.riskGuardEnabled,
    required this.maxSingleAssetPct,
    required this.notificationsEnabled,
    required this.approvalRequired,
  });

  final SavingsAutoPilotMode mode;
  final SavingsAutoPilotStatus status;
  final int monthlyBudgetUsd;
  final bool dcaEnabled;
  final String dcaFrequencyLabel;
  final bool rebalanceEnabled;
  final int rebalanceThresholdPct;
  final bool smartSwitchEnabled;
  final double switchMinApyGainPct;
  final bool compoundEnabled;
  final bool riskGuardEnabled;
  final int maxSingleAssetPct;
  final bool notificationsEnabled;
  final bool approvalRequired;
}

final class SavingsAutoPilotModeDraft {
  const SavingsAutoPilotModeDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.tone,
    required this.dcaFrequency,
    required this.rebalanceThreshold,
    required this.switchMinGain,
    required this.maxConcentration,
  });

  final SavingsAutoPilotMode id;
  final String label;
  final String description;
  final String iconKey;
  final EarnRiskLevel tone;
  final String dcaFrequency;
  final String rebalanceThreshold;
  final String switchMinGain;
  final String maxConcentration;
}

final class SavingsAutoPilotMetricDraft {
  const SavingsAutoPilotMetricDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.deltaLabel,
    required this.iconKey,
    required this.tone,
  });

  final String id;
  final String label;
  final String value;
  final String deltaLabel;
  final String iconKey;
  final EarnRiskLevel tone;
}

final class SavingsAutoPilotModuleDraft {
  const SavingsAutoPilotModuleDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.enabled,
    required this.iconKey,
    required this.tone,
    required this.route,
  });

  final String id;
  final String label;
  final String description;
  final bool enabled;
  final String iconKey;
  final EarnRiskLevel tone;
  final String route;
}

final class SavingsAutoPilotActionDraft {
  const SavingsAutoPilotActionDraft({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.impact,
    required this.impactValue,
    required this.details,
  });

  final String id;
  final SavingsAutoPilotActionType type;
  final SavingsAutoPilotActionStatus status;
  final String title;
  final String description;
  final String timestamp;
  final String impact;
  final double impactValue;
  final Map<String, String> details;
}

final class SavingsLadderSnapshot {
  const SavingsLadderSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroLabel,
    required this.tabs,
    required this.defaultTab,
    required this.defaultAmountUsd,
    required this.quickAmounts,
    required this.defaultPreset,
    required this.templates,
    required this.availableProducts,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroLabel;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final int defaultAmountUsd;
  final List<int> quickAmounts;
  final SavingsLadderPreset defaultPreset;
  final List<SavingsLadderTemplateDraft> templates;
  final List<SavingsLadderProductDraft> availableProducts;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsLadderTemplateDraft {
  const SavingsLadderTemplateDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.tone,
    required this.intervals,
  });

  final SavingsLadderPreset id;
  final String label;
  final String description;
  final String iconKey;
  final EarnRiskLevel tone;
  final List<SavingsLadderIntervalDraft> intervals;
}

final class SavingsLadderIntervalDraft {
  const SavingsLadderIntervalDraft({
    required this.lockDays,
    required this.allocationPct,
    required this.product,
    required this.asset,
    required this.apyPct,
    required this.colorKey,
  });

  final int lockDays;
  final int allocationPct;
  final String product;
  final String asset;
  final double apyPct;
  final String colorKey;
}

final class SavingsLadderRungDraft {
  const SavingsLadderRungDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.colorKey,
    required this.lockDays,
    required this.apyPct,
    required this.amountUsd,
    required this.startDate,
    required this.maturityDate,
    required this.autoRenew,
  });

  final String id;
  final String product;
  final String asset;
  final String colorKey;
  final int lockDays;
  final double apyPct;
  final double amountUsd;
  final String startDate;
  final String maturityDate;
  final bool autoRenew;
}

final class SavingsLadderProductDraft {
  const SavingsLadderProductDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.colorKey,
    required this.lockDays,
    required this.apyPct,
  });

  final String id;
  final String product;
  final String asset;
  final String colorKey;
  final int lockDays;
  final double apyPct;
}

final class SavingsWhatIfSnapshot {
  const SavingsWhatIfSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroLabel,
    required this.tabs,
    required this.defaultTab,
    required this.defaultScenario,
    required this.defaultCustomMultiplier,
    required this.defaultCustomVolatility,
    required this.scenarios,
    required this.portfolio,
    required this.disclaimer,
    required this.stressDisclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroLabel;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final SavingsWhatIfScenarioId defaultScenario;
  final double defaultCustomMultiplier;
  final double defaultCustomVolatility;
  final List<SavingsWhatIfScenarioDraft> scenarios;
  final List<SavingsWhatIfPortfolioPositionDraft> portfolio;
  final String disclaimer;
  final String stressDisclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsWhatIfScenarioDraft {
  const SavingsWhatIfScenarioDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.apyMultiplier,
    required this.volatility,
    required this.durationMonths,
    required this.riskLevel,
  });

  final SavingsWhatIfScenarioId id;
  final String label;
  final String description;
  final String iconKey;
  final double apyMultiplier;
  final double volatility;
  final int durationMonths;
  final SavingsWhatIfRiskLevel riskLevel;
}
