part of '../pages/admin_home.dart';

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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  dashboard.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            dashboard.stat,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
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
