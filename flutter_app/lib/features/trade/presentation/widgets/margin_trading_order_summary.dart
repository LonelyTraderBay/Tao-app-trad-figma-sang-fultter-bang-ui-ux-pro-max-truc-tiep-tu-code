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
    return VitFinancialSafetySummary(
      title: 'Margin order preview',
      contractId: 'SC-085 Margin preview',
      density: VitDensity.compact,
      footer:
          'Review margin, liquidation, fee, leverage, and side before opening a position.',
      items: [
        VitFinancialSafetyItem(
          label: 'Available margin',
          value: _formatMoney(available),
          leading: const Icon(Icons.account_balance_wallet_outlined),
          valueColor: AppColors.onAccent,
        ),
        VitFinancialSafetyItem(
          label: 'Liquidation estimate',
          value: liquidationPrice,
          leading: const Icon(Icons.warning_amber_rounded),
          valueColor: _marginRed,
        ),
        const VitFinancialSafetyItem(
          label: 'Trading fee',
          value: '0.05% preview',
          leading: Icon(Icons.receipt_long_outlined),
          valueColor: AppColors.text2,
        ),
        const VitFinancialSafetyItem(
          label: 'Risk check',
          value: 'Confirm leverage before submit',
          leading: Icon(Icons.verified_user_outlined),
          valueColor: _marginAmber,
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
