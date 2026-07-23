import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';

TextStyle get savingsSmartCaptionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get savingsSmartMicroBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

final class SavingsSmartSuggestionsKeys {
  const SavingsSmartSuggestionsKeys._();

  static const summary = Key('sc347_summary');
  static const suggestionsList = Key('sc347_suggestions_list');
  static const trendsList = Key('sc347_trends_list');
  static const signalsList = Key('sc347_signals_list');

  static Key filter(String id) => Key('sc347_filter_$id');
  static Key suggestion(String id) => Key('sc347_suggestion_$id');
  static Key action(String id) => Key('sc347_action_$id');
  static Key helpful(String id) => Key('sc347_helpful_$id');
  static Key dismiss(String id) => Key('sc347_dismiss_$id');
}

Color savingsSmartFilterTone(String id) {
  return switch (id) {
    'high' => AppColors.sell,
    'medium' => AppColors.warn,
    'low' => AppColors.primary,
    _ => AppColors.primary,
  };
}

Color savingsSmartPriorityColor(SavingsSuggestionPriority priority) {
  return switch (priority) {
    SavingsSuggestionPriority.high => AppColors.sell,
    SavingsSuggestionPriority.medium => AppColors.warn,
    SavingsSuggestionPriority.low => AppColors.primary,
  };
}

Color savingsSmartTypeColor(SavingsSuggestionType type) {
  return switch (type) {
    SavingsSuggestionType.dcaTiming => AppColors.buy,
    SavingsSuggestionType.productSwitch => AppColors.primary,
    SavingsSuggestionType.rebalance => AppColors.accent,
    SavingsSuggestionType.newOpportunity => AppColors.warn,
    SavingsSuggestionType.riskAlert => AppColors.sell,
    SavingsSuggestionType.compoundBoost => AppColors.accent,
  };
}

IconData savingsSmartTypeIcon(SavingsSuggestionType type) {
  return switch (type) {
    SavingsSuggestionType.dcaTiming => Icons.repeat_rounded,
    SavingsSuggestionType.productSwitch => Icons.swap_horiz_rounded,
    SavingsSuggestionType.rebalance => Icons.sync_rounded,
    SavingsSuggestionType.newOpportunity => Icons.auto_awesome_rounded,
    SavingsSuggestionType.riskAlert => Icons.warning_amber_rounded,
    SavingsSuggestionType.compoundBoost => Icons.bolt_rounded,
  };
}

Color savingsSmartConfidenceColor(int value) {
  if (value >= 80) return AppColors.buy;
  if (value >= 60) return AppColors.warn;
  return AppColors.sell;
}

Color savingsSmartTrendColor(SavingsApyTrendDirection direction) {
  return switch (direction) {
    SavingsApyTrendDirection.up => AppColors.buy,
    SavingsApyTrendDirection.down => AppColors.sell,
    SavingsApyTrendDirection.stable => AppColors.primary,
  };
}

String savingsSmartTrendLabel(SavingsApyTrendDirection direction) {
  return switch (direction) {
    SavingsApyTrendDirection.up => 'Tăng',
    SavingsApyTrendDirection.down => 'Giảm',
    SavingsApyTrendDirection.stable => 'Ổn định',
  };
}

Color savingsSmartSignalColor(SavingsMarketSignalType type) {
  return switch (type) {
    SavingsMarketSignalType.bullish => AppColors.buy,
    SavingsMarketSignalType.bearish => AppColors.sell,
    SavingsMarketSignalType.neutral => AppColors.primary,
  };
}
