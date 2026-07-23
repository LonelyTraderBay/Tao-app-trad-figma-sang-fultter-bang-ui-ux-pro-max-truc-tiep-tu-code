import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_insurance_fund_common.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_insurance_fund_status_card.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingInsuranceFundHistoryTab extends StatelessWidget {
  const StakingInsuranceFundHistoryTab({super.key, required this.snapshot});

  final StakingInsuranceFundTransparencySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingInsuranceFundKeys.history,
          label: 'Historical Performance (12 Months)',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnCardPaddingX4,
              child: Column(
                children: [
                  SizedBox(
                    height: EarnSpacingTokens.stakingProductHistoryChartHeight,
                    child: CustomPaint(
                      painter: StakingInsuranceFundHistoryPainter(
                        history: snapshot.history,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: StakingInsuranceFundInlineStatCard(
                          label: '12M Growth',
                          value: '+10.6%',
                          color: AppColors.primarySoft,
                        ),
                      ),
                      SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: StakingInsuranceFundInlineStatCard(
                          label: 'Avg Ratio',
                          value: '161%',
                          color: AppColors.buy,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const VitPageSection(
          key: StakingInsuranceFundKeys.audits,
          label: 'Monthly Audit Reports',
          accentColor: AppColors.primarySoft,
          children: [
            StakingInsuranceFundAuditRow(month: 'March 2026'),
            StakingInsuranceFundAuditRow(month: 'February 2026'),
            StakingInsuranceFundAuditRow(month: 'January 2026'),
          ],
        ),
      ],
    );
  }
}

class StakingInsuranceFundAuditRow extends StatelessWidget {
  const StakingInsuranceFundAuditRow({super.key, required this.month});

  final String month;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$month Audit', style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Third-party verified',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.download_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}
