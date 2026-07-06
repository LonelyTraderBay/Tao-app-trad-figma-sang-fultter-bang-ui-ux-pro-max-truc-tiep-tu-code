part of 'p2p_entities.dart';

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

enum P2PMyAdStatus { active, paused, expired }
