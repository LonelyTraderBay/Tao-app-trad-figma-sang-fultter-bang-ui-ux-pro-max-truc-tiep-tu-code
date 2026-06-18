part of '../pages/sub_account_page.dart';

class _SubAccountSummaryCard extends StatelessWidget {
  const _SubAccountSummaryCard({
    required this.snapshot,
    required this.isBalanceHidden,
    required this.onToggleBalance,
  });

  final ProfileSubAccountsSnapshot snapshot;
  final bool isBalanceHidden;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    final pnlColor = snapshot.totalPnl30d >= 0 ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: SubAccountPage.summaryKey,
      padding: AppSpacing.profileSubAccountSummaryPadding,
      radius: VitCardRadius.lg,
      variant: VitCardVariant.hero,
      borderColor: AppColors.primary20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.group_outlined,
                color: AppColors.primary,
                size: AppSpacing.profileSubAccountSummaryIcon,
              ),
              const SizedBox(width: AppSpacing.profileSubAccountSummaryIconGap),
              Expanded(
                child: Text(
                  'T\u1ED5ng t\u00E0i s\u1EA3n t\u1EA5t c\u1EA3 t\u00E0i kho\u1EA3n',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              VitIconButton(
                key: SubAccountPage.balanceToggleKey,
                icon: isBalanceHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                tooltip: isBalanceHidden
                    ? 'Hi\u1EC3n s\u1ED1 d\u01B0'
                    : '\u1EA8n s\u1ED1 d\u01B0',
                onPressed: onToggleBalance,
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.profileSubAccountSummaryBalanceGap),
          Text(
            isBalanceHidden
                ? '\u2022\u2022\u2022\u2022\u2022\u2022'
                : _formatUsd(snapshot.totalBalance),
            style: AppTextStyles.heroNumber.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.profileSubAccountSummaryPnlGap),
          Text(
            isBalanceHidden
                ? 'PnL 30d: \u2022\u2022\u2022\u2022'
                : 'PnL 30d: ${_formatSignedUsd(snapshot.totalPnl30d)}',
            style: AppTextStyles.caption.copyWith(
              color: pnlColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(
            height: AppSpacing.profileSubAccountSummaryMetricTopGap,
          ),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'T\u1ED5ng TK',
                  value: '${snapshot.accounts.length}',
                  valueColor: AppColors.text1,
                ),
              ),
              const SizedBox(
                width: AppSpacing.profileSubAccountSummaryMetricGap,
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Ho\u1EA1t \u0111\u1ED9ng',
                  value: '${snapshot.activeCount}',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(
                width: AppSpacing.profileSubAccountSummaryMetricGap,
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'API Keys',
                  value: '${snapshot.apiKeyCount}',
                  valueColor: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.profileSubAccountSummaryMetricHeight,
      child: Material(
        color: AppColors.portfolioBtnGhost,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
        child: Padding(
          padding: AppSpacing.profileSubAccountSummaryMetricPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
              const SizedBox(
                height: AppSpacing.profileSubAccountSummaryMetricValueGap,
              ),
              Text(
                value,
                style: AppTextStyles.baseMedium.copyWith(color: valueColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
