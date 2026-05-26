enum ReferralScreenState { loading, empty, error, offline }

enum ReferralFriendFilter { all, activeTrader, kycDone, pendingKyc }

enum ReferralHistorySort { date, commission, volume }

enum ReferralFriendStatus { pendingKyc, kycDone, activeTrader, inactive }

enum ReferralRewardFilter { all, kycBonus, tradeCommission }

enum ReferralRewardSort { date, amount }

enum ReferralRewardType { kycBonus, tradeCommission }

enum ReferralRewardStatus { completed, pending }

final class ReferralHistorySnapshot {
  const ReferralHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.searchHint,
    required this.stats,
    required this.filters,
    required this.sortOptions,
    required this.friends,
    required this.filter,
    required this.sort,
    required this.query,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String searchHint;
  final ReferralStatsDraft stats;
  final List<ReferralFilterDraft> filters;
  final List<ReferralSortDraft> sortOptions;
  final List<ReferralFriendDraft> friends;
  final ReferralFriendFilter filter;
  final ReferralHistorySort sort;
  final String query;
  final String contractNotes;
  final Set<ReferralScreenState> supportedStates;
}

final class ReferralHomeSnapshot {
  const ReferralHomeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.referralCode,
    required this.referralLink,
    required this.stats,
    required this.currentTier,
    required this.nextTier,
    required this.campaign,
    required this.socialProof,
    required this.milestones,
    required this.pendingCommissions,
    required this.leaderboard,
    required this.detailLinks,
    required this.howItWorks,
    required this.campaignHistory,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String referralCode;
  final String referralLink;
  final ReferralHomeStatsDraft stats;
  final ReferralTierRuleDraft currentTier;
  final ReferralTierRuleDraft? nextTier;
  final ReferralCampaignDraft campaign;
  final List<ReferralSocialProofDraft> socialProof;
  final List<ReferralMilestoneDraft> milestones;
  final List<ReferralPendingCommissionDraft> pendingCommissions;
  final List<ReferralLeaderboardDraft> leaderboard;
  final List<ReferralDetailLinkDraft> detailLinks;
  final List<ReferralStepDraft> howItWorks;
  final List<ReferralCampaignHistoryDraft> campaignHistory;
  final String contractNotes;
  final Set<ReferralScreenState> supportedStates;
}

final class ReferralRewardsSnapshot {
  const ReferralRewardsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.totalCommission,
    required this.pendingCommission,
    required this.kycBonusTotal,
    required this.tradeCommissionTotal,
    required this.thisMonthCommission,
    required this.tierName,
    required this.tierNameEn,
    required this.chartPoints,
    required this.filters,
    required this.sortOptions,
    required this.records,
    required this.filter,
    required this.sort,
    required this.completedCount,
    required this.pendingCount,
    required this.exportRanges,
    required this.disputeTypes,
    required this.disputes,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final double totalCommission;
  final double pendingCommission;
  final double kycBonusTotal;
  final double tradeCommissionTotal;
  final double thisMonthCommission;
  final String tierName;
  final String tierNameEn;
  final List<ReferralChartPointDraft> chartPoints;
  final List<ReferralRewardFilterDraft> filters;
  final List<ReferralRewardSortDraft> sortOptions;
  final List<ReferralRewardRecordDraft> records;
  final ReferralRewardFilter filter;
  final ReferralRewardSort sort;
  final int completedCount;
  final int pendingCount;
  final List<ReferralExportRangeDraft> exportRanges;
  final List<ReferralDisputeTypeDraft> disputeTypes;
  final List<ReferralDisputeDraft> disputes;
  final String contractNotes;
  final Set<ReferralScreenState> supportedStates;
}

final class ReferralRulesSnapshot {
  const ReferralRulesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.tiers,
    required this.rewardTypes,
    required this.terms,
    required this.faqs,
    required this.disclaimer,
    required this.currentTierIndex,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<ReferralTierRuleDraft> tiers;
  final List<ReferralRewardTypeRuleDraft> rewardTypes;
  final List<String> terms;
  final List<ReferralFaqDraft> faqs;
  final String disclaimer;
  final int currentTierIndex;
  final String contractNotes;
  final Set<ReferralScreenState> supportedStates;
}

final class ReferralFriendDetailSnapshot {
  const ReferralFriendDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.friendId,
    required this.found,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.listRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String friendId;
  final bool found;
  final String emptyTitle;
  final String emptyMessage;
  final String listRoute;
  final String contractNotes;
  final Set<ReferralScreenState> supportedStates;
}

final class ReferralStatsDraft {
  const ReferralStatsDraft({
    required this.totalFriends,
    required this.kycCompleted,
    required this.activeFriends,
  });

  final int totalFriends;
  final int kycCompleted;
  final int activeFriends;
}

final class ReferralHomeStatsDraft {
  const ReferralHomeStatsDraft({
    required this.totalFriends,
    required this.kycCompleted,
    required this.activeFriends,
    required this.totalCommission,
    required this.pendingCommission,
    required this.totalVolume,
    required this.thisMonthCommission,
    required this.thisMonthFriends,
  });

  final int totalFriends;
  final int kycCompleted;
  final int activeFriends;
  final double totalCommission;
  final double pendingCommission;
  final double totalVolume;
  final double thisMonthCommission;
  final int thisMonthFriends;
}

