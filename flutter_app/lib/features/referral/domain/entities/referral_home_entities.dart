part of 'referral_entities.dart';

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
