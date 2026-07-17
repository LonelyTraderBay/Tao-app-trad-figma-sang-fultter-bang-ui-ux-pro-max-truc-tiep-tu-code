part of 'p2p_entities.dart';

/// A merchant's trading analytics dashboard: stats, charts, comparisons, and top merchants.
final class P2PDashboardSnapshot {
  const P2PDashboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.filters,
    required this.selectedFilter,
    required this.stats,
    required this.weeklyVolume,
    required this.monthlyOrders,
    required this.assetDistribution,
    required this.currentLevel,
    required this.nextLevel,
    required this.platformComparisons,
    required this.topMerchants,
    required this.recentActivity,
    required this.quickActions,
    required this.parentRoute,
    required this.myOrdersRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final List<P2PDashboardFilterDraft> filters;
  final P2PDashboardFilterDraft selectedFilter;
  final P2PDashboardStatsDraft stats;
  final List<P2PDashboardSeriesPointDraft> weeklyVolume;
  final List<P2PDashboardMonthlyOrdersDraft> monthlyOrders;
  final List<P2PDashboardAssetDraft> assetDistribution;
  final P2PDashboardLevelDraft currentLevel;
  final P2PDashboardLevelDraft nextLevel;
  final List<P2PDashboardComparisonDraft> platformComparisons;
  final List<P2PDashboardMerchantDraft> topMerchants;
  final List<P2PDashboardActivityDraft> recentActivity;
  final List<P2PDashboardQuickActionDraft> quickActions;
  final String parentRoute;
  final String myOrdersRoute;
  final String emptyTitle;
  final String contractNotes;

  double get selectedVolume {
    return switch (selectedFilter.id) {
      '7d' => stats.totalVolume7d,
      'all' => stats.totalVolumeAll,
      _ => stats.totalVolume30d,
    };
  }
}

/// A single selectable time-range filter (e.g. 7d/30d/all) on the dashboard.
final class P2PDashboardFilterDraft {
  const P2PDashboardFilterDraft({required this.id, required this.label});

  final String id;
  final String label;
}

/// Aggregated order, volume, and reputation stats for the dashboard.
final class P2PDashboardStatsDraft {
  const P2PDashboardStatsDraft({
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.disputedOrders,
    required this.completionRate,
    required this.avgCompletionTime,
    required this.totalVolume7d,
    required this.totalVolume30d,
    required this.totalVolumeAll,
    required this.buyVolume30d,
    required this.sellVolume30d,
    required this.spreadRevenue30d,
    required this.avgOrderSize,
    required this.uniqueCounterparties,
    required this.repeatCustomerRate,
    required this.avgRatingReceived,
    required this.positiveReviewRate,
    required this.responseTimeAvg,
    required this.platformAvgCompletionRate,
    required this.platformAvgResponseTime,
  });

  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int disputedOrders;
  final double completionRate;
  final String avgCompletionTime;
  final double totalVolume7d;
  final double totalVolume30d;
  final double totalVolumeAll;
  final double buyVolume30d;
  final double sellVolume30d;
  final double spreadRevenue30d;
  final double avgOrderSize;
  final int uniqueCounterparties;
  final double repeatCustomerRate;
  final double avgRatingReceived;
  final double positiveReviewRate;
  final String responseTimeAvg;
  final double platformAvgCompletionRate;
  final String platformAvgResponseTime;
}

