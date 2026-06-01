part of '../pages/analytics_dashboard.dart';

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.events});

  final List<AdminEventSummary> events;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.pie_chart_outline_rounded,
            title: 'Phân bổ sự kiện',
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 260,
            child: events.isEmpty
                ? const Center(
                    child: AdminInlineEmptyState(
                      icon: Icons.pie_chart_outline_rounded,
                      title: 'No distribution',
                      message: 'Distribution appears after events are grouped.',
                    ),
                  )
                : Semantics(
                    label: 'Event distribution summary',
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.x2),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Text(
                          '${event.eventName}: ${event.percentage.toStringAsFixed(1)}%',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RecentEventsCard extends StatelessWidget {
  const _RecentEventsCard({required this.events});

  final List<AdminRecentEvent> events;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.offline_bolt_rounded,
            title: 'Sự kiện gần đây',
          ),
          const SizedBox(height: AppSpacing.x6),
          if (events.isEmpty)
            const AdminInlineEmptyState(
              icon: Icons.monitor_heart_outlined,
              title: 'No recent events',
              message: 'The event stream is quiet for the selected period.',
            ),
          const SizedBox(height: AppSpacing.x5),
        ],
      ),
    );
  }
}

class _QueueSummaryCard extends StatelessWidget {
  const _QueueSummaryCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.text1, size: 18),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _EventVolumePainter extends CustomPainter {
  const _EventVolumePainter({required this.stats});

  final List<AdminDailyStat> stats;

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 34.0;
    const bottomPad = 24.0;
    const topPad = 6.0;
    const rightPad = 2.0;
    final chartWidth = math.max(1.0, size.width - leftPad - rightPad);
    final chartHeight = math.max(1.0, size.height - topPad - bottomPad);
    final chartLeft = leftPad;
    final chartTop = topPad;
    final chartBottom = topPad + chartHeight;

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var i = 0; i <= 4; i++) {
      final y = chartTop + chartHeight * i / 4;
      canvas.drawLine(Offset(chartLeft, y), Offset(size.width, y), gridPaint);
      _drawText(
        canvas,
        '${4 - i}',
        Offset(0, y - 8),
        color: AppColors.text3,
        fontSize: 11,
      );
    }

    final verticalLines = math.max(1, stats.length - 1);
    for (var i = 0; i < stats.length; i++) {
      final x = chartLeft + chartWidth * i / verticalLines;
      canvas.drawLine(Offset(x, chartTop), Offset(x, chartBottom), gridPaint);
      _drawText(
        canvas,
        stats[i].label,
        Offset(x - 22, chartBottom + 6),
        color: AppColors.text3,
        fontSize: 10,
      );
    }

    final baseline = Path()
      ..moveTo(chartLeft, chartBottom)
      ..lineTo(chartLeft + chartWidth, chartBottom);
    canvas.drawPath(baseline, linePaint);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset, {
    required Color color,
    required double fontSize,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          height: 1,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _EventVolumePainter oldDelegate) {
    return oldDelegate.stats != stats;
  }
}
