part of '../pages/advanced_chart_page.dart';

class _AdvancedTradeChartPainter extends CustomPainter {
  const _AdvancedTradeChartPainter({
    required this.candles,
    required this.indicators,
    required this.chartType,
  });

  final List<TradeCandle> candles;
  final List<TradeChartIndicator> indicators;
  final String chartType;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = _chartBlack;
    canvas.drawRect(Offset.zero & size, bg);

    if (candles.isEmpty) return;

    final chartCandles = _expandedCandles(candles);
    final showVolume = indicators.any(
      (indicator) => indicator.id == 'vol' && indicator.enabled,
    );
    final chartTop = 18.0;
    final chartBottom = showVolume ? size.height - 64 : size.height - 12;
    final chartHeight = chartBottom - chartTop;
    final chartWidth = size.width - 16;
    final left = 8.0;
    final right = left + chartWidth;
    final prices = [
      for (final candle in chartCandles) ...[candle.high, candle.low],
    ];
    final minPrice = prices.reduce(math.min);
    final maxPrice = prices.reduce(math.max);
    final pricePad = (maxPrice - minPrice) * .08;
    final low = minPrice - pricePad;
    final high = maxPrice + pricePad;
    final range = math.max(1, high - low);
    final step = chartWidth / chartCandles.length;

    double xFor(int index) => left + step * index + step / 2;
    double yFor(double value) =>
        chartTop + chartHeight - ((value - low) / range) * chartHeight;

    final grid = Paint()
      ..color = AppColors.onAccent.withValues(alpha: .055)
      ..strokeWidth = .7;
    for (var i = 0; i < 4; i++) {
      final y = chartTop + chartHeight * i / 3;
      canvas.drawLine(Offset(left, y), Offset(right, y), grid);
    }

    if (chartType == 'line' || chartType == 'area') {
      _drawLineOrArea(canvas, chartCandles, yFor, xFor, chartBottom);
    } else {
      _drawCandles(canvas, chartCandles, xFor, yFor, step);
    }

    _drawMovingAverages(canvas, chartCandles, xFor, yFor);

    if (showVolume) {
      _drawVolume(canvas, size, chartCandles, xFor, step);
    }
  }

  void _drawCandles(
    Canvas canvas,
    List<TradeCandle> source,
    double Function(int index) xFor,
    double Function(double value) yFor,
    double step,
  ) {
    final paint = Paint()..strokeWidth = 1;
    final bodyWidth = math.max(2.6, step * .48);

    for (var i = 0; i < source.length; i++) {
      final candle = source[i];
      final isUp = candle.close >= candle.open;
      final color = isUp ? AppColors.buy : AppColors.sell;
      final x = xFor(i);
      final highY = yFor(candle.high);
      final lowY = yFor(candle.low);
      final openY = yFor(candle.open);
      final closeY = yFor(candle.close);
      paint.color = color;
      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint);
      final top = math.min(openY, closeY);
      final height = math.max(2.2, (openY - closeY).abs());
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - bodyWidth / 2, top, bodyWidth, height),
          const Radius.circular(.8),
        ),
        paint..color = color.withValues(alpha: .88),
      );
    }
  }

  void _drawLineOrArea(
    Canvas canvas,
    List<TradeCandle> source,
    double Function(double value) yFor,
    double Function(int index) xFor,
    double chartBottom,
  ) {
    final path = Path();
    for (var i = 0; i < source.length; i++) {
      final offset = Offset(xFor(i), yFor(source[i].close));
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    if (chartType == 'area') {
      final area = Path.from(path)
        ..lineTo(xFor(source.length - 1), chartBottom)
        ..lineTo(xFor(0), chartBottom)
        ..close();
      canvas.drawPath(
        area,
        Paint()..color = _tradePrimary.withValues(alpha: .18),
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _tradePrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
  }

  void _drawMovingAverages(
    Canvas canvas,
    List<TradeCandle> source,
    double Function(int index) xFor,
    double Function(double value) yFor,
  ) {
    for (final indicator in indicators) {
      if (!indicator.enabled || indicator.period == null) continue;
      if (!indicator.id.startsWith('ma')) continue;
      final period = indicator.period!;
      final path = Path();
      var started = false;
      for (var i = 0; i < source.length; i++) {
        final start = math.max(0, i - period + 1);
        final slice = source.sublist(start, i + 1);
        final average =
            slice.fold<double>(0, (sum, candle) => sum + candle.close) /
            slice.length;
        final offset = Offset(xFor(i), yFor(average));
        if (!started) {
          path.moveTo(offset.dx, offset.dy);
          started = true;
        } else {
          path.lineTo(offset.dx, offset.dy);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = Color(indicator.colorHex)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.25,
      );
    }
  }

  void _drawVolume(
    Canvas canvas,
    Size size,
    List<TradeCandle> source,
    double Function(int index) xFor,
    double step,
  ) {
    final maxVolume = source.map((candle) => candle.volume).reduce(math.max);
    const baseY = 111.0;
    const maxH = 27.0;
    final paint = Paint();
    for (var i = 0; i < source.length; i++) {
      final candle = source[i];
      final isUp = candle.close >= candle.open;
      final height = math.max(4.0, candle.volume / maxVolume * maxH);
      paint.color = (isUp ? AppColors.buy : AppColors.sell).withValues(
        alpha: .55,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          xFor(i) - step * .28,
          baseY - height,
          math.max(3.0, step * .55),
          height,
        ),
        paint,
      );
    }

    final tp = TextPainter(
      text: TextSpan(
        text: 'VOL',
        style: AppTextStyles.chartLabelXs.copyWith(
          color: AppColors.sell,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(size.width - tp.width - 6, 96));
  }

  List<TradeCandle> _expandedCandles(List<TradeCandle> source) {
    if (source.length < 2) return source;
    final expanded = <TradeCandle>[];
    var previousClose = source.first.open;
    for (var i = 0; i < source.length - 1; i++) {
      final current = source[i];
      final next = source[i + 1];
      for (var step = 0; step < 3; step++) {
        final t = step / 3;
        final close =
            current.close +
            (next.close - current.close) * t +
            math.sin((i * 3 + step) * .9) * 26;
        final open = previousClose;
        final high = math.max(open, close) + 46 + (step % 2) * 15;
        final low = math.min(open, close) - 42 - ((i + step) % 2) * 13;
        final volume =
            current.volume +
            (next.volume - current.volume) * t +
            ((i + step) % 4) * 180;
        expanded.add(
          TradeCandle(
            time: current.time,
            open: open,
            high: high,
            low: low,
            close: close,
            volume: volume,
          ),
        );
        previousClose = close;
      }
    }
    expanded.add(source.last);
    return expanded;
  }

  @override
  bool shouldRepaint(covariant _AdvancedTradeChartPainter oldDelegate) {
    return oldDelegate.chartType != chartType ||
        oldDelegate.indicators != indicators ||
        oldDelegate.candles != candles;
  }
}

String _formatRawPrice(double value) => value.toStringAsFixed(2);

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatPrice(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '${buffer.toString()}.${parts.last}';
}
