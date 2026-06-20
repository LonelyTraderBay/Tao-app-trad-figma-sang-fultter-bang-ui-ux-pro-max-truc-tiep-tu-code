part of '../pages/margin_trading_page.dart';

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.available,
    required this.liquidationPrice,
  });

  final double available;
  final String liquidationPrice;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.walletAssetSectionGap,
        top: AppSpacing.walletAssetHeroTopGap,
        right: AppSpacing.walletAssetSectionGap,
        bottom: AppSpacing.walletAssetHeroTopGap,
      ),
      variant: VitCardVariant.inner,
      child: VitPageContent(
        padding: VitContentPadding.none,
        density: VitDensity.compact,
        children: [
          _SummaryRow(
            'Margin kha dung',
            _formatMoney(available),
            AppColors.onAccent,
          ),
          _SummaryRow('Liquidation estimate', liquidationPrice, _marginRed),
          const _SummaryRow('Trading fee (0.05%)', '--', AppColors.text2),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _MarginOrderReviewCard extends StatelessWidget {
  const _MarginOrderReviewCard({required this.leverage});

  final int leverage;

  @override
  Widget build(BuildContext context) {
    final checks = [
      'Risk and leverage limit are reviewed at ${leverage}x before submission.',
      'Liquidation estimate, margin availability, and fee preview remain visible.',
    ];
    return _Panel(
      color: _marginAmber.withValues(alpha: .06),
      borderColor: _marginAmber.withValues(alpha: .28),
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.walletAssetSectionGap,
        top: AppSpacing.rowPy,
        right: AppSpacing.walletAssetSectionGap,
        bottom: AppSpacing.rowPy,
      ),
      child: VitPageContent(
        padding: VitContentPadding.none,
        density: VitDensity.compact,
        children: [
          Text(
            'Margin order review',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          VitPageContent(
            padding: VitContentPadding.none,
            density: VitDensity.compact,
            children: [
              for (final check in checks)
                _Bullet(text: check, color: _marginAmber),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.side,
    required this.leverage,
    required this.pairSymbol,
    required this.disabled,
  });

  final String side;
  final int leverage;
  final String pairSymbol;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: MarginTradingPage.submitKey,
      density: VitDensity.compact,
      onPressed: disabled ? null : () {},
      variant: side == 'long'
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.danger,
      child: Text(
        'Open ${side == 'long' ? 'Long' : 'Short'} $pairSymbol (${leverage}x)',
      ),
    );
  }
}
