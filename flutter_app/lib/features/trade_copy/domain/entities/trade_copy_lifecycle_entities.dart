part of 'trade_copy_entities.dart';

/// Risk tier of a copy-trading provider: low, medium, or high.
enum TradeCopyRiskLevel { low, medium, high }

/// Read-model for the Copy Trading discovery screen (available traders,
/// aggregate AUM, risk warning/disclaimer copy).
final class TradeCopyTradingSnapshot {
  const TradeCopyTradingSnapshot({
    required this.trade,
    required this.traders,
    required this.sortOptions,
    required this.totalCopiers,
    required this.totalAum,
    required this.aumTrendPct,
    required this.riskWarningTitle,
    required this.riskWarningText,
    required this.disclaimer,
    required this.supportedStates,
    required this.lastUpdatedLabel,
    this.highRiskContractId,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyTrader> traders;
  final List<String> sortOptions;
  final int totalCopiers;
  final double totalAum;
  final double aumTrendPct;
  final String riskWarningTitle;
  final String riskWarningText;
  final String disclaimer;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
  final String? highRiskContractId;
}

/// Compliance verdict for a copy-trading card variant: pass, warn, or
/// fail.
enum TradeCopyCardCompliance { pass, warn, fail }

/// Read-model for the internal Copy Card design-review demo screen
/// (metrics, variants, compliance issues, recommendation).
final class TradeCopyCardDemoSnapshot {
  const TradeCopyCardDemoSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.backRoute,
    required this.metrics,
    required this.improvements,
    required this.variants,
    required this.issues,
    required this.originalIssues,
    required this.recommendation,
    required this.recommendationReasons,
    required this.guidelines,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
  final String title;
  final String backRoute;
  final TradeCopyCardMetrics metrics;
  final List<String> improvements;
  final List<TradeCopyCardVariantDraft> variants;
  final List<TradeCopyCardIssue> issues;
  final List<TradeCopyCardTextBlock> originalIssues;
  final String recommendation;
  final List<String> recommendationReasons;
  final List<TradeCopyCardTextBlock> guidelines;
  final String contractNotes;
}

/// Aggregate trader/copier/AUM metrics shown on the copy card demo
/// screen.
final class TradeCopyCardMetrics {
  const TradeCopyCardMetrics({
    required this.traders,
    required this.copiers,
    required this.aumUsd,
    required this.aumTrendPercent,
    required this.lastUpdated,
  });

  final int traders;
  final int copiers;
  final int aumUsd;
  final double aumTrendPercent;
  final String lastUpdated;
}

/// A single candidate copy-card design variant under review.
final class TradeCopyCardVariantDraft {
  const TradeCopyCardVariantDraft({
    required this.id,
    required this.title,
    required this.badge,
    required this.notesTitle,
    required this.notes,
  });

  final String id;
  final String title;
  final String? badge;
  final String notesTitle;
  final List<String> notes;
}

/// A single compliance issue compared across the original design and its
/// candidate variants.
final class TradeCopyCardIssue {
  const TradeCopyCardIssue({
    required this.category,
    required this.description,
    required this.original,
    required this.variantA,
    required this.variantB,
    required this.variantC,
  });

  final String category;
  final String description;
  final TradeCopyCardCompliance original;
  final TradeCopyCardCompliance variantA;
  final TradeCopyCardCompliance variantB;
  final TradeCopyCardCompliance variantC;
}

/// A titled block of body text used in the copy card demo's notes/
/// guidelines sections.
final class TradeCopyCardTextBlock {
  const TradeCopyCardTextBlock({required this.title, required this.body});

  final String title;
  final String body;
}

/// Read-model for the Copy Trading Education screen (intro, step-by-step
/// guide, copy-mode explainers, concept glossary).
final class TradeCopyEducationSnapshot {
  const TradeCopyEducationSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTab,
    required this.introTitle,
    required this.introDescription,
    required this.steps,
    required this.copyModes,
    required this.concepts,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyEducationTab> tabs;
  final String defaultTab;
  final String introTitle;
  final String introDescription;
  final List<TradeCopyEducationStep> steps;
  final List<TradeCopyModeGuide> copyModes;
  final List<TradeCopyConceptGuide> concepts;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

/// A selectable tab on the Copy Trading Education screen.
final class TradeCopyEducationTab {
  const TradeCopyEducationTab({required this.id, required this.label});

  final String id;
  final String label;
}

/// A single numbered step in the "how copy trading works" walkthrough.
final class TradeCopyEducationStep {
  const TradeCopyEducationStep({
    required this.number,
    required this.iconName,
    required this.title,
    required this.description,
  });

  final int number;
  final String iconName;
  final String title;
  final String description;
}

/// An explainer for one copy mode (pros/cons) shown on the education
/// screen.
final class TradeCopyModeGuide {
  const TradeCopyModeGuide({
    required this.title,
    required this.description,
    required this.pro,
    required this.con,
    required this.colorHex,
  });

  final String title;
  final String description;
  final String pro;
  final String con;
  final int colorHex;
}

/// A single glossary entry (term + definition) on the education screen.
final class TradeCopyConceptGuide {
  const TradeCopyConceptGuide({
    required this.term,
    required this.description,
    required this.iconName,
  });

  final String term;
  final String description;
  final String iconName;
}

/// Lifecycle status of an active copy subscription: active, cooling off,
/// paused, or stopped.
enum TradeActiveCopyStatus { active, coolingOff, paused, stopped }

/// Copy mode of an active copy subscription: mirror, fixed, or smart.
enum TradeActiveCopyMode { mirror, fixed, smart }

/// Default copy mode configured in copy settings: mirror, fixed, or
/// smart.
enum TradeCopySettingsMode { mirror, fixed, smart }

/// Read-model for the Active Copies screen (portfolio summary, tabs,
/// individual active copy subscriptions).
final class TradeActiveCopiesSnapshot {
  const TradeActiveCopiesSnapshot({
    required this.trade,
    required this.portfolio,
    required this.tabs,
    required this.defaultTab,
    required this.copies,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeActiveCopyPortfolio portfolio;
  final List<TradeActiveCopiesTab> tabs;
  final String defaultTab;
  final List<TradeActiveCopy> copies;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

/// Aggregate capital/value/PnL summary across all active copy
/// subscriptions.
final class TradeActiveCopyPortfolio {
  const TradeActiveCopyPortfolio({
    required this.totalCapital,
    required this.totalValue,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.activeCopies,
    required this.totalCopies,
  });

  final double totalCapital;
  final double totalValue;
  final double totalPnl;
  final double totalPnlPct;
  final int activeCopies;
  final int totalCopies;
}

/// A selectable filter tab on the Active Copies screen, with an optional
/// count badge.
final class TradeActiveCopiesTab {
  const TradeActiveCopiesTab({
    required this.id,
    required this.label,
    this.badge,
  });

  final String id;
  final String label;
  final int? badge;
}

/// A single active copy-trading subscription (provider, capital, PnL,
/// status, recent trades, performance history).
final class TradeActiveCopy {
  const TradeActiveCopy({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.providerAvatar,
    required this.providerVerified,
    required this.capital,
    required this.currentValue,
    required this.pnl,
    required this.pnlPct,
    required this.status,
    required this.startDate,
    required this.copyMode,
    required this.trades,
    required this.winRate,
    required this.hasCustomStopLoss,
    required this.recentTrades,
    required this.performanceHistory,
    this.copyRatio,
    this.stopLossLevel,
    this.coolingOffUntil,
  });

  final String id;
  final String providerId;
  final String providerName;
  final String providerAvatar;
  final bool providerVerified;
  final double capital;
  final double currentValue;
  final double pnl;
  final double pnlPct;
  final TradeActiveCopyStatus status;
  final String startDate;
  final TradeActiveCopyMode copyMode;
  final double? copyRatio;
  final int trades;
  final double winRate;
  final bool hasCustomStopLoss;
  final double? stopLossLevel;
  final String? coolingOffUntil;
  final List<TradeCopyRecentTrade> recentTrades;
  final List<TradeCopyPerformancePoint> performanceHistory;
}

/// A single recent trade executed within an active copy subscription.
final class TradeCopyRecentTrade {
  const TradeCopyRecentTrade({
    required this.id,
    required this.pair,
    required this.side,
    required this.size,
    required this.price,
    required this.pnl,
    required this.timestamp,
  });

  final String id;
  final String pair;
  final TradeOrderSide side;
  final double size;
  final double price;
  final double pnl;
  final String timestamp;
}

/// One timestamped equity value on an active copy's performance history
/// chart.
final class TradeCopyPerformancePoint {
  const TradeCopyPerformancePoint({
    required this.timestamp,
    required this.value,
  });

  final String timestamp;
  final double value;
}

/// Read-model for the Copy Trading Settings screen.
final class TradeCopySettingsSnapshot {
  const TradeCopySettingsSnapshot({
    required this.trade,
    required this.settings,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeCopySettings settings;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

/// User's global copy-trading preferences (defaults, portfolio limits,
/// circuit breaker, notifications, emergency contact).
final class TradeCopySettings {
  const TradeCopySettings({
    required this.defaultCopyMode,
    required this.defaultCopyRatio,
    required this.defaultStopLoss,
    required this.defaultTakeProfit,
    required this.maxPortfolioAllocation,
    required this.maxCopiesActive,
    required this.enableCircuitBreaker,
    required this.circuitBreakerThreshold,
    required this.notifyNewTrades,
    required this.notifyPnlChanges,
    required this.notifyRiskAlerts,
    required this.notifyProviderUpdates,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.emergencyContact,
    required this.emergencyPhone,
    required this.showPortfolioPublic,
  });

  final TradeCopySettingsMode defaultCopyMode;
  final double defaultCopyRatio;
  final double defaultStopLoss;
  final double defaultTakeProfit;
  final double maxPortfolioAllocation;
  final int maxCopiesActive;
  final bool enableCircuitBreaker;
  final double circuitBreakerThreshold;
  final bool notifyNewTrades;
  final bool notifyPnlChanges;
  final bool notifyRiskAlerts;
  final bool notifyProviderUpdates;
  final bool emailNotifications;
  final bool pushNotifications;
  final String emergencyContact;
  final String emergencyPhone;
  final bool showPortfolioPublic;

  TradeCopySettings copyWith({
    TradeCopySettingsMode? defaultCopyMode,
    double? defaultCopyRatio,
    double? defaultStopLoss,
    double? defaultTakeProfit,
    double? maxPortfolioAllocation,
    int? maxCopiesActive,
    bool? enableCircuitBreaker,
    double? circuitBreakerThreshold,
    bool? notifyNewTrades,
    bool? notifyPnlChanges,
    bool? notifyRiskAlerts,
    bool? notifyProviderUpdates,
    bool? emailNotifications,
    bool? pushNotifications,
    String? emergencyContact,
    String? emergencyPhone,
    bool? showPortfolioPublic,
  }) {
    return TradeCopySettings(
      defaultCopyMode: defaultCopyMode ?? this.defaultCopyMode,
      defaultCopyRatio: defaultCopyRatio ?? this.defaultCopyRatio,
      defaultStopLoss: defaultStopLoss ?? this.defaultStopLoss,
      defaultTakeProfit: defaultTakeProfit ?? this.defaultTakeProfit,
      maxPortfolioAllocation:
          maxPortfolioAllocation ?? this.maxPortfolioAllocation,
      maxCopiesActive: maxCopiesActive ?? this.maxCopiesActive,
      enableCircuitBreaker: enableCircuitBreaker ?? this.enableCircuitBreaker,
      circuitBreakerThreshold:
          circuitBreakerThreshold ?? this.circuitBreakerThreshold,
      notifyNewTrades: notifyNewTrades ?? this.notifyNewTrades,
      notifyPnlChanges: notifyPnlChanges ?? this.notifyPnlChanges,
      notifyRiskAlerts: notifyRiskAlerts ?? this.notifyRiskAlerts,
      notifyProviderUpdates:
          notifyProviderUpdates ?? this.notifyProviderUpdates,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      showPortfolioPublic: showPortfolioPublic ?? this.showPortfolioPublic,
    );
  }
}

/// Result of saving updated copy-trading settings.
final class TradeCopySettingsSaveResult {
  const TradeCopySettingsSaveResult({
    required this.status,
    required this.settings,
  });

  final String status;
  final TradeCopySettings settings;
}

/// Category of a copy-trading notification: trade, risk, update, or
/// system.
enum TradeCopyNotificationType { trade, risk, update, system }

/// Severity of a copy-trading notification: info, warning, or critical.
enum TradeCopyNotificationSeverity { info, warning, critical }

/// Read-model for the Copy Trading Notifications screen.
final class TradeCopyNotificationsSnapshot {
  const TradeCopyNotificationsSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTab,
    required this.notifications,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyNotificationTab> tabs;
  final String defaultTab;
  final List<TradeCopyNotification> notifications;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

/// A selectable filter tab on the Copy Trading Notifications screen, with
/// an optional unread-count badge.
final class TradeCopyNotificationTab {
  const TradeCopyNotificationTab({
    required this.id,
    required this.label,
    this.badge,
  });

  final String id;
  final String label;
  final int? badge;
}

/// A single copy-trading notification (type, severity, optional linked
/// provider/copy/trade context).
final class TradeCopyNotification {
  const TradeCopyNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
    required this.severity,
    this.providerId,
    this.providerName,
    this.copyId,
    this.actionPath,
    this.pnl,
    this.pair,
    this.side,
  });

  final String id;
  final TradeCopyNotificationType type;
  final String title;
  final String message;
  final String timestamp;
  final bool read;
  final TradeCopyNotificationSeverity severity;
  final String? providerId;
  final String? providerName;
  final String? copyId;
  final String? actionPath;
  final double? pnl;
  final String? pair;
  final TradeOrderSide? side;

  TradeCopyNotification copyWith({bool? read}) {
    return TradeCopyNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      timestamp: timestamp,
      read: read ?? this.read,
      severity: severity,
      providerId: providerId,
      providerName: providerName,
      copyId: copyId,
      actionPath: actionPath,
      pnl: pnl,
      pair: pair,
      side: side,
    );
  }
}

/// A single stress-test scenario (name, impact, probability) used in
/// portfolio risk analysis.
final class TradeStressScenario {
  const TradeStressScenario({
    required this.name,
    required this.impact,
    required this.probability,
    required this.colorHex,
  });

  final String name;
  final double impact;
  final int probability;
  final int colorHex;
}

/// Read-model for the Copy Trading Safety Education screen (scam types,
/// red flags, verification tiers, report reasons).
final class TradeSafetyEducationSnapshot {
  const TradeSafetyEducationSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.scams,
    required this.redFlags,
    required this.verificationTiers,
    required this.reportReasons,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeSafetyTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final List<TradeSafetyScamType> scams;
  final List<TradeSafetyRedFlag> redFlags;
  final List<TradeSafetyVerificationTier> verificationTiers;
  final List<String> reportReasons;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

/// A selectable tab on the Safety Education screen.
final class TradeSafetyTab {
  const TradeSafetyTab({required this.id, required this.label});

  final String id;
  final String label;
}

/// A single documented scam pattern (examples, how to avoid).
final class TradeSafetyScamType {
  const TradeSafetyScamType({
    required this.id,
    required this.title,
    required this.description,
    required this.examples,
    required this.howToAvoid,
  });

  final String id;
  final String title;
  final String description;
  final List<String> examples;
  final List<String> howToAvoid;
}

/// A single documented red-flag warning sign to watch for in a provider.
final class TradeSafetyRedFlag {
  const TradeSafetyRedFlag({
    required this.id,
    required this.category,
    required this.flag,
    required this.severity,
    required this.explanation,
  });

  final String id;
  final String category;
  final String flag;
  final String severity;
  final String explanation;
}

/// A single provider verification tier and its requirements.
final class TradeSafetyVerificationTier {
  const TradeSafetyVerificationTier({
    required this.tier,
    required this.colorHex,
    required this.requirements,
  });

  final String tier;
  final int colorHex;
  final List<String> requirements;
}

/// Read-model for the Dispute Resolution screen (complaint types,
/// providers, active/resolved dispute cases).
final class TradeDisputeResolutionSnapshot {
  const TradeDisputeResolutionSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.noticeTitle,
    required this.noticeBody,
    required this.complaintTypes,
    required this.providers,
    required this.activeCases,
    required this.resolvedCases,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeDisputeTab> tabs;
  final String defaultTabId;
  final String noticeTitle;
  final String noticeBody;
  final List<TradeComplaintTypeOption> complaintTypes;
  final List<TradeDisputeProviderOption> providers;
  final List<TradeDisputeCase> activeCases;
  final List<TradeDisputeCase> resolvedCases;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

/// A selectable tab on the Dispute Resolution screen, with an optional
/// count badge.
final class TradeDisputeTab {
  const TradeDisputeTab({
    required this.id,
    required this.label,
    this.badgeCount,
  });

  final String id;
  final String label;
  final int? badgeCount;
}

/// A selectable complaint type option on the dispute submission form.
final class TradeComplaintTypeOption {
  const TradeComplaintTypeOption({
    required this.value,
    required this.label,
    required this.description,
  });

  final String value;
  final String label;
  final String description;
}

/// A selectable provider option on the dispute submission form.
final class TradeDisputeProviderOption {
  const TradeDisputeProviderOption({required this.id, required this.name});

  final String id;
  final String name;
}

/// A single filed dispute case against a copy-trading provider.
final class TradeDisputeCase {
  const TradeDisputeCase({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.complaintType,
    required this.subject,
    required this.description,
    required this.status,
    required this.submittedDate,
    required this.updatedDate,
    required this.estimatedResolution,
    this.outcome,
  });

  final String id;
  final String providerId;
  final String providerName;
  final String complaintType;
  final String subject;
  final String description;
  final String status;
  final String submittedDate;
  final String updatedDate;
  final String estimatedResolution;
  final String? outcome;
}

/// Mutable draft form state for filing a new dispute complaint.
final class TradeDisputeComplaintDraft {
  const TradeDisputeComplaintDraft({
    required this.complaintType,
    required this.providerId,
    required this.subject,
    required this.description,
    this.evidenceNames = const [],
  });

  final String complaintType;
  final String providerId;
  final String subject;
  final String description;
  final List<String> evidenceNames;
}

/// Result of submitting a dispute complaint.
final class TradeDisputeSubmissionResult {
  const TradeDisputeSubmissionResult({
    required this.caseId,
    required this.status,
    required this.message,
  });

  final String caseId;
  final String status;
  final String message;
}

/// Read-model for the Copy Trading Safety Center screen (verification
/// tiers, trust metrics, prohibited behaviors, reporting, safety tools).
final class TradeCopySafetyCenterSnapshot {
  const TradeCopySafetyCenterSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.verificationIntro,
    required this.verificationTiers,
    required this.trustMetrics,
    required this.prohibitedBehaviors,
    required this.followerResponsibilities,
    required this.reportingSteps,
    required this.safetyTools,
    required this.enforcementActions,
    required this.warningText,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopySafetyCenterTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final String verificationIntro;
  final List<TradeCopyVerificationTier> verificationTiers;
  final List<TradeCopyTrustMetric> trustMetrics;
  final List<String> prohibitedBehaviors;
  final List<String> followerResponsibilities;
  final List<TradeCopyReportingStep> reportingSteps;
  final List<TradeCopySafetyTool> safetyTools;
  final List<TradeCopyEnforcementAction> enforcementActions;
  final String warningText;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

/// A selectable tab on the Copy Trading Safety Center screen.
final class TradeCopySafetyCenterTab {
  const TradeCopySafetyCenterTab({required this.id, required this.label});

  final String id;
  final String label;
}

/// A single provider verification tier's requirements and benefits.
final class TradeCopyVerificationTier {
  const TradeCopyVerificationTier({
    required this.tier,
    required this.requirements,
    required this.benefits,
    required this.colorHex,
  });

  final String tier;
  final List<String> requirements;
  final List<String> benefits;
  final int colorHex;
}

/// A single trust metric explainer (what it measures, good/bad ranges,
/// why it matters).
final class TradeCopyTrustMetric {
  const TradeCopyTrustMetric({
    required this.name,
    required this.description,
    required this.goodRange,
    required this.badRange,
    required this.whyMatters,
  });

  final String name;
  final String description;
  final String goodRange;
  final String badRange;
  final String whyMatters;
}

/// A single numbered step in the "how to report a provider" flow.
final class TradeCopyReportingStep {
  const TradeCopyReportingStep({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

/// A single safety tool (e.g. circuit breaker) linked from the Safety
/// Center screen.
final class TradeCopySafetyTool {
  const TradeCopySafetyTool({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    this.routePath,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String? routePath;
}

/// A single historical enforcement action taken against a provider.
final class TradeCopyEnforcementAction {
  const TradeCopyEnforcementAction({
    required this.id,
    required this.date,
    required this.providerName,
    required this.action,
    required this.reason,
  });

  final String id;
  final String date;
  final String providerName;
  final String action;
  final String reason;
}

/// Request to run a provider-level action (e.g. report, block).
final class TradeCopyActionRequest {
  const TradeCopyActionRequest({
    required this.providerId,
    required this.action,
  });

  final String providerId;
  final String action;
}

/// Result of a provider-level action.
final class TradeCopyActionResult {
  const TradeCopyActionResult({
    required this.providerId,
    required this.action,
    required this.status,
  });

  final String providerId;
  final String action;
  final String status;
}
