part of '../pages/funnel_dashboard.dart';

class _FunnelSelector extends StatelessWidget {
  const _FunnelSelector({
    required this.funnels,
    required this.selectedFunnelId,
    required this.onChanged,
  });

  final List<AdminConversionFunnel> funnels;
  final String selectedFunnelId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn funnel',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x3),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: funnels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AppSpacing.adminGridColumns,
            mainAxisExtent: AppSpacing.adminMetricTileExtent,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
          ),
          itemBuilder: (context, index) {
            final funnel = funnels[index];
            final selected = funnel.id == selectedFunnelId;
            return Semantics(
              button: true,
              selected: selected,
              label: '${funnel.name} funnel selector',
              child: GestureDetector(
                key: FunnelDashboard.selectorKey(funnel.id),
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(funnel.id),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: selected ? AppColors.surface : AppColors.surface2,
                    borderRadius: AppRadii.inputRadius,
                    border: Border.all(
                      color: selected
                          ? AppColors.accent
                          : AppColors.transparent,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.x4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          funnel.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            height: AppSpacing.adminLineHeightShort,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          funnel.stepCountLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: AppSpacing.adminLineHeightShort,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.snapshot});

  final AdminFunnelsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.filter_alt_outlined,
            title: 'Phiên',
            value: '${snapshot.totalSessions}',
            caption: '${snapshot.completedSessions} hoàn thành',
            delta: '0.0%',
            timeframe: 'Selected funnel',
            tint: AppColors.accent15,
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _MetricCard(
            icon: Icons.check_circle_outline_rounded,
            title: 'Tỷ lệ hoàn thành',
            value: snapshot.completionRateLabel,
            caption: 'Trung bình ${snapshot.avgCompletionTimeLabel}',
            delta: '0.0%',
            timeframe: 'Selected funnel',
            tint: AppColors.buy15,
            accent: AppColors.buy,
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
      label: 'Admin funnel metric $title: $value. $caption. $delta $timeframe',
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
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.amountXs.copyWith(color: accent),
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
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
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
