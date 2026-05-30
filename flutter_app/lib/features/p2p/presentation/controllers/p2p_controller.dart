export 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
export 'package:vit_trade_flutter/features/p2p/domain/repositories/p2p_repository.dart';

import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/controllers/p2p_flow_status.dart';

export 'p2p_flow_status.dart';

final class P2PCreateAdViewState {
  const P2PCreateAdViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PCreateAdSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PCreateAdDraft {
  const P2PCreateAdDraft({
    required this.adType,
    required this.asset,
    required this.currency,
    required this.priceType,
    required this.paymentWindow,
    required this.tradingHours,
    required this.requireKyc,
    required this.requiredKycLevel,
    required this.selectedPayments,
    required this.priceText,
    required this.marginText,
    required this.totalText,
    required this.minLimitText,
    required this.maxLimitText,
  });

  final P2PTradeType adType;
  final String asset;
  final String currency;
  final String priceType;
  final int paymentWindow;
  final String tradingHours;
  final bool requireKyc;
  final String requiredKycLevel;
  final Set<String> selectedPayments;
  final String priceText;
  final String marginText;
  final String totalText;
  final String minLimitText;
  final String maxLimitText;
}

final class P2PCreateAdPreview {
  const P2PCreateAdPreview({
    required this.marketPrice,
    required this.effectivePrice,
    required this.priceDiffPercent,
    required this.canPublish,
    required this.typeLabel,
    required this.publishLabel,
    required this.marketPriceLabel,
    required this.priceLabel,
    required this.priceDiffLabel,
    required this.totalAmountLabel,
    required this.paymentSummary,
    required this.limitSummary,
    required this.feeReviewLabel,
    required this.riskReviewLabel,
    required this.escrowReviewLabel,
  });

  final int marketPrice;
  final int effectivePrice;
  final double priceDiffPercent;
  final bool canPublish;
  final String typeLabel;
  final String publishLabel;
  final String marketPriceLabel;
  final String priceLabel;
  final String priceDiffLabel;
  final String totalAmountLabel;
  final String paymentSummary;
  final String limitSummary;
  final String feeReviewLabel;
  final String riskReviewLabel;
  final String escrowReviewLabel;
}

final class P2PCreateAdController {
  const P2PCreateAdController({required this.state});

  final P2PCreateAdViewState state;

  P2PCreateAdPreview preview(P2PCreateAdDraft draft) {
    final marketPrice = state.snapshot.marketPrices[draft.asset] ?? 25300;
    final effectivePrice = _effectivePrice(draft, marketPrice);
    final priceDiffPercent = effectivePrice <= 0
        ? 0.0
        : ((effectivePrice - marketPrice) / marketPrice) * 100;
    final total = _parseP2PNum(draft.totalText);
    final typeLabel = draft.adType == P2PTradeType.buy ? 'MUA' : 'BÁN';
    final paymentSummary = draft.selectedPayments.isEmpty
        ? 'Chưa chọn'
        : draft.selectedPayments.join(', ');
    final minLimit = draft.minLimitText.trim().isEmpty
        ? 'Chưa đặt'
        : draft.minLimitText.trim();
    final maxLimit = draft.maxLimitText.trim().isEmpty
        ? 'Chưa đặt'
        : draft.maxLimitText.trim();

    return P2PCreateAdPreview(
      marketPrice: marketPrice,
      effectivePrice: effectivePrice,
      priceDiffPercent: priceDiffPercent,
      canPublish:
          effectivePrice > 0 && total > 0 && draft.selectedPayments.isNotEmpty,
      typeLabel: typeLabel,
      publishLabel: 'Đăng quảng cáo $typeLabel ${draft.asset}',
      marketPriceLabel: _formatP2PFiat(marketPrice),
      priceLabel: '${_formatP2PFiat(effectivePrice)} ${draft.currency}',
      priceDiffLabel:
          '${priceDiffPercent >= 0 ? 'Tăng' : 'Giảm'} ${priceDiffPercent.abs().toStringAsFixed(2)}% so với thị trường',
      totalAmountLabel: '${draft.totalText.trim()} ${draft.asset}',
      paymentSummary: paymentSummary,
      limitSummary: 'Min $minLimit / Max $maxLimit ${draft.currency}',
      feeReviewLabel:
          'Fee review: no listing fee in mock; order fees must be checked before escrow.',
      riskReviewLabel: state.snapshot.warningNote,
      escrowReviewLabel: state.snapshot.escrowNote,
    );
  }

  Set<String> toggledPayments(Set<String> current, String payment) {
    final next = Set<String>.of(current);
    if (next.contains(payment)) {
      next.remove(payment);
    } else if (next.length < 5) {
      next.add(payment);
    }
    return next;
  }

