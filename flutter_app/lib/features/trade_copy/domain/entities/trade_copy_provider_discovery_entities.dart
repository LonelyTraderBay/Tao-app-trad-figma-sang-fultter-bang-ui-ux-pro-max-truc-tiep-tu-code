part of 'trade_copy_entities.dart';

/// Step of the become-a-provider application wizard: intro, requirements,
/// disclosure, fees, or review.
enum TradeProviderApplicationStep {
  intro,
  requirements,
  disclosure,
  fees,
  review,
}

/// Read-model for the Become a Provider application screen (steps,
/// benefits, requirements, responsibilities, default draft).
final class TradeProviderApplicationSnapshot {
  const TradeProviderApplicationSnapshot({
    required this.trade,
    required this.steps,
    required this.defaultStep,
    required this.benefits,
    required this.requirements,
    required this.responsibilities,
    required this.defaultDraft,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeProviderApplicationStep> steps;
  final TradeProviderApplicationStep defaultStep;
  final List<TradeProviderBenefit> benefits;
  final List<TradeProviderRequirement> requirements;
  final List<String> responsibilities;
  final TradeProviderApplicationDraft defaultDraft;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

/// A single benefit callout (icon, title, description) shown to
/// prospective providers.
final class TradeProviderBenefit {
  const TradeProviderBenefit({
    required this.iconName,
    required this.title,
    required this.description,
  });

  final String iconName;
  final String title;
  final String description;
}

/// A single eligibility requirement (label + whether it is currently
/// met) on the provider application screen.
final class TradeProviderRequirement {
  const TradeProviderRequirement({required this.label, required this.met});

  final String label;
  final bool met;
}

/// Mutable draft form state for a provider application before
/// submission.
final class TradeProviderApplicationDraft {
  const TradeProviderApplicationDraft({
    required this.hasKyc,
    required this.tradingMonths,
    required this.minCapital,
    required this.performanceFee,
    required this.agreedToDisclosure,
    required this.agreedToFiduciary,
    required this.agreedToTerms,
    required this.strategyDescription,
  });

  final bool hasKyc;
  final int tradingMonths;
  final int minCapital;
  final int performanceFee;
  final bool agreedToDisclosure;
  final bool agreedToFiduciary;
  final bool agreedToTerms;
  final String strategyDescription;

  TradeProviderApplicationDraft copyWith({
    bool? hasKyc,
    int? tradingMonths,
    int? minCapital,
    int? performanceFee,
    bool? agreedToDisclosure,
    bool? agreedToFiduciary,
    bool? agreedToTerms,
    String? strategyDescription,
  }) {
    return TradeProviderApplicationDraft(
      hasKyc: hasKyc ?? this.hasKyc,
      tradingMonths: tradingMonths ?? this.tradingMonths,
      minCapital: minCapital ?? this.minCapital,
      performanceFee: performanceFee ?? this.performanceFee,
      agreedToDisclosure: agreedToDisclosure ?? this.agreedToDisclosure,
      agreedToFiduciary: agreedToFiduciary ?? this.agreedToFiduciary,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      strategyDescription: strategyDescription ?? this.strategyDescription,
    );
  }
}

/// Result of submitting a provider application.
final class TradeProviderApplicationResult {
  const TradeProviderApplicationResult({
    required this.applicationId,
    required this.status,
    required this.reviewWindow,
  });

  final String applicationId;
  final String status;
  final String reviewWindow;
}

/// Read-model for a single provider's detail screen.
final class TradeCopyProviderDetailSnapshot {
  const TradeCopyProviderDetailSnapshot({
    required this.providerId,
    required this.provider,
    required this.supportedStates,
    required this.lastUpdatedLabel,
    this.notFoundMessage = 'Provider không tồn tại',
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
  final String notFoundMessage;

  bool get isNotFound => provider == null;
}

/// Read-model for the Pre-Copy Suitability Assessment screen (provider,
/// questionnaire, education docs) shown before copying a provider.
final class TradePreCopyAssessmentSnapshot {
  const TradePreCopyAssessmentSnapshot({
    required this.providerId,
    required this.provider,
    required this.questions,
    required this.educationDocs,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final List<TradePreCopyQuestion> questions;
  final List<TradePreCopyEducationDoc> educationDocs;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

/// A single pre-copy suitability question with scored answer options.
final class TradePreCopyQuestion {
  const TradePreCopyQuestion({
    required this.id,
    required this.question,
    required this.description,
    required this.options,
  });

  final String id;
  final String question;
  final String description;
  final List<TradePreCopyOption> options;
}

/// A single selectable, scored answer option for a pre-copy assessment
/// question.
final class TradePreCopyOption {
  const TradePreCopyOption({
    required this.value,
    required this.label,
    required this.score,
  });

  final String value;
  final String label;
  final int score;
}

/// A single linked educational document shown on the pre-copy assessment
/// screen.
final class TradePreCopyEducationDoc {
  const TradePreCopyEducationDoc({
    required this.id,
    required this.title,
    required this.duration,
  });

  final String id;
  final String title;
  final String duration;
}

/// Read-model for the Provider Comparison screen (selected providers,
/// side-by-side metrics).
final class TradeProviderComparisonSnapshot {
  const TradeProviderComparisonSnapshot({
    required this.selectedCount,
    required this.maxProviders,
    required this.providers,
    required this.metrics,
    required this.disclaimer,
    required this.legend,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final int selectedCount;
  final int maxProviders;
  final List<TradeProviderComparisonProvider> providers;
  final List<TradeProviderComparisonMetric> metrics;
  final String disclaimer;
  final String legend;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

/// A single provider entry (id, name, avatar) selected for comparison.
final class TradeProviderComparisonProvider {
  const TradeProviderComparisonProvider({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String name;
  final String avatar;
}

/// A single comparison metric row with per-provider values.
final class TradeProviderComparisonMetric {
  const TradeProviderComparisonMetric({
    required this.label,
    required this.category,
    required this.higherIsBetter,
    required this.values,
  });

  final String label;
  final TradeProviderComparisonCategory category;
  final bool higherIsBetter;
  final Map<String, String> values;
}

/// Category of a provider comparison metric: performance, risk,
/// execution, or cost.
enum TradeProviderComparisonCategory { performance, risk, execution, cost }

/// Read-model for the Provider Leaderboard screen (ranked providers,
/// sort/risk filters, risk warning copy).
final class TradeProviderLeaderboardSnapshot {
  const TradeProviderLeaderboardSnapshot({
    required this.trade,
    required this.providers,
    required this.sortOptions,
    required this.riskFilters,
    required this.defaultSortId,
    required this.defaultRiskFilterId,
    required this.defaultVerifiedOnly,
    required this.warningTitle,
    required this.warningText,
    required this.verifiedOnlyLabel,
    required this.disclaimer,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyTrader> providers;
  final List<TradeProviderLeaderboardSort> sortOptions;
  final List<TradeProviderLeaderboardRiskFilter> riskFilters;
  final String defaultSortId;
  final String defaultRiskFilterId;
  final bool defaultVerifiedOnly;
  final String warningTitle;
  final String warningText;
  final String verifiedOnlyLabel;
  final String disclaimer;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

/// A selectable sort option on the provider leaderboard.
final class TradeProviderLeaderboardSort {
  const TradeProviderLeaderboardSort({required this.id, required this.label});

  final String id;
  final String label;
}

/// A selectable risk-level filter on the provider leaderboard.
final class TradeProviderLeaderboardRiskFilter {
  const TradeProviderLeaderboardRiskFilter({
    required this.id,
    required this.label,
    this.riskLevel,
  });

  final String id;
  final String label;
  final TradeCopyRiskLevel? riskLevel;
}

/// Read-model for the Provider Governance screen (a provider's own
/// dashboard: stats, strategy changes, follower messages, compliance).
final class TradeProviderGovernanceSnapshot {
  const TradeProviderGovernanceSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.stats,
    required this.warning,
    required this.modifications,
    required this.messages,
    required this.feeContributors,
    required this.complianceItems,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeProviderGovernanceTab> tabs;
  final String defaultTabId;
  final TradeProviderGovernanceStats stats;
  final String warning;
  final List<TradeStrategyModification> modifications;
  final List<TradeFollowerMessage> messages;
  final List<TradeFeeContributor> feeContributors;
  final List<TradeComplianceItem> complianceItems;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

/// A selectable tab on the Provider Governance screen.
final class TradeProviderGovernanceTab {
  const TradeProviderGovernanceTab({required this.id, required this.label});

  final String id;
  final String label;
}

/// Aggregate provider-facing governance stats (followers, AUM, fees
/// earned, compliance score).
final class TradeProviderGovernanceStats {
  const TradeProviderGovernanceStats({
    required this.followers,
    required this.aum,
    required this.monthlyFeesEarned,
    required this.allTimeFeesEarned,
    required this.complianceScore,
  });

  final int followers;
  final double aum;
  final double monthlyFeesEarned;
  final double allTimeFeesEarned;
  final int complianceScore;
}

/// A single logged change to a provider's strategy parameters, with
/// follower-notification status.
final class TradeStrategyModification {
  const TradeStrategyModification({
    required this.id,
    required this.date,
    required this.type,
    required this.oldValue,
    required this.newValue,
    required this.notificationSent,
    required this.followerImpact,
  });

  final String id;
  final String date;
  final String type;
  final String oldValue;
  final String newValue;
  final bool notificationSent;
  final int followerImpact;
}

/// A single message a provider sent to their followers.
final class TradeFollowerMessage {
  const TradeFollowerMessage({
    required this.id,
    required this.date,
    required this.subject,
    required this.body,
    required this.recipients,
    required this.openRate,
  });

  final String id;
  final String date;
  final String subject;
  final String body;
  final int recipients;
  final int openRate;
}

/// A single follower's contribution to a provider's performance-fee
/// earnings.
final class TradeFeeContributor {
  const TradeFeeContributor({
    required this.name,
    required this.profit,
    required this.fee,
  });

  final String name;
  final double profit;
  final double fee;
}

/// A single compliance checklist item on the provider governance screen.
final class TradeComplianceItem {
  const TradeComplianceItem({
    required this.item,
    required this.status,
    required this.lastCheck,
  });

  final String item;
  final bool status;
  final String lastCheck;
}

/// Read-model for a trader's public profile screen (PnL history, recent
/// trades).
final class TradeTraderProfileSnapshot {
  const TradeTraderProfileSnapshot({
    required this.traderId,
    required this.trader,
    required this.pnlHistory,
    required this.recentTrades,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String traderId;
  final TradeCopyTrader trader;
  final List<TradeTraderPnlPoint> pnlHistory;
  final List<TradeTraderRecentTrade> recentTrades;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

/// One day's daily and cumulative PnL for a trader's public profile.
final class TradeTraderPnlPoint {
  const TradeTraderPnlPoint({
    required this.day,
    required this.pnl,
    required this.cumPnl,
  });

  final String day;
  final double pnl;
  final double cumPnl;
}

/// A single recent trade shown on a trader's public profile.
final class TradeTraderRecentTrade {
  const TradeTraderRecentTrade({
    required this.id,
    required this.pair,
    required this.side,
    required this.entry,
    required this.exit,
    required this.pnl,
    required this.pnlPct,
    required this.time,
    required this.status,
  });

  final String id;
  final String pair;
  final String side;
  final double entry;
  final double? exit;
  final double pnl;
  final double pnlPct;
  final String time;
  final String status;
}

/// A copy-trading provider profile — kernel entity shared across
/// discovery, leaderboard, comparison, and detail screens (performance,
/// AUM, follower count, risk level).
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
