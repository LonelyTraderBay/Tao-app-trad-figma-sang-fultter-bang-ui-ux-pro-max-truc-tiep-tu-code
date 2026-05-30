part of 'trade_entities.dart';

final class TradeBotGuideExample {
  const TradeBotGuideExample({
    required this.setup,
    required this.duration,
    required this.result,
    required this.profit,
  });

  final String setup;
  final String duration;
  final String result;
  final String profit;
}

final class TradeBotGuidePractice {
  const TradeBotGuidePractice({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
}

final class TradeBotGuideMistake {
  const TradeBotGuideMistake({
    required this.mistake,
    required this.why,
    required this.fix,
  });

  final String mistake;
  final String why;
  final String fix;
}

final class TradeBotFaqSnapshot {
  const TradeBotFaqSnapshot({
    required this.categories,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotFaqCategory> categories;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  int get totalFaqs =>
      categories.fold<int>(0, (sum, category) => sum + category.items.length);
}

final class TradeBotFaqCategory {
  const TradeBotFaqCategory({
    required this.id,
    required this.label,
    required this.items,
  });

  final String id;
  final String label;
  final List<TradeBotFaqItem> items;
}

final class TradeBotFaqItem {
  const TradeBotFaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

final class TradeBotTaxReportingSnapshot {
  const TradeBotTaxReportingSnapshot({
    required this.taxYears,
    required this.defaultYear,
    required this.defaultCostBasisMethod,
    required this.summary,
    required this.reportTypes,
    required this.breakdown,
    required this.taxNotes,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<String> taxYears;
  final String defaultYear;
  final String defaultCostBasisMethod;
  final TradeBotTaxSummary summary;
  final List<TradeBotTaxReportType> reportTypes;
  final TradeBotTaxBreakdown breakdown;
  final List<String> taxNotes;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotTaxSummary {
  const TradeBotTaxSummary({
    required this.totalTrades,
    required this.realizedGains,
    required this.realizedLosses,
    required this.netGainLoss,
    required this.shortTermGains,
    required this.longTermGains,
    required this.totalFees,
  });

  final int totalTrades;
  final double realizedGains;
  final double realizedLosses;
  final double netGainLoss;
  final double shortTermGains;
  final double longTermGains;
  final double totalFees;
}

final class TradeBotTaxReportType {
  const TradeBotTaxReportType({
    required this.id,
    required this.name,
    required this.description,
    required this.format,
    required this.recommended,
    required this.selectedByDefault,
  });

  final String id;
  final String name;
  final String description;
  final String format;
  final bool recommended;
  final bool selectedByDefault;
}

final class TradeBotTaxBreakdown {
  const TradeBotTaxBreakdown({
    required this.shortTermLabel,
    required this.shortTermDescription,
    required this.longTermLabel,
    required this.longTermDescription,
  });

  final String shortTermLabel;
  final String shortTermDescription;
  final String longTermLabel;
  final String longTermDescription;
}

final class TradeBotTaxReportExportRequest {
  const TradeBotTaxReportExportRequest({
    required this.year,
    required this.reportTypeIds,
    required this.costBasisMethod,
  });

  final String year;
  final List<String> reportTypeIds;
  final String costBasisMethod;
}

final class TradeBotTaxReportExportResult {
  const TradeBotTaxReportExportResult({
    required this.status,
    required this.year,
    required this.reportCount,
    required this.exportId,
  });

  final String status;
  final String year;
  final int reportCount;
  final String exportId;
}

final class TradeBotApiDocumentationSnapshot {
  const TradeBotApiDocumentationSnapshot({
    required this.tabs,
    required this.defaultView,
    required this.defaultLanguage,
    required this.endpoints,
    required this.websocketUrl,
    required this.websocketEvents,
    required this.codeExamples,
    required this.rateLimits,
    required this.authenticationHeader,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotApiTab> tabs;
  final String defaultView;
  final String defaultLanguage;
  final List<TradeBotApiEndpoint> endpoints;
  final String websocketUrl;
  final List<TradeBotWebSocketEvent> websocketEvents;
  final List<TradeBotCodeExample> codeExamples;
  final List<TradeBotRateLimit> rateLimits;
  final String authenticationHeader;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotApiTab {
  const TradeBotApiTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeBotApiEndpoint {
  const TradeBotApiEndpoint({
    required this.method,
    required this.path,
    required this.description,
    required this.params,
    required this.response,
  });

  final String method;
  final String path;
  final String description;
  final List<TradeBotApiParameter> params;
  final String response;
}

final class TradeBotApiParameter {
  const TradeBotApiParameter({
    required this.name,
    required this.type,
    required this.required,
    required this.description,
  });

  final String name;
  final String type;
  final bool required;
  final String description;
}

final class TradeBotWebSocketEvent {
  const TradeBotWebSocketEvent({
    required this.event,
    required this.description,
    required this.payload,
  });

  final String event;
  final String description;
  final String payload;
}

final class TradeBotCodeExample {
  const TradeBotCodeExample({
    required this.language,
    required this.label,
    required this.title,
    required this.source,
  });

  final String language;
  final String label;
  final String title;
  final String source;
}

final class TradeBotRateLimit {
  const TradeBotRateLimit({required this.label, required this.value});

  final String label;
  final String value;
}

final class TradeComplaintCategory {
  const TradeComplaintCategory({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final TradeComplaintCategoryIcon icon;
}

final class TradeComplaintTimelineStep {
  const TradeComplaintTimelineStep({
    required this.step,
    required this.label,
    required this.time,
  });

  final int step;
  final String label;
  final String time;
}

final class TradeComplaint {
  const TradeComplaint({
    required this.id,
    required this.category,
    required this.status,
    required this.submittedDate,
    required this.deadline,
    required this.subject,
  });

  final String id;
  final String category;
  final TradeComplaintStatus status;
  final String submittedDate;
  final String deadline;
  final String subject;
}

final class TradeComplaintProcessStep {
  const TradeComplaintProcessStep({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeOmbudsmanInfo {
  const TradeOmbudsmanInfo({
    required this.description,
    required this.phone,
    required this.website,
  });

  final String description;
  final String phone;
  final String website;
}

enum TradeComplaintCategoryIcon {
  trade,
  account,
  payment,
  service,
  fees,
  other,
}

enum TradeComplaintStatus { submitted, underReview, resolved, escalated }

final class TradeCopyTrader {
  const TradeCopyTrader({
    required this.id,
    required this.name,
    required this.avatar,
    required this.winRate,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.aum,
    required this.copiers,
    required this.maxCopiers,
    required this.sharpeRatio,
    required this.maxDrawdown,
    required this.totalTrades,
    required this.avgHoldingTime,
    required this.weeklyPnl,
    required this.tags,
    required this.isFollowing,
    required this.riskLevel,
  });

  final String id;
  final String name;
  final String avatar;
  final double winRate;
  final double totalPnl;
  final double totalPnlPct;
  final double aum;
  final int copiers;
  final int maxCopiers;
  final double sharpeRatio;
  final double maxDrawdown;
  final int totalTrades;
  final String avgHoldingTime;
  final List<double> weeklyPnl;
  final List<String> tags;
  final bool isFollowing;
  final TradeCopyRiskLevel riskLevel;

  TradeCopyTrader copyWith({bool? isFollowing}) {
    return TradeCopyTrader(
      id: id,
      name: name,
      avatar: avatar,
      winRate: winRate,
      totalPnl: totalPnl,
      totalPnlPct: totalPnlPct,
      aum: aum,
      copiers: copiers,
      maxCopiers: maxCopiers,
      sharpeRatio: sharpeRatio,
      maxDrawdown: maxDrawdown,
      totalTrades: totalTrades,
      avgHoldingTime: avgHoldingTime,
      weeklyPnl: weeklyPnl,
      tags: tags,
      isFollowing: isFollowing ?? this.isFollowing,
      riskLevel: riskLevel,
    );
  }
}

final class TradeCopyActionRequest {
  const TradeCopyActionRequest({
    required this.providerId,
    required this.action,
  });

  final String providerId;
  final String action;
}

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

final class TradeDashboardPosition {
  const TradeDashboardPosition({
    required this.id,
    required this.symbol,
    required this.type,
    required this.side,
    required this.size,
    required this.entryPrice,
    required this.currentPrice,
    required this.pnl,
    required this.pnlPct,
    this.leverage,
    this.liquidPrice,
    this.takeProfit,
    this.stopLoss,
    this.margin,
  });

  final String id;
  final String symbol;
  final TradePositionType type;
  final TradePositionSide side;
  final double size;
  final double entryPrice;
  final double currentPrice;
  final double pnl;
  final double pnlPct;
  final int? leverage;
  final double? liquidPrice;
  final double? takeProfit;
  final double? stopLoss;
  final double? margin;

  double get notional => size * currentPrice;
}

final class TradeHistoryOrder {
  const TradeHistoryOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.status,
    required this.price,
    required this.amount,
    required this.filled,
    required this.fee,
    required this.createdAt,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final TradeOrderType type;
  final TradeOrderStatus status;
  final double price;
  final double amount;
  final double filled;
  final double fee;
  final String createdAt;
}

final class TradePosition {
  const TradePosition({
    required this.symbol,
    required this.side,
    required this.notional,
    required this.pnl,
  });

  final String symbol;
  final TradeOrderSide side;
  final double notional;
  final double pnl;
}

final class TradeBalances {
  const TradeBalances({
    required this.usdtAvailable,
    required this.baseAvailable,
  });

  final double usdtAvailable;
  final double baseAvailable;
}

final class TradeOrderDraft {
  const TradeOrderDraft({
    required this.pairId,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
  });

  final String pairId;
  final TradeOrderSide side;
  final TradeOrderType type;
  final double price;
  final double amount;
}

final class TradeOrderPreview {
  const TradeOrderPreview({
    required this.total,
    required this.fee,
    required this.feeRate,
    required this.estimatedReceive,
  });

  final double total;
  final double fee;
  final double feeRate;
  final double estimatedReceive;
}
