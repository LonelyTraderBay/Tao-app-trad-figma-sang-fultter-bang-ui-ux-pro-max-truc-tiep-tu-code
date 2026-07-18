import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart'
    show TradeHighRiskFlowStatus, TradeHighRiskFlowStatusX;

import 'package:vit_trade_flutter/features/trade/domain/entities/trade_entities.dart';

typedef TradeFuturesOrderControllerRequest = ({
  String pairId,
  TradeFuturesOrderDraft draft,
});

final class TradeLeverageViewState {
  const TradeLeverageViewState({
    required this.snapshot,
    required this.request,
    required this.preview,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
    this.receipt,
  });

  final TradeFuturesLeverageSnapshot snapshot;
  final TradeFuturesLeverageRequest request;
  final TradeFuturesLeveragePreview preview;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
  final TradeFuturesLeverageReceipt? receipt;

  /// `errorMessage` cố ý không giữ giá trị cũ khi không truyền (xem
  /// [TradeOrderViewState.copyWith]).
  TradeLeverageViewState copyWith({
    TradeFuturesLeverageRequest? request,
    TradeFuturesLeveragePreview? preview,
    TradeHighRiskFlowStatus? status,
    String? errorMessage,
    TradeFuturesLeverageReceipt? receipt,
  }) {
    return TradeLeverageViewState(
      snapshot: snapshot,
      request: request ?? this.request,
      preview: preview ?? this.preview,
      status: status ?? this.status,
      errorMessage: errorMessage,
      receipt: receipt ?? this.receipt,
    );
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
      return 'Không còn ký quỹ khả dụng cho lần xem trước này.';
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
    this.receipt,
  });

  final TradeFuturesSnapshot snapshot;
  final TradeFuturesOrderDraft draft;
  final TradeFuturesPreview preview;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
  final TradeFuturesReceipt? receipt;

  /// `errorMessage` cố ý không giữ giá trị cũ khi không truyền (xem
  /// [TradeOrderViewState.copyWith]).
  TradeFuturesOrderViewState copyWith({
    TradeHighRiskFlowStatus? status,
    String? errorMessage,
    TradeFuturesReceipt? receipt,
  }) {
    return TradeFuturesOrderViewState(
      snapshot: snapshot,
      draft: draft,
      preview: preview,
      status: status ?? this.status,
      errorMessage: errorMessage,
      receipt: receipt ?? this.receipt,
    );
  }
}
