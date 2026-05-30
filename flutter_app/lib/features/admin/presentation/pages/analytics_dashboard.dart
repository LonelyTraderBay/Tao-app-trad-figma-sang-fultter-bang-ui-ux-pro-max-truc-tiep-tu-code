import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/features/admin/presentation/widgets/admin_dashboard_state_content.dart';

class AnalyticsDashboard extends ConsumerStatefulWidget {
  const AnalyticsDashboard({super.key, this.shellRenderMode});

  static const contentKey = Key('sc181_analytics_content');
  static const refreshKey = Key('sc181_refresh');
  static const exportKey = Key('sc181_export');

  static Key rangeKey(AdminAnalyticsRange range) =>
      Key('sc181_range_${range.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends ConsumerState<AnalyticsDashboard> {
  AdminAnalyticsRange _activeRange = AdminAnalyticsRange.sevenDays;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminAnalyticsControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-181 AnalyticsDashboard',
      child: Column(
        children: [
          VitHeader(
            title: 'Analytics Dashboard',
            subtitle: 'DCA Event Analytics',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.admin),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: AnalyticsDashboard.contentKey,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: scrollBottom),
              child: VitPageContent(
                customGap: AppSpacing.x5,
                children: [
                  AdminDashboardStateContent(
                    status: controller.state.status,
                    title: 'Analytics dashboard',
                    message: controller.state.message,
                    children: [
                      _Controls(
                        ranges: snapshot.ranges,
                        activeRange: _activeRange,
                        onRangeChanged: (range) {
                          setState(() => _activeRange = range);
                        },
                      ),
                      _KeyMetrics(snapshot: snapshot),
                      _EventVolumeCard(stats: snapshot.dailyStats),
                      _TopEventsCard(events: snapshot.topEvents),
                      _DistributionCard(events: snapshot.topEvents),
                      _RecentEventsCard(events: snapshot.recentEvents),
                      _QueueSummaryCard(text: snapshot.queueSummary),
                    ],
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
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Icon(icon, color: accent, size: 20),
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
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 20,
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
              fontSize: 11,
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
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
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
            height: 180,
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
