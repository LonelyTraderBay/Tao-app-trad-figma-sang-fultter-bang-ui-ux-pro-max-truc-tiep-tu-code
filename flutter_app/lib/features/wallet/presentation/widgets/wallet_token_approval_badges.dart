part of 'wallet_token_active_approvals_tab.dart';

class WalletTokenRiskBadge extends StatelessWidget {
  const WalletTokenRiskBadge({required this.risk, super.key});

  final String risk;

  @override
  Widget build(BuildContext context) {
    final color = walletTokenApprovalRiskColor(risk);
    return VitAccentPill(label: risk.toUpperCase(), accentColor: color);
  }
}

class WalletTokenApprovalAmount extends StatelessWidget {
  const WalletTokenApprovalAmount({required this.approval, super.key});

  final WalletTokenApproval approval;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.walletTokenAmountHeight,
      padding: AppSpacing.walletTokenAmountPadding,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: approval.unlimited
          ? walletTokenApprovalRed.withValues(alpha: .20)
          : null,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Approved Amount',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
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
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.walletTokenStatValueGap),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
