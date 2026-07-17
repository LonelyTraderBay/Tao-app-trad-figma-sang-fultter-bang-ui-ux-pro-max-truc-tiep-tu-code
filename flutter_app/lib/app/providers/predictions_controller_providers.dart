import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/features/predictions/data/providers/predictions_repository_provider.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

final predictionsReadModelControllerProvider =
    Provider<PredictionsReadModelController>((ref) {
      return ref.watch(predictionsRepositoryProvider);
    });

/// ERR-36: Notifier theo ADR-001 — máy trạng thái submit dự đoán, family key
/// = eventId.
final predictionEventDetailControllerProvider = NotifierProvider.autoDispose
    .family<
      PredictionEventDetailController,
      PredictionEventDetailViewState,
      String
    >(PredictionEventDetailController.new);

final predictionsPortfolioControllerProvider =
    Provider<PredictionsPortfolioController>((ref) {
      return PredictionsPortfolioController(
        state: PredictionsPortfolioViewState(
          snapshot: ref.watch(predictionsRepositoryProvider).getPortfolio(),
        ),
      );
    });

final predictionRiskCalculatorControllerProvider =
    Provider<PredictionRiskCalculatorController>((ref) {
      return PredictionRiskCalculatorController(
        state: PredictionRiskCalculatorViewState(
          snapshot: ref
              .watch(predictionsRepositoryProvider)
              .getRiskCalculator(),
        ),
      );
    });

final predictionOrderReceiptControllerProvider =
    Provider.family<PredictionOrderReceiptController, String>((ref, receiptId) {
      return PredictionOrderReceiptController(
        state: PredictionOrderReceiptViewState(
          snapshot: ref
              .watch(predictionsRepositoryProvider)
              .getOrderReceipt(receiptId),
        ),
      );
    });

final class PredictionEventDetailController
    extends Notifier<PredictionEventDetailViewState> {
  PredictionEventDetailController(this.eventId);

  final String eventId;

  PredictionsRepository get _repository =>
      ref.read(predictionsRepositoryProvider);

  @override
  PredictionEventDetailViewState build() {
    return PredictionEventDetailViewState(
      snapshot: ref
          .watch(predictionsRepositoryProvider)
          .getEventDetail(eventId),
    );
  }

  /// Người dùng bấm CTA Buy/Sell sau preview. Trả về `receiptId` khi thành
  /// công (view điều hướng trang biên lai), `null` khi lỗi/validation —
  /// trạng thái + errorMessage đã ghi vào state, không bao giờ ném ra UI.
  Future<String?> submitOrder({
    required String outcome,
    required bool isBuy,
    required bool isMarket,
    required String amountText,
  }) async {
    if (state.status.isBusy) return null;
    final validation = orderValidationMessage(
      outcome: outcome,
      amountText: amountText,
    );
    if (validation != null) {
      state = state.copyWith(
        status: PredictionHighRiskFlowStatus.validationError,
        errorMessage: validation,
      );
      return null;
    }
    final amount = double.tryParse(amountText.trim().replaceAll(',', '')) ?? 0;
    state = state.copyWith(status: PredictionHighRiskFlowStatus.confirming);
    state = state.copyWith(status: PredictionHighRiskFlowStatus.submitting);
    try {
      final receiptId = await _repository.submitOrder(
        eventId: eventId,
        outcome: outcome,
        isBuy: isBuy,
        isMarket: isMarket,
        amount: amount,
      );
      if (!ref.mounted) return null;
      state = state.copyWith(
        status: PredictionHighRiskFlowStatus.submitted,
        lastReceiptId: receiptId,
      );
      return receiptId;
    } on OfflineFailure catch (failure) {
      if (!ref.mounted) return null;
      state = state.copyWith(
        status: PredictionHighRiskFlowStatus.offline,
        errorMessage: failure.message,
      );
      return null;
    } on Object {
      if (!ref.mounted) return null;
      state = state.copyWith(
        status: PredictionHighRiskFlowStatus.error,
        errorMessage: 'Gửi lệnh dự đoán thất bại. Vui lòng thử lại.',
      );
      return null;
    }
  }

  String? orderValidationMessage({
    required String outcome,
    required String amountText,
  }) {
    if (state.status == PredictionHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing this prediction order.';
    }
    if (state.status.isBusy) {
      return 'Prediction order confirmation is already in progress.';
    }
    if (state.snapshot.event.status != PredictionEventStatus.active) {
      return 'Resolved events are receipt-only and cannot accept new orders.';
    }
    final hasOutcome = state.snapshot.event.outcomes.any(
      (item) => item.label == outcome,
    );
    if (!hasOutcome) {
      return 'Select an available outcome before preview.';
    }
    final amount = double.tryParse(amountText.trim().replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      return 'Enter a valid order amount before preview.';
    }
    return null;
  }

  bool canSubmitOrder({required String outcome, required String amountText}) {
    return orderValidationMessage(outcome: outcome, amountText: amountText) ==
        null;
  }

  PredictionOrderPreview previewOrder({
    required String outcome,
    required bool isBuy,
    required bool isMarket,
    required String amountText,
  }) {
    final selected = state.snapshot.event.outcomes.firstWhere(
      (item) => item.label == outcome,
      orElse: () => state.snapshot.event.outcomes.first,
    );
    final amount = double.tryParse(amountText.trim().replaceAll(',', '')) ?? 0;
    final price = selected.chance / 100;
    final fee = amount * .005;
    final shares = price <= 0 ? 0.0 : amount / price;
    final canSubmit = canSubmitOrder(
      outcome: selected.label,
      amountText: amountText,
    );
    return PredictionOrderPreview(
      outcome: selected.label,
      sideLabel: isBuy ? 'Buy' : 'Sell',
      orderTypeLabel: isMarket ? 'Market' : 'Limit',
      probabilityPct: selected.chance,
      price: price,
      amount: amount,
      fee: fee,
      shares: shares,
      maxLoss: amount + fee,
      canSubmit: canSubmit,
    );
  }
}
