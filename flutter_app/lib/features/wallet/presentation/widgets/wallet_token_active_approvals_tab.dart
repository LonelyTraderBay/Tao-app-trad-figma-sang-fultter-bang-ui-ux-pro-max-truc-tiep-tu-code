import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';

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
        WalletTokenSecurityOverview(snapshot: snapshot),
        const SizedBox(height: 18),
        WalletTokenCriticalAlert(count: snapshot.criticalCount),
        const SizedBox(height: 17),
        const WalletTokenApprovalSectionLabel(label: 'Active Approvals'),
        const SizedBox(height: 11),
        for (var i = 0; i < approvals.length; i++) ...[
          WalletTokenApprovalCard(approval: approvals[i], onRevoke: onRevoke),
          if (i != approvals.length - 1) const SizedBox(height: 14),
        ],
        const SizedBox(height: 17),
        WalletTokenApprovalRevokeAllButton(onTap: onRevokeAll),
        const SizedBox(height: 16),
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
    return Container(
      height: 203,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: walletTokenApprovalPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: walletTokenApprovalBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: walletTokenApprovalPurple.withValues(alpha: .14),
                  borderRadius: AppRadii.inputRadius,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.shield_outlined,
                  color: walletTokenApprovalPurple,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Token Approvals',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.approvals.length} active approvals',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
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
          const Spacer(),
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
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
              height: 1,
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
    return Container(
      height: 104,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: walletTokenApprovalRed.withValues(alpha: .07),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(
          color: walletTokenApprovalRed.withValues(alpha: .23),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: walletTokenApprovalRed,
            size: 17,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Critical Security Risk',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have $count approval(s) to unverified contracts. Revoke immediately to protect your funds.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
