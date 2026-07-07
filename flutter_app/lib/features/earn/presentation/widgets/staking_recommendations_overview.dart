import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_recommendations_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingRecommendationsHeroCard extends StatelessWidget {
  const StakingRecommendationsHeroCard({super.key, required this.snapshot});

  final StakingRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRecommendationsKeys.hero,
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent20,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.accent,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.heroSubtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingRecommendationsBodyLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StakingRecommendationsProfileCard extends StatelessWidget {
  const StakingRecommendationsProfileCard({super.key, required this.snapshot});

  final StakingRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final profile = snapshot.profile;
    return VitCard(
      key: StakingRecommendationsKeys.profile,
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Profile của bạn', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - AppSpacing.x3) / 2;
              return Wrap(
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x3,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: StakingRecommendationsProfileMetric(
                      label: 'Risk Tolerance',
                      value: stakingRecommendationsProfileRiskLabel(
                        profile.riskTolerance,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: StakingRecommendationsProfileMetric(
                      label: 'Investment Horizon',
                      value: stakingRecommendationsHorizonLabel(
                        profile.investmentHorizon,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: StakingRecommendationsProfileMetric(
                      label: 'Liquidity Needs',
                      value: stakingRecommendationsLiquidityLabel(
                        profile.liquidityNeed,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: StakingRecommendationsProfileMetric(
                      label: 'Portfolio Size',
                      value: stakingRecommendationsFormatUsd(
                        profile.totalPortfolio,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: StakingRecommendationsKeys.riskButton,
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.riskAssessmentRoute);
            },
            child: const Text('Cập nhật Profile'),
          ),
        ],
      ),
    );
  }
}

class StakingRecommendationsProfileMetric extends StatelessWidget {
  const StakingRecommendationsProfileMetric({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnCardPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StakingRecommendationsAmountSimulator extends StatelessWidget {
  const StakingRecommendationsAmountSimulator({
    super.key,
    required this.amountText,
    required this.onAmountChanged,
  });

  final String amountText;
  final ValueChanged<String> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mô phỏng với số lượng khác',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          TextField(
            key: StakingRecommendationsKeys.amountField,
            keyboardType: TextInputType.number,
            onChanged: onAmountChanged,
            controller: TextEditingController(text: amountText)
              ..selection = TextSelection.collapsed(offset: amountText.length),
            cursorColor: AppColors.primary,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
            decoration: const InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.surface2,
              contentPadding: AppSpacing.earnCardPaddingX4X3,
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadii.inputRadius,
                borderSide: BorderSide(color: AppColors.borderSolid),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadii.inputRadius,
                borderSide: BorderSide(color: AppColors.primary30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
