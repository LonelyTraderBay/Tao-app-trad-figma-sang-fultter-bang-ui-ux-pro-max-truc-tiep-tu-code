enum P2PTradeType { buy, sell }

enum P2PScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  realtimeRefresh,
}

enum P2POrderTimelineStatus { completed, pending, failed }

enum P2PMyAdStatus { active, paused, expired }

enum P2PEscrowOrderType { buy, sell }

enum P2PEscrowOrderStatus { pendingPayment, paid, pendingRelease, dispute }

enum P2PKycTierStatus { locked, available, current, pending }

enum P2PKycVerificationStatus { approved, pending, rejected, incomplete }

enum P2PKycStepStatus { completed, pending, rejected, waiting, processing }

enum P2PSecurityStatus { enabled, warning, disabled }

enum P2PSecurityEventSeverity { info, warning, critical }

final class P2PHomeSnapshot {
  const P2PHomeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.defaultTradeType,
    required this.selectedTradeType,
    required this.selectedAsset,
    required this.selectedFiat,
    required this.assets,
    required this.fiatCurrencies,
    required this.searchHint,
    required this.quickActions,
    required this.platformStats,
    required this.ads,
    required this.expressRoute,
    required this.createRoute,
    required this.myOrdersRoute,
    required this.tradingLevelRoute,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final P2PTradeType defaultTradeType;
  final P2PTradeType selectedTradeType;
  final String selectedAsset;
  final String selectedFiat;
  final List<String> assets;
  final List<String> fiatCurrencies;
  final String searchHint;
  final List<P2PHomeQuickActionDraft> quickActions;
  final P2PHomePlatformStatsDraft platformStats;
  final List<P2PAdDraft> ads;
  final String expressRoute;
  final String createRoute;
  final String myOrdersRoute;
  final String tradingLevelRoute;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PHomeQuickActionDraft {
  const P2PHomeQuickActionDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconKey,
    required this.route,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconKey;
  final String route;
  final String toneKey;
}

final class P2PHomePlatformStatsDraft {
  const P2PHomePlatformStatsDraft({
    required this.volume24h,
    required this.volume24hChange,
    required this.totalTrades24h,
    required this.activeMerchants,
    required this.onlineTraders,
    required this.avgCompletionRate,
    required this.avgCompletionTime,
    required this.escrowProtected,
  });

  final int volume24h;
  final double volume24hChange;
  final int totalTrades24h;
  final int activeMerchants;
  final int onlineTraders;
  final double avgCompletionRate;
  final String avgCompletionTime;
  final int escrowProtected;
}

final class P2PExpressConfirmSnapshot {
  const P2PExpressConfirmSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.tradeType,
    required this.asset,
    required this.fiatAmount,
    required this.cryptoAmount,
    required this.paymentMethod,
    required this.ad,
    required this.order,
    required this.escrowNote,
    required this.warningNote,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PTradeType tradeType;
  final String asset;
  final double fiatAmount;
  final double cryptoAmount;
  final String paymentMethod;
  final P2PAdDraft ad;
  final P2POrderDraft order;
  final String escrowNote;
  final String warningNote;
  final String contractNotes;

  bool get isBuy => tradeType == P2PTradeType.buy;
}

final class P2PExpressSnapshot {
  const P2PExpressSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.assets,
    required this.quickAmountsVnd,
    required this.paymentMethods,
    required this.ads,
    required this.escrowTitle,
    required this.escrowBuyNote,
    required this.escrowSellNote,
    required this.steps,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PAssetDraft> assets;
  final List<int> quickAmountsVnd;
  final List<P2PPaymentMethodDraft> paymentMethods;
  final List<P2PAdDraft> ads;
  final String escrowTitle;
  final String escrowBuyNote;
  final String escrowSellNote;
  final List<P2PExpressStepDraft> steps;
  final String contractNotes;

  P2PAssetDraft assetBySymbol(String symbol) {
    return assets.firstWhere(
      (asset) => asset.symbol == symbol,
      orElse: () => assets.first,
    );
  }

  List<P2PAdDraft> topAds({
    required P2PTradeType tradeType,
    required String asset,
    required int fiatAmount,
  }) {
    final adType = tradeType == P2PTradeType.buy
        ? P2PTradeType.sell
        : P2PTradeType.buy;
    final candidates =
        ads
            .where((ad) => ad.type == adType && ad.asset == asset && ad.active)
            .where(
              (ad) =>
                  fiatAmount <= 0 ||
                  (fiatAmount >= ad.minLimit && fiatAmount <= ad.maxLimit),
            )
            .toList()
          ..sort(
            (a, b) => tradeType == P2PTradeType.buy
                ? a.price.compareTo(b.price)
                : b.price.compareTo(a.price),
          );
    return candidates.take(3).toList();
  }

