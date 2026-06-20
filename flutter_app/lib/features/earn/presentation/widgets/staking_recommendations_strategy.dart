import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_recommendations_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingRecommendationsStrategyCard extends StatelessWidget {
  const StakingRecommendationsStrategyCard({
    super.key,
    required this.strategy,
    required this.amount,
    required this.onTap,
  });

  final StakingStrategyDraft strategy;
  final double amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX4,
      borderColor: strategy.recommended ? AppColors.primary : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (strategy.recommended) ...[
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                StakingRecommendationsSmallPill(
                  label: 'Được đề xuất',
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strategy.title, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      strategy.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: AppSpacing
                            .stakingRecommendationsDescriptionLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    stakingRecommendationsFormatPercent(strategy.expectedApy),
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth =
                  (constraints.maxWidth - (AppSpacing.x2 * 2)) / 3;
              return Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final item in strategy.allocation.take(3))
                    SizedBox(
                      width: itemWidth,
                      child: StakingRecommendationsAllocationTile(item: item),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              StakingRecommendationsSmallPill(
                label: stakingRecommendationsRiskLabel(strategy.riskLevel),
                color: stakingRecommendationsRiskColor(strategy.riskLevel),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '~${stakingRecommendationsFormatUsd(amount * strategy.expectedApy / 100)}/năm',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StakingRecommendationsAllocationTile extends StatelessWidget {
  const StakingRecommendationsAllocationTile({super.key, required this.item});

  final StakingRecommendationAllocationDraft item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnPaddingX2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.asset,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              '${item.percentage}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StakingRecommendationsTipCard extends StatelessWidget {
  const StakingRecommendationsTipCard({super.key, required this.tip});

  final StakingPersonalizedTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = stakingRecommendationsTipColor(tip.tone);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StakingRecommendationsRoundIcon(
            icon: stakingRecommendationsTipIcon(tip.iconKey),
            color: color,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tip.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height:
                        AppSpacing.stakingRecommendationsDescriptionLineHeight,
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

class StakingRecommendationsDisclaimer extends StatelessWidget {
  const StakingRecommendationsDisclaimer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppSpacing.stakingRecommendationsBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
