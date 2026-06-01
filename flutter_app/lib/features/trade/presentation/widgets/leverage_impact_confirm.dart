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

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 13),
      decoration: BoxDecoration(
        color: _panelBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
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
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Với ký quỹ \$${_formatWholeNumber(margin)} USDT',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
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
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
                height: 1.15,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
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
    final danger = preview.leverage > 20;
    final color = danger ? AppColors.sell : AppColors.warn;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              preview.warningText,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 12,
                height: 1.6,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.sell.withValues(alpha: .22)),
      ),
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
                  fontSize: 13,
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
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
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
    return InkWell(
      key: LeveragePage.confirmKey,
      onTap: onPressed,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_tradePrimary, _tradePrimaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadii.cardRadius,
          boxShadow: [
            BoxShadow(
              color: _tradePrimary.withValues(alpha: .25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          'Xác nhận đòn bẩy ${leverage}x',
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.onAccent,
            fontWeight: AppTextStyles.bold,
          ),
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
