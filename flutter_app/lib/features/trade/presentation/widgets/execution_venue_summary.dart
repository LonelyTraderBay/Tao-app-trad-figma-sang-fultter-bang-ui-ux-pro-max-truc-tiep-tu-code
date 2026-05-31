part of '../pages/execution_venue_analysis_page.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final TradeExecutionVenueAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Total Venues',
            value: summary.totalVenues.toString(),
            subtitle: 'Active integrations',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Avg Total Cost',
            value: '${summary.avgTotalCost.toStringAsFixed(2)} bps',
            subtitle: '-5% vs last quarter',
            subtitleColor: _venueGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Avg Fill Time',
            value: '${summary.avgFillTime.toStringAsFixed(2)}s',
            subtitle: '-12% vs last quarter',
            subtitleColor: _venueGreen,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.subtitle,
    this.subtitleColor = AppColors.text3,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 12),
      decoration: BoxDecoration(
        color: _venuePanel,
        border: Border.all(color: _venueBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 17),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontSize: 20,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: subtitleColor,
              fontSize: 9,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SortSelector extends StatelessWidget {
  const _SortSelector({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [
      ('volume', 'Volume'),
      ('cost', 'Lowest\nCost'),
      ('speed', 'Fastest'),
      ('fill-rate', 'Best Fill\nRate'),
    ];
    return Row(
      children: [
        const Icon(Icons.filter_alt_outlined, color: AppColors.text3, size: 17),
        const SizedBox(width: 8),
        SizedBox(
          width: 42,
          child: Text(
            'Sort\nby:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.15,
            ),
          ),
        ),
        const SizedBox(width: 6),
        for (final option in options) ...[
          Expanded(
            child: InkWell(
              key: ExecutionVenueAnalysisPage.sortKey(option.$1),
              onTap: () => onChanged(option.$1),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: activeId == option.$1 ? _venuePrimary : _venuePanel2,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  option.$2,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: activeId == option.$1
                        ? AppColors.onAccent
                        : AppColors.text2,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
              ),
            ),
          ),
          if (option != options.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('comparison', 'Comparison'),
      ('costs', 'Costs'),
      ('speed', 'Speed'),
      ('trends', 'Trends'),
    ];
    return Container(
      height: 52,
      color: _venuePanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: ExecutionVenueAnalysisPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _venuePrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 72 : 0,
                      height: 2,
                      color: _venuePrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
