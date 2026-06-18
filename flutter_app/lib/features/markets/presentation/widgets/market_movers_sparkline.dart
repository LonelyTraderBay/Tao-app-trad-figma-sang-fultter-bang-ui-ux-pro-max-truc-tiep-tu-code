part of '../pages/market_movers_page.dart';

String _formatPrice(double value) {
  if (value >= 1) {
    return _formatFixed(value, 2);
  }
  if (value >= 0.01) {
    return _formatFixed(value, 4);
  }
  return _formatFixed(value, 6);
}

String _formatCompact(double value, {String prefix = ''}) {
  if (value >= 1000000000) {
    return '$prefix${_formatFixed(value / 1000000000, 2)}B';
  }
  if (value >= 1000000) {
    return '$prefix${_formatFixed(value / 1000000, 2)}M';
  }
  if (value >= 1000) {
    return '$prefix${_formatFixed(value / 1000, 2)}K';
  }
  return '$prefix${_formatFixed(value, 2)}';
}

String _formatFixed(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String _formatSignedPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
