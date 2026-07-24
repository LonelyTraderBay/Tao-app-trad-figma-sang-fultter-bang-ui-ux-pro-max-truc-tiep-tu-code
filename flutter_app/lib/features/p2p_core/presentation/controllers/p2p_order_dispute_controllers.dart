part of 'p2p_controller.dart';

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
      return 'Tải lên hoặc chọn ít nhất một tài liệu bằng chứng trước khi xem trước.';
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
      return 'Xem lại giá, phương thức thanh toán và chi tiết ký quỹ trước khi xác nhận.';
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

String _maskPaymentAccount(String value) => maskAccountNumber(value);
