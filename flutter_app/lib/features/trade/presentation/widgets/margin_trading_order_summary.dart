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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      variant: VitCardVariant.inner,
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 9,
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
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 10,
        children: [
          Text(
            'Margin order review',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
              height: 1.1,
            ),
          ),
          VitPageContent(
            padding: VitContentPadding.none,
            customGap: 7,
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
      height: 52,
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
