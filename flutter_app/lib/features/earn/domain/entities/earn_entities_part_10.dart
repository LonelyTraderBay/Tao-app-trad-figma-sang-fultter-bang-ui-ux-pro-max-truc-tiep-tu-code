part of 'earn_entities.dart';

final class SavingsAutoRebalanceSnapshot {
  const SavingsAutoRebalanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.defaultStrategyId,
    required this.totalPortfolio,
    required this.positions,
    required this.strategies,
    required this.driftHistory,
    required this.history,
    required this.settings,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<String> tabs;
  final String defaultTab;
  final String defaultStrategyId;
  final double totalPortfolio;
  final List<SavingsRebalancePositionDraft> positions;
  final List<SavingsRebalanceStrategyDraft> strategies;
  final List<SavingsRebalanceDriftPointDraft> driftHistory;
  final List<SavingsRebalanceHistoryDraft> history;
  final SavingsRebalanceSettingsDraft settings;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsRebalancePositionDraft {
  const SavingsRebalancePositionDraft({
    required this.id,
    required this.asset,
    required this.product,
    required this.currentValue,
    required this.currentPct,
    required this.targetPct,
    required this.apy,
    required this.colorName,
    required this.locked,
    required this.rebalanceable,
    this.lockDays,
    this.daysRemaining,
  });

  final String id;
  final String asset;
  final String product;
  final double currentValue;
  final double currentPct;
  final double targetPct;
  final double apy;
  final String colorName;
  final bool locked;
  final bool rebalanceable;
  final int? lockDays;
  final int? daysRemaining;
}

final class SavingsRebalanceStrategyDraft {
  const SavingsRebalanceStrategyDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.riskLevel,
    required this.expectedApy,
    required this.allocations,
  });

  final String id;
  final String name;
  final String description;
  final SavingsRebalanceRiskLevel riskLevel;
  final double expectedApy;
  final Map<String, double> allocations;
}

final class SavingsRebalanceDriftPointDraft {
  const SavingsRebalanceDriftPointDraft({
    required this.date,
    required this.drift,
  });

  final String date;
  final double drift;
}

final class SavingsRebalanceHistoryDraft {
  const SavingsRebalanceHistoryDraft({
    required this.id,
    required this.date,
    required this.strategy,
    required this.actions,
    required this.totalMoved,
    required this.status,
    required this.driftBefore,
    required this.driftAfter,
  });

  final String id;
  final String date;
  final String strategy;
  final int actions;
  final double totalMoved;
  final SavingsRebalanceHistoryStatus status;
  final double driftBefore;
  final double driftAfter;
}

final class SavingsRebalanceSettingsDraft {
  const SavingsRebalanceSettingsDraft({
    required this.autoEnabled,
    required this.frequencyLabel,
    required this.driftThreshold,
    required this.skipLocked,
    required this.minTradeSize,
  });

  final bool autoEnabled;
  final String frequencyLabel;
  final double driftThreshold;
  final bool skipLocked;
  final double minTradeSize;
}

