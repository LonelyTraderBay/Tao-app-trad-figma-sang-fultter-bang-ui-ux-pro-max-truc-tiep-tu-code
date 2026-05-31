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
        const SizedBox(height: 12),
        for (var index = 0; index < venues.length; index++) ...[
          _VenueCard(venue: venues[index], rank: index + 1),
          if (index != venues.length - 1) const SizedBox(height: 12),
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
    return Container(
      key: ExecutionVenueAnalysisPage.venueKey(venue.venue),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _venuePanel,
        border: Border.all(color: _venueBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isWinner
                      ? _venueAmber.withValues(alpha: .15)
                      : _venuePanel2,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Text(
                  '#$rank',
                  style: AppTextStyles.caption.copyWith(
                    color: isWinner ? _venueAmber : AppColors.text2,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 11),
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
                        fontSize: 14,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatInt(venue.volume)} orders • ${_formatUsd(venue.value)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              if (isWinner)
                const Icon(
                  Icons.workspace_premium_outlined,
                  color: _venueAmber,
                  size: 16,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Total Cost',
                  value: '${venue.totalCost.toStringAsFixed(2)} bps',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Fill Time',
                  value: '${_formatSpeed(venue.avgFillTime)}s',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Fill Rate',
                  value: '${venue.fillRate.toStringAsFixed(1)}%',
                ),
              ),
              const SizedBox(width: 8),
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
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
      decoration: BoxDecoration(
        color: _venuePanel2,
        borderRadius: AppRadii.mdRadius,
      ),
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
              fontSize: 9,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
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
        const SizedBox(height: 12),
        for (final venue in venues) ...[
          _CostCard(venue: venue),
          if (venue != venues.last) const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            venue.venue,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          _ProgressMetric(
            label: 'Trading Fee',
            value: '${venue.avgFee.toStringAsFixed(2)}%',
            factor: venue.avgFee / .12,
            color: _venuePrimary,
          ),
          const SizedBox(height: 10),
          _ProgressMetric(
            label: 'Spread Cost',
            value: '${venue.avgSpread.toStringAsFixed(1)} bps',
            factor: venue.avgSpread / 3.2,
            color: _venueGreen,
          ),
          const SizedBox(height: 10),
          _ProgressMetric(
            label: 'Market Impact',
            value: '${venue.marketImpact.toStringAsFixed(1)} bps',
            factor: venue.marketImpact / 1.6,
            color: _venueAmber,
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: _venueBorder),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Cost',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${venue.totalCost.toStringAsFixed(2)} bps',
                style: AppTextStyles.caption.copyWith(
                  color: _venuePrimary,
                  fontSize: 14,
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
