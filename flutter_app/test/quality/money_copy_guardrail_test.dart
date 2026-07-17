import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Matches a raw `'\$${...toStringAsFixed(...)}'`-style inline money
/// interpolation — the exact shape that caused the DEBT-81 drift
/// (`$1234.50` vs `$1,234.50` for the same feature) — anywhere under
/// `lib/features/*/presentation/`.
final _rawMoneyInterpolationRe = RegExp(r'\\\$\$\{[^}]*toStringAsFixed\(');

int _rawMoneyInterpolationCount({required String root}) {
  final directory = Directory(root);
  if (!directory.existsSync()) return 0;

  var count = 0;
  for (final entity
      in directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final path = entity.path.replaceAll('\\', '/');
    if (!path.contains('/presentation/')) continue;
    for (final line in entity.readAsLinesSync()) {
      if (_rawMoneyInterpolationRe.hasMatch(line)) count += 1;
    }
  }
  return count;
}

void main() {
  test('presentation money-copy interpolation (raw \$ + toStringAsFixed) does '
      'not increase', () {
    // A-Plus roadmap DEBT-84 (2026-07-16). 176 instances of this pattern
    // already exist across lib/features/*/presentation/ (verified live),
    // spanning both plain 2-decimal money text and module-specific
    // K/M/B/T compact-magnitude formatters — most are not bugs today,
    // but every one of them is a place where a future edit can silently
    // drift from VitFormat's comma-grouping the way DEBT-81 did. This is
    // a ratchet on the total count (176 named entries would be
    // unmaintainable and would still miss the point — the goal is no
    // NEW raw money interpolation, not naming every existing one).
    // DEBT-82 migrates these to VitFormat/module formatters over time;
    // lower this number as that happens, do not raise it for a new
    // hand-rolled money string that could delegate instead.
    final count = _rawMoneyInterpolationCount(root: 'lib/features');
    expect(count, lessThanOrEqualTo(176));
  });
}