/// A single labeled point in a dashboard time-series chart.
final class P2PDashboardSeriesPointDraft {
  const P2PDashboardSeriesPointDraft({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;
}

/// Buy/sell order counts for a single month in the dashboard chart.
final class P2PDashboardMonthlyOrdersDraft {
  const P2PDashboardMonthlyOrdersDraft({
    required this.month,
    required this.buy,
    required this.sell,
  });

  final String month;
  final int buy;
  final int sell;
}

/// Share and volume of a single asset in the dashboard's asset distribution.
final class P2PDashboardAssetDraft {
  const P2PDashboardAssetDraft({
    required this.asset,
    required this.percentage,
    required this.volume,
  });

  final String asset;
  final double percentage;
  final double volume;
}

/// A trading level and progress used on the dashboard (current or next).
final class P2PDashboardLevelDraft {
  const P2PDashboardLevelDraft({
    required this.id,
    required this.name,
    required this.dailyUsed,
    required this.dailyLimit,
    required this.progress,
    required this.requirements,
  });

  final int id;
  final String name;
  final double dailyUsed;
  final double dailyLimit;
  final double progress;
  final List<String> requirements;
}

/// A single metric comparing the user against the platform average.
final class P2PDashboardComparisonDraft {
  const P2PDashboardComparisonDraft({
    required this.label,
    required this.yours,
    required this.platform,
    required this.suffix,
    this.lowerBetter = false,
  });

  final String label;
  final double yours;
  final double platform;
  final String suffix;
  final bool lowerBetter;
}

/// A single top-merchant row on the dashboard leaderboard.
final class P2PDashboardMerchantDraft {
  const P2PDashboardMerchantDraft({
    required this.id,
    required this.name,
    required this.trades,
    required this.volume,
    required this.rating,
  });

  final String id;
  final String name;
  final int trades;
  final double volume;
  final double rating;
}

/// A single recent trade row on the dashboard's activity feed.
final class P2PDashboardActivityDraft {
  const P2PDashboardActivityDraft({
    required this.date,
    required this.type,
    required this.asset,
    required this.amount,
    required this.total,
    required this.merchant,
    required this.status,
  });

  final String date;
  final String type;
  final String asset;
  final double amount;
  final double total;
  final String merchant;
  final String status;
}

/// A single quick-action shortcut on the dashboard.
final class P2PDashboardQuickActionDraft {
  const P2PDashboardQuickActionDraft({
    required this.id,
    required this.label,
    required this.route,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final String iconKey;
}

/// A user's unlocked/locked achievements and categories for the achievements screen.
final class P2PAchievementsSnapshot {
  const P2PAchievementsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.currentLevel,
    required this.achievements,
    required this.categories,
    required this.parentRoute,
    required this.tradingLevelRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final int currentLevel;
  final List<P2PAchievementDraft> achievements;
  final List<P2PAchievementCategoryDraft> categories;
  final String parentRoute;
  final String tradingLevelRoute;
  final String emptyTitle;
  final String contractNotes;

  int get unlockedCount {
    return achievements.where((item) => item.unlocked).length;
  }

  int get totalReputationPoints {
    return achievements
        .where((item) => item.unlocked && item.reputationPointsReward != null)
        .fold<int>(0, (sum, item) => sum + item.reputationPointsReward!);
  }

  int get unlockedBadgeCount {
    return achievements
        .where((item) => item.unlocked && item.rewardType == 'badge')
        .length;
  }

  double get overallProgress {
    if (achievements.isEmpty) return 0;
    return unlockedCount / achievements.length;
  }

  List<P2PAchievementDraft> achievementsFor(String categoryId) {
    return achievements.where((item) => item.categoryId == categoryId).toList();
  }
}

/// A single selectable achievement category filter.
final class P2PAchievementCategoryDraft {
  const P2PAchievementCategoryDraft({required this.id, required this.label});

  final String id;
  final String label;
}

/// A single achievement with its progress and unlock reward.
final class P2PAchievementDraft {
  const P2PAchievementDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.toneKey,
    required this.progress,
    required this.currentValueLabel,
    required this.progressLabel,
    required this.unlocked,
    required this.reward,
    required this.rewardType,
    required this.categoryId,
    this.unlockedAt,
    this.reputationPointsReward,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String toneKey;
  final double progress;
  final String currentValueLabel;
  final String progressLabel;
  final bool unlocked;
  final String? unlockedAt;
  final String reward;
  final String rewardType;
  final int? reputationPointsReward;
  final String categoryId;
}

/// Form data for adding a user to the personal blacklist.
final class P2PBlacklistAddSnapshot {
  const P2PBlacklistAddSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.usernameLabel,
    required this.usernameHint,
    required this.noteLabel,
    required this.noteHint,
    required this.warning,
    required this.submitLabel,
    required this.reasons,
    required this.parentRoute,
    required this.blacklistRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroSubtitle;
  final String usernameLabel;
  final String usernameHint;
  final String noteLabel;
  final String noteHint;
  final String warning;
  final String submitLabel;
  final List<P2PBlacklistReasonDraft> reasons;
  final String parentRoute;
  final String blacklistRoute;
  final String emptyTitle;
  final String contractNotes;
}

/// A single selectable reason for blacklisting a user.
final class P2PBlacklistReasonDraft {
  const P2PBlacklistReasonDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.toneKey,
  });

  final String id;
  final String label;
  final String iconKey;
  final String toneKey;
}

/// A user's personal blacklist entries for the blacklist screen.
final class P2PBlacklistSnapshot {
  const P2PBlacklistSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.searchHint,
    required this.infoTitle,
    required this.infoText,
    required this.addRoute,
    required this.parentRoute,
    required this.reasons,
    required this.entries,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String searchHint;
  final String infoTitle;
  final String infoText;
  final String addRoute;
  final String parentRoute;
  final List<P2PBlacklistReasonDraft> reasons;
  final List<P2PBlacklistEntryDraft> entries;
  final String emptyTitle;
  final String contractNotes;

  int get recent30dCount {
    return entries.where((item) => item.recent30d).length;
  }

  Map<String, int> get reasonCounts {
    final counts = <String, int>{};
    for (final entry in entries) {
      counts[entry.reasonId] = (counts[entry.reasonId] ?? 0) + 1;
    }
    return counts;
  }
}

/// A single blacklisted user entry.
final class P2PBlacklistEntryDraft {
  const P2PBlacklistEntryDraft({
    required this.id,
    required this.userId,
    required this.username,
    required this.reasonId,
    required this.reasonText,
    required this.blockedAt,
    required this.tradesBefore,
    required this.completionRate,
    required this.isVerified,
    required this.recent30d,
    this.orderId,
    this.badge,
  });

  final String id;
  final String userId;
  final String username;
  final String reasonId;
  final String reasonText;
  final String blockedAt;
  final String? orderId;
  final int tradesBefore;
  final double completionRate;
  final bool isVerified;
  final bool recent30d;
  final String? badge;
}

/// Notification preferences for the notification settings screen.
final class P2PNotificationSettingsSnapshot {
  const P2PNotificationSettingsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.settings,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroSubtitle;
  final List<P2PNotificationSettingDraft> settings;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

/// A single notification category and its enabled channels.
final class P2PNotificationSettingDraft {
  const P2PNotificationSettingDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.channels,
  });

  final String id;
  final String label;
  final String description;
  final Map<String, bool> channels;
}

/// Trading defaults, toggles, and auto-reply configuration for the P2P settings screen.
final class P2PSettingsSnapshot {
  const P2PSettingsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.assetOptions,
    required this.currencyOptions,
    required this.paymentWindows,
    required this.defaultAsset,
    required this.defaultCurrency,
    required this.defaultPaymentWindow,
    required this.notificationToggles,
    required this.privacyToggles,
    required this.securityToggles,
    required this.autoReply,
    required this.notificationsRoute,
    required this.trustedDevicesRoute,
    required this.blacklistRoute,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final List<String> assetOptions;
  final List<String> currencyOptions;
  final List<String> paymentWindows;
  final String defaultAsset;
  final String defaultCurrency;
  final String defaultPaymentWindow;
  final List<P2PSettingsToggleDraft> notificationToggles;
  final List<P2PSettingsToggleDraft> privacyToggles;
  final List<P2PSettingsToggleDraft> securityToggles;
  final P2PSettingsAutoReplyDraft autoReply;
  final String notificationsRoute;
  final String trustedDevicesRoute;
  final String blacklistRoute;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

/// A single on/off toggle on the P2P settings screen.
final class P2PSettingsToggleDraft {
  const P2PSettingsToggleDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.toneKey,
    required this.enabled,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final String toneKey;
  final bool enabled;
}

/// Auto-reply configuration used when a user is away.
final class P2PSettingsAutoReplyDraft {
  const P2PSettingsAutoReplyDraft({
    required this.enabled,
    required this.buyTemplate,
  });

