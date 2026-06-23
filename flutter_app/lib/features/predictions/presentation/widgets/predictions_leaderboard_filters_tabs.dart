part of '../pages/predictions_leaderboard_page.dart';

class _TimeFilters extends StatelessWidget {
  const _TimeFilters({required this.active, required this.onSelected});

  final PredictionLeaderboardTimeFilter active;
  final ValueChanged<PredictionLeaderboardTimeFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final filters = [
      (PredictionLeaderboardTimeFilter.today, 'Today'),
      (PredictionLeaderboardTimeFilter.weekly, 'Weekly'),
      (PredictionLeaderboardTimeFilter.monthly, 'Monthly'),
      (PredictionLeaderboardTimeFilter.allTime, 'All Time'),
    ];

    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.lgRadius,
      child: SizedBox(
        height: _boardControlExtent,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(_boardTinySpace),
          child: Row(
            children: [
              for (final item in filters)
                Expanded(
                  child: _TimeFilterButton(
                    key: _timeFilterKey(item.$1),
                    label: item.$2,
                    active: active == item.$1,
                    onTap: () => onSelected(item.$1),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeFilterButton extends StatelessWidget {
  const _TimeFilterButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: _predictionPrimary,
      fullWidth: true,
      height: _boardControlExtent - (_boardTinySpace * 2),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: _boardTinySpace,
      ),
    );
  }
}

class _MetricTabs extends StatelessWidget {
  const _MetricTabs({
    required this.active,
    required this.onSelected,
    required this.onInfoTap,
  });

  final PredictionLeaderboardMetric active;
  final ValueChanged<PredictionLeaderboardMetric> onSelected;
  final VoidCallback onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetricTab(
          key: PredictionsLeaderboardPage.pnlMetricKey,
          label: 'Profit/Loss',
          icon: Icons.trending_up_rounded,
          active: active == PredictionLeaderboardMetric.pnl,
          onTap: () => onSelected(PredictionLeaderboardMetric.pnl),
          trailing: VitIconButton(
            key: PredictionsLeaderboardPage.infoKey,
            icon: Icons.help_outline_rounded,
            tooltip: 'Leaderboard metric info',
            onPressed: onInfoTap,
            variant: VitIconButtonVariant.transparent,
            size: VitIconButtonSize.sm,
          ),
        ),
        const SizedBox(width: _boardSpace),
        _MetricTab(
          key: PredictionsLeaderboardPage.volumeMetricKey,
          label: 'Volume',
          icon: Icons.bar_chart_rounded,
          active: active == PredictionLeaderboardMetric.volume,
          onTap: () => onSelected(PredictionLeaderboardMetric.volume),
        ),
      ],
    );
  }
}

class _MetricTab extends StatelessWidget {
  const _MetricTab({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final foreground = active ? _predictionPrimary : AppColors.text3;

    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      height: _boardControlExtent,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x3),
      borderColor: active
          ? _predictionPrimary.withValues(alpha: .38)
          : AppColors.transparent,
      background: active
          ? ColoredBox(color: _predictionPrimary.withValues(alpha: .14))
          : null,
      clip: active,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: AppSpacing.x3),
          const SizedBox(width: _boardTinySpace),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: foreground,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: _boardTinySpace),
            trailing!,
          ],
        ],
      ),
    );
  }
}
