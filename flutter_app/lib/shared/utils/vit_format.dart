import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:vit_trade_flutter/core/utils/number_formatters.dart';
import 'package:vit_trade_flutter/shared/utils/currency_formatters.dart';

/// Shared display-format facade. Prefer this import over ad-hoc local
/// `*_format*` helpers when the value is generic (not Arena-points-only
/// or module-specific product copy).
///
/// Quy ước ngôn ngữ hiển thị số (FMT-1, DEC-i18n phương án (a)):
/// - **USD luôn theo quy ước en-US**: `$1,234.50` — dấu phẩy nhóm nghìn,
///   dấu chấm thập phân ([usd], [usdSigned], [usdWhole], [usdWholeSigned]).
/// - **Số đếm/VND theo vi-VN hiển thị trong copy tiếng Việt** nhưng dùng cùng
///   dấu phẩy nhóm nghìn ([count], [compactInt], [thousands]) — sản phẩm giữ
///   MỘT kiểu nhóm nghìn thống nhất trên toàn app cho tới khi có backend
///   locale thật (nâng cấp gen-l10n ghi ở AGENTS.md "Chính sách ngôn ngữ").
///
/// Bài học drift 440dcb06: MỌI call site phải đi qua facade này — import
/// thẳng `currency_formatters.dart`/`number_formatters.dart` bị chặn bởi
/// `test/quality/vit_format_facade_guardrail_test.dart`; đổi format ở một
/// nơi duy nhất để copy tiền tệ không lệch âm thầm giữa các module.
abstract final class VitFormat {
  static String usd(double value) => formatUsd(value);

  /// USD amount with an explicit leading sign, e.g. `1234.5` -> `+$1,234.50`,
  /// `-1234.5` -> `-$1,234.50`.
  static String usdSigned(double value) {
    final sign = value < 0 ? '-' : '+';
    return '$sign${formatUsd(value.abs())}';
  }

  /// Whole-dollar USD amount (rounded, no decimals), e.g. `1234.5` ->
  /// `$1,235`.
  static String usdWhole(num value) {
    final rounded = value.round();
    final sign = rounded < 0 ? '-' : '';
    return '$sign\$${insertThousandsSeparator(rounded.abs().toString())}';
  }

  /// Whole-dollar USD amount with an explicit leading sign, e.g. `1234.5` ->
  /// `+$1,235`, `-1234.5` -> `-$1,235`.
  static String usdWholeSigned(num value) {
    final rounded = value.round();
    final sign = rounded < 0 ? '-' : '+';
    return '$sign\$${insertThousandsSeparator(rounded.abs().toString())}';
  }

  /// Thousands-grouped integer count, no currency prefix, e.g. `1234` ->
  /// `1,234`.
  static String count(int value) {
    final sign = value < 0 ? '-' : '';
    return '$sign${insertThousandsSeparator(value.abs().toString())}';
  }

  static String thousands(String digits) => insertThousandsSeparator(digits);

  static String email(String value) => maskEmail(value);

  static String account(String value) => maskAccountNumber(value);

  /// Percentage with fixed decimals, e.g. `12.345` + 2 -> `12.35%`.
  static String percent(num value, {int fractionDigits = 2}) {
    return '${value.toStringAsFixed(fractionDigits)}%';
  }

  /// Percentage with an explicit leading sign, zero is treated as positive,
  /// e.g. `12.34` -> `+12.3%`, `-12.34` -> `-12.3%`, `0` -> `+0.0%`.
  static String signedPercent(num value, {int fractionDigits = 1}) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(fractionDigits)}%';
  }

  /// Compact VND-style absolute amount with thousands separators (no suffix).
  static String compactInt(num value) {
    final whole = value.round().abs().toString();
    final signed = value < 0 ? '-' : '';
    return '$signed${insertThousandsSeparator(whole)}';
  }

  /// Compact magnitude-suffixed value, e.g. `1234` -> `1.2K`, `2500000` ->
  /// `2.5M`, `-1500000000` -> `-1.5B`. Optional [prefix] (e.g. `'$'`) is
  /// inserted after the sign and before the number.
  static String compactSuffix(
    num value, {
    int fractionDigits = 1,
    bool stripTrailingZero = false,
    String prefix = '',
  }) {
    final sign = value < 0 ? '-' : '';
    final abs = value.abs();
    String fixed(double n) {
      final s = n.toStringAsFixed(fractionDigits);
      return stripTrailingZero ? s.replaceAll(RegExp(r'\.0+$'), '') : s;
    }

    if (abs >= 1e9) return '$sign$prefix${fixed(abs / 1e9)}B';
    if (abs >= 1e6) return '$sign$prefix${fixed(abs / 1e6)}M';
    if (abs >= 1e3) return '$sign$prefix${fixed(abs / 1e3)}K';
    return '$sign$prefix${abs.toStringAsFixed(0)}';
  }
}
