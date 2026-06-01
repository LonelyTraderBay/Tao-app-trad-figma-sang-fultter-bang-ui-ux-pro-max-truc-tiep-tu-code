part of 'wallet_token_active_approvals_tab.dart';

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
