import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/utils/currency_formatters.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';

void main() {
  test('formatUsd groups thousands and keeps two decimals', () {
    expect(formatUsd(0), r'$0.00');
    expect(formatUsd(60), r'$60.00');
    expect(formatUsd(234.5), r'$234.50');
    expect(formatUsd(1234.5), r'$1,234.50');
    expect(formatUsd(1234567.89), r'$1,234,567.89');
  });

  test('formatUsd renders negatives with the sign before the dollar', () {
    // Regression: the grouping loop used to run over the '-' sign, so
    // formatUsd(-234) rendered r'$-,234.00'.
    expect(formatUsd(-234), r'-$234.00');
    expect(formatUsd(-1234.5), r'-$1,234.50');
    expect(formatUsd(-1234567.89), r'-$1,234,567.89');
  });

  test('VitFormat signed helpers keep the sign before the dollar', () {
    expect(VitFormat.usdSigned(1234.5), r'+$1,234.50');
    expect(VitFormat.usdSigned(-1234.5), r'-$1,234.50');
    expect(VitFormat.usdWhole(-1234.5), r'-$1,235');
    expect(VitFormat.usdWholeSigned(1234.5), r'+$1,235');
  });

  test('VitFormat.compactSuffix keeps magnitude thresholds and sign order', () {
    expect(VitFormat.compactSuffix(2500000, prefix: r'$'), r'$2.5M');
    expect(VitFormat.compactSuffix(1234, prefix: r'$'), r'$1.2K');
    expect(VitFormat.compactSuffix(-1500000000, prefix: r'$'), r'-$1.5B');
    expect(VitFormat.compactSuffix(999), r'999');
  });

  test('VitFormat.compactSuffix stripTrailingZero drops a trailing .0', () {
    expect(
      VitFormat.compactSuffix(2000000, stripTrailingZero: true),
      '2M',
    );
    expect(
      VitFormat.compactSuffix(2500000, stripTrailingZero: true),
      '2.5M',
    );
    expect(VitFormat.compactSuffix(2000000), '2.0M');
  });

  test('VitFormat.count groups thousands with no currency prefix', () {
    expect(VitFormat.count(0), '0');
    expect(VitFormat.count(1234), '1,234');
    expect(VitFormat.count(-1234), '-1,234');
    expect(VitFormat.count(1234567), '1,234,567');
  });

  test('VitFormat.thousands inserts separators into a raw digit string', () {
    expect(VitFormat.thousands('0'), '0');
    expect(VitFormat.thousands('1234'), '1,234');
    expect(VitFormat.thousands('1234567'), '1,234,567');
  });

  test('VitFormat.email masks the local part, keeps the domain', () {
    expect(VitFormat.email('nguyenvana@email.com'), 'n***@email.com');
    // Defensive fallback: no '@' returns the input unchanged.
    expect(VitFormat.email('not-an-email'), 'not-an-email');
  });

  test(
    'VitFormat.account keeps a short prefix and the last 4 characters',
    () {
      expect(VitFormat.account(''), '');
      expect(VitFormat.account('1234'), '***');
      expect(VitFormat.account('123456'), '1...3456');
      expect(VitFormat.account('0901234567'), '090...4567');
    },
  );

  test('VitFormat.percent uses the requested fraction digits', () {
    expect(VitFormat.percent(12.345), '12.35%');
    expect(VitFormat.percent(0), '0.00%');
    expect(VitFormat.percent(-5.5), '-5.50%');
    expect(VitFormat.percent(12.345, fractionDigits: 0), '12%');
  });

  test(
    'VitFormat.signedPercent adds an explicit sign, zero counts as positive',
    () {
      expect(VitFormat.signedPercent(12.34), '+12.3%');
      expect(VitFormat.signedPercent(-12.34), '-12.3%');
      expect(VitFormat.signedPercent(0), '+0.0%');
      expect(VitFormat.signedPercent(12.34, fractionDigits: 2), '+12.34%');
    },
  );

  test('VitFormat.compactInt groups thousands with no currency prefix', () {
    expect(VitFormat.compactInt(0), '0');
    expect(VitFormat.compactInt(1234.6), '1,235');
    expect(VitFormat.compactInt(-1234.6), '-1,235');
  });

  test('VitFormat.usd delegates to formatUsd', () {
    expect(VitFormat.usd(1234.5), r'$1,234.50');
    expect(VitFormat.usd(0), r'$0.00');
  });
}
