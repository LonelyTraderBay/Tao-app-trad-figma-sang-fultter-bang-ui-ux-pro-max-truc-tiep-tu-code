part of 'p2p_entities.dart';

final class P2PMerchantProfileSnapshot {
  const P2PMerchantProfileSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.merchantId,
    required this.merchant,
    required this.ads,
    required this.reviews,
    required this.reportRoute,
    required this.blacklistAddRoute,
    required this.emptyAdsTitle,
    required this.emptyReviewsTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String merchantId;
  final P2PMerchantProfileDraft merchant;
  final List<P2PMerchantProfileAdDraft> ads;
  final List<P2PMerchantProfileReviewDraft> reviews;
  final String reportRoute;
  final String blacklistAddRoute;
  final String emptyAdsTitle;
  final String emptyReviewsTitle;
  final String contractNotes;

  int get positiveReviewCount =>
      (merchant.totalTrades * merchant.positiveRate / 100).round();
}

final class P2PMerchantProfileDraft {
  const P2PMerchantProfileDraft({
    required this.id,
    required this.name,
    required this.level,
    required this.kycVerified,
    required this.joinDate,
    required this.totalTrades,
    required this.totalTrades30d,
    required this.completionRate,
    required this.avgReleaseTime,
    required this.avgPayTime,
    required this.totalVolume30dUsd,
    required this.isOnline,
    required this.lastActive,
    required this.positiveRate,
    required this.negativeCount,
    required this.activeAds,
    this.isBlocked = false,
    this.isFollowed = false,
  });

  final String id;
  final String name;
  final int level;
  final bool kycVerified;
  final String joinDate;
  final int totalTrades;
  final int totalTrades30d;
  final double completionRate;
  final String avgReleaseTime;
  final String avgPayTime;
  final int totalVolume30dUsd;
  final bool isOnline;
  final String lastActive;
  final double positiveRate;
  final int negativeCount;
  final int activeAds;
  final bool isBlocked;
  final bool isFollowed;
}

final class P2PMerchantProfileAdDraft {
  const P2PMerchantProfileAdDraft({
    required this.id,
    required this.merchantId,
    required this.type,
    required this.asset,
    required this.available,
    required this.price,
    required this.minLimit,
    required this.maxLimit,
    required this.paymentMethods,
  });

  final String id;
  final String merchantId;
  final P2PTradeType type;
  final String asset;
  final double available;
  final int price;
  final int minLimit;
  final int maxLimit;
  final List<String> paymentMethods;
}

final class P2PMerchantProfileReviewDraft {
  const P2PMerchantProfileReviewDraft({
    required this.id,
    required this.fromUser,
    required this.toUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.positive,
  });

  final String id;
  final String fromUser;
  final String toUserId;
  final int rating;
  final String comment;
  final String createdAt;
  final bool positive;
}

final class P2PReportMerchantSnapshot {
  const P2PReportMerchantSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.merchantId,
    required this.merchant,
    required this.reasons,
    required this.blacklistAddRoute,
    required this.merchantProfileRoute,
    required this.detailPrompt,
    required this.reviewNotice,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String merchantId;
  final P2PMerchantProfileDraft merchant;
  final List<P2PReportReasonDraft> reasons;
  final String blacklistAddRoute;
  final String merchantProfileRoute;
  final String detailPrompt;
  final String reviewNotice;
  final String emptyTitle;
  final String contractNotes;
}

enum P2PReportReasonTone { danger, purple, warning, info, neutral }

final class P2PReportReasonDraft {
  const P2PReportReasonDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.tone,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final P2PReportReasonTone tone;
}

final class P2PTradingLevelSnapshot {
  const P2PTradingLevelSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.userLevel,
    required this.currentLevel,
    required this.levels,
    required this.upgradeRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PUserTradingLevelDraft userLevel;
  final P2PTradingLevelDraft currentLevel;
  final List<P2PTradingLevelDraft> levels;
  final String upgradeRoute;
  final String emptyTitle;
  final String contractNotes;

  int get dailyUsagePercent =>
      (userLevel.dailyUsed / userLevel.dailyLimit * 100).round();
}

final class P2PReviewsSnapshot {
  const P2PReviewsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.receivedReviews,
    required this.givenReviews,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PReviewDraft> receivedReviews;
  final List<P2PReviewDraft> givenReviews;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PReviewDraft {
  const P2PReviewDraft({
    required this.id,
    required this.orderId,
    required this.fromUser,
    required this.fromUserId,
    required this.toUser,
    required this.toUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.positive,
    this.reply,
  });

  final String id;
  final String orderId;
  final String fromUser;
  final String fromUserId;
  final String toUser;
  final String toUserId;
  final int rating;
  final String comment;
  final String createdAt;
  final bool positive;
  final String? reply;
}

final class P2PUserTradingLevelDraft {
  const P2PUserTradingLevelDraft({
    required this.currentLevel,
    required this.completedOrders,
    required this.accumulatedVolume,
    required this.dailyUsed,
    required this.dailyLimit,
    required this.fee,
    required this.nextLevelProgress,
  });

  final int currentLevel;
  final int completedOrders;
  final int accumulatedVolume;
  final int dailyUsed;
  final int dailyLimit;
  final double fee;
  final double nextLevelProgress;
}

final class P2PTradingLevelDraft {
  const P2PTradingLevelDraft({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.fee,
    required this.dailyLimit,
    required this.perOrderLimit,
    required this.requirements,
  });

  final int id;
  final String name;
  final String nameVi;
  final double fee;
  final int dailyLimit;
  final int perOrderLimit;
  final List<String> requirements;
}

final class P2PMerchantApplySnapshot {
  const P2PMerchantApplySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.stats,
    required this.benefits,
    required this.requirements,
    required this.businessTypes,
    required this.documents,
    required this.reviewSteps,
    required this.securityNote,
    required this.reviewNotice,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PMerchantStatsDraft stats;
  final List<P2PMerchantBenefitDraft> benefits;
  final List<P2PMerchantRequirementDraft> requirements;
  final List<String> businessTypes;
  final List<P2PMerchantDocumentDraft> documents;
  final List<String> reviewSteps;
  final String securityNote;
  final String reviewNotice;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  bool get allRequirementsMet => requirements.every((item) => item.met);
}

final class P2PMerchantStatsDraft {
  const P2PMerchantStatsDraft({
    required this.totalTrades,
    required this.completionRate,
    required this.avgResponseTime,
    required this.accountAgeDays,
    required this.volume30dVnd,
    required this.disputes,
    required this.kycLevel,
  });

  final int totalTrades;
  final double completionRate;
  final String avgResponseTime;
  final int accountAgeDays;
  final int volume30dVnd;
  final int disputes;
  final int kycLevel;
}

final class P2PMerchantBenefitDraft {
  const P2PMerchantBenefitDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconKey,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconKey;
  final String toneKey;
}

final class P2PMerchantRequirementDraft {
  const P2PMerchantRequirementDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.met,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String value;
  final bool met;
  final String iconKey;
}

final class P2PMerchantDocumentDraft {
  const P2PMerchantDocumentDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.required,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final bool required;
  final String iconKey;
}
