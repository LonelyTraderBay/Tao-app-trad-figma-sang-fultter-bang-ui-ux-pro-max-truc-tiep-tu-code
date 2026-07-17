part of 'trade_copy_entities.dart';

/// How a copy-trading position is sized against the provider's trades:
/// mirror, fixed amount, or smart (risk-adjusted).
enum TradeCopyConfigurationMode { mirror, fixed, smart }

/// Method used to size each copied position: percentage of capital, fixed
/// amount, or risk-based.
enum TradePositionSizingMethod { percentage, fixedAmount, riskBased }

/// Severity of a copy-configuration validation message: error, warning,
/// or info.
enum TradeCopyConfigurationValidationLevel { error, warning, info }

/// Read-model for the Copy Configuration screen (provider, default draft,
/// portfolio allocation, fee preview, validations).
final class TradeCopyConfigurationSnapshot {
  const TradeCopyConfigurationSnapshot({
    required this.providerId,
    required this.provider,
    required this.defaultDraft,
    required this.totalPortfolio,
    required this.currentCopyAllocation,
    required this.availableCapital,
    required this.feePreview,
    required this.validations,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final TradeCopyConfigurationDraft defaultDraft;
  final double totalPortfolio;
  final double currentCopyAllocation;
  final double availableCapital;
  final TradeCopyConfigurationFeePreview feePreview;
  final List<TradeCopyConfigurationValidation> validations;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

/// Mutable draft form state for configuring a new copy-trading
/// subscription (capital, mode, sizing, TP/SL/trailing stop overrides)
/// before preview/submission.
final class TradeCopyConfigurationDraft {
  const TradeCopyConfigurationDraft({
    required this.providerId,
    required this.copyCapital,
    required this.copyMode,
    required this.positionSizing,
    required this.copyRatio,
    required this.useCustomStopLoss,
    required this.customStopLoss,
    required this.useCustomTakeProfit,
    required this.customTakeProfit,
    required this.useTrailingStop,
    required this.trailingStopPercent,
  });

  final String providerId;
  final double copyCapital;
  final TradeCopyConfigurationMode copyMode;
  final TradePositionSizingMethod positionSizing;
  final double copyRatio;
  final bool useCustomStopLoss;
  final double customStopLoss;
  final bool useCustomTakeProfit;
  final double customTakeProfit;
  final bool useTrailingStop;
  final double trailingStopPercent;

  TradeCopyConfigurationDraft copyWith({
    double? copyCapital,
    TradeCopyConfigurationMode? copyMode,
    TradePositionSizingMethod? positionSizing,
    double? copyRatio,
    bool? useCustomStopLoss,
    double? customStopLoss,
    bool? useCustomTakeProfit,
    double? customTakeProfit,
    bool? useTrailingStop,
    double? trailingStopPercent,
  }) {
    return TradeCopyConfigurationDraft(
      providerId: providerId,
      copyCapital: copyCapital ?? this.copyCapital,
      copyMode: copyMode ?? this.copyMode,
      positionSizing: positionSizing ?? this.positionSizing,
      copyRatio: copyRatio ?? this.copyRatio,
      useCustomStopLoss: useCustomStopLoss ?? this.useCustomStopLoss,
      customStopLoss: customStopLoss ?? this.customStopLoss,
      useCustomTakeProfit: useCustomTakeProfit ?? this.useCustomTakeProfit,
      customTakeProfit: customTakeProfit ?? this.customTakeProfit,
      useTrailingStop: useTrailingStop ?? this.useTrailingStop,
      trailingStopPercent: trailingStopPercent ?? this.trailingStopPercent,
    );
  }
}

/// Computed fee preview (platform fee, estimated trading fees,
/// performance-fee note) for a copy configuration draft — financial
/// write path, see ADR-001.
final class TradeCopyConfigurationFeePreview {
  const TradeCopyConfigurationFeePreview({
    required this.platformFee,
    required this.estimatedTradingFees,
    required this.performanceFeeNote,
  });

  final double platformFee;
  final double estimatedTradingFees;
  final String performanceFeeNote;

  double get totalFixedFees => platformFee + estimatedTradingFees;
}

/// A single validation message (severity + text) surfaced while editing
/// a copy configuration draft.
final class TradeCopyConfigurationValidation {
  const TradeCopyConfigurationValidation({
    required this.level,
    required this.message,
  });

  final TradeCopyConfigurationValidationLevel level;
  final String message;
}

/// Computed preview (status, draft, fees, validations) for a copy
/// configuration before the user proceeds to confirmation.
final class TradeCopyConfigurationPreview {
  const TradeCopyConfigurationPreview({
    required this.providerId,
    required this.status,
    required this.draft,
    required this.feePreview,
    required this.validations,
  });

  final String providerId;
  final String status;
  final TradeCopyConfigurationDraft draft;
  final TradeCopyConfigurationFeePreview feePreview;
  final List<TradeCopyConfigurationValidation> validations;

  bool get hasBlockingErrors => validations.any(
    (item) => item.level == TradeCopyConfigurationValidationLevel.error,
  );
}

/// Read-model for the Copy Confirmation screen (final config, fee
/// preview, projected scenarios, required consents, cooling-off period).
final class TradeCopyConfirmationSnapshot {
  const TradeCopyConfirmationSnapshot({
    required this.providerId,
    required this.provider,
    required this.configuration,
    required this.feePreview,
    required this.scenarios,
    required this.maxLossAmount,
    required this.consentItems,
    required this.coolingOffHours,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final TradeCopyConfigurationDraft configuration;
  final TradeCopyConfigurationFeePreview feePreview;
  final List<TradeCopyScenarioProjection> scenarios;
  final double maxLossAmount;
  final List<TradeCopyConsentItem> consentItems;
  final int coolingOffHours;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

/// One projected outcome scenario (return %, gross/net PnL, fees,
/// slippage) shown on the copy confirmation screen.
final class TradeCopyScenarioProjection {
  const TradeCopyScenarioProjection({
    required this.id,
    required this.title,
    required this.returnPct,
    required this.grossPnl,
    required this.performanceFee,
    required this.slippageLoss,
    required this.fixedFees,
    required this.netPnl,
    required this.netReturnPct,
  });

  final String id;
  final String title;
  final double returnPct;
  final double grossPnl;
  final double performanceFee;
  final double slippageLoss;
  final double fixedFees;
  final double netPnl;
  final double netReturnPct;
}

/// A single required/optional consent checkbox item on the copy
/// confirmation screen.
final class TradeCopyConsentItem {
  const TradeCopyConsentItem({
    required this.id,
    required this.label,
    required this.required,
  });

  final String id;
  final String label;
  final bool required;
}

/// Request to confirm and start a copy-trading subscription — financial
/// write path, see ADR-001.
final class TradeCopyConfirmationRequest {
  const TradeCopyConfirmationRequest({
    required this.providerId,
    required this.configuration,
    required this.acceptedConsentIds,
  });

  final String providerId;
  final TradeCopyConfigurationDraft configuration;
  final List<String> acceptedConsentIds;
}

/// Result of confirming a copy-trading subscription, including audit
/// trail id and cooling-off period.
final class TradeCopyConfirmationResult {
  const TradeCopyConfirmationResult({
    required this.providerId,
    required this.status,
    required this.auditTrailId,
    required this.coolingOffHours,
    required this.activeCopiesPath,
  });

  final String providerId;
  final String status;
  final String auditTrailId;
  final int coolingOffHours;
  final String activeCopiesPath;
}

/// Read-model for the Copy Performance screen (your return vs. provider's,
/// equity curve, slippage/cost breakdown, trade-by-trade comparison).
final class TradeCopyPerformanceSnapshot {
  const TradeCopyPerformanceSnapshot({
    required this.copyId,
    required this.initialCapital,
    required this.yourReturnPct,
    required this.providerReturnPct,
    required this.yourCurrentValue,
    required this.providerTheoreticalValue,
    required this.performanceGapPct,
    required this.avgSlippagePct,
    required this.providerAvgSlippagePct,
    required this.totalCosts,
    required this.equityCurve,
    required this.slippageBuckets,
    required this.costAttribution,
    required this.tradeComparisons,
    required this.metrics,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String copyId;
  final double initialCapital;
  final double yourReturnPct;
  final double providerReturnPct;
  final double yourCurrentValue;
  final double providerTheoreticalValue;
  final double performanceGapPct;
  final double avgSlippagePct;
  final double providerAvgSlippagePct;
  final double totalCosts;
  final List<TradeCopyEquityPoint> equityCurve;
  final List<TradeCopySlippageBucket> slippageBuckets;
  final List<TradeCopyCostAttribution> costAttribution;
  final List<TradeCopyTradeComparison> tradeComparisons;
  final List<TradeCopyMetricComparison> metrics;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

/// One day's equity value for you vs. the provider.
final class TradeCopyEquityPoint {
  const TradeCopyEquityPoint({
    required this.day,
    required this.you,
    required this.provider,
  });

  final int day;
  final double you;
  final double provider;
}

/// A histogram bucket of copy-execution slippage, split you vs. provider.
final class TradeCopySlippageBucket {
  const TradeCopySlippageBucket({
    required this.range,
    required this.youPct,
    required this.providerPct,
  });

  final String range;
  final double youPct;
  final double providerPct;
}

/// A single labelled slice of the copy-trading cost attribution chart.
final class TradeCopyCostAttribution {
  const TradeCopyCostAttribution({
    required this.name,
    required this.value,
    required this.colorHex,
  });

  final String name;
  final double value;
  final int colorHex;
}

/// A single trade-by-trade comparison between the provider's execution
/// and yours (entry/exit, PnL, slippage, delay).
final class TradeCopyTradeComparison {
  const TradeCopyTradeComparison({
    required this.id,
    required this.pair,
    required this.side,
    required this.providerEntry,
    required this.yourEntry,
    required this.providerExit,
    required this.yourExit,
    required this.providerPnl,
    required this.yourPnl,
    required this.slippagePct,
    required this.delay,
    required this.timestamp,
  });

  final String id;
  final String pair;
  final TradeOrderSide side;
  final double providerEntry;
  final double yourEntry;
  final double providerExit;
  final double yourExit;
  final double providerPnl;
  final double yourPnl;
  final double slippagePct;
  final String delay;
  final String timestamp;
}

/// A single named metric compared between you and the provider (e.g.
/// win rate, Sharpe).
final class TradeCopyMetricComparison {
  const TradeCopyMetricComparison({
    required this.name,
    required this.you,
    required this.provider,
    required this.higherIsBetter,
    this.suffix = '',
  });

  final String name;
  final double you;
  final double provider;
  final bool higherIsBetter;
  final String suffix;
}

/// Read-model for the Performance Attribution screen (alpha/beta,
/// return/drawdown series, Monte Carlo projections, correlation).
final class TradePerformanceAttributionSnapshot {
  const TradePerformanceAttributionSnapshot({
    required this.copyId,
    required this.totalReturnPct,
    required this.alphaPct,
    required this.beta,
    required this.rSquared,
    required this.returns,
    required this.drawdowns,
    required this.monteCarloPaths,
    required this.correlationPoints,
    required this.marketContributionPct,
    required this.skillContributionPct,
    required this.maxDrawdownPct,
    required this.avgDrawdownPct,
    required this.medianProjection,
    required this.worstProjection,
    required this.bestProjection,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String copyId;
  final double totalReturnPct;
  final double alphaPct;
  final double beta;
  final double rSquared;
  final List<TradePerformanceReturnPoint> returns;
  final List<TradePerformanceDrawdownPoint> drawdowns;
  final List<List<TradePerformanceProjectionPoint>> monteCarloPaths;
  final List<TradePerformanceCorrelationPoint> correlationPoints;
  final double marketContributionPct;
  final double skillContributionPct;
  final double maxDrawdownPct;
  final double avgDrawdownPct;
  final double medianProjection;
  final double worstProjection;
  final double bestProjection;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

/// One day's market vs. alpha return contribution, with derived total.
final class TradePerformanceReturnPoint {
  const TradePerformanceReturnPoint({
    required this.day,
    required this.market,
    required this.alpha,
  });

  final int day;
  final double market;
  final double alpha;

  double get total => market + alpha;
}

/// One day's drawdown value on the performance attribution chart.
final class TradePerformanceDrawdownPoint {
  const TradePerformanceDrawdownPoint({
    required this.day,
    required this.drawdown,
  });

  final int day;
  final double drawdown;
}

/// One day's simulated value along a single Monte Carlo projection path.
final class TradePerformanceProjectionPoint {
  const TradePerformanceProjectionPoint({
    required this.day,
    required this.value,
  });

  final int day;
  final double value;
}

/// One day's market return vs. your return, used for correlation
/// analysis.
final class TradePerformanceCorrelationPoint {
  const TradePerformanceCorrelationPoint({
    required this.day,
    required this.marketReturn,
    required this.yourReturn,
  });

  final int day;
  final double marketReturn;
  final double yourReturn;
}

/// Category of a copy-trading audit log event: trade, config, risk, or
/// system.
enum TradeCopyAuditEventType { trade, config, risk, system }

/// Severity of a copy-trading audit log event: info, warning, or
/// critical.
enum TradeCopyAuditSeverity { info, warning, critical }

/// Read-model for the Copy Audit Log screen (filterable event log,
/// export options, retention policy).
final class TradeCopyAuditLogSnapshot {
  const TradeCopyAuditLogSnapshot({
    required this.copyId,
    required this.complianceTitle,
    required this.complianceDescription,
    required this.tabs,
    required this.events,
    required this.exportFormats,
    required this.retentionYears,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String copyId;
  final String complianceTitle;
  final String complianceDescription;
  final List<TradeCopyAuditTab> tabs;
  final List<TradeCopyAuditEvent> events;
  final List<TradeCopyAuditExportFormat> exportFormats;
  final int retentionYears;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

/// A selectable filter tab on the audit log screen, with an event-count
/// badge.
final class TradeCopyAuditTab {
  const TradeCopyAuditTab({
    required this.id,
    required this.label,
    required this.badge,
    this.type,
  });

  final String id;
  final String label;
  final int badge;
  final TradeCopyAuditEventType? type;
}

/// A single copy-trading audit log event.
final class TradeCopyAuditEvent {
  const TradeCopyAuditEvent({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.severity,
    this.metadata,
  });

  final String id;
  final TradeCopyAuditEventType type;
  final String timestamp;
  final String title;
  final String description;
  final TradeCopyAuditSeverity severity;
  final TradeCopyAuditMetadata? metadata;
}

/// Optional structured detail (trade prices, slippage, PnL, or old/new
/// value diff) attached to an audit log event.
final class TradeCopyAuditMetadata {
  const TradeCopyAuditMetadata({
    this.pair,
    this.side,
    this.providerPrice,
    this.yourPrice,
    this.slippagePct,
    this.pnl,
    this.oldValue,
    this.newValue,
  });

  final String? pair;
  final TradeOrderSide? side;
  final double? providerPrice;
  final double? yourPrice;
  final double? slippagePct;
  final double? pnl;
  final String? oldValue;
  final String? newValue;
}

/// A selectable audit-log export format (id, label, description).
final class TradeCopyAuditExportFormat {
  const TradeCopyAuditExportFormat({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

/// Request to export the copy audit log for a given format/filter/search.
final class TradeCopyAuditExportRequest {
  const TradeCopyAuditExportRequest({
    required this.copyId,
    required this.format,
    required this.filterId,
    required this.searchQuery,
  });

  final String copyId;
  final String format;
  final String filterId;
  final String searchQuery;
}

/// Result of exporting the copy audit log.
final class TradeCopyAuditExportResult {
  const TradeCopyAuditExportResult({
    required this.exportId,
    required this.format,
    required this.status,
    required this.downloadUrl,
  });

  final String exportId;
  final String format;
  final String status;
  final String downloadUrl;
}

/// Read-model for the Portfolio Risk Analysis screen (total exposure,
/// VaR, diversification, per-asset exposure, stress scenarios).
final class TradePortfolioRiskAnalysisSnapshot {
  const TradePortfolioRiskAnalysisSnapshot({
    required this.totalExposure,
    required this.var95,
    required this.var99,
    required this.diversificationScore,
    required this.assetExposures,
    required this.riskAlerts,
    required this.tabs,
    required this.scenarios,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final double totalExposure;
  final double var95;
  final double var99;
  final int diversificationScore;
  final List<TradeAssetExposure> assetExposures;
  final List<String> riskAlerts;
  final List<TradePortfolioRiskTab> tabs;
  final List<TradeStressScenario> scenarios;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

/// A single asset's exposure amount and percentage within the copy
/// portfolio.
final class TradeAssetExposure {
  const TradeAssetExposure({
    required this.asset,
    required this.value,
    required this.percent,
    required this.colorHex,
  });

  final String asset;
  final double value;
  final double percent;
  final int colorHex;
}

/// A selectable tab on the Portfolio Risk Analysis screen.
final class TradePortfolioRiskTab {
  const TradePortfolioRiskTab({required this.id, required this.label});

  final String id;
  final String label;
}
