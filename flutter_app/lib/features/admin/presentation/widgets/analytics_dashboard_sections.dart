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
          child: VitSegmentedChoice<AdminAnalyticsRange>(
            selected: activeRange,
            onChanged: onRangeChanged,
            options: [
              for (final option in ranges)
                VitSegmentedChoiceOption(
                  key: AnalyticsDashboard.rangeKey(option.range),
                  value: option.range,
                  label: option.label,
                  accentColor: AppModuleAccents.admin,
                  semanticLabel: '${option.label} range',
                ),
            ],
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
        padding: AdminSpacingTokens.adminCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox.square(
                  dimension: AdminSpacingTokens.adminBox40,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: tint,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.inputRadius,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: accent,
                      size: AdminSpacingTokens.adminIconXl,
                    ),
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
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
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
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
      padding: AdminSpacingTokens.adminCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Khối lượng sự kiện',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: AdminSpacingTokens.adminAnalyticsSparklineHeight,
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
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
      padding: AdminSpacingTokens.adminCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.trending_up_rounded,
            title: 'Top sự kiện',
          ),
          if (events.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            for (final event in events)
              Text(
                event.eventName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text1),
              ),
          ] else ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
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
