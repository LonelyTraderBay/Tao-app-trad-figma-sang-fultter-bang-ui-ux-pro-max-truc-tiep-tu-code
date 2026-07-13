import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart';

final class TradeLeverageViewState {
  const TradeLeverageViewState({
    required this.snapshot,
    required this.request,
    required this.preview,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeFuturesLeverageSnapshot snapshot;
  final TradeFuturesLeverageRequest request;
  final TradeFuturesLeveragePreview preview;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeLeverageController {
  const TradeLeverageController({
    required this.state,
    required TradeRepository repository,
  }) : _repository = repository;

  final TradeLeverageViewState state;
  final TradeRepository _repository;

  static int sanitize(int leverage) => leverage.clamp(1, 100).toInt();

  int sanitizeLeverage(int leverage) => sanitize(leverage);

  bool get canSubmit => validationMessage() == null;

  String? validationMessage() {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before changing leverage.';
    }
    if (state.status.isBusy) {
      return 'Leverage confirmation is already in progress.';
    }
    if (state.request.pairId.trim().isEmpty) {
      return 'Select a futures pair before preview.';
    }
    if (state.request.leverage < 1 || state.request.leverage > 100) {
      return 'Leverage must stay between 1x and 100x.';
    }
    if (state.request.exampleMargin <= 0) {
      return 'Enter a valid margin example before preview.';
    }
    return null;
  }

  TradeFuturesLeverageReceipt submit() {
    return _repository.submitFuturesLeverage(state.request);
  }
}

final class TradeMarginViewState {
  const TradeMarginViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeMarginTradingSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeMarginController {
  const TradeMarginController({required this.state});

  final TradeMarginViewState state;

  List<TradeMarginPosition> positionsForMode(String mode) {
    return state.snapshot.positions
        .where((position) => position.mode == mode)
        .toList(growable: false);
  }

  double totalPnlForMode(String mode) {
    return positionsForMode(
      mode,
    ).fold<double>(0, (total, position) => total + position.pnl);
  }

  String maxAmountFor({required int leverage}) {
    return (state.snapshot.account.availableMargin *
            leverage /
            state.snapshot.pair.price)
        .toStringAsFixed(6);
  }

  String? leverageValidationMessage({required int leverage}) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing margin risk.';
    }
    if (state.status.isBusy) {
      return 'Margin preview is already in progress.';
    }
    if (leverage < 1 || leverage > 100) {
      return 'Leverage must stay between 1x and 100x.';
    }
    if (state.snapshot.account.availableMargin <= 0) {
      return 'No available margin remains for this preview.';
    }
    return null;
  }
}

final class TradeFuturesOrderViewState {
  const TradeFuturesOrderViewState({
    required this.snapshot,
    required this.draft,
    required this.preview,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeFuturesSnapshot snapshot;
  final TradeFuturesOrderDraft draft;
  final TradeFuturesPreview preview;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeFuturesOrderController {
  const TradeFuturesOrderController({
    required this.state,
    required TradeRepository repository,
  }) : _repository = repository;

  final TradeFuturesOrderViewState state;
  final TradeRepository _repository;

  bool get canSubmit => validationMessage() == null;

  String? validationMessage() {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing this futures order.';
    }
    if (state.status.isBusy) {
      return 'Futures confirmation is already in progress.';
    }
    if (state.draft.pairId.trim().isEmpty) {
      return 'Select a futures pair before preview.';
    }
    if (state.draft.margin <= 0) {
      return 'Enter a valid margin amount before preview.';
    }
    if (state.draft.leverage < 1 || state.draft.leverage > 100) {
      return 'Leverage must stay between 1x and 100x.';
    }
    final availableMargin =
        state.snapshot.accountBalance - state.snapshot.usedMargin;
    if (state.draft.margin > availableMargin) {
      return 'Margin exceeds available futures balance.';
    }
    if (state.draft.type == TradeFuturesOrderType.limit &&
        (state.draft.limitPrice == null || state.draft.limitPrice! <= 0)) {
      return 'Enter a valid limit price before preview.';
    }
    if (!state.preview.canOpen) {
      return 'Resolve futures risk checks before confirmation.';
    }
    return null;
  }

  TradeFuturesReceipt submit() {
    return _repository.submitFuturesOrder(state.draft);
  }
}
