part of '../pages/watchlist_page.dart';

class _EmptyWatchlist extends StatelessWidget {
  const _EmptyWatchlist({required this.searchActive, required this.onAddPair});

  final bool searchActive;
  final VoidCallback onAddPair;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: VitEmptyState(
        icon: Icons.star_border_rounded,
        title: searchActive
            ? 'Không tìm thấy cặp nào'
            : 'Chưa có cặp trong danh sách theo dõi',
        message: searchActive
            ? 'Thử tìm BTC, ETH hoặc SOL'
            : 'Thêm cặp giao dịch để theo dõi nhanh giá và ghi chú.',
        actionLabel: searchActive ? null : 'Thêm cặp giao dịch',
        onAction: searchActive ? null : onAddPair,
      ),
    );
  }
}

class _WatchlistItem {
  const _WatchlistItem({required this.entry, required this.pair});

  final MarketWatchlistEntry entry;
  final MarketPair pair;
}

class _WatchlistSparklinePainter extends CustomPainter {
  const _WatchlistSparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.width <= 0 || size.height <= 0) return;

    final firstValue = values.first == 0 ? 1.0 : values.first;
    final baseY = size.height * 0.26;
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final relative = ((values[i] - firstValue) / firstValue).clamp(
        -0.12,
        0.12,
      );
      final y = (baseY - relative * size.height * 0.72).clamp(
        4.0,
        size.height - 6,
      );
      points.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0.0)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _WatchlistSparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

MarketPair? _findPair(List<MarketPair> pairs, String id) {
  for (final pair in pairs) {
    if (pair.id == id) return pair;
  }
  return null;
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value)}';
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatNumber(double value) {
  final fractionDigits = value >= 100
      ? 2
      : value >= 1
      ? 2
      : 4;
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}