final class ReferralFilterDraft {
  const ReferralFilterDraft({
    required this.filter,
    required this.label,
    required this.count,
  });

  final ReferralFriendFilter filter;
  final String label;
  final int count;
}

final class ReferralSortDraft {
  const ReferralSortDraft({required this.sort, required this.label});

  final ReferralHistorySort sort;
  final String label;
}

final class ReferralFriendDraft {
  const ReferralFriendDraft({
    required this.id,
    required this.initial,
    required this.name,
    required this.joinedDate,
    required this.status,
    required this.totalCommission,
    required this.totalVolume,
    required this.firstTradeDate,
    required this.route,
  });

  final String id;
  final String initial;
  final String name;
  final String joinedDate;
  final ReferralFriendStatus status;
  final double totalCommission;
  final double totalVolume;
  final String? firstTradeDate;
  final String route;

  bool get kycCompleted => status != ReferralFriendStatus.pendingKyc;
  bool get canRemindKyc => status == ReferralFriendStatus.pendingKyc;
}

final class ReferralChartPointDraft {
  const ReferralChartPointDraft({
    required this.month,
    required this.commission,
  });

  final String month;
  final double commission;
}

final class ReferralRewardFilterDraft {
  const ReferralRewardFilterDraft({required this.filter, required this.label});

  final ReferralRewardFilter filter;
  final String label;
}

final class ReferralRewardSortDraft {
  const ReferralRewardSortDraft({required this.sort, required this.label});

  final ReferralRewardSort sort;
  final String label;
}

final class ReferralRewardRecordDraft {
  const ReferralRewardRecordDraft({
    required this.id,
    required this.friendName,
    required this.friendInitial,
    required this.type,
    required this.amount,
    required this.currency,
    required this.action,
    required this.date,
    required this.status,
  });

  final String id;
  final String friendName;
  final String friendInitial;
  final ReferralRewardType type;
  final double amount;
  final String currency;
  final String action;
  final String date;
  final ReferralRewardStatus status;
}

final class ReferralExportRangeDraft {
  const ReferralExportRangeDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class ReferralDisputeTypeDraft {
  const ReferralDisputeTypeDraft({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class ReferralDisputeDraft {
  const ReferralDisputeDraft({
    required this.id,
    required this.typeId,
    required this.description,
    required this.statusLabel,
    required this.createdDate,
    required this.resolvedDate,
    required this.resolution,
  });

  final String id;
  final String typeId;
  final String description;
  final String statusLabel;
  final String createdDate;
  final String? resolvedDate;
  final String? resolution;
}

final class ReferralTierRuleDraft {
  const ReferralTierRuleDraft({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.minFriends,
    required this.commissionPercent,
    required this.kycBonus,
  });

  final String id;
  final String name;
  final String nameEn;
  final int minFriends;
  final int commissionPercent;
  final double kycBonus;
}

final class ReferralRewardTypeRuleDraft {
  const ReferralRewardTypeRuleDraft({
    required this.id,
    required this.title,
    required this.body,
    required this.highlight,
  });

  final String id;
  final String title;
  final String body;
  final String highlight;
}

final class ReferralFaqDraft {
  const ReferralFaqDraft({required this.question, required this.answer});

  final String question;
  final String answer;
}

final class ReferralCampaignDraft {
  const ReferralCampaignDraft({
    required this.title,
    required this.description,
    required this.bonusLabel,
    required this.daysLeft,
    required this.totalParticipants,
    required this.extraReward,
    required this.bonusMultiplier,
  });

  final String title;
  final String description;
  final String bonusLabel;
  final int daysLeft;
  final int totalParticipants;
  final String extraReward;
  final int bonusMultiplier;
}

final class ReferralSocialProofDraft {
  const ReferralSocialProofDraft({required this.value, required this.label});

  final String value;
  final String label;
}

final class ReferralMilestoneDraft {
  const ReferralMilestoneDraft({
    required this.id,
    required this.friends,
    required this.reward,
    required this.description,
    required this.claimed,
  });

  final String id;
  final int friends;
  final String reward;
  final String description;
  final bool claimed;
}

final class ReferralPendingCommissionDraft {
  const ReferralPendingCommissionDraft({
    required this.id,
    required this.friendName,
    required this.friendInitial,
    required this.amount,
    required this.currency,
    required this.reason,
    required this.reasonDetail,
    required this.eta,
    required this.progress,
  });

  final String id;
  final String friendName;
  final String friendInitial;
  final double amount;
  final String currency;
  final String reason;
  final String reasonDetail;
  final String eta;
  final int progress;
}

final class ReferralLeaderboardDraft {
  const ReferralLeaderboardDraft({
    required this.rank,
    required this.name,
    required this.friends,
    required this.totalEarned,
    required this.tier,
  });

  final int rank;
  final String name;
  final int friends;
  final double totalEarned;
  final String tier;
}

final class ReferralDetailLinkDraft {
  const ReferralDetailLinkDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final String id;
  final String title;
  final String subtitle;
  final String route;
}

final class ReferralStepDraft {
  const ReferralStepDraft({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

final class ReferralCampaignHistoryDraft {
  const ReferralCampaignHistoryDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.bonusLabel,
    required this.dateRange,
    required this.statusLabel,
    required this.participants,
    required this.result,
  });

  final String id;
  final String title;
  final String description;
  final String bonusLabel;
  final String dateRange;
  final String statusLabel;
  final int participants;
  final String result;
}