final class SavingsNotificationPreferencesSnapshot {
  const SavingsNotificationPreferencesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.masterEnabled,
    required this.alerts,
    required this.productAlerts,
    required this.channels,
    required this.digestFrequency,
    required this.quietHours,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final bool masterEnabled;
  final List<SavingsNotificationAlertDraft> alerts;
  final List<SavingsProductNotificationDraft> productAlerts;
  final List<SavingsDeliveryChannelDraft> channels;
  final SavingsDeliveryFrequency digestFrequency;
  final SavingsQuietHoursDraft quietHours;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsPreferenceTabDraft {
  const SavingsPreferenceTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class SavingsNotificationAlertDraft {
  const SavingsNotificationAlertDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.enabled,
    required this.category,
    required this.severity,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final bool enabled;
  final SavingsNotificationPreferenceCategory category;
  final SavingsNotificationPreferenceSeverity severity;
}

final class SavingsProductNotificationDraft {
  const SavingsProductNotificationDraft({
    required this.id,
    required this.productName,
    required this.asset,
    required this.typeLabel,
    required this.enabledCount,
    required this.totalCount,
    required this.alertLabels,
  });

  final String id;
  final String productName;
  final String asset;
  final String typeLabel;
  final int enabledCount;
  final int totalCount;
  final List<String> alertLabels;
}

final class SavingsDeliveryChannelDraft {
  const SavingsDeliveryChannelDraft({
    required this.id,
    required this.label,
    required this.detail,
    required this.iconKey,
    required this.enabled,
    this.locked = false,
  });

  final String id;
  final String label;
  final String detail;
  final String iconKey;
  final bool enabled;
  final bool locked;
}

final class SavingsQuietHoursDraft {
  const SavingsQuietHoursDraft({
    required this.enabled,
    required this.startHour,
    required this.endHour,
    required this.allowCritical,
  });

  final bool enabled;
  final int startHour;
  final int endHour;
  final bool allowCritical;
}

final class SavingsDcaSnapshot {
  const SavingsDcaSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.heroLabel,
    required this.totalInvestedUsd,
    required this.totalCurrentUsd,
    required this.gainUsd,
    required this.gainLabel,
    required this.activePlanCount,
    required this.strategyLabel,
    required this.infoText,
    required this.plans,
    required this.executions,
    required this.products,
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
  final String totalInvestedUsd;
  final String totalCurrentUsd;
  final String gainUsd;
  final String gainLabel;
  final int activePlanCount;
  final String strategyLabel;
  final String infoText;
  final List<SavingsDcaPlanDraft> plans;
  final List<SavingsDcaExecutionDraft> executions;
  final List<SavingsDcaProductDraft> products;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsDcaPlanDraft {
  const SavingsDcaPlanDraft({
    required this.id,
    required this.productName,
    required this.asset,
    required this.assetLabel,
    required this.amountPerPeriodLabel,
    required this.frequencyLabel,
    required this.status,
    required this.statusLabel,
    required this.totalInvestedLabel,
    required this.currentValueLabel,
    required this.gainLabel,
    required this.gainPositive,
    required this.nextExecution,
    required this.currentApyLabel,
  });

  final String id;
  final String productName;
  final String asset;
  final String assetLabel;
  final String amountPerPeriodLabel;
  final String frequencyLabel;
  final SavingsDcaPlanStatus status;
  final String statusLabel;
  final String totalInvestedLabel;
  final String currentValueLabel;
  final String gainLabel;
  final bool gainPositive;
  final String nextExecution;
  final String currentApyLabel;
}

final class SavingsDcaExecutionDraft {
  const SavingsDcaExecutionDraft({
    required this.id,
    required this.planName,
    required this.date,
    required this.amountLabel,
    required this.asset,
    required this.status,
    required this.apyLabel,
  });

  final String id;
  final String planName;
  final String date;
  final String amountLabel;
  final String asset;
  final SavingsDcaExecutionStatus status;
  final String apyLabel;
}

final class SavingsDcaProductDraft {
  const SavingsDcaProductDraft({
    required this.id,
    required this.name,
    required this.asset,
    required this.apyLabel,
    required this.balanceLabel,
  });

  final String id;
  final String name;
  final String asset;
  final String apyLabel;
  final String balanceLabel;
}

final class SavingsSmartSuggestionsSnapshot {
  const SavingsSmartSuggestionsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.filters,
    required this.heroLabel,
    required this.pendingCount,
    required this.potentialApyGainLabel,
    required this.highPriorityCount,
    required this.upTrendCount,
    required this.signalCount,
    required this.suggestions,
    required this.trends,
    required this.signals,
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
  final List<SavingsPreferenceTabDraft> filters;
  final String heroLabel;
  final int pendingCount;
  final String potentialApyGainLabel;
  final int highPriorityCount;
  final int upTrendCount;
  final int signalCount;
  final List<SavingsSuggestionDraft> suggestions;
  final List<SavingsApyTrendDraft> trends;
  final List<SavingsMarketSignalDraft> signals;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsSuggestionDraft {
  const SavingsSuggestionDraft({
    required this.id,
    required this.type,
    required this.typeLabel,
    required this.priority,
    required this.priorityLabel,
    required this.status,
    required this.title,
    required this.description,
    required this.reasoning,
    required this.impact,
    required this.impactPositive,
    required this.actionLabel,
    required this.confidence,
    required this.createdAt,
    required this.tags,
    this.actionRoute,
    this.expiresAt,
  });

  final String id;
  final SavingsSuggestionType type;
  final String typeLabel;
  final SavingsSuggestionPriority priority;
  final String priorityLabel;
  final SavingsSuggestionStatus status;
  final String title;
  final String description;
  final String reasoning;
  final String impact;
  final bool impactPositive;
  final String actionLabel;
  final String? actionRoute;
  final int confidence;
  final String createdAt;
  final String? expiresAt;
  final List<String> tags;
}

final class SavingsApyTrendDraft {
  const SavingsApyTrendDraft({
    required this.product,
    required this.asset,
    required this.currentApyLabel,
    required this.averageApyLabel,
    required this.predictionLabel,
    required this.direction,
    required this.points,
  });

  final String product;
  final String asset;
  final String currentApyLabel;
  final String averageApyLabel;
  final String predictionLabel;
  final SavingsApyTrendDirection direction;
  final List<SavingsApyTrendPointDraft> points;
}

final class SavingsApyTrendPointDraft {
  const SavingsApyTrendPointDraft({required this.date, required this.apy});

  final String date;
  final double apy;
}

final class SavingsMarketSignalDraft {
  const SavingsMarketSignalDraft({
    required this.id,
    required this.title,
    required this.type,
    required this.impact,
    required this.affectedProducts,
    required this.timestamp,
  });

  final String id;
  final String title;
  final SavingsMarketSignalType type;
  final String impact;
  final List<String> affectedProducts;
  final String timestamp;
}

final class SavingsExportSnapshot {
  const SavingsExportSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.heroLabel,
    required this.createdReports,
    required this.reportTypeCountLabel,
    required this.formatSummary,
    required this.retentionLabel,
    required this.reportTypes,
    required this.formats,
    required this.periods,
    required this.scopes,
    required this.options,
    required this.defaultReportType,
    required this.defaultFormat,
    required this.defaultPeriod,
    required this.defaultScope,
    required this.defaultEnabledOptions,
    required this.summaryRows,
    required this.summaryFileSize,
    required this.sensitiveNotice,
    required this.ctaLabel,
    required this.history,
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
  final int createdReports;
  final String reportTypeCountLabel;
  final String formatSummary;
  final String retentionLabel;
  final List<SavingsExportReportDraft> reportTypes;
  final List<SavingsExportFormatDraft> formats;
  final List<SavingsExportPeriodDraft> periods;
  final List<SavingsExportScopeDraft> scopes;
  final List<SavingsExportOptionDraft> options;
  final SavingsExportReportType defaultReportType;
  final SavingsExportFormat defaultFormat;
  final SavingsExportPeriod defaultPeriod;
  final SavingsExportScope defaultScope;
  final Set<String> defaultEnabledOptions;
  final String summaryRows;
  final String summaryFileSize;
  final String sensitiveNotice;
  final String ctaLabel;
  final List<SavingsExportHistoryDraft> history;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}
