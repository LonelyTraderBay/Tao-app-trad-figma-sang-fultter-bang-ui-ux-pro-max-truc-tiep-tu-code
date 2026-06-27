import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_icon_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';

part 'wallet_token_approval_cards.dart';
part 'wallet_token_approval_badges.dart';

class WalletTokenActiveApprovalsTab extends StatelessWidget {
  const WalletTokenActiveApprovalsTab({
    required this.snapshot,
    required this.onRevoke,
    required this.onRevokeAll,
    super.key,
  });

  final WalletTokenApprovalSnapshot snapshot;
  final ValueChanged<WalletTokenApproval> onRevoke;
  final VoidCallback onRevokeAll;

  @override
  Widget build(BuildContext context) {
    final approvals = snapshot.riskSortedApprovals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WalletTokenCriticalAlert(count: snapshot.criticalCount),
        const SizedBox(height: AppSpacing.walletTokenAlertGap),
        const WalletTokenApprovalSectionLabel(
          label: 'Active Approvals',
          icon: Icons.shield_outlined,
        ),
        const SizedBox(height: AppSpacing.walletTokenLabelGap),
        for (var i = 0; i < approvals.length; i++) ...[
          WalletTokenApprovalCard(approval: approvals[i], onRevoke: onRevoke),
          if (i != approvals.length - 1)
            const SizedBox(height: AppSpacing.walletTokenCardGap),
        ],
        const SizedBox(height: AppSpacing.walletTokenAlertGap),
        WalletTokenApprovalRevokeAllButton(onTap: onRevokeAll),
        const SizedBox(height: AppSpacing.walletTokenNoticeGap),
        const WalletTokenApprovalInfoNotice(),
      ],
    );
  }
}

class WalletTokenSecurityOverview extends StatelessWidget {
  const WalletTokenSecurityOverview({required this.snapshot, super.key});

  final WalletTokenApprovalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: walletTokenApprovalBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitCard(
                width: AppSpacing.walletTokenHeroIcon,
                height: AppSpacing.walletTokenHeroIcon,
                variant: VitCardVariant.inner,
                borderColor: walletTokenApprovalPurple.withValues(alpha: .20),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.shield_outlined,
                  color: walletTokenApprovalPurple,
                  size: AppSpacing.walletTokenHeroIconGlyph,
                ),
              ),
              const SizedBox(width: AppSpacing.walletTokenHeroGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Token Approvals',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.walletTokenTitleGap),
                    Text(
                      '${snapshot.approvals.length} active approvals',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletTokenMetricTopGap),
          Row(
            children: [
              WalletTokenOverviewMetric(
                label: 'Critical Risk',
                value: '${snapshot.criticalCount}',
                color: walletTokenApprovalRed,
              ),
              WalletTokenOverviewMetric(
                label: 'High Risk',
                value: '${snapshot.highRiskCount}',
                color: walletTokenApprovalOrange,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletTokenMetricTopGap),
          Row(
            children: [
              WalletTokenOverviewMetric(
                label: 'Unlimited',
                value: '${snapshot.unlimitedCount}',
                color: walletTokenApprovalAmber,
              ),
              WalletTokenOverviewMetric(
                label: 'Unused',
                value: '${snapshot.unusedCount}',
                color: AppColors.text1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WalletTokenOverviewMetric extends StatelessWidget {
  const WalletTokenOverviewMetric({
    required this.label,
    required this.value,
    required this.color,
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
            style: AppTextStyles.badge.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.walletTokenMetricValueGap),
          Text(
            value,
            style: AppTextStyles.amountSm.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class WalletTokenCriticalAlert extends StatelessWidget {
  const WalletTokenCriticalAlert({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.inner,
      borderColor: walletTokenApprovalRed.withValues(alpha: .23),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: walletTokenApprovalRed,
            size: AppSpacing.walletTokenAlertIcon,
          ),
          const SizedBox(width: AppSpacing.rowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Critical Security Risk',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.rowGap),
                Text(
                  'You have $count approval(s) to unverified contracts. Revoke immediately to protect your funds.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
