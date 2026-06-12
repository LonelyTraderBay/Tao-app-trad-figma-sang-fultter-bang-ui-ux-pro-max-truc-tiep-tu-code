part of '../pages/admin_home.dart';

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
    return Semantics(
      label:
          'Admin home metric ${metric.label}: ${metric.value}. ${metric.deltaLabel} ${metric.timeframeLabel}',
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _metricIcon(metric.icon),
                  color: accent,
                  size: AppSpacing.adminIconSm,
                ),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.baseMedium.copyWith(
                fontSize: AppSpacing.adminFont2xl,
                fontWeight: AppTextStyles.bold,
                color: metric.label == 'Health'
                    ? AppColors.buy
                    : AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x1,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                VitStatusPill(
                  label: metric.deltaLabel,
                  status: metric.deltaLabel.startsWith('-')
                      ? VitStatusPillStatus.error
                      : VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
                Text(
                  metric.timeframeLabel,
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
                    size: AppSpacing.adminIconMd,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              size: AppSpacing.adminIconXs,
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
    return Semantics(
      button: true,
      label: isLive ? 'Pause live admin updates' : 'Resume live admin updates',
      child: DecoratedBox(
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
                fontSize: AppSpacing.adminFontMd,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
