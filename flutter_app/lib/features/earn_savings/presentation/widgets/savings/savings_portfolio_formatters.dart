import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';

const double savingsPortfolioDonutExtent = 118;
const double savingsPortfolioSectionMarkerExtent =
    AppSpacing.iconSm + AppSpacing.x1;
const double savingsPortfolioSecondaryButtonExtent = 36;
const double savingsPortfolioDaysLineHeight = 1.05;
const EdgeInsetsDirectional savingsPortfolioCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);

double allocationValue(String allocationLabel) {
  final value = double.tryParse(allocationLabel.replaceAll('%', '')) ?? 0;
  return (value / 100).clamp(0, 1);
}

Color assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'SOL' => AppColors.accent,
    'ETH' => AppColors.primarySoft,
    _ => AppColors.primary,
  };
}

Color riskColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.primary,
  };
}

String statusLabel(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => 'Còn lâu',
    EarnRiskLevel.medium => 'Gần đáo hạn',
    EarnRiskLevel.high => 'Sắp tới',
  };
}
