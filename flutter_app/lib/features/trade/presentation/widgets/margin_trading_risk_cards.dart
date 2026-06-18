part of '../pages/margin_trading_page.dart';

class _RiskWarningCard extends StatelessWidget {
  const _RiskWarningCard({required this.warning});

  final TradeMarginRiskWarning warning;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginAmber.withValues(alpha: .06),
      borderColor: _marginAmber.withValues(alpha: .35),
      padding: AppSpacing.cardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _marginAmber,
            size: AppSpacing.walletAssetActionIconInner,
          ),
          const SizedBox(width: AppSpacing.walletAssetChartBottomGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warning.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.walletAssetChartBottomGap),
                for (final item in warning.items) ...[
                  _Bullet(text: item, color: _marginAmber),
                  if (item != warning.items.last)
                    const SizedBox(height: AppSpacing.transferCardGap),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NegativeBalanceCard extends StatelessWidget {
  const _NegativeBalanceCard({required this.disclosure});

  final TradeMarginSafetyDisclosure disclosure;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      color: _marginGreen.withValues(alpha: .07),
      borderColor: _marginGreen.withValues(alpha: .18),
      padding: AppSpacing.cardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MarginIconSurface(
            icon: Icons.shield_outlined,
            color: _marginGreen,
          ),
          const SizedBox(width: AppSpacing.walletAssetHeroTopGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disclosure.title,
                  style: AppTextStyles.body.copyWith(
                    color: _marginGreen,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  disclosure.body,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.transferCardGap),
                Text(
                  disclosure.footer,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BestExecutionCard extends StatelessWidget {
  const _BestExecutionCard({required this.disclosure, required this.onTap});

  final TradeMarginBestExecutionDisclosure disclosure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: AppSpacing.cardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MarginIconSurface(
            icon: Icons.description_outlined,
            color: _marginPrimary,
          ),
          const SizedBox(width: AppSpacing.walletAssetHeroTopGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disclosure.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  disclosure.body,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x3),
                for (final item in disclosure.items) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: _marginPrimary,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.formFieldLabelGap),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item != disclosure.items.last)
                    const SizedBox(height: AppSpacing.x2),
                ],
                const SizedBox(height: AppSpacing.walletAssetHeroTopGap),
                Align(
                  alignment: Alignment.centerLeft,
                  child: VitStatusPill(
                    label: disclosure.actionLabel,
                    status: VitStatusPillStatus.info,
                    size: VitStatusPillSize.lg,
                    onTap: onTap,
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
