import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/predictions/data/providers/predictions_repository_provider.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

final predictionsReadModelControllerProvider =
    Provider<PredictionsReadModelController>((ref) {
      return ref.watch(predictionsRepositoryProvider);
    });

final predictionEventDetailControllerProvider =
    Provider.family<PredictionEventDetailController, String>((ref, eventId) {
      return PredictionEventDetailController(
        state: PredictionEventDetailViewState(
          snapshot: ref
              .watch(predictionsRepositoryProvider)
              .getEventDetail(eventId),
        ),
      );
    });

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
