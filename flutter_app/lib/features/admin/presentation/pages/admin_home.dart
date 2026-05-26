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
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';

class AdminHome extends ConsumerStatefulWidget {
  const AdminHome({super.key, this.shellRenderMode});

  static const contentKey = Key('sc180_admin_home_content');
  static const settingsKey = Key('sc180_admin_settings');
  static const pauseKey = Key('sc180_admin_pause_live');

  static Key dashboardKey(String id) => Key('sc180_admin_dashboard_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  bool _isLive = true;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(adminRepositoryProvider).getHome();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-180 AdminHome',
      child: Column(
        children: [
          VitHeader(
            title: 'Admin Dashboard',
            subtitle: 'DCA Analytics & Monitoring',
            trailing: _SettingsButton(
              onPressed: () => context.go(AppRoutePaths.adminSettings),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: AdminHome.contentKey,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: scrollBottom),
              child: VitPageContent(
                customGap: AppSpacing.x5,
                children: [
                  _MetricGrid(metrics: snapshot.quickStats),
                  _RealTimeMetricsSection(
                    snapshot: snapshot,
                    isLive: _isLive,
                    onToggleLive: () => setState(() => _isLive = !_isLive),
                  ),
                  _DashboardsSection(dashboards: snapshot.dashboards),
                  _FooterCard(snapshot: snapshot),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: AdminHome.settingsKey,
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.mdRadius,
          border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          tooltip: 'Admin Settings',
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.text2,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<AdminMetricTile> metrics;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < metrics.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.x4),
          Expanded(child: _MetricCard(metric: metrics[i])),
        ],
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final AdminMetricTile metric;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(metric.accent);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_metricIcon(metric.icon), color: accent, size: 14),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  metric.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            metric.value,
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 18,
              fontWeight: AppTextStyles.bold,
              color: metric.label == 'Health' ? AppColors.buy : AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _RealTimeMetricsSection extends StatelessWidget {
  const _RealTimeMetricsSection({
    required this.snapshot,
    required this.isLive,
    required this.onToggleLive,
  });

  final AdminHomeSnapshot snapshot;
  final bool isLive;
  final VoidCallback onToggleLive;

  @override
  Widget build(BuildContext context) {
    final metrics = snapshot.adminMetrics;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(
          icon: Icons.bolt_rounded,
          title: 'Real-Time Metrics',
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            const _LiveDot(),
            const SizedBox(width: AppSpacing.x2),
            Text(
              isLive ? 'LIVE' : 'PAUSED',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const Spacer(),
            _PauseButton(isLive: isLive, onPressed: onToggleLive),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _MetricGrid(metrics: snapshot.liveStats),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.offline_bolt_rounded,
                    color: AppColors.text1,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Live Event Stream',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Text(
                    metrics.liveEventWindowLabel,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x6),
              Text(
                'Không có sự kiện mới',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x3),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: AppColors.text3,
              size: 12,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Cập nhật lúc ${metrics.lastUpdatedTime}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppSpacing.x3,
      height: AppSpacing.x3,
      child: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.buy, shape: BoxShape.circle),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton({required this.isLive, required this.onPressed});

  final bool isLive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.inputRadius,
      ),
      child: GestureDetector(
        key: AdminHome.pauseKey,
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            isLive ? 'Tạm dừng' : 'Tiếp tục',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardsSection extends StatelessWidget {
  const _DashboardsSection({required this.dashboards});

  final List<AdminDashboardLink> dashboards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(
          icon: Icons.trending_up_rounded,
          title: 'Dashboards',
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final dashboard in dashboards) ...[
          _DashboardCard(dashboard: dashboard),
          if (dashboard != dashboards.last)
            const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.dashboard});

  final AdminDashboardLink dashboard;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(dashboard.accent);
    return VitCard(
      key: AdminHome.dashboardKey(dashboard.id),
      onTap: () => context.go(dashboard.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: AppSpacing.inputHeight,
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: _accentTint(dashboard.accent),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Icon(_metricIcon(dashboard.icon), color: accent, size: 24),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dashboard.title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  dashboard.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            dashboard.stat,
            style: AppTextStyles.caption.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _FooterCard extends StatelessWidget {
  const _FooterCard({required this.snapshot});

  final AdminHomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Text(
            'Admin Dashboard v1.0 • Phase 2 Sprint 3',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Last updated: ${snapshot.adminMetrics.footerUpdatedLabel}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.text1, size: 18),
        const SizedBox(width: AppSpacing.x2),
        Text(
          title,
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

Color _accentColor(AdminMetricAccent accent) {
  switch (accent) {
    case AdminMetricAccent.accent:
      return AppColors.accent;
    case AdminMetricAccent.primary:
      return AppColors.primary;
    case AdminMetricAccent.success:
      return AppColors.buy;
  }
}

Color _accentTint(AdminMetricAccent accent) {
  switch (accent) {
    case AdminMetricAccent.accent:
      return AppColors.accent15;
    case AdminMetricAccent.primary:
      return AppColors.primary15;
    case AdminMetricAccent.success:
      return AppColors.buy15;
  }
}

IconData _metricIcon(AdminDashboardIcon icon) {
  switch (icon) {
    case AdminDashboardIcon.analytics:
      return Icons.bar_chart_rounded;
    case AdminDashboardIcon.experiment:
      return Icons.science_outlined;
    case AdminDashboardIcon.funnel:
      return Icons.filter_alt_outlined;
  }
}
