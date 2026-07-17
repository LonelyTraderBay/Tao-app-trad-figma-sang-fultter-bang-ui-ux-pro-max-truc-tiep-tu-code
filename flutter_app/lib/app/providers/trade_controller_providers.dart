// Spot / Futures / Margin / Convert product controller providers.
// Advanced terminal demos stay in trade_terminal_controller_providers.dart.
//
// Composition root for the `trade` feature's own domain/data/controllers
// layers (features/trade/domain, features/trade/data,
// features/trade/presentation/controllers) — no longer wired through
// `trade_core`'s 6-way TradeRepository union.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/features/trade/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

final tradeReadModelControllerProvider = Provider<TradeRepository>((ref) {
  return ref.watch(tradeRepositoryProvider);
});

typedef TradeMarginControllerRequest = ({String pairId, bool pairRouteVariant});

final tradeScreenProvider = Provider.family<TradeScreenSnapshot, String>(
  (ref, pairId) => ref.watch(tradeRepositoryProvider).getTrade(pairId: pairId),
);

final tradeFuturesProvider = Provider.family<TradeFuturesSnapshot, String>(
  (ref, pairId) =>
      ref.watch(tradeRepositoryProvider).getFutures(pairId: pairId),
);

final tradeOrdersHistoryControllerProvider =
    Provider<TradeOrdersHistoryController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeOrdersHistoryController(
        repository: repository,
        state: TradeOrdersHistoryViewState(
          snapshot: repository.getOrdersHistory(),
        ),
      );
    });

/// Notifier theo ADR-001 — family key giữ nguyên record request (PERF-HN1
/// đã cho record này value equality qua TradeOrderDraft ==), autoDispose để
/// member theo từng draft không tích lũy.
final tradeOrderControllerProvider = NotifierProvider.autoDispose
    .family<
      TradeOrderController,
      TradeOrderViewState,
      TradeOrderControllerRequest
    >(TradeOrderController.new);

/// STATE-S22: Notifier theo ADR-001, family key thu về `String pairId` —
/// nấc đòn bẩy là state trong Notifier, không còn nằm trong key (trước đây
/// mỗi nấc slider tạo một element cache riêng — leak allowlist S24).
final tradeLeverageControllerProvider = NotifierProvider.autoDispose
    .family<TradeLeverageController, TradeLeverageViewState, String>(
      TradeLeverageController.new,
    );

/// Read-model thuần (không có mutation) — giữ Provider theo chuẩn AGENTS.md;
/// autoDispose để member theo request không tích lũy.
final tradeMarginControllerProvider = Provider.autoDispose
    .family<TradeMarginController, TradeMarginControllerRequest>((
      ref,
      request,
    ) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeMarginController(
        state: TradeMarginViewState(
          snapshot: repository.getMarginTrading(
            pairId: request.pairId,
            pairRouteVariant: request.pairRouteVariant,
          ),
        ),
      );
    });

/// STATE-S22: Notifier theo ADR-001 (mirror tradeOrderControllerProvider).
final tradeFuturesOrderControllerProvider = NotifierProvider.autoDispose
    .family<
      TradeFuturesOrderController,
      TradeFuturesOrderViewState,
      TradeFuturesOrderControllerRequest
    >(TradeFuturesOrderController.new);

final class TradeOrderController extends Notifier<TradeOrderViewState> {
  TradeOrderController(this.request);

  final TradeOrderControllerRequest request;

  TradeRepository get _repository => ref.read(tradeRepositoryProvider);

  @override
  TradeOrderViewState build() {
    final repository = ref.watch(tradeRepositoryProvider);
    final seeded = TradeOrderViewState(
      snapshot: repository.getTrade(pairId: request.pairId),
      draft: request.draft,
      preview: repository.previewOrder(request.draft),
    );
    if (request.draft.amount <= 0) {
      return seeded.copyWith(status: TradeHighRiskFlowStatus.draft);
    }
    if (_validationMessageFor(seeded) != null) {
      return seeded.copyWith(status: TradeHighRiskFlowStatus.validationError);
    }
    return seeded;
  }

  bool get canSubmit => validationMessage() == null;

  String? validationMessage() => _validationMessageFor(state);

  static String? _validationMessageFor(TradeOrderViewState state) {
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

  /// Người dùng mở sheet 'Xem lại lệnh' — `ready → preview`.
  void enterPreview() {
    if (!canSubmit || state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.preview);
  }

  /// Đóng sheet mà không xác nhận — quay về `ready`.
  void cancelPreview() {
    if (state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.ready);
  }

  /// Người dùng bấm xác nhận trong sheet. Nhánh `offline` phân loại qua
  /// [OfflineFailure]; mọi lỗi khác về `error` — không bao giờ ném ra UI.
  Future<void> submit() async {
    if (state.status.isBusy) return;
    state = state.copyWith(status: TradeHighRiskFlowStatus.confirming);
    state = state.copyWith(status: TradeHighRiskFlowStatus.submitting);
    try {
      final receipt = await _repository.submitOrder(state.draft);
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
        errorMessage: 'Gửi lệnh thất bại. Vui lòng thử lại.',
      );
    }
  }
}

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
