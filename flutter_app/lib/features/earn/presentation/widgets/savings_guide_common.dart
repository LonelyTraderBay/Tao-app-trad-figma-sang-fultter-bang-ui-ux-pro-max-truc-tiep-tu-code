import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

final class SavingsGuideKeys {
  const SavingsGuideKeys._();

  static const tutorialList = Key('sc335_tutorial_list');
  static const glossaryList = Key('sc335_glossary_list');
  static const firstTutorial = Key('sc335_first_tutorial');
  static const startButton = Key('sc335_start_button');
  static const completeButton = Key('sc335_complete_tutorial_button');

  static Key tab(String id) => Key('sc335_tab_$id');
}

class SavingsGuideProgressHeader extends StatelessWidget {
  const SavingsGuideProgressHeader({
    super.key,
    required this.stepIndex,
    required this.total,
    required this.progress,
  });

  final int stepIndex;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Bước ${stepIndex + 1}/$total',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).round()}% hoàn thành',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.earnGuideProgressHeight,
            value: progress,
            backgroundColor: AppColors.borderSolid,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class SavingsGuideStepDetail extends StatelessWidget {
  const SavingsGuideStepDetail({super.key, required this.step});

  final SavingsGuideStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SavingsGuideRoundIcon(
              icon: savingsGuideIcon(step.iconKey),
              color: AppColors.buy,
              size: AppSpacing.buttonStandard,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                step.title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          step.description,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: AppSpacing.earnGuideParagraphLineHeight,
          ),
        ),
      ],
    );
  }
}

class SavingsGuideTipPanel extends StatelessWidget {
  const SavingsGuideTipPanel({super.key, required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tips quan trọng',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final tip in tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.earnGuideBulletTop),
                  child: SizedBox(
                    width: AppSpacing.earnGuideBulletSize,
                    height: AppSpacing.earnGuideBulletSize,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.text3,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.earnGuideTipLineHeight,
                    ),
                  ),
                ),
              ],
            ),
            if (tip != tips.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class SavingsGuideDifficultyPill extends StatelessWidget {
  const SavingsGuideDifficultyPill({super.key, required this.difficulty});

  final SavingsGuideDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final color = savingsGuideDifficultyColor(difficulty);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          savingsGuideDifficultyLabel(difficulty),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.earnGuidePillLineHeight,
          ),
        ),
      ),
    );
  }
}

class SavingsGuideRoundIcon extends StatelessWidget {
  const SavingsGuideRoundIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = AppSpacing.x7,
    this.label,
  });

  final IconData icon;
  final Color color;
  final double size;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: label == null
              ? Icon(icon, color: color, size: AppSpacing.iconSm)
              : Text(
                  label!,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.earnGuidePillLineHeight,
                  ),
                ),
        ),
      ),
    );
  }
}

IconData savingsGuideIcon(String iconKey) {
  return switch (iconKey) {
    'piggy' => Icons.savings_outlined,
    'trend' => Icons.trending_up_rounded,
    'shield' => Icons.shield_outlined,
    'zap' => Icons.bolt_rounded,
    'lock' => Icons.lock_outline_rounded,
    'calculator' => Icons.calculate_outlined,
    'alert' => Icons.warning_amber_rounded,
    'check' => Icons.check_circle_outline_rounded,
    _ => Icons.menu_book_outlined,
  };
}

String savingsGuideDifficultyLabel(SavingsGuideDifficulty difficulty) {
  return switch (difficulty) {
    SavingsGuideDifficulty.beginner => 'Cơ bản',
    SavingsGuideDifficulty.intermediate => 'Trung bình',
    SavingsGuideDifficulty.advanced => 'Nâng cao',
  };
}

Color savingsGuideDifficultyColor(SavingsGuideDifficulty difficulty) {
  return switch (difficulty) {
    SavingsGuideDifficulty.beginner => AppColors.buy,
    SavingsGuideDifficulty.intermediate => AppColors.primary,
    SavingsGuideDifficulty.advanced => AppColors.warn,
  };
}

Color savingsGuideRiskColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.sell,
  };
}
