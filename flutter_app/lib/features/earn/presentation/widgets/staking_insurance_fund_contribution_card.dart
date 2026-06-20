import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_status_card.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingInsuranceFundContributionCard extends StatelessWidget {
  const StakingInsuranceFundContributionCard({
    super.key,
    required this.snapshot,
  });

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.primarySoft,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How the Fund Grows', style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      '${snapshot.stakingFeeContribution}% of all staking fees are automatically allocated to the insurance fund. No user funds are ever used.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: AppSpacing.stakingProductBodyLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: StakingInsuranceFundInlineStatCard(
                  label: 'Monthly Avg',
                  value: stakingInsuranceFundFormatUsd(
                    snapshot.monthlyContribution,
                  ),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: StakingInsuranceFundInlineStatCard(
                  label: 'YTD 2026',
                  value: stakingInsuranceFundFormatUsd(
                    snapshot.ytdContributions,
                  ),
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          StakingInsuranceFundInlineStatCard(
            label: 'Total Contributed (All-time)',
            value: stakingInsuranceFundFormatUsd(snapshot.totalContributed),
            color: AppColors.primarySoft,
          ),
        ],
      ),
    );
  }
}
