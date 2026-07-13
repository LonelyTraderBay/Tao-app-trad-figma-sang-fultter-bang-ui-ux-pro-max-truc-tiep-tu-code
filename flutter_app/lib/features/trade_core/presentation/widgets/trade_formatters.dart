/// Shared price/money formatters for trade terminal surfaces.
String formatTradePrice(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$buffer.${parts.last}';
}

String formatTradeMoney(double value) => formatTradePrice(value);

/// Thousands-grouped non-negative integer, e.g. `1,234`.
String formatTradeInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

/// USD amount with thousands separators and exact cents, e.g. `$1,234.56`.
String formatTradeUsd(double value) => '\$${formatTradeMoney(value)}';

/// Whole-dollar USD amount with thousands separators, e.g. `$1,235.00`.
String formatTradeUsdWhole(double value) =>
    '\$${formatTradeMoney(value.roundToDouble())}';

/// Rounded whole-dollar USD amount with thousands separators and no
/// decimal places, e.g. `$1,235`.
String formatTradeUsdRounded(double value) =>
    '\$${formatTradeInt(value.round())}';

/// Signed, rounded whole-dollar USD amount, e.g. `+$1,235` / `-$1,235`.
String formatTradeSignedUsdRounded(double value) =>
    '${value >= 0 ? '+' : '-'}${formatTradeUsdRounded(value.abs())}';

/// Signed USD amount with thousands separators and exact cents,
/// e.g. `+$1,234.56` / `-$1,234.56`.
String formatTradeSignedMoney(double value) =>
    '${value >= 0 ? '+' : '-'}\$${formatTradeMoney(value.abs())}';

/// EUR amount with thousands separators, sign before the currency symbol,
/// e.g. `-€1,234`.
String formatTradeEur(double value) {
  final rounded = value.round();
  final sign = rounded < 0 ? '-' : '';
  return '$sign€${formatTradeInt(rounded.abs())}';
}

/// Compact `K`-suffixed integer, e.g. `1K` for values >= 1000, else the
/// plain integer.
String formatTradeCompactNumber(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return '$value';
}
