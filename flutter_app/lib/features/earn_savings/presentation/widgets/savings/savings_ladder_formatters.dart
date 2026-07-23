import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';

const savingsLadderToday = '09/03/2026';

TextStyle get savingsLadderCaptionBoldStyle =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get savingsLadderMicroBoldStyle =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

SavingsLadderTemplateDraft savingsLadderTemplateById(
  SavingsLadderSnapshot snapshot,
  SavingsLadderPreset id,
) {
  return snapshot.templates.firstWhere(
    (template) => template.id == id,
    orElse: () => snapshot.templates.first,
  );
}

List<SavingsLadderRungDraft> savingsLadderGenerateRungs(
  SavingsLadderTemplateDraft template,
  int amountUsd,
) {
  if (template.intervals.isEmpty) return const [];
  return [
    for (var i = 0; i < template.intervals.length; i++)
      SavingsLadderRungDraft(
        id: 'rung-${i + 1}',
        product: template.intervals[i].product,
        asset: template.intervals[i].asset,
        colorKey: template.intervals[i].colorKey,
        lockDays: template.intervals[i].lockDays,
        apyPct: template.intervals[i].apyPct,
        amountUsd:
            (amountUsd * template.intervals[i].allocationPct / 100 * 100)
                .round() /
            100,
        startDate: savingsLadderToday,
        maturityDate: savingsLadderAddDays(
          savingsLadderToday,
          template.intervals[i].lockDays + i * 30,
        ),
        autoRenew: true,
      ),
  ];
}

double savingsLadderTotalAllocated(List<SavingsLadderRungDraft> rungs) {
  return rungs.fold<double>(0, (total, rung) => total + rung.amountUsd);
}

double savingsLadderWeightedApy(List<SavingsLadderRungDraft> rungs) {
  final total = savingsLadderTotalAllocated(rungs);
  if (total <= 0) return 0;
  return rungs.fold<double>(
        0,
        (sum, rung) => sum + (rung.apyPct * rung.amountUsd),
      ) /
      total;
}

double savingsLadderAnnualInterest(List<SavingsLadderRungDraft> rungs) {
  return rungs.fold<double>(
    0,
    (sum, rung) => sum + rung.amountUsd * rung.apyPct / 100,
  );
}

double savingsLadderInterestForTerm(SavingsLadderRungDraft rung) {
  return rung.amountUsd * rung.apyPct / 100 * rung.lockDays / 365;
}

int savingsLadderLiquidityScore(List<SavingsLadderRungDraft> rungs) {
  final total = savingsLadderTotalAllocated(rungs);
  if (rungs.isEmpty || total <= 0) return 0;
  final uniqueDays = rungs.map((rung) => rung.lockDays).toSet().length;
  final shortTermUsd = rungs
      .where((rung) => rung.lockDays <= 30)
      .fold<double>(0, (sum, rung) => sum + rung.amountUsd);
  final diversityScore = math.min(uniqueDays / 3 * 40, 40);
  final shortTermScore = math.min((shortTermUsd / total * 100) / 40 * 30, 30);
  final spreadScore = math.min(rungs.length / 6 * 30, 30);
  return (diversityScore + shortTermScore + spreadScore).round();
}

String savingsLadderAddDays(String from, int days) {
  final parts = from.split('/').map(int.parse).toList();
  final date = DateTime(parts[2], parts[1], parts[0]).add(Duration(days: days));
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String savingsLadderMoney(num value) {
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

String savingsLadderCompactAmount(int value) {
  if (value >= 1000) return '${value ~/ 1000}K';
  return '$value';
}

IconData savingsLadderIconFor(String key) {
  return switch (key) {
    'calendar' => Icons.calendar_today_rounded,
    'bars' => Icons.bar_chart_rounded,
    'layers' => Icons.layers_rounded,
    'sliders' => Icons.tune_rounded,
    _ => Icons.savings_outlined,
  };
}

Color savingsLadderToneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.accent,
  };
}

Color savingsLadderColorFor(String colorKey) {
  return switch (colorKey) {
    'buy' => AppColors.buy,
    'primary' => AppColors.primary,
    'warn' => AppColors.warn,
    'accent' => AppColors.accent,
    'sell' => AppColors.sell,
    _ => AppColors.text3,
  };
}

Color savingsLadderLiquidityColor(int score) {
  if (score >= 70) return AppColors.buy;
  if (score >= 40) return AppColors.warn;
  return AppColors.sell;
}
