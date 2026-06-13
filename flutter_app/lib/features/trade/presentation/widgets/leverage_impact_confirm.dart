part of '../pages/leverage_page.dart';

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({required this.margin, required this.preview});

  final double margin;
  final TradeFuturesLeveragePreview preview;

  @override
  Widget build(BuildContext context) {
    final rows = [
      (
        'Giá trị hợp đồng',
        '\$${_formatWholeNumber(preview.positionSize)}',
        AppColors.text1,
      ),
      (
        'Thanh lý cách giá vào',
        '~${preview.liquidationDistancePct.toStringAsFixed(1)}%',
        AppColors.sell,
      ),
      (
        'Phí mở vị thế (0.02%)',
        '\$${preview.openFee.toStringAsFixed(4)}',
        AppColors.warn,
      ),
      (
        'Lợi nhuận nếu +1%',
        '+\$${preview.profitAtOnePct.toStringAsFixed(2)}',
        AppColors.buy,
      ),
      (
        'Lỗ nếu -1%',
        '-\$${preview.lossAtOnePct.toStringAsFixed(2)}',
        AppColors.sell,
      ),
    ];

    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 13),
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: _tradePrimary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Ước tính tác động',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Với ký quỹ \$${_formatWholeNumber(margin)} USDT',
            style: AppTextStyles.captionSm.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 11),
          for (final row in rows)
            _ImpactRow(label: row.$1, value: row.$2, valueColor: row.$3),
        ],
      ),
    );
  }
}

class _ImpactRow extends StatelessWidget {
  const _ImpactRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.captionSm.copyWith(
                color: AppColors.text3,
                height: 1.15,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.numericCode.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.preview});

  final TradeFuturesLeveragePreview preview;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: 'Leverage risk review',
      message: preview.warningText,
      contractId: 'SC-058 ${preview.leverage}x',
    );
  }
}

class _RiskTipsCard extends StatelessWidget {
  const _RiskTipsCard();

  static const _tips = [
    'Luôn đặt Stop Loss để giới hạn lỗ',
    'Không sử dụng quá 5% tổng vốn cho 1 lệnh',
    'Theo dõi vị thế thường xuyên',
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      borderColor: AppColors.sell.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.sell,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Lưu ý quan trọng',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final tip in _tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.sell,
                    size: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTextStyles.captionSm.copyWith(
                      color: AppColors.text2,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            if (tip != _tips.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.leverage, required this.onPressed});

  final int leverage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: LeveragePage.confirmKey,
      onPressed: onPressed,
      height: 52,
      variant: leverage > 20
          ? VitCtaButtonVariant.danger
          : VitCtaButtonVariant.primary,
      child: Text(
        'Xác nhận đòn bẩy ${leverage}x',
        style: AppTextStyles.baseMedium.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

String _formatWholeNumber(double value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return buffer.toString();
}
