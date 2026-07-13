part of 'trade_bots_entities.dart';

enum TradeBotRisk { low, medium, high }

enum TradeBotStatus { running, paused, stopped }

final class TradeBotsSnapshot {
  const TradeBotsSnapshot({
    required this.trade,
    required this.strategies,
    required this.activeBots,
    required this.supportedStates,
    required this.lastUpdatedLabel,
    this.highRiskContractId,
  });

  final TradeScreenSnapshot trade;
  final List<TradeBotStrategy> strategies;
  final List<TradeBot> activeBots;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
  final String? highRiskContractId;

  int get runningCount =>
      activeBots.where((bot) => bot.status == TradeBotStatus.running).length;

  double get totalInvestment =>
      activeBots.fold(0.0, (sum, bot) => sum + bot.investment);

  double get totalProfit =>
      activeBots.fold(0.0, (sum, bot) => sum + bot.profit);

  TradeBotsSnapshot copyWith({List<TradeBot>? activeBots}) {
    return TradeBotsSnapshot(
      trade: trade,
      strategies: strategies,
      activeBots: activeBots ?? this.activeBots,
      supportedStates: supportedStates,
      lastUpdatedLabel: lastUpdatedLabel,
      highRiskContractId: highRiskContractId,
    );
  }
}

final class TradeBotStrategy {
  const TradeBotStrategy({
    required this.id,
    required this.name,
    required this.description,
    required this.longDescription,
    required this.icon,
    required this.colorHex,
    required this.risk,
    required this.avgReturn,
    required this.suitableFor,
    required this.params,
  });

  final String id;
  final String name;
  final String description;
  final String longDescription;
  final String icon;
  final int colorHex;
  final TradeBotRisk risk;
  final String avgReturn;
  final String suitableFor;
  final List<TradeBotParam> params;
}

final class TradeBotParam {
  const TradeBotParam({
    required this.key,
    required this.label,
    required this.type,
    required this.defaultValue,
    this.options = const [],
    this.unit,
  });

  final String key;
  final String label;
  final String type;
  final String defaultValue;
  final List<String> options;
  final String? unit;
}

final class TradeBot {
  const TradeBot({
    required this.id,
    required this.strategyId,
    required this.strategyName,
    required this.icon,
    required this.colorHex,
    required this.pair,
    required this.status,
    required this.profit,
    required this.profitPct,
    required this.trades,
    required this.investment,
    required this.startDate,
    required this.runtime,
  });

  final String id;
  final String strategyId;
  final String strategyName;
  final String icon;
  final int colorHex;
  final String pair;
  final TradeBotStatus status;
  final double profit;
  final double profitPct;
  final int trades;
  final double investment;
  final String startDate;
  final String runtime;

  TradeBot copyWith({TradeBotStatus? status}) {
    return TradeBot(
      id: id,
      strategyId: strategyId,
      strategyName: strategyName,
      icon: icon,
      colorHex: colorHex,
      pair: pair,
      status: status ?? this.status,
      profit: profit,
      profitPct: profitPct,
      trades: trades,
      investment: investment,
      startDate: startDate,
      runtime: runtime,
    );
  }
}

final class TradeBotActionRequest {
  const TradeBotActionRequest({required this.botId, required this.action});

  final String botId;
  final String action;
}

final class TradeBotActionResult {
  const TradeBotActionResult({
    required this.botId,
    required this.action,
    required this.status,
  });

  final String botId;
  final String action;
  final String status;
}

final class TradeBotCreateRequest {
  const TradeBotCreateRequest({required this.strategyId, required this.params});

  final String strategyId;
  final Map<String, String> params;
}

final class TradeBotCreateResult {
  const TradeBotCreateResult({
    required this.botId,
    required this.strategyId,
    required this.status,
  });

  final String botId;
  final String strategyId;
  final String status;
}

