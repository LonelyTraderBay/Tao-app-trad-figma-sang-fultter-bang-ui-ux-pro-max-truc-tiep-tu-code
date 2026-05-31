import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';

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

class WalletTokenApprovalCard extends StatelessWidget {
  const WalletTokenApprovalCard({
    required this.approval,
    required this.onRevoke,
    super.key,
  });

  final WalletTokenApproval approval;
  final ValueChanged<WalletTokenApproval> onRevoke;

  @override
  Widget build(BuildContext context) {
    final riskColor = walletTokenApprovalRiskColor(approval.riskLevel);
    final bordered =
        approval.riskLevel == 'critical' || approval.riskLevel == 'high';
    final showUnusedWarning = approval.unlimited && approval.usageCount == 0;
    return Container(
      key: walletTokenApprovalApprovalKey(approval.id),
      height: showUnusedWarning ? 252 : 212,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: walletTokenApprovalPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(
          color: bordered ? riskColor : walletTokenApprovalBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletTokenCategoryIcon(approval: approval),
              const SizedBox(width: 10),
              Expanded(
                child: WalletTokenApprovalHeaderText(approval: approval),
              ),
              const SizedBox(width: 8),
              Semantics(
                button: true,
                label:
                    'Revoke approval for ${approval.token} to ${approval.spenderName}',
                child: GestureDetector(
                  key: walletTokenApprovalRevokeKey(approval.id),
                  onTap: () => onRevoke(approval),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: walletTokenApprovalRed.withValues(alpha: .10),
                      borderRadius: AppRadii.cardRadius,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: walletTokenApprovalRed,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          WalletTokenApprovalAmount(approval: approval),
          const SizedBox(height: 15),
          Row(
            children: [
              WalletTokenApprovalStat(
                label: 'Approved',
                value: approval.approvedAtLabel,
              ),
              WalletTokenApprovalStat(
                label: 'Last Used',
                value: approval.lastUsedLabel,
              ),
              WalletTokenApprovalStat(
                label: 'Usage',
                value: '${approval.usageCount}x',
              ),
            ],
          ),
          if (showUnusedWarning) ...[
            const Spacer(),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: walletTokenApprovalRed.withValues(alpha: .07),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: walletTokenApprovalRed,
                    size: 12,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Unused unlimited approval - revoke to protect funds',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: walletTokenApprovalRed,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class WalletTokenCategoryIcon extends StatelessWidget {
  const WalletTokenCategoryIcon({required this.approval, super.key});

  final WalletTokenApproval approval;

  @override
  Widget build(BuildContext context) {
    final color = walletTokenApprovalRiskColor(approval.riskLevel);
    final icon = switch (approval.category) {
      'dex' => Icons.trending_up_rounded,
      'lending' => Icons.attach_money_rounded,
      _ => Icons.shield_outlined,
    };
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 17),
    );
  }
}

class WalletTokenApprovalHeaderText extends StatelessWidget {
  const WalletTokenApprovalHeaderText({required this.approval, super.key});

  final WalletTokenApproval approval;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              approval.token,
              style: AppTextStyles.baseMedium.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              approval.verified
                  ? Icons.check_circle_outline_rounded
                  : Icons.cancel_outlined,
              color: approval.verified
                  ? walletTokenApprovalGreen
                  : walletTokenApprovalRed,
              size: 13,
            ),
            const SizedBox(width: 8),
            WalletTokenRiskBadge(risk: approval.riskLevel),
          ],
        ),
        const SizedBox(height: 11),
        Text(
          '\u2192 ${approval.spenderName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          approval.maskedSpender,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            fontFamily: 'Roboto',
            height: 1,
          ),
        ),
      ],
    );
  }
}

class WalletTokenRiskBadge extends StatelessWidget {
  const WalletTokenRiskBadge({required this.risk, super.key});

  final String risk;

  @override
  Widget build(BuildContext context) {
    final color = walletTokenApprovalRiskColor(risk);
    return Container(
      height: 17,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        risk.toUpperCase(),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class WalletTokenApprovalAmount extends StatelessWidget {
  const WalletTokenApprovalAmount({required this.approval, super.key});

  final WalletTokenApproval approval;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: approval.unlimited
            ? walletTokenApprovalRed.withValues(alpha: .08)
            : AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Approved Amount',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
          ),
          Text(
            approval.unlimited
                ? '\u221E ${approval.amountLabel}'
                : approval.amountLabel,
            style: AppTextStyles.caption.copyWith(
              color: approval.unlimited
                  ? walletTokenApprovalRed
                  : AppColors.text1,
              fontSize: 13,
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

class WalletTokenApprovalStat extends StatelessWidget {
  const WalletTokenApprovalStat({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
