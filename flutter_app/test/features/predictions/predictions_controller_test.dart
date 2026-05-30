import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

void main() {
  test('Prediction event controller builds high-risk order preview', () {
    final repository = const MockPredictionsRepository();
    final controller = PredictionEventDetailController(
      state: PredictionEventDetailViewState(
        snapshot: repository.getEventDetail('pred-1'),
      ),
    );

    expect(
      controller.orderValidationMessage(outcome: 'Yes', amountText: '100'),
      isNull,
    );
    expect(PredictionHighRiskFlowStatus.confirming.isBusy, isTrue);
    expect(PredictionHighRiskFlowStatus.preview.hasPreview, isTrue);
    expect(PredictionHighRiskFlowStatus.validationError.isFailure, isTrue);
    final preview = controller.previewOrder(
      outcome: 'Yes',
      isBuy: true,
      isMarket: true,
      amountText: '100',
    );

    expect(preview.outcome, 'Yes');
    expect(preview.sideLabel, 'Buy');
    expect(preview.orderTypeLabel, 'Market');
    expect(preview.probabilityPct, greaterThan(0));
    expect(preview.fee, greaterThan(0));
    expect(preview.maxLoss, greaterThan(preview.amount));
    expect(preview.canSubmit, isTrue);
    expect(
      controller.orderValidationMessage(outcome: 'Yes', amountText: '0'),
      'Enter a valid order amount before preview.',
    );
    expect(
      PredictionEventDetailController(
        state: PredictionEventDetailViewState(
          snapshot: repository.getEventDetail('pred-1'),
          status: PredictionHighRiskFlowStatus.offline,
        ),
      ).orderValidationMessage(outcome: 'Yes', amountText: '100'),
      'Offline: reconnect before previewing this prediction order.',
    );
  });

  test('Predictions portfolio controller owns open-order cancel state', () {
    final repository = const MockPredictionsRepository();
    final controller = PredictionsPortfolioController(
      state: PredictionsPortfolioViewState(snapshot: repository.getPortfolio()),
    );

    final openOrders = controller.openOrdersExcluding({'oo-1'});

    expect(openOrders.map((order) => order.id), isNot(contains('oo-1')));
    expect(openOrders.length, repository.getPortfolio().openOrders.length - 1);
    expect(controller.cancelValidationMessage('oo-1'), isNull);
    expect(
      controller.cancelValidationMessage('missing'),
      'Open order is no longer available.',
    );
  });

  test('Prediction risk and receipt controllers expose review depth', () {
    final repository = const MockPredictionsRepository();
    final riskSnapshot = repository.getRiskCalculator();
    final riskController = PredictionRiskCalculatorController(
      state: PredictionRiskCalculatorViewState(snapshot: riskSnapshot),
    );

    final review = riskController.review(
      outcome: riskSnapshot.defaultOutcome,
      sharesText: riskSnapshot.defaultShares.toString(),
      entryPriceText: riskSnapshot.defaultEntryPrice.toString(),
      currentPriceText: riskSnapshot.defaultCurrentPrice.toString(),
      portfolioBudgetText: riskSnapshot.defaultBankroll.toString(),
    );

    expect(review.validationMessage, isNull);
    expect(review.maxLoss, greaterThan(0));
    expect(review.currentValue, greaterThan(0));
    expect(review.portfolioImpactPct, greaterThan(0));
    expect(
      riskController.validationMessage(
        sharesText: '0',
        entryPriceText: '0.44',
        currentPriceText: '0.52',
        portfolioBudgetText: '1000',
      ),
      'Enter valid shares, entry price, and current price.',
    );

    final receiptController = PredictionOrderReceiptController(
      state: PredictionOrderReceiptViewState(
        snapshot: repository.getOrderReceipt('po-1'),
      ),
    );
    final receiptReview = receiptController.review();

    expect(receiptReview.found, isTrue);
    expect(receiptReview.receiptId, 'po-1');
    expect(receiptReview.eventTitle, isNotEmpty);
    expect(receiptReview.fee, greaterThanOrEqualTo(0));
    expect(receiptReview.portfolioImpactPct, greaterThan(0));
  });
}
