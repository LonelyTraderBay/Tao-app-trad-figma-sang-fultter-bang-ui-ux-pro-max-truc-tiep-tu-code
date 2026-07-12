/// Small, pure-Dart number-formatting helpers with no Flutter dependency,
/// shared across features that render comma-grouped values (e.g. sub-account
/// balances, API usage counters, VIP tier volumes).
library;

/// Inserts thousands-separator commas into a digit string, e.g. `"1234567"`
/// -> `"1,234,567"`. Operates on the string as-is (no sign/decimal-point
/// handling) — callers that need signed or fixed-point formatting should
/// split those parts out before calling this.
String insertThousandsSeparator(String input) {
  final buffer = StringBuffer();
  for (var i = 0; i < input.length; i += 1) {
    final remaining = input.length - i;
    buffer.write(input[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
