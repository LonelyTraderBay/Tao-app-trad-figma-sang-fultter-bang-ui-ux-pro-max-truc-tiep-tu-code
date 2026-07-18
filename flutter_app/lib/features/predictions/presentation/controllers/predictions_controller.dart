import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/domain/repositories/predictions_repository.dart';

export 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
export 'package:vit_trade_flutter/features/predictions/domain/repositories/predictions_repository.dart';

typedef PredictionsReadModelController = PredictionsRepository;

enum PredictionHighRiskFlowStatus {
  draft,
  ready,
  validationError,
  preview,
  confirming,
  submitting,
  submitted,
  success,
  error,
  offline,
}

extension PredictionHighRiskFlowStatusX on PredictionHighRiskFlowStatus {
  bool get isBusy {
    return this == PredictionHighRiskFlowStatus.confirming ||
        this == PredictionHighRiskFlowStatus.submitting;
  }

  bool get isFailure {
    return this == PredictionHighRiskFlowStatus.validationError ||
        this == PredictionHighRiskFlowStatus.error ||
        this == PredictionHighRiskFlowStatus.offline;
  }

  bool get hasPreview {
    return switch (this) {
      PredictionHighRiskFlowStatus.preview ||
      PredictionHighRiskFlowStatus.confirming ||
      PredictionHighRiskFlowStatus.submitting ||
      PredictionHighRiskFlowStatus.submitted ||
      PredictionHighRiskFlowStatus.success => true,
      _ => false,
    };
  }
}

final class PredictionEventDetailViewState {
  const PredictionEventDetailViewState({
    required this.snapshot,
    this.status = PredictionHighRiskFlowStatus.ready,
    this.errorMessage,
    this.lastReceiptId,
  });

  final PredictionEventDetailSnapshot snapshot;
  final PredictionHighRiskFlowStatus status;
  final String? errorMessage;
  final String? lastReceiptId;

  /// `errorMessage` cố ý không giữ giá trị cũ khi không truyền (retry sạch —
  /// cùng quy ước với TradeOrderViewState của ADR-001).
  PredictionEventDetailViewState copyWith({
    PredictionHighRiskFlowStatus? status,
    String? errorMessage,
    String? lastReceiptId,
  }) {
    return PredictionEventDetailViewState(
      snapshot: snapshot,
      status: status ?? this.status,
      errorMessage: errorMessage,
      lastReceiptId: lastReceiptId ?? this.lastReceiptId,
    );
  }
}

final class PredictionOrderPreview {
  const PredictionOrderPreview({
    required this.outcome,
    required this.sideLabel,
    required this.orderTypeLabel,
    required this.probabilityPct,
    required this.price,
    required this.amount,
    required this.fee,
    required this.shares,
    required this.maxLoss,
    required this.canSubmit,
  });

  final String outcome;
  final String sideLabel;
  final String orderTypeLabel;
  final int probabilityPct;
  final double price;
  final double amount;
  final double fee;
  final double shares;
  final double maxLoss;
  final bool canSubmit;
}

