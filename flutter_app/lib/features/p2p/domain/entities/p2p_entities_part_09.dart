part of 'p2p_entities.dart';

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
