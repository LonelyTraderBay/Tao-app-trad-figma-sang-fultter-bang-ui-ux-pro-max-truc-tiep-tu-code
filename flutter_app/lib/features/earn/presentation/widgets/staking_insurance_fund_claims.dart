import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingInsuranceFundClaimsTab extends StatelessWidget {
  const StakingInsuranceFundClaimsTab({super.key, required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingInsuranceFundKeys.claims,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Claims History',
          accentColor: AppColors.primarySoft,
          children: [
            for (final claim in snapshot.claims)
              StakingInsuranceFundClaimCard(claim: claim),
          ],
        ),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: AppSpacing.earnCardPaddingX4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.primarySoft,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Claim Processing: All claims are reviewed within 24 hours. Approved claims are paid out within 7 business days. Average approval rate: 94%.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingProductCompactBodyLineHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StakingInsuranceFundClaimCard extends StatelessWidget {
  const StakingInsuranceFundClaimCard({super.key, required this.claim});

  final StakingInsuranceFundClaimDraft claim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsuranceFundKeys.claim(claim.id),
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(claim.user, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      claim.date,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const StakingInsuranceFundStatusPill(
                label: 'Approved',
                color: AppColors.buy,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            padding: AppSpacing.earnCardPaddingX3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Reason: ${claim.reason}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: StakingInsuranceFundClaimMetric(
                        label: 'Loss',
                        value: '\$${claim.loss.toStringAsFixed(2)}',
                        color: AppColors.sell,
                      ),
                    ),
                    Expanded(
                      child: StakingInsuranceFundClaimMetric(
                        label: 'Coverage',
                        value: '${claim.coverage}%',
                        color: AppColors.warn,
                      ),
                    ),
                    Expanded(
                      child: StakingInsuranceFundClaimMetric(
                        label: 'Payout',
                        value: '\$${claim.payout.toStringAsFixed(2)}',
                        color: AppColors.buy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Processed in ${claim.processingDays} business days',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StakingInsuranceFundClaimMetric extends StatelessWidget {
  const StakingInsuranceFundClaimMetric({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
