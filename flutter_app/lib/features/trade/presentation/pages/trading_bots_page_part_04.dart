part of 'trading_bots_page.dart';

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.buy),
          boxShadow: [
            BoxShadow(
              color: AppColors.dynamicIslandBg.withValues(alpha: .45),
              blurRadius: 28,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.buy),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bot đã được khởi chạy!',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    'Bot đang hoạt động và giao dịch tự động',
                    style: AppTextStyles.captionSm,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded, size: 18),
              color: AppColors.text3,
            ),
          ],
        ),
      ),
    );
  }
}

(String, Color, Color) _riskStyle(TradeBotRisk risk) {
  return switch (risk) {
    TradeBotRisk.low => (
      'Thấp',
      AppColors.buy.withValues(alpha: .12),
      AppColors.buy,
    ),
    TradeBotRisk.medium => (
      'Trung bình',
      AppColors.warn.withValues(alpha: .12),
      AppColors.warn,
    ),
    TradeBotRisk.high => (
      'Cao',
      AppColors.sell.withValues(alpha: .10),
      AppColors.sell,
    ),
  };
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

String _formatSignedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${value.abs().toStringAsFixed(2)}';
}

String _formatSignedPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
