import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';

class WalletTokenApprovalHistoryTab extends StatelessWidget {
  const WalletTokenApprovalHistoryTab({required this.snapshot, super.key});

  final WalletTokenApprovalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WalletTokenApprovalSectionLabel(label: 'Revoked Approvals'),
        const SizedBox(height: 10),
        for (final revoked in snapshot.revokedApprovals) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: walletTokenApprovalPanel,
              borderRadius: AppRadii.inputRadius,
              border: Border.all(color: walletTokenApprovalBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: walletTokenApprovalGreen,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${revoked.token} \u2192 ${revoked.spenderName}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        revoked.reason,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  revoked.revokedAtLabel,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: walletTokenApprovalPanel,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(color: walletTokenApprovalBorder),
          ),
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
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}
