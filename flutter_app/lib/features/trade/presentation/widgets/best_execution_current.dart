part of '../pages/best_execution_reports_page.dart';

class _CurrentReport extends StatelessWidget {
  const _CurrentReport({
    required this.venues,
    required this.onAnalysis,
    required this.onExport,
    required this.onPublish,
  });

  final List<TradeExecutionVenue> venues;
  final VoidCallback onAnalysis;
  final VoidCallback onExport;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: 12,
      children: [
        VitPageSection(
          label: 'Top 5 Execution Venues (By Volume)',
          customGap: 12,
          children: [for (final venue in venues) _VenueCard(venue: venue)],
        ),
        _AnalysisButton(onTap: onAnalysis),
        VitPageSection(
          label: 'Report Actions',
          children: [_ReportActions(onExport: onExport, onPublish: onPublish)],
        ),
      ],
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({required this.venue});

  final TradeExecutionVenue venue;

  @override
  Widget build(BuildContext context) {
    final isWinner = venue.rank == 1;
    return VitCard(
      key: BestExecutionReportsPage.venueKey(venue.rank),
      padding: const EdgeInsets.all(16),
      borderColor: _bestBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitCard(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                variant: VitCardVariant.inner,
                borderColor: isWinner ? _bestAmber : AppColors.transparent,
                child: Text(
                  '#${venue.rank}',
                  style: AppTextStyles.body.copyWith(
                    color: isWinner ? _bestAmber : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            venue.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        if (isWinner) ...[
                          const SizedBox(width: 9),
                          const Icon(
                            Icons.workspace_premium_outlined,
                            color: _bestAmber,
                            size: 15,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      '${_formatInt(venue.volume)} orders • ${_formatUsd(venue.value)} value',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    venue.score.toStringAsFixed(1),
                    style: AppTextStyles.body.copyWith(
                      color: _bestGreen,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Quality',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _VenueMetric(
                  label: 'Avg Price',
                  value: '\$${_formatInt(venue.avgPrice)}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _VenueMetric(
                  label: 'Cost',
                  value:
                      '${venue.avgCost.toStringAsFixed(venue.avgCost == .10 ? 1 : 2)}%',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _VenueMetric(
                  label: 'Speed',
                  value:
                      '${venue.avgSpeed.toStringAsFixed(venue.avgSpeed == .3 || venue.avgSpeed == .4 || venue.avgSpeed == .5 ? 1 : 2)}s',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _VenueMetric(
                  label: 'Fill Rate',
                  value: '${venue.fillRate.toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Composite Quality Score',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${venue.score.toStringAsFixed(1)}/100',
                style: AppTextStyles.micro.copyWith(
                  color: _bestGreen,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: SizedBox(
              height: 6,
              child: Stack(
                children: [
                  const ColoredBox(color: _bestPanel2),
                  FractionallySizedBox(
                    widthFactor: (venue.score / 100).clamp(0, 1).toDouble(),
                    child: const ColoredBox(color: _bestGreen),
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

class _VenueMetric extends StatelessWidget {
  const _VenueMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      height: 48,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
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

class _AnalysisButton extends StatelessWidget {
  const _AnalysisButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: BestExecutionReportsPage.analysisKey,
      onPressed: onTap,
      variant: VitCtaButtonVariant.secondary,
      height: 44,
      leading: const Icon(Icons.bar_chart_rounded, color: AppColors.text1),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.text1),
      child: Text(
        'View Detailed Analysis',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}
