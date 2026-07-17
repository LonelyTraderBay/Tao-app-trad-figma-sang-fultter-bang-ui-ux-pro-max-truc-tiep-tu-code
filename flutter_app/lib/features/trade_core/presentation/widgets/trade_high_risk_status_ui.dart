import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart'
    show TradeHighRiskFlowStatus;
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart'
    show VitHighRiskUiState;

/// Map 10 trạng thái máy high-risk (ADR-001) về 7 trạng thái hiển thị của
/// [VitHighRiskUiState] — dùng chung cho panel spot/futures/leverage.
///
/// Các pha trước-khi-gửi (draft/ready/validationError/preview/confirming)
/// đều hiển thị khối "đánh giá rủi ro" (riskReview); submitted gộp vào
/// submitting vì về mặt UI vẫn là "đang xử lý" cho tới khi success.
extension TradeHighRiskFlowStatusUiX on TradeHighRiskFlowStatus {
  VitHighRiskUiState get uiState => switch (this) {
    TradeHighRiskFlowStatus.draft ||
    TradeHighRiskFlowStatus.ready ||
    TradeHighRiskFlowStatus.validationError ||
    TradeHighRiskFlowStatus.preview ||
    TradeHighRiskFlowStatus.confirming => VitHighRiskUiState.riskReview,
    TradeHighRiskFlowStatus.submitting ||
    TradeHighRiskFlowStatus.submitted => VitHighRiskUiState.submitting,
    TradeHighRiskFlowStatus.success => VitHighRiskUiState.success,
    TradeHighRiskFlowStatus.error => VitHighRiskUiState.error,
    TradeHighRiskFlowStatus.offline => VitHighRiskUiState.offline,
  };
}
