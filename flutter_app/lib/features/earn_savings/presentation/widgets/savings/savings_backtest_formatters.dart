import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';

TextStyle get captionBoldStyle =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get microBoldStyle =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

SavingsBacktestPresetDraft presetById(
  SavingsBacktestSnapshot snapshot,
  SavingsBacktestPreset id,
) {
  return snapshot.presets.firstWhere(
    (preset) => preset.id == id,
    orElse: () => snapshot.presets.first,
  );
}

SavingsBacktestPeriodDraft periodById(
  SavingsBacktestSnapshot snapshot,
  SavingsBacktestPeriod id,
) {
  return snapshot.periods.firstWhere(
    (period) => period.id == id,
    orElse: () => snapshot.periods.first,
  );
}

double weightedApy(List<SavingsBacktestSlotDraft> slots) {
  return slots.fold<double>(
    0,
    (total, slot) => total + (slot.avgApy * slot.percentage / 100),
  );
}

IconData iconFor(String iconKey) {
  return switch (iconKey) {
    'shield' => Icons.shield_outlined,
    'target' => Icons.center_focus_strong_rounded,
    'bolt' => Icons.bolt_outlined,
    'sliders' => Icons.tune_rounded,
    _ => Icons.savings_outlined,
  };
}

Color presetColor(SavingsBacktestPreset preset) {
  return switch (preset) {
    SavingsBacktestPreset.conservative => AppColors.buy,
    SavingsBacktestPreset.balanced => AppColors.primary,
    SavingsBacktestPreset.aggressive => AppColors.warn,
    SavingsBacktestPreset.custom => AppColors.accent,
  };
}

Color slotColor(String colorKey) {
  return switch (colorKey) {
    'buy' => AppColors.buy,
    'primary' => AppColors.primary,
    'warn' => AppColors.warn,
    'accent' => AppColors.accent,
    'sell' => AppColors.sell,
    _ => AppColors.text3,
  };
}

String usd(num value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '\$$buffer.${parts.last}';
}

String compactAmount(int value) {
  if (value >= 1000) return '${value ~/ 1000}K';
  return '$value';
}
