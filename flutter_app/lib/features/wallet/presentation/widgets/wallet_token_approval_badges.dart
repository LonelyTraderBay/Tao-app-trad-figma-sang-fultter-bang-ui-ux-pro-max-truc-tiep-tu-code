part of 'wallet_token_active_approvals_tab.dart';

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
