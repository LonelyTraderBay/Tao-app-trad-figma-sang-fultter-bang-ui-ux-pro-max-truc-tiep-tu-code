part of 'market_data_analytics_page.dart';

class _FundingLinePainter extends CustomPainter {
  const _FundingLinePainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxValue = values.reduce(math.max);
    final minValue = values.reduce(math.min);
    final span = math.max(maxValue - minValue, .001);
    final zeroY = size.height * (maxValue / span).clamp(0, 1);
    final gridPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .18)
      ..strokeWidth = AppSpacing.dividerHairline;
    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), gridPaint);

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - ((values[i] - minValue) / span * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = _analyticsRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSpacing.hairlineStroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FundingLinePainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

String _formatMillions(double value) {
  return '\$${(value / 1000000).toStringAsFixed(2)}M';
}

String _formatCompactUsd(double value) {
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatMoney(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final buffer = StringBuffer();
  for (var i = 0; i < parts.first.length; i++) {
    final remaining = parts.first.length - i;
    buffer.write(parts.first[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
