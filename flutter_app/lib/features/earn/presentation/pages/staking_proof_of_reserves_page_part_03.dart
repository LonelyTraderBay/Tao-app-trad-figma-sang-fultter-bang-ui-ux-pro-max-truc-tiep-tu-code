part of 'staking_proof_of_reserves_page.dart';

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.color,
    this.alignEnd = false,
    this.suffix,
  });

  final String label;
  final String value;
  final Color? color;
  final bool alignEnd;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color ?? AppColors.text1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: AppSpacing.x1),
                Text(
                  suffix!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InnerMetric extends StatelessWidget {
  const _InnerMetric({
    required this.label,
    required this.value,
    this.valueColor,
    this.subtleBuy = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool subtleBuy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: subtleBuy ? AppColors.buy20 : null,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingProofOfReservesPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: AppSpacing.stakingProofInfoLineHeight,
        ),
      ),
    );
  }
}

class _ReserveProgressPainter extends CustomPainter {
  const _ReserveProgressPainter(this.ratio);

  final double ratio;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - AppSpacing.x3;
    final stroke = AppSpacing.x4;
    final track = Paint()
      ..color = AppColors.surface3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    final progress = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * math.min(ratio / 150, 1),
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _ReserveProgressPainter oldDelegate) {
    return oldDelegate.ratio != ratio;
  }
}

class _ReserveTrendPainter extends CustomPainter {
  const _ReserveTrendPainter(this.points);

  final List<StakingReserveHistoryPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const left = 16.0;
    const top = 14.0;
    const right = 12.0;
    const bottom = 16.0;
    final chart = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );
    final gridPaint = Paint()
      ..color = AppColors.primary20
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.text3
      ..strokeWidth = 1.2;
    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3;

    for (var i = 0; i <= 4; i++) {
      final y = chart.bottom - chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }
    for (var i = 0; i <= 4; i++) {
      final x = chart.left + chart.width * i / 4;
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), gridPaint);
    }
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + chart.width * i / (points.length - 1);
      final y = chart.bottom - chart.height * ((points[i].ratio - 100) / 4);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = AppColors.buy;
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + chart.width * i / (points.length - 1);
      final y = chart.bottom - chart.height * ((points[i].ratio - 100) / 4);
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ReserveTrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

String _tabLabel(_ReserveTab tab) {
  return switch (tab) {
    _ReserveTab.overview => 'Overview',
    _ReserveTab.assets => 'By Asset',
    _ReserveTab.verify => 'Verify',
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatAmount(double value) {
  final text = value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
  final parts = text.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (parts.length == 1) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}

String _shortHash(String value) {
  if (value.length <= 24) return value;
  return '${value.substring(0, 20)}...${value.substring(value.length - 10)}';
}
