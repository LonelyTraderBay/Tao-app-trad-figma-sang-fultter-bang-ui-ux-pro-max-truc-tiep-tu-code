part of '../pages/portfolio_analytics_page.dart';

class _PlaceholderAnalyticsView extends StatelessWidget {
  const _PlaceholderAnalyticsView({required this.view});

  final String view;

  @override
  Widget build(BuildContext context) {
    final title = view == 'allocation'
        ? 'Ph\u00E2n b\u1ED5 danh m\u1EE5c'
        : 'L\u00E3i/L\u1ED7';
    return _VitCardSurface(
      padding: AppSpacing.walletAnalyticsPlaceholderPadding,
      child: Text(
        title,
        style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
      ),
    );
  }
}

class _VitCardSurface extends StatelessWidget {
  const _VitCardSurface({required this.child, this.padding, this.height});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: height,
      padding: padding,
      borderColor: AppColors.cardBorder,
      child: child,
    );
  }
}

final class _ViewItem {
  const _ViewItem(this.id, this.label, this.icon);

  final String id;
  final String label;
  final IconData icon;
}

String _formatUsd(double value, {bool symbol = true}) {
  final sign = value < 0 ? '-' : '';
  final abs = value.abs();
  final fixed = abs.toStringAsFixed(abs < 1 ? 4 : 2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  final prefix = symbol ? '\$' : '';
  return '$sign$prefix${buffer.toString()}.${parts[1]}';
}

String _formatCompactMoney(double value) {
  final fixed = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < fixed.length; i++) {
    if (i > 0 && (fixed.length - i) % 3 == 0) buffer.write(',');
    buffer.write(fixed[i]);
  }
  return buffer.toString();
}
