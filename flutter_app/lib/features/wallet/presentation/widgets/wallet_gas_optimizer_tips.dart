part of '../pages/wallet_gas_optimizer_page.dart';

class _TipsTab extends StatelessWidget {
  const _TipsTab({required this.snapshot});

  final WalletGasOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(label: 'Gas Optimization Tips'),
        const SizedBox(height: 10),
        for (var i = 0; i < snapshot.tips.length; i++) ...[
          _TipCard(tip: snapshot.tips[i]),
          if (i != snapshot.tips.length - 1) const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
        const _QuickActionsCard(),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final WalletGasTip tip;

  @override
  Widget build(BuildContext context) {
    final color = switch (tip.difficulty) {
      'easy' => _gasGreen,
      'medium' => _gasAmber,
      'advanced' => _gasRed,
      _ => AppColors.text3,
    };
    return VitCard(
      padding: const EdgeInsets.all(16),
      borderColor: _gasBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _gasAmber.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: _gasAmber,
              size: 17,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tip.title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                    ),
                    _SmallBadge(
                      label: tip.difficulty.toUpperCase(),
                      color: color,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  tip.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _CategoryPill(label: tip.category),
                    const Spacer(),
                    const Icon(
                      Icons.attach_money_rounded,
                      color: _gasGreen,
                      size: 13,
                    ),
                    Text(
                      tip.potentialSaving,
                      style: AppTextStyles.caption.copyWith(
                        color: _gasGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.overlaySubtle,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.textSoftBlue,
          fontSize: 10,
          height: 1,
        ),
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      borderColor: _gasBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          for (final label in const [
            'Set Gas Price Alert',
            'Schedule Transaction',
            'View L2 Options',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: _gasBackground,
                  borderRadius: AppRadii.mdRadius,
                  border: Border.all(color: _gasBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bolt_outlined,
                      color: AppColors.text3,
                      size: 16,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.text3,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GasLineChartPainter extends CustomPainter {
  const _GasLineChartPainter({required this.points});

  final List<WalletGasHistoryPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final chart = Rect.fromLTWH(10, 4, size.width - 20, size.height - 24);
    _drawGasLine(canvas, chart, points.map((p) => p.slow).toList(), _gasGreen);
    _drawGasLine(
      canvas,
      chart,
      points.map((p) => p.standard).toList(),
      _gasAmber,
    );
    _drawGasLine(canvas, chart, points.map((p) => p.fast).toList(), _gasRed);
  }

  void _drawGasLine(Canvas canvas, Rect chart, List<int> values, Color color) {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(1, maxValue - minValue);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = chart.left + chart.width * i / (values.length - 1);
      final y = chart.bottom - ((values[i] - minValue) / range) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GasLineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _NetworkBarChartPainter extends CustomPainter {
  const _NetworkBarChartPainter({required this.points});

  final List<WalletNetworkActivityPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxTx = points.map((point) => point.txCount).reduce(math.max);
    final barWidth = size.width / (points.length * 2.2);
    final gap = barWidth * 1.2;
    final paint = Paint()..color = _gasPrimary;
    for (var i = 0; i < points.length; i++) {
      final barHeight = (points[i].txCount / maxTx) * (size.height - 10);
      final left = i * (barWidth + gap) + 12;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, size.height - barHeight, barWidth, barHeight),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NetworkBarChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

String _withCommas(String value) {
  final buffer = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    final remaining = value.length - i;
    buffer.write(value[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
