enum P2PHighRiskFlowStatus {
  draft,
  ready,
  validationError,
  preview,
  confirming,
  submitting,
  submitted,
  success,
  error,
  offline,
}

extension P2PHighRiskFlowStatusX on P2PHighRiskFlowStatus {
  bool get isBusy {
    return this == P2PHighRiskFlowStatus.confirming ||
        this == P2PHighRiskFlowStatus.submitting;
  }

  bool get isFailure {
    return this == P2PHighRiskFlowStatus.validationError ||
        this == P2PHighRiskFlowStatus.error ||
        this == P2PHighRiskFlowStatus.offline;
  }

  bool get hasPreview {
    return switch (this) {
      P2PHighRiskFlowStatus.preview ||
      P2PHighRiskFlowStatus.confirming ||
      P2PHighRiskFlowStatus.submitting ||
      P2PHighRiskFlowStatus.submitted ||
      P2PHighRiskFlowStatus.success => true,
      _ => false,
    };
  }
}
