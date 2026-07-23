import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_insurance_fund_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingInsuranceFundStatusCard extends StatelessWidget {
  const StakingInsuranceFundStatusCard({super.key, required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.currentRatio / snapshot.targetRatio;
    return VitCard(
      key: StakingInsuranceFundKeys.fundStatus,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX5,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StakingInsuranceFundMetricBlock(
                  label: 'Total Fund Balance',
                  value: stakingInsuranceFundFormatUsd(snapshot.totalBalance),
                  large: true,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: StakingInsuranceFundMetricBlock(
                  label: 'Reserve Ratio',
                  value: '${snapshot.currentRatio}%',
                  suffix: '/ ${snapshot.targetRatio}%',
                  valueColor: AppColors.buy,
                  alignRight: true,
                  large: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          SizedBox.square(
            dimension: 160,
            child: CustomPaint(
              painter: StakingInsuranceFundProgressRingPainter(
                progress: progress,
                color: AppColors.buy,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.buy,
                      ),
                    ),
                    Text(
                      'of target',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: StakingInsuranceFundInlineStatCard(
                  label: 'Total Liabilities',
                  value: stakingInsuranceFundFormatUsd(snapshot.liabilities),
                  color: AppColors.primarySoft,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: StakingInsuranceFundInlineStatCard(
                  label: 'Surplus',
                  value: stakingInsuranceFundFormatUsd(snapshot.surplus),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            'Last updated: ${snapshot.lastUpdated}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class StakingInsuranceFundMetricBlock extends StatelessWidget {
  const StakingInsuranceFundMetricBlock({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.valueColor = AppColors.text1,
    this.alignRight = false,
    this.large = false,
  });

  final String label;
  final String value;
  final String? suffix;
  final Color valueColor;
  final bool alignRight;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: (large ? AppTextStyles.sectionTitle : AppTextStyles.body)
                    .copyWith(
                      color: valueColor,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: AppSpacing.x1),
                Text(
                  suffix!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class StakingInsuranceFundInlineStatCard extends StatelessWidget {
  const StakingInsuranceFundInlineStatCard({
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
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: color.withValues(alpha: 0.16),
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: StakingInsuranceFundMetricBlock(
        label: label,
        value: value,
        valueColor: color,
      ),
    );
  }
}
