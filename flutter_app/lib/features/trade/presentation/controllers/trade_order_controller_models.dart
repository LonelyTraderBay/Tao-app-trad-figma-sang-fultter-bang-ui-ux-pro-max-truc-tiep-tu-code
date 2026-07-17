import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart'
    show TradeHighRiskFlowStatus, TradeHighRiskFlowStatusX;

import 'package:vit_trade_flutter/features/trade/domain/entities/trade_entities.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';

final class TradeOrderViewState {
  const TradeOrderViewState({
    required this.snapshot,
    required this.draft,
    required this.preview,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeScreenSnapshot snapshot;
  final TradeOrderDraft draft;
  final TradeOrderPreview preview;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeOrderController {
  const TradeOrderController({
    required this.state,
    required TradeRepository repository,
  }) : _repository = repository;

  final TradeOrderViewState state;
  final TradeRepository _repository;

  bool get canSubmit => validationMessage() == null;

  String? validationMessage() {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing this order.';
    }
    if (state.status.isBusy) {
      return 'Confirmation is already in progress.';
    }
    if (state.draft.pairId.trim().isEmpty) {
      return 'Select a trading pair before preview.';
    }
    if (state.draft.amount <= 0) {
      return 'Enter a valid order amount before preview.';
    }
    if (state.draft.price <= 0) {
      return 'Enter a valid order price before preview.';
    }
    if (state.draft.side == TradeOrderSide.buy &&
        state.preview.total > state.snapshot.balances.usdtAvailable) {
      return 'Order total exceeds available quote balance.';
    }
    if (state.draft.side == TradeOrderSide.sell &&
        state.draft.amount > state.snapshot.balances.baseAvailable) {
      return 'Order amount exceeds available base balance.';
    }
    return null;
  }

  TradeOrderReceipt submit() {
    return _repository.submitOrder(state.draft);
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
