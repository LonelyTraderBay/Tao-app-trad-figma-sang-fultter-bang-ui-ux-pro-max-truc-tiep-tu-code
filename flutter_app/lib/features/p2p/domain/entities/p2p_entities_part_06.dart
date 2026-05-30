part of 'p2p_entities.dart';

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
