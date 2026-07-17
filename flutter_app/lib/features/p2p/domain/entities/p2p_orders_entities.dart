part of 'p2p_entities.dart';

enum P2POrderTimelineStatus { completed, pending, failed }

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
    this.highRiskContractId,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2POrderDraft order;
  final List<P2POrderTimelineEventDraft> events;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
  final String? highRiskContractId;
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
    this.highRiskContractId,
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
  final String? highRiskContractId;
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

String _maskAddress(String address) =>
    maskAddress(address, head: 8, tail: 6);
