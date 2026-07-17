import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart'
    show TradeHighRiskFlowStatus, TradeHighRiskFlowStatusX;

import 'package:vit_trade_flutter/features/trade/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade/domain/entities/trade_entities.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';

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

/// Máy trạng thái điều chỉnh đòn bẩy (STATE-S22, theo ADR-001). Family key
/// thu về `String pairId` — nấc đòn bẩy là state bên trong Notifier
/// ([setLeverage]) thay vì một phần của key như trước (mỗi nấc từng tạo một
/// element cache riêng).
final class TradeLeverageController extends Notifier<TradeLeverageViewState> {
  TradeLeverageController(this.pairId);

  final String pairId;

  TradeRepository get _repository => ref.read(tradeRepositoryProvider);

  static int sanitize(int leverage) => leverage.clamp(1, 100).toInt();

  int sanitizeLeverage(int leverage) => sanitize(leverage);

  @override
  TradeLeverageViewState build() {
    final repository = ref.watch(tradeRepositoryProvider);
    final snapshot = repository.getFuturesLeverage(pairId: pairId);
    final request = TradeFuturesLeverageRequest(
      pairId: pairId,
      leverage: sanitize(snapshot.currentLeverage),
      exampleMargin: snapshot.exampleMargin,
    );
    return TradeLeverageViewState(
      snapshot: snapshot,
      request: request,
      preview: repository.previewFuturesLeverage(request),
    );
  }

  /// Người dùng kéo slider/chọn preset — cập nhật request + preview mới.
  void setLeverage(int leverage) {
    if (state.status.isBusy) return;
    final request = TradeFuturesLeverageRequest(
      pairId: pairId,
      leverage: sanitize(leverage),
      exampleMargin: state.snapshot.exampleMargin,
    );
    state = state.copyWith(
      request: request,
      preview: _repository.previewFuturesLeverage(request),
      status: TradeHighRiskFlowStatus.ready,
    );
  }

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

  /// Máy trạng thái chung ADR-001 — xem [TradeOrderController.submit].
  Future<void> submit() async {
    if (state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.confirming);
    state = state.copyWith(status: TradeHighRiskFlowStatus.submitting);
    try {
      final receipt = await _repository.submitFuturesLeverage(state.request);
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.submitted,
        receipt: receipt,
      );
      state = state.copyWith(status: TradeHighRiskFlowStatus.success);
    } on OfflineFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.offline,
        errorMessage: failure.message,
      );
    } on Object {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.error,
        errorMessage: 'Điều chỉnh đòn bẩy thất bại. Vui lòng thử lại.',
      );
    }
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

/// Máy trạng thái đặt lệnh futures (STATE-S22) — nhân idiom ADR-001 từ
/// [TradeOrderController] (implementation tham chiếu).
final class TradeFuturesOrderController
    extends Notifier<TradeFuturesOrderViewState> {
  TradeFuturesOrderController(this.request);

  final TradeFuturesOrderControllerRequest request;

  TradeRepository get _repository => ref.read(tradeRepositoryProvider);

  @override
  TradeFuturesOrderViewState build() {
    final repository = ref.watch(tradeRepositoryProvider);
    final seeded = TradeFuturesOrderViewState(
      snapshot: repository.getFutures(pairId: request.pairId),
      draft: request.draft,
      preview: repository.previewFuturesOrder(request.draft),
    );
    if (request.draft.margin <= 0) {
      return seeded.copyWith(status: TradeHighRiskFlowStatus.draft);
    }
    if (_validationMessageFor(seeded) != null) {
      return seeded.copyWith(status: TradeHighRiskFlowStatus.validationError);
    }
    return seeded;
  }

  bool get canSubmit => validationMessage() == null;

  String? validationMessage() => _validationMessageFor(state);

  /// Người dùng mở sheet 'Xem lại hợp đồng' — `ready → preview`.
  void enterPreview() {
    if (!canSubmit || state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.preview);
  }

  /// Đóng sheet mà không xác nhận — quay về `ready`.
  void cancelPreview() {
    if (state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.ready);
  }

  /// Máy trạng thái chung ADR-001 — xem [TradeOrderController.submit].
  Future<void> submit() async {
    if (state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.confirming);
    state = state.copyWith(status: TradeHighRiskFlowStatus.submitting);
    try {
      final receipt = await _repository.submitFuturesOrder(state.draft);
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.submitted,
        receipt: receipt,
      );
      state = state.copyWith(status: TradeHighRiskFlowStatus.success);
    } on OfflineFailure catch (failure) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.offline,
        errorMessage: failure.message,
      );
    } on Object {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: TradeHighRiskFlowStatus.error,
        errorMessage: 'Gửi lệnh futures thất bại. Vui lòng thử lại.',
      );
    }
  }

  static String? _validationMessageFor(TradeFuturesOrderViewState state) {
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
}