  final bool enabled;
  final String buyTemplate;
}

/// FAQ, step-by-step guides, and safety tips for the P2P help/guide screen.
final class P2PGuideSnapshot {
  const P2PGuideSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.tabs,
    required this.defaultTab,
    required this.faqItems,
    required this.buySteps,
    required this.sellSteps,
    required this.safetyTips,
    required this.videos,
    required this.parentRoute,
    required this.supportRoute,
    required this.marketRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final List<P2PGuideTabDraft> tabs;
  final String defaultTab;
  final List<P2PGuideFaqDraft> faqItems;
  final List<P2PGuideStepDraft> buySteps;
  final List<P2PGuideStepDraft> sellSteps;
  final List<P2PGuideTipDraft> safetyTips;
  final List<P2PGuideVideoDraft> videos;
  final String parentRoute;
  final String supportRoute;
  final String marketRoute;
  final String emptyTitle;
  final String contractNotes;
}

/// A single selectable tab on the P2P guide screen.
final class P2PGuideTabDraft {
  const P2PGuideTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

/// A single FAQ question/answer pair on the guide screen.
final class P2PGuideFaqDraft {
  const P2PGuideFaqDraft({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String question;
  final String answer;
}

/// A single numbered step in a buy/sell how-to guide.
final class P2PGuideStepDraft {
  const P2PGuideStepDraft({
    required this.id,
    required this.step,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.toneKey,
  });

  final String id;
  final int step;
  final String title;
  final String description;
  final String iconKey;
  final String toneKey;
}

/// A single safety tip on the P2P guide screen.
final class P2PGuideTipDraft {
  const P2PGuideTipDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String toneKey;
}

/// A single tutorial video listed on the guide screen.
final class P2PGuideVideoDraft {
  const P2PGuideVideoDraft({
    required this.id,
    required this.title,
    required this.duration,
    required this.views,
    required this.thumb,
    required this.level,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String duration;
  final String views;
  final String thumb;
  final String level;
  final String toneKey;
}

/// A single quick-link shortcut shown across P2P screens.
final class P2PQuickLinkDraft {
  const P2PQuickLinkDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String route;
  final String iconKey;
}