  int _effectivePrice(P2PCreateAdDraft draft, int marketPrice) {
    if (draft.priceType == 'fixed') {
      return _parseP2PNum(draft.priceText).round();
    }
    final margin = _parseP2PNum(draft.marginText);
    return (marketPrice * (1 + margin / 100)).round();
  }
}

final class P2PPaymentMethodAddViewState {
  const P2PPaymentMethodAddViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PPaymentMethodAddSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PPaymentMethodPreview {
  const P2PPaymentMethodPreview({
    required this.method,
    required this.account,
    required this.maskedAccount,
    required this.ownerName,
    required this.ownershipRiskMessage,
    required this.limitMessage,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.saveRoute,
  });

  final String method;
  final String account;
  final String maskedAccount;
  final String ownerName;
  final String ownershipRiskMessage;
  final String limitMessage;
  final String confirmTitle;
  final String confirmMessage;
  final String saveRoute;
}

final class P2PPaymentMethodAddController {
  const P2PPaymentMethodAddController({required this.state});

  final P2PPaymentMethodAddViewState state;

  List<String> optionsFor({required bool bankType}) {
    return bankType
        ? state.snapshot.bankOptions
        : state.snapshot.ewalletOptions;
  }

  bool canPreview({
    required String? selectedMethod,
    required String account,
    required String ownerName,
  }) {
    return validationMessage(
          selectedMethod: selectedMethod,
          account: account,
          ownerName: ownerName,
        ) ==
        null;
  }

  String? validationMessage({
    required String? selectedMethod,
    required String account,
    required String ownerName,
  }) {
    if (state.status == P2PHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before adding a payment method.';
    }
    if (state.status.isBusy) {
      return 'Confirmation is already in progress.';
    }
    if (selectedMethod == null || selectedMethod.trim().isEmpty) {
      return 'Select a payment method before preview.';
    }
    if (account.trim().isEmpty) {
      return 'Enter the account or wallet identifier before preview.';
    }
    if (ownerName.trim().isEmpty) {
      return 'Enter the verified owner name before preview.';
    }
    return null;
  }

  P2PPaymentMethodPreview preview({
    required String selectedMethod,
    required String account,
    required String ownerName,
  }) {
    return P2PPaymentMethodPreview(
      method: selectedMethod.trim(),
      account: account.trim(),
      maskedAccount: _maskPaymentAccount(account.trim()),
      ownerName: ownerName.trim(),
      ownershipRiskMessage:
          'Ownership review: account owner must match the verified P2P profile before activation.',
      limitMessage:
          'Limits: new payment methods stay under security review before high-value orders.',
      confirmTitle: state.snapshot.confirmTitle,
      confirmMessage: state.snapshot.confirmMessage,
      saveRoute: state.snapshot.saveRoute,
    );
  }
}

final class P2PPaymentMethodOwnershipViewState {
  const P2PPaymentMethodOwnershipViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PPaymentMethodOwnershipSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PPaymentMethodOwnershipSubmitPreview {
  const P2PPaymentMethodOwnershipSubmitPreview({
    required this.confirmTitle,
    required this.confirmMessage,
    required this.saveRoute,
    required this.requiredUploaded,
    required this.requiredTotal,
  });

  final String confirmTitle;
  final String confirmMessage;
  final String saveRoute;
  final int requiredUploaded;
  final int requiredTotal;
}

final class P2PPaymentMethodOwnershipController {
  const P2PPaymentMethodOwnershipController({required this.state});

  final P2PPaymentMethodOwnershipViewState state;

  List<P2POwnershipDocumentDraft> get requiredDocuments {
    return [
      for (final document in state.snapshot.documents)
        if (!document.optional) document,
    ];
  }

  bool canSubmit(Set<String> uploadedDocumentIds) {
    return requiredDocuments.every(
      (document) => uploadedDocumentIds.contains(document.id),
    );
  }

  P2PPaymentMethodOwnershipSubmitPreview submitPreview(
    Set<String> uploadedDocumentIds,
  ) {
    final uploadedRequired = requiredDocuments
        .where((document) => uploadedDocumentIds.contains(document.id))
        .length;
    return P2PPaymentMethodOwnershipSubmitPreview(
      confirmTitle: state.snapshot.confirmTitle,
      confirmMessage: state.snapshot.confirmMessage,
      saveRoute: state.snapshot.saveRoute,
      requiredUploaded: uploadedRequired,
      requiredTotal: requiredDocuments.length,
    );
  }
}

final class P2PPaymentMethodCoolingPeriodViewState {
  const P2PPaymentMethodCoolingPeriodViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PPaymentMethodCoolingPeriodSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PPaymentMethodCoolingPeriodController {
  const P2PPaymentMethodCoolingPeriodController({required this.state});

  final P2PPaymentMethodCoolingPeriodViewState state;

  int get daysLeft => state.snapshot.hoursRemaining ~/ 24;

  int get hoursLeft => state.snapshot.hoursRemaining % 24;

  String get remainingLabel => '${daysLeft}d ${hoursLeft}h';
}

final class P2PRiskAssessmentViewState {
  const P2PRiskAssessmentViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PRiskAssessmentSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PRiskAssessmentController {
  const P2PRiskAssessmentController({required this.state});

  final P2PRiskAssessmentViewState state;

  bool get requiresReview {
    return state.snapshot.score < 80 ||
        state.snapshot.factors.any((factor) => factor.risk == 'medium');
  }

  List<P2PRiskFactorDraft> get materialFactors {
    return [
      for (final factor in state.snapshot.factors)
        if (factor.score < 90 || factor.risk != 'low') factor,
    ];
  }
}

final class P2POrderViewState {
  const P2POrderViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2POrderSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2POrderPaidPreview {
  const P2POrderPaidPreview({
    required this.statusLabel,
    required this.countdownLabel,
    required this.auditMessage,
  });

  final String statusLabel;
  final String countdownLabel;
  final String auditMessage;
}

final class P2POrderController {
  const P2POrderController({required this.state});