final class PredictionsPortfolioViewState {
  const PredictionsPortfolioViewState({
    required this.snapshot,
    this.status = PredictionHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final PredictionPortfolioSnapshot snapshot;
  final PredictionHighRiskFlowStatus status;
  final String? errorMessage;
}

final class PredictionsPortfolioController {
  const PredictionsPortfolioController({required this.state});

  final PredictionsPortfolioViewState state;

  List<PredictionPortfolioOrderDraft> openOrdersExcluding(
    Set<String> cancelledOrderIds,
  ) {
    return state.snapshot.openOrders
        .where((order) => !cancelledOrderIds.contains(order.id))
        .toList(growable: false);
  }

  String? cancelValidationMessage(String orderId) {
    if (state.status == PredictionHighRiskFlowStatus.offline) {
      return 'Mất kết nối: kết nối lại trước khi thay đổi lệnh dự đoán này.';
    }
    if (state.status.isBusy) {
      return 'Thao tác lệnh dự đoán đang được xử lý.';
    }
    if (orderId.trim().isEmpty) {
      return 'Chọn một lệnh dự đoán đang mở trước khi xác nhận.';
    }
    final exists = state.snapshot.openOrders.any(
      (order) => order.id == orderId,
    );
    if (!exists) {
      return 'Lệnh đang mở không còn khả dụng.';
    }
    return null;
  }
}

final class PredictionRiskCalculatorViewState {
  const PredictionRiskCalculatorViewState({
    required this.snapshot,
    this.status = PredictionHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final PredictionRiskCalculatorSnapshot snapshot;
  final PredictionHighRiskFlowStatus status;
  final String? errorMessage;
}

final class PredictionRiskReview {
  const PredictionRiskReview({
    required this.outcome,
    required this.shares,
    required this.entryPrice,
    required this.currentPrice,
    required this.maxLoss,
    required this.currentValue,
    required this.unrealizedPnl,
    required this.portfolioImpactPct,
    required this.validationMessage,
  });

  final String outcome;
  final double shares;
  final double entryPrice;
  final double currentPrice;
  final double maxLoss;
  final double currentValue;
  final double unrealizedPnl;
  final double portfolioImpactPct;
  final String? validationMessage;
}

final class PredictionRiskCalculatorController {
  const PredictionRiskCalculatorController({required this.state});

  final PredictionRiskCalculatorViewState state;

  PredictionRiskReview review({
    required String outcome,
    required String sharesText,
    required String entryPriceText,
    required String currentPriceText,
    required String portfolioBudgetText,
  }) {
    final shares = _parsePredictionNumber(sharesText);
    final entryPrice = _parsePredictionNumber(entryPriceText);
    final currentPrice = _parsePredictionNumber(currentPriceText);
    final portfolioBudget = _parsePredictionNumber(portfolioBudgetText);
    final maxLoss = shares * entryPrice;
    final currentValue = shares * currentPrice;
    final unrealizedPnl = currentValue - maxLoss;
    final impact = portfolioBudget <= 0
        ? 0.0
        : (maxLoss / portfolioBudget) * 100;
    return PredictionRiskReview(
      outcome: outcome.trim().isEmpty
          ? state.snapshot.defaultOutcome
          : outcome.trim(),
      shares: shares,
      entryPrice: entryPrice,
      currentPrice: currentPrice,
      maxLoss: maxLoss,
      currentValue: currentValue,
      unrealizedPnl: unrealizedPnl,
      portfolioImpactPct: impact,
      validationMessage: validationMessage(
        sharesText: sharesText,
        entryPriceText: entryPriceText,
        currentPriceText: currentPriceText,
        portfolioBudgetText: portfolioBudgetText,
      ),
    );
  }

  String? validationMessage({
    required String sharesText,
    required String entryPriceText,
    required String currentPriceText,
    required String portfolioBudgetText,
  }) {
    if (state.status == PredictionHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before calculating prediction risk.';
    }
    if (state.status.isBusy) {
      return 'Risk calculation is already in progress.';
    }
    final shares = _parsePredictionNumber(sharesText);
    final entryPrice = _parsePredictionNumber(entryPriceText);
    final currentPrice = _parsePredictionNumber(currentPriceText);
    final portfolioBudget = _parsePredictionNumber(portfolioBudgetText);
    if (shares <= 0 || entryPrice <= 0 || currentPrice <= 0) {
      return 'Nhập số cổ phần, giá vào lệnh và giá hiện tại hợp lệ.';
    }
    if (portfolioBudget <= 0) {
      return 'Nhập số tiền tác động đến danh mục hợp lệ.';
    }
    return null;
  }
}

final class PredictionOrderReceiptViewState {
  const PredictionOrderReceiptViewState({
    required this.snapshot,
    this.status = PredictionHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final PredictionOrderReceiptSnapshot snapshot;
  final PredictionHighRiskFlowStatus status;
  final String? errorMessage;
}

final class PredictionOrderReceiptReview {
  const PredictionOrderReceiptReview({
    required this.found,
    required this.receiptId,
    required this.eventTitle,
    required this.outcome,
    required this.total,
    required this.fee,
    required this.statusLabel,
    required this.portfolioImpactPct,
  });

  final bool found;
  final String receiptId;
  final String eventTitle;
  final String outcome;
  final double total;
  final double fee;
  final String statusLabel;
  final double portfolioImpactPct;
}

final class PredictionOrderReceiptController {
  const PredictionOrderReceiptController({required this.state});

  final PredictionOrderReceiptViewState state;

  PredictionOrderReceiptReview review() {
    final receipt = state.snapshot.receipt;
    if (receipt == null) {
      return PredictionOrderReceiptReview(
        found: false,
        receiptId: state.snapshot.receiptId,
        eventTitle: 'Receipt unavailable',
        outcome: '',
        total: 0,
        fee: 0,
        statusLabel: 'Missing',
        portfolioImpactPct: 0,
      );
    }
    final portfolioTotal = state.snapshot.receipts.fold<double>(
      0,
      (total, item) => total + item.total,
    );
    final event = state.snapshot.event;
    return PredictionOrderReceiptReview(
      found: true,
      receiptId: receipt.id,
      eventTitle: event?.title ?? 'Event unavailable',
      outcome: receipt.outcome,
      total: receipt.total,
      fee: receipt.fee,
      statusLabel: receipt.status,
      portfolioImpactPct: portfolioTotal <= 0
          ? 0
          : (receipt.total / portfolioTotal) * 100,
    );
  }
}

double _parsePredictionNumber(String value) {
  return double.tryParse(value.trim().replaceAll(',', '')) ?? 0;
}
