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
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: funnels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AdminSpacingTokens.adminGridColumns,
            mainAxisExtent: AdminSpacingTokens.adminMetricTileExtent,
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
              child: VitCard(
                key: FunnelDashboard.selectorKey(funnel.id),
                onTap: () => onChanged(funnel.id),
                padding: AdminSpacingTokens.adminCardPadding,
                borderColor: selected
                    ? AppColors.accent
                    : AppColors.transparent,
                background: ColoredBox(
                  color: selected ? AppColors.surface : AppColors.surface2,
                ),
                clip: true,
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
                        height: AdminSpacingTokens.adminLineHeightShort,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      funnel.stepCountLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: AdminSpacingTokens.adminLineHeightShort,
                      ),
                    ),
                  ],
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
                        style: AppTextStyles.amountXs.copyWith(color: accent),
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
