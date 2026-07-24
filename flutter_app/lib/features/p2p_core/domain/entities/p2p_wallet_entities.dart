part of 'p2p_entities.dart';

/// Form data and balances for transferring funds between the main and P2P wallets.
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

/// A single asset selectable in the wallet transfer form.
final class P2PWalletTransferAssetDraft {
  const P2PWalletTransferAssetDraft({required this.symbol, required this.name});

  final String symbol;
  final String name;
}

/// Available balance of one asset in one wallet, used by the transfer form.
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

/// History of fund lock/unlock records for the P2P wallet.
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

/// A single fund lock or unlock record.
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

/// P2P wallet balances and recent transactions for the wallet screen.
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

/// Balance breakdown (available/escrow/locked) for a single asset in the P2P wallet.
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

/// A single transaction row in the P2P wallet history.
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
