part of 'p2p_entities.dart';

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
