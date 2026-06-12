part of 'launchpad_gas_tracker_page.dart';

class _SelectablePill extends StatelessWidget {
  const _SelectablePill({
    super.key,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: active ? color.withValues(alpha: .14) : AppColors.surface2,
            border: Border.all(
              color: active
                  ? color.withValues(alpha: .34)
                  : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: active ? color : AppColors.text3,
                fontWeight: AppTextStyles.bold,
                fontSize: AppSpacing.launchpadFontMd,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChainBadge extends StatelessWidget {
  const _ChainBadge({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.launchpadBox32,
      height: AppSpacing.launchpadBox32,
      decoration: BoxDecoration(
        color: price.accent.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        price.chainIcon,
        style: AppTextStyles.micro.copyWith(
          color: price.accent,
          fontWeight: AppTextStyles.bold,
          fontSize: AppSpacing.launchpadFontSm,
        ),
      ),
    );
  }
}

class _TrendPill extends StatelessWidget {
  const _TrendPill({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    final color = _trendColor(price.trend);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _trendIcon(price.trend),
              color: color,
              size: AppSpacing.launchpadIconXxs,
            ),
            const SizedBox(width: AppSpacing.launchpadGapXs),
            Text(
              _formatChange(price.change24h),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: AppSpacing.launchpadFontXs,
                height: AppSpacing.launchpadLineHeightTight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendInline extends StatelessWidget {
  const _TrendInline({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    final color = _trendColor(price.trend);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _trendIcon(price.trend),
          color: color,
          size: AppSpacing.launchpadIconSm,
        ),
        const SizedBox(width: AppSpacing.x1 + AppSpacing.hairlineStroke),
        Text(
          _formatChange(price.change24h),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: AppSpacing.launchpadFontSm,
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(
        color: color,
        fontSize: AppSpacing.launchpadFontXxs,
      ),
    );
  }
}

class _CostText extends StatelessWidget {
  const _CostText(this.value, this.color);

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: AppTextStyles.micro.copyWith(
        color: color,
        fontFamily: 'monospace',
        fontWeight: AppTextStyles.medium,
        fontSize: AppSpacing.launchpadFontSm,
      ),
    );
  }
}

class _EmptyAlerts extends StatelessWidget {
  const _EmptyAlerts();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.text3,
            size: AppSpacing.launchpadIconHuge,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chua co canh bao nao',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Them canh bao de biet khi gas giam',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _GasChartPainter extends CustomPainter {
  const _GasChartPainter(this.price);

  final LaunchpadGasPriceDraft price;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(34, 12, size.width - 44, size.height - 28);
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = chart.top + chart.height * i / 4;
      _drawDashedLine(
        canvas,
        Offset(chart.left, y),
        Offset(chart.right, y),
        gridPaint,
      );
    }
    for (var i = 0; i <= 4; i++) {
      final x = chart.left + chart.width * i / 4;
      _drawDashedLine(
        canvas,
        Offset(x, chart.top),
        Offset(x, chart.bottom),
        gridPaint,
      );
    }

    final slow = _series(price.standard * .7, 25);
    final standard = _series(price.standard, 25);
    final fast = _series(price.standard * 1.4, 25);
    final maxValue = [
      ...slow,
      ...standard,
      ...fast,
      price.instant,
    ].reduce(math.max);

    _drawSeries(canvas, chart, slow, maxValue, AppColors.buy);
    _drawSeries(canvas, chart, standard, maxValue, AppColors.primary);
    _drawSeries(canvas, chart, fast, maxValue, AppColors.warn);

    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );
    for (final label in const ['32', '16', '8', '0']) {
      final index = const ['32', '16', '8', '0'].indexOf(label);
      labelPainter.text = TextSpan(
        text: label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: AppSpacing.launchpadFontXs,
        ),
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(0, chart.top + chart.height * index / 3 - 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GasChartPainter oldDelegate) {
    return oldDelegate.price.chain != price.chain;
  }
}

List<double> _series(double base, int count) {
  return [
    for (var i = 0; i < count; i++)
      math.max(
        .01,
        base *
            (1 +
                (math.sin(i * .48) + math.cos(i * .27)) * .16 +
                math.sin(i * .93) * .05),
      ),
  ];
}

void _drawSeries(
  Canvas canvas,
  Rect chart,
  List<double> values,
  double maxValue,
  Color color,
) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = chart.left + chart.width * i / (values.length - 1);
    final y = chart.bottom - chart.height * (values[i] / maxValue);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2,
  );
}

void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  const dash = 4.0;
  const gap = 5.0;
  final delta = end - start;
  final distance = delta.distance;
  final direction = delta / distance;
  var progress = 0.0;
  while (progress < distance) {
    final segmentStart = start + direction * progress;
    final segmentEnd = start + direction * math.min(progress + dash, distance);
    canvas.drawLine(segmentStart, segmentEnd, paint);
    progress += dash + gap;
  }
}

String _formatGasValue(double value) {
  if (value < 1) return value.toStringAsFixed(2);
  if (value == value.roundToDouble()) return value.round().toString();
  return value.toStringAsFixed(1);
}

String _formatChange(double value) {
  if (value == 0) return '0%';
  final prefix = value > 0 ? '+' : '';
  return '$prefix${value.toStringAsFixed(1)}%';
}

Color _trendColor(LaunchpadGasTrend trend) {
  return switch (trend) {
    LaunchpadGasTrend.up => AppColors.sell,
    LaunchpadGasTrend.down => AppColors.buy,
    LaunchpadGasTrend.stable => AppColors.text3,
  };
}

IconData _trendIcon(LaunchpadGasTrend trend) {
  return switch (trend) {
    LaunchpadGasTrend.up => Icons.trending_up_rounded,
    LaunchpadGasTrend.down => Icons.trending_down_rounded,
    LaunchpadGasTrend.stable => Icons.remove_rounded,
  };
}
