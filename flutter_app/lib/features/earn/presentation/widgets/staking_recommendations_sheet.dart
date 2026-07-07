import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_recommendations_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingRecommendationsStrategyDetailSheet extends StatelessWidget {
  const StakingRecommendationsStrategyDetailSheet({
    super.key,
    required this.strategy,
    required this.amount,
    required this.stakingRoute,
  });

  final StakingStrategyDraft strategy;
  final double amount;
  final String stakingRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(strategy.title, style: AppTextStyles.sectionTitle),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Dong',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.sm,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          variant: VitCardVariant.inner,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            children: [
              StakingRecommendationsSheetMetric(
                label: 'Expected APY',
                value: stakingRecommendationsFormatPercent(
                  strategy.expectedApy,
                ),
                color: AppColors.buy,
              ),
              StakingRecommendationsSheetMetric(
                label: 'Risk Level',
                value: stakingRecommendationsRiskLevelLabel(strategy.riskLevel),
                color: stakingRecommendationsRiskColor(strategy.riskLevel),
              ),
              StakingRecommendationsSheetMetric(
                label: 'Với ${stakingRecommendationsFormatUsd(amount)}',
                value:
                    '~${stakingRecommendationsFormatUsd(amount * strategy.expectedApy / 100)}/năm',
                color: AppColors.buy,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        Text(
          'Phân bổ chi tiết',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final item in strategy.allocation) ...[
          StakingRecommendationsAllocationDetailRow(item: item, amount: amount),
          if (item != strategy.allocation.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        StakingRecommendationsBulletSection(
          title: 'Ưu điểm',
          items: strategy.pros,
          color: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        StakingRecommendationsBulletSection(
          title: 'Nhược điểm',
          items: strategy.cons,
          color: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        StakingRecommendationsBulletSection(
          title: 'Phù hợp với',
          items: strategy.bestFor,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        VitCtaButton(
          key: StakingRecommendationsKeys.detailCta,
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop();
            context.go(stakingRoute);
          },
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Áp dụng chiến lược này'),
        ),
      ],
    );
  }
}

class StakingRecommendationsAllocationDetailRow extends StatelessWidget {
  const StakingRecommendationsAllocationDetailRow({
    super.key,
    required this.item,
    required this.amount,
  });

  final StakingRecommendationAllocationDraft item;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final color = stakingRecommendationsAssetColor(item.asset);
    return Row(
      children: [
        StakingRecommendationsAssetBadge(asset: item.asset, color: color),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'APY: ${stakingRecommendationsFormatPercent(item.apy)}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${item.percentage}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              stakingRecommendationsFormatUsd(amount * item.percentage / 100),
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class StakingRecommendationsBulletSection extends StatelessWidget {
  const StakingRecommendationsBulletSection({
    super.key,
    required this.title,
    required this.items,
    required this.color,
  });

  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EarnSpacingTokens.stakingRecommendationsBulletPadding,
                child: SizedBox(
                  width: AppSpacing.x1,
                  height: AppSpacing.x1,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: color,
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: EarnSpacingTokens
                        .stakingRecommendationsBulletLineHeight,
                  ),
                ),
              ),
            ],
          ),
          if (item != items.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class StakingRecommendationsSheetMetric extends StatelessWidget {
  const StakingRecommendationsSheetMetric({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
