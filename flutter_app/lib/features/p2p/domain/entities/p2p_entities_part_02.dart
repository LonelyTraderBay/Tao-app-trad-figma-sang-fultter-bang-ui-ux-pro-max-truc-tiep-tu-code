part of 'p2p_entities.dart';

final class P2PDisputeEvidenceSnapshot {
  const P2PDisputeEvidenceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.disputeId,
    required this.title,
    required this.subtitle,
    required this.documents,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String disputeId;
  final String title;
  final String subtitle;
  final List<P2PDisputeEvidenceDocumentDraft> documents;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PDisputeEvidenceDocumentDraft {
  const P2PDisputeEvidenceDocumentDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.uploaded,
  });

  final String id;
  final String label;
  final String iconKey;
  final bool uploaded;
}

final class P2PDisputeResolutionSnapshot {
  const P2PDisputeResolutionSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.disputeId,
    required this.resultTitle,
    required this.disputeLabel,
    required this.refundAmountLabel,
    required this.reason,
    required this.mediator,
    required this.resolvedAt,
    required this.appealDeadline,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String disputeId;
  final String resultTitle;
  final String disputeLabel;
  final String refundAmountLabel;
  final String reason;
  final String mediator;
  final String resolvedAt;
  final String appealDeadline;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PDisputeOpenSnapshot {
  const P2PDisputeOpenSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.orderId,
    required this.title,
    required this.subtitle,
    required this.reasons,
    required this.descriptionLabel,
    required this.descriptionPlaceholder,
    required this.uploadTitle,
    required this.uploadSubtitle,
    required this.targetDisputeId,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String orderId;
  final String title;
  final String subtitle;
  final List<String> reasons;
  final String descriptionLabel;
  final String descriptionPlaceholder;
  final String uploadTitle;
  final String uploadSubtitle;
  final String targetDisputeId;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PDisputesSnapshot {
  const P2PDisputesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.disputes,
    required this.noticeTitle,
    required this.notice,
    required this.guideTitle,
    required this.guideSteps,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PDisputeListItemDraft> disputes;
  final String noticeTitle;
  final String notice;
  final String guideTitle;
  final List<String> guideSteps;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  int get totalCount => disputes.length;

  int get activeCount =>
      disputes.where((item) => item.status != P2PDisputeStatus.resolved).length;

  int get resolvedCount =>
      disputes.where((item) => item.status == P2PDisputeStatus.resolved).length;
}

final class P2PDisputeListItemDraft {
  const P2PDisputeListItemDraft({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.reason,
    required this.createdAt,
    required this.evidenceCount,
    required this.timelineCount,
  });

  final String id;
  final String orderId;
  final String orderNumber;
  final P2PDisputeStatus status;
  final String statusLabel;
  final String reason;
  final String createdAt;
  final int evidenceCount;
  final int timelineCount;

  String get shortOrderNumber {
    if (orderNumber.length <= 6) return orderNumber;
    return orderNumber.substring(orderNumber.length - 6);
  }
}

final class P2PAdAnalyticsSnapshot {
  const P2PAdAnalyticsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.adId,
    required this.sourceAdId,
    required this.tradeType,
    required this.asset,
    required this.currency,
    required this.priceVnd,
    required this.ranking,
    required this.totalActiveAds,
    required this.impressions,
    required this.clicks,
    required this.ordersCreated,
    required this.ordersCompleted,
    required this.ordersDisputed,
    required this.ordersCancelled,
    required this.totalVolume,
    required this.totalRevenue,
    required this.avgOrderValue,
    required this.avgResponseTimeSeconds,
    required this.avgCompletionMinutes,
    required this.conversionRate,
    required this.completionRate,
    required this.rating,
    required this.reviewsCount,
    required this.dailyPerformance,
    required this.hourlyHeatmap,
    required this.paymentBreakdown,
    required this.competitorComparison,
    required this.optimizationTips,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String adId;
  final String sourceAdId;
  final P2PTradeType tradeType;
  final String asset;
  final String currency;
  final int priceVnd;
  final int ranking;
  final int totalActiveAds;
  final int impressions;
  final int clicks;
  final int ordersCreated;
  final int ordersCompleted;
  final int ordersDisputed;
  final int ordersCancelled;
  final int totalVolume;
  final int totalRevenue;
  final int avgOrderValue;
  final int avgResponseTimeSeconds;
  final double avgCompletionMinutes;
  final double conversionRate;
  final double completionRate;
  final double rating;
  final int reviewsCount;
  final List<P2PAdDailyPerformanceDraft> dailyPerformance;
  final List<P2PAdHourlyHeatmapDraft> hourlyHeatmap;
  final List<P2PAdPaymentBreakdownDraft> paymentBreakdown;
  final List<P2PAdCompetitorComparisonDraft> competitorComparison;
  final List<P2PAdOptimizationTipDraft> optimizationTips;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PAdDailyPerformanceDraft {
  const P2PAdDailyPerformanceDraft({
    required this.date,
    required this.impressions,
    required this.orders,
    required this.volume,
  });

  final String date;
  final int impressions;
  final int orders;
  final int volume;
}

final class P2PAdHourlyHeatmapDraft {
  const P2PAdHourlyHeatmapDraft({required this.hour, required this.orders});

  final int hour;
  final int orders;
}

final class P2PAdPaymentBreakdownDraft {
  const P2PAdPaymentBreakdownDraft({
    required this.method,
    required this.count,
    required this.volume,
  });

  final String method;
  final int count;
  final int volume;
}

final class P2PAdCompetitorComparisonDraft {
  const P2PAdCompetitorComparisonDraft({
    required this.metric,
    required this.yours,
    required this.average,
    required this.top,
  });

  final String metric;
  final double yours;
  final double average;
  final double top;
}

final class P2PAdOptimizationTipDraft {
  const P2PAdOptimizationTipDraft({
    required this.tone,
    required this.iconKey,
    required this.text,
  });

  final String tone;
  final String iconKey;
  final String text;
}

final class P2PAdDetailSnapshot {
  const P2PAdDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.adId,
    required this.sourceAdId,
    required this.ad,
    required this.marketPriceVnd,
    required this.priceDiffPct,
    required this.trustScore,
    required this.trustLabel,
    required this.viewerCount,
    required this.totalVolume30dUsd,
    required this.availableAmount,
    required this.paymentWindowMinutes,
    required this.minKycLevel,
    required this.minCompletedTrades,
    required this.remarks,
    required this.tradingHours,
    required this.targetOrderId,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String adId;
  final String sourceAdId;
  final P2PAdDraft ad;
  final int marketPriceVnd;
  final double priceDiffPct;
  final int trustScore;
  final String trustLabel;
  final int viewerCount;
  final int totalVolume30dUsd;
  final double availableAmount;
  final int paymentWindowMinutes;
  final int minKycLevel;
  final int minCompletedTrades;
  final String remarks;
  final String tradingHours;
  final String targetOrderId;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

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
