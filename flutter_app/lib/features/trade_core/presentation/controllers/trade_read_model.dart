export 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';

enum TradeHighRiskFlowStatus {
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

extension TradeHighRiskFlowStatusX on TradeHighRiskFlowStatus {
  bool get isBusy {
    return this == TradeHighRiskFlowStatus.confirming ||
        this == TradeHighRiskFlowStatus.submitting;
  }

  bool get isFailure {
    return this == TradeHighRiskFlowStatus.validationError ||
        this == TradeHighRiskFlowStatus.error ||
        this == TradeHighRiskFlowStatus.offline;
  }

  bool get hasPreview {
    return switch (this) {
      TradeHighRiskFlowStatus.preview ||
      TradeHighRiskFlowStatus.confirming ||
      TradeHighRiskFlowStatus.submitting ||
      TradeHighRiskFlowStatus.submitted ||
      TradeHighRiskFlowStatus.success => true,
      _ => false,
    };
  }
}
