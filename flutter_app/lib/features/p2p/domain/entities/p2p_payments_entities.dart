part of 'p2p_entities.dart';

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
    this.highRiskContractId,
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
  final String? highRiskContractId;
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
    this.highRiskContractId,
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
  final String? highRiskContractId;
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
    this.highRiskContractId,
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
  final String? highRiskContractId;
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
