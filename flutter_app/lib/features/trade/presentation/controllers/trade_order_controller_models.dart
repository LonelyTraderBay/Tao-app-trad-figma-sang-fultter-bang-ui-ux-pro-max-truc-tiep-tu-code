import 'trade_controller_common.dart';

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

final class TradeAdvancedToolsViewState {
  const TradeAdvancedToolsViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeAdvancedToolsSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeAdvancedToolsController {
  const TradeAdvancedToolsController({
    required this.state,
    required TradeRepository repository,
  }) : _repository = repository;

  final TradeAdvancedToolsViewState state;
  final TradeRepository _repository;

  TradeAdvancedToolActionResult submitAction(
    TradeAdvancedToolActionRequest request,
  ) {
    return _repository.submitAdvancedToolAction(request);
  }

  String? actionValidationMessage(TradeAdvancedToolActionRequest request) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before submitting this trading action.';
    }
    if (state.status.isBusy) {
      return 'Trading action is already in progress.';
    }
    if (request.toolId.trim().isEmpty || request.action.trim().isEmpty) {
      return 'Select a tool action before confirmation.';
    }
    if (request.orderIds.isEmpty) {
      return 'Select at least one order before confirmation.';
    }
    return null;
  }

  TradeOrderAmendmentResult amendOrder(TradeOrderAmendmentRequest request) {
    return _repository.amendOrder(request);
  }

  String? amendmentValidationMessage(TradeOrderAmendmentRequest request) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before amending this order.';
    }
    if (state.status.isBusy) {
      return 'Order amendment is already in progress.';
    }
    if (request.orderId.trim().isEmpty) {
      return 'Select an order before amendment preview.';
    }
    if (request.newPrice <= 0 || request.newAmount <= 0) {
      return 'Enter a valid amended price and amount before preview.';
    }
    return null;
  }
}
