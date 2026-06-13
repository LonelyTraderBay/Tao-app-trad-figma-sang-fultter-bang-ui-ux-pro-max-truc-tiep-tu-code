import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_calculations.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LaunchpadRebalanceHero extends StatelessWidget {
  const LaunchpadRebalanceHero({
    super.key,
    required this.totalValue,
    required this.assetCount,
    required this.totalDeviation,
  });

  final double totalValue;
  final int assetCount;
  final double totalDeviation;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pie_chart_outline_rounded,
                color: AppColors.portfolioTextMuted,
                size: AppSpacing.launchpadIconLg,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Portfolio Value',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextDim,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            '\$${launchpadRebalanceMoney(totalValue)}',
            style: AppTextStyles.numericDisplayXl.copyWith(
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '$assetCount assets - Deviation: ${totalDeviation.toStringAsFixed(1)}%',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
