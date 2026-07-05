part of 'dca_page.dart';

class _HistoryChartPainter extends CustomPainter {
  const _HistoryChartPainter({
    required this.values,
    required this.lineColor,
    required this.investedColor,
    required this.gridColor,
  });

  final List<DcaHistoryPoint> values;
  final Color lineColor;
  final Color investedColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final portfolioValues = values
        .map((point) => point.portfolioValueM)
        .toList();
    final investedValues = values.map((point) => point.investedM).toList();
    final maxValue = portfolioValues
        .followedBy(investedValues)
        .reduce((a, b) => a > b ? a : b);
    final minValue = investedValues.reduce((a, b) => a < b ? a : b);

    final portfolioPath = _buildLinePath(
      portfolioValues,
      size,
      minValue: minValue,
      maxValue: maxValue,
    );
    final investedPath = _buildLinePath(
      investedValues,
      size,
      minValue: minValue,
      maxValue: maxValue,
    );

    canvas.drawPath(
      investedPath,
      Paint()
        ..color = investedColor.withValues(alpha: .65)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      portfolioPath,
      Paint()
        ..color = lineColor
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _HistoryChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.investedColor != investedColor ||
        oldDelegate.gridColor != gridColor;
  }
}

Path _buildLinePath(
  List<double> values,
  Size size, {
  double? minValue,
  double? maxValue,
}) {
  final min = minValue ?? values.reduce((a, b) => a < b ? a : b);
  final max = maxValue ?? values.reduce((a, b) => a > b ? a : b);
  final range = (max - min).abs() < 0.01 ? 1 : max - min;
  final path = Path();
  for (var index = 0; index < values.length; index++) {
    final x = index / (values.length - 1) * size.width;
    final y = size.height - ((values[index] - min) / range * size.height);
    if (index == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  return path;
}

Color _toolAccentColor(DcaToolAccent accent) {
  return switch (accent) {
    DcaToolAccent.purple => AppColors.accent,
    DcaToolAccent.primary => AppModuleAccents.trade,
    DcaToolAccent.success => AppColors.buy,
    DcaToolAccent.warning => AppColors.warn,
  };
}

IconData _toolIcon(DcaToolIcon icon) {
  return switch (icon) {
    DcaToolIcon.target => Icons.track_changes_rounded,
    DcaToolIcon.activity => Icons.show_chart_rounded,
    DcaToolIcon.sliders => Icons.tune_rounded,
    DcaToolIcon.clock => Icons.schedule_rounded,
  };
}

String _frequencyLabel(DcaFrequency frequency) {
  return switch (frequency) {
    DcaFrequency.daily => 'Hàng ngày',
    DcaFrequency.weekly => 'Hàng tuần',
    DcaFrequency.monthly => 'Hàng tháng',
  };
}

String _statusLabel(DcaPlanStatus status) {
  return switch (status) {
    DcaPlanStatus.active => 'Đang chạy',
    DcaPlanStatus.paused => 'Tạm dừng',
    DcaPlanStatus.error => 'Lỗi',
  };
}

VitStatusPillStatus _statusPillStatus(DcaPlanStatus status) {
  return switch (status) {
    DcaPlanStatus.active => VitStatusPillStatus.success,
    DcaPlanStatus.paused => VitStatusPillStatus.warning,
    DcaPlanStatus.error => VitStatusPillStatus.error,
  };
}

String _formatFullVnd(int amount) {
  final raw = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

String _formatCompactVnd(int amount) {
  if (amount >= 1000000000) {
    return '${(amount / 1000000000).toStringAsFixed(2)}B';
  }
  if (amount >= 1000000) {
    return '${(amount / 1000000).toStringAsFixed(2)}M';
  }
  if (amount >= 1000) {
    return '${(amount / 1000).toStringAsFixed(0)}K';
  }
  return _formatFullVnd(amount);
}

String _formatPercent(double percent) {
  return percent.toStringAsFixed(1).replaceAll('.', ',');
}
