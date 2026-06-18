part of '../pages/market_screener_page.dart';

class _ScreenerEmptyState extends StatelessWidget {
  const _ScreenerEmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.marketScreenerEmptyPadding,
      child: Column(
        children: [
          const Icon(
            Icons.filter_alt_off_rounded,
            color: AppColors.text3,
            size: AppSpacing.marketScreenerEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.marketScreenerEmptyGap),
          Text(
            'Không tìm thấy kết quả phù hợp',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.marketScreenerEmptyGap),
          TextButton(
            onPressed: onReset,
            style: TextButton.styleFrom(foregroundColor: _marketPrimary),
            child: const Text('Đặt lại bộ lọc'),
          ),
        ],
      ),
    );
  }
}

String _formatCompactUsd(double value) {
  if (value >= 1000000000000) {
    return '\$${(value / 1000000000000).toStringAsFixed(2)}T';
  }
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(2)}M';
  }
  return '\$${value.toStringAsFixed(0)}';
}

String _formatPrice(double value) {
  final fractionDigits = value >= 1000
      ? 2
      : value >= 1
      ? 2
      : 4;
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}
