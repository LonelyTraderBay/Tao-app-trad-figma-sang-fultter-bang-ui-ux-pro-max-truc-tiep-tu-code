/// Shared VND / crypto amount formatters for the P2P module.
///
/// Consolidates the dot-grouped VND formatter and fixed-precision crypto
/// formatter that were independently re-implemented (byte-for-byte
/// equivalent, modulo `int`/`num`/`double` parameter widening) across
/// multiple P2P page-family files. See
/// `run-artifacts/ponytail-audit-p2p-2026-07-11.md` finding #1.
library;

/// Formats [value] as a VND amount grouped with `.` every 3 digits from the
/// right, e.g. `1234567` -> `"1.234.567"`. Non-integer input is rounded
/// first.
String formatP2PVnd(num value) {
  final raw = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}

/// Formats a crypto [value] with a fixed 4-decimal precision.
String formatP2PCrypto(double value) => value.toStringAsFixed(4);
