part of '../pages/price_alerts_page.dart';

class _AddAlertButton extends StatelessWidget {
  const _AddAlertButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: PriceAlertsPage.addAlertKey,
      onPressed: onTap,
      variant: VitCtaButtonVariant.secondary,
      height: _alertsFilterHeight,
      leading: const Icon(Icons.add_rounded, size: _alertsAddIcon),
      child: Text(
        'T\u1EA1o c\u1EA3nh b\u00E1o m\u1EDBi',
        style: AppTextStyles.body.copyWith(
          fontWeight: AppTextStyles.bold,
          height: _alertsLineHeightTight,
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
