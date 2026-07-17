import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart'
    show TradeHighRiskFlowStatus, TradeHighRiskFlowStatusX;

import 'package:vit_trade_flutter/features/trade/data/providers/trade_repository_provider.dart';
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

/// Máy trạng thái đặt lệnh Spot — implementation tham chiếu của ADR-001
/// (docs/05_ARCHITECTURE/decisions/ADR-001-async-error-idiom.md).
///
/// Notifier theo family per-request (cặp + draft hiện tại của form):
/// `build()` seed `draft`/`validationError`/`ready` từ read-model;
/// `submit()` chạy chuỗi `confirming → submitting → submitted → success`,
/// rẽ nhánh `error`/`offline` kèm `errorMessage`.
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
