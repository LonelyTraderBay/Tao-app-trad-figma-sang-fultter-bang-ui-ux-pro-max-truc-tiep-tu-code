import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

class WalletTokenApprovalHistoryTab extends StatelessWidget {
  const WalletTokenApprovalHistoryTab({required this.snapshot, super.key});

  final WalletTokenApprovalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Revoked Approvals',
      headerIcon: Icons.history_rounded,
      accentColor: walletTokenApprovalPrimary,
      innerGap: AppSpacing.pageRhythmFormInnerGap,
      children: [
        for (final revoked in snapshot.revokedApprovals) ...[
          VitCard(
            density: VitDensity.compact,
            borderColor: walletTokenApprovalBorder,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: walletTokenApprovalGreen,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(
                  width: WalletSpacingTokens.walletTokenApprovalHeaderGap,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${revoked.token} \u2192 ${revoked.spenderName}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmFormSectionGap,
                      ),
                      Text(
                        revoked.reason,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                VitStatusPill(
                  label: revoked.revokedAtLabel,
                  icon: Icons.schedule_rounded,
                  status: VitStatusPillStatus.neutral,
                  size: VitStatusPillSize.sm,
                ),
              ],
            ),
          ),
          const SizedBox(height: WalletSpacingTokens.walletTokenStatValueGap),
        ],
        VitCard(
          density: VitDensity.compact,
          borderColor: walletTokenApprovalBorder,
          child: const Row(
            children: [
              WalletTokenApprovalHistoryMetric(
                label: 'Total Revoked',
                value: '2',
              ),
              WalletTokenApprovalHistoryMetric(
                label: 'Funds Protected',
                value: '\$47,200',
                color: walletTokenApprovalGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WalletTokenApprovalHistoryMetric extends StatelessWidget {
  const WalletTokenApprovalHistoryMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    super.key,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.rowGap),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
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
