import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/admin_repository.dart';

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
    final snapshot = ref.watch(adminRepositoryProvider).getAnalytics();
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
        _IconAction(
          key: AnalyticsDashboard.refreshKey,
          icon: Icons.refresh_rounded,
          onTap: () {},
        ),
        const SizedBox(width: AppSpacing.x3),
        _IconAction(
          key: AnalyticsDashboard.exportKey,
          icon: Icons.download_rounded,
          onTap: () {},
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
    return GestureDetector(
      key: AnalyticsDashboard.rangeKey(option.range),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active ? AppColors.surface3 : Colors.transparent,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            option.label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.text1 : AppColors.text3,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: AppSpacing.buttonCompact,
        height: AppSpacing.buttonCompact,
        child: Icon(icon, color: AppColors.text2, size: 20),
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
    required this.tint,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String value;
  final String caption;
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
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
            ),
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
            child: CustomPaint(
              painter: _EventVolumePainter(stats: stats),
              child: const SizedBox.expand(),
            ),
          ),
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
                style: AppTextStyles.caption.copyWith(color: AppColors.text1),
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
                ? const SizedBox.shrink()
                : const Center(child: Text('')),
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
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.monitor_heart_outlined,
                    color: AppColors.text3,
                    size: 34,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    'Chưa có sự kiện nào',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ),
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
