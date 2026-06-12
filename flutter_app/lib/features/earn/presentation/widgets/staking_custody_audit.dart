import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_custody_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingCustodyReconciliationSection extends StatelessWidget {
  const StakingCustodyReconciliationSection({
    super.key,
    required this.snapshot,
    required this.onAuditTrail,
  });

  final StakingCustodySnapshot snapshot;
  final VoidCallback onAuditTrail;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Daily Reconciliation Audit Trail',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingCustodyKeys.reconciliation,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                snapshot.reconciliationBody,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.stakingCustodyBodyLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              for (final log in snapshot.reconciliationLogs) ...[
                StakingCustodyReconciliationLogCard(log: log),
                if (log != snapshot.reconciliationLogs.last)
                  const SizedBox(height: AppSpacing.x2),
              ],
              const SizedBox(height: AppSpacing.x3),
              StakingCustodyActionButton(
                key: StakingCustodyKeys.auditTrailButton,
                label: 'View Full Audit Trail',
                onTap: onAuditTrail,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StakingCustodyTransparencySection extends StatelessWidget {
  const StakingCustodyTransparencySection({super.key, required this.snapshot});

  final StakingCustodySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Transparency Commitment',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingCustodyKeys.transparency,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.visibility_outlined,
                color: AppColors.primarySoft,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Real-time On-Chain Verification',
                      style: AppTextStyles.baseMedium,
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      snapshot.transparencyBody,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: AppSpacing.stakingCustodyBodyLineHeight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    for (final address in snapshot.transparencyAddresses) ...[
                      StakingCustodyAddressRow(address: address),
                      if (address != snapshot.transparencyAddresses.last)
                        const SizedBox(height: AppSpacing.x2),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
