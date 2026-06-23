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
    return VitCard(
      key: walletTokenApprovalApprovalKey(approval.id),
      constraints: BoxConstraints(
        minHeight: showUnusedWarning
            ? AppSpacing.walletTokenApprovalWarningMinHeight
            : AppSpacing.walletTokenApprovalMinHeight,
      ),
      padding: AppSpacing.walletTokenApprovalPadding,
      borderColor: bordered ? riskColor : walletTokenApprovalBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletTokenCategoryIcon(approval: approval),
              const SizedBox(width: AppSpacing.walletTokenApprovalHeaderGap),
              Expanded(
                child: WalletTokenApprovalHeaderText(approval: approval),
              ),
              const SizedBox(width: AppSpacing.walletTokenApprovalActionGap),
              Semantics(
                button: true,
                label:
                    'Revoke approval for ${approval.token} to ${approval.spenderName}',
                child: VitCard(
                  key: walletTokenApprovalRevokeKey(approval.id),
                  onTap: () => onRevoke(approval),
                  width: AppSpacing.walletTokenApprovalActionSize,
                  height: AppSpacing.walletTokenApprovalActionSize,
                  variant: VitCardVariant.inner,
                  borderColor: walletTokenApprovalRed.withValues(alpha: .26),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: walletTokenApprovalRed,
                    size: AppSpacing.walletTokenApprovalActionIcon,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletTokenApprovalContentGap),
          WalletTokenApprovalAmount(approval: approval),
          const SizedBox(height: AppSpacing.walletTokenApprovalAmountGap),
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
            const SizedBox(height: AppSpacing.walletTokenApprovalUnusedGap),
            VitCard(
              height: AppSpacing.walletTokenApprovalUnusedHeight,
              padding: AppSpacing.walletTokenApprovalUnusedPadding,
              variant: VitCardVariant.inner,
              radius: VitCardRadius.sm,
              borderColor: walletTokenApprovalRed.withValues(alpha: .20),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: walletTokenApprovalRed,
                    size: AppSpacing.walletTokenApprovalUnusedIcon,
                  ),
                  const SizedBox(
                    width: AppSpacing.walletTokenApprovalUnusedTextGap,
                  ),
                  Expanded(
                    child: Text(
                      'Unused unlimited approval - revoke to protect funds',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: walletTokenApprovalRed,
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
    return VitCard(
      width: AppSpacing.walletTokenCategoryIcon,
      height: AppSpacing.walletTokenCategoryIcon,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: color.withValues(alpha: .20),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: color,
        size: AppSpacing.walletTokenCategoryGlyph,
      ),
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
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.walletTokenHeaderWrapSpacing,
          runSpacing: AppSpacing.walletTokenHeaderRunSpacing,
          children: [
            Text(
              approval.token,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Icon(
              approval.verified
                  ? Icons.check_circle_outline_rounded
                  : Icons.cancel_outlined,
              color: approval.verified
                  ? walletTokenApprovalGreen
                  : walletTokenApprovalRed,
              size: AppSpacing.walletTokenVerifiedIcon,
            ),
            WalletTokenRiskBadge(risk: approval.riskLevel),
          ],
        ),
        const SizedBox(height: AppSpacing.walletTokenSpenderGap),
        Text(
          '\u2192 ${approval.spenderName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.walletTokenMaskedGap),
        Text(
          approval.maskedSpender,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
