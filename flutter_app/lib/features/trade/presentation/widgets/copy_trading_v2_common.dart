part of '../pages/copy_trading_v2_page.dart';

String _titleCase(String value) {
  if (value.isEmpty) return value;
  return value.substring(0, 1).toUpperCase() + value.substring(1);
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (abs >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(0)}K';
  }
  return '$prefix${value.toStringAsFixed(0)}';
}

String _formatCompactNumber(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return '$value';
}