  final P2POrderViewState state;

  bool canMarkPaid({required bool paymentProofReady}) {
    return paidValidationMessage(paymentProofReady: paymentProofReady) == null;
  }

  String? paidValidationMessage({required bool paymentProofReady}) {
    if (state.status == P2PHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before confirming payment.';
    }
    if (state.status.isBusy) {
      return 'Payment confirmation is already in progress.';
    }
    if (!paymentProofReady) {
      return 'Review payment proof before confirming payment.';
    }
    return null;
  }

  P2POrderPaidPreview paidPreview() {
    return const P2POrderPaidPreview(
      statusLabel: 'Đã thanh toán - Chờ xác nhận',
      countdownLabel: '29:59',
      auditMessage: 'Payment confirmation requires escrow and audit trail.',
    );
  }
}

final class P2PDisputeEvidenceViewState {
  const P2PDisputeEvidenceViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PDisputeEvidenceSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PDisputeEvidenceDocumentViewState {
  const P2PDisputeEvidenceDocumentViewState({
    required this.source,
    required this.uploaded,
  });

  final P2PDisputeEvidenceDocumentDraft source;
  final bool uploaded;
}

final class P2PDisputeEvidenceSubmitPreview {
  const P2PDisputeEvidenceSubmitPreview({
    required this.disputeId,
    required this.uploadedCount,
    required this.totalCount,
    required this.auditMessage,
  });

  final String disputeId;
  final int uploadedCount;
  final int totalCount;
  final String auditMessage;
}

final class P2PDisputeEvidenceController {
  const P2PDisputeEvidenceController({required this.state});

  final P2PDisputeEvidenceViewState state;

  List<P2PDisputeEvidenceDocumentViewState> documents(
    Set<String> uploadedDocumentIds,
  ) {
    return [
      for (final document in state.snapshot.documents)
        P2PDisputeEvidenceDocumentViewState(
          source: document,
          uploaded:
              document.uploaded || uploadedDocumentIds.contains(document.id),
        ),
    ];
  }

  bool canSubmit(Set<String> uploadedDocumentIds) {
    return validationMessage(uploadedDocumentIds) == null;
  }

  String? validationMessage(Set<String> uploadedDocumentIds) {
    if (state.status == P2PHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before submitting dispute evidence.';
    }
    if (state.status.isBusy) {
      return 'Dispute evidence submission is already in progress.';
    }
    final hasEvidence = documents(
      uploadedDocumentIds,
    ).any((document) => document.uploaded);
    if (!hasEvidence) {
      return 'Upload or select at least one evidence document before preview.';
    }
    return null;
  }

  P2PDisputeEvidenceSubmitPreview submitPreview(
    Set<String> uploadedDocumentIds,
  ) {
    final documentStates = documents(uploadedDocumentIds);
    final uploadedCount = documentStates
        .where((document) => document.uploaded)
        .length;
    return P2PDisputeEvidenceSubmitPreview(
      disputeId: state.snapshot.disputeId,
      uploadedCount: uploadedCount,
      totalCount: documentStates.length,
      auditMessage: state.snapshot.contractNotes,
    );
  }
}

final class P2PExpressConfirmViewState {
  const P2PExpressConfirmViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PExpressConfirmSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PExpressConfirmController {
  const P2PExpressConfirmController({required this.state});

  final P2PExpressConfirmViewState state;

  String get orderRouteId => state.snapshot.order.id;

  String get confirmationTitle {
    return 'Xác nhận ${state.snapshot.isBuy ? 'mua' : 'bán'} nhanh';
  }

  String? validationMessage({required bool acceptedReview}) {
    if (state.status == P2PHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before express confirmation.';
    }
    if (state.status.isBusy) {
      return 'Express confirmation is already in progress.';
    }
    if (!acceptedReview) {
      return 'Review price, payment, and escrow details before confirmation.';
    }
    return null;
  }
}

num _parseP2PNum(String value) {
  var normalized = value.replaceAll(',', '').replaceAll(' ', '').trim();
  final dotParts = normalized.split('.');
  if (dotParts.length > 2 ||
      (dotParts.length == 2 &&
          dotParts.last.length == 3 &&
          dotParts.first.length > 1)) {
    normalized = normalized.replaceAll('.', '');
  }
  return num.tryParse(normalized) ?? 0;
}

String _formatP2PFiat(num value) {
  final raw = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}

String _maskPaymentAccount(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '';
  if (trimmed.length <= 4) return '***';
  final prefix = trimmed.substring(0, trimmed.length < 7 ? 1 : 3);
  return '$prefix...${trimmed.substring(trimmed.length - 4)}';
}
