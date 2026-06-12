part of '../pages/prediction_event_detail_page.dart';

class _ChartSection extends StatelessWidget {
  const _ChartSection({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Price / Probability',
      accentColor: AppColors.buy,
      children: [
        VitCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ChartPeriodTabs(),
              const Padding(padding: EdgeInsets.only(top: 10)),
              SizedBox(
                height: 178,
                child: CustomPaint(
                  painter: _ProbabilityChartPainter(
                    values: snapshot.probabilityHistory,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 9)),
              Text(
                'Volume (24h)',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              SizedBox(
                height: 42,
                child: _VolumeBars(values: snapshot.volumeHistory),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartPeriodTabs extends StatelessWidget {
  const _ChartPeriodTabs();

  @override
  Widget build(BuildContext context) {
    const tabs = ['1H', '1D', '7D', '30D', 'All'];
    return Row(
      children: [
        for (var index = 0; index < tabs.length; index += 1) ...[
          Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tabs[index] == '30D'
                    ? _predictionPrimary.withValues(alpha: .14)
                    : AppColors.transparent,
                border: Border.all(
                  color: tabs[index] == '30D'
                      ? _predictionPrimary.withValues(alpha: .32)
                      : AppColors.transparent,
                ),
                borderRadius: AppRadii.smRadius,
              ),
              child: Text(
                tabs[index],
                style: AppTextStyles.micro.copyWith(
                  color: tabs[index] == '30D'
                      ? _predictionPrimary
                      : AppColors.text3,
                  fontWeight: tabs[index] == '30D'
                      ? AppTextStyles.bold
                      : AppTextStyles.normal,
                ),
              ),
            ),
          ),
          if (index != tabs.length - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

class _VolumeBars extends StatelessWidget {
  const _VolumeBars({required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce(math.max).toDouble();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final value in values)
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: math.max(.10, value / maxValue),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: _predictionPrimary.withValues(alpha: .30),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProbabilityChartPainter extends CustomPainter {
  const _ProbabilityChartPainter({required this.values});

  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .55)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i += 1) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (values.length < 2) return;

    final path = Path();
    for (var index = 0; index < values.length; index += 1) {
      final x = size.width * index / (values.length - 1);
      final y = size.height - (values[index] / 100) * size.height;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.buy.withValues(alpha: .30),
          AppColors.buy.withValues(alpha: .02),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ProbabilityChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
