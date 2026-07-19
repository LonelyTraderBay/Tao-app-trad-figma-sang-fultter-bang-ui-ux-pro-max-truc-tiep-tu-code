// Origin: 9d896e0b (2026-07-18) - feat(gd3-c): painter hoist + RepaintBoundary dau tien + predictions cap 8 — dong Cum C GD3
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// PERF-HN5 ratchet: every mount file listed here draws a heavy
/// `CustomPainter` (candle charts, PnL/win-loss charts, equity curves,
/// radar charts, donuts) and MUST wrap the `CustomPaint(` with a
/// `RepaintBoundary(` so sibling repaints don't force it to redraw.
///
/// Heuristic (deliberately simple, not a real widget-tree parse): a file is
/// considered compliant if it contains `RepaintBoundary(` at least once
/// whenever it contains `CustomPaint(`. This is a text-scan, so it can't
/// verify the RepaintBoundary is the *direct* ancestor of the CustomPaint —
/// it only ratchets "this file has heavy painters AND uses RepaintBoundary
/// somewhere", which is enough to catch someone deleting the wrap outright
/// or adding a brand-new unwrapped CustomPaint to one of these files.
const _wrappedHeavyPainterMountFiles = <String>[
  'lib/features/predictions/presentation/widgets/event/prediction_advanced_chart_overview.dart',
  'lib/features/trade_bots/presentation/widgets/backtest/bot_strategy_compare_metrics.dart',
  'lib/features/trade_bots/presentation/widgets/dashboard/bot_equity_curve_charts_cards.dart',
  'lib/features/trade_bots/presentation/widgets/dashboard/bot_performance_charts_strategy.dart',
  'lib/features/trade_bots/presentation/widgets/dashboard/bot_performance_metrics_summary.dart',
  'lib/features/trade_terminal/presentation/widgets/tools/advanced_chart_area_actions.dart',
];

void main() {
  test(
    '_wrappedHeavyPainterMountFiles list stays sorted (ratchet hygiene)',
    () {
      final sorted = [..._wrappedHeavyPainterMountFiles]..sort();
      expect(_wrappedHeavyPainterMountFiles, sorted);
    },
  );

  test('every pinned heavy-painter mount file exists', () {
    for (final path in _wrappedHeavyPainterMountFiles) {
      expect(
        File(path).existsSync(),
        isTrue,
        reason: '$path no longer exists — update the pinned list.',
      );
    }
  });

  test('pinned heavy-painter mount files wrap every CustomPaint( in a '
      'RepaintBoundary(', () {
    final offenders = <String>[];
    for (final path in _wrappedHeavyPainterMountFiles) {
      final content = File(path).readAsStringSync();
      final hasCustomPaint = content.contains('CustomPaint(');
      final hasRepaintBoundary = content.contains('RepaintBoundary(');
      if (hasCustomPaint && !hasRepaintBoundary) {
        offenders.add(path);
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'These pinned heavy-painter mount files contain CustomPaint( '
          'without any RepaintBoundary( — PERF-HN5 requires wrapping the '
          'painter\'s mount site: ${offenders.join(', ')}',
    );
  });
}
