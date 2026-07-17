/// Formats [value] as a USD amount with thousands separators and two
/// decimal places, e.g. `1234.5` -> `$1,234.50`, `-1234.5` -> `-$1,234.50`
/// (sign before `$`, matching `VitFormat.usdSigned`/`usdWhole`).
String formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final negative = fixed.startsWith('-');
  final parts = (negative ? fixed.substring(1) : fixed).split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${negative ? '-' : ''}\$${buffer.toString()}.${parts.last}';
}