  P2PAdDraft? bestAd({
    required P2PTradeType tradeType,
    required String asset,
    required int fiatAmount,
    String? paymentMethod,
  }) {
    if (fiatAmount <= 0) return null;
    final candidates =
        topAds(
          tradeType: tradeType,
          asset: asset,
          fiatAmount: fiatAmount,
        ).where(
          (ad) =>
              paymentMethod == null ||
              paymentMethod.isEmpty ||
              ad.paymentMethods.contains(paymentMethod),
        );
    return candidates.isEmpty ? null : candidates.first;
  }
}

final class P2POrderTimelineSnapshot {
  const P2POrderTimelineSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.order,
    required this.events,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderDraft order;
  final List<P2POrderTimelineEventDraft> events;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2POrderRateSnapshot {
  const P2POrderRateSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.order,
    required this.quickTags,
    required this.successTitle,
    required this.successMessage,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderRateDraft order;
  final List<P2POrderRateTagDraft> quickTags;
  final String successTitle;
  final String successMessage;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2POrderCancelSnapshot {
  const P2POrderCancelSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.order,
    required this.reasons,
    required this.warningTitle,
    required this.warningMessage,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderCancelDraft order;
  final List<String> reasons;
  final String warningTitle;
  final String warningMessage;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2POrderProofSnapshot {
  const P2POrderProofSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.order,
    required this.uploadTitle,
    required this.uploadSubtitle,
    required this.tipsTitle,
    required this.tips,
    required this.warningMessage,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderProofDraft order;
  final String uploadTitle;
  final String uploadSubtitle;
  final String tipsTitle;
  final List<String> tips;
  final String warningMessage;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2POrderSnapshot {
  const P2POrderSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.order,
    required this.safetyTitle,
    required this.safetyBullets,
    required this.paymentFields,
    required this.timeline,
    required this.quickActions,
    required this.transferWarningTitle,
    required this.transferWarning,
    required this.paymentWarning,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderDetailDraft order;
  final String safetyTitle;
  final List<String> safetyBullets;
  final List<P2POrderPaymentFieldDraft> paymentFields;
  final List<P2POrderTimelineStepDraft> timeline;
  final List<P2POrderQuickActionDraft> quickActions;
  final String transferWarningTitle;
  final String transferWarning;
  final String paymentWarning;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

final class P2PChatSnapshot {
  const P2PChatSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.orderId,
    required this.orderNumber,
    required this.merchant,
    required this.merchantInitial,
    required this.activeLabel,
    required this.warning,
    required this.e2eTitle,
    required this.e2eSubtitle,
    required this.encryptionPill,
    required this.messages,
    required this.quickReplies,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String orderId;
  final String orderNumber;
  final String merchant;
  final String merchantInitial;
  final String activeLabel;
  final String warning;
  final String e2eTitle;
  final String e2eSubtitle;
  final String encryptionPill;
  final List<P2PChatMessageDraft> messages;
  final List<String> quickReplies;
  final String contractNotes;
}

enum P2PChatSender { system, me, other }

final class P2PChatMessageDraft {
  const P2PChatMessageDraft({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
    this.isRead = true,
  });

  final String id;
  final P2PChatSender sender;
  final String text;
  final String time;
  final bool isRead;
}

final class P2PDisputeDetailSnapshot {
  const P2PDisputeDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.dispute,
    required this.levels,
    required this.evidence,
    required this.timeline,
    required this.supportMessages,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PDisputeDraft dispute;
  final List<P2PDisputeLevelDraft> levels;
  final List<P2PDisputeEvidenceDraft> evidence;
  final List<P2PDisputeTimelineDraft> timeline;
  final List<P2PDisputeSupportMessageDraft> supportMessages;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  P2PDisputeLevelDraft levelByNumber(int level) {
    return levels.firstWhere(
      (item) => item.level == level,
      orElse: () => levels.first,
    );
  }
}

enum P2PDisputeStatus { submitted, underReview, resolved, rejected }

enum P2PDisputeMessageSender { user, support }

final class P2PDisputeDraft {
  const P2PDisputeDraft({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.reason,
    required this.description,
    required this.currentLevel,
  });

  final String id;
  final String orderId;
  final String orderNumber;
  final P2PDisputeStatus status;
  final String statusLabel;
  final String reason;
  final String description;
  final int currentLevel;
}

final class P2PDisputeLevelDraft {
  const P2PDisputeLevelDraft({
    required this.level,
    required this.shortLabel,
    required this.label,
    required this.description,
    required this.avgTime,
    required this.iconKey,
  });

  final int level;
  final String shortLabel;
  final String label;
  final String description;
  final String avgTime;
  final String iconKey;
}

final class P2PDisputeEvidenceDraft {
  const P2PDisputeEvidenceDraft({required this.id, required this.fileName});

  final String id;
  final String fileName;
}

final class P2PDisputeTimelineDraft {
  const P2PDisputeTimelineDraft({
    required this.id,
    required this.event,
    required this.time,
    this.detail,
    this.active = false,
  });

  final String id;
  final String event;
  final String time;
  final String? detail;
  final bool active;
}

final class P2PDisputeSupportMessageDraft {
  const P2PDisputeSupportMessageDraft({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
  });

  final String id;
  final P2PDisputeMessageSender sender;
  final String text;
  final String time;
}

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

final class P2PPaymentMethodAddSnapshot {
  const P2PPaymentMethodAddSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.bankOptions,
    required this.ewalletOptions,
    required this.defaultBankAccountHint,
    required this.defaultEwalletAccountHint,
    required this.ownerNameHint,
    required this.saveRoute,
    required this.securityNote,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<String> bankOptions;
  final List<String> ewalletOptions;
  final String defaultBankAccountHint;
  final String defaultEwalletAccountHint;
  final String ownerNameHint;
  final String saveRoute;
  final String securityNote;
  final String confirmTitle;
  final String confirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentMethodVerificationSnapshot {
  const P2PPaymentMethodVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methodId,
    required this.methods,
    required this.microDepositSteps,
    required this.warningNote,
    required this.saveRoute,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String methodId;
  final List<P2PPaymentVerificationMethodDraft> methods;
  final List<String> microDepositSteps;
  final String warningNote;
  final String saveRoute;
  final String confirmTitle;
  final String confirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentVerificationMethodDraft {
  const P2PPaymentVerificationMethodDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.duration,
    required this.iconKey,
    this.recommended = false,
  });

  final String id;
  final String label;
  final String description;
  final String duration;
  final String iconKey;
  final bool recommended;
}

final class P2PPaymentMethodOwnershipSnapshot {
  const P2PPaymentMethodOwnershipSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methodId,
    required this.documents,
    required this.saveRoute,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String methodId;
  final List<P2POwnershipDocumentDraft> documents;
  final String saveRoute;
  final String confirmTitle;
  final String confirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2POwnershipDocumentDraft {
  const P2POwnershipDocumentDraft({
    required this.id,
    required this.label,
    this.optional = false,
  });

  final String id;
  final String label;
  final bool optional;
}

final class P2PPaymentMethodCoolingPeriodSnapshot {
  const P2PPaymentMethodCoolingPeriodSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.addedAt,
    required this.availableAt,
    required this.hoursRemaining,
    required this.reason,
    required this.reasons,
    required this.waitTitle,
    required this.waitMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String addedAt;
  final String availableAt;
  final int hoursRemaining;
  final String reason;
  final List<String> reasons;
  final String waitTitle;
  final String waitMessage;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentMethodHistorySnapshot {
  const P2PPaymentMethodHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalTransactions,
    required this.totalVolume,
    required this.successRate,
    required this.transactions,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int totalTransactions;
  final int totalVolume;
  final double successRate;
  final List<P2PPaymentHistoryTransactionDraft> transactions;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PPaymentHistoryTransactionDraft {
  const P2PPaymentHistoryTransactionDraft({
    required this.id,
    required this.orderId,
    required this.type,
    required this.amount,
    required this.status,
    required this.timestamp,
  });

  final String id;
  final String orderId;
  final P2PTradeType type;
  final int amount;
  final String status;
  final String timestamp;
}

final class P2PPaymentMethodsSnapshot {
  const P2PPaymentMethodsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methods,
    required this.addBankRoute,
    required this.addEwalletRoute,
    required this.securityNote,
    required this.deleteConfirmTitle,
    required this.deleteConfirmMessage,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PPaymentListMethodDraft> methods;
  final String addBankRoute;
  final String addEwalletRoute;
  final String securityNote;
  final String deleteConfirmTitle;
  final String deleteConfirmMessage;
  final String emptyTitle;
  final String contractNotes;
}

enum P2PPaymentListMethodType { bank, ewallet }

final class P2PPaymentListMethodDraft {
  const P2PPaymentListMethodDraft({
    required this.id,
    required this.type,
    required this.name,
    required this.accountNumber,
    required this.accountName,
    required this.isVerified,
    this.isDefault = false,
  });

  final String id;
  final P2PPaymentListMethodType type;
  final String name;
  final String accountNumber;
  final String accountName;
  final bool isVerified;
  final bool isDefault;

  P2PPaymentListMethodDraft copyWith({bool? isDefault}) {
    return P2PPaymentListMethodDraft(
      id: id,
      type: type,
      name: name,
      accountNumber: accountNumber,
      accountName: accountName,
      isVerified: isVerified,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

final class P2PInsuranceFundSnapshot {
  const P2PInsuranceFundSnapshot({
    required this.endpoint,
    required this.legacyEndpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalFund,
    required this.activeClaims,
    required this.totalContributed,
    required this.totalPaid,
    required this.userCoveragePct,
    required this.tierName,
    required this.contributionRate,
    required this.outstandingClaimsAmount,
    required this.solvencyRatio,
    required this.healthStatus,
    required this.lastAuditDate,
    required this.auditorName,
    required this.nextAuditDate,
    required this.maxClaimPerPeriod,
    required this.approvalRate,
    required this.avgResolutionHours,
    required this.eligibilityItems,
    required this.coverageTiers,
    required this.notificationPrefs,
    required this.claims,
    required this.chartPoints,
    required this.certificateRoute,
    required this.contributionHistoryRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String legacyEndpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int totalFund;
  final int activeClaims;
  final int totalContributed;
  final int totalPaid;
  final int userCoveragePct;
  final String tierName;
  final String contributionRate;
  final int outstandingClaimsAmount;
  final double solvencyRatio;
  final String healthStatus;
  final String lastAuditDate;
  final String auditorName;
  final String nextAuditDate;
  final int maxClaimPerPeriod;
  final double approvalRate;
  final int avgResolutionHours;
  final List<P2PInsuranceEligibilityItemDraft> eligibilityItems;
  final List<P2PInsuranceCoverageTierDraft> coverageTiers;
  final List<P2PInsuranceNotificationPrefDraft> notificationPrefs;
  final List<P2PInsuranceClaimDraft> claims;
  final List<P2PInsuranceChartPointDraft> chartPoints;
  final String certificateRoute;
  final String contributionHistoryRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PInsuranceEligibilityItemDraft {
  const P2PInsuranceEligibilityItemDraft({
    required this.label,
    this.value,
    this.highlight = false,
  });

  final String label;
  final String? value;
  final bool highlight;
}

final class P2PInsuranceCoverageTierDraft {
  const P2PInsuranceCoverageTierDraft({
    required this.name,
    required this.coveragePct,
    this.bonus,
    this.highlight = false,
  });

  final String name;
  final String coveragePct;
  final String? bonus;
  final bool highlight;
}

final class P2PInsuranceNotificationPrefDraft {
  const P2PInsuranceNotificationPrefDraft({
    required this.key,
    required this.label,
    required this.description,
    required this.enabled,
  });

  final String key;
  final String label;
  final String description;
  final bool enabled;
}

enum P2PInsuranceClaimStatus { pending, reviewing, approved, rejected, paid }

final class P2PInsuranceClaimDraft {
  const P2PInsuranceClaimDraft({
    required this.id,
    required this.claimCode,
    required this.orderId,
    required this.reason,
    required this.amount,
    required this.status,
    required this.submittedAt,
    this.paidAmount,
  });

  final String id;
  final String claimCode;
  final String orderId;
  final String reason;
  final int amount;
  final int? paidAmount;
  final P2PInsuranceClaimStatus status;
  final String submittedAt;
}

final class P2PInsuranceChartPointDraft {
  const P2PInsuranceChartPointDraft({
    required this.day,
    required this.balance,
    required this.inflow,
    required this.outflow,
  });

  final String day;
  final int balance;
  final int inflow;
  final int outflow;
}

final class P2PInsuranceCertificateSnapshot {
  const P2PInsuranceCertificateSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.certId,
    required this.holderName,
    required this.holderId,
    required this.tierName,
    required this.coveragePct,
    required this.maxCoveragePerClaim,
    required this.maxCoveragePer30Days,
    required this.contributionRate,
    required this.issueDate,
    required this.validUntil,
    required this.totalContributed,
    required this.totalTransactions,
    required this.claimWindowDays,
    required this.reviewSla,
    required this.payoutSla,
    required this.auditor,
    required this.lastAuditDate,
    required this.coveredCases,
    required this.exclusions,
    required this.disclosure,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String certId;
  final String holderName;
  final String holderId;
  final String tierName;
  final int coveragePct;
  final int maxCoveragePerClaim;
  final int maxCoveragePer30Days;
  final String contributionRate;
  final String issueDate;
  final String validUntil;
  final int totalContributed;
  final int totalTransactions;
  final int claimWindowDays;
  final String reviewSla;
  final String payoutSla;
  final String auditor;
  final String lastAuditDate;
  final List<String> coveredCases;
  final List<String> exclusions;
  final String disclosure;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  String get shareText =>
      'Chứng nhận bảo hiểm: $certId - Tier $tierName ($coveragePct%)';

  String get exportText =>
      '''
CHỨNG NHẬN BẢO HIỂM GIAO DỊCH P2P
P2P Trading Insurance Certificate

Mã chứng nhận: $certId
Ngày cấp: $issueDate
Hiệu lực đến: $validUntil

Người được bảo hiểm: $holderName
Mã người dùng: $holderId
Tier: $tierName

Tỷ lệ bảo hiểm: $coveragePct% giá trị giao dịch
Hạn mức/claim: $maxCoveragePerClaim VND
Hạn mức/30 ngày: $maxCoveragePer30Days VND
Cửa sổ claim: $claimWindowDays ngày sau sự cố
Phí đóng góp: $contributionRate mỗi giao dịch

Xem xét claim: Trong $reviewSla
Chi trả: Trong $payoutSla sau khi duyệt
Kiểm toán: $auditor
Kiểm toán gần nhất: $lastAuditDate

Tổng đóng góp: $totalContributed VND
Tổng giao dịch: $totalTransactions

Phạm vi bảo vệ:
${coveredCases.map((item) => '- $item').join('\n')}

Không bao gồm:
${exclusions.map((item) => '- $item').join('\n')}
''';
}

final class P2PInsuranceScoreSnapshot {
  const P2PInsuranceScoreSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.overallScore,
    required this.maxScore,
    required this.grade,
    required this.gradeLabel,
    required this.gradeDescription,
    required this.currentTier,
    required this.factors,
    required this.quickActions,
    required this.tierRequirements,
    required this.disclosure,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int overallScore;
  final int maxScore;
  final String grade;
  final String gradeLabel;
  final String gradeDescription;
  final String currentTier;
  final List<P2PInsuranceScoreFactorDraft> factors;
  final List<P2PInsuranceScoreQuickActionDraft> quickActions;
  final List<P2PInsuranceScoreTierDraft> tierRequirements;
  final String disclosure;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get potentialGain =>
      factors.fold(0, (sum, factor) => sum + (factor.maxScore - factor.score));
}

final class P2PInsuranceScoreFactorDraft {
  const P2PInsuranceScoreFactorDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.score,
    required this.maxScore,
    required this.statusLabel,
    required this.toneKey,
    required this.iconKey,
    this.recommendation,
  });

  final String id;
  final String label;
  final String description;
  final int score;
  final int maxScore;
  final String statusLabel;
  final String toneKey;
  final String iconKey;
  final String? recommendation;
}

final class P2PInsuranceScoreQuickActionDraft {
  const P2PInsuranceScoreQuickActionDraft({
    required this.label,
    required this.gain,
    required this.toneKey,
    this.route,
  });

  final String label;
  final String gain;
  final String toneKey;
  final String? route;
}

final class P2PInsuranceScoreTierDraft {
  const P2PInsuranceScoreTierDraft({
    required this.name,
    required this.requiredScore,
    required this.coveragePct,
    required this.requirements,
    required this.isCurrent,
    required this.isUnlocked,
  });

  final String name;
  final int requiredScore;
  final String coveragePct;
  final List<String> requirements;
  final bool isCurrent;
  final bool isUnlocked;
}

final class P2PInsurancePolicySnapshot {
  const P2PInsurancePolicySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.version,
    required this.lastUpdated,
    required this.notice,
    required this.sections,
    required this.privacyNotice,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String version;
  final String lastUpdated;
  final String notice;
  final List<P2PInsurancePolicySectionDraft> sections;
  final String privacyNotice;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PInsurancePolicySectionDraft {
  const P2PInsurancePolicySectionDraft({
    required this.id,
    required this.title,
    required this.content,
  });

  final String id;
  final String title;
  final List<String> content;
}

final class P2PContributionHistorySnapshot {
  const P2PContributionHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.contributions,
    required this.contributionRateLabel,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PContributionDraft> contributions;
  final String contributionRateLabel;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get totalContributed => contributions.fold(
    0,
    (sum, contribution) => sum + contribution.contributionAmount,
  );

  int get totalTrades => contributions.length;

  int get averagePerTrade =>
      totalTrades == 0 ? 0 : (totalContributed / totalTrades).round();

  List<P2PContributionMonthDraft> get monthlyGroups {
    final grouped = <String, List<P2PContributionDraft>>{};
    for (final contribution in contributions) {
      grouped
          .putIfAbsent(contribution.monthKey, () => <P2PContributionDraft>[])
          .add(contribution);
    }

    final groups = grouped.entries.map((entry) {
      final total = entry.value.fold(
        0,
        (sum, contribution) => sum + contribution.contributionAmount,
      );
      return P2PContributionMonthDraft(
        month: entry.key,
        monthLabel: _monthLabel(entry.key),
        totalAmount: total,
        count: entry.value.length,
        contributions: entry.value,
      );
    }).toList()..sort((a, b) => b.month.compareTo(a.month));

    return groups;
  }
}

final class P2PContributionDraft {
  const P2PContributionDraft({
    required this.id,
    required this.date,
    required this.orderId,
    required this.orderAmount,
    required this.contributionAmount,
    required this.feeRate,
    required this.coin,
  });

  final String id;
  final String date;
  final String orderId;
  final int orderAmount;
  final int contributionAmount;
  final double feeRate;
  final String coin;

  String get monthKey => date.substring(0, 7);

  String get displayDate {
    final parts = date.split('-');
    if (parts.length != 3) return date;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}

final class P2PContributionMonthDraft {
  const P2PContributionMonthDraft({
    required this.month,
    required this.monthLabel,
    required this.totalAmount,
    required this.count,
    required this.contributions,
  });

  final String month;
  final String monthLabel;
  final int totalAmount;
  final int count;
  final List<P2PContributionDraft> contributions;
}

final class P2PEscrowBalanceSnapshot {
  const P2PEscrowBalanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.selectedAsset,
    required this.assets,
    required this.ordersByAsset,
    required this.title,
    required this.subtitle,
    required this.infoTitle,
    required this.infoBody,
    required this.helpTitle,
    required this.helpBullets,
    required this.parentRoute,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String selectedAsset;
  final List<P2PEscrowAssetBalanceDraft> assets;
  final Map<String, List<P2PEscrowOrderDraft>> ordersByAsset;
  final String title;
  final String subtitle;
  final String infoTitle;
  final String infoBody;
  final String helpTitle;
  final List<String> helpBullets;
  final String parentRoute;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  List<P2PEscrowOrderDraft> ordersFor(String asset) =>
      ordersByAsset[asset] ?? const <P2PEscrowOrderDraft>[];

  P2PEscrowAssetBalanceDraft assetBalance(String asset) {
    return assets.firstWhere(
      (item) => item.asset == asset,
      orElse: () => assets.first,
    );
  }
}

final class P2PEscrowAssetBalanceDraft {
  const P2PEscrowAssetBalanceDraft({
    required this.asset,
    required this.totalAmount,
    required this.orderCount,
  });

  final String asset;
  final double totalAmount;
  final int orderCount;
}

final class P2PEscrowOrderDraft {
  const P2PEscrowOrderDraft({
    required this.id,
    required this.orderId,
    required this.type,
    required this.asset,
    required this.amount,
    required this.fiatAmount,
    required this.fiatCurrency,
    required this.counterparty,
    required this.status,
    required this.lockedAt,
    required this.estimatedRelease,
    this.warning,
  });

  final String id;
  final String orderId;
  final P2PEscrowOrderType type;
  final String asset;
  final double amount;
  final int fiatAmount;
  final String fiatCurrency;
  final String counterparty;
  final P2PEscrowOrderStatus status;
  final String lockedAt;
  final String estimatedRelease;
  final String? warning;

  String get canonicalOrderId => orderId.replaceFirst('#P2P-', '');

  String get typeLabel => switch (type) {
    P2PEscrowOrderType.buy => 'MUA',
    P2PEscrowOrderType.sell => 'BÁN',
  };

  String get statusLabel => switch (status) {
    P2PEscrowOrderStatus.pendingPayment => 'Chờ thanh toán',
    P2PEscrowOrderStatus.paid => 'Đã thanh toán',
    P2PEscrowOrderStatus.pendingRelease => 'Chờ release',
    P2PEscrowOrderStatus.dispute => 'Tranh chấp',
  };
}

final class P2PEscrowDetailSnapshot {
  const P2PEscrowDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.orderId,
    required this.order,
    required this.statusLabel,
    required this.statusToneKey,
    required this.escrowAddress,
    required this.explorerRoute,
    required this.signers,
    required this.timeline,
    required this.securityTitle,
    required this.securityBody,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String orderId;
  final P2POrderDetailDraft order;
  final String statusLabel;
  final String statusToneKey;
  final String escrowAddress;
  final String explorerRoute;
  final List<P2PEscrowSignerDraft> signers;
  final List<P2PEscrowTimelineEventDraft> timeline;
  final String securityTitle;
  final String securityBody;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get signedCount => signers.where((signer) => signer.hasSigned).length;

  int get signerCount => signers.length;

  String get maskedAddress => _maskAddress(escrowAddress);
}

final class P2PEscrowSignerDraft {
  const P2PEscrowSignerDraft({
    required this.id,
    required this.role,
    required this.label,
    required this.address,
    required this.hasSigned,
    this.signedAt,
  });

  final String id;
  final String role;
  final String label;
  final String address;
  final bool hasSigned;
  final String? signedAt;

  String get maskedAddress => _maskAddress(address);
}

final class P2PEscrowTimelineEventDraft {
  const P2PEscrowTimelineEventDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.time,
    required this.status,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String description;
  final String time;
  final P2POrderStepStatus status;
  final String iconKey;
}

final class P2PKycRequirementsSnapshot {
  const P2PKycRequirementsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.currentTier,
    required this.pendingTier,
    required this.tiers,
    required this.heroTitle,
    required this.heroBody,
    required this.noticeTitle,
    required this.noticeBody,
    required this.supportTitle,
    required this.supportBody,
    required this.verifyRouteBase,
    required this.supportRoute,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int currentTier;
  final int? pendingTier;
  final List<P2PKycTierDraft> tiers;
  final String heroTitle;
  final String heroBody;
  final String noticeTitle;
  final String noticeBody;
  final String supportTitle;
  final String supportBody;
  final String verifyRouteBase;
  final String supportRoute;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  String verifyRouteFor(int tierId) => '$verifyRouteBase?tier=$tierId';
}

final class P2PKycTierDraft {
  const P2PKycTierDraft({
    required this.id,
    required this.name,
    required this.badge,
    required this.toneKey,
    required this.iconKey,
    required this.requirements,
    required this.limits,
    required this.benefits,
    required this.verificationTime,
    required this.status,
  });

  final int id;
  final String name;
  final String badge;
  final String toneKey;
  final String iconKey;
  final List<P2PKycRequirementDraft> requirements;
  final P2PKycLimitsDraft limits;
  final List<String> benefits;
  final String verificationTime;
  final P2PKycTierStatus status;
}

final class P2PKycRequirementDraft {
  const P2PKycRequirementDraft({required this.label, required this.iconKey});

  final String label;
  final String iconKey;
}

final class P2PKycLimitsDraft {
  const P2PKycLimitsDraft({
    required this.dailyBuy,
    required this.dailySell,
    required this.monthlyVolume,
  });

  final int dailyBuy;
  final int dailySell;
  final int monthlyVolume;
}

final class P2PKycStatusSnapshot {
  const P2PKycStatusSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.tier,
    required this.tierName,
    required this.overallStatus,
    required this.submittedAt,
    required this.steps,
    required this.infoBody,
    required this.supportTitle,
    required this.supportBody,
    required this.parentRoute,
    required this.supportRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int tier;
  final String tierName;
  final P2PKycVerificationStatus overallStatus;
  final String submittedAt;
  final List<P2PKycStatusStepDraft> steps;
  final String infoBody;
  final String supportTitle;
  final String supportBody;
  final String parentRoute;
  final String supportRoute;
  final String emptyTitle;
  final String contractNotes;

  int get completedSteps =>
      steps.where((step) => step.status == P2PKycStepStatus.completed).length;

  int get totalSteps => steps.length;

  double get progress => totalSteps == 0 ? 0 : completedSteps / totalSteps;

  String get progressLabel => '$completedSteps/$totalSteps bước';

  String get statusLabel => switch (overallStatus) {
    P2PKycVerificationStatus.approved => 'Đã duyệt',
    P2PKycVerificationStatus.pending => 'Đang xử lý',
    P2PKycVerificationStatus.rejected => 'Từ chối',
    P2PKycVerificationStatus.incomplete => 'Chưa hoàn tất',
  };
}

final class P2PKycStatusStepDraft {
  const P2PKycStatusStepDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.status,
    this.completedAt,
    this.rejectedReason,
    this.rejectedDetails,
    this.estimatedTime,
    this.actionLabel,
    this.actionRoute,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final P2PKycStepStatus status;
  final String? completedAt;
  final String? rejectedReason;
  final String? rejectedDetails;
  final String? estimatedTime;
  final String? actionLabel;
  final String? actionRoute;

  bool get hasAction => actionLabel != null && actionRoute != null;

  String get statusLabel => switch (status) {
    P2PKycStepStatus.completed => 'Hoàn thành',
    P2PKycStepStatus.processing => 'Đang xử lý',
    P2PKycStepStatus.pending => 'Chờ xử lý',
    P2PKycStepStatus.waiting => 'Chưa bắt đầu',
    P2PKycStepStatus.rejected => 'Từ chối',
  };
}

final class P2PIdentityVerificationSnapshot {
  const P2PIdentityVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.documentTypes,
    required this.guidelines,
    required this.securityNotes,
    required this.parentRoute,
    required this.nextRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final List<P2PIdentityDocumentTypeDraft> documentTypes;
  final List<String> guidelines;
  final List<String> securityNotes;
  final String parentRoute;
  final String nextRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PIdentityDocumentTypeDraft {
  const P2PIdentityDocumentTypeDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
}

final class P2PAddressProofSnapshot {
  const P2PAddressProofSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.documentTypes,
    required this.requirements,
    required this.securityNotes,
    required this.extractedName,
    required this.extractedAddress,
    required this.extractedDate,
    required this.parentRoute,
    required this.submitRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final List<P2PAddressDocumentTypeDraft> documentTypes;
  final List<String> requirements;
  final List<String> securityNotes;
  final String extractedName;
  final String extractedAddress;
  final String extractedDate;
  final String parentRoute;
  final String submitRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PAddressDocumentTypeDraft {
  const P2PAddressDocumentTypeDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.examples,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final List<String> examples;
}

final class P2PSelfieVerificationSnapshot {
  const P2PSelfieVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.sampleTitle,
    required this.sampleBody,
    required this.guidelines,
    required this.tips,
    required this.livenessActions,
    required this.matchScore,
    required this.livenessScore,
    required this.parentRoute,
    required this.statusRoute,
    required this.supportRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final String sampleTitle;
  final String sampleBody;
  final List<String> guidelines;
  final List<String> tips;
  final List<P2PSelfieLivenessActionDraft> livenessActions;
  final String matchScore;
  final String livenessScore;
  final String parentRoute;
  final String statusRoute;
  final String supportRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PSelfieLivenessActionDraft {
  const P2PSelfieLivenessActionDraft({
    required this.id,
    required this.label,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String iconKey;
}

final class P2PVideoVerificationSnapshot {
  const P2PVideoVerificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroBody,
    required this.preparationItems,
    required this.timeSlots,
    required this.parentRoute,
    required this.statusRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroBody;
  final List<String> preparationItems;
  final List<P2PVideoTimeSlotDraft> timeSlots;
  final String parentRoute;
  final String statusRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PVideoTimeSlotDraft {
  const P2PVideoTimeSlotDraft({
    required this.id,
    required this.date,
    required this.time,
    required this.available,
  });

  final String id;
  final String date;
  final String time;
  final bool available;
}

final class P2PSecurityCenterSnapshot {
  const P2PSecurityCenterSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.score,
    required this.maxScore,
    required this.scoreLabel,
    required this.scoreSubtitle,
    required this.scoreBody,
    required this.features,
    required this.quickActions,
    required this.recentEvents,
    required this.parentRoute,
    required this.settingsRoute,
    required this.loginHistoryRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final int score;
  final int maxScore;
  final String scoreLabel;
  final String scoreSubtitle;
  final String scoreBody;
  final List<P2PSecurityFeatureDraft> features;
  final List<P2PSecurityQuickActionDraft> quickActions;
  final List<P2PSecurityEventDraft> recentEvents;
  final String parentRoute;
  final String settingsRoute;
  final String loginHistoryRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PSecurityFeatureDraft {
  const P2PSecurityFeatureDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.status,
    required this.scoreDelta,
    required this.route,
  });

  final String id;
  final String label;
  final String iconKey;
  final P2PSecurityStatus status;
  final int scoreDelta;
  final String route;
}

final class P2PSecurityQuickActionDraft {
  const P2PSecurityQuickActionDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.colorKey,
    required this.route,
  });

  final String id;
  final String label;
  final String iconKey;
  final String colorKey;
  final String route;
}

final class P2PSecurityEventDraft {
  const P2PSecurityEventDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.time,
    required this.iconKey,
    required this.severity,
  });

  final String id;
  final String label;
  final String description;
  final String time;
  final String iconKey;
  final P2PSecurityEventSeverity severity;
}

final class P2PTwoFactorSettingsSnapshot {
  const P2PTwoFactorSettingsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.methods,
    required this.thresholds,
    required this.recommendation,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PTwoFactorMethodDraft> methods;
  final List<P2PTransactionThresholdDraft> thresholds;
  final String recommendation;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PTwoFactorMethodDraft {
  const P2PTwoFactorMethodDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.colorKey,
    required this.enabled,
    required this.isPrimary,
    required this.setupRequired,
  });

  final String id;
  final String label;
  final String description;
  final String iconKey;
  final String colorKey;
  final bool enabled;
  final bool isPrimary;
  final bool setupRequired;

  P2PTwoFactorMethodDraft copyWith({
    bool? enabled,
    bool? isPrimary,
    bool? setupRequired,
  }) {
    return P2PTwoFactorMethodDraft(
      id: id,
      label: label,
      description: description,
      iconKey: iconKey,
      colorKey: colorKey,
      enabled: enabled ?? this.enabled,
      isPrimary: isPrimary ?? this.isPrimary,
      setupRequired: setupRequired ?? this.setupRequired,
    );
  }
}

final class P2PTransactionThresholdDraft {
  const P2PTransactionThresholdDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.valueLabel,
    required this.enabled,
    required this.editable,
  });

  final String id;
  final String label;
  final String description;
  final String valueLabel;
  final bool enabled;
  final bool editable;

  P2PTransactionThresholdDraft copyWith({bool? enabled}) {
    return P2PTransactionThresholdDraft(
      id: id,
      label: label,
      description: description,
      valueLabel: valueLabel,
      enabled: enabled ?? this.enabled,
      editable: editable,
    );
  }
}

final class P2PDeviceManagementSnapshot {
  const P2PDeviceManagementSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.devices,
    required this.infoTitle,
    required this.infoBody,
    required this.securityTips,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PTrustedDeviceDraft> devices;
  final String infoTitle;
  final String infoBody;
  final List<String> securityTips;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  List<P2PTrustedDeviceDraft> get trustedDevices =>
      devices.where((device) => device.isTrusted).toList(growable: false);

  List<P2PTrustedDeviceDraft> get untrustedDevices =>
      devices.where((device) => !device.isTrusted).toList(growable: false);
}

final class P2PTrustedDeviceDraft {
  const P2PTrustedDeviceDraft({
    required this.id,
    required this.name,
    required this.type,
    required this.os,
    required this.browser,
    required this.location,
    required this.ip,
    required this.lastActive,
    required this.firstSeen,
    required this.isCurrent,
    required this.isTrusted,
    required this.fingerprint,
  });

  final String id;
  final String name;
  final String type;
  final String os;
  final String browser;
  final String location;
  final String ip;
  final String lastActive;
  final String firstSeen;
  final bool isCurrent;
  final bool isTrusted;
  final String fingerprint;

  P2PTrustedDeviceDraft copyWith({bool? isTrusted}) {
    return P2PTrustedDeviceDraft(
      id: id,
      name: name,
      type: type,
      os: os,
      browser: browser,
      location: location,
      ip: ip,
      lastActive: lastActive,
      firstSeen: firstSeen,
      isCurrent: isCurrent,
      isTrusted: isTrusted ?? this.isTrusted,
      fingerprint: fingerprint,
    );
  }
}

final class P2PAntiPhishingCodeSnapshot {
  const P2PAntiPhishingCodeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.hasCode,
    required this.currentCode,
    required this.statusTitle,
    required this.statusBody,
    required this.explainerTitle,
    required this.explainerBody,
    required this.benefits,
    required this.examples,
    required this.warningTitle,
    required this.warnings,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final bool hasCode;
  final String currentCode;
  final String statusTitle;
  final String statusBody;
  final String explainerTitle;
  final String explainerBody;
  final List<String> benefits;
  final List<P2PAntiPhishingExampleDraft> examples;
  final String warningTitle;
  final List<String> warnings;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PAntiPhishingExampleDraft {
  const P2PAntiPhishingExampleDraft({
    required this.id,
    required this.subject,
    required this.preview,
    required this.isLegit,
  });

  final String id;
  final String subject;
  final String preview;
  final bool isLegit;
}

final class P2PLoginHistorySnapshot {
  const P2PLoginHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.events,
    required this.warningBody,
    required this.infoTitle,
    required this.securityTips,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PLoginEventDraft> events;
  final String warningBody;
  final String infoTitle;
  final List<String> securityTips;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get successCount =>
      events.where((event) => event.status == 'success').length;

  int get riskEventCount => events.where((event) => event.isRiskEvent).length;
}

final class P2PLoginEventDraft {
  const P2PLoginEventDraft({
    required this.id,
    required this.timestamp,
    required this.deviceType,
    required this.deviceName,
    required this.os,
    required this.browser,
    required this.city,
    required this.country,
    required this.ip,
    required this.status,
    required this.statusLabel,
    required this.method,
    required this.methodLabel,
    required this.isCurrent,
  });

  final String id;
  final String timestamp;
  final String deviceType;
  final String deviceName;
  final String os;
  final String browser;
  final String city;
  final String country;
  final String ip;
  final String status;
  final String statusLabel;
  final String method;
  final String methodLabel;
  final bool isCurrent;

  bool get isRiskEvent => status == 'suspicious' || status == 'failed';
}

final class P2PSuspiciousActivitySnapshot {
  const P2PSuspiciousActivitySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.alerts,
    required this.summarySubtitle,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PSuspiciousAlertDraft> alerts;
  final String summarySubtitle;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get unreviewedCount => alerts.where((alert) => !alert.reviewed).length;
}

final class P2PSuspiciousAlertDraft {
  const P2PSuspiciousAlertDraft({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    required this.severity,
    required this.reviewed,
  });

  final String id;
  final String type;
  final String message;
  final String timestamp;
  final String severity;
  final bool reviewed;

  P2PSuspiciousAlertDraft copyWith({bool? reviewed}) {
    return P2PSuspiciousAlertDraft(
      id: id,
      type: type,
      message: message,
      timestamp: timestamp,
      severity: severity,
      reviewed: reviewed ?? this.reviewed,
    );
  }
}

final class P2PE2EInfoSnapshot {
  const P2PE2EInfoSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.localLabel,
    required this.partnerLabel,
    required this.diagramCaption,
    required this.infoItems,
    required this.fingerprint,
    required this.fingerprintHint,
    required this.steps,
    required this.serverNote,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String heroTitle;
  final String heroSubtitle;
  final String localLabel;
  final String partnerLabel;
  final String diagramCaption;
  final List<P2PE2EInfoItemDraft> infoItems;
  final String fingerprint;
  final String fingerprintHint;
  final List<P2PE2EStepDraft> steps;
  final String serverNote;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PE2EInfoItemDraft {
  const P2PE2EInfoItemDraft({
    required this.id,
    required this.iconKey,
    required this.title,
    required this.description,
    required this.toneKey,
  });

  final String id;
  final String iconKey;
  final String title;
  final String description;
  final String toneKey;
}

final class P2PE2EStepDraft {
  const P2PE2EStepDraft({
    required this.id,
    required this.step,
    required this.title,
    required this.description,
  });

  final String id;
  final String step;
  final String title;
  final String description;
}

final class P2PFraudPreventionSnapshot {
  const P2PFraudPreventionSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.patterns,
    required this.checklist,
    required this.emergencyActions,
    required this.disclosure,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PScamPatternDraft> patterns;
  final List<P2PSafetyChecklistItemDraft> checklist;
  final List<P2PFraudEmergencyActionDraft> emergencyActions;
  final String disclosure;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get checkedSafetyCount => checklist.where((item) => item.checked).length;

  int get safetyScore => (checkedSafetyCount / checklist.length * 100).round();
}

final class P2PScamPatternDraft {
  const P2PScamPatternDraft({
    required this.id,
    required this.title,
    required this.severity,
    required this.description,
    required this.howItWorks,
    required this.redFlags,
    required this.prevention,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String severity;
  final String description;
  final List<String> howItWorks;
  final List<String> redFlags;
  final List<String> prevention;
  final String iconKey;
}

final class P2PSafetyChecklistItemDraft {
  const P2PSafetyChecklistItemDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.checked,
    required this.category,
  });

  final String id;
  final String label;
  final String description;
  final bool checked;
  final String category;

  P2PSafetyChecklistItemDraft copyWith({bool? checked}) {
    return P2PSafetyChecklistItemDraft(
      id: id,
      label: label,
      description: description,
      checked: checked ?? this.checked,
      category: category,
    );
  }
}

final class P2PFraudEmergencyActionDraft {
  const P2PFraudEmergencyActionDraft({
    required this.id,
    required this.label,
    required this.route,
    required this.toneKey,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final String toneKey;
  final String iconKey;
}

final class P2PWalletTransferSnapshot {
  const P2PWalletTransferSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.defaultAsset,
    required this.defaultType,
    required this.assets,
    required this.balances,
    required this.feeLabel,
    required this.processingLabel,
    required this.escrowNote,
    required this.confirmationNote,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String defaultAsset;
  final String defaultType;
  final List<P2PWalletTransferAssetDraft> assets;
  final List<P2PWalletTransferBalanceDraft> balances;
  final String feeLabel;
  final String processingLabel;
  final String escrowNote;
  final String confirmationNote;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  P2PWalletTransferBalanceDraft sourceBalance(String type, String asset) {
    return balanceFor(type == 'withdraw' ? 'p2p' : 'main', asset);
  }

  P2PWalletTransferBalanceDraft destinationBalance(String type, String asset) {
    return balanceFor(type == 'withdraw' ? 'main' : 'p2p', asset);
  }

  P2PWalletTransferBalanceDraft balanceFor(String walletKey, String asset) {
    return balances.firstWhere(
      (item) => item.walletKey == walletKey && item.asset == asset,
      orElse: () => balances.first,
    );
  }
}

final class P2PWalletTransferAssetDraft {
  const P2PWalletTransferAssetDraft({required this.symbol, required this.name});

  final String symbol;
  final String name;
}

final class P2PWalletTransferBalanceDraft {
  const P2PWalletTransferBalanceDraft({
    required this.walletKey,
    required this.walletLabel,
    required this.asset,
    required this.available,
    required this.balanceLabel,
  });

  final String walletKey;
  final String walletLabel;
  final String asset;
  final double available;
  final String balanceLabel;
}

final class P2PFundLockHistorySnapshot {
  const P2PFundLockHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.records,
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
  final List<P2PFundLockRecordDraft> records;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  int get lockCount => records.where((item) => item.type == 'lock').length;
}

final class P2PFundLockRecordDraft {
  const P2PFundLockRecordDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.amount,
    required this.reason,
    required this.timestamp,
  });

  final String id;
  final String type;
  final String asset;
  final double amount;
  final String reason;
  final String timestamp;
}

final class P2PWalletSnapshot {
  const P2PWalletSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.totalUsdValue,
    required this.privacyMask,
    required this.balances,
    required this.transactions,
    required this.infoNote,
    required this.parentRoute,
    required this.transferRoute,
    required this.historyRoute,
    required this.escrowBalanceRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final double totalUsdValue;
  final String privacyMask;
  final List<P2PWalletBalanceDraft> balances;
  final List<P2PWalletTransactionDraft> transactions;
  final String infoNote;
  final String parentRoute;
  final String transferRoute;
  final String historyRoute;
  final String escrowBalanceRoute;
  final String emptyTitle;
  final String contractNotes;

  P2PWalletBalanceDraft balanceFor(String asset) {
    return balances.firstWhere(
      (item) => item.asset == asset,
      orElse: () => balances.first,
    );
  }
}

final class P2PWalletBalanceDraft {
  const P2PWalletBalanceDraft({
    required this.asset,
    required this.available,
    required this.inEscrow,
    required this.locked,
    required this.total,
    required this.usdValue,
  });

  final String asset;
  final double available;
  final double inEscrow;
  final double locked;
  final double total;
  final double usdValue;
}

final class P2PWalletTransactionDraft {
  const P2PWalletTransactionDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.amount,
    required this.status,
    required this.time,
    this.orderId,
  });

  final String id;
  final String type;
  final String asset;
  final double amount;
  final String status;
  final String time;
  final String? orderId;
}

final class P2PLimitTrackerSnapshot {
  const P2PLimitTrackerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.usages,
    required this.breakdown,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final List<P2PLimitUsageDraft> usages;
  final List<P2PLimitBreakdownDraft> breakdown;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  P2PLimitUsageDraft usageFor(String period) {
    return usages.firstWhere(
      (item) => item.period == period,
      orElse: () => usages.first,
    );
  }
}

final class P2PLimitUsageDraft {
  const P2PLimitUsageDraft({
    required this.period,
    required this.label,
    required this.used,
    required this.limit,
    required this.percentage,
  });

  final String period;
  final String label;
  final double used;
  final double limit;
  final int percentage;
}

final class P2PLimitBreakdownDraft {
  const P2PLimitBreakdownDraft({
    required this.date,
    required this.buy,
    required this.sell,
  });

  final String date;
  final double buy;
  final double sell;

  double get total => buy + sell;
}

final class P2PTransactionLimitsSnapshot {
  const P2PTransactionLimitsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.currentTier,
    required this.nextTier,
    required this.usageItems,
    required this.detailItems,
    required this.infoBullets,
    required this.parentRoute,
    required this.trackerRoute,
    required this.kycRequirementsRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final P2PTransactionLimitTierDraft currentTier;
  final P2PTransactionLimitTierDraft nextTier;
  final List<P2PTransactionLimitUsageDraft> usageItems;
  final List<P2PTransactionLimitDetailDraft> detailItems;
  final List<String> infoBullets;
  final String parentRoute;
  final String trackerRoute;
  final String kycRequirementsRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PComplianceOverviewSnapshot {
  const P2PComplianceOverviewSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.items,
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
  final List<P2PComplianceItemDraft> items;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PComplianceItemDraft {
  const P2PComplianceItemDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.status,
    required this.iconKey,
    required this.route,
  });

  final String id;
  final String label;
  final String value;
  final String status;
  final String iconKey;
  final String route;
}

final class P2PAmlScreeningSnapshot {
  const P2PAmlScreeningSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.statusDescription,
    required this.lastCheckLabel,
    required this.lastCheckAt,
    required this.nextCheckLabel,
    required this.nextCheckAt,
    required this.checks,
    required this.infoTitle,
    required this.infoBody,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String statusLabel;
  final String statusDescription;
  final String lastCheckLabel;
  final String lastCheckAt;
  final String nextCheckLabel;
  final String nextCheckAt;
  final List<P2PAmlCheckDraft> checks;
  final String infoTitle;
  final String infoBody;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PAmlCheckDraft {
  const P2PAmlCheckDraft({
    required this.id,
    required this.name,
    required this.status,
    required this.detail,
  });

  final String id;
  final String name;
  final String status;
  final String detail;
}

final class P2PSourceOfFundsSnapshot {
  const P2PSourceOfFundsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.sourceTitle,
    required this.inputLabel,
    required this.inputPlaceholder,
    required this.ctaLabel,
    required this.sources,
    required this.parentRoute,
    required this.successRoute,
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
  final String sourceTitle;
  final String inputLabel;
  final String inputPlaceholder;
  final String ctaLabel;
  final List<P2PFundSourceDraft> sources;
  final String parentRoute;
  final String successRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PFundSourceDraft {
  const P2PFundSourceDraft({
    required this.id,
    required this.label,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String iconKey;
}

final class P2PLargeTransactionJustificationSnapshot {
  const P2PLargeTransactionJustificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.purposeTitle,
    required this.customPurposeLabel,
    required this.customPurposePlaceholder,
    required this.detailsLabel,
    required this.detailsPlaceholder,
    required this.ctaLabel,
    required this.purposes,
    required this.parentRoute,
    required this.successRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final double amount;
  final String heroTitle;
  final String heroSubtitle;
  final String purposeTitle;
  final String customPurposeLabel;
  final String customPurposePlaceholder;
  final String detailsLabel;
  final String detailsPlaceholder;
  final String ctaLabel;
  final List<String> purposes;
  final String parentRoute;
  final String successRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PRiskAssessmentSnapshot {
  const P2PRiskAssessmentSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.overallRisk,
    required this.score,
    required this.scoreLabel,
    required this.scoreSubtitle,
    required this.infoText,
    required this.factorTitle,
    required this.factors,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String overallRisk;
  final int score;
  final String scoreLabel;
  final String scoreSubtitle;
  final String infoText;
  final String factorTitle;
  final List<P2PRiskFactorDraft> factors;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PRiskFactorDraft {
  const P2PRiskFactorDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.risk,
    required this.score,
  });

  final String id;
  final String label;
  final String value;
  final String risk;
  final int score;
}

final class P2PTaxReportingSnapshot {
  const P2PTaxReportingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.selectedYear,
    required this.selectedJurisdiction,
    required this.years,
    required this.jurisdictions,
    required this.summary,
    required this.documents,
    required this.disclaimer,
    required this.parentRoute,
    required this.detailRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final int selectedYear;
  final P2PTaxJurisdictionDraft selectedJurisdiction;
  final List<int> years;
  final List<P2PTaxJurisdictionDraft> jurisdictions;
  final P2PTaxSummaryDraft summary;
  final List<P2PTaxDocumentDraft> documents;
  final String disclaimer;
  final String parentRoute;
  final String detailRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PTaxJurisdictionDraft {
  const P2PTaxJurisdictionDraft({
    required this.code,
    required this.name,
    required this.form,
  });

  final String code;
  final String name;
  final String form;
}

final class P2PTaxSummaryDraft {
  const P2PTaxSummaryDraft({
    required this.totalTransactions,
    required this.totalVolumeLabel,
    required this.capitalGainsLabel,
    required this.capitalLossesLabel,
    required this.netGainsLabel,
    required this.generatedAt,
  });

  final int totalTransactions;
  final String totalVolumeLabel;
  final String capitalGainsLabel;
  final String capitalLossesLabel;
  final String netGainsLabel;
  final String generatedAt;
}

final class P2PTaxDocumentDraft {
  const P2PTaxDocumentDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.format,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String format;
  final String toneKey;
}

final class P2POrderBookSnapshot {
  const P2POrderBookSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.selectedAsset,
    required this.markets,
    required this.bids,
    required this.asks,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final P2POrderBookMarketDraft selectedAsset;
  final List<P2POrderBookMarketDraft> markets;
  final List<P2POrderBookEntryDraft> bids;
  final List<P2POrderBookEntryDraft> asks;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  P2POrderBookEntryDraft get bestBid => bids.first;
  P2POrderBookEntryDraft get bestAsk => asks.first;

  double get spreadPercent {
    final spread = bestAsk.priceVnd - bestBid.priceVnd;
    return spread / bestBid.priceVnd * 100;
  }

  double get maxTotal {
    final bidMax = bids
        .map((item) => item.total)
        .reduce((a, b) => a > b ? a : b);
    final askMax = asks
        .map((item) => item.total)
        .reduce((a, b) => a > b ? a : b);
    return bidMax > askMax ? bidMax : askMax;
  }
}

final class P2POrderBookMarketDraft {
  const P2POrderBookMarketDraft({
    required this.asset,
    required this.lastPriceVnd,
    required this.changePct,
    required this.high24hVnd,
    required this.low24hVnd,
    required this.volume24hLabel,
    required this.trades24h,
  });

  final String asset;
  final double lastPriceVnd;
  final double changePct;
  final double high24hVnd;
  final double low24hVnd;
  final String volume24hLabel;
  final int trades24h;
}

final class P2POrderBookEntryDraft {
  const P2POrderBookEntryDraft({
    required this.priceVnd,
    required this.volume,
    required this.total,
    required this.orders,
  });

  final double priceVnd;
  final double volume;
  final double total;
  final int orders;
}

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

final class P2PDashboardFilterDraft {
  const P2PDashboardFilterDraft({required this.id, required this.label});

  final String id;
  final String label;
}

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

final class P2PDashboardSeriesPointDraft {
  const P2PDashboardSeriesPointDraft({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;
}

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

final class P2PAchievementCategoryDraft {
  const P2PAchievementCategoryDraft({required this.id, required this.label});

  final String id;
  final String label;
}

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

final class P2PSettingsAutoReplyDraft {
  const P2PSettingsAutoReplyDraft({
    required this.enabled,
    required this.buyTemplate,
  });

  final bool enabled;
  final String buyTemplate;
}

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

final class P2PGuideTabDraft {
  const P2PGuideTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

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

final class P2PMyOrdersSnapshot {
  const P2PMyOrdersSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.searchHint,
    required this.defaultTab,
    required this.tabs,
    required this.orders,
    required this.parentRoute,
    required this.dashboardRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String searchHint;
  final String defaultTab;
  final List<P2PMyOrdersTabDraft> tabs;
  final List<P2PMyOrderDraft> orders;
  final String parentRoute;
  final String dashboardRoute;
  final String emptyTitle;
  final String contractNotes;

  int get completedCount =>
      orders.where((order) => order.status == 'released').length;

  int get disputedCount =>
      orders.where((order) => order.status == 'disputed').length;

  double get completedVolume => orders
      .where((order) => order.status == 'released')
      .fold<double>(0, (sum, order) => sum + order.total);
}

final class P2PMyOrdersTabDraft {
  const P2PMyOrdersTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class P2PMyOrderDraft {
  const P2PMyOrderDraft({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.asset,
    required this.amount,
    required this.price,
    required this.total,
    required this.currency,
    required this.status,
    required this.merchant,
    required this.merchantId,
    required this.createdAt,
  });

  final String id;
  final String orderNumber;
  final String type;
  final String asset;
  final double amount;
  final int price;
  final int total;
  final String currency;
  final String status;
  final String merchant;
  final String merchantId;
  final String createdAt;
}

final class P2PTransactionLimitTierDraft {
  const P2PTransactionLimitTierDraft({
    required this.tier,
    required this.name,
    required this.statusLabel,
    required this.dailyBuy,
    required this.dailySell,
    required this.weeklyTotal,
    required this.monthlyTotal,
    required this.perTransaction,
    required this.requirements,
  });

  final int tier;
  final String name;
  final String statusLabel;
  final double dailyBuy;
  final double dailySell;
  final double weeklyTotal;
  final double monthlyTotal;
  final double perTransaction;
  final List<String> requirements;
}

final class P2PTransactionLimitUsageDraft {
  const P2PTransactionLimitUsageDraft({
    required this.id,
    required this.label,
    required this.current,
    required this.max,
    required this.toneKey,
  });

  final String id;
  final String label;
  final double current;
  final double max;
  final String toneKey;

  double get percentage => current / max * 100;
  double get remaining => max - current;
}

final class P2PTransactionLimitDetailDraft {
  const P2PTransactionLimitDetailDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.toneKey,
    required this.iconKey,
  });

  final String id;
  final String label;
  final double value;
  final String toneKey;
  final String iconKey;
}

final class P2PClaimDetailSnapshot {
  const P2PClaimDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.claim,
    required this.benchmarks,
    required this.reasonShares,
    required this.parentRoute,
    required this.orderRoute,
    required this.supportRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PClaimDetailDraft claim;
  final List<P2PClaimBenchmarkDraft> benchmarks;
  final List<P2PClaimReasonShareDraft> reasonShares;
  final String parentRoute;
  final String orderRoute;
  final String supportRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PClaimDetailDraft {
  const P2PClaimDetailDraft({
    required this.id,
    required this.claimCode,
    required this.orderId,
    required this.orderNumber,
    required this.reason,
    required this.description,
    required this.amount,
    required this.currency,
    required this.status,
    required this.submittedAt,
    required this.estimatedReview,
    required this.coveragePct,
    required this.maxCoverage,
    required this.timeline,
    required this.evidence,
    required this.reviewerNotes,
    required this.notificationsEnabled,
    this.paidAmount,
  });

  final String id;
  final String claimCode;
  final String orderId;
  final String orderNumber;
  final String reason;
  final String description;
  final int amount;
  final int? paidAmount;
  final String currency;
  final P2PInsuranceClaimStatus status;
  final String submittedAt;
  final String estimatedReview;
  final int coveragePct;
  final int maxCoverage;
  final List<P2PClaimTimelineEventDraft> timeline;
  final List<P2PClaimEvidenceDraft> evidence;
  final List<P2PClaimReviewerNoteDraft> reviewerNotes;
  final bool notificationsEnabled;

  String get statusLabel => switch (status) {
    P2PInsuranceClaimStatus.pending => 'Chờ xử lý',
    P2PInsuranceClaimStatus.reviewing => 'Đang xem xét',
    P2PInsuranceClaimStatus.approved => 'Đã duyệt',
    P2PInsuranceClaimStatus.rejected => 'Từ chối',
    P2PInsuranceClaimStatus.paid => 'Đã chi trả',
  };
}

final class P2PClaimTimelineEventDraft {
  const P2PClaimTimelineEventDraft({
    required this.id,
    required this.statusKey,
    required this.title,
    required this.description,
    required this.timestamp,
    this.actor,
  });

  final String id;
  final String statusKey;
  final String title;
  final String description;
  final String timestamp;
  final String? actor;
}

final class P2PClaimEvidenceDraft {
  const P2PClaimEvidenceDraft({
    required this.id,
    required this.type,
    required this.name,
    required this.size,
    required this.uploadedAt,
  });

  final String id;
  final String type;
  final String name;
  final String size;
  final String uploadedAt;
}

final class P2PClaimReviewerNoteDraft {
  const P2PClaimReviewerNoteDraft({
    required this.id,
    required this.author,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  final String id;
  final String author;
  final String role;
  final String content;
  final String timestamp;
}

final class P2PClaimBenchmarkDraft {
  const P2PClaimBenchmarkDraft({
    required this.id,
    required this.title,
    required this.value,
    required this.caption,
    required this.comparison,
    required this.progress,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String value;
  final String caption;
  final String comparison;
  final double progress;
  final String toneKey;
}

final class P2PClaimReasonShareDraft {
  const P2PClaimReasonShareDraft({
    required this.label,
    required this.percent,
    this.highlight = false,
  });

  final String label;
  final int percent;
  final bool highlight;
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

final class P2PMyAdsSnapshot {
  const P2PMyAdsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.ads,
    required this.emptyTitle,
    required this.emptyActionLabel,
    required this.quickLinks,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PMyAdDraft> ads;
  final String emptyTitle;
  final String emptyActionLabel;
  final List<P2PQuickLinkDraft> quickLinks;
  final String contractNotes;

  int get activeCount =>
      ads.where((ad) => ad.status == P2PMyAdStatus.active).length;

  int get pausedCount =>
      ads.where((ad) => ad.status == P2PMyAdStatus.paused).length;

  int get totalVolume30dUsd =>
      ads.fold<int>(0, (sum, ad) => sum + ad.totalVolume30dUsd);
}

final class P2PMyAdDraft {
  const P2PMyAdDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.price,
    required this.currency,
    required this.priceType,
    required this.minLimit,
    required this.maxLimit,
    required this.available,
    required this.paymentMethods,
    required this.avgResponseTime,
    required this.status,
    required this.totalVolume30dUsd,
    this.priceMargin,
    this.tradingHours,
  });

  final String id;
  final P2PTradeType type;
  final String asset;
  final int price;
  final String currency;
  final String priceType;
  final int minLimit;
  final int maxLimit;
  final double available;
  final List<String> paymentMethods;
  final String avgResponseTime;
  final P2PMyAdStatus status;
  final int totalVolume30dUsd;
  final double? priceMargin;
  final String? tradingHours;

  P2PMyAdDraft copyWith({P2PMyAdStatus? status}) {
    return P2PMyAdDraft(
      id: id,
      type: type,
      asset: asset,
      price: price,
      currency: currency,
      priceType: priceType,
      minLimit: minLimit,
      maxLimit: maxLimit,
      available: available,
      paymentMethods: paymentMethods,
      avgResponseTime: avgResponseTime,
      status: status ?? this.status,
      totalVolume30dUsd: totalVolume30dUsd,
      priceMargin: priceMargin,
      tradingHours: tradingHours,
    );
  }
}

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

final class P2PCreateAdSnapshot {
  const P2PCreateAdSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.assets,
    required this.currencies,
    required this.paymentOptions,
    required this.paymentWindows,
    required this.tradingHours,
    required this.marketPrices,
    required this.defaultAsset,
    required this.defaultCurrency,
    required this.defaultPaymentWindow,
    required this.defaultTradingHours,
    required this.warningNote,
    required this.escrowNote,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<String> assets;
  final List<String> currencies;
  final List<String> paymentOptions;
  final List<int> paymentWindows;
  final List<String> tradingHours;
  final Map<String, int> marketPrices;
  final String defaultAsset;
  final String defaultCurrency;
  final int defaultPaymentWindow;
  final String defaultTradingHours;
  final String warningNote;
  final String escrowNote;
  final String contractNotes;
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

final class P2POrderDetailDraft {
  const P2POrderDetailDraft({
    required this.id,
    required this.orderNumber,
    required this.statusLabel,
    required this.countdownLabel,
    required this.typeLabel,
    required this.amount,
    required this.asset,
    required this.priceVnd,
    required this.totalVnd,
    required this.currency,
    required this.paymentMethod,
    required this.merchant,
    required this.merchantId,
    required this.escrowAmount,
    required this.feeLabel,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.transferContent,
    required this.createdTime,
  });

  final String id;
  final String orderNumber;
  final String statusLabel;
  final String countdownLabel;
  final String typeLabel;
  final double amount;
  final String asset;
  final int priceVnd;
  final int totalVnd;
  final String currency;
  final String paymentMethod;
  final String merchant;
  final String merchantId;
  final double escrowAmount;
  final String feeLabel;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String transferContent;
  final String createdTime;
}

final class P2POrderPaymentFieldDraft {
  const P2POrderPaymentFieldDraft({
    required this.id,
    required this.label,
    required this.value,
    this.monospace = false,
    this.emphasis = false,
  });

  final String id;
  final String label;
  final String value;
  final bool monospace;
  final bool emphasis;
}

enum P2POrderStepStatus { completed, active, pending }

final class P2POrderTimelineStepDraft {
  const P2POrderTimelineStepDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.time,
    required this.status,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String description;
  final String time;
  final P2POrderStepStatus status;
  final String iconKey;
}

final class P2POrderQuickActionDraft {
  const P2POrderQuickActionDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.route,
  });

  final String id;
  final String label;
  final String iconKey;
  final String route;
}

final class P2POrderProofDraft {
  const P2POrderProofDraft({
    required this.id,
    required this.orderNumber,
    required this.totalVnd,
    required this.currency,
  });

  final String id;
  final String orderNumber;
  final int totalVnd;
  final String currency;
}

final class P2POrderCancelDraft {
  const P2POrderCancelDraft({
    required this.id,
    required this.orderNumber,
    required this.typeLabel,
    required this.amount,
    required this.asset,
    required this.totalVnd,
    required this.currency,
    required this.merchant,
    required this.escrowAmount,
  });

  final String id;
  final String orderNumber;
  final String typeLabel;
  final double amount;
  final String asset;
  final int totalVnd;
  final String currency;
  final String merchant;
  final double escrowAmount;
}

final class P2POrderRateDraft {
  const P2POrderRateDraft({
    required this.id,
    required this.merchant,
    required this.typeLabel,
    required this.amount,
    required this.asset,
    required this.totalVnd,
  });

  final String id;
  final String merchant;
  final String typeLabel;
  final double amount;
  final String asset;
  final int totalVnd;
}

final class P2POrderRateTagDraft {
  const P2POrderRateTagDraft({required this.label, required this.iconKey});

  final String label;
  final String iconKey;
}

final class P2POrderTimelineEventDraft {
  const P2POrderTimelineEventDraft({
    required this.id,
    required this.typeKey,
    required this.title,
    required this.time,
    required this.status,
    required this.actor,
  });

  final String id;
  final String typeKey;
  final String title;
  final String time;
  final P2POrderTimelineStatus status;
  final String actor;

  String get statusLabel => status.name;
}

final class P2PAssetDraft {
  const P2PAssetDraft({
    required this.symbol,
    required this.name,
    required this.marketPriceVnd,
  });

  final String symbol;
  final String name;
  final int marketPriceVnd;
}

final class P2PPaymentMethodDraft {
  const P2PPaymentMethodDraft({
    required this.id,
    required this.bankName,
    required this.isVerified,
  });

  final String id;
  final String bankName;
  final bool isVerified;
}

final class P2PExpressStepDraft {
  const P2PExpressStepDraft({required this.title, required this.iconKey});

  final String title;
  final String iconKey;
}

final class P2PAdDraft {
  const P2PAdDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.merchant,
    required this.merchantId,
    required this.merchantVerified,
    required this.completedOrders,
    required this.completionRate,
    required this.price,
    required this.minLimit,
    required this.maxLimit,
    required this.paymentMethods,
    required this.avgResponseTime,
    required this.isOnline,
    required this.kycMinimum,
    this.active = true,
    this.available = 0,
    this.currency = 'VND',
    this.priceType = 'fixed',
    this.priceMargin,
    this.isNewMerchant = false,
    this.merchantBadge,
    this.merchantRating,
  });

  final String id;
  final P2PTradeType type;
  final String asset;
  final String merchant;
  final String merchantId;
  final bool merchantVerified;
  final int completedOrders;
  final double completionRate;
  final int price;
  final int minLimit;
  final int maxLimit;
  final List<String> paymentMethods;
  final String avgResponseTime;
  final bool isOnline;
  final int kycMinimum;
  final bool active;
  final double available;
  final String currency;
  final String priceType;
  final double? priceMargin;
  final bool isNewMerchant;
  final String? merchantBadge;
  final double? merchantRating;
}

final class P2POrderDraft {
  const P2POrderDraft({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.escrowMinutes,
    required this.escrowAmount,
    required this.fee,
  });

  final String id;
  final String orderNumber;
  final String status;
  final int escrowMinutes;
  final double escrowAmount;
  final int fee;
}

String _monthLabel(String monthKey) {
  final parts = monthKey.split('-');
  if (parts.length != 2) return monthKey;
  return 'Tháng ${int.parse(parts[1])}/${parts[0]}';
}

String _maskAddress(String address) {
  if (address.length < 14) return address;
  return '${address.substring(0, 8)}...${address.substring(address.length - 6)}';
}
