part of '../pages/price_alerts_page.dart';

class _AddAlertButton extends StatelessWidget {
  const _AddAlertButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: PriceAlertsPage.addAlertKey,
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: AppSpacing.buttonStandard,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _marketPrimary.withValues(alpha: .13),
          border: Border.all(color: _marketPrimary.withValues(alpha: .30)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, color: _marketPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              'Tạo cảnh báo mới',
              style: AppTextStyles.body.copyWith(
                color: _marketPrimary,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

MarketPair? _findPair(List<MarketPair> pairs, String id) {
  for (final pair in pairs) {
    if (pair.id == id) return pair;
  }
  return null;
}

Color _progressColor(MarketPriceAlert alert, double progress) {
  if (alert.condition == MarketAlertCondition.above) {
    return progress >= 1 ? AppColors.buy : _marketPrimary;
  }
  return AppColors.sell;
}

String _formatUsd(double value) {
  final fractionDigits = value >= 100
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
  return '\$${buffer.toString()}.${parts.last}';
}
