part of 'trade_entities.dart';

final class TradeExecutionQualitySnapshot {
  const TradeExecutionQualitySnapshot({
    required this.trade,
    required this.features,
    required this.report,
    required this.openOrder,
    required this.slippageSettings,
    required this.statusItems,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeExecutionFeature> features;
  final TradeExecutionReport report;
  final TradeExecutionOpenOrder openOrder;
  final TradeSlippageSettings slippageSettings;
  final List<TradeRiskStatusItem> statusItems;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeExecutionFeature {
  const TradeExecutionFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String iconName;
}

final class TradeExecutionReport {
  const TradeExecutionReport({
    required this.orderId,
    required this.symbol,
    required this.side,
    required this.requestedAmount,
    required this.filledAmount,
    required this.expectedPrice,
    required this.averageFillPrice,
    required this.bestAvailablePrice,
    required this.executionTimeMs,
    required this.slippagePct,
    required this.savingsVsSingleVenue,
    required this.executionQuality,
    required this.fills,
  });

  final String orderId;
  final String symbol;
  final TradeOrderSide side;
  final double requestedAmount;
  final double filledAmount;
  final double expectedPrice;
  final double averageFillPrice;
  final double bestAvailablePrice;
  final int executionTimeMs;
  final double slippagePct;
  final double savingsVsSingleVenue;
  final String executionQuality;
  final List<TradeExecutionFill> fills;
}

final class TradeExecutionFill {
  const TradeExecutionFill({
    required this.venue,
    required this.amount,
    required this.price,
    required this.fee,
    required this.timestampLabel,
  });

  final String venue;
  final double amount;
  final double price;
  final double fee;
  final String timestampLabel;
}

final class TradeExecutionOpenOrder {
  const TradeExecutionOpenOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
    required this.filled,
    required this.remaining,
    required this.queuePosition,
    required this.totalInQueue,
    required this.supportsAmend,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final String type;
  final double price;
  final double amount;
  final double filled;
  final double remaining;
  final int queuePosition;
  final int totalInQueue;
  final bool supportsAmend;
}

final class TradeSlippageSettings {
  const TradeSlippageSettings({
    required this.tolerancePct,
    required this.rejectOnExceed,
    required this.partialFillAllowed,
  });

  final double tolerancePct;
  final bool rejectOnExceed;
  final bool partialFillAllowed;
}

final class TradeOrderAmendmentRequest {
  const TradeOrderAmendmentRequest({
    required this.orderId,
    required this.newPrice,
    required this.newAmount,
  });

  final String orderId;
  final double newPrice;
  final double newAmount;
}

final class TradeOrderAmendmentResult {
  const TradeOrderAmendmentResult({
    required this.orderId,
    required this.status,
    required this.queuePositionPreserved,
  });

  final String orderId;
  final String status;
  final bool queuePositionPreserved;
}

final class TradeAdvancedToolsSnapshot {
  const TradeAdvancedToolsSnapshot({
    required this.trade,
    required this.features,
    required this.ladderOrders,
    required this.bulkOrders,
    required this.shortcuts,
    required this.statusItems,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeAdvancedToolFeature> features;
  final List<TradeLadderOrder> ladderOrders;
  final List<TradeBulkOrder> bulkOrders;
  final List<TradeShortcut> shortcuts;
  final List<TradeRiskStatusItem> statusItems;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeAdvancedToolFeature {
  const TradeAdvancedToolFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String iconName;
}

final class TradeLadderOrder {
  const TradeLadderOrder({
    required this.id,
    required this.price,
    required this.amount,
    required this.side,
    required this.filled,
  });

  final String id;
  final double price;
  final double amount;
  final TradeOrderSide side;
  final double filled;
}

final class TradeBulkOrder {
  const TradeBulkOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
    required this.filled,
    required this.remaining,
    required this.totalValue,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final String type;
  final double price;
  final double amount;
  final double filled;
  final double remaining;
  final double totalValue;
}

final class TradeShortcut {
  const TradeShortcut({
    required this.id,
    required this.keys,
    required this.label,
    required this.description,
  });

  final String id;
  final String keys;
  final String label;
  final String description;
}

final class TradeAdvancedToolActionRequest {
  const TradeAdvancedToolActionRequest({
    required this.toolId,
    required this.action,
    this.orderIds = const [],
  });

  final String toolId;
  final String action;
  final List<String> orderIds;
}

final class TradeAdvancedToolActionResult {
  const TradeAdvancedToolActionResult({
    required this.toolId,
    required this.action,
    required this.status,
    required this.affectedCount,
  });

  final String toolId;
  final String action;
  final String status;
  final int affectedCount;
}

enum TradeCopyRiskLevel { low, medium, high }

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
}

final class TradeCopyTradingV2Snapshot {
  const TradeCopyTradingV2Snapshot({
    required this.copyTrading,
    required this.heroVariants,
    required this.defaultHeroVariant,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeCopyTradingSnapshot copyTrading;
  final List<String> heroVariants;
  final String defaultHeroVariant;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

enum TradeCopyCardCompliance { pass, warn, fail }

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

final class TradeCopyCardTextBlock {
  const TradeCopyCardTextBlock({required this.title, required this.body});

  final String title;
  final String body;
}

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

final class TradeCopyEducationTab {
  const TradeCopyEducationTab({required this.id, required this.label});

  final String id;
  final String label;
}

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

enum TradeActiveCopyStatus { active, coolingOff, paused, stopped }

enum TradeActiveCopyMode { mirror, fixed, smart }

enum TradeCopySettingsMode { mirror, fixed, smart }

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
