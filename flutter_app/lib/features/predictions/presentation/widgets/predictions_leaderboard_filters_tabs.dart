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

    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
      ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.surface : AppColors.transparent,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.text1 : AppColors.text3,
            fontSize: 12,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
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
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(
                Icons.help_outline_rounded,
                color: AppColors.text3,
                size: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active
              ? _predictionPrimary.withValues(alpha: .14)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _predictionPrimary.withValues(alpha: .38)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? _predictionPrimary : AppColors.text3,
              size: 13,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? _predictionPrimary : AppColors.text3,
                fontSize: 12,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
