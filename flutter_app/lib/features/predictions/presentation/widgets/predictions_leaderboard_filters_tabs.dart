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
    return Material(
      color: active ? AppColors.surface : AppColors.transparent,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.text1 : AppColors.text3,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
            ),
          ),
        ),
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
          trailing: InkWell(
            key: PredictionsLeaderboardPage.infoKey,
            onTap: onInfoTap,
            borderRadius: AppRadii.smRadius,
            child: const Padding(
              padding: EdgeInsetsDirectional.only(start: _boardTinySpace),
              child: Icon(
                Icons.help_outline_rounded,
                color: AppColors.text3,
                size: AppSpacing.x3,
              ),
            ),
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
    return Material(
      color: active
          ? _predictionPrimary.withValues(alpha: .14)
          : AppColors.surface2,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.mdRadius,
        side: BorderSide(
          color: active
              ? _predictionPrimary.withValues(alpha: .38)
              : AppColors.transparent,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: SizedBox(
          height: _boardControlExtent,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: active ? _predictionPrimary : AppColors.text3,
                  size: AppSpacing.x3,
                ),
                const SizedBox(width: _boardTinySpace),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _predictionPrimary : AppColors.text3,
                    fontWeight: active
                        ? AppTextStyles.bold
                        : AppTextStyles.normal,
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
