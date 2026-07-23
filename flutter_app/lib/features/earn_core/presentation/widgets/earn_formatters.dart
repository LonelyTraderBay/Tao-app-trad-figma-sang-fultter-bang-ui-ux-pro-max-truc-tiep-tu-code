import 'package:vit_trade_flutter/shared/utils/vit_format.dart';

/// Shared formatting helpers for the `earn` module.
///
/// Consolidates the duplicate `_formatUsd(double)` implementations that were
/// hand-rolled identically across several page/widget part files (ponytail
/// audit `flutter_app/run-artifacts/ponytail-audit-earn-2026-07-11.md`,
/// finding #2). Only call sites whose local implementation was verified
/// byte-for-byte behaviorally identical to this one were migrated; sites with
/// genuinely different formatting rules (compaction to K/M/B, conditional
/// decimal places, etc.) were intentionally left untouched.
class EarnFormatters {
  const EarnFormatters._();

  /// Formats [value] as a `$`-prefixed, comma-grouped USD amount with a
  /// fixed 2 decimal places (e.g. `1234.5` -> `$1,234.50`).
  static String usd(double value) => VitFormat.usd(value);
}
