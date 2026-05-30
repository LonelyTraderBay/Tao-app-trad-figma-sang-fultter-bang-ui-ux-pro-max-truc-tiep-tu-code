part of 'p2p_entities.dart';

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
