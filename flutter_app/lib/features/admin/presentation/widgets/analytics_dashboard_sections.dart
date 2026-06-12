part of '../pages/analytics_dashboard.dart';

class _Controls extends StatelessWidget {
  const _Controls({
    required this.ranges,
    required this.activeRange,
    required this.onRangeChanged,
  });

  final List<AdminAnalyticsRangeOption> ranges;
  final AdminAnalyticsRange activeRange;
  final ValueChanged<AdminAnalyticsRange> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x1),
              child: Row(
                children: [
                  for (final range in ranges)
                    Expanded(
                      child: _RangeButton(
                        option: range,
                        active: range.range == activeRange,
                        onTap: () => onRangeChanged(range.range),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x5),
        VitIconButton(
          key: AnalyticsDashboard.refreshKey,
          icon: Icons.refresh_rounded,
          tooltip: 'Refresh analytics',
          onPressed: () {},
          size: VitIconButtonSize.md,
        ),
        const SizedBox(width: AppSpacing.x3),
        VitIconButton(
          key: AnalyticsDashboard.exportKey,
          icon: Icons.download_rounded,
          tooltip: 'Export analytics',
          onPressed: () {},
          size: VitIconButtonSize.md,
        ),
      ],
    );
  }
}

class _RangeButton extends StatelessWidget {
  const _RangeButton({
    required this.option,
    required this.active,
    required this.onTap,
  });

  final AdminAnalyticsRangeOption option;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: '${option.label} range',
      child: GestureDetector(
        key: AnalyticsDashboard.rangeKey(option.range),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: active ? AppColors.surface3 : AppColors.transparent,
            borderRadius: AppRadii.mdRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x2,
              vertical: AppSpacing.x2,
            ),
            child: Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.text1 : AppColors.text3,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyMetrics extends StatelessWidget {
  const _KeyMetrics({required this.snapshot});

  final AdminAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.monitor_heart_rounded,
            title: 'Tổng sự kiện',
            value: '${snapshot.totalEvents}',
            caption: snapshot.eventsPerDayLabel,
            delta: '0.0%',
            timeframe: 'Selected range',
            tint: AppColors.accent15,
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _MetricCard(
            icon: Icons.groups_2_outlined,
            title: 'Người dùng',
            value: '${snapshot.uniqueUsers}',
            caption: 'Unique users',
            delta: '0.0%',
            timeframe: 'Selected range',
            tint: AppColors.primary15,
            accent: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.caption,
    required this.delta,
    required this.timeframe,
    required this.tint,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String value;
  final String caption;
  final String delta;
  final String timeframe;
  final Color tint;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Admin analytics metric $title: $value. $caption. $delta $timeframe',
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppSpacing.adminBox40,
                  height: AppSpacing.adminBox40,
                  decoration: BoxDecoration(
                    color: tint,
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Icon(
                    icon,
                    color: accent,
                    size: AppSpacing.adminIconXl,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: AppSpacing.adminFontMd,
                        ),
                      ),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: AppSpacing.adminFont3xl,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: AppSpacing.adminFontMd,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x1,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                VitStatusPill(
                  label: delta,
                  status: delta.startsWith('-')
                      ? VitStatusPillStatus.error
                      : VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
                Text(
                  timeframe,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: AppSpacing.adminFontSm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EventVolumeCard extends StatelessWidget {
  const _EventVolumeCard({required this.stats});

  final List<AdminDailyStat> stats;

  @override
  Widget build(BuildContext context) {
    final hasEvents = stats.any((stat) => stat.events > 0 || stat.users > 0);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Khối lượng sự kiện',
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.adminAnalyticsSparklineHeight,
            child: Semantics(
              label: hasEvents
                  ? 'Event volume chart for ${stats.length} days'
                  : 'Event volume chart has no events in this range',
              child: CustomPaint(
                painter: _EventVolumePainter(stats: stats),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          if (!hasEvents) ...[
            const SizedBox(height: AppSpacing.x3),
            const AdminInlineEmptyState(
              icon: Icons.bar_chart_outlined,
              title: 'No event volume',
              message: 'The selected range has no tracked admin events yet.',
            ),
          ],
        ],
      ),
    );
  }
}

class _TopEventsCard extends StatelessWidget {
  const _TopEventsCard({required this.events});

  final List<AdminEventSummary> events;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.trending_up_rounded,
            title: 'Top sự kiện',
          ),
          if (events.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x4),
            for (final event in events)
              Text(
                event.eventName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text1),
              ),
          ] else ...[
            const SizedBox(height: AppSpacing.x4),
            const AdminInlineEmptyState(
              icon: Icons.trending_up_rounded,
              title: 'No top events',
              message: 'Events will rank here after tracking data arrives.',
            ),
          ],
        ],
      ),
    );
  }
}
