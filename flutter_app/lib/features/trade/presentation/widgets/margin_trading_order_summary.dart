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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: _marginPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          _SummaryRow(
            'Margin khả dụng',
            _formatMoney(available),
            AppColors.onAccent,
          ),
          const SizedBox(height: 9),
          _SummaryRow('Giá thanh lý (ước tính)', liquidationPrice, _marginRed),
          const SizedBox(height: 9),
          const _SummaryRow('Phí giao dịch (0.05%)', '--', AppColors.text2),
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
              fontSize: 12,
              height: 1,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 12,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Margin order review',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          for (final check in checks) ...[
            _Bullet(text: check, color: _marginAmber),
            if (check != checks.last) const SizedBox(height: 7),
          ],
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
    return Container(
      key: MarginTradingPage.submitKey,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: disabled
            ? _marginPrimary.withValues(alpha: .06)
            : (side == 'long' ? _marginGreen : _marginRed),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Text(
        'Mở ${side == 'long' ? 'Long' : 'Short'} $pairSymbol (${leverage}x)',
        style: AppTextStyles.body.copyWith(
          color: disabled
              ? AppColors.text3.withValues(alpha: .45)
              : AppColors.onAccent,
          fontSize: 15,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
