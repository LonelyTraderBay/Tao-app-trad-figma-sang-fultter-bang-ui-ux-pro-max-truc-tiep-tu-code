import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';

const predictionPortfolioPrimary = AppColors.primary;

const predictionPortfolioContentKey = Key(
  'sc031_predictions_portfolio_content',
);
const predictionPortfolioVisibilityToggleKey = Key('sc031_visibility_toggle');
const predictionPortfolioActiveTabKey = Key('sc031_tab_active');
const predictionPortfolioClosedTabKey = Key('sc031_tab_closed');
const predictionPortfolioHistoryTabKey = Key('sc031_tab_history');
const predictionPortfolioArenaBridgeKey = Key('sc031_arena_bridge');

enum PredictionPortfolioTab { active, closed, history }

Key predictionPortfolioPositionKey(String id) => Key('sc031_position_$id');
Key predictionPortfolioOpenOrderKey(String id) => Key('sc031_open_order_$id');
Key predictionPortfolioCancelOrderKey(String id) =>
    Key('sc031_cancel_order_$id');
Key predictionPortfolioReceiptKey(String id) => Key('sc031_receipt_$id');

String formatPredictionPortfolioMoney(double value) {
  return '\$${value.toStringAsFixed(2)}';
}

String formatPredictionPortfolioSignedMoney(double value, {int decimals = 2}) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${value.abs().toStringAsFixed(decimals)}';
}

String formatPredictionPortfolioShares(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(2);
}
