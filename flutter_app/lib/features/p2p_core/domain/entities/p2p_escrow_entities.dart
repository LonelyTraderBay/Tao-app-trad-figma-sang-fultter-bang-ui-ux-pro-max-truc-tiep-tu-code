part of 'p2p_entities.dart';

/// Buy/sell direction of an order held in escrow.
enum P2PEscrowOrderType { buy, sell }

/// Lifecycle status of funds held in escrow for an order.
enum P2PEscrowOrderStatus { pendingPayment, paid, pendingRelease, dispute }

/// Escrow balances by asset and the orders holding each balance.
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

/// Total amount and order count held in escrow for a single asset.
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

/// A single order with funds currently held in escrow.
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

/// Detail of a single escrow, including signers and release timeline.
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

/// A single signer required to release funds from escrow.
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

/// A single event in an escrow's release timeline.
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
