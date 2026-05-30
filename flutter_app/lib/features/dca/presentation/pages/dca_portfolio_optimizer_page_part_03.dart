part of 'dca_portfolio_optimizer_page.dart';

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBubble(icon: icon, color: color),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: AppSpacing.x2,
              height: AppSpacing.x2,
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadii.inputRadius,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _FrontierChip extends StatelessWidget {
  const _FrontierChip({required this.point, required this.active});

  final DcaFrontierPoint point;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: active ? AppColors.accent10 : AppColors.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(
          color: active ? AppColors.accent30 : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            point.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: active ? AppColors.accent : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Text(
                '+${point.returnPercent.toStringAsFixed(0)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                ' · ',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                '${point.riskPercent.toStringAsFixed(0)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SimpleAllocationBar extends StatelessWidget {
  const _SimpleAllocationBar({required this.allocation});

  final DcaPortfolioAllocation allocation;

  @override
  Widget build(BuildContext context) {
    final accent = _assetColor(allocation.accent);
    return Row(
      children: [
        Container(
          width: AppSpacing.x7,
          height: AppSpacing.x7,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: .10),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Text(
            allocation.symbol,
            style: AppTextStyles.micro.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.inputRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: allocation.optimalPercent / 100,
              color: accent,
              backgroundColor: AppColors.surface2,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        SizedBox(
          width: AppSpacing.x6,
          child: Text(
            '${allocation.optimalPercent.toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.suggestion});

  final DcaPortfolioSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final positive =
        suggestion.type == DcaPortfolioSuggestionType.add ||
        suggestion.type == DcaPortfolioSuggestionType.increase;
    final color = positive ? AppColors.buy : AppColors.sell;
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBubble(
            icon: positive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color: color,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      suggestion.symbol,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      '${suggestion.currentPercent.toStringAsFixed(0)}% → ${suggestion.suggestedPercent.toStringAsFixed(0)}%',
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  suggestion.reason,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
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
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CorrelationCell extends StatelessWidget {
  const _CorrelationCell({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= .7
        ? AppColors.sell
        : value >= .4
        ? AppColors.warn
        : AppColors.buy;
    return Container(
      height: AppSpacing.x7,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: value == 1 ? .08 : .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        value.toStringAsFixed(2),
        style: AppTextStyles.micro.copyWith(
          color: value == 1 ? AppColors.text3 : color,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IconBubble(
            icon: Icons.warning_amber_rounded,
            color: AppColors.warn,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FrontierChartPainter extends CustomPainter {
  const _FrontierChartPainter(this.points);

  final List<DcaFrontierPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(
      AppSpacing.x6,
      AppSpacing.x2,
      size.width - AppSpacing.x6 - AppSpacing.x3,
      size.height - AppSpacing.x6,
    );
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .45)
      ..strokeWidth = 1;

    for (var i = 0; i <= 3; i++) {
      final y = chart.top + chart.height * i / 3;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      final x = chart.left + chart.width * i / 3;
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), gridPaint);
    }
    canvas.drawLine(
      Offset(chart.left, chart.bottom),
      Offset(chart.right, chart.bottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chart.left, chart.top),
      Offset(chart.left, chart.bottom),
      axisPaint,
    );

    for (final point in points) {
      final x = chart.left + chart.width * (point.riskPercent / 60);
      final y = chart.bottom - chart.height * (point.returnPercent / 60);
      final active = point.label == 'Optimal (Max Sharpe)';
      final paint = Paint()
        ..color = active ? AppColors.accent : AppColors.accent30;
      canvas.drawCircle(
        Offset(x, y),
        active ? AppSpacing.x3 : AppSpacing.x2,
        paint,
      );
      if (active) {
        canvas.drawCircle(
          Offset(x, y),
          AppSpacing.x4,
          Paint()
            ..color = AppColors.accent20
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }

    _paintChartLabel(
      canvas,
      'Rủi ro (%)',
      Offset(chart.center.dx - AppSpacing.x6, size.height - AppSpacing.x3),
    );
    canvas.save();
    canvas.translate(AppSpacing.x3, chart.center.dy + AppSpacing.x7);
    canvas.rotate(-math.pi / 2);
    _paintChartLabel(canvas, 'Lợi nhuận (%)', Offset.zero);
    canvas.restore();
  }

  void _paintChartLabel(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _FrontierChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
