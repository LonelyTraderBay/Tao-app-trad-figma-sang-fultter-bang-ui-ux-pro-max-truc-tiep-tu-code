import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_status_card.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                    child: CustomPaint(
                      painter: StakingInsuranceFundHistoryPainter(
                        history: snapshot.history,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      const Expanded(
                        child: StakingInsuranceFundInlineStatCard(
                          label: '12M Growth',
                          value: '+10.6%',
                          color: AppColors.primarySoft,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      const Expanded(
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
        VitPageSection(
          key: StakingInsuranceFundKeys.audits,
          label: 'Monthly Audit Reports',
          accentColor: AppColors.primarySoft,
          children: const [
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
