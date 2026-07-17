import 'package:flutter_riverpod/flutter_riverpod.dart';

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