final class TradeBotTermsSnapshot {
  const TradeBotTermsSnapshot({
    required this.infoTitle,
    required this.infoDescription,
    required this.title,
    required this.lastUpdatedLabel,
    required this.sections,
    required this.acceptSectionLabel,
    required this.scrollWarning,
    required this.agreementTitle,
    required this.agreementDescription,
    required this.disabledCta,
    required this.enabledCta,
    required this.complianceTitle,
    required this.complianceDescription,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String infoTitle;
  final String infoDescription;
  final String title;
  final String lastUpdatedLabel;
  final List<TradeBotTermsSection> sections;
  final String acceptSectionLabel;
  final String scrollWarning;
  final String agreementTitle;
  final String agreementDescription;
  final String disabledCta;
  final String enabledCta;
  final String complianceTitle;
  final String complianceDescription;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotTermsSection {
  const TradeBotTermsSection({
    required this.title,
    required this.paragraphs,
    this.warningTitle,
    this.warningBody,
    this.bullets = const [],
  });

  final String title;
  final List<String> paragraphs;
  final String? warningTitle;
  final String? warningBody;
  final List<String> bullets;
}

final class TradeBotRiskDisclosureSnapshot {
  const TradeBotRiskDisclosureSnapshot({
    required this.highRiskTitle,
    required this.highRiskBody,
    required this.pastPerformanceTitle,
    required this.pastPerformanceBody,
    required this.riskSectionLabel,
    required this.categories,
    required this.additionalWarningsLabel,
    required this.additionalWarnings,
    required this.regulatoryNoticeLabel,
    required this.regulatoryTitle,
    required this.regulatoryBody,
    required this.regulatoryNotes,
    required this.acknowledgmentLabel,
    required this.acknowledgmentTitle,
    required this.acknowledgmentDescription,
    required this.disabledCta,
    required this.enabledCta,
    required this.helpTitle,
    required this.helpDescription,
    required this.helpCta,
    required this.nextPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String highRiskTitle;
  final String highRiskBody;
  final String pastPerformanceTitle;
  final String pastPerformanceBody;
  final String riskSectionLabel;
  final List<TradeBotRiskCategory> categories;
  final String additionalWarningsLabel;
  final List<TradeBotRiskWarning> additionalWarnings;
  final String regulatoryNoticeLabel;
  final String regulatoryTitle;
  final String regulatoryBody;
  final List<String> regulatoryNotes;
  final String acknowledgmentLabel;
  final String acknowledgmentTitle;
  final String acknowledgmentDescription;
  final String disabledCta;
  final String enabledCta;
  final String helpTitle;
  final String helpDescription;
  final String helpCta;
  final String nextPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotRiskCategory {
  const TradeBotRiskCategory({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.examples,
    required this.mitigation,
  });

  final String id;
  final TradeBotRiskKind kind;
  final String title;
  final String description;
  final List<String> examples;
  final String mitigation;
}

enum TradeBotRiskKind {
  market,
  leverage,
  liquidity,
  technical,
  timing,
  regulatory,
}

final class TradeBotRiskWarning {
  const TradeBotRiskWarning({required this.title, required this.text});

  final String title;
  final String text;
}

final class TradeBotSuitabilityAssessmentSnapshot {
  const TradeBotSuitabilityAssessmentSnapshot({
    required this.questions,
    required this.infoTitle,
    required this.infoDescription,
    required this.pass,
    required this.warning,
    required this.fail,
    required this.regulatoryTitle,
    required this.regulatoryDescription,
    required this.completionPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotSuitabilityQuestion> questions;
  final String infoTitle;
  final String infoDescription;
  final TradeBotSuitabilityOutcomeCopy pass;
  final TradeBotSuitabilityOutcomeCopy warning;
  final TradeBotSuitabilityOutcomeCopy fail;
  final String regulatoryTitle;
  final String regulatoryDescription;
  final String completionPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  int get maxScore => questions.length * 3;
}

final class TradeBotSuitabilityQuestion {
  const TradeBotSuitabilityQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
  });

  final String id;
  final TradeBotSuitabilityCategory category;
  final String question;
  final List<TradeBotSuitabilityOption> options;
}

final class TradeBotSuitabilityOption {
  const TradeBotSuitabilityOption({
    required this.id,
    required this.text,
    required this.score,
  });

  final String id;
  final String text;
  final int score;
}

enum TradeBotSuitabilityCategory { experience, knowledge, risk, financial }

enum TradeBotSuitabilityOutcome { pass, warning, fail }

final class TradeBotSuitabilityOutcomeCopy {
  const TradeBotSuitabilityOutcomeCopy({
    required this.outcome,
    required this.title,
    required this.message,
    required this.recommendations,
    required this.ctaLabel,
  });

  final TradeBotSuitabilityOutcome outcome;
  final String title;
  final String message;
  final List<String> recommendations;
  final String ctaLabel;
}

final class TradeBotRiskDashboardSnapshot {
  const TradeBotRiskDashboardSnapshot({
    required this.riskScore,
    required this.riskLabel,
    required this.riskMessage,
    required this.currentDrawdown,
    required this.maxDrawdownLimit,
    required this.dailyLoss,
    required this.dailyLossLimit,
    required this.totalExposure,
    required this.maxExposure,
    required this.var95,
    required this.runningBots,
    required this.drawdownPoints,
    required this.exposures,
    required this.varHistory,
    required this.safetyControls,
    required this.emergencyPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int riskScore;
  final String riskLabel;
  final String riskMessage;
  final double currentDrawdown;
  final double maxDrawdownLimit;
  final double dailyLoss;
  final double dailyLossLimit;
  final double totalExposure;
  final double maxExposure;
  final double var95;
  final int runningBots;
  final List<TradeBotDrawdownPoint> drawdownPoints;
  final List<TradeBotExposure> exposures;
  final List<TradeBotVarPoint> varHistory;
  final List<TradeBotSafetyControl> safetyControls;
  final String emergencyPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotDrawdownPoint {
  const TradeBotDrawdownPoint({required this.label, required this.value});

  final String label;
  final double value;
}

final class TradeBotExposure {
  const TradeBotExposure({
    required this.asset,
    required this.exposure,
    required this.percentage,
    required this.colorHex,
  });

  final String asset;
  final double exposure;
  final int percentage;
  final int colorHex;
}

final class TradeBotVarPoint {
  const TradeBotVarPoint({required this.label, required this.value});

  final String label;
  final double value;
}

final class TradeBotSafetyControl {
  const TradeBotSafetyControl({required this.label, required this.value});

  final String label;
  final String value;
}

final class TradeBotEmergencyStopSnapshot {
  const TradeBotEmergencyStopSnapshot({
    required this.warningTitle,
    required this.warningDescription,
    required this.bots,
    required this.reasons,
    required this.closePositionsTitle,
    required this.closePositionsDescription,
    required this.confirmationTitle,
    required this.confirmationDescription,
    required this.supportTitle,
    required this.supportDescription,
    required this.completionPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String warningTitle;
  final String warningDescription;
  final List<TradeBotEmergencyBot> bots;
  final List<TradeBotEmergencyReason> reasons;
  final String closePositionsTitle;
  final String closePositionsDescription;
  final String confirmationTitle;
  final String confirmationDescription;
  final String supportTitle;
  final String supportDescription;
  final String completionPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotEmergencyBot {
  const TradeBotEmergencyBot({
    required this.id,
    required this.name,
    required this.pair,
    required this.profit,
    required this.statusLabel,
  });

  final String id;
  final String name;
  final String pair;
  final double profit;
  final String statusLabel;
}

final class TradeBotEmergencyReason {
  const TradeBotEmergencyReason({
    required this.id,
    required this.label,
    required this.iconName,
  });

  final String id;
  final String label;
  final String iconName;
}

final class TradeBotEmergencyStopDraft {
  const TradeBotEmergencyStopDraft({
    required this.reasonId,
    required this.closePositions,
    required this.confirmed,
  });

  final String reasonId;
  final bool closePositions;
  final bool confirmed;
}

final class TradeBotEmergencyStopResult {
  const TradeBotEmergencyStopResult({
    required this.status,
    required this.stoppedBotCount,
    required this.redirectPath,
  });

  final String status;
  final int stoppedBotCount;
  final String redirectPath;
}

final class TradeBotSecuritySettingsSnapshot {
  const TradeBotSecuritySettingsSnapshot({
    required this.twoFaEnabled,
    required this.apiKeys,
    required this.ipWhitelist,
    required this.recentActivity,
    required this.securityTips,
    required this.generatedApiKeyPreview,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final bool twoFaEnabled;
  final List<TradeBotApiKey> apiKeys;
  final List<TradeBotIpWhitelistEntry> ipWhitelist;
  final List<TradeBotSecurityActivity> recentActivity;
  final List<String> securityTips;
  final String generatedApiKeyPreview;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotApiKey {
  const TradeBotApiKey({
    required this.id,
    required this.name,
    required this.permissions,
    required this.lastUsed,
    required this.created,
  });

  final String id;
  final String name;
  final String permissions;
  final String lastUsed;
  final String created;
}

final class TradeBotIpWhitelistEntry {
  const TradeBotIpWhitelistEntry({
    required this.id,
    required this.ip,
    required this.label,
    required this.added,
  });

  final String id;
  final String ip;
  final String label;
  final String added;
}

enum TradeBotSecurityActivityStatus { success, warning }

final class TradeBotSecurityActivity {
  const TradeBotSecurityActivity({
    required this.id,
    required this.action,
    required this.time,
    required this.status,
  });

  final String id;
  final String action;
  final String time;
  final TradeBotSecurityActivityStatus status;
}

final class TradeBotSecuritySettingsDraft {
  const TradeBotSecuritySettingsDraft({required this.twoFaEnabled});

  final bool twoFaEnabled;
}

final class TradeBotSecuritySettingsResult {
  const TradeBotSecuritySettingsResult({
    required this.status,
    required this.twoFaEnabled,
  });

  final String status;
  final bool twoFaEnabled;
}

final class TradeBotHistorySnapshot {
  const TradeBotHistorySnapshot({
    required this.trades,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotHistoryTrade> trades;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

enum TradeBotHistorySide { buy, sell }

final class TradeBotHistoryTrade {
  const TradeBotHistoryTrade({
    required this.id,
    required this.timestamp,
    required this.botName,
    required this.strategy,
    required this.pair,
    required this.side,
    required this.qty,
    required this.price,
    required this.fee,
    required this.pnl,
    required this.status,
  });

  final String id;
  final String timestamp;
  final String botName;
  final String strategy;
  final String pair;
  final TradeBotHistorySide side;
  final double qty;
  final double price;
  final double fee;
  final double pnl;
  final String status;
}

final class TradeBotHistoryExportRequest {
  const TradeBotHistoryExportRequest({required this.format});

  final String format;
}

final class TradeBotHistoryExportResult {
  const TradeBotHistoryExportResult({
    required this.status,
    required this.downloadUrl,
  });

  final String status;
  final String downloadUrl;
}

final class TradeBotPerformanceAnalyticsSnapshot {
  const TradeBotPerformanceAnalyticsSnapshot({
    required this.metrics,
    required this.pnlPoints,
    required this.winLossPoints,
    required this.strategyPerformance,
    required this.durationDistribution,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotPerformanceMetrics metrics;
  final List<TradeBotPnlPoint> pnlPoints;
  final List<TradeBotWinLossPoint> winLossPoints;
  final List<TradeBotStrategyPerformance> strategyPerformance;
  final List<TradeBotDurationDistribution> durationDistribution;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotPerformanceMetrics {
  const TradeBotPerformanceMetrics({
    required this.totalPnl,
    required this.winRate,
    required this.sharpeRatio,
    required this.avgWin,
    required this.avgLoss,
    required this.profitFactor,
    required this.totalTrades,
    required this.bestTrade,
    required this.worstTrade,
  });

  final double totalPnl;
  final double winRate;
  final double sharpeRatio;
  final double avgWin;
  final double avgLoss;
  final double profitFactor;
  final int totalTrades;
  final double bestTrade;
  final double worstTrade;
}

final class TradeBotPnlPoint {
  const TradeBotPnlPoint({required this.date, required this.pnl});

  final String date;
  final double pnl;
}

final class TradeBotWinLossPoint {
  const TradeBotWinLossPoint({
    required this.week,
    required this.wins,
    required this.losses,
  });

  final String week;
  final int wins;
  final int losses;
}

final class TradeBotStrategyPerformance {
  const TradeBotStrategyPerformance({
    required this.strategy,
    required this.pnl,
    required this.colorHex,
  });

  final String strategy;
  final double pnl;
  final int colorHex;
}
