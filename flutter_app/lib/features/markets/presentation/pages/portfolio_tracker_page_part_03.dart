part of 'portfolio_tracker_page.dart';

class _PnlBreakdown extends StatelessWidget {
  const _PnlBreakdown({required this.holdings, required this.hidden});

  final List<PortfolioHolding> holdings;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final sorted = [...holdings]..sort((a, b) => b.pnl.compareTo(a.pnl));
    final maxPnl = sorted.fold<double>(
      0,
      (value, holding) => math.max(value, holding.pnl.abs()),
    );
    return Column(
      children: [
        for (final holding in sorted) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                _TokenBadge(holding: holding, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            holding.symbol,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _mask(
                              '${holding.pnl >= 0 ? '+' : ''}${_formatUsd(holding.pnl)}',
                              hidden,
                            ),
                            style: AppTextStyles.caption.copyWith(
                              color: holding.pnl >= 0
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: SizedBox(
                          height: 4,
                          child: Stack(
                            children: [
                              Container(color: AppColors.surface2),
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: maxPnl == 0
                                    ? 0
                                    : holding.pnl.abs() / maxPnl,
                                child: Container(
                                  color: holding.pnl >= 0
                                      ? AppColors.buy
                                      : AppColors.sell,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (holding != sorted.last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _SummaryStats extends StatelessWidget {
  const _SummaryStats({required this.stats, required this.hidden});

  final PortfolioStats stats;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCard(
            padding: const EdgeInsets.all(12),
            child: _SummaryStat(
              label: 'Tổng lãi/lỗ',
              value: _mask(
                '${stats.totalPnl >= 0 ? '+' : ''}${_formatUsd(stats.totalPnl)}',
                hidden,
              ),
              color: stats.totalPnl >= 0 ? AppColors.buy : AppColors.sell,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: VitCard(
            padding: const EdgeInsets.all(12),
            child: _SummaryStat(
              label: 'ROI tổng',
              value: _formatSignedPercent(stats.totalPnlPct),
              color: stats.totalPnlPct >= 0 ? AppColors.buy : AppColors.sell,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TokenBadge extends StatelessWidget {
  const _TokenBadge({required this.holding, required this.size});

  final PortfolioHolding holding;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: holding.color.withValues(alpha: .14),
        shape: BoxShape.circle,
      ),
      child: Text(
        holding.symbol.substring(0, math.min(2, holding.symbol.length)),
        style: AppTextStyles.caption.copyWith(
          color: holding.color,
          fontWeight: AppTextStyles.bold,
          fontSize: size <= 28 ? 10 : 12,
        ),
      ),
    );
  }
}

class _AllocationDonutPainter extends CustomPainter {
  const _AllocationDonutPainter({required this.holdings});

  final List<PortfolioHolding> holdings;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(
      center: center,
      radius: size.shortestSide / 2 - 8,
    );
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.butt;

    for (final holding in holdings) {
      final sweep = (holding.allocation / 100) * math.pi * 2;
      paint.color = holding.color.withValues(alpha: .86);
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _AllocationDonutPainter oldDelegate) {
    return oldDelegate.holdings != holdings;
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = maxValue - minValue;
    final path = Path();
    for (var index = 0; index < values.length; index += 1) {
      final x = values.length == 1
          ? 0.0
          : index / (values.length - 1) * size.width;
      final normalized = range == 0 ? .5 : (values[index] - minValue) / range;
      final y = size.height - normalized * size.height;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

class _PerformancePainter extends CustomPainter {
  const _PerformancePainter({required this.points});

  final List<PortfolioPerformancePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final values = [for (final point in points) point.value];
    final minValue = values.reduce(math.min) * .995;
    final maxValue = values.reduce(math.max) * 1.005;
    final range = maxValue - minValue;
    const topPadding = 8.0;
    const bottomPadding = 24.0;
    final chartHeight = size.height - topPadding - bottomPadding;
    final linePath = Path();

    Offset pointAt(int index) {
      final x = index / (points.length - 1) * size.width;
      final normalized = range == 0 ? .5 : (values[index] - minValue) / range;
      final y = topPadding + (1 - normalized) * chartHeight;
      return Offset(x, y);
    }

    for (var index = 0; index < points.length; index += 1) {
      final point = pointAt(index);
      if (index == 0) {
        linePath.moveTo(point.dx, point.dy);
      } else {
        linePath.lineTo(point.dx, point.dy);
      }
    }

    final areaPath = Path.from(linePath)
      ..lineTo(size.width, topPadding + chartHeight)
      ..lineTo(0, topPadding + chartHeight)
      ..close();
    final areaPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.buy20, AppColors.buyTransparent],
      ).createShader(Offset.zero & size);
    canvas.drawPath(areaPath, areaPaint);

    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    final last = pointAt(points.length - 1);
    canvas
      ..drawCircle(last, 4, Paint()..color = AppColors.buy)
      ..drawCircle(last, 2, Paint()..color = AppColors.text1);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    for (final index in [0, points.length ~/ 2, points.length - 1]) {
      textPainter.text = TextSpan(
        text: points[index].date,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      final x = (index / (points.length - 1) * size.width).clamp(
        textPainter.width / 2,
        size.width - textPainter.width / 2,
      );
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PerformancePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

List<PortfolioHolding> _overviewHoldings(List<PortfolioHolding> holdings) {
  const order = ['btc', 'eth', 'usdt', 'sol', 'bnb', 'ada'];
  final sorted = [...holdings];
  sorted.sort((a, b) => order.indexOf(a.id).compareTo(order.indexOf(b.id)));
  return sorted;
}

String _mask(String value, bool hidden, {bool long = false}) {
  if (!hidden) return value;
  return long ? '••••••' : '••••';
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value, 2)}';
}

String _formatSignedPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatCompact(double value, {String prefix = ''}) {
  if (value >= 1000000000) {
    return '$prefix${(value / 1000000000).toStringAsFixed(1)}B';
  }
  if (value >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$prefix${value.toStringAsFixed(2)}';
}

String _formatPrice(double value) {
  if (value >= 1000) return _formatNumber(value, 2);
  if (value >= 1) return _formatNumber(value, 2);
  return _formatNumber(value, 4);
}

String _formatNumber(double value, int fractionDigits) {
  final sign = value < 0 ? '-' : '';
  final fixed = value.abs().toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < whole.length; index += 1) {
    if (index > 0 && (whole.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[index]);
  }
  if (fractionDigits == 0) return '$sign$buffer';
  return '$sign$buffer.${parts[1]}';
}
