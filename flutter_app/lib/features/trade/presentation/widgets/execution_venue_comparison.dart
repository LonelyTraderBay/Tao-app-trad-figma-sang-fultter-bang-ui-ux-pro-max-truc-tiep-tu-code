part of '../pages/execution_venue_analysis_page.dart';

class _ComparisonTab extends StatelessWidget {
  const _ComparisonTab({required this.venues});

  final List<TradeExecutionVenueAnalysisMetric> venues;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Venue Comparison'),
        const SizedBox(height: AppSpacing.executionVenueSummaryGap),
        for (var index = 0; index < venues.length; index++) ...[
          _VenueCard(venue: venues[index], rank: index + 1),
          if (index != venues.length - 1)
            const SizedBox(height: AppSpacing.executionVenueSummaryGap),
        ],
      ],
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({required this.venue, required this.rank});

  final TradeExecutionVenueAnalysisMetric venue;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final isWinner = rank == 1;
    return VitCard(
      key: ExecutionVenueAnalysisPage.venueKey(venue.venue),
      padding: AppSpacing.executionVenueCardPadding,
      borderColor: _venueBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            children: [
              VitCard(
                width: AppSpacing.buttonCompact,
                height: AppSpacing.buttonCompact,
                alignment: Alignment.center,
                variant: VitCardVariant.inner,
                borderColor: isWinner
                    ? _venueAmber.withValues(alpha: .28)
                    : AppColors.transparent,
                child: Text(
                  '#$rank',
                  style: AppTextStyles.caption.copyWith(
                    color: isWinner ? _venueAmber : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.executionVenueLineHeightTight,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.executionVenueRankGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.venue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.executionVenueLineHeightTight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      '${_formatInt(venue.volume)} orders • ${_formatUsd(venue.value)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: AppSpacing.executionVenueLineHeightTight,
                      ),
                    ),
                  ],
                ),
              ),
              if (isWinner)
                const Icon(
                  Icons.workspace_premium_outlined,
                  color: _venueAmber,
                  size: AppSpacing.executionVenueWinnerIcon,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.executionVenuePanelPaddingValue),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Total Cost',
                  value: '${venue.totalCost.toStringAsFixed(2)} bps',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricBox(
                  label: 'Fill Time',
                  value: '${_formatSpeed(venue.avgFillTime)}s',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricBox(
                  label: 'Fill Rate',
                  value: '${venue.fillRate.toStringAsFixed(1)}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricBox(
                  label: 'Liquidity',
                  value: '\$${venue.liquidity}M',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      height: AppSpacing.executionVenueMetricBoxHeight,
      padding: AppSpacing.executionVenueMetricBoxPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.executionVenueLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.executionVenueMetricGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.executionVenueLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}

class _CostsTab extends StatelessWidget {
  const _CostsTab({required this.venues});

  final List<TradeExecutionVenueAnalysisMetric> venues;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Cost Breakdown'),
        const SizedBox(height: AppSpacing.executionVenueSummaryGap),
        for (final venue in venues) ...[
          _CostCard(venue: venue),
          if (venue != venues.last)
            const SizedBox(height: AppSpacing.executionVenueSummaryGap),
        ],
      ],
    );
  }
}

class _CostCard extends StatelessWidget {
  const _CostCard({required this.venue});

  final TradeExecutionVenueAnalysisMetric venue;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.executionVenuePanelPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            venue.venue,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.executionVenueSummaryGap),
          _ProgressMetric(
            label: 'Trading Fee',
            value: '${venue.avgFee.toStringAsFixed(2)}%',
            factor: venue.avgFee / .12,
            color: _venuePrimary,
          ),
          const SizedBox(height: AppSpacing.executionVenueProgressGap),
          _ProgressMetric(
            label: 'Spread Cost',
            value: '${venue.avgSpread.toStringAsFixed(1)} bps',
            factor: venue.avgSpread / 3.2,
            color: _venueGreen,
          ),
          const SizedBox(height: AppSpacing.executionVenueProgressGap),
          _ProgressMetric(
            label: 'Market Impact',
            value: '${venue.marketImpact.toStringAsFixed(1)} bps',
            factor: venue.marketImpact / 1.6,
            color: _venueAmber,
          ),
          const SizedBox(height: AppSpacing.executionVenueSummaryGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: _venueBorder,
          ),
          const SizedBox(height: AppSpacing.executionVenueSummaryGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Cost',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${venue.totalCost.toStringAsFixed(2)} bps',
                style: AppTextStyles.caption.copyWith(
                  color: _venuePrimary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
