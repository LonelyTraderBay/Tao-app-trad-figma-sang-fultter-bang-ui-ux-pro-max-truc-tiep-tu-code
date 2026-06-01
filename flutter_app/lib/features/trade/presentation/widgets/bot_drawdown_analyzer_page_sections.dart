part of '../pages/bot_drawdown_analyzer_page.dart';

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.summary});

  final TradeBotDrawdownSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                height: 109,
                icon: Icons.trending_down_rounded,
                iconColor: _drawdownRed,
                label: 'Max Drawdown',
                value: '${summary.maxDrawdownPct.toStringAsFixed(1)}%',
                valueColor: _drawdownRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                height: 109,
                icon: Icons.bar_chart_rounded,
                iconColor: _drawdownAmber,
                label: 'Avg Drawdown',
                value: '${summary.avgDrawdownPct.toStringAsFixed(1)}%',
                valueColor: _drawdownAmber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                height: 124,
                icon: Icons.schedule_rounded,
                iconColor: _drawdownPrimary,
                label: 'Drawdown Days',
                value: summary.drawdownDays.toString(),
                caption: 'of ${summary.totalDays} days',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                height: 124,
                icon: Icons.report_problem_outlined,
                iconColor: _drawdownGreen,
                label: 'DD Frequency',
                value: summary.frequency.toString(),
                caption: 'events',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.height,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.caption,
  });

  final double height;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: SizedBox(
        height: height - 32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 21),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: valueColor,
                fontSize: 20,
                fontWeight: AppTextStyles.bold,
                fontFamily: 'Roboto',
                fontFeatures: AppTextStyles.tabularFigures,
                height: 1,
              ),
            ),
            if (caption != null) ...[
              const SizedBox(height: 5),
              Text(
                caption!,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UnderwaterCard extends StatelessWidget {
  const _UnderwaterCard({required this.points});

  final List<TradeBotUnderwaterPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _UnderwaterPainter(points),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Below zero = in drawdown (underwater)',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  const _DurationCard({required this.buckets});

  final List<TradeBotDrawdownDurationBucket> buckets;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: SizedBox(
        height: 160,
        child: CustomPaint(
          painter: _DurationPainter(buckets),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _EventsList extends StatelessWidget {
  const _EventsList({required this.events});

  final List<TradeBotDrawdownEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final event in events) ...[
          _EventCard(event: event),
          if (event != events.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final TradeBotDrawdownEvent event;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event #${event.id}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1,
                ),
              ),
              if (event.severe) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _drawdownRed.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Severe',
                    style: AppTextStyles.micro.copyWith(
                      color: _drawdownRed,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                '${event.depthPct.toStringAsFixed(1)}%',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _drawdownRed,
                  fontSize: 16,
                  fontWeight: AppTextStyles.bold,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _EventStat(label: 'Start', value: event.startLabel),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _EventStat(label: 'Duration', value: event.duration),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _EventStat(
                  label: 'Recovery',
                  value: event.recovery,
                  valueColor: event.recovery == 'Ongoing'
                      ? _drawdownAmber
                      : _drawdownGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventStat extends StatelessWidget {
  const _EventStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      decoration: BoxDecoration(
        color: _drawdownPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: valueColor,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
