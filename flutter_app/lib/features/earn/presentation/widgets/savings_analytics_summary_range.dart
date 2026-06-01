part of '../pages/savings_analytics_page.dart';

class _SummaryHero extends StatelessWidget {
  const _SummaryHero({required this.summary});

  final SavingsAnalyticsSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAnalyticsPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _SummaryTile(
              label: 'Tổng tiết kiệm',
              value: _formatUsd(summary.totalInvested),
              color: AppColors.text1,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryTile(
              label: 'Tổng yield',
              value: '+${_formatUsd(summary.totalEarned)}',
              color: AppColors.buy,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryTile(
              label: 'APY BQ',
              value: '${summary.weightedApy.toStringAsFixed(2)}%',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeRangeSelector extends StatelessWidget {
  const _TimeRangeSelector({
    required this.ranges,
    required this.activeRange,
    required this.onChanged,
  });

  final List<String> ranges;
  final String activeRange;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final range in ranges) ...[
          Expanded(
            child: _RangeChip(
              range: range,
              selected: range == activeRange,
              onTap: () => onChanged(range),
            ),
          ),
          if (range != ranges.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.range,
    required this.selected,
    required this.onTap,
  });

  final String range;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        key: SavingsAnalyticsPage.rangeKey(range),
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadii.mdRadius,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
            child: Text(
              range,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: selected ? AppColors.primary : AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
