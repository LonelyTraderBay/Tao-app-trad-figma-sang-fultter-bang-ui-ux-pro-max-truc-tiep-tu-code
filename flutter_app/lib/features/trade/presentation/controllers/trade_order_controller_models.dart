import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart'
    show TradeHighRiskFlowStatus, TradeHighRiskFlowStatusX;

import 'package:vit_trade_flutter/features/trade/domain/entities/trade_entities.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';

typedef TradeOrderControllerRequest = ({String pairId, TradeOrderDraft draft});

final class TradeOrderViewState {
  const TradeOrderViewState({
    required this.snapshot,
    required this.draft,
    required this.preview,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
    this.receipt,
  });

  final TradeScreenSnapshot snapshot;
  final TradeOrderDraft draft;
  final TradeOrderPreview preview;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
  final TradeOrderReceipt? receipt;

  /// `errorMessage` cố ý KHÔNG giữ giá trị cũ khi không truyền — mỗi
  /// transition mới xóa lỗi của lượt trước (retry sạch).
  TradeOrderViewState copyWith({
    TradeHighRiskFlowStatus? status,
    String? errorMessage,
    TradeOrderReceipt? receipt,
  }) {
    return TradeOrderViewState(
      snapshot: snapshot,
      draft: draft,
      preview: preview,
      status: status ?? this.status,
      errorMessage: errorMessage,
      receipt: receipt ?? this.receipt,
    );
  }
}

final class TradeOrdersHistoryViewState {
  const TradeOrdersHistoryViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeOrdersHistorySnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeOrdersHistoryController {
  const TradeOrdersHistoryController({
    required this.state,
    required TradeRepository repository,
  }) : _repository = repository;

  final TradeOrdersHistoryViewState state;
  final TradeRepository _repository;

  TradeOrderActionResult cancelOrder(String orderId) {
    return _repository.submitOrderAction(orderId: orderId, action: 'cancel');
  }

  String? cancelValidationMessage(String orderId) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before changing this order.';
    }
    if (state.status.isBusy) {
      return 'Order action is already in progress.';
    }
    if (orderId.trim().isEmpty) {
      return 'Select an open order before confirmation.';
    }
    return null;
  }
}
