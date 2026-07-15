part of '../../pages/tools/launchpad_limit_orders_page.dart';

String _formatPrice(double value) => VitFormat.usd(value);

String _formatAmount(double value) {
  final decimals = value == value.roundToDouble() ? 0 : 2;
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = VitFormat.thousands(parts.first);
  return parts.length > 1 ? '$whole.${parts[1]}' : whole;
}
