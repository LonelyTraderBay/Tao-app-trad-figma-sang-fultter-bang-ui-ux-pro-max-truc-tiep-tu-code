import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart'
    show TradeHighRiskFlowStatus, TradeHighRiskFlowStatusX;
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/spot_trade_repository.dart';

// TradeOrderViewState/Controller and TradeOrdersHistoryViewState/Controller
// moved to `features/trade/presentation/controllers/trade_order_controller_models.dart`
// (only `trade`'s own pages used them). This file keeps only the classes
// `trade_terminal`'s own advanced-tools pages still use.

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
    required SpotTradeRepository repository,
  }) : _repository = repository;

  final TradeAdvancedToolsViewState state;
  final SpotTradeRepository _repository;

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
